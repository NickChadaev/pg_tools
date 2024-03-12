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
	-- , m. kd_otd
	-- , m.kd_parent_otd
	-- , m.nm_otd
	-- , m.id_facility
	--
     , u.acc_id_usr
     , u.nm_usr
	 , u.nm_last
	 , u.nm_first
	 , u.nm_middle
	 , u.nm_email
	 , u.id_facility
     , u.nm_tel
	 , u.nm_position
	 , u.nn_pers_num
	 , u.pr_access
	 , u.kd_otd
	 , u.kd_otd_list
	 , u.id_parent_usr	 
	 
	FROM dict.d_facility f	 
     --  LEFT JOIN dict.otdel_mv m ON (m.id_facility =  f.id_dict) -- 916
	   JOIN dict.acc_user u ON (u.id_facility =  f.id_dict)  
       JOIN dict.otdel_mv m ON (m.kd_otd = u.kd_otd) -- 915
	    
	WHERE (f.id_dict IN (1, 22, 101)) 
	ORDER BY f.id_dict  ;

SELECT acc_id_usr
     , nm_usr
	 , nm_last
	 , nm_first
	 , nm_middle
	 , nm_email
	 , id_facility
     , nm_tel
	 , nm_position
	 , nn_pers_num
	 , pr_access
	 , kd_otd
	 , kd_otd_list
	 , id_parent_usr
	FROM dict.acc_user WHERE (id_facility IN (1, 22, 101));  -- 1317