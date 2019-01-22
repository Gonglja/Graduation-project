{application, emqx_lwm2m, [
	{description, "EMQ X LwM2M Gateway"},
	{vsn, "3.0"},
	{id, "v3.0.0"},
	{modules, ['binary_util','emqx_lwm2m_app','emqx_lwm2m_cfg','emqx_lwm2m_cmd_handler','emqx_lwm2m_coap_resource','emqx_lwm2m_coap_server','emqx_lwm2m_json','emqx_lwm2m_message','emqx_lwm2m_protocol','emqx_lwm2m_registry','emqx_lwm2m_sup','emqx_lwm2m_timer','emqx_lwm2m_tlv','emqx_lwm2m_xml_object','emqx_lwm2m_xml_object_db']},
	{registered, [emqx_lwm2m_sup]},
	{applications, [kernel,stdlib,lwm2m_coap,jsx,clique]},
	{mod, {emqx_lwm2m_app, []}}
]}.