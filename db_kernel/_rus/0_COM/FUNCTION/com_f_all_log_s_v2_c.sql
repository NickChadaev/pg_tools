DROP FUNCTION IF EXISTS com.com_f_com_log_s(t_sysname, t_code1, t_timestamp, t_timestamp);
DROP FUNCTION IF EXISTS nso.nso_f_nso_log_s(t_sysname, t_code1, t_timestamp, t_timestamp);
DROP FUNCTION IF EXISTS com.com_f_all_log_s ( public.t_sysname, public.t_arr_code,public.t_arr_code, public.t_arr_code,public.t_arr_code,
                                              public.t_timestamp, public.t_timestamp, public.t_int, public.t_text 
);
CREATE OR REPLACE FUNCTION com.com_f_all_log_s (
        p_user_name         public.t_sysname   = NULL                      -- Логин пользователя
       ,p_sch_name_desr     public.t_arr_code  = ARRAY ['com', 'nso']::public.t_arr_code -- Имя схемы/схем рассматриваемых  -- 2018-04-09 Timur
       ,p_sch_name_forb     public.t_arr_code  = NULL -- Имя схемы/схем запрещенных       -- 2018-04-09 Timur 
        --
       ,p_impact_type_desr  public.t_arr_code  = NULL -- Тип воздействия рассматриваемый  -- 2018-04-09 Timur
       ,p_impact_type_forb  public.t_arr_code  = ARRAY['!']::public.t_arr_code -- Тип воздействия запрещённый      -- 2018-04-09 Timur
        --
       ,p_date_from         public.t_timestamp = (now()- interval '2 week')::public.t_timestamp -- Дата воздействия, нижняя граница
       ,p_date_to           public.t_timestamp = now()::public.t_timestamp       -- Дата воздействия, верхняя граница
        --
       ,p_limit             public.t_int       = 100 -- Выводимый блок  
       ,p_sort_hstore       public.t_text      = '1 => "impact_date DESC"' -- Сортировка (hstore)   
) 
RETURNS TABLE(
               id_log       public.id_t        -- ID события 
             , user_name    public.t_str250    -- Имя пользователя    
             , host_name    public.t_str250    -- IP хоста
             , impact_date  public.t_timestamp -- Дата воздействия
               --
             , sch_name     public.t_code6     -- Схема    
             , impact_type  public.t_code1     -- Код воздействия, локальный в пределах схемы 
             , object_id    public.id_t        -- ID объекта
             , object_name  public.t_text      -- Наименование объекта             
             , impact_descr public.t_text      -- Расширенное описание воздействия
)
AS
  $$
  -- ==============================================================================================
  -- Author: Gregory
  -- Create date: 2016-11-11
  -- Description:	Отображение сводного журнала учёта и изменений всех схем
  -- ----------------------------------------------------------------------------------------------
  -- 2016-11-12 Nick id_log вместо order_number.  Сохраняем традиции.
  -- 2016-11-21 Nick Имя схемы в выходном наборе.
  -- 2016-11-25 Nick Перестройка функции. Имя схемы - опциональный аргумент, диапазон дат.
  -- 2017-01-24 Nick Перестройка выходного набора. "IMPACT_DESCR" типа public.t_text
  -- 2017-02-08 Nick  Новое событие "Q - Обновление объекта с изменением его уровня секретности"
  -- 2018-03-26 Gregory сортировка
  -- 2018-04-09 Timur добавим новых атрибутов
  -- 2018-06-18 Nick Реанимация 
  -- ----------------------------------------------------------------------------------------------
  -- 2020-04-30 Nick Новое ядро и секционированный журнал.
  -- ==============================================================================================
    DECLARE
           _user_name         public.t_sysname := btrim ( p_user_name );
           _sch_name_descr    public.t_arr_code;
           _sch_name_forb     public.t_arr_code;
            --  
           _impact_type_desr  public.t_arr_code := p_impact_type_desr;
           _impact_type_forb  public.t_arr_code := p_impact_type_forb;
            --
          _limit    public.t_int := p_limit; -- По умолчанию 100 строк
          --
          _order    public.t_arr_text;
          _idx_attr public.t_arr_nmb;
          _rev_idx  public.t_arr_nmb;
          -- 
          _date_from public.t_timestamp = COALESCE (p_date_from, (now() - interval '2 week'));  -- Дата воздействия, нижняя граница
          _date_to   public.t_timestamp = COALESCE (p_date_to, now()::public.t_timestamp);     -- Дата воздействия, верхняя граница
  
          c_DEBUG   public.t_boolean := utl.f_debug_status();
          
    BEGIN
     IF (p_sch_name_desr IS NULL) 
     THEN
              _sch_name_descr := NULL::public.t_arr_code;                    
         ELSE                       
              _sch_name_descr := (SELECT array_agg (lower (btrim (arr_c))) 
                                                               FROM unnest (p_sch_name_desr) arr_c
                                 );
     END IF;
     --
     IF (p_sch_name_forb IS NULL) 
     THEN
              _sch_name_forb := NULL::public.t_arr_code;                    
         ELSE                       
              _sch_name_forb := (SELECT array_agg (lower (btrim (arr_c))) 
                                                        FROM unnest (p_sch_name_forb) arr_c
                                );
     END IF;            
         --
     WITH sort AS (SELECT string_to_array ( value, ' ') AS col_mod FROM 
                        EACH ( COALESCE (p_sort_hstore, '1 => "impact_date DESC"')::hstore ) ORDER BY key ASC
     )
     SELECT array_agg (col_mod::text) FROM sort INTO _order;
  
     WITH idxs AS ( SELECT row_number() OVER() AS idx, (u::t_arr_text)[1] AS attr FROM unnest (_order) u
     )
     SELECT avals ( hstore ( ROW (
             max(CASE attr WHEN 'id_log'       THEN idx ELSE 0 END)
            ,max(CASE attr WHEN 'user_name'    THEN idx ELSE 0 END)
            ,max(CASE attr WHEN 'host_name'    THEN idx ELSE 0 END)
            ,max(CASE attr WHEN 'impact_date'  THEN idx ELSE 0 END)
            ,max(CASE attr WHEN 'sch_name'     THEN idx ELSE 0 END)
            ,max(CASE attr WHEN 'impact_type'  THEN idx ELSE 0 END)
            ,max(CASE attr WHEN 'object_id'    THEN idx ELSE 0 END)
            ,max(CASE attr WHEN 'object_name'  THEN idx ELSE 0 END)
            ,max(CASE attr WHEN 'impact_descr' THEN idx ELSE 0 END)
         ))
     )
        FROM idxs INTO _idx_attr;
  
     WITH attrs AS ( SELECT (u::t_arr_text)[1] AS attr FROM unnest(_order) u
     )
     SELECT array_agg (
             CASE attr
                     WHEN 'id_log'       THEN 1
                     WHEN 'user_name'    THEN 2
                     WHEN 'host_name'    THEN 3
                     WHEN 'impact_date'  THEN 4
                     WHEN 'sch_name'     THEN 5
                     WHEN 'impact_type'  THEN 6
                     WHEN 'object_id'    THEN 7
                     WHEN 'object_name'  THEN 8
                     WHEN 'impact_descr' THEN 9
             END
     )
     FROM attrs INTO _rev_idx;
  
     IF c_DEBUG
       THEN
             RAISE NOTICE '<com_f_all_log_s> % % %', _order, _date_from, _date_to;
             RAISE NOTICE '<com_f_all_log_s> %', _idx_attr;
             RAISE NOTICE '<com_f_all_log_s> %', _rev_idx;
     END IF;
    
     RETURN QUERY
        WITH xd0 AS (	SELECT
                             al.id_log::public.id_t  AS id_log
                           , al.user_name            AS user_name
                           , al.host_name            AS host_name
                           , al.impact_date          AS impact_date
                           , al.schema_name          AS sch_name
                           , al.impact_type          AS impact_type
                           , al.impact_descr         AS impact_descr                
    	                FROM com.all_log_1 al
                     WHERE 
                          ((_user_name IS NULL) OR ((_user_name IS NOT NULL) AND (btrim (al.user_name) = _user_name))) AND  
                            -- 2018-04-09 Timur
                          ((_sch_name_descr   IS NULL) OR ((_sch_name_descr   IS NOT NULL) AND (lower (al.schema_name)  = ANY (_sch_name_descr)))) AND
                          ((_sch_name_forb    IS NULL) OR ((_sch_name_forb    IS NOT NULL) AND (lower (al.schema_name) <> ALL (_sch_name_forb))))  AND
                          ((_impact_type_desr IS NULL) OR ((_impact_type_desr IS NOT NULL) AND (lower (al.impact_type)  = ANY (_impact_type_desr)))) AND
                          ((_impact_type_forb IS NULL) OR ((_impact_type_forb IS NOT NULL) AND (lower (al.impact_type) <> ALL (_impact_type_forb)))) AND
                            -- 2018-04-09 Timur
                          ((_date_from IS NULL) OR ((_date_from IS NOT NULL) AND (al.impact_date >= _date_from))) AND
                          ((_date_to   IS NULL) OR ((_date_to   IS NOT NULL) AND (al.impact_date <= _date_to)))
  
           )
          ,query AS (
                     SELECT  xd0.id_log
                            ,xd0.user_name
                            ,xd0.host_name
                            ,xd0.impact_date
                            ,xd0.sch_name
                            ,xd0.impact_type
                            ,ac0.object_id
                            ,ac0.object_name::public.t_text
                            ,xd0.impact_descr
                     FROM xd0
                         LEFT JOIN LATERAL 
                            (  SELECT c0.id_log  -- Это историческая таблица, но она не наследуется.
                                     ,c0.object_id
                                     ,c0.object_short_name AS object_name
                                FROM com.obj_object_hist c0 WHERE ( c0.id_log = xd0.id_log)
                                 
                              UNION ALL
                              
                                SELECT c1.id_log 
                                     ,c1.object_id
                                     ,c1.object_short_name AS object_name
                                FROM com.obj_object c1 WHERE ( c1.id_log = xd0.id_log)                                 
                                 
                              UNION ALL
                              
                               SELECT c2.id_log
                                     ,c2.codif_id   AS object_id
                                     ,c2.codif_name AS object_name
                                 FROM com.obj_codifier c2 WHERE (c2.id_log = xd0.id_log)
                                 
                              UNION ALL
                              
                               SELECT c3.id_log
                                     ,c3.attr_id   AS object_id
                                     ,c3.attr_name AS object_name
                                 FROM com.nso_domain_column c3 WHERE (c3.id_log = xd0.id_log)
                                 
                              UNION ALL
                    
                               SELECT n1.id_log
                                     ,n1.nso_id   AS object_id
                                     ,n1.nso_name AS object_name
                               FROM nso.nso_object n1 WHERE (n1.id_log = xd0.id_log)
                    
                              UNION ALL
                    
                               SELECT n2.log_id AS id_log
                                     ,n2.rec_id AS object_id
                                    ,(nso_structure.nso_f_object_get_code(n2.nso_id))::public.t_fullname 
                                                AS object_name
                                FROM nso.nso_record n2 WHERE ( n2.log_id = xd0.id_log )                        
                            ) ac0 ON ((xd0.id_log) = (ac0.id_log))
           ) 
          ,sort AS (
                  SELECT
                          q.id_log
                         ,q.user_name
                         ,q.host_name
                         ,q.impact_date
                         ,lower(q.sch_name)::public.t_code6 AS sch_name
                         ,q.impact_type
                         ,q.object_id
                         ,q.object_name
                         ,q.impact_descr                         
  
                         ,ARRAY [
                                  s_id_log.num
                                 ,s_user_name.num
                                 ,s_host_name.num
                                 ,s_impact_date.num
                                 ,s_sch_name.num
                                 ,s_impact_type.num
                                 ,s_object_id.num
                                 ,s_object_name.num
                                 ,s_impact_descr.num                         
                          ] AS ordr
                  FROM query q
                       LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[1]])::t_arr_text)[2] = 'DESC' THEN row_number() OVER(ORDER BY qs.id_log       DESC) ELSE row_number() OVER(ORDER BY qs.id_log       ASC) END AS num, qs.id_log       FROM query qs WHERE _idx_attr[1] > 0 GROUP BY qs.id_log      ) s_id_log       USING(id_log)
                       LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[2]])::t_arr_text)[2] = 'DESC' THEN row_number() OVER(ORDER BY qs.user_name    DESC) ELSE row_number() OVER(ORDER BY qs.user_name    ASC) END AS num, qs.user_name    FROM query qs WHERE _idx_attr[2] > 0 GROUP BY qs.user_name   ) s_user_name    USING(user_name)
                       LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[3]])::t_arr_text)[2] = 'DESC' THEN row_number() OVER(ORDER BY qs.host_name    DESC) ELSE row_number() OVER(ORDER BY qs.host_name    ASC) END AS num, qs.host_name    FROM query qs WHERE _idx_attr[3] > 0 GROUP BY qs.host_name   ) s_host_name    USING(host_name)
                       LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[4]])::t_arr_text)[2] = 'DESC' THEN row_number() OVER(ORDER BY qs.impact_date  DESC) ELSE row_number() OVER(ORDER BY qs.impact_date  ASC) END AS num, qs.impact_date  FROM query qs WHERE _idx_attr[4] > 0 GROUP BY qs.impact_date ) s_impact_date  USING(impact_date)
                       LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[5]])::t_arr_text)[2] = 'DESC' THEN row_number() OVER(ORDER BY qs.sch_name     DESC) ELSE row_number() OVER(ORDER BY qs.sch_name     ASC) END AS num, qs.sch_name     FROM QUERY qs WHERE _idx_attr[5] > 0 GROUP BY qs.sch_name    ) s_sch_name     USING(sch_name)
                       LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[6]])::t_arr_text)[2] = 'DESC' THEN row_number() OVER(ORDER BY qs.impact_type  DESC) ELSE row_number() OVER(ORDER BY qs.impact_type  ASC) END AS num, qs.impact_type  FROM query qs WHERE _idx_attr[6] > 0 GROUP BY qs.impact_type ) s_impact_type  USING(impact_type)
                       LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[7]])::t_arr_text)[2] = 'DESC' THEN row_number() OVER(ORDER BY qs.object_id    DESC) ELSE row_number() OVER(ORDER BY qs.object_id    ASC) END AS num, qs.object_id    FROM query qs WHERE _idx_attr[7] > 0 GROUP BY qs.object_id   ) s_object_id    USING(object_id)
                       LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[8]])::t_arr_text)[2] = 'DESC' THEN row_number() OVER(ORDER BY qs.object_name  DESC) ELSE row_number() OVER(ORDER BY qs.object_name  ASC) END AS num, qs.object_name  FROM query qs WHERE _idx_attr[8] > 0 GROUP BY qs.object_name ) s_object_name  USING(object_name)
                       LEFT JOIN LATERAL (SELECT DISTINCT CASE WHEN ((_order[_idx_attr[9]])::t_arr_text)[2] = 'DESC' THEN row_number() OVER(ORDER BY qs.impact_descr DESC) ELSE row_number() OVER(ORDER BY qs.impact_descr ASC) END AS num, qs.impact_descr FROM query qs WHERE _idx_attr[9] > 0 GROUP BY qs.impact_descr) s_impact_descr USING(impact_descr)
          )
            SELECT
                    s.id_log
                   ,s.user_name
                   ,s.host_name
                   ,s.impact_date
                   ,s.sch_name
                   ,s.impact_type
                   ,s.object_id   
                   ,s.object_name 
                   ,s.impact_descr
                    --
            FROM sort s
            ORDER BY
                    ordr[_rev_idx[1]]
                   ,ordr[_rev_idx[2]]
                   ,ordr[_rev_idx[3]]
                   ,ordr[_rev_idx[4]]
                   ,ordr[_rev_idx[5]]
                   ,ordr[_rev_idx[6]]
                   ,ordr[_rev_idx[7]]
                   ,ordr[_rev_idx[8]]
                   ,ordr[_rev_idx[9]]
            LIMIT _limit;
    END;
  $$
