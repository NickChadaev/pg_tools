DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_stead_get (text, bigint, varchar(250), bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_stead_get (
              p_schema         text      -- Имя схемы
              --
             ,p_id_area         bigint   --  NOT NULL
             ,p_stead_num   varchar(250) --  NOT NULL
             ,p_id_street       bigint   --      NULL
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
              (id_area = %L::bigint) AND (upper(stead_num::text) = upper (%L)::text) AND
              (id_street IS NOT DISTINCT FROM %L::bigint) AND
			  (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
      $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --     2023-10-17 Nick.
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_id_area, p_stead_num, p_id_street);  
      
     EXECUTE _exec INTO rr;
     RETURN;

   END;                   
  $$;
 
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_stead_get (text, bigint, varchar(250), bigint)
IS 'Получить запись из таблицы адресов ЗУ. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_stead_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       SELECT gar_tmp_pcg_trans.f_adr_stead_get ('gar_tmp', 1087, 'д. 74',  68730);
--       SELECT gar_tmp_pcg_trans.f_adr_stead_get ('unnsi', 73908, 'д. 2', NULL, 2);
--       SELECT gar_tmp_pcg_trans.f_adr_stead_get ('gar_tmp', 73908, 'д. 2', NULL);    
-- -----------------------------------------------------------------------------------
--  SELECT nm_fias_guid FROM unnsi.adr_stead 
--                       WHERE ((id_area = 73908) AND (upper(nm_house_full::text) = upper('д. 2')) AND
--                              (id_street IS NOT DISTINCT FROM NULL) AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL)
--                       ); -- 001d7c82-92e0-4392-82f1-f9646e6c9f9f
-- SELECT * FROM unnsi.adr_stead WHERE (nm_fias_guid = '001d7c82-92e0-4392-82f1-f9646e6c9f9f');
-- --
--  SELECT nm_fias_guid FROM unnsi.adr_stead 
--                WHERE ((id_area = 91764) AND (upper(nm_house_full::text) = upper('дв. 10')) AND
--                       (id_street IS NOT DISTINCT FROM 588345) AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL)
--                       ); -- dfd85aa3-942b-4911-a8b9-a800514712d3
--
-- SELECT * FROM gar_tmp_pcg_trans.f_adr_stead_get ('unnsi', 73908, 'д. 2', NULL, 2);
-- SELECT (gar_tmp_pcg_trans.f_adr_stead_get ('unnsi', 73908, 'д. 2', NULL, 2)).id_house;
-- SELECT (gar_tmp_pcg_trans.f_adr_stead_get ('unnsi', 73908, 'д. 2', NULL, 2)).nm_fias_guid;
