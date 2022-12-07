--   SELECT id, type_name, type_shortname, type_descr, update_date, start_date, end_date, is_active, fias_row_key
--   	FROM gar_fias.as_addr_obj_type_black_list WHERE (object_kind = '1') AND
--   	id IN (158, 209,125,113,194, 128);
--   -- ----------------------------------------
--   -- id	type_name	type_shortname	type_descr	update_date	start_date	end_date	is_active	fias_row_key
--   -- 158	Поселок	п	Поселок	1900-01-01	1900-01-01	2018-04-16	True	поселок
--   -- 194	Садовое неком-е товарищество	снт	Садовое некоммерческое товарищество	1900-01-01	1900-01-01	2018-11-09	True	садовоенекометоварищество
--   -- 209	Хутор	х	Хутор	1900-01-01	1900-01-01	2015-11-05	True	хутор
--   --
--   SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_area_type_show_data ('gar_tmp') 
--      where (fias_row_key in ('поселок','хутор','садовоенекометоварищество', 'деревня'))
--   SELECT id, type_name, type_shortname, type_descr, update_date, start_date, end_date, is_active 
--   	FROM gar_fias.as_addr_obj_type WHERE id IN (158, 209,125,113,194, 128);
--   	
--   id	type_name	type_shortname	type_descr	update_date	start_date	end_date	is_active
--   113	Абонентский ящик	а/я	Абонентский ящик	1900-01-01	1900-01-01	2015-11-05	True
--   125	Деревня	д	Деревня	1900-01-01	1900-01-01	2015-11-05	True
--   128	Железнодорожная будка	ж/д_будка	Железнодорожная будка	1900-01-01	1900-01-01	2015-11-05	True
--   158	Поселок	п	Поселок	1900-01-01	1900-01-01	2018-04-16	True
--   194	Садовое неком-е товарищество	снт	Садовое некоммерческое товарищество	1900-01-01	1900-01-01	2018-11-09	True
--   209	Хутор	х	Хутор	1900-01-01	1900-01-01	2015-11-05	True
--   	
--   SELECT * FROM gar_tmp.adr_street WHERE (id_street_type > 1000); -- 48
--   SELECT * FROM gar_tmp.adr_area WHERE (id_area = 611); -- 48

