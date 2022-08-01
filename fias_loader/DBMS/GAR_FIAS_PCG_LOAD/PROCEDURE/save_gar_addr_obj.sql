DROP PROCEDURE IF EXISTS gar_fias_pcg_load.save_gar_addr_obj (bigint, bigint, uuid, bigint, character varying, character varying, bigint, bigint, bigint, bigint, date, date, date, boolean, boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.save_gar_addr_obj (
                            i_id           gar_fias.as_addr_obj.id%TYPE           
                           ,i_object_id    gar_fias.as_addr_obj.object_id%TYPE
                           ,i_object_guid  gar_fias.as_addr_obj.object_guid%TYPE
                           ,i_change_id    gar_fias.as_addr_obj.change_id%TYPE
                           ,i_object_name  gar_fias.as_addr_obj.object_name%TYPE
                           ,i_type_name    gar_fias.as_addr_obj.type_name%TYPE
                           ,i_obj_level    gar_fias.as_addr_obj.obj_level%TYPE
                           ,i_oper_type_id gar_fias.as_addr_obj.oper_type_id%TYPE
                           ,i_prev_id      gar_fias.as_addr_obj.prev_id%TYPE
                           ,i_next_id      gar_fias.as_addr_obj.next_id%TYPE
                           ,i_update_date  gar_fias.as_addr_obj.update_date%TYPE
                           ,i_start_date   gar_fias.as_addr_obj.start_date%TYPE
                           ,i_end_date     gar_fias.as_addr_obj.end_date%TYPE
                           ,i_is_actual    gar_fias.as_addr_obj.is_actual%TYPE
                           ,i_is_active    gar_fias.as_addr_obj.is_active%TYPE
                           
)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_fias, public
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-07
    -- Updates:  2021-10-28 Модификация под загрузчик ГИС Интеграция.
    --           2022-01-26 Неоднозность в определении типов
    -- ----------------------------------------------------------------------------------------------------  
    -- Загрузка классификатора адресных объектов. Источник: внешний парсер.
    --  Предварительно должны быть загружены: "as_operation_type", "as_reestr_objects", "as_object_level".
    --  Два этапа выполнения: 1) собственно загрузка, 2) обновление столбца "type_id".
    --  Для второго эапа должна быть загружена таблица "gar_fias.as_addr_obj_type".
    --  Дополнительные параметры адресного объекта грузятся после загрузки основного объекта "as_addr_obj",
    --     (таблица "gar_fias.as_addr_obj_params").
    -- ====================================================================================================
   
    BEGIN
        INSERT INTO gar_fias.as_addr_obj AS i (
        
                            id            
                           ,object_id    
                           ,object_guid  
                           ,change_id    
                           ,object_name  
                           ,type_name    
                           ,obj_level    
                           ,oper_type_id 
                           ,prev_id      
                           ,next_id      
                           ,update_date  
                           ,start_date   
                           ,end_date     
                           ,is_actual    
                           ,is_active    
        )
          VALUES (
                            i_id          
                           ,i_object_id   
                           ,i_object_guid 
                           ,i_change_id   
                           ,i_object_name 
                           ,i_type_name   
                           ,i_obj_level   
                           ,i_oper_type_id
                           ,i_prev_id     
                           ,i_next_id     
                           ,i_update_date 
                           ,i_start_date  
                           ,i_end_date    
                           ,i_is_actual   
                           ,i_is_active   
                 )
                 ON CONFLICT (id) DO 
                    UPDATE 
                         SET 
                            object_id    = excluded.object_id   
                           ,object_guid  = excluded.object_guid 
                           ,change_id    = excluded.change_id   
                           ,object_name  = excluded.object_name 
                           ,type_name    = excluded.type_name   
                           ,obj_level    = excluded.obj_level   
                           ,oper_type_id = excluded.oper_type_id
                           ,prev_id      = excluded.prev_id     
                           ,next_id      = excluded.next_id     
                           ,update_date  = excluded.update_date 
                           ,start_date   = excluded.start_date  
                           ,end_date     = excluded.end_date    
                           ,is_actual    = excluded.is_actual   
                           ,is_active    = excluded.is_active   
                    
                    WHERE (i.id = excluded.id);
        --
        WITH x AS (
                    SELECT z.id, z.type_shortname 
                        FROM gar_fias.as_addr_obj_type z WHERE (z.type_shortname = i_type_name) AND 
               			      (z.end_date > current_date) AND (	z.type_level::bigint = i_obj_level)            
        )
        UPDATE gar_fias.as_addr_obj u SET type_id = x.id 
           FROM x  
                 WHERE (u.type_name = x.type_shortname) AND (u.id = i_id);
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.save_gar_addr_obj (bigint, bigint, uuid, bigint, character varying, character varying, bigint, bigint, bigint, bigint, date, date, date, boolean, boolean)
     OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.save_gar_addr_obj (bigint, bigint, uuid, bigint, character varying, character varying, bigint, bigint, bigint, bigint, date, date, date, boolean, boolean)
     IS 'Загрузка классификатора адресообразующих элементов';
--
--  USE CASE:
-- --------------------------------------------------------------------------------------------
