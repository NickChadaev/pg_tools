-- SELECT id
--      , object_id
--      , parent_obj_id
--      , change_id
--      , region_code
--      , area_code
--      , city_code
--      , place_code
--      , plan_code
--      , street_code
--      , prev_id
--      , next_id
--      , update_date
--      , start_date
--      , end_date
--      , is_active
-- 	FROM gar_fias.as_adm_hierarchy
-- WHERE (object_id = 83006);
-- ---------------------------------------------------
-- -- id	object_id	parent_obj_id	change_id	region_code	area_code	city_code	place_code	plan_code	street_code	prev_id	next_id	update_date	start_date	end_date	is_active
-- -- 2563937	83006	79186	233970	5	0	1	0	0	2677	0	0	2012-12-25	2012-12-25	2079-06-06	True


-- SELECT id
--      , object_id
--      , parent_obj_id
--      , change_id
--      , region_code
--      , area_code
--      , city_code
--      , place_code
--      , plan_code
--      , street_code
--      , prev_id
--      , next_id
--      , update_date
--      , start_date
--      , end_date
--      , is_active
-- 	FROM gar_fias.as_adm_hierarchy
-- WHERE (object_id = 79186);  -- 78727

-- SELECT id
--      , object_id
--      , parent_obj_id
--      , change_id
--      , region_code
--      , area_code
--      , city_code
--      , place_code
--      , plan_code
--      , street_code
--      , prev_id
--      , next_id
--      , update_date
--      , start_date
--      , end_date
--      , is_active
-- 	FROM gar_fias.as_adm_hierarchy
-- WHERE (object_id = 78727);  -- 78545


WITH RECURSIVE aa1 AS (

                 SELECT h1.id
                      , h1.object_id
                      , h1.parent_obj_id
                      , h1.change_id
                      , h1.region_code
                      , h1.area_code
                      , h1.city_code
                      , h1.place_code
                      , h1.plan_code
                      , h1.street_code
                      , h1.prev_id
                      , h1.next_id
                      , h1.update_date
                      , h1.start_date
                      , h1.end_date
                      , h1.is_active
                 	FROM gar_fias.as_adm_hierarchy h1
                 	
                 WHERE (h1.object_id = 84195) -- 83006

                 UNION ALL
                 
                 SELECT h2.id
                      , h2.object_id
                      , h2.parent_obj_id
                      , h2.change_id
                      , h2.region_code
                      , h2.area_code
                      , h2.city_code
                      , h2.place_code
                      , h2.plan_code
                      , h2.street_code
                      , h2.prev_id
                      , h2.next_id
                      , h2.update_date
                      , h2.start_date
                      , h2.end_date
                      , h2.is_active
                 	FROM gar_fias.as_adm_hierarchy h2
                 	
                   INNER JOIN aa1 ON (h2.object_id = aa1.parent_obj_id) 
                 
)
   SELECT * FROM aa1;

   
   WITH RECURSIVE aa1 AS (

                 SELECT h1.id
                      , h1.object_id
                      , h1.parent_obj_id
                      , h1.change_id
                      , h1.region_code
                      , h1.area_code
                      , h1.city_code
                      , h1.place_code
                      , h1.plan_code
                      , h1.street_code
                      , h1.prev_id
                      , h1.next_id
                      , h1.update_date
                      , h1.start_date
                      , h1.end_date
                      , h1.is_active
                 	FROM gar_fias.as_adm_hierarchy h1
                 	
                 WHERE (h1.parent_obj_id = 0) AND (h1.is_active)-- 83006

                 UNION ALL
                 
                 SELECT h2.id
                      , h2.object_id
                      , h2.parent_obj_id
                      , h2.change_id
                      , h2.region_code
                      , h2.area_code
                      , h2.city_code
                      , h2.place_code
                      , h2.plan_code
                      , h2.street_code
                      , h2.prev_id
                      , h2.next_id
                      , h2.update_date
                      , h2.start_date
                      , h2.end_date
                      , h2.is_active
                 	FROM gar_fias.as_adm_hierarchy h2
                 	
                       INNER JOIN aa1 ON (h2.parent_obj_id = aa1.object_id) 
                       
                    WHERE (h2.is_active)   
                 
)
   SELECT * FROM aa1 WHERE (region_code = '5'); -- 1415089 /1003550 rows affected.
