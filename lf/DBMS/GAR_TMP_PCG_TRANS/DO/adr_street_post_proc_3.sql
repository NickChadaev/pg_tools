BEGIN;
 --
 -- 1) Перенести в адресные области     
 --
 WITH ax AS (    
     INSERT INTO unnsi.adr_area (
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
           
              FROM public.adr_street_gap s
                LEFT JOIN gar_fias.as_addr_obj_type a ON ((s.id_street_type - 1000) = a.id)
              WHERE NOT (s.id_street_type IN (1193, 1158, 1194))
         )
          SELECT z.id_street
                ,185 AS id_country 
                ,z.nm_street AS nm_area
                ,((gar_tmp_pcg_trans.f_adr_area_get ('unnsi', z.id_area)).nm_area_full ||
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
              INNER JOIN unnsi.adr_area_type x -- 2022-12-01
                  ON (z.fias_row_key = gar_tmp_pcg_trans.f_xxx_replace_char(x.nm_area_type))
       ON CONFLICT DO NOTHING           
     RETURNING *
 )
   SELECT ax.* FROM ax;

   SELECT * FROM public.adr_street_gap s WHERE (s.id_street_type IN (1193, 1158, 1194));     -- 188    
   SELECT * FROM public.adr_street_gap s WHERE NOT (s.id_street_type IN (1193, 1158, 1194));     -- 15     
-- ROLLBACK;
COMMIT;
