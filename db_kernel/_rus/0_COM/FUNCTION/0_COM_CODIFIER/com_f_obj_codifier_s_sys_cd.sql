-- ================================================================= --
-- Author Ann. Отображение кодификатора.                             --
-- Date create 2014-02-19                                            --
--             2014-09-16 Nick Переписал всё.                        --
--  2014-09-17 Дополнительная функция, аргумент - код кодификатора.  --
--  2015-02-15 Nick Адаптация под домен EBD                          --
--  2015-04-05  STABLE SECURITY INVOKER                              --
--  2015-05-30 Добавлены date_from, codif_uuid                       --
--  2015-07-20 Gregory Модифицирована под "на дату"                  --
--  2015-08-29 Nick ввёл атрибут "статус"                            --
-- 2017-07-11  Сортировка по столбцу "tree_d"                        -- 
-- ================================================================= --
-- SET search_path=com,PUBLIC;

DROP FUNCTION IF EXISTS com.com_f_obj_codifier_s_sys ( t_str60, t_timestamp );

DROP FUNCTION IF EXISTS com.com_f_obj_codifier_s_imp ( t_str60, t_timestamp );
CREATE OR REPLACE FUNCTION com.com_f_obj_codifier_s_imp ( p_codif_code t_str60, p_date t_timestamp ) 
 RETURNS TABLE  (
      codif_id          BIGINT      -- id элемента кодификатора ( ID строки )
    , parent_codif_id   id_t        -- id родительской строки
      --
    , impact_type       t_code1     -- Код воздействия -- Nick 2015-08-29
    , codif_status      t_str20     -- Статус экземпляра кодификатора
      --
    , small_code        t_code1     -- Краткий код
    , codif_code        t_str60     -- код элемента кодификатора
    , codif_name        t_str250    -- наименование элемента кодификатора
      -- 
    , date_from         t_timestamp -- Дата начала актуальности 
    , date_to           t_timestamp -- Дата конца актуальности
    , codif_uuid        t_guid      -- UUID кодификатора 
      --
    , tree_d            t_arr_id    -- массив ID от текущей позиции
    , level_d           small_t     -- уровень от текущей позиции
    , tree_name_d       t_str2048   -- путь от текущей позиции
)
  AS
   $$
     BEGIN
        RETURN QUERY SELECT * FROM (
            WITH RECURSIVE cd (  codif_id
                                ,parent_codif_id
                                  --
                                ,impact_type 
                                ,codif_status   
                                  --
                                ,small_code 
                                ,codif_code
                                ,codif_name
                                ,date_from   -- 2015-05-30 Nick 
                                ,date_to     -- 2015-07-20 Gregory
                                ,codif_uuid
                                ,tree_d
                                ,level_d
                                ,tree_name_d
                                ,cicle_d
                ) AS ( SELECT 
                          c.codif_id
                        , c.parent_codif_id
                          --  
                        , l.impact_type    
                        , CASE l.impact_type  
                             WHEN '0' THEN  'Активный' 
                             WHEN '2' THEN  'Обновлённый' 
                             WHEN '1' THEN  'Удалённый' 
                          END::t_str20 AS codif_status  
                          --
                        , c.small_code
                        , c.codif_code
                        , c.codif_name
                        , c.date_from   -- 2015-05-30 Nick
			               , c.date_to -- 2015-07-20 Gregory
                        , c.codif_uuid                    
                        , CAST ( ARRAY [c.codif_id] AS t_arr_id ) 
                        , 1::small_t
                        , btrim ( CAST( c.codif_name AS t_str2048))
                        , FALSE
                       FROM com.obj_codifier c 
                            INNER JOIN com.com_log l ON ( c.id_log = l.id_log )
                         WHERE ( c.codif_code = upper (btrim ( p_codif_code ))) 

                        UNION ALL

                       SELECT 
                          c.codif_id
                        , c.parent_codif_id
                          --  
                        , l.impact_type    
                        , CASE l.impact_type  
                             WHEN '0' THEN  'Активный' 
                             WHEN '2' THEN  'Обновлённый' 
                             WHEN '1' THEN  'Удалённый' 
                          END::t_str20 AS codif_status  
                          --
                        , c.small_code
                        , c.codif_code
                        , c.codif_name
                        , c.date_from   -- 2015-05-30 Nick
               	   	, c.date_to -- 2015-07-20 Gregory
                        , c.codif_uuid                    
                        , CAST (  d.tree_d || c.codif_id AS t_arr_id )
                        , (d.level_d + 1)::small_t
                        , d.tree_name_d::t_str2048|| '-->' || c.codif_name::t_str250 
                        , c.codif_id = ANY ( d.tree_d )
                       FROM com.obj_codifier c 
                        INNER JOIN com.com_log l ON ( c.id_log = l.id_log )
                        INNER JOIN cd d          ON ( d.codif_id  = c.parent_codif_id ) AND ( NOT cicle_d )
                   ) 
                    SELECT DISTINCT ON(s.codif_id)
                            s.codif_id     
                           ,s.parent_codif_id 
                           ,s.impact_type    
                           ,s.codif_status
                           ,s.small_code   
                           ,s.codif_code   
                           ,s.codif_name  
                           ,s.date_from   -- 2015-05-30 Nick
                           ,s.date_to     -- Nick 2015-08-29
                           ,s.codif_uuid                    
                           ,s.tree_d       
                           ,s.level_d      
                           ,s.tree_name_d::t_str2048
                     FROM cd s
		     WHERE s.date_from <= p_date AND p_date >= s.date_to -- Nick 2015-08-29
		     ORDER BY s.codif_id, s.date_from DESC, s.date_to DESC) AS u
                    ORDER BY u.tree_d; -- u.level_d, u.parent_codif_id, u.codif_id;
     END;
   $$
     STABLE 
     SECURITY INVOKER
     LANGUAGE plpgsql ;

COMMENT ON FUNCTION com.com_f_obj_codifier_s_imp ( t_str60, t_timestamp ) IS '7875: Отображение кодификатора по уровням иерархии, аргументы код кодификатора и дата
  РЕЗУЛЬТАТ:
      codif_id          BIGINT      -- id элемента кодификатора ( ID строки )
    , parent_codif_id   id_t        -- id родительской строки
      --
    , impact_type       t_code1     -- Код воздействия -- Nick 2015-08-29
    , codif_status      t_str20     -- Статус экземпляра кодификатора
      --
    , small_code        t_code1     -- Краткий код
    , codif_code        t_str60     -- код элемента кодификатора
    , codif_name        t_str250    -- наименование элемента кодификатора
      -- 
    , date_from         t_timestamp -- Дата начала актуальности 
    , date_to           t_timestamp -- Дата конца актуальности
    , codif_uuid        t_guid      -- UUID кодификатора 
      --
    , tree_d            t_arr_id    -- массив ID от текущей позиции
    , level_d           small_t     -- уровень от текущей позиции
    , tree_name_d       t_str2048   -- путь от текущей позиции
';
--
-- 	
-- select * from com.com_f_obj_codifier_s_imp ();
-- select * from com.com_f_obj_codifier_s_imp ('C_MRT', '2015-09-05 19:08:32');
-- select * from com.com_f_obj_codifier_s_imp ('C_MRT', '2015-08-05 19:08:32');
-- select * from com.com_f_obj_codifier_s_imp ('C_MRT');
-- select * from com.com_f_obj_codifier_s_imp ('C_CODIF_ROOT', '2016-08-05 19:08:32');
-- select * from com.com_f_obj_codifier_s_imp ('zggfd');
-- select * from com.obj_codifier_hist
-- select * from com.com_log where ( id_log = 253 );
