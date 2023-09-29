--
--    2023-08-07
--
BEGIN;
COMMIT;
ROLLBACK;

INSERT INTO fiscalization.fsc_org_cash ( 
	id_org_cash, id_org, dt_create, dt_update, qty_cash, grp_cash, nm_grp_cash, org_cash_status, id_fsc_provider
)
SELECT id_org_cash, id_org, dt_create, dt_update, qty_cash, grp_cash, nm_grp_cash, org_cash_status, id_fsc_provider
FROM "_OLD_9_fiscalization".fsc_org_cash;	

SELECT id_org_cash, id_org, dt_create, dt_update, qty_cash, grp_cash, nm_grp_cash, org_cash_status, id_fsc_provider
FROM fiscalization.fsc_org_cash ORDER BY id_org_cash DESC;	