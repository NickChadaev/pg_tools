--
--    2023-08-07
--
BEGIN;
COMMIT;
ROLLBACK;

INSERT INTO fiscalization.fsc_org_app (id_org_app, id_org, id_app, dt_create, org_app_status, id_fsc_data_operator
)
SELECT id_org_app, id_org, id_app, dt_create, org_app_status, id_fsc_data_operator
	FROM "_OLD_9_fiscalization".fsc_org_app;
	
	
SELECT id_org_app, id_org, id_app, dt_create, org_app_status, id_fsc_data_operator
	FROM fiscalization.fsc_org_app ORDER BY id_org_app DESC;	