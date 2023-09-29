--
--    2023-08-07
--
BEGIN;
COMMIT;
ROLLBACK;

INSERT INTO fiscalization.fsc_org (
	id_org, dt_create, dt_update, dt_remove, inn, nm_org_name, org_type, org_status, bik, nm_org_address, nm_org_phones
)
SELECT id_org, dt_create, dt_update, dt_remove, inn, nm_org_name, org_type, org_status, bik, nm_org_address, nm_org_phones
 FROM "_OLD_9_fiscalization".fsc_org;
--
SELECT id_org, dt_create, dt_update, dt_remove, inn, nm_org_name, org_type, org_status, bik, nm_org_address, nm_org_phones
 FROM fiscalization.fsc_org;