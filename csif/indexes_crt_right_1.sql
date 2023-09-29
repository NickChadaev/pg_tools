/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     09.08.2023                                   */ 
/*==============================================================*/

SET search_path=fiscalization;

CREATE UNIQUE INDEX IF NOT EXISTS ak1_org ON fiscalization.fsc_org 
  USING btree (fsc_receipt_pcg.f_xxx_replace_char(nm_org_name), inn);
  
CREATE INDEX IF NOT EXISTS ie1_app ON fiscalization.fsc_app
  USING hash (app_guid);
  
-- ----------------------------------------------------------------
-- 2023-08-25
--
CREATE INDEX IF NOT EXISTS ie1_org ON fiscalization.fsc_org
  USING btree (inn); 
  
ALTER TABLE fiscalization.fsc_org_app ADD CONSTRAINT fk_fsc_data_operator_supports_fsc_org_app 
FOREIGN KEY (id_fsc_data_operator)        
REFERENCES fiscalization.fsc_data_operator (id_fsc_data_operator)  
        ON UPDATE RESTRICT
        ON DELETE RESTRICT;        

ALTER TABLE fiscalization.fsc_org_cash ADD CONSTRAINT fk_fsc_provider_fsc_org_cash
FOREIGN KEY (id_fsc_provider)
REFERENCES fiscalization.fsc_provider (id_fsc_provider)  
        ON UPDATE RESTRICT
        ON DELETE RESTRICT; 
        
ALTER TABLE fiscalization.fsc_app_param ADD CONSTRAINT fk_fsc_provider_fsc_app_param        
FOREIGN KEY (id_fsc_provider)
REFERENCES fiscalization.fsc_provider (id_fsc_provider)  
        ON UPDATE RESTRICT
        ON DELETE RESTRICT;
