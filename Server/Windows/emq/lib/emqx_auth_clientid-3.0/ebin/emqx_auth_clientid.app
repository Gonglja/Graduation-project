{application, emqx_auth_clientid, [
	{description, "EMQ X Authentication with ClientId/Password"},
	{vsn, "3.0"},
	{modules, ['emqx_auth_clientid','emqx_auth_clientid_app']},
	{registered, [emqx_auth_clientid_sup]},
	{applications, [kernel,stdlib]},
	{mod, {emqx_auth_clientid_app, []}}
]}.
