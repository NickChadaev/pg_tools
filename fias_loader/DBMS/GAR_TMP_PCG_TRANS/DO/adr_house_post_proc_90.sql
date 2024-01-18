--
--  2023-11-13 Nick
--
BEGIN;
--
  SELECT x.op_sign, h.* FROM gar_tmp.adr_house h  
      INNER JOIN gar_tmp.adr_house_aux x ON (x.id_house = h.id_house);

  SELECT * FROM gar_tmp.xxx_adr_house_gap;  
  SELECT * FROM gar_fias.twin_addr_objects WHERE (obj_level IN(0,1,2)) ORDER BY obj_level DESC; 

--ROLLBACK;
COMMIT;
