--
--  2023-05-04
--

DROP SEQUENCE IF EXISTS  fiscalization.fsc_app_id_app_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS  fiscalization.fsc_app_id_app_seq
AS integer;

--

DROP SEQUENCE IF EXISTS  fiscalization.fsc_org_id_org_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS  fiscalization.fsc_org_id_org_seq
AS integer;

--
 
DROP SEQUENCE IF EXISTS  fiscalization.fsc_receipt_id_receipt_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS  fiscalization.fsc_receipt_id_receipt_seq
AS bigint;

-- ++
-- DROP SEQUENCE IF EXISTS fiscalization.fsc_app_fsc_provider_id_seq CASCADE;
DROP SEQUENCE IF EXISTS  fiscalization.fsc_org_app_id_org_app_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS  fiscalization.fsc_org_app_id_org_app_seq
AS integer  ;

--               fsc_provider

DROP SEQUENCE IF EXISTS  fiscalization.fsc_provider_id_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS  fiscalization.fsc_provider_id_seq
AS integer  ;

--  

DROP SEQUENCE IF EXISTS  fiscalization.fsc_org_cash_id_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS  fiscalization.fsc_org_cash_id_seq
AS integer  ;

--  

DROP SEQUENCE IF EXISTS  fiscalization.fsc_app_param_id_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS  fiscalization.fsc_app_param_id_seq
AS integer  ;

--  

DROP SEQUENCE IF EXISTS  fiscalization.fsc_data_operator_id_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS  fiscalization.fsc_data_operator_id_seq
AS integer  ;

--

DROP SEQUENCE IF EXISTS fiscalization.fsc_source_reestr_id_reestr_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS fiscalization.fsc_source_reestr_id_reestr_seq
AS bigint;
