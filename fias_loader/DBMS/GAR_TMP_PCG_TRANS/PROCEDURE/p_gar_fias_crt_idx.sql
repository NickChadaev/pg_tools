DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_gar_fias_crt_idx (p_sw boolean);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_gar_fias_crt_idx (p_sw boolean = TRUE)

    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias, public

 AS 
   $$
    -- -------------------------------------------------------------------------------
    --    2021-11-25/2021-12-09/2022-04-12/2022-07-12/2022-09-05
    --        Nick. Управление индексами в схеме "gar_fias"
    --   2023-10-13 Изменён первый блок. Далее для "as_addr_obj",  "as_adm_hierarchy", 
    --                                            "as_houses".
    --   2023-10-31 Изменён последний блок
    -- -------------------------------------------------------------------------------
    --     p_sw boolean = TRUE  - удаление и создание индексов
    --                    FALSE - только удаление
    -- -------------------------------------------------------------------------------
     BEGIN
       -- 
       -- 2023-10-13
       
       DROP INDEX IF EXISTS ie1_as_object_level;
       DROP INDEX IF EXISTS ie1_as_addr_obj;       -- см. 2022-07-12, 2022-09-05
       DROP INDEX IF EXISTS ie1_as_adm_hierarchy;  -- см. 2022-09-05
       DROP INDEX IF EXISTS ie1_as_mun_hierarchy;
       DROP INDEX IF EXISTS ie1_as_houses;         -- см. 2022-04-12
       --
       IF (p_sw) THEN
      --
            CREATE INDEX ie1_as_object_level  ON gar_fias.as_object_level (end_date);
            CREATE INDEX ie1_as_addr_obj      ON gar_fias.as_addr_obj (end_date);
            CREATE INDEX ie1_as_adm_hierarchy ON gar_fias.as_adm_hierarchy (parent_obj_id);
            CREATE INDEX ie1_as_mun_hierarchy ON gar_fias.as_mun_hierarchy (parent_obj_id); 
            CREATE INDEX ie1_as_houses        ON gar_fias.as_houses (end_date); 
       
       END IF;
       --
       --
       DROP INDEX IF EXISTS ie1_as_addr_obj_params;   
       DROP INDEX IF EXISTS ie1_as_apartments_params; 
       DROP INDEX IF EXISTS ie1_as_carplaces_params;  
       DROP INDEX IF EXISTS ie1_as_houses_params;     
       DROP INDEX IF EXISTS ie1_as_rooms_params;      
       DROP INDEX IF EXISTS ie1_as_steads_params;     
       --
       IF (p_sw) THEN
       
            CREATE INDEX ie1_as_addr_obj_params   
                        ON gar_fias.as_addr_obj_params (type_id, start_date, end_date);
            --                 
            CREATE INDEX ie1_as_apartments_params 
                        ON gar_fias.as_apartments_params (type_id, start_date, end_date);
            --                 
            CREATE INDEX ie1_as_carplaces_params  
                        ON gar_fias.as_carplaces_params (type_id, start_date, end_date);
            --                 
            CREATE INDEX ie1_as_houses_params     
                        ON gar_fias.as_houses_params (type_id, start_date, end_date);
            --                 
            CREATE INDEX ie1_as_rooms_params      
                        ON gar_fias.as_rooms_params (type_id, start_date, end_date);
            --                 
            CREATE INDEX ie1_as_steads_params     
                        ON gar_fias.as_steads_params (type_id, start_date, end_date);
       END IF;	
       --
       --  2022-04-12/2023-10-13
       --
       DROP INDEX IF EXISTS gar_fias.iex_as_houses; 
       DROP INDEX IF EXISTS gar_fias.iex_as_steads; 
       DROP INDEX IF EXISTS gar_fias.ie1_as_steads;
       DROP INDEX IF EXISTS gar_fias.ie1_as_reestr_objects; -- !!!! Фигня
       DROP INDEX IF EXISTS gar_fias.ie1_as_operation_type;
       DROP INDEX IF EXISTS gar_fias.ie1_as_addr_obj_type;       
      
       IF (p_sw) THEN
       
         -- 2023-10-13
         CREATE INDEX iex_as_houses ON gar_fias.as_houses USING hash (object_guid);
         CREATE INDEX iex_as_steads ON gar_fias.as_steads USING hash (object_guid);
         CREATE INDEX ie1_as_steads ON gar_fias.as_steads USING btree (end_date);
         -- 2023-10-13
         --
         CREATE INDEX ie1_as_operation_type
             ON gar_fias.as_operation_type USING btree
                 (end_date ASC NULLS LAST, start_date ASC NULLS LAST)
          WHERE is_active;    
         --
         CREATE INDEX ie1_as_addr_obj_type
          ON gar_fias.as_addr_obj_type USING btree
            (end_date ASC NULLS LAST, start_date ASC NULLS LAST)
          WHERE is_active;          
         --       
         CREATE INDEX ie1_as_reestr_objects
             ON gar_fias.as_reestr_objects USING btree
                 (object_id ASC NULLS LAST) WHERE is_active;
       END IF;
       --
       -- 2022-07-12/2023-10-13
       --
       DROP INDEX IF EXISTS ie2_as_addr_obj;
       --
       IF (p_sw) THEN
       
         CREATE INDEX IF NOT EXISTS ie2_as_addr_obj 
             ON gar_fias.as_addr_obj  USING btree (upper(object_name));  
                  -- WHERE (is_actual AND is_active); 
                   
       END IF;
       --
       -- 2022-09-05/2023-10-13/2023-1031
       --
       DROP INDEX IF EXISTS ie1_gap_adr_area;
       DROP INDEX IF EXISTS ie2_gap_adr_area;
       DROP INDEX IF EXISTS ie3_as_addr_obj ;
       DROP INDEX IF EXISTS ie4_as_addr_obj ; -- Дубль  2023-10-13
       DROP INDEX IF EXISTS ie2_as_adm_hierarchy; 
       
       IF (p_sw) THEN
       
           CREATE INDEX IF NOT EXISTS ie1_gap_adr_area ON gar_fias.gap_adr_area 
                   USING btree (id_addr_parent, upper(nm_addr_obj), addr_obj_type_id, change_id);
           --
           CREATE INDEX IF NOT EXISTS ie2_gap_adr_area ON gar_fias.gap_adr_area 
                   USING btree (obj_level);
           --
           CREATE INDEX IF NOT EXISTS ie3_as_addr_obj ON gar_fias.as_addr_obj    -- ???
                   USING btree (object_guid); 
           -- 
           -- CREATE INDEX IF NOT EXISTS ie4_as_addr_obj ON gar_fias.as_addr_obj  --Дубль
           --         USING btree (end_date, start_date) WHERE (is_actual AND is_active);
           -- 
           -- CREATE INDEX IF NOT EXISTS ie2_as_adm_hierarchy ON gar_fias.as_adm_hierarchy 
           --         USING btree (end_date, start_date) WHERE (is_active); -- Потенциальная ошибка в
           --         -- функциях -- отображения ?? Сейчас только одно условие:  
           --        -- признак активности IS TRUE 
           -- --   
           CREATE INDEX IF NOT EXISTS ie2_as_adm_hierarchy ON gar_fias.as_adm_hierarchy 
                                     USING btree (end_date); 
                                     
           CREATE INDEX IF NOT EXISTS ie3_as_adm_hierarchy ON gar_fias.as_adm_hierarchy 
                                     USING btree (object_id); 
                  
       END IF;
       
     END;
 $$;
  
ALTER PROCEDURE gar_tmp_pcg_trans.p_gar_fias_crt_idx (boolean) OWNER TO postgres;  

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_gar_fias_crt_idx (boolean) 
IS 'Управление индексами в схеме "gar_fias"';

--  CALL gar_tmp_pcg_trans.p_gar_fias_crt_idx (FALSE); 
--  CALL gar_tmp_pcg_trans.p_gar_fias_crt_idx (); -- Query returned successfully in 3 min 48 secs.
