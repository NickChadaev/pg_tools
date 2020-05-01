       WITH xd0 AS (	SELECT
                             al.id_log::public.id_t   AS id_log
                           , al.user_name             AS user_name
                           , al.host_name             AS host_name
                           , al.impact_date           AS impact_date
                           , al.schema_name           AS sch_name
                           , al.impact_type           AS impact_type
                           , al.impact_descr          AS impact_descr                
    	                FROM com.all_log_1 al
                    WHERE 
--              ((_user_name IS NULL) OR ((_user_name IS NOT NULL) AND (btrim (al.user_name) = _user_name))) AND  
--                -- 2018-04-09 Timur
                (lower (al.schema_name)  = ANY (ARRAY['com', 'nso'])) AND
--                ((_sch_name_forb    IS NULL) OR ((_sch_name_forb    IS NOT NULL) AND (upper (al.schema_name) <> ALL (_sch_name_forb))))  AND
--              ((_impact_type_desr IS NULL) OR ((_impact_type_desr IS NOT NULL) AND (upper (al.impact_type)  = ANY (_impact_type_desr)))) AND
              (upper (al.impact_type) <> ALL (ARRAY['!'])) AND
--                -- 2018-04-09 Timur
               (al.impact_date >= '2020-01-01') 
--              ((_date_to   IS NULL) OR ((_date_to   IS NOT NULL) AND (al.impact_date <= _date_to)))
--  
           )  -- 18 rows 115 ms
             SELECT  xd0.id_log
                    ,xd0.user_name
                    ,xd0.host_name
                    ,xd0.impact_date
                    ,xd0.sch_name
                    ,xd0.impact_type
                    ,xd0.impact_descr
                    ,ac0.object_id
                    ,ac0.object_name
             FROM xd0
                     LEFT JOIN LATERAL ( SELECT 
                             obj_object.id_log 
                            ,obj_object.object_id
                            ,com_codifier.com_f_obj_codifier_get_code(obj_object.object_type_id) 
                                                    AS object_name
                            ,'com'  AS sch_name                        
                           FROM com.obj_object WHERE ( id_log = xd0.id_log )
                        UNION ALL
                         SELECT obj_codifier.id_log
                            ,obj_codifier.codif_id AS object_id
                            ,obj_codifier.codif_name AS object_name
                            ,'com'  AS sch_name
                           FROM com.obj_codifier WHERE ( id_log = xd0.id_log )
                        UNION ALL
                         SELECT nso_domain_column.id_log
                            ,nso_domain_column.attr_id AS object_id
                            ,nso_domain_column.attr_name AS object_name
                            ,'com'  AS sch_name
                           FROM com.nso_domain_column WHERE ( id_log = xd0.id_log )
                           
                        UNION ALL

                       SELECT nso_object.id_log
                             ,nso_object.nso_id AS object_id
                             ,(nso_object.nso_name)::public.t_fullname AS object_name
                            ,'nso'  AS sch_name
               FROM nso.nso_object WHERE ( id_log = xd0.id_log )
        UNION ALL
    
       SELECT nso_record.log_id AS id_log
              ,nso_record.rec_id AS object_id
            ,(nso_structure.nso_f_object_get_code(nso_record.nso_id))::public.t_fullname AS object_name
                           ,'nso'  AS sch_name
           FROM nso.nso_record WHERE ( id_log = xd0.id_log )                        
                      ) ac0 ON (((xd0.id_log) = (ac0.id_log)) AND (xd0.sch_name = ac0.sch_name))
           ORDER BY impact_date DESC;					  
-- 18             
-- SELECT * FROM com.com_log_1 WHERE ( impact_date >= '2020-01-01') --10 - 1 = 9
-- SELECT * FROM nso.nso_log_1 WHERE ( impact_date >= '2020-01-01') --11 -2 = 9
--
-- 30 строк после подключения объектов 120 ms
--SELECT * from com.all_v_event_log_op WHERE (impact_date >= '2020-01-01'); -- 120 ms
SELECT id_log,user_name,host_name,impact_date,sch_name,impact_type,impact_descr,object_id,object_name 
  from com.all_v_event_log_op WHERE (impact_date >= '2020-01-01'); -- 120 ms
