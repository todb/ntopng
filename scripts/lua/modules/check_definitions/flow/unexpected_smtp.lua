--
-- (C) 2019-22 - ntop.org
--

local checks = require("checks")
local alerts_api = require "alerts_api"
local alert_consts = require("alert_consts")
local flow_alert_keys = require "flow_alert_keys"

local UNEXPECTED_SCRIPTS_ENABLED_CACHE_KEY = "ntopng.cache.checks.unexpected_scripts_enabled"

-- #################################################################

local script = {
   -- Script category
   category = checks.check_categories.security,

   -- This module is disabled by default
   alert_id = flow_alert_keys.flow_alert_unexpected_smtp_server,

   default_enabled = false,

   -- Specify the default value whe clicking on the "Reset Default" button
   default_value = {
      items = {},
   },

   gui = {
      i18n_title        = "flow_checks.unexpected_smtp_title",
      i18n_description  = "flow_checks.unexpected_smtp_description",

      input_builder     = "items_list",
      item_list_type    = "server",
      input_title       = "flow_checks.allowed_servers_title",
      input_description = "flow_checks.allowed_server_names_description",
   }
}

-- #################################################################

function script.onEnable(hook, hook_config)
   -- Set a flag to indicate to the notifications system that an unexpected script
   -- has been enabled
   if isEmptyString(ntop.getCache(UNEXPECTED_SCRIPTS_ENABLED_CACHE_KEY)) then
      ntop.setCache(UNEXPECTED_SCRIPTS_ENABLED_CACHE_KEY, "1")
   end
end

-- #################################################################

return script
