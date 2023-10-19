DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_stead_get (text, uuid);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_stead_get (
              p_schema        text -- Имя схемы
             ,p_nm_fias_guid  uuid -- NOT NULL
              --
             ,OUT rr gar_tmp.adr_stead_t 
)
    RETURNS gar_tmp.adr_stead_t
    LANGUAGE plpgsql
    
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
         SELECT   
         
                id_stead           
               ,id_area            
               ,id_street          
               ,stead_num          
               ,stead_cadastr_num  
               ,kd_oktmo           
               ,kd_okato           
               ,nm_zipcode         
               ,nm_fias_guid       
               ,dt_data_del        
               ,id_data_etalon     
               ,vl_addr_latitude   
               ,vl_addr_longitude  
                 
         FROM ONLY %I.adr_stead WHERE
              (nm_fias_guid = %L::uuid) AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
      $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --     2023-10-17 Nick.
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_nm_fias_guid);  
      
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_stead_get (text, uuid)
IS 'Получить запись из таблицы адресов ЗУ. ОТДАЛЁННЫЙ СЕРВЕР';
--
--  USE CASE:
--       SELECT * FROM gar_tmp_pcg_trans.f_adr_stead_get ('gar_tmp', '38f092e7-a04b-46d9-bcaf-37c61ef241ea'::uuid);

--  id_stead |id_area|id_street|stead_num|stead_cadastr_num|kd_oktmo   |kd_okato   |nm_zipcode|nm_fias_guid                        |
--  ---------+-------+---------+---------+-----------------+-----------+-----------+----------+------------------------------------+
--  600962344|   6303|   198812|19       |05:06:000013:1168|82626440101|82226000006|368105    |38f092e7-a04b-46d9-bcaf-37c61ef241ea|
--
--  SELECT * FROM gar_tmp_pcg_trans.f_adr_stead_get ('gar_tmp', 6303, '19', 198812);    
-- -----------------------------------------------------------------------------------
-- SELECT * FROM gar_tmp.adr_stead WHERE (nm_fias_guid = '38f092e7-a04b-46d9-bcaf-37c61ef241ea');
-- 600962344|     6303|   198812|19       |05:06:000013:1168|82626440101|82226000006|368105    |38f092e7-a04b-46d9-bcaf-37c61ef241ea| 