BEGIN;
 --
 -- 1) Перенести в адресные области     
 --
 WITH ax AS (    
     INSERT INTO gar_tmp.adr_area (
        id_area           --  bigint NOT NULL,
       ,id_country        --  integer NOT NULL,
       ,nm_area           --  character varying(120) COLLATE pg_catalog."default" NOT NULL,
       ,nm_area_full      --  character varying(4000) COLLATE pg_catalog."default" NOT NULL,
       ,id_area_type      --  integer,
       ,id_area_parent    --  bigint,
       ,kd_timezone       --  integer,
       ,pr_detailed       --   smallint NOT NULL,
       ,kd_oktmo          --  character varying(11) COLLATE pg_catalog."default",
       ,nm_fias_guid      --  uuid,
       ,dt_data_del       --  timestamp without time zone,
       ,id_data_etalon    --  bigint,
       ,kd_okato          --  character varying(11) COLLATE pg_catalog."default",
       ,nm_zipcode        --  character varying(20) COLLATE pg_catalog."default",
       ,kd_kladr          --  character varying(15) COLLATE pg_catalog."default",
       ,vl_addr_latitude  --  numeric,
       ,vl_addr_longitude --  numeric,
     )
        WITH z AS (
           SELECT s.id_street
                , s.id_area
                , s.nm_street
                , s.nm_street_full
                , s.nm_fias_guid
                , a.type_name 
                , gar_tmp_pcg_trans.f_xxx_replace_char(a.type_name ) AS fias_row_key
                , s.dt_data_del
                , s.id_data_etalon
                , s.kd_kladr
           
              FROM gar_tmp.adr_street s
                LEFT JOIN gar_fias.as_addr_obj_type a ON ((s.id_street_type - 1000) = a.id)
              WHERE (s.id_street_type > 1000)
         )
          SELECT z.id_street
                ,185 AS id_country 
                ,z.nm_street AS nm_area
                ,((gar_tmp_pcg_trans.f_adr_area_get ('gar_tmp', z.id_area)).nm_area_full ||
                  ', ' || z.nm_street_full
                 ) AS nm_area_full
                ,x.id_area_type
                ,z.id_area AS id_area_parent
                ,NULL AS kd_timezone
                ,0 AS pr_detailed
                ,NULL AS kd_oktmo
                ,z.nm_fias_guid
                ,z.dt_data_del
                ,z.id_data_etalon
                ,NULL AS kd_okato
                ,NULL AS nm_zipcode
                ,z.kd_kladr
                ,NULL AS vl_addr_latitude 
                ,NULL AS vl_addr_longitude
          FROM z
              INNER JOIN gar_tmp.adr_area_type x -- 2022-12-01
                  ON (z.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char(x.nm_area_type))
       ON CONFLICT DO NOTHING           
     RETURNING *
 )
   SELECT ax.* FROM ax;

 --
 -- 2) Создать в adr_area_aux   INSERT
 -- 3) Создать в adr_street_aux   UPDATE
                    
 WITH a0 AS (
              SELECT s.id_street AS id_obj FROM gar_tmp.adr_street s
                WHERE (s.id_street_type > 1000)
      )
      ,a1 AS (
              INSERT INTO gar_tmp.adr_area_aux (id_area, op_sign)
               SELECT a0.id_obj, 'I' FROM a0 
                 ON CONFLICT (id_area) DO UPDATE SET op_sign = 'I'
                    WHERE (gar_tmp.adr_area_aux.id_area = excluded.id_area)                  
              RETURNING * 
             )  
      ,a2 AS (              
             INSERT INTO gar_tmp.adr_street_aux (id_street, op_sign)
               SELECT a0.id_obj, 'U' FROM a0  
                 ON CONFLICT (id_street) DO UPDATE SET op_sign = 'U'
                    WHERE (gar_tmp.adr_street_aux.id_street = excluded.id_street)  
              RETURNING *  
             )
         SELECT a1.* FROM a1 UNION ALL SELECT a2.* FROM a2
         ORDER BY 1,2;
 --
 -- 4) Удалить
 --
 WITH z0 AS (
             SELECT s.id_street FROM gar_tmp.adr_street s
                  WHERE (s.id_street_type > 1000)
 )
 , z1 AS (
           DELETE FROM gar_tmp.adr_street s 
                    USING z0 WHERE (z0.id_street = s.id_street)
           RETURNING s.*         
 )
    INSERT INTO gar_tmp.xxx_adr_street_gap (
        id_street          -- bigint,
       ,nm_street          -- character varying(250),
       ,nm_street_full     -- character varying(250),
       ,id_street_type     -- bigint,
       ,nm_street_type     -- character varying(50),
       ,id_area            -- bigint,
       ,nm_fias_guid_area  -- uuid,
       ,nm_fias_guid       -- uuid,
       ,kd_kladr           -- text,
       --
       ,tree_d             -- bigint[],
       ,level_d            -- integer,
       ,obj_level          -- bigint,
       ,level_name         -- character varying(100),
       ,oper_type_id       -- bigint,
       ,oper_type_name     -- character varying(100),
       ,curr_date          -- date,
       ,check_kind         -- character(1)
  )
    SELECT 
         z1.id_street      
        ,z1.nm_street      
        ,z1.nm_street_full 
        ,z1.id_street_type 
        ,NULL AS nm_street_type
        ,z1.id_area  
        ,NULL AS nm_fias_guid_area 
        ,z1.nm_fias_guid   
        ,z1.kd_kladr       
         --
        ,NULL AS tree_d          
        ,NULL AS level_d         
        ,NULL AS obj_level       
        ,NULL AS level_name      
        ,NULL AS oper_type_id    
        ,NULL AS oper_type_name  
        ,current_date
        ,'1'
 
       FROM z1 
 
       ON CONFLICT (nm_fias_guid) DO UPDATE
           SET
             id_street          = excluded.id_street        
            ,nm_street          = excluded.nm_street        
            ,nm_street_full     = excluded.nm_street_full   
            ,id_street_type     = excluded.id_street_type   
            ,nm_street_type     = excluded.nm_street_type   
            ,id_area            = excluded.id_area          
            ,nm_fias_guid_area  = excluded.nm_fias_guid_area
            ,kd_kladr           = excluded.kd_kladr         
            ,tree_d             = excluded.tree_d           
            ,level_d            = excluded.level_d          
            ,obj_level          = excluded.obj_level        
            ,level_name         = excluded.level_name       
            ,oper_type_id       = excluded.oper_type_id     
            ,oper_type_name     = excluded.oper_type_name   
            ,curr_date          = excluded.curr_date        
            ,check_kind         = excluded.check_kind       
           
         WHERE (gar_tmp.xxx_adr_street_gap.nm_fias_guid =  excluded.nm_fias_guid);
         
   SELECT * FROM gar_tmp.xxx_adr_street_gap;             
-- ROLLBACK;
COMMIT;
