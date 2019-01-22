{application, 'emqx_plugin_template', [
	{description, ""},
	{vsn, "rolling"},
	{id, "v3.0.0-dirty"},
	{modules, ['emqx_acl_demo','emqx_auth_demo','emqx_cli_demo','emqx_plugin_template','emqx_plugin_template_app','emqx_plugin_template_sup']},
	{registered, [emqx_plugin_template_sup]},
	{applications, [kernel,stdlib]},
	{mod, {emqx_plugin_template_app, []}},
	{env, []}
]}.