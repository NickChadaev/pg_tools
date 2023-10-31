DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_update_children (uuid, uuid, date);
DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_update_children (date, integer[], uuid[], date);
DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_update_children (date, integer[], uuid[], date);

DROP FUNCTION IF EXISTS gar_fias_pcg_load.f_addr_obj_update_children (date);
CREATE OR REPLACE FUNCTION gar_fias_pcg_load.f_addr_obj_update_children (
         p_date_2  date  = current_date  -- Текущая дата (передаётся как параметр ??)
         --
        ,OUT fias_guid_new    uuid         -- UUID актуального объекта.
        ,OUT fias_guid_old    uuid         -- UUID объекта-дубля 
        ,OUT nm_addr_obj      varchar(250) -- Наименование адресного объекта. 
        ,OUT addr_obj_type_id bigint       -- Тип адрессного объекта.
        ,OUT chld_qty_tot     integer      -- Общее количество подчинённых объектов 
        ,OUT obj_level        bigint       -- Уровень адресного  объекта
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
                  ,obj_level
         ) AS 
           (
             -- Выбираю записи, принадлежание обрабатываемой дате.
             SELECT  x.id_addr_obj
                    ,x.id_addr_parent
                    ,upper(x.nm_addr_obj)
                    ,x.addr_obj_type_id
                    ,x.date_create
                    ,x.id_lead
                    ,x.obj_level
                   
                  FROM gar_fias.gap_adr_area x WHERE (x.date_create = p_date_2) 
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
                   , z.obj_level
              FROM z
                JOIN gar_fias.gap_adr_area a ON (z.id_lead = a.id_addr_obj) AND  (z.date_create = a.date_create)
                JOIN gar_fias.gap_adr_area b ON (z.id_lead <> b.id_addr_obj) AND (b.date_create = z.date_create) AND
                                                (z.id_addr_parent = b.id_addr_parent)  AND
                                                (z.nm_addr_obj = upper(b.nm_addr_obj)) AND
                                                (z.addr_obj_type_id = b.addr_obj_type_id)                                               
                                                		  
      LOOP
        -- 0) Заменяю старого родителя на нового
        chld_qty_tot := gar_fias_pcg_load.f_addr_obj_update_parent (
                            _rec_one.fias_guid_old, _rec_one.fias_guid_new, p_date_2
        );
          
        -- 1) Старого родителя убрать: (p_date_2 - interval '1 year');
          
        UPDATE gar_fias.as_addr_obj SET end_date = (p_date_2 - interval '1 year')
           WHERE (object_guid = _rec_one.fias_guid_old);
        --
        -- 2) Теперь запоминаю детей-двойников, связанных с актуальным родитеделем.
        --
        INSERT INTO gar_fias.twin_addr_objects AS k(

                        fias_guid_new
                       ,fias_guid_old
                       ,obj_level  
                       ,date_create
        )
           WITH x (
                     id_addr_obj_new
                    ,id_addr_obj_old 
          )      
            AS (
                   SELECT DISTINCT id_lead, min(id_addr_obj) OVER (PARTITION BY id_lead) 
                     FROM gar_fias_pcg_load.f_adr_area_show_data (
                                                         p_fias_guid := _rec_one.fias_guid_new
                                                        ,p_qty := 1
                  )
               )
                 SELECT z1.object_guid  AS fias_guid_new 
                       ,z2.object_guid  AS fias_guid_old 
                       ,z1.obj_level 
                       ,p_date_2
                 FROM x
                   INNER JOIN gar_fias.as_addr_obj z1 ON (z1.object_id = x.id_addr_obj_new)
                   INNER JOIN gar_fias.as_addr_obj z2 ON (z2.object_id = x.id_addr_obj_old)

        ON CONFLICT ON CONSTRAINT pk_twin_adr_objects DO NOTHING;
        
        fias_guid_new    := _rec_one.fias_guid_new;
        fias_guid_old    := _rec_one.fias_guid_old;
        nm_addr_obj      := _rec_one.nm_addr_obj; 
        addr_obj_type_id := _rec_one.addr_obj_type_id;
        obj_level        := _rec_one.obj_level;
        
        RETURN NEXT;
      END LOOP;
  END;
 $$;

COMMENT ON FUNCTION gar_fias_pcg_load.f_addr_obj_update_children (date) IS 
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
-- BEGIN;
-- SELECT * FROM gar_fias_pcg_load.f_addr_obj_update_children (current_date);
-- -- SELECT gar_fias_pcg_load."_NEW_f_addr_obj_update_parent" ('d2f48256-c10a-4806-b281-9b5b85d56616','21ab76d1-fab6-4b4f-a4dc-4871a93b7aab'); -- 2
-- SELECT a.* FROM gar_fias.as_addr_obj a WHERE (a.object_guid = '21ab76d1-fab6-4b4f-a4dc-4871a93b7aab') ; -- 81637
-- SELECT a.* FROM gar_fias.as_addr_obj a WHERE (a.object_guid = 'd2f48256-c10a-4806-b281-9b5b85d56616') ; -- 81317
-- 
-- SELECT * FROM gar_fias.as_adm_hierarchy where parent_obj_id = 82811 
--     UNION ALL
-- SELECT * FROM gar_fias.as_adm_hierarchy where parent_obj_id = 82471 ;
-- 
-- SELECT * FROM gar_fias_pcg_load."_NEW_f_adr_area_show_data" (p_fias_guid := NULL::uuid, p_qty := 1) ;
-- ROLLBACK;
-- -----------------------------------------------------------------------------------------------------
-- "fias_guid_new"	"fias_guid_old"	"nm_addr_obj"	"addr_obj_type_id"	"chld_qty_tot"
-- "21ab76d1-fab6-4b4f-a4dc-4871a93b7aab"	"d2f48256-c10a-4806-b281-9b5b85d56616"	"АЗОВСКАЯ"	204	2
-- "29efff6b-23d5-48e4-9c02-cadc513ea35e"	"80513d5c-ebf2-4f4f-a9ec-2c3356329c09"	"ВТОРАЯ"	204	6
-- "59e94457-ed1a-49cf-b83c-868514f98244"	"8418d308-bf4a-4d5f-a7a4-5d46032692c5"	"ШИДИБ"	103	0
-- "8b87e6c4-617a-4d32-9414-fada8d0d3e8b"	"bb301a7c-c4f5-4c00-a564-b4854377bfbb"	"БУДЕННОВСКАЯ"	204	15
-- "8b87e6c4-617a-4d32-9414-fada8d0d3e8b"	"ddf6a4e7-5207-42fd-8af3-89c905d0f368"	"БУДЕННОВСКАЯ"	204	0
-- "bd784bc1-152d-4896-bf9b-98701702f3ce"	"6e876e17-68a5-4d63-b078-1dc2202c7173"	"ЦЕНТРАЛЬНАЯ"	204	30
-- "ec6c88c3-053b-46cf-ac3b-3e5fecad8b2a"	"a669b619-6016-48be-8564-e05ccac82a4a"	"САДОВАЯ"	204	0
