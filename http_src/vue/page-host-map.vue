<!-- (C) 2022 - ntop.org     -->

<template>
<div class="row">
  <div class="col-12">
    <div class="card">
      <div class="card-body">
        <div class='align-items-center justify-content-end mb-3' style='height: 70vh;'>
          <div class="d-flex ms-auto flex-row-reverse">
            <label class="my-auto me-1"></label>
            <div class="m-1" v-for="(value, key, index) in available_filters">
              <template v-if="value.length > 0">
                <div style="min-width: 15rem;">
                  <label class="my-auto me-1">{{ _i18n('bubble_map.' + key) }}: </label>
                  <SelectSearch
                    v-model:selected_option="active_filter_list[key]"
                    :options="value"
                    @select_option="click_item">
                  </SelectSearch>
                </div>
              </template>
            </div>
          </div>
          <div :id="widget_name" style="height: 90%;">
            <Chart
              ref="bubble_chart"
              :id="widget_name"
              :chart_type="chart_type"
              :base_url_request="rest_url"
              :get_params_url_request="format_request"
              :get_custom_chart_options="get_f_get_custom_chart_options()"
              :register_on_status_change="false">
            </Chart>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</template>

<script setup>
import { ref, onMounted, onBeforeMount } from "vue";
import { default as Chart } from "./chart.vue";
import { default as SelectSearch } from "./select-search.vue";
import { ntopng_url_manager } from "../services/context/ntopng_globals_services";
import NtopUtils from "../utilities/ntop-utils";

const _i18n = (t) => i18n(t);
const props = defineProps({
  ifid: String,
  page_csrf: String,
  charts_options: Array,
  available_filters: Object,
})

/* By default use the first entry */
const currently_selected_chart = 0

const chart_type = ntopChartApex.typeChart.BUBBLE
const rest_url = `${http_prefix}/lua/rest/v2/charts/host/map.lua`
const widget_name = 'alerts-map';
const active_filter_list = {}
const bubble_chart = ref(null)

const format_request = function() {
  let params_string = ''
  const params = {
    bubble_mode: ntopng_url_manager.get_url_entry('bubble_mode'),
    ifid: ntopng_url_manager.get_url_entry('ifid'),
  }

  for (const [key, value] of Object.entries(params)) {
    params_string = `${params_string}&${key}=${value}`
  }

  /* Return a custom string, containing custom options */
  return params_string
}

const format_options = function(mode_id) {
  let options = {}

  props.charts_options.forEach((option_list) => {
    if(option_list.mode_id == mode_id)
      options = option_list;
  })

  /* Add the corract event functions */
  if(options && options.chart && options.chart.ntop_events) {
    options.chart.events = options.chart.events || {}
    for(const [event, fun] of Object.entries(options.chart.ntop_events)) {
      if(fun == undefined) 
        continue

      options.chart.events[event] = NtopUtils[fun] || NtopUtils.fnone
    }
  }

  /* Add the correct formatting function, given from the backend */
  if(options && options.xaxis && options.xaxis.labels && options.xaxis.labels.ntop_utils_formatter) {
    options.xaxis.labels.formatter = NtopUtils[options.xaxis.labels.ntop_utils_formatter] || NtopUtils.fnone
  }

  /* Add the correct formatting function, given from the backend */
  if(options && options.yaxis && options.yaxis.labels && options.yaxis.labels.ntop_utils_formatter) {
    options.yaxis.labels.formatter = NtopUtils[options.yaxis.labels.ntop_utils_formatter] || NtopUtils.fnone
  }

  /* Add the correct formatting function, given from the backend */
  if(options && options.tooltip && options.tooltip.ntop_utils_formatter)
    options.tooltip.custom = NtopUtils[options.tooltip.ntop_utils_formatter]

  return options
}

const get_f_get_custom_chart_options = function() {
  
  /* Return the list of formatted options of the chart */
  return async (url) => {
    let options = format_options(Number(active_filter_list['bubble_mode'].id))
    const data = await ntopng_utility.http_request(url);
    options.series = data.series || {}
    return options
  }
}

const click_item = function(item) {
  ntopng_url_manager.set_key_to_url(item.filter_name, item.id)
  bubble_chart.value.update_chart(`${rest_url}?${format_request()}`)
}

onBeforeMount(() => {
  /* Before mounting the various widgets, update the url to the correct one, by adding ifid, ecc. */
  const bubble_mode = ntopng_url_manager.get_url_entry('bubble_mode');
  
  if(!bubble_mode) ntopng_url_manager.set_key_to_url('bubble_mode', 0) /* First Entry */
  
  ntopng_url_manager.set_key_to_url('ifid', props.ifid) /* Current interface */

  for(const [name, filters] of Object.entries(props.available_filters)) {
    filters.forEach((filter) => {
      filter.filter_name = name
      if(filter.currently_active)
        active_filter_list[name] = filter;
    })
  }
});
</script>
