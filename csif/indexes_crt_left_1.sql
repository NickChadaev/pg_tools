/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     04.08.2023                                   */ 
/*  2023-08-22  Индексы становятся глобальными, определёнными   */
/*              для каждой секции.                              */
/*==============================================================*/

SET search_path=fiscalization;

DROP INDEX IF EXISTS fiscalization.ie1_receipt;
CREATE INDEX ie1_receipt ON fiscalization.fsc_receipt USING btree (rcp_status, inn);

DROP INDEX IF EXISTS fiscalization.ie2_receipt;
CREATE INDEX ie2_receipt ON fiscalization.fsc_receipt USING btree (rcp_status, id_pay);
    
DROP INDEX IF EXISTS fiscalization.ie3_receipt;
CREATE INDEX ie3_receipt ON fiscalization.fsc_receipt USING btree (rcp_status, id_fsc_provider);

DROP INDEX IF EXISTS fiscalization.ie4_receipt;
CREATE INDEX ie4_receipt ON fiscalization.fsc_receipt USING btree (rcp_status, rcp_nmb);

DROP INDEX IF EXISTS fiscalization.ie5_receipt;
CREATE INDEX ie5_receipt ON fiscalization.fsc_receipt USING btree (rcp_status, rcp_fp);

DROP INDEX IF EXISTS fiscalization.ie6_receipt;
CREATE INDEX ie6_receipt ON fiscalization.fsc_receipt USING btree (rcp_status, dt_fp);

--
--    Триггер: контроль принадлежности чека и организации провайдеру ???  Что это такое ???
--

ALTER TABLE fiscalization.fsc_receipt ADD CONSTRAINT fk_org_app_supports_fsc_receipt FOREIGN KEY (id_org_app)        
REFERENCES fiscalization.fsc_org_app (id_org_app)  
        ON UPDATE RESTRICT
        ON DELETE RESTRICT;
        
ALTER TABLE fiscalization.fsc_receipt ADD CONSTRAINT fk_fsc_provider_supports_fsc_receipt FOREIGN KEY (id_fsc_provider)        
REFERENCES fiscalization.fsc_provider (id_fsc_provider)  
        ON UPDATE RESTRICT
        ON DELETE RESTRICT;

        
        
