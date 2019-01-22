{application, 'emqx_retainer', [
	{description, "EMQ X Retainer"},
	{vsn, "3.0"},
	{id, "v3.0.0-dirty"},
	{modules, ['emqx_retainer','emqx_retainer_app','emqx_retainer_cfg','emqx_retainer_cli','emqx_retainer_sup']},
	{registered, [emqx_retainer_sup]},
	{applications, [kernel,stdlib]},
	{mod, {emqx_retainer_app, []}},
	{env, []}
]}.