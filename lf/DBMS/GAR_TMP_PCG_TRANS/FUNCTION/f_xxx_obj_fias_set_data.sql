DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_fias_set_data (text, text, text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_set_data (
       p_adr_area_sch     text -- Отдалённая/Локальная схема для хранения адресных областей
      ,p_adr_street_sch   text -- Отдалённая/Локальная схема для хранения улиц
      ,p_adr_house_sch    text -- Отдалённая/Локальная схема для хранения домов/строений
       --
      ,OUT rr integer -- Количество вставленных записей
)
    RETURNS SETOF integer
    LANGUAGE plpgsql
    SECURITY DEFINER
 AS
  $$
    -- -------------------------------------------------------------------------------
    --   2022-03-18. Заполнение управляющей таблицы. Несколько топорно.
    -- -------------------------------------------------------------------------------
    BEGIN
      TRUNCATE TABLE gar_tmp.xxx_obj_fias;
      --
      --  0)  ADR_AREAs
      --
     -- SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 ('unnsi'); -- 8653 rows, 
      INSERT INTO gar_tmp.xxx_obj_fias AS x0 
           SELECT  
                   id_obj      
                  ,id_obj_fias 
                  ,obj_guid    
                  ,type_object 
                  ,tree_d      
                  ,level_d     
                  
           FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 (p_adr_area_sch) 
           
      ON CONFLICT (obj_guid) DO UPDATE 
                             SET 
                                 id_obj      = excluded.id_obj     
                                ,id_obj_fias = excluded.id_obj_fias
                                ,type_object = excluded.type_object
                                ,tree_d      = excluded.tree_d     
                                ,level_d     = excluded.level_d    
                                
                             WHERE (x0.obj_guid = excluded.obj_guid); -- unnsi
      
      GET DIAGNOSTICS rr = ROW_COUNT;
      RETURN NEXT;
      --
      --  1)  Adr_streets
      --
      -- SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 ('unnsi'); -- 21046
      INSERT INTO gar_tmp.xxx_obj_fias AS x1
            SELECT 
                   id_obj      
                  ,id_obj_fias 
                  ,obj_guid    
                  ,type_object 
                  ,tree_d      
                  ,level_d     
            
            FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 (p_adr_street_sch)
            
      ON CONFLICT (obj_guid) DO UPDATE 
                             SET 
                                 id_obj      = excluded.id_obj     
                                ,id_obj_fias = excluded.id_obj_fias
                                ,type_object = excluded.type_object
                                ,tree_d      = excluded.tree_d     
                                ,level_d     = excluded.level_d    
                                
                             WHERE (x1.obj_guid = excluded.obj_guid); -- unnsi
       
      GET DIAGNOSTICS rr = ROW_COUNT;
      RETURN NEXT;  
      --
      -- 2) Houses
      --
      -- SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 ('unnsi'); -- 96167   5 min
      INSERT INTO gar_tmp.xxx_obj_fias AS x2
            SELECT  
                   id_obj      
                  ,id_obj_fias 
                  ,obj_guid    
                  ,type_object 
                  ,tree_d      
                  ,level_d     
            
            FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 (p_adr_house_sch) -- 'unnsi' 2022-01-28
      ON CONFLICT (obj_guid) DO UPDATE 
                             SET 
                                 id_obj      = excluded.id_obj     
                                ,id_obj_fias = excluded.id_obj_fias
                                ,type_object = excluded.type_object
                                ,tree_d      = excluded.tree_d     
                                ,level_d     = excluded.level_d    
                                
                             WHERE (x2.obj_guid = excluded.obj_guid); -- unnsi
            
      GET DIAGNOSTICS rr = ROW_COUNT;
      RETURN NEXT;       
            
    END;
  $$;
  
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_obj_fias_set_data (text, text, text)
                       IS 'Загрузка данных в таблицу, управляющую последующей обработкой';  
-- ----------------------------------------------------------------------------------------
-- USE CASE:
--       SELECT gar_link.f_server_is ('unnsi');   -- unsi_l
--       SELECT gar_link.f_server_is ('unsi');    -- unsi_l
--       SELECT gar_tmp_pcg_trans.f_xxx_obj_fias_set_data ('unnsi', 'unnsi', 'gar_tmp');
-- ---------------------------------------------------------------------------------------
--            Далее важно - распределение данных в рабочих таблицах.  
-- ---------------------------------------------------------------------------------------           
--            SELECT COUNT(1), type_object FROM gar_tmp.xxx_obj_fias
--                  WHERE (id_obj IS NULL) GROUP BY type_object ORDER BY 2;
--
--            SELECT COUNT(1), type_object FROM gar_tmp.xxx_obj_fias
--                  GROUP BY type_object ORDER BY 2;
-- --            
--             count	type_object
--                418	       0
--               5611	       1
--              96167          2   
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_0 ('unnsi'); -- 418
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_1 ('unnsi'); -- 5615
-- SELECT * FROM gar_tmp_pcg_trans.f_xxx_obj_fias_show_data_2 ('gar_tmp'); --  96167
-- -----------------------------------------------------------------------
