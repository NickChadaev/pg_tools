DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_update_children (uuid, uuid, date);

DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_update_children (date, integer[], uuid[], date);
CREATE OR REPLACE FUNCTION gar_fias_pcg_load.f_addr_obj_update_children (
         p_date_1     date                      -- Обрабатываемвя дата
        ,p_obj_level  integer[] = ARRAY[6,7]    -- Уровни адресных объектов
        ,p_fias_guid  uuid[]    = NULL::uuid[]  -- Выбранные UUID, опционально
        ,p_date_2     date      = current_date  -- Текущая дата (передаётся как параметр ??)
         --
        ,OUT fias_guid_new    uuid         -- UUID актуального объекта.
        ,OUT nm_addr_obj      varchar(250) -- Наименование адресного объекта. 
        ,OUT addr_obj_type_id bigint       -- Тип адрессного объекта.
        ,OUT chld_qty_tot     integer      -- Общее количество подчинённых объектов 
        ,OUT chld_qty_unact   integer      -- Неактуальные.
  )
    RETURNS setof record
    LANGUAGE plpgsql 
    SECURITY DEFINER
    AS $$
    -- ================================================================================
    -- Author: Nick
    -- Create date: 2022-08-31/2022-09-01
    -- -------------------------------------------------------------------------------- 
    -- Модификация отношения подчинённости в схеме gar_fias.
    --      Для выбранного родителя, оставляю актуальных детей.
    -- ================================================================================
  DECLARE
    _rec_one record; 
    
  BEGIN
    -- ------------------------------------------------------------------------------
    -- Цикл по таблице ошибок. (obj_level IN (6,7)). Парные записи, вначале новый 
    --   адресный объект, потом старый. 
    -- Должны совпадать: id_addr_parent, upper(nm_addr_obj), addr_obj_type_id.
    -- Далее обработка (пункты 0,1,2). 
    -- -----------------------------------------------------------------------------
  
    FOR _rec_one IN 
     WITH z (  change_id
              ,id_addr_parent
              ,nm_addr_obj
              ,addr_obj_type_id
              ,date_create
         ) AS 
           (
             -- Выбираю записи, принадлежание обрабатываемой дате.
             SELECT  MAX(x.change_id) AS change_id
                    ,x.id_addr_parent
                    ,upper(x.nm_addr_obj)
                    ,x.addr_obj_type_id
                    ,x.date_create
                   
                  FROM gar_fias.gap_adr_area x 
                    WHERE (x.obj_level = ANY(p_obj_level)) AND 
                          (x.date_create = p_date_1) AND
                          (((x.fias_guid = ANY (p_fias_guid)) AND (p_fias_guid IS NOT NULL))
                             OR (p_fias_guid IS NULL)
                          )	                                  
                   GROUP BY x.id_addr_parent
                          ,upper(x.nm_addr_obj)
                          ,x.addr_obj_type_id
                          ,x.date_create 
            )
              SELECT a.fias_guid AS fias_guid_new
                   , b.fias_guid AS fias_guid_old 
                   , z.id_addr_parent  
                   , a.nm_addr_obj 
                   , z.addr_obj_type_id              
                   , z.change_id AS change_id_new
                   , b.change_id AS change_id_old
              FROM z
                JOIN gar_fias.gap_adr_area a ON (z.id_addr_parent = a.id_addr_parent)  AND
                                                (z.nm_addr_obj = upper(a.nm_addr_obj)) AND
                                                (z.addr_obj_type_id = a.addr_obj_type_id) AND
                                                (z.change_id = a.change_id) AND
                                                (z.date_create = a.date_create)
                 --                                
                JOIN gar_fias.gap_adr_area b ON (z.id_addr_parent = b.id_addr_parent)  AND
                                                (z.nm_addr_obj = upper(b.nm_addr_obj)) AND
                                                (z.addr_obj_type_id = b.addr_obj_type_id) AND
												(b.date_create = z.date_create) AND                                                 
                                                (z.change_id > b.change_id)		  

      LOOP
          -- 0) Заменяю старого родителя на нового
          chld_qty_tot := gar_fias_pcg_load.f_addr_obj_update_parent (
                            _rec_one.fias_guid_old, _rec_one.fias_guid_new, p_date_2
          );
          
          -- 1) Старого родителя убрать: is actual, is_active <---- FALSE.
          UPDATE gar_fias.as_addr_obj SET is_actual = FALSE, is_active = FALSE
           WHERE (object_guid = _rec_one.fias_guid_old);
         
          -- 2) Убрать неактуальных детей. (id_lead IS not NULL) убрать is actual, is_active <---- FALSE.
          WITH z (id_addr_obj)
              AS (
                   SELECT id_addr_obj 
                       FROM gar_fias_pcg_load.f_adr_area_show_data (_rec_one.fias_guid_new)
                              WHERE (id_lead IS not NULL)
                 )
             UPDATE gar_fias.as_addr_obj x SET is_actual = FALSE, is_active = FALSE
              FROM z
                      WHERE (x.object_id = z.id_addr_obj);
        
        GET DIAGNOSTICS chld_qty_unact = ROW_COUNT;
        
        fias_guid_new    := _rec_one.fias_guid_new;
        nm_addr_obj      := _rec_one.nm_addr_obj; 
        addr_obj_type_id := _rec_one.addr_obj_type_id;
        
        RETURN NEXT;
      END LOOP;
  END;
 $$;

COMMENT ON FUNCTION gar_fias_pcg_load.f_addr_obj_update_children (date, integer[], uuid[], date) IS 
'ТОЛЬКО АКТИВНЫЕ И АКТУАЛЬНЫЕ ОБЪЕКТЫ. Модификация отношения подчинённости в схеме gar_fias,
с дективацией более ранних объектов.';
--
--  USE CASE:
--
