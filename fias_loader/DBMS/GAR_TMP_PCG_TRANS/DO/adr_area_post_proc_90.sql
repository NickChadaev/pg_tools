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
   -- 2024-01-20
   
   -- Необходимо проверить работу обновления эталона, куда грузятся обновления из ФИАС.
   -- Пример ошибки:
   -- ошибочный индекс у села в Дагестане: Дагестан Респ, Новолакский р-н, Чапаево с
   -- Индекс ФИАС: 368160
   -- Индекс в нашем адресном справочнике: 368168   
   
   SELECT * FROM gar_tmp.adr_area 
                             WHERE (nm_fias_guid = '1a91684d-7af5-4f5e-acf3-d33fe8e3351a');
   UPDATE gar_tmp.adr_area SET nm_zipcode = '368160'  
                             WHERE (nm_fias_guid = '1a91684d-7af5-4f5e-acf3-d33fe8e3351a');   
---

--ROLLBACK;
COMMIT;

