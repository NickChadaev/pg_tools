--
--  2023-11-13 Nick
--
BEGIN;
--
   SELECT x.op_sign, s.* FROM gar_tmp.adr_street s 
     INNER JOIN gar_tmp.adr_street_aux x ON (x.id_street = s.id_street);
     
   SELECT * FROM gar_tmp.xxx_adr_street_gap;  
   SELECT * FROM gar_fias.twin_addr_objects WHERE (obj_level IN(0,1,2)) ORDER BY obj_level DESC; 

--ROLLBACK;
COMMIT;
