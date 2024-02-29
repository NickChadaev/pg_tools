SELECT id, email, first_name, last_name, "password", password_salt, date_joined, last_login, is_superuser
     , is_active, reset_token, reset_triggered, is_qbnewb, login_attributes, updated_at, sso_source
     , locale, is_datasetnewb, settings
FROM public.core_user;

id|email             |first_name|last_name|password                                                    |password_salt 
--+------------------+----------+---------+------------------------------------------------------------+--------------
 1|xlarik_357@list.ru|xlarik    |xlarik   |$2a$10$tEusXbPwenuU7DQE9OjCmuNZ2OUmrylYoMJRWGb03EPr8iuh..Xsi|ea7096ff-72b8-
 
 
SELECT id, user_id, created_at, anti_csrf_token
FROM public.core_session;
 

id                                  |user_id|created_at                   |anti_csrf_token|
------------------------------------+-------+-----------------------------+---------------+
07b78a1a-884e-492f-a4ce-c38fd8f03f69|      1|2024-02-16 14:08:19.120 +0300|               |

SELECT id, "name", description, archived, "location", personal_owner_id, slug, "namespace", authority_level, entity_id, created_at, "type"
FROM public.collection;

id|name                          |description|archived|location|personal_owner_id|slug                                  
--+------------------------------+-----------+--------+--------+-----------------+--------------------------------------
 1|xlarik личная коллекция xlarik|           |false   |/       |                1|xlarik_%D0%BB%D0%B8%D1%87%D0%BD%D0%B0%
 

-- 2024-02-19
-------------
 SELECT id, created_at, updated_at, "name", description, details, engine, is_sample, is_full_sync, points_of_interest, caveats, metadata_sync_schedule, cache_field_values_schedule, timezone, is_on_demand, auto_run_queries, refingerprint, cache_ttl, initial_sync_status, creator_id, settings, dbms_version, is_audit
FROM public.metabase_database;

SELECT id, created_at, updated_at, "name", description, entity_type, active, db_id, display_name, visibility_type, "schema", points_of_interest, caveats, show_in_getting_started, field_order, initial_sync_status, is_upload
FROM public.metabase_table;


SELECT id, "object", group_id
FROM public.permissions;


SELECT id, "name"
FROM public.permissions_group;

SELECT id, user_id, group_id, is_group_manager
FROM public.permissions_group_membership;

SELECT id, "version", creator_id, created_at, updated_at, "name", kind, "source", value
FROM public.secret;

SELECT id, user_id, model, model_id, "timestamp", metadata, has_access, context
FROM public.view_log;
