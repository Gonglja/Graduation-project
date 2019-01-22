{application, 'emqx_delayed_publish', [
	{description, "EMQ X Delayed Publish"},
	{vsn, "3.0"},
	{id, "v3.0.0-dirty"},
	{modules, ['emqx_delayed_publish','emqx_delayed_publish_app','emqx_delayed_publish_sup']},
	{registered, [emqx_delayed_publish_sup]},
	{applications, [kernel,stdlib]},
	{mod, {emqx_delayed_publish_app, []}},
	{env, []}
]}.