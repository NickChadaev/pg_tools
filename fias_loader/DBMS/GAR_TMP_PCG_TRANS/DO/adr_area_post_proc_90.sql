--
--  2023-11-13 Nick
--
BEGIN;
--
   SELECT x.op_sign, a.* FROM gar_tmp.adr_area a 
     INNER JOIN gar_tmp.adr_area_aux x ON (x.id_area = a.id_area);
     
   SELECT * FROM gar_tmp.xxx_adr_area_gap; 
   SELECT * FROM gar_fias.twin_addr_objects WHERE (obj_level IN(0,1,2)) ORDER BY obj_level DESC; 
   --
--ROLLBACK;
COMMIT;

