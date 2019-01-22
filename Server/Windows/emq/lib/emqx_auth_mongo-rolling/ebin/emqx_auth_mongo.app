{application, 'emqx_auth_mongo', [
	{description, ""},
	{vsn, "rolling"},
	{id, "v3.0.0-dirty"},
	{modules, ['emqx_acl_mongo','emqx_auth_mongo','emqx_auth_mongo_app','emqx_auth_mongo_cfg','emqx_auth_mongo_sup']},
	{registered, [emqx_auth_mongo_sup]},
	{applications, [kernel,stdlib,mongodb,ecpool,clique,emqx_passwd]},
	{mod, {emqx_auth_mongo_app, []}},
	{env, []}
]}.