BEGIN;
 --
 -- 1) Перенести из адресных областей в улицы     
 --
 
 WITH ax AS (    
              INSERT INTO unnsi.adr_street (
                            id_street           -- bigint NOT NULL,
                          , id_area             -- bigint NOT NULL,
                          , nm_street           -- varchar(120) NOT NULL,
                          , id_street_type      -- integer,
                          , nm_street_full      -- varchar(255) NOT NULL,
                          , nm_fias_guid        -- uuid,
                          , dt_data_del         -- timestamp without time zone,
                          , id_data_etalon      -- bigint,
                          , kd_kladr            -- varchar(15) COLLATE pg_catalog."default",
                          , vl_addr_latitude    -- numeric,
                          , vl_addr_longitude   -- numeric, 
                          )
        WITH z AS (
                
                 SELECT id_area
                      , nm_area
                      , nm_area_full
                      , id_area_type
                      , id_area_parent
                      , kd_oktmo
                      , nm_fias_guid
                        --
                      , a.type_name 
                      , a.type_shortname
                      , gar_tmp_pcg_trans.f_xxx_replace_char(a.type_name ) AS fias_row_key
                        --
                      , dt_data_del
                      , id_data_etalon
                      , kd_okato
                      , nm_zipcode
                      , kd_kladr
                      , vl_addr_latitude
                      , vl_addr_longitude
                           
                 FROM public.adr_area_gap s
                     JOIN gar_fias.as_addr_obj_type a ON ((s.id_area_type - 1000) = a.id)
         )
          SELECT 
                 z.id_area        AS id_street -- bigint NOT NULL,
                ,z.id_area_parent AS id_area   -- bigint NOT NULL,
                ,z.nm_area        AS nm_street -- varchar(120) NOT NULL,

                ,x.id_street_type AS id_street_type      -- integer,
                ,(z.nm_area || ' ' || COALESCE (x.nm_street_type_short, '')) AS nm_street_full      -- varchar(255) NOT NULL,
                
                ,z.nm_fias_guid        -- uuid,
                ,z.dt_data_del         -- timestamp without time zone,
                ,z.id_data_etalon      -- bigint,
                ,z.kd_kladr            -- varchar(15) COLLATE pg_catalog."default",
                ,z.vl_addr_latitude    -- numeric,
                ,z.vl_addr_longitude   -- numeric, 
          
          FROM z
              INNER JOIN unnsi.adr_street_type x -- 2022-12-01
                  ON (z.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char(x.nm_street_type))
       ON CONFLICT DO NOTHING           
     RETURNING *
 )
   SELECT ax.* FROM ax;

-- ROLLBACK;
COMMIT; -- + 42
-- SELECT * FROM unnsi.adr_street LIMIT 50;