--  
SELECT id_log, COUNT(*) AS 	QTY
  from com.all_v_event_log_op WHERE (impact_date >= '2020-01-01')
 group BY id_log order by 2 desc; -- 120 ms
--------------------------------------------------------------  18 + 12 = 30  Всё
1863|8
1875|2
1872|2
1878|2
1881|2
1869|2
1871|1
1873|1
1874|1
1876|1
------------------------------------------------------------------------------
-- 2020-05-01 
--
--  id_log = 1882
SELECT * FROM com.all_log_1 WHERE (id_log = 1882);  
-- 'com'|1882|'3'|'2020-04-14 16:57:52'|'Создание атрибута в домене: D_N_CODE_8145.86767259815'|'postgres'|'/var/run/postgresql'
SELECT * FROM com.nso_domain_column WHERE ( id_log = 1882); 
-- 123|4|7|'U'|'31c0ca1e-01b2-4002-9ff8-d6543da386f9'|'2011-01-01 00:00:00'|false|'D_N_CODE_8145.86767259815'|'Заголовок - ИМЯ_5158.778038790786'|||'2011-01-01 00:00:00'|'9999-12-31 00:00:00'|1882\
--
SELECT * FROM com.all_log_1 WHERE (id_log = 1881); -- 'nso'|1881|'0'|'2020-04-14 16:57:52'|'Создан НСО: "N_CODE_8145.86767259815 - ИМЯ_5158.778038790786"'|'postgres'|
SELECT * FROM nso.nso_object WHERE ( id_log = 1881);
----------------------------------------------------------------------
17|8|158|'31c0ca1e-01b2-4002-9ff8-d6543da386f9'|'2011-01-01 00:00:00'|0|true|false|false|false|false|'N_CODE_8145.86767259815'|'ИМЯ_5158.778038790786'||0|'2020-04-14 16:57:52'|'9999-12-31 00:00:00'|1881
17|8|158|'31c0ca1e-01b2-4002-9ff8-d6543da386f9'|'2011-01-01 00:00:00'|0|false|false|false|false|false|'N_CODE_8145.86767259815'|'ИМЯ_5158.778038790786'||0|'2011-01-01 00:00:00'|'2020-04-14 16:57:52'|1881
-- Запись была обновлена, почему общий ID_LOG ?? Проверить обновление НСО

