BEGIN;
 SET LOCAL search_path = gar_fias_pcg_load, gar_fias, public;
\timing

 SET plpgsql_check.enable_tracer = OFF;
 SET plpgsql_check.tracer = OFF;
 SET plpgsql_check.tracer_verbosity TO verbose;
 
 SELECT * FROM gar_tmp_pcg_trans.f_adr_stead_ins ('gar_tmp', 'gar_tmp', 'gar_tmp'); 

 SELECT * FROM gar_tmp.adr_stead_hist  WHERE (id_region = 0) AND (date_create >= (now() - INTERVAL '1 DAY'))
         ORDER BY date_create DESC;
         
 SELECT count (1) AS qty_xxx_adr_stead  FROM gar_tmp.xxx_adr_stead; -- 295157
 
 SELECT * FROM gar_tmp.xxx_adr_stead_gap ORDER BY nm_parent_obj;    -- 128     ????
         
--
-- ROLLBACK;
COMMIT;

