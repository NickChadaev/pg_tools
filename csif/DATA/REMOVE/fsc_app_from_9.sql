--
--    2023-08-07
--
BEGIN;
COMMIT;
ROLLBACK;

INSERT INTO fiscalization.fsc_app(
	id_app, dt_create, dt_update, dt_remove, app_guid, secret_key, nm_app, notification_url, provaider_key, app_status
)
SELECT id_app, dt_create, dt_update, dt_remove, app_guid, secret_key, nm_app, notification_url, provaider_key, app_status
FROM "_OLD_9_fiscalization".fsc_app;

SELECT * FROM fiscalization.fsc_app ORDER BY dt_create DESC;