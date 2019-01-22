{application, 'emqx_auth_http', [
	{description, ""},
	{vsn, "rolling"},
	{id, "v3.0.0-dirty"},
	{modules, ['emqx_acl_http','emqx_auth_http','emqx_auth_http_app','emqx_auth_http_cfg','emqx_auth_http_cli']},
	{registered, [emqx_auth_http_sup]},
	{applications, [kernel,stdlib,clique]},
	{mod, {emqx_auth_http_app, []}},
	{env, []}
]}.