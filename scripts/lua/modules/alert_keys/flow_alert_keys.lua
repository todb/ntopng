--
-- (C) 2020-22 - ntop.org
--

-- ##############################################

-- Keep in sync with ntop_typedefs.h FlowAlertTypeEnum
local flow_alert_keys = {
   flow_alert_normal                               = 0,
   flow_alert_blacklisted                          = 1,
   flow_alert_blacklisted_country                  = 2,
   flow_alert_flow_blocked                         = 3,
   flow_alert_data_exfiltration                    = 4,
   flow_alert_device_protocol_not_allowed          = 5,
   flow_alert_dns_data_exfiltration                = 6,
   flow_alert_dns_invalid_query                    = 7,
   flow_alert_elephant_flow                        = 8,
   flow_alert_notused_1                            = 9,  -- No longer used, can be recycled
   flow_alert_external                             = 10,
   flow_alert_longlived                            = 11,
   flow_alert_low_goodput                          = 12,
   flow_alert_notused_2                            = 13, -- No longer used, can be recycled
   flow_alert_internals                            = 14,
   flow_alert_notused_3                            = 15, -- No longer used, can be recycled
   flow_alert_remote_to_remote                     = 16,
   flow_alert_notused_4                            = 17, -- No longer used, can be recycled
   flow_alert_notused_5                            = 18, -- No longer used, can be recycled
   flow_alert_tcp_packets_issues                   = 19,
   flow_alert_tcp_connection_refused               = 20,
   flow_alert_tcp_severe_connection_issues         = 21,
   flow_alert_tls_certificate_expired              = 22,
   flow_alert_tls_certificate_mismatch             = 23,
   flow_alert_ndpi_tls_old_protocol_version        = 24,
   flow_alert_tls_unsafe_ciphers                   = 25,
   flow_alert_ndpi_unidirectional_traffic          = 26,
   flow_alert_web_mining                           = 27,
   flow_alert_tls_certificate_selfsigned           = 28,
   flow_alert_binary_application_transfer          = 29,
   flow_alert_known_proto_on_non_std_port          = 30,
   flow_alert_flow_risk                            = 31,
   flow_alert_unexpected_dhcp_server               = 32,
   flow_alert_unexpected_dns_server                = 33,
   flow_alert_unexpected_smtp_server               = 34,
   flow_alert_unexpected_ntp_server                = 35,
   flow_alert_zero_tcp_window                      = 36,
   flow_alert_iec_invalid_transition               = 37,
   flow_alert_remote_to_local_insecure_proto       = 38,
   flow_alert_ndpi_url_possible_xss                = 39,
   flow_alert_ndpi_url_possible_sql_injection      = 40,
   flow_alert_ndpi_url_possible_rce_injection      = 41,
   flow_alert_ndpi_http_suspicious_user_agent      = 42,
   flow_alert_ndpi_numeric_ip_host                 = 43,
   flow_alert_ndpi_http_suspicious_url             = 44,
   flow_alert_ndpi_http_suspicious_header          = 45,
   flow_alert_ndpi_tls_not_carrying_https          = 46,
   flow_alert_ndpi_suspicious_dga_domain           = 47,
   flow_alert_ndpi_malformed_packet                = 48,
   flow_alert_ndpi_ssh_obsolete_server             = 49,
   flow_alert_ndpi_smb_insecure_version            = 50,
   flow_alert_ndpi_tls_suspicious_esni_usage       = 51,
   flow_alert_ndpi_unsafe_protocol                 = 52,
   flow_alert_ndpi_dns_suspicious_traffic          = 53,
   flow_alert_ndpi_tls_missing_sni                 = 54,
   flow_alert_iec_unexpected_type_id               = 55,
   flow_alert_tcp_no_data_exchanged                = 56,
   flow_alert_remote_access                        = 57,
   flow_alert_lateral_movement                     = 58,
   flow_alert_periodicity_changed                  = 59,
   flow_alert_ndpi_tls_cert_validity_too_long      = 60,
   flow_alert_ndpi_ssh_obsolete_client             = 61,
   flow_alert_ndpi_clear_text_credentials          = 62,
   flow_alert_ndpi_http_suspicious_content         = 63,
   flow_alert_ndpi_dns_large_packet                = 64,
   flow_alert_ndpi_dns_fragmented                  = 65,
   flow_alert_ndpi_invalid_characters              = 66,
   flow_alert_broadcast_non_udp_traffic            = 67,
   flow_alert_ndpi_possible_exploit                = 68,
   flow_alert_ndpi_tls_certificate_about_to_expire = 69,
   flow_alert_ndpi_punicody_idn                    = 70,
   flow_alert_ndpi_error_code_detected             = 71,
   flow_alert_ndpi_http_crawler_bot                = 72,
   flow_alert_ndpi_suspicious_entropy              = 73,
   flow_alert_iec_invalid_command_transition       = 74,
   flow_alert_connection_failed                    = 75,
   flow_alert_ndpi_anonymous_subscriber            = 76,
   flow_alert_unidirectional_traffic               = 77,
   flow_alert_ndpi_desktop_or_file_sharing_session = 78,
   flow_alert_ndpi_malicious_ja3                   = 79,
   flow_alert_ndpi_malicious_sha1_certificate      = 80,
   flow_alert_ndpi_tls_uncommon_alpn               = 81,
   flow_alert_ndpi_tls_suspicious_extension        = 82,
   flow_alert_ndpi_tls_fatal_alert                 = 83,
   flow_alert_ndpi_http_obsolete_server            = 84,
   flow_alert_ndpi_risky_asn                       = 85,
   flow_alert_ndpi_risky_domain                    = 86,
   flow_alert_custom_lua_script                    = 87,
   flow_alert_ndpi_periodic_flow                   = 88,
   flow_alert_ndpi_minor_issues                    = 89,
   flow_alert_ndpi_tcp_issues                      = 90,
   flow_alert_vlan_bidirectional_traffic           = 91,
   flow_alert_rare_destination                     = 92
   
   -- NOTE: for flow alerts not not go beyond the size of Bitmap alert_map inside Flow.h (currently 128)
}

-- ##############################################

return flow_alert_keys

-- ##############################################
