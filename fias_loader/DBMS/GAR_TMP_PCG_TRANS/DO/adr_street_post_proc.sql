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
--   --
--   -- 2022-11-30  -- {33,90,276,440}
--   --
--   SELECT * FROM gar_tmp.adr_street WHERE (id_street_type > 1000);
DO
 $$
  DECLARE
    
  
  BEGIN
    WITH z AS (
     SELECT s.id_street
          , s.id_area
          , s.nm_street
          , (s.id_street_type - 1000) AS id_street_type
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
            ,z.id_area
            ,z.nm_street
            ,z.nm_street_full
            ,z.nm_fias_guid
            ,z.dt_data_del
            ,z.id_data_etalon
            ,z.kd_kladr
            ,x.id_area_type
            ,x.nm_area_type
      FROM z
          LEFT JOIN gar_tmp.adr_area_type x 
              ON (z.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char(x.nm_area_type));
             
     -- Создать в adr_area, adr_area_aux   INSERT
     -- adr_street - DELETE, adr_street_aux update_date
     
     
     INSERT INTO gar_tmp.adr_area (
         id_area           --  bigint NOT NULL,
         id_country        --  integer NOT NULL,
         nm_area           --  character varying(120) COLLATE pg_catalog."default" NOT NULL,
         nm_area_full      --  character varying(4000) COLLATE pg_catalog."default" NOT NULL,
         id_area_type      --  integer,
         id_area_parent    --  bigint,
         kd_timezone       --  integer,
         pr_detailed       --   smallint NOT NULL,
         kd_oktmo          --  character varying(11) COLLATE pg_catalog."default",
         nm_fias_guid      --  uuid,
         dt_data_del       --  timestamp without time zone,
         id_data_etalon    --  bigint,
         kd_okato          --  character varying(11) COLLATE pg_catalog."default",
         nm_zipcode        --  character varying(20) COLLATE pg_catalog."default",
         kd_kladr          --  character varying(15) COLLATE pg_catalog."default",
         vl_addr_latitude  --  numeric,
         vl_addr_longitude --  numeric,
     )
       SELECT    
         
     --    SELECT 
     --    (
             id_street           -- bigint NOT NULL,
             185  AS id_country  --              
             nm_street           -- character varying(120) COLLATE pg_catalog."default" NOT NULL,
             nm_street_full  ++ имя родителя    -- character varying(255) COLLATE pg_catalog."default" NOT NULL,
             id_area_type              -- bigint NOT NULL,
             id_area         ++ родитель
             NULL    AS kd_timezone
             0 AS prdetailed
             NULL as kd_oktmo
             nm_fias_guid        -- uuid,
             dt_data_del         -- timestamp without time zone,
             id_data_etalon      -- bigint,
             NULL as kd_okato
             NULL as nm_zipcode
             kd_kladr            -- character varying(15) COLLATE pg_catalog."default",
             vl_addr_latitude    -- numeric,
             vl_addr_longitude   -- numeric,
             
             id_street_type      -- integer,
     --        CONSTRAINT pk_adr_street PRIMARY KEY (id_street)
     
     --      FROM gar_tmp.adr_street
     --  )
  END; 
 $$;  
