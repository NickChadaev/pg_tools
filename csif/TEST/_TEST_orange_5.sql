SELECT receipt_id, dt_create, org_id, app_id, dt_fp, fp, "order", receipt, uid, inn, contact, correction, notify_send
       , receipt_received, receipt_status, receipt_status_description 
	FROM public.receipt_old WHERE (dt_create >= '2019-07-01 00:00:00+03') AND (dt_create <= '2019-07-01 23:00:00+03')
	    LIMIT 10;
--
SELECT count(1) FROM public.receipt_old WHERE (dt_create >= '2019-07-01 00:00:00+03') AND (dt_create <= '2019-07-01 23:00:00+03');
-- 24545

CONSTRAINT chk_receipt_dt_create CHECK (dt_create >= '2019-07-01 00:00:00+03'::timestamp with time zone AND dt_create < '2021-01-01 00:00:00+03');

SELECT receipt_id, dt_create, org_id, app_id, dt_fp, fp, "order", receipt, uid, inn, contact, correction, notify_send
       , receipt_received, receipt_status, receipt_status_description 
	FROM public.receipt_old WHERE (dt_create >= '2019-07-01 00:00:00+03') AND (dt_create <= '2019-07-01 23:00:00+03')
	     AND (receipt_status IN (3,4,5))
	    LIMIT 10;

--- 

SELECT  receipt_id, dt_create, org_id, app_id, dt_fp, fp, "order", receipt, uid, inn, contact, correction, notify_send
       , receipt_received, receipt_status, receipt_status_description  FROM public.receipt WHERE (receipt_status IN (3,4,5)) AND 
              (dt_create >= '2021-04-26 00:00:00+03') AND (dt_create <= '2021-04-27 23:00:00+03');

SELECT * FROM public.receipt_status5; 


CONSTRAINT chk_receipt_dt_create CHECK (dt_create >= '2019-07-01 00:00:00+03'::timestamp with time zone AND dt_create < '2021-01-01 00:00:00+03'
--
SELECT receipt_id, dt_create, org_id, app_id, dt_fp, fp, "order", receipt, uid, inn, contact, correction, notify_send
       , receipt_received, receipt_status, receipt_status_description 
	FROM public.receipt_old WHERE (dt_create >= '2020-12-31')
	    LIMIT 100;
--
SELECT count(1) FROM public.receipt_old WHERE (dt_create >= '2020-12-31');
-- 403449

SELECT count(1) FROM fiscalization_part.fsc_receipt_2_2021_3 ;	
--	599914
										
SELECT * FROM fiscalization_part.fsc_receipt_2_2021_3 LIMIT 10;											
