DROP FUNCTION IF EXISTS gar_fias_pcg_load."_NEW_f_addr_obj_update_children" (date, integer[], uuid[], date);
CREATE OR REPLACE FUNCTION gar_fias_pcg_load."_NEW_f_addr_obj_update_children" (
         p_date_1     date                      -- Обрабатываемвя дата
        ,p_obj_level  integer[] = ARRAY[6,7]    -- Уровни адресных объектов
        ,p_fias_guid  uuid[]    = NULL::uuid[]  -- Выбранные UUID, опционально
        ,p_date_2     date      = current_date  -- Текущая дата (передаётся как параметр ??)
         --
        ,OUT fias_guid_new    uuid         -- UUID актуального объекта.
        ,OUT fias_guid_old    uuid         -- UUID объекта-дубля 
        ,OUT nm_addr_obj      varchar(250) -- Наименование адресного объекта. 
        ,OUT addr_obj_type_id bigint       -- Тип адрессного объекта.
        ,OUT chld_qty_tot     integer      -- Общее количество подчинённых объектов 
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
    --   2023-10-27  Перестройка подчинеия, всё подчиняется самому новому родителю
    -- ================================================================================
  DECLARE
    _rec_one record; 
    
  BEGIN
    -- ------------------------------------------------------------------------------
    -- Цикл по таблице ошибок. Парные записи, вначале новый адресный объект, потом старый. 
    -- Должны совпадать: id_addr_parent, upper(nm_addr_obj), addr_obj_type_id.
    -- Далее обработка (пункты 0,1). 
    -- -----------------------------------------------------------------------------
    FOR _rec_one IN 
         WITH z (  id_addr_obj
                  ,id_addr_parent
                  ,nm_addr_obj
                  ,addr_obj_type_id
                  ,date_create
                  ,id_lead
         ) AS 
           (
             -- Выбираю записи, принадлежание обрабатываемой дате.
             SELECT  x.id_addr_obj
                    ,x.id_addr_parent
                    ,upper(x.nm_addr_obj)
                    ,x.addr_obj_type_id
                    ,x.date_create
                    ,x.id_lead
                   
                  FROM gar_fias.gap_adr_area x WHERE (x.date_create = p_date_1) 
              ORDER BY  x.nm_addr_obj, x.id_addr_obj DESC     
            )
            
              SELECT DISTINCT ON (a.fias_guid, b.fias_guid)
                     a.fias_guid AS fias_guid_new
                   , b.fias_guid AS fias_guid_old 
                   , z.id_lead
                   , z.id_addr_parent  
                   , z.nm_addr_obj 
                   , z.addr_obj_type_id              
                   , z.id_addr_obj AS id_addr_obj_new
                   , b.id_addr_obj AS id_addr_obj_old
              FROM z
                JOIN gar_fias.gap_adr_area a ON (z.id_lead = a.id_addr_obj) AND  (z.date_create = a.date_create)
                JOIN gar_fias.gap_adr_area b ON (z.id_lead <> b.id_addr_obj) AND (b.date_create = z.date_create) AND
                                                (z.id_addr_parent = b.id_addr_parent)  AND
                                                (z.nm_addr_obj = upper(b.nm_addr_obj)) AND
                                                (z.addr_obj_type_id = b.addr_obj_type_id)                                               
                                                		  
      LOOP
        -- 0) Заменяю старого родителя на нового
        chld_qty_tot := gar_fias_pcg_load."_NEW_f_addr_obj_update_parent" (
                            _rec_one.fias_guid_old, _rec_one.fias_guid_new, p_date_2
        );
          
        -- 1) Старого родителя убрать: (p_date_2 - interval '1 year');
          
        UPDATE gar_fias.as_addr_obj SET end_date = (p_date_2 - interval '1 year')
           WHERE (object_guid = _rec_one.fias_guid_old);
        
        fias_guid_new    := _rec_one.fias_guid_new;
        fias_guid_old    := _rec_one.fias_guid_old;
        nm_addr_obj      := _rec_one.nm_addr_obj; 
        addr_obj_type_id := _rec_one.addr_obj_type_id;
        
        RETURN NEXT;
      END LOOP;
  END;
 $$;

COMMENT ON FUNCTION gar_fias_pcg_load."_NEW_f_addr_obj_update_children" (date, integer[], uuid[], date) IS 
'ТОЛЬКО АКТИВНЫЕ И АКТУАЛЬНЫЕ ОБЪЕКТЫ. Модификация отношения подчинённости в схеме gar_fias,
с дективацией более ранних объектов.';
-- -------------------------------------------------------------------------------------
-- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_obj_level"
-- ЗАМЕЧАНИЕ:  warning extra:00000:unused parameter "p_fias_guid"
-- ЗАМЕЧАНИЕ:  FUNCTION | 247238 | gar_fias_pcg_load | _NEW_f_addr_obj_update_parent | (uuid,uuid,date)
-- ЗАМЕЧАНИЕ:  RELATION | 246157 | gar_fias | as_addr_obj
-- ЗАМЕЧАНИЕ:  RELATION | 246282 | gar_fias | gap_adr_area
-- Query returned successfully with no result in 41 msec.
--
--  USE CASE:
--
BEGIN;
SELECT * FROM gar_fias_pcg_load."_NEW_f_addr_obj_update_children" (current_date);
-- SELECT gar_fias_pcg_load."_NEW_f_addr_obj_update_parent" ('d2f48256-c10a-4806-b281-9b5b85d56616','21ab76d1-fab6-4b4f-a4dc-4871a93b7aab'); -- 2
SELECT a.* FROM gar_fias.as_addr_obj a WHERE (a.object_guid = '21ab76d1-fab6-4b4f-a4dc-4871a93b7aab') ; -- 81637
SELECT a.* FROM gar_fias.as_addr_obj a WHERE (a.object_guid = 'd2f48256-c10a-4806-b281-9b5b85d56616') ; -- 81317

SELECT * FROM gar_fias.as_adm_hierarchy where parent_obj_id = 81637 
    UNION ALL
SELECT * FROM gar_fias.as_adm_hierarchy where parent_obj_id = 81317 ;

SELECT * FROM gar_fias_pcg_load."_NEW_f_adr_area_show_data" (p_fias_guid := NULL::uuid, p_qty := 1) ;
ROLLBACK;