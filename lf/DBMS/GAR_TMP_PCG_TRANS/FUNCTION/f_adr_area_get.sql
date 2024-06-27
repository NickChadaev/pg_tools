DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_get (text, uuid);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_area_get (
               p_schema        text -- Имя схемы
              ,p_nm_fias_guid  uuid -- аргумент
	          ,OUT rr          gar_tmp.adr_area_t 
)
    RETURNS gar_tmp.adr_area_t
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
    _exec   text;
    _select text = $_$
                  SELECT 
                           id_area           --  bigint                      -- NOT NULL
                          ,id_country        --  integer                     -- NOT NULL
                          ,nm_area           --  varchar(120)                -- NOT NULL
                          ,nm_area_full      --  varchar(4000)               -- NOT NULL
                          ,id_area_type      --  integer                     --   NULL
                          ,id_area_parent    --  bigint                      --   NULL
                          ,kd_timezone       --  integer                     --   NULL
                          ,pr_detailed       --  smallint                    -- NOT NULL 
                          ,kd_oktmo          --  varchar(11)                 --   NULL
                          ,nm_fias_guid      --  uuid                        --   NULL
                          ,dt_data_del       --  timestamp without time zone --   NULL
                          ,id_data_etalon    --  bigint                      --   NULL
                          ,kd_okato          --  varchar(11)                 --   NULL
                          ,nm_zipcode        --  varchar(20)                 --   NULL
                          ,kd_kladr          --  varchar(15)                 --   NULL
                          ,vl_addr_latitude  --  numeric                     --   NULL
                          ,vl_addr_longitude --  numeric                     --   NULL
    
                  FROM ONLY %I.adr_area
                  
                        WHERE (nm_fias_guid = %L) 
                           AND (id_data_etalon IS NULL) AND (dt_data_del IS NULL);
              $_$;

           
   BEGIN
    -- --------------------------------------------------------------------------
    --  2021-12-10 Nick  Дополнение адресных георегионов. Поиск по UUID
    --  2022-02-21 Опция ONLY.
    --  2023-11-10 Дополнительный поиск в таблице "gar_fias.twin_addr_objects".
    -- --------------------------------------------------------------------------
     _exec := format (_select, p_schema, p_nm_fias_guid);  
     EXECUTE _exec INTO rr;
     
     IF (rr.id_area IS NULL) 
       THEN
        --
        -- Хрен во всю морду, пробуем искать в таблице двойников.
        --
        _exec := format (  _select
                         , p_schema
                         , (SELECT t.fias_guid_new FROM gar_fias.twin_addr_objects t 
                                       INNER JOIN gar_fias.as_addr_obj s ON (t.fias_guid_new = s.object_guid)
                            WHERE ((s.end_date > current_date) AND (t.fias_guid_old = p_nm_fias_guid))
                           ) 
         );  
        EXECUTE _exec INTO rr;
     END IF;
     
     RETURN;
   END;                   
  $$;
 
-- ALTER FUNCTION gar_tmp_pcg_trans.f_adr_area_get (text, uuid) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_area_get (text, uuid) 
IS 'Получить запись из таблицы адресных георегионов. ОТДАЛЁННЫЙ СЕРВЕР';

-- ЗАМЕЧАНИЕ:  функция gar_tmp_pcg_trans.f_adr_area_get(text,uuid) не существует, пропускается
-- ЗАМЕЧАНИЕ:  warning:00000:36:EXECUTE:cannot determinate a result of dynamic SQL
-- ЗАМЕЧАНИЕ:  Detail: There is a risk of related false alarms.
-- ЗАМЕЧАНИЕ:  Hint: Don't use dynamic SQL and record type together, when you would check function.
--
--  USE CASE:
--       836c7232-c614-4455-a71c-9874f2ccee96 | 2cd50151-d2c0-4b9f-b3fd-3a6734c47cc0
--       ----------------------------------------------------------------------------
--       SELECT gar_tmp_pcg_trans.f_adr_area_get ('gar_tmp', '836c7232-c614-4455-a71c-9874f2ccee96'::uuid);
--             '(208140,185,Омарова-Чохского,"Дагестан Респ, Махачкала г., Омарова-Чохского мкр.",30,217,2,0,82701365,836c7232-c614-4455-a71c-9874f2ccee96,,,82401365000,,,,)'    
--       ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--       SELECT gar_tmp_pcg_trans.f_adr_area_get ('gar_tmp', '2cd50151-d2c0-4b9f-b3fd-3a6734c47cc0'::uuid);
--             '(208140,185,Омарова-Чохского,"Дагестан Респ, Махачкала г., Омарова-Чохского мкр.",30,217,2,0,82701365,836c7232-c614-4455-a71c-9874f2ccee96,,,82401365000,,,,)'
--       ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--       SELECT gar_tmp_pcg_trans.f_adr_area_get ('gar_tmp', 'c774b5d0-bd2d-4159-87c3-c08edd1bcedc'::uuid);
--             '(13928,185,37-й,"Башкортостан Респ, Октябрьский г., 37-й мкр.",30,156,4,0,80735000001,51708f9b-ceb3-482b-9074-af0d61f99143,,,80435000000,,02000004002,,)'
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--       SELECT gar_tmp_pcg_trans.f_adr_area_get ('gar_tmp', 'a25b2d21-a398-47da-aaa8-451c29e67bf4'::uuid);
--             '(207479,185,Скотомогильник,"Башкортостан Респ, Татышлинский р-н, Скотомогильник тер",54,162,,1,80650465,41170db5-ad4d-4cee-bba7-0c989ab79703,,,80250865000,,,,)'
--
--       SELECT gar_tmp_pcg_trans.f_adr_area_get ('gar_tmp', '9455353f-a2c6-43c3-8680-e356badf38e0'::uuid);
--       
