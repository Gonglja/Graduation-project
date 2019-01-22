{application, emqx_dashboard, [
	{description, "EMQ X Web Dashboard"},
	{vsn, "3.0"},
	{id, "v3.0.0"},
	{modules, ['emqx_auth_dashboard','emqx_dashboard','emqx_dashboard_admin','emqx_dashboard_api','emqx_dashboard_app','emqx_dashboard_cli','emqx_dashboard_sup']},
	{registered, [emqx_dashboard_sup]},
	{applications, [kernel,stdlib,mnesia,minirest]},
	{mod, {emqx_dashboard_app, []}}
]}.