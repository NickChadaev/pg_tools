SELECT acc_id_usr, nm_usr, nm_last, nm_first, nm_middle, nm_email, id_facility, nm_tel, nm_position, nn_pers_num, pr_access, kd_otd, kd_otd_list, id_parent_usr
	FROM dict.acc_user;
--
--
SELECT count (1), kd_otd  FROM dict.acc_user 
   GROUP BY kd_otd ORDER BY 1 DESC; -- 594
   
   
SELECT * FROM dict.otdel_mv;   

SELECT kd_otd, kd_parent_otd, nm_otd, id_facility  FROM dict.otdel_mv 
ORDER BY kd_parent_otd, kd_otd;   

	
