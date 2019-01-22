{application,emqx_auth_ldap,
             [{description,"EMQ X Authentication/ACL with LDAP"},
              {vsn,"3.0"},
              {modules, ['emqx_acl_ldap','emqx_auth_ldap','emqx_auth_ldap_app','emqx_auth_ldap_cli','emqx_auth_ldap_sup']},
              {registered,[emqx_auth_ldap_sup]},
              {applications,[kernel,stdlib,eldap2,ecpool,clique,emqx_passwd]},
              {mod,{emqx_auth_ldap_app,[]}}]}.
