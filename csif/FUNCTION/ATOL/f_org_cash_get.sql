DROP FUNCTION IF EXISTS fsc_receipt_pcg.f_org_cash_get (varchar(12), integer) CASCADE;
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.f_org_cash_get (
                             p_org_inn         varchar(12) 
                            ,p_id_fsc_provider integer  
                             --
                            ,OUT id_org_cash     integer
                            ,OUT id_org          integer
                            ,OUT grp_cash        varchar(50)
                            ,OUT org_cash_params json
)
    RETURNS SETOF RECORD
    LANGUAGE plpgsql
    STABLE

AS $$
  -- -----------------------------------------------------------------
  --  2023-08-30 Получить параметры касс для выбранной организации. 
  -- -----------------------------------------------------------------
  BEGIN
    SELECT x1.id_org_cash, x0.id_org, x1.grp_cash, x1.org_cash_params
      FROM fiscalization.fsc_org  x0
        INNER JOIN fiscalization.fsc_org_cash x1 ON 
                (x0.id_org = x1.id_org) AND (x1.org_cash_status)  
    WHERE (x0.org_status) AND (x0.inn = p_org_inn) AND (x1.id_fsc_provider = p_id_fsc_provider) 
    INTO  id_org_cash, id_org, grp_cash, org_cash_params;

    RETURN NEXT;    
  END;  
$$;
   
COMMENT ON FUNCTION fsc_receipt_pcg.f_org_cash_get (varchar(12), integer)  
   IS 'Получить параметры касс для выбранной организации.';
   --
   -- USE CASE
   -- SELECT * FROM fsc_receipt_pcg.f_org_cash_get ('5609032431', 2);
   -- -----------------------------------------------------------------------------------------
   -- id_org_cash	id_org	grp_cash	org_cash_params
   -- 27	33	3010071	
--    {"tax": "3"
--    , "prType": "1"
--    , "agentType": "0"
--    , "paymentType": "2"
--    , "supplierINN": null
--    , "provaider_key": "3010071"
--    , "taxationSystem": "0"
--    , "paymentMethodType": "3"
--    , "paymentOperatorINN": null
--    , "paymentSubjectType": "4"
--    , "paymentOperatorName": null
--    , "supplierPhoneNumbers": null
--    , "paymentAgentOperation": null
--    , "paymentOperatorAddress": null
--    , "paymentAgentPhoneNumbers": null
--    , "paymentOperatorPhoneNumbers": null
--    , "paymentTransferOperatorPhoneNumbers": null
--   }
   
