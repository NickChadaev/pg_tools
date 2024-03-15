SELECT c.id_comment, 
                                        c.id_comment_parent, 
                                        c.id_entity, 
                                        c.kd_sys_entity, 
                                        c.id_usr_create,
                               	        c.nm_comment, 
                                        c. dt_comment, 
--                                         CASE 
--                                         WHEN dt_del IS NOT NULL THEN TRUE
--                                           ELSE FALSE
--                                         END pr_del
                                          u.*,
										  f.*
                                 FROM contacts.cm_comment c
								 INNER JOIN dict.acc_user u ON (c.id_usr_create = u.acc_id_usr )
 								 INNER JOIN dict.d_facility f ON (f.id_dict = u.id_facility)
								 WHERE (u.id_facility = 101)
								 
								 LIMIT 100
                                 
--                                WHERE (dt_change >= %1L  AND  dt_change < %2L)
--                                   OR 
--                                      (dt_comment >= %3L AND  dt_comment < %4L)
                                     
SELECT min(DT_COMMENT), max (DT_COMMENT)  FROM contacts.cm_comment                                
  -- "2021-01-27 10:22:24.88749"	"2024-03-14 12:10:08.110454"                                   
                                 
SELECT min(dt_change), max (dt_change)  FROM contacts.cm_comment 
  -- "2021-01-27 10:22:24.88749"	"2024-03-14 12:10:08.110454"
  
SELECT min(dt_del), max (dt_del) FROM contacts.cm_comment 
--"2021-04-03 11:41:16.456299"  2023-05-29 14:59:37.595767