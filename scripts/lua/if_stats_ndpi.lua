--
-- (C) 2013-23 - ntop.org
--

local dirs = ntop.getDirs()
package.path = dirs.installdir .. "/scripts/lua/modules/?.lua;" .. package.path

require "lua_utils"
local graph_utils = require "graph_utils"

local ifid = _GET["ifid"]

local ifstats = {}
if ifid then
   ifstats = interface.getStats()
   interface.select(ifid)
end

local format = _GET["format"]
if(format == "json") then
   sendHTTPHeader('application/json')
   json_format = true
else
   sendHTTPContentTypeHeader('text/html')
   json_format = false
end

-- Add ARP to stats
if(ifstats.stats ~= nil) then
  local arp = { }

  arp["bytes.sent"] = 0
  arp["bytes.rcvd"] = ifstats.eth["ARP_bytes"]
  arp["packets.sent"] = 0
  arp["packets.rcvd"] = ifstats.eth["ARP_packets"]
  arp.breed = "Unrated"

  ifstats["ndpi"]["ARP"] = arp

  if(ifstats["ndpi"]["Unknown"] ~= nil) then
    ifstats["ndpi"]["Unknown"]["bytes.rcvd"] = ifstats["ndpi"]["Unknown"]["bytes.rcvd"] - ifstats.eth["ARP_bytes"]
    ifstats["ndpi"]["Unknown"]["packets.rcvd"] = ifstats["ndpi"]["Unknown"]["packets.rcvd"] - ifstats.eth["ARP_packets"]
  end
end

local total = 0
if table.len(ifstats) > 0 then
   total = ifstats.stats.bytes
end

local vals = {}

for k, v in pairs(ifstats["ndpi"] or {}) do
   -- io.write("->"..k.."\n")
   if v["bytes.rcvd"] > 0 or v["bytes.sent"] > 0 then
    vals[k] = k
   end
end

table.sort(vals)

if(json_format) then print('[\n') end

local num = 0
for _k in pairsByKeys(vals, asc) do
  k = vals[_k]

  if(not(json_format)) then
     print('<tr id="t_protocol_'..k..'">')
     print('<th style="width: 33%;">')
  else
     if(num > 0) then
	print(',\n')
     end
  end

  local proto_cache_key = "ntopng.cache.has_ndpi_" .. ifid.."_".. k
  local has_ndpi_proto = ntop.getCache(proto_cache_key)

  if has_ndpi_proto ~= "1" then
    if areInterfaceL7TimeseriesEnabled(ifid) then
      has_ndpi_proto = "1"
      ntop.setCache(proto_cache_key, "1", 300)
    end
  end

  if(has_ndpi_proto == "1") then
     if(not(json_format)) then
	print("<A HREF=\""..interface2detailhref(ifid, {page = "historical", ts_schema = "top:iface:ndpi", ts_query = "ifid:" .. ifid .. ",protocol:" .. k, zoom = '1d'}) .. "\">" .. k .." "..formatBreed(ifstats["ndpi"][k]["breed"]).."</A>")
     else
	print('{ "proto": "'..k..'", "breed": "'..ifstats["ndpi"][k]["breed"]..'", ')
     end
  else
     if(not(json_format)) then
	print(k.." "..formatBreed(ifstats["ndpi"][k]["breed"]))
     else
	print('{ "proto": "'..k..'", ')
     end
  end

  local t = ifstats["ndpi"][k]["bytes.sent"]+ifstats["ndpi"][k]["bytes.rcvd"]

  if(not(json_format)) then
     if(k ~= "ARP") then print(" <A class='btn btn-sm bt-info' HREF=\""..ntop.getHttpPrefix().."/lua/flows_stats.lua?application="..k.."\"><i class=\"fas fa-search-plus\"></i></A>") end
     print("</th><td class=\"text-end\" style=\"width: 20%;\">" ..bytesToSize(t).. "</td>")
     print("<td ><span style=\"width: 60%; float: left;\">")
     graph_utils.percentageBar(total, t, "") -- k
     -- print("</td>\n")
     print("</span><span style=\"width: 40%; margin-left: 15px;\" >" ..round((t * 100)/total, 1).. " %</span></td></tr>\n")
  else
     print('"bytes": '..tostring(t))

     if ifstats["ndpi"][k]["throughput"] then
	print(', "throughput_bps": '..tostring(ifstats["ndpi"][k]["throughput"]["bps"]))
     end

     print('}')
  end

  num = num + 1
end

if(json_format) then print('\n]\n') end
::exit::
