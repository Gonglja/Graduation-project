{application,emqx_management,
             [{description,"EMQ X Management API and CLI"},
              {vsn,"3.0"},
              {modules, ['emqx_mgmt','emqx_mgmt_api','emqx_mgmt_api_alarms','emqx_mgmt_api_apps','emqx_mgmt_api_banned','emqx_mgmt_api_brokers','emqx_mgmt_api_configs','emqx_mgmt_api_connections','emqx_mgmt_api_listeners','emqx_mgmt_api_metrics','emqx_mgmt_api_nodes','emqx_mgmt_api_plugins','emqx_mgmt_api_pubsub','emqx_mgmt_api_routes','emqx_mgmt_api_sessions','emqx_mgmt_api_stats','emqx_mgmt_api_subscriptions','emqx_mgmt_app','emqx_mgmt_auth','emqx_mgmt_cli','emqx_mgmt_cli_cfg','emqx_mgmt_config','emqx_mgmt_http','emqx_mgmt_sup','emqx_mgmt_util']},
              {registered,[emqx_management_sup]},
              {applications,[kernel,stdlib,minirest,clique]},
              {mod,{emqx_mgmt_app,[]}}]}.
