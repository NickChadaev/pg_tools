--
--    2023-08-07
--
BEGIN;
COMMIT;
ROLLBACK;

INSERT INTO fiscalization.fsc_receipt (
	  id_receipt
	, dt_create
	, rcp_status
    , dt_update
	, inn
	, rcp_nmb
	, rcp_fp
	, dt_fp
	, id_org_app
	, rcp_status_descr
	, rcp_order
	, rcp_receipt
	, id_fsc_provider
	, rcp_type
	, rcp_received
	, rcp_notify_send
	, id_pay
	, resend_pr
)
SELECT id_receipt
     , dt_create
	 , rcp_status
	 , dt_update
	 , inn
	 , rcp_nmb
	 , rcp_fp
	 , dt_fp
	 , id_org_app
	 , rcp_status_descr
	 , rcp_order
	 , rcp_receipt
	 , 2 AS id_fsc_provider
	 , rcp_type
	 , rcp_received
	 , rcp_notify_send
	 , id_pay
	 , resend_pr
	FROM "_OLD_9_fiscalization".fsc_receipt  WHERE (rcp_status >= 1);
--
INSERT INTO fiscalization.fsc_receipt (
	  id_receipt
	, dt_create
	, rcp_status
    , dt_update
	, inn
	, rcp_nmb
	, rcp_fp
	, dt_fp
	, id_org_app
	, rcp_status_descr
	, rcp_order
	, rcp_receipt
	, id_fsc_provider
	, rcp_type
	, rcp_received
	, rcp_notify_send
	, id_pay
	, resend_pr
)
SELECT id_receipt
     , dt_create
	 , rcp_status
	 , dt_update
	 , inn
	 , rcp_nmb
	 , rcp_fp
	 , dt_fp
	 , id_org_app
	 , rcp_status_descr
	 , rcp_order
	 , rcp_receipt
	 , 1 AS id_fsc_provider
	 , rcp_type
	 , rcp_received
	 , rcp_notify_send
	 , id_pay
	 , resend_pr
	FROM "_OLD_9_fiscalization".fsc_receipt  WHERE (rcp_status = 0);
--
SELECT count (1) FROM "_OLD_9_fiscalization".fsc_receipt;
-- 2-000-048

SELECT min (dt_create), max (dt_create) FROM "_OLD_9_fiscalization".fsc_receipt WHERE (rcp_status >= 1);
-- 2021-01-01 00:00:21+03
-- 2021-10-01 10:41:52+03

SELECT count (1) FROM fiscalization.fsc_receipt;

SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status > 1) limit 10;