SELECT * FROM ONLY nso.nso_object WHERE ( id_log = 1881);
SELECT * FROM nso.nso_object_hist WHERE (nso_id = 17); -- ( id_log = 1881);
SELECT * FROM nso.nso_object WHERE ( id_log = 1881) OR (nso_id = 17); 
--
--  ID_LOG = 1879 
--
SELECT * FROM com.all_log_1 WHERE (id_log = 1879); 
SELECT * FROM com.nso_domain_column WHERE ( id_log = 1879); 
--
-- ID_LOG = 1878
--
SELECT * FROM com.all_log_1 WHERE (id_log = 1878); -- 'nso'|1878|'0'|'2020-04-14 11:18:59'|'Создан НСО: "N_CODE_5576.835511715821 - ИМЯ_8827.949646800163"'|'postgres'|
--
SELECT * FROM nso.nso_object WHERE ( id_log = 1878); -- Два объекта НСО с разными именами, разные объекты, но олдин ID_LOG
SELECT * FROM nso.nso_object WHERE ( id_log = 1875);
-----------------------------------------------------
EXPLAIN ANALYZE
       WITH xd0 AS (	SELECT
                             al.id_log::public.id_t   AS id_log
                           , al.user_name             AS user_name
                           , al.host_name             AS host_name
                           , al.impact_date           AS impact_date
                           , al.schema_name           AS sch_name
                           , al.impact_type           AS impact_type
                           , al.impact_descr          AS impact_descr                
    	                FROM com.all_log_1 al
                    WHERE 
--              ((_user_name IS NULL) OR ((_user_name IS NOT NULL) AND (btrim (al.user_name) = _user_name))) AND  
--                -- 2018-04-09 Timur
                (lower (al.schema_name)  = ANY (ARRAY['com', 'nso'])) AND
--                ((_sch_name_forb    IS NULL) OR ((_sch_name_forb    IS NOT NULL) AND (upper (al.schema_name) <> ALL (_sch_name_forb))))  AND
--              ((_impact_type_desr IS NULL) OR ((_impact_type_desr IS NOT NULL) AND (upper (al.impact_type)  = ANY (_impact_type_desr)))) AND
              (upper (al.impact_type) <> ALL (ARRAY['!'])) AND
--                -- 2018-04-09 Timur
               (al.impact_date >= '2020-01-01') 
--              ((_date_to   IS NULL) OR ((_date_to   IS NOT NULL) AND (al.impact_date <= _date_to)))
--  
           )  -- 18 rows 115 ms
             SELECT  xd0.id_log
                    ,xd0.user_name
                    ,xd0.host_name
                    ,xd0.impact_date
                    ,xd0.sch_name
                    ,xd0.impact_type
                    ,xd0.impact_descr
                    ,ac0.object_id
                    ,ac0.object_name
             FROM xd0
                     LEFT JOIN LATERAL ( SELECT 
                             obj_object.id_log 
                            ,obj_object.object_id
                            ,com_codifier.com_f_obj_codifier_get_code(obj_object.object_type_id) 
                                                    AS object_name
                            ,'com'  AS sch_name                        
                           FROM com.obj_object WHERE ( id_log = xd0.id_log )
                        UNION ALL
										
SELECT 
                             obj_object_hist.id_log 
                            ,obj_object_hist.object_id
                            ,com_codifier.com_f_obj_codifier_get_code(obj_object_hist.object_type_id) 
                                                    AS object_name
                            ,'com'  AS sch_name                        
                           FROM com.obj_object_hist WHERE ( id_log = xd0.id_log )	
										
										union all
										
                         SELECT obj_codifier.id_log
                            ,obj_codifier.codif_id AS object_id
                            ,obj_codifier.codif_name AS object_name
                            ,'com'  AS sch_name
                           FROM com.obj_codifier WHERE ( id_log = xd0.id_log )
                        UNION ALL
                         SELECT nso_domain_column.id_log
                            ,nso_domain_column.attr_id AS object_id
                            ,nso_domain_column.attr_name AS object_name
                            ,'com'  AS sch_name
                           FROM com.nso_domain_column WHERE ( id_log = xd0.id_log )
                           
                        UNION ALL

                       SELECT nso_object.id_log
                             ,nso_object.nso_id AS object_id
                             ,(nso_object.nso_name)::public.t_fullname AS object_name
                            ,'nso'  AS sch_name
               FROM nso.nso_object WHERE ( id_log = xd0.id_log )
        UNION ALL
    
       SELECT nso_record.log_id AS id_log
              ,nso_record.rec_id AS object_id
            ,(nso_structure.nso_f_object_get_code(nso_record.nso_id))::public.t_fullname AS object_name
                           ,'nso'  AS sch_name
           FROM nso.nso_record WHERE ( id_log = xd0.id_log )                        
                      ) ac0 ON (((xd0.id_log) = (ac0.id_log))) -- AND (xd0.sch_name = ac0.sch_name))
           ORDER BY impact_date DESC;	
		  -- Явно включать "obj_object_hist" в запросы. 
--
-- 2020-05-01 Функция отображения.
--
-- SELECT * FROM com.com_f_all_log_s (p_date_from := '2020-01-01'); -- Суммарное время выполнения запроса: 113 ms. 18 строк получено.
-- SELECT DISTINCT * from com.all_v_event_log_op WHERE (impact_date >= '2020-01-01');  -- 144 ms 29 rows Неверно
-- SELECT * FROM com.com_log_1 WHERE ( impact_date >= '2020-01-01') --10 - 1 = 9
-- SELECT * FROM nso.nso_log_1 WHERE ( impact_date >= '2020-01-01') --11 -2 = 9


