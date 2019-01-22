{application, 'emqx_lua_hook', [
	{description, "EMQ X Lua Hooks"},
	{vsn, "3.0"},
	{id, "v3.0.0-dirty"},
	{modules, ['emqx_lua_hook','emqx_lua_hook_app','emqx_lua_hook_cli','emqx_lua_hook_sup','emqx_lua_script']},
	{registered, [emqx_lua_hook_sup]},
	{applications, [kernel,stdlib,luerl]},
	{mod, {emqx_lua_hook_app, []}},
	{env, []}
]}.