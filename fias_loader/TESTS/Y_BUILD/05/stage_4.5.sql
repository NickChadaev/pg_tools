BEGIN;
 SET LOCAL search_path = gar_fias_pcg_load, gar_fias, public;

 SET plpgsql_check.enable_tracer = OFF;
 SET plpgsql_check.tracer = OFF;
 SET plpgsql_check.tracer_verbosity TO verbose;

 \timing 

  SELECT * FROM gar_tmp_pcg_trans.f_adr_house_ins ('gar_tmp', 'gar_tmp', 'gar_tmp', p_sw := FALSE);
  -- Без adr_objects
  
  SELECT * FROM gar_tmp.adr_house_hist WHERE (id_region = 0) AND (date_create >= (now() - INTERVAL '1 DAY'))
        ORDER BY date_create;
 
  SELECT x.op_sign, h.* FROM gar_tmp.adr_house h  
      INNER JOIN gar_tmp.adr_house_aux x ON (x.id_house = h.id_house);

  SELECT * FROM gar_tmp.xxx_adr_house_gap;  
  SELECT * FROM gar_fias.twin_addr_objects WHERE (obj_level IN(0,1,2))  ORDER BY obj_level DESC; 
  --
-- ROLLBACK;
COMMIT;