SECURITY INVOKER LANGUAGE plpgsql;
COMMENT ON FUNCTION com.com_f_all_log_s (public.t_sysname,   public.t_arr_code,  public.t_arr_code, public.t_arr_code, public.t_arr_code,
                                         public.t_timestamp, public.t_timestamp, public.t_int,      public.t_text 
)
IS '317: Отображение сводного журнала событий

   Входные параметры:
      1)  p_user_name         public.t_sysname   = NULL -- Логин пользователя
      2) ,p_sch_name_desr     public.t_arr_code  = ARRAY [''com'', ''nso'']::public.t_arr_code -- Имя схемы/схем рассматриваемых   
      3) ,p_sch_name_forb     public.t_arr_code  = NULL -- Имя схемы/схем нерассматриваемый (запрещённый)  
      --                     
      4) ,p_impact_type_desr  public.t_arr_code  = NULL -- Тип воздействия рассматриваемый   
      5) ,p_impact_type_forb  public.t_arr_code  = ARRAY[''!'']::public.t_arr_code  -- Тип воздействия нерассматриваемый (запрещённый) 
          --                 
      6) ,p_date_from         public.t_timestamp = (now() - interval ''2 week'')::public.t_timestamp -- Дата воздействия, нижняя граница (Две недели тому назад)
      7) ,p_date_to           public.t_timestamp = now()::public.t_timestamp -- Дата воздействия, верхняя граница (Сегодня)
          --                 
      8) ,p_limit             public.t_int       = 100 -- Выводимый блок  
      9) ,p_sort_hstore       public.t_text      = ''1 => "impact_date DESC"'' -- Сортировка (hstore)   

	Выходные параметры:

      1)  id_log        public.id_t        -- ID события 
      2) ,user_name     public.t_str250    -- Имя пользователя    
      3) ,host_name     public.t_str250    -- IP хоста
      4) ,impact_date   public.t_timestamp -- Дата воздействия
          --           
      5) ,sch_name      public.t_code6  -- Схема    
      6) ,impact_type   public.t_code1  -- Код воздействия, локальный в пределах схемы 
      7) ,object_id     public.id_t     -- ID объекта
      8) ,object_name   public.t_text   -- Наименование объекта             
      9) ,impact_descr  public.t_text   -- Расширенное описание воздействия
