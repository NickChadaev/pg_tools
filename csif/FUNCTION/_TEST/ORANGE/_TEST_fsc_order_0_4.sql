SELECT id_receipt, dt_create, rcp_status, dt_update, inn, rcp_nmb, rcp_fp, dt_fp, id_org_app, rcp_status_descr, rcp_order, rcp_receipt, id_fsc_provider, rcp_type, rcp_received, rcp_notify_send, id_pay, resend_pr
	FROM fiscalization.fsc_receipt_1;
--
SELECT id_receipt, dt_create, rcp_status, dt_update, inn, rcp_nmb, rcp_fp, dt_fp, id_org_app, rcp_status_descr, rcp_order, rcp_receipt, id_fsc_provider, rcp_type, rcp_received, rcp_notify_send, id_pay, resend_pr
	FROM fiscalization.fsc_receipt_0;
--
SELECT count(1) FROM fiscalization.fsc_receipt_0; -- 99045

SELECT id_receipt, dt_create FROM fiscalization.fsc_receipt_1
INTERSECT
SELECT id_receipt, dt_create FROM fiscalization.fsc_receipt_0;

--
SELECT id_receipt, dt_create FROM fiscalization.fsc_receipt_0
EXCEPT
SELECT id_receipt, dt_create FROM fiscalization.fsc_receipt_1
