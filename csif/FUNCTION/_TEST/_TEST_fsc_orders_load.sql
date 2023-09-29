-- USE CASE:
-- SELECT * FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0 );
--
-- select count (1), x.dt_create, x.type_source_reestr
--  from fiscalization.fsc_source_reestr x group by x.dt_create, x.type_source_reestr ORDER BY 3, 2;
-- ---------------------------
-- count	dt_create	type_source_reestr
-- 2556	2023-05-12 00:00:00	0
-- 73	    2023-05-13 00:00:00	0
-- 15232	2023-05-17 00:00:00	1
-- ==============================
-- 17861

-- USE CASE:
-- SELECT * FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0 );
--
-- select count (1), x.dt_create, x.type_source_reestr
--  from fiscalization.fsc_source_reestr x group by x.dt_create, x.type_source_reestr ORDER BY 3, 2;
-- ---------------------------
-- count	dt_create	type_source_reestr
-- 2556	2023-05-12 00:00:00	0
-- 73	    2023-05-13 00:00:00	0
-- 15232	2023-05-17 00:00:00	1
-- ==============================
-- 17861
--
SELECT * FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0 ) AND (dt_create >= '2023-05-12');
SELECT id_receipt, rcp_nmb, id_org_app, id_pmt_reestr
   FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0 ) AND (dt_create = '2023-05-13 ')
      ORDER BY 4;
--
SELECT x.*  FROM fiscalization.fsc_source_reestr x WHERE (dt_create >= '2023-05-12 ') AND (type_source_reestr = 0);  -- 53   12: 10  13: 43
SELECT x.id_source_reestr, dt_create, external_id 
    FROM fiscalization.fsc_source_reestr x WHERE (dt_create = '2023-05-13') order by 1;
--
BEGIN;
    DELETE FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0 ) AND (dt_create >= '2023-05-12');
    SELECT * FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0 ) AND (dt_create >= '2023-05-12');   ---  17860   13: 15305
    --
    SELECT fsc_receipt_pcg.fsc_orders_load (0, '2023-05-12', '2023-05-13'); -- 53
	--
    SELECT *
          FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0 ) AND (dt_create >= '2023-05-12 ')
                ORDER BY 4;	-- 48, ИСХОДНО 53  ИНН ПОВТОРЯЛСЯ ??
    --    
COMMIT;
ROLLBACK;