';
-- -------------------------------------------------------------------------------------------------------------

-- SELECT * FROM com.com_f_all_log_s (p_date_from := '2020-01-01'); -- Суммарное время выполнения запроса: 113 ms. 18 строк получено.
-- SELECT * from com.all_v_event_log_op WHERE (impact_date >= '2020-01-01');  -- 144 ms 29 rows Неверно
-- SELECT * FROM com.com_log_1 WHERE ( impact_date >= '2020-01-01') --10 - 1 = 9
-- SELECT * FROM nso.nso_log_1 WHERE ( impact_date >= '2020-01-01') --11 -2 = 9
-- ----------------------------------------------------------------------------
-- SELECT * FROM com.com_f_all_log_s (p_date_from := '2010-01-01', p_limit := NULL);  -- m326 ms 699 rows
-- SELECT * FROM com.com_f_all_log_s (p_date_from := '2010-01-01', p_limit := NULL);  -- m300 ms 699 rows
-- SELECT * from com.all_v_event_log_op; -- 204 699
-- SELECT * FROM com.com_f_all_log_s (p_date_from := '2010-01-01', p_limit := NULL, p_impact_type_forb := NULL); --366 ms 840
-- SELECT * FROM com.com_f_all_log_s (p_date_from := '2010-01-01', p_limit := NULL
-- 								   , p_impact_type_forb := NULL); -- 317
-- SELECT * FROM com.com_f_all_log_s (); -- Пусто
-- SELECT * FROM com.com_f_all_log_s (p_date_from := '2010-01-01', p_limit := NULL
--   ,p_impact_type_forb := NULL, p_sort_hstore := '1 => "impact_date DESC", 3 => "id_log ASC", 2 => "sch_name ASC"'); -- 317
-- --
-- SELECT * FROM com.com_f_all_log_s (p_date_from := '2010-01-01', p_limit := NULL
--   ,p_impact_type_forb := NULL, p_sort_hstore := '1 => "impact_date DESC", 3 => "id_log ASC", 2 => "object_id ASC"'); 
