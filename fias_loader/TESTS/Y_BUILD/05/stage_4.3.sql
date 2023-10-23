BEGIN;
 SET LOCAL search_path = gar_fias_pcg_load, gar_fias, public;

 SET plpgsql_check.enable_tracer = OFF;
 SET plpgsql_check.tracer = OFF;
 SET plpgsql_check.tracer_verbosity TO verbose;
 
\timing

 SELECT * FROM gar_tmp_pcg_trans.f_adr_street_ins ('gar_tmp', 'gar_tmp', 'gar_tmp'); 
 SELECT * FROM gar_tmp.adr_street_hist WHERE (id_region = 0) AND (date_create >= (now() - INTERVAL '1 DAY'))
        ORDER BY date_create;

SELECT x.op_sign, s.* FROM gar_tmp.adr_street s 
  INNER JOIN gar_tmp.adr_street_aux x ON (x.id_street = s.id_street);
  
SELECT * FROM gar_tmp.xxx_adr_street_gap;   
  
-- ROLLBACK;  -- 249
COMMIT;
