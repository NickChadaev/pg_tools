--   qty    id_house_type_1	nm_house_type	nm_house_type_short
--   249240 2               Дом	д.
--   8707   5               Строение	стр.
--   2924   1               Владение	вл.
--   2890   8               Здание	зд.
--   2198   3               Домовладение	дв.
--   294    9               Гараж	г-ж
--   170    6               Сооружение	соор.
--   104    NULL           NULL	NULL
--   7      1005           NULL	NULL
--   5      4	           Корпус	корп.

BEGIN;
 --     
 --  1) Создать в adr_house_aux   UPDATE
 --
 WITH a0 AS (
             SELECT h.id_house AS id_obj FROM gar_tmp.adr_house h WHERE (h.id_house_type_1 > 1000)
                UNION 
             SELECT h.id_house AS id_obj FROM gar_tmp.adr_house h WHERE (h.id_house_type_2 > 1000)
                UNION 
             SELECT h.id_house AS id_obj FROM gar_tmp.adr_house h WHERE (h.id_house_type_3 > 1000)
      )
      ,a1 AS (
              INSERT INTO gar_tmp.adr_house_aux (id_house, op_sign)
               SELECT a0.id_obj, 'U' FROM a0 
                 ON CONFLICT (id_house) DO UPDATE SET op_sign = 'U'
                    WHERE (gar_tmp.adr_house_aux.id_house = excluded.id_house)                  
              RETURNING * 
             )  
       SELECT a1.* FROM a1 ORDER BY 1;
 --
 -- 2) Вытащить и обновить TYPE_1  
 --
 WITH ax1 AS (    
              SELECT h.id_house
                ,h.id_area
                ,upper(h.nm_house_full::text) AS nm_house_full
                ,h.id_street
                ,h.id_house_type_1                
                 --                
                ,a.house_type_id
                ,(gar_tmp_pcg_trans.f_xxx_replace_char (a.type_name)) AS fias_row_key
                
              FROM gar_tmp.adr_house h 
                        JOIN gar_fias.as_house_type a ON ((h.id_house_type_1 - 1000) = a.house_type_id)  
              WHERE (h.id_house_type_1 > 1000)
  )
   , az1 AS (SELECT ax1.id_house, x.id_house_type FROM ax1
              JOIN gar_tmp.adr_house_type x 
                  ON (ax1.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char(x.nm_house_type))
              WHERE (NOT EXISTS (SELECT 1 FROM gar_tmp.adr_house 
                                  WHERE ((id_area = ax1.id_area) AND 
                                         (upper(nm_house_full) = ax1.nm_house_full) AND
                                         (id_street IS NOT DISTINCT FROM ax1.id_street) AND 
                                         (id_house_type_1 IS NOT DISTINCT FROM x.id_house_type)
                                        )
                                )
                     )
            )
   , ay1 AS (UPDATE gar_tmp.adr_house SET id_house_type_1 = az1.id_house_type
                FROM az1 WHERE (gar_tmp.adr_house.id_house = az1.id_house)
             RETURNING * 
     )  
       SELECT * FROM ay1 ORDER BY 1;
 --
 -- 3) Вытащить и обновить TYPE_2  
 --
 WITH ax2 AS (    
              SELECT h.id_house
                ,h.nm_house_full
                ,a.house_type_id
                ,(gar_tmp_pcg_trans.f_xxx_replace_char (a.type_name)) AS fias_row_key
              FROM gar_tmp.adr_house h 
                        JOIN gar_fias.as_house_type a ON ((h.id_house_type_2 - 1000) = a.house_type_id)  
              WHERE (h.id_house_type_2 > 1000)
  )
   , az2 AS (SELECT ax2.id_house, x.id_house_type FROM ax2
               JOIN gar_tmp.adr_house_type x 
                  ON (ax2.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char(x.nm_house_type))
     )
   , ay2 AS (UPDATE gar_tmp.adr_house SET id_house_type_2 = az2.id_house_type
                FROM az2 WHERE (gar_tmp.adr_house.id_house = az2.id_house)
             RETURNING * 
     )  
     SELECT * FROM ay2 ORDER BY 1;   
 --
 -- 4) Вытащить и обновить TYPE_3  
 --
 WITH ax3 AS (    
              SELECT h.id_house
                ,h.nm_house_full
                ,a.house_type_id
                ,(gar_tmp_pcg_trans.f_xxx_replace_char (a.type_name)) AS fias_row_key
              FROM gar_tmp.adr_house h 
                        JOIN gar_fias.as_house_type a ON ((h.id_house_type_3 - 1000) = a.house_type_id)  
              WHERE (h.id_house_type_3 > 1000)
  )
   , az3 AS (SELECT ax3.id_house, x.id_house_type FROM ax3
              JOIN gar_tmp.adr_house_type x 
                  ON (ax3.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char(x.nm_house_type))
     )
   , ay3 AS (UPDATE gar_tmp.adr_house SET id_house_type_3 = az3.id_house_type
                FROM az3 WHERE (gar_tmp.adr_house.id_house = az3.id_house)
             RETURNING * 
     )  
     SELECT * FROM ay3 ORDER BY 1;   
 --
 -- 5) Что осталось ??
 --
 WITH z0 AS (
              DELETE FROM gar_tmp.adr_house h WHERE (h.id_house_type_1 > 1000)
              RETURNING h.*
 )             
   INSERT INTO gar_tmp.xxx_adr_house_gap (
 
            id_house
           ,id_addr_parent
           ,nm_fias_guid
           ,nm_fias_guid_parent
           ,nm_parent_obj
           ,region_code
           ,parent_type_id
           ,parent_type_name
           ,parent_type_shortname
           ,parent_level_id
           ,parent_level_name
           ,parent_short_name
           ,house_num
           ,add_num1
           ,add_num2
           ,house_type
           ,house_type_name
           ,house_type_shortname
           ,add_type1
           ,add_type1_name
           ,add_type1_shortname
           ,add_type2
           ,add_type2_name
           ,add_type2_shortname
           ,nm_zipcode
           ,kd_oktmo
           ,kd_okato
           ,oper_type_id
           ,oper_type_name
           ,curr_date
           ,check_kind
 )
 
   SELECT 
       z0.id_house                           -- bigint NOT NULL,
      ,COALESCE (z0.id_area, z0.id_street)   -- bigint NOT NULL,
      ,z0.nm_fias_guid                       -- uuid,
      ,NULL AS nm_fias_guid_parent
      ,z0.nm_house_full  AS nm_parent_obj
      ,NULL AS region_code
      ,NULL AS parent_type_id
      ,NULL AS parent_type_name
      ,NULL AS parent_type_shortname
      ,NULL AS parent_level_id
      ,NULL AS parent_level_name
      ,NULL AS parent_short_name
       --
      ,z0.nm_house_1  -- character varying(70) COLLATE pg_catalog."default",
      ,z0.nm_house_2  -- character varying(50) COLLATE pg_catalog."default",
      ,z0.nm_house_3  -- character varying(50) COLLATE pg_catalog."default",
       --
      ,z0.id_house_type_1            -- integer,
      ,NULL AS house_type_name
      ,NULL AS house_type_shortname
      ,z0.id_house_type_2            -- integer,
      ,NULL AS add_type1_name
      ,NULL AS add_type1_shortname
      ,z0.id_house_type_3            -- integer,
      ,NULL AS add_type2_name
      ,NULL AS add_type2_shortname   
       --
      ,z0.nm_zipcode  -- character varying(20) COLLATE pg_catalog."default",
      ,z0.kd_oktmo    -- character varying(11) COLLATE pg_catalog."default",
      ,z0.kd_okato    -- character varying(11) COLLATE pg_catalog."default",
       --
      ,NULL AS oper_type_id
      ,NULL AS oper_type_name
      ,current_date
      ,'1'

      FROM z0 

      ON CONFLICT (nm_fias_guid) DO UPDATE
          SET
                 id_house              = excluded.id_house
                ,id_addr_parent        = excluded.id_addr_parent
                ,nm_fias_guid_parent   = excluded.nm_fias_guid_parent
                ,nm_parent_obj         = excluded.nm_parent_obj
                ,region_code           = excluded.region_code
                ,parent_type_id        = excluded.parent_type_id
                ,parent_type_name      = excluded.parent_type_name
                ,parent_type_shortname = excluded.parent_type_shortname
                ,parent_level_id       = excluded.parent_level_id
                ,parent_level_name     = excluded.parent_level_name
                ,parent_short_name     = excluded.parent_short_name
                ,house_num             = excluded.house_num
                ,add_num1              = excluded.add_num1
                ,add_num2              = excluded.add_num2
                ,house_type            = excluded.house_type
                ,house_type_name       = excluded.house_type_name
                ,house_type_shortname  = excluded.house_type_shortname
                ,add_type1             = excluded.add_type1
                ,add_type1_name        = excluded.add_type1_name
                ,add_type1_shortname   = excluded.add_type1_shortname
                ,add_type2             = excluded.add_type2
                ,add_type2_name        = excluded.add_type2_name
                ,add_type2_shortname   = excluded.add_type2_shortname
                ,nm_zipcode            = excluded.nm_zipcode
                ,kd_oktmo              = excluded.kd_oktmo
                ,kd_okato              = excluded.kd_okato
                ,oper_type_id          = excluded.oper_type_id
                ,oper_type_name        = excluded.oper_type_name
                ,curr_date             = COALESCE (excluded.curr_date, current_date)
                ,check_kind            = COALESCE (excluded.check_kind, '1')
          
            WHERE (gar_tmp.xxx_adr_house_gap.nm_fias_guid =  excluded.nm_fias_guid);

   SELECT * FROM gar_tmp.xxx_adr_house_gap;
-- ROLLBACK;
COMMIT;
