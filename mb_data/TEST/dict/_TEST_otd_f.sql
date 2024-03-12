SELECT f.id_dict
     , f.id_dict_parent
	 , f.kd_dict_entity
	 , f.id_dict_ext
	 , f.pr_delete
	 , f.dt_st
	 , f.dt_en
	 , f.id_usr
	 , f.nm_dict
	 , f.nm_dict_full
     ---
	 , m. kd_otd
	 , m.kd_parent_otd
	 , m.nm_otd
	 , m.id_facility
	 
	FROM dict.d_facility f	 
     --  LEFT JOIN dict.otdel_mv m ON (m.id_facility =  f.id_dict) -- 916
       JOIN dict.otdel_mv m ON (m.id_facility =  f.id_dict) -- 915	   
	ORDER BY f.nm_dict  ;




-- SELECT kd_otd, kd_parent_otd, nm_otd, id_facility  FROM dict.otdel_mv 
--    ORDER BY kd_parent_otd, kd_otd; 
