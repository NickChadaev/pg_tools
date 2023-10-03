BEGIN;
 SET LOCAL search_path = gar_fias_pcg_load, gar_fias, public;

 SET plpgsql_check.enable_tracer = OFF;
 SET plpgsql_check.tracer = OFF;
 SET plpgsql_check.tracer_verbosity TO verbose;
 
\timing
 --
 SELECT gar_tmp_pcg_trans.f_adr_area_upd ('unnsi', 'unnsi', 'gar_tmp');  
 SELECT * FROM gar_tmp.adr_area_hist WHERE (id_region = 0) AND (date_create >= (now() - INTERVAL '1 DAY'))
        ORDER BY date_create;
 
 
-- ROLLBACK;
COMMIT;
