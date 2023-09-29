-- DROP TABLE fiscalization.fsc_goback;
CREATE TABLE fiscalization.fsc_goback (
   goback_data json
);

SELECT k.goback_data  FROM fiscalization.fsc_goback k;
SELECT json_array_length(x.goback_data) FROM fiscalization.fsc_goback x; -- 998

BEGIN;
ROLLBACK;
COMMIT;
EXPLAIN
SELECT * FROM fsc_orange_pcg.fsc_receipt_upd (
	(SELECT k.goback_data  FROM fiscalization.fsc_goback k) --, 0   -- 8557733579,  8557734614++
);	-- 2 SEC

-- SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 0) AND (rcp_nmb = '320aafd4-e484-43d8-8135-959f6d98b54f');
-- SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 1) ORDER by dt_create DESC; 
--              AND (rcp_nmb = '320aafd4-e484-43d8-8135-959f6d98b54f');
-- SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 2) AND (rcp_nmb = '320aafd4-e484-43d8-8135-959f6d98b54f');
--
SELECT * FROM fiscalization.fsc_receipt_2_default; -- 148, 85
--
SELECT * FROM fsc_receipt_pcg.f_org_get(148)
SELECT * FROM fsc_receipt_pcg.f_app_get(148)
-- {
--     "fp": "9831876769",
--     "id": "d18df966-75ba-4ba7-875a-d1ac9c26c2a5",
--     "change": 0.11,
--     "ofdName": "НТТ Контур",
--     "deviceRN": "8102414032",
--     "deviceSN": "3455310189",
--     "fsNumber": "773501929",
--     "companyINN": "5609032431",
--     "fnsWebsite": "www.nalog.ru",
--     "companyName": "ООО \"Газпром межрегионгаз Оренбург\"",
--     "processedAt": "2024-09-18T07:09:41",
--     "shiftNumber": 88,
--     "documentIndex": 0,
--     "documentNumber": 56
-- }
-- ERROR:  no partition of relation "fsc_receipt_2" found for row
-- ПОДРОБНОСТИ:  Partition key of the failing row contains (dt_create) = (2024-09-17 07:09:41+03).
-- КОНТЕКСТ:  PL/pgSQL function fsc_orange_pcg.fsc_receipt_upd(json,integer,integer) line 19 at RETURN QUERY
-- SQL state: 23514
-- Detail: Partition key of the failing row contains (dt_create) = (2024-09-17 07:09:41+03).
-- Context: PL/pgSQL function fsc_orange_pcg.fsc_receipt_upd(json,integer,integer) line 19 at RETURN QUERY

-- {
--     "fp": "9831876769",
--     "id": "d18df966-75ba-4ba7-875a-d1ac9c26c2a5",
--     "change": 0.11,
--     "ofdName": "НТТ Контур",
--     "deviceRN": "8102414032",
--     "deviceSN": "3455310189",
--     "fsNumber": "773501929",
--     "companyINN": "5609032431",
--     "fnsWebsite": "www.nalog.ru",
--     "companyName": "ООО \"Газпром межрегионгаз Оренбург\"",
--     "processedAt": "2024-09-18T07:09:41",
--     "shiftNumber": 88,
--     "documentIndex": 0,
--     "documentNumber": 56
-- }