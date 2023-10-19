DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_stead_upd (text, text, text, uuid[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_stead_upd (

           p_schema_data    text -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
          ,p_schema_etl     text -- Схема эталон, обычно локальный сервер, копия p_chema_data 
          ,p_schema_hist    text -- Схема для хранения исторических данных 
           --
          ,p_nm_guids_fias  uuid[]  = NULL -- Список обрабатываемых GUID, NULL - все.
           --
          ,OUT total_row  integer  -- Общее количество обработанных строк.
          ,OUT upd_row    integer  -- Из них обновлено.
)
    RETURNS setof record
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
     _r_upd   integer := 0;   
     --
     _data   gar_tmp.xxx_adr_stead_proc_t;  
     _parent gar_tmp.adr_street_t;
     --
     _id_area    bigint;   
     _id_street  bigint;    
     --
     -- 2022-10-18
     --
     UPD_OP CONSTANT char(1) := 'U';  

     
   BEGIN
    -- -----------------------------------------------------------------------------------
    --  2021-12-10 Nick  Обновление и дополнение адресных свойств зхемельных участков.
    -- -------------------------------------------------------------------------  
    --     p_schema_data    -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
    --    ,p_schema_etl     -- Схема эталон, обычно локальный сервер, копия p_schema_data 
    --    ,p_schema_hist    -- Схема для хранения исторических данных 
    --    ,p_nm_guids_fias  -- Список обрабатываемых GUID, NULL - все.
    -- -----------------------------------------------------------------------------------
    FOR _data IN 
          SELECT 
                s.id_stead                                        
              , s.id_addr_parent                                  
              , s.fias_guid        AS nm_fias_guid                
              , s.parent_fias_guid AS nm_fias_guid_parent         
              , s.nm_parent_obj                                   
              , s.region_code                                     
              
              , s.parent_type_id                                  
              , s.parent_type_name                                
              , s.parent_type_shortname                           
              
              , s.parent_level_id                                 
              , s.parent_level_name                               
              
              , s.stead_num                                        

              , (p.type_param_value -> '8'::text)  AS stead_cadastr_num 
              , (p.type_param_value -> '7'::text)  AS kd_oktmo
              , (p.type_param_value -> '6'::text)  AS kd_okato  
              , (p.type_param_value -> '5'::text)  AS nm_zipcode   
              
              , s.oper_type_id                                     
              , s.oper_type_name                                   
              
           FROM gar_tmp.xxx_adr_stead s   
              
              INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = s.fias_guid) 
              LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (s.id_stead = p.object_id)              
              
            WHERE (f.id_obj IS NOT NULL) AND (f.type_object = 3) 
                    AND
                  (((s.fias_guid = ANY (p_nm_guids_fias)) AND 
	               (p_nm_guids_fias IS NOT NULL)) OR (p_nm_guids_fias IS NULL)
	              )                     
       LOOP
      
         -- 2022-05-31
         --              level_id |           level_name       
         --             ----------+------------------------------------
         --                     1 | Субъект РФ                               
         --                     2 | Административный район                   
         --                     3 | Муниципальный район                      
         --                     4 | Сельское/городское поселение             
         --                     5 | Город                                    
         --                     6 | Населенный пункт                         
         --                     7 | Элемент планировочной структуры          
         --                     8 | Элемент улично-дорожной сети             
         --                     9 | Земельный участок                        
         
         IF (_data.parent_level_id IN (8, 9))  -- ??
           THEN
              _parent := gar_tmp_pcg_trans.f_adr_street_get (p_schema_etl, _data.nm_fias_guid_parent);
              _id_area   := _parent.id_area;   
              _id_street := _parent.id_street;    
           
           ELSE
            _id_area   := (gar_tmp_pcg_trans.f_adr_area_get (p_schema_etl, _data.nm_fias_guid_parent)).id_area;   
            _id_street := NULL;  
           
         END IF;
         --
         IF (_id_area IS NULL)
           THEN
               CALL gar_tmp_pcg_trans.p_xxx_adr_stead_gap_put (_data);
               CONTINUE; -- НЕ были загружены Ни улицы, Ни адресные объекты.
         END IF; 
         --
    --
    --     p_schema_data    -- Обновляемая схема  с данными ОТДАЛЁННЫЙ СЕРВЕР
    --    ,p_schema_etl     -- Схема эталон, обычно локальный сервер, копия p_schema_data 
    --    ,p_schema_hist    -- Схема для хранения исторических данных 
         
         CALL gar_tmp_pcg_trans.p_adr_stead_upd (
         
               p_schema_name := p_schema_data
              ,p_schema_h    := p_schema_hist       
               --
              ,p_id_area   :=  _id_area::bigint         --  NOT NULL
              ,p_id_street :=  _id_street::bigint       --      NULL
               --
              ,p_stead_num         := _data.stead_num                                        
              ,p_stead_cadastr_num := _data.stead_cadastr_num
               --              
              ,p_kd_oktmo          := _data.kd_oktmo::varchar(11)    --  NULL
              ,p_kd_okato          := _data.kd_okato::varchar(11)    --  NULL
              ,p_nm_zipcode        := _data.nm_zipcode::varchar(20)  --  NULL
               --        
             ,p_nm_fias_guid := _data.nm_fias_guid::uuid  --  NOT NULL              
         );
         ----------------------------------------------------------------------  
       
         _r_upd := _r_upd + 1; 
       END LOOP;           
 
    total_row := _r_upd;
    upd_row := (SELECT count(1) FROM gar_tmp.adr_stead_aux WHERE (op_sign = UPD_OP));
    
    RETURN NEXT;      
   END;                   
  $$;
 
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_stead_upd (text, text, text, uuid[])
IS 'Обновление адресных свойств домов';
----------------------------------------------------------------------------------
-- USE CASE:
-- SELECT gar_tmp_pcg_trans.f_adr_stead_upd ('unsi'); 
-- SELECT * from gar_tmp.obj_seq;
-- SELECT * FROM unsi.adr_stead WHERE (id_stead > 50000000);
-- SELECT * FROM unsi.adr_objects WHERE (id_object > 50000000);
-- DELETE FROM unsi.adr_stead WHERE (id_stead > 50000000);
-- DELETE FROM unsi.adr_objects WHERE (id_object > 50000000);
-- SELECT * FROM gar_tmp_pcg_trans.f_adr_stead_show (2);
