SELECT * FROM com.nso_f_domain_column_s ('APP_NODE');
-- 100|3|'FC_TEXT'|'Текст не лимитированной длины. Может содержать гигабайты текстовой информации в одной ячейке'. Новый атрибут.
SELECT * FROM nso.nso_f_object_s_sys ('CL_TEST3');
SELECT * FROM nso.nso_f_column_head_nso_s ('CL_TEST3');
--------------------------------------------------------------------------------------------------
-- 397|   |0|189|'D_CL_TEST3' |'Заголовок - Тестовый классификатор #'|7|'U'|'C_DOMEN_NODE'|'Узловой Атрибут'       |f|||||''|''|''|0
-- 398|397|1| 14|'DATE_START' |'Дата начала кампании'               |21|'B'|'T_STR250'    |'Строка 250 символов'           |f|163|t|1|45|'a'|'AKKEY1'|'Уникальный ключ 1'|1
-- 401|397|2| 37|'COST_PLAN_1'|'Ожидаемые плановые затраты'         |33|'N'|'T_MONEY'     |'Денежная единица'              |f|||||''|''|''|1
-- 399|397|3|100|'DESCR'      |'Описание кампании'                  |38|'Я'|'T_TEXT'      |'Текст не лимитированной длины.'|f|162|t|1|51|'g'|'DEFKEY'|'Значение по умолчанию'|1
-- 402|397|4| 37|'COST_FACT'  |'Затраты на кампанию фактические'    |33|'N'|'T_MONEY'     |'Денежная единица'              |f|||||''|''|''|1

-- 1) Заменить   атрибут №2  тип T_MONEY,  на T_TEXT Это "nso_abs". Секционированная таблица

SELECT * FROM nso.v_CL_TEST3;
-----------------------------
                  WITH 
                    attrs AS ( -- info по новому и старому типу атрибута
                               SELECT
                                       oc.codif_code
                                      ,oc.small_code
                                      ,CASE ndc.attr_id
                                               WHEN 100 THEN TRUE
                                                              ELSE FALSE
                                       END AS new_type
                               FROM ONLY com.nso_domain_column ndc
                                 JOIN ONLY com.obj_codifier    oc   ON (oc.codif_id = ndc.attr_type_id)
                               WHERE (ndc.attr_id = 100) OR (ndc.attr_id = 37)
                    )
--                       SELECT * FROM attrs;
--                       'T_MONEY'|'N'|f
--                       'T_TEXT'|'Я'|t
                   ,change AS ( -- формируем ключевую строку "было - стало"
                       SELECT
                            CAST (MAX(CASE new_type WHEN FALSE THEN codif_code ELSE NULL END) AS public.t_str60) AS old_code
                           ,CAST (MAX(CASE new_type WHEN FALSE THEN small_code ELSE NULL END) AS public.t_code1) AS old_scode
                           ,CAST (MAX(CASE new_type WHEN TRUE  THEN codif_code ELSE NULL END) AS public.t_str60) AS new_code
                           ,CAST (MAX(CASE new_type WHEN TRUE  THEN small_code ELSE NULL END) AS public.t_code1) AS new_scode
                       FROM attrs  -- Свёртываем в одну строку.
                    )
--                       SELECT * FROM change;
--                       'T_MONEY'|'N'|'T_TEXT'|'Я'
                    
                   ,records AS ( -- Существующие данные Nick 2019-08-13. Основа, содержит section_sign.
                                 SELECT rec_id FROM ONLY nso.nso_record WHERE (nso_id = 109)
                    )
--                       SELECT * FROM records;   -- Всего две записи.
                      ----------------------------------------------
-- 			37327
-- 			37326
                   ,oldrefs AS ( -- разыменование ссылок если был T_REF а будет не T_BLOB
                                 SELECT
                                         nr.rec_id
                                        ,nr.col_id
                                        ,nso.nso_f_record_def_val (nr.ref_rec_id) AS def_val
                                 FROM
                                         change
                                        ,records r
                                        ,ONLY nso.nso_ref nr
                                 WHERE -- если был T_REF и будет любой скалярный тип, иначе блок не вычисляется ~ WHERE FALSE
                                         ( old_code  = 'T_REF' ) AND ( new_code != 'T_REF' )
                                     AND ( new_code != 'T_BLOB') AND ( nr.rec_id = r.rec_id )
                                     AND ( nr.col_id = 401 )
                    )
                    -- SELECT * FROM oldrefs; -- Пусто, всё правильно
                    
                   ,clearref AS ( -- чистим nso_ref если был T_REF а будет не T_REF
                                   DELETE FROM ONLY nso.nso_ref rf
                                       USING change, records r
                                   WHERE
                                           ( old_code = 'T_REF' )     AND ( new_code != 'T_REF' )
                                       AND ( rf.rec_id = r.rec_id ) AND ( rf.col_id = 401 )
                                   RETURNING r.rec_id
                    )
                     -- SELECT * FROM clearref;  -- Пусто, один столбец "rec_id"
                     
                   ,clearblob AS ( -- чистим nso_blob если был T_BLOB а будет не T_BLOB
                                   DELETE FROM ONLY nso.nso_blob b
                                       USING change, records r
                                   WHERE
                                           (change.old_code = 'T_BLOB') AND (change.new_code != 'T_BLOB')
                                       AND (b.rec_id = r.rec_id)      AND (b.col_id = 401)
                                   RETURNING r.rec_id
                    )
                     -- SELECT * FROM clearblob; -- Пусто, один столбец
                     
                   ,clearabs AS ( -- чистим nso_abs если был скалярный тип(не T_REF и не T_BLOB) а будет не скалярный тип(T_REF или T_BLOB)
                                  DELETE FROM ONLY nso.nso_abs a
                                       USING change, records r
                                  WHERE
                                          (change.old_code != 'T_REF') AND (change.old_code != 'T_BLOB')
                                      AND (change.new_code = 'T_REF' OR change.new_code = 'T_BLOB')
                                      AND (a.rec_id = r.rec_id) AND (a.col_id = 401)
                                  RETURNING r.rec_id
                    )
                      --SELECT * FROM clearabs;
                      
                   ,addref AS ( -- Nick 2019-08-13 Несекционированная таблица
                                 INSERT INTO nso.nso_ref (rec_id, col_id, ref_rec_id)
                                 SELECT
                                         rec_id, 401, NULL
                                 FROM
                                         change, records
                                 WHERE
                                         (change.old_code != 'T_REF')  AND (change.new_code = 'T_REF')
                                 RETURNING rec_id
                    )
                    -- SELECT * FROM addref;
                    
                   ,addblob AS ( -- Nick 2019-08-13 Секционированная таблица.
                                 INSERT INTO nso.nso_blob (
                                         rec_id
                                        ,col_id
                                        ,val_cel_hash
                                        ,val_cel_data_name
                                        ,val_cell_blob
                                 )
                                 SELECT  rec_id
                                        ,401
                                        ,NULL
                                        ,NULL
                                        ,NULL
                                 FROM
                                      change, records
                                 WHERE
                                        ( change.old_code != 'T_BLOB') AND (change.new_code = 'T_BLOB')
                                 RETURNING rec_id
                    )
                     -- SELECT * FROM addblob;
                      
                   ,addabs AS (  -- Nick 2019-08-13 Секционированная таблица.
                                 INSERT INTO nso.nso_abs (
                                         rec_id
                                        ,col_id
                                        ,s_type_code
                                        ,s_key_code
                                        ,val_cell_abs
                                 )
                                 SELECT  r.rec_id
                                        ,401
                                        ,change.new_scode
                                        ,COALESCE(
                                                 (SELECT k.key_small_code
                                                 FROM
                                                         ONLY nso.nso_key k
                                                        ,ONLY nso.nso_key_attr a
                                                 WHERE
                                                         k.key_id = a.key_id
                                                     AND a.col_id = 401
                                                 )
                                                ,'0'
                                         )
                                        ,orf.def_val
                                 FROM
                                         change, records r
                                         
                                 LEFT JOIN oldrefs orf ON (orf.rec_id = r.rec_id)
                                 WHERE
                                         ( change.old_code = 'T_REF' OR change.old_code = 'T_BLOB' )
                                     AND ( change.new_code != 'T_REF') AND (change.new_code != 'T_BLOB')
                                 RETURNING rec_id
                    )
                   ,updabs AS (
                                UPDATE ONLY nso.nso_abs a SET s_type_code = change.new_scode
                                FROM
                                     change, records r
                                WHERE
                                        (change.new_code != 'T_REF')
                                    AND (change.new_code != 'T_BLOB')
                                    AND (change.new_code != change.old_code)
                                    AND (a.rec_id = r.rec_id)
                                    AND (a.col_id = 401)
                                RETURNING r.rec_id
                    )
--                      SELECT * FROM updabs;
--                      37327
--                      37326
                    SELECT
                         c.old_code
                        ,c.old_scode
                        ,c.new_code
                        ,c.new_scode
                        ,r.rec_id
                        ,left (dv.def_val, 64) -- ??? Nick 2019-08-13
                        ,CASE WHEN cr.rec_id IS NULL THEN NULL ELSE 'rem ref'  END
                        ,CASE WHEN cb.rec_id IS NULL THEN NULL ELSE 'rem blob' END
                        ,CASE WHEN ca.rec_id IS NULL THEN NULL ELSE 'rem abs'  END
                        ,CASE WHEN ar.rec_id IS NULL THEN NULL ELSE 'add ref'  END
                        ,CASE WHEN ab.rec_id IS NULL THEN NULL ELSE 'add blob' END
                        ,CASE WHEN aa.rec_id IS NULL THEN NULL ELSE 'add abs'  END
                        ,CASE WHEN ua.rec_id IS NULL THEN NULL ELSE 'upd abs'  END
                        ,left(a.val_cell_abs, 64)
                        ,CASE
                                 WHEN c.new_code != 'T_REF' AND c.new_code != 'T_BLOB'
                                 THEN com.com_f_value_check (c.new_scode, val_cell_abs)
                         END AS chck
                    FROM
                            change c, records r
                                 LEFT JOIN oldrefs     dv ON (dv.rec_id = r.rec_id)
                                 LEFT JOIN clearref    cr ON (cr.rec_id = r.rec_id)
                                 LEFT JOIN clearblob   cb ON (cb.rec_id = r.rec_id)
                                 LEFT JOIN clearabs    ca ON (ca.rec_id = r.rec_id)
                                 LEFT JOIN addref      ar ON (ar.rec_id = r.rec_id)
                                 LEFT JOIN addblob     ab ON (ab.rec_id = r.rec_id)
                                 LEFT JOIN addabs      aa ON (aa.rec_id = r.rec_id)
                                 LEFT JOIN updabs      ua ON (ua.rec_id = r.rec_id)
                                 JOIN ONLY nso.nso_abs  a ON ( a.rec_id = r.rec_id)
                    WHERE (a.col_id = 401)

--                ) -- End of Query
--                 LOOP
--                        IF C_DEBUG
--                          THEN
--                                RAISE NOTICE '<%>, %', c_ERR_FUNC_NAME, _dbg_record;
--                        END IF;
--                        
--                        IF (_dbg_record.chck).rc < 0 AND (_dbg_record.chck).rc != -9
--                        THEN
--                                RAISE EXCEPTION '%', (_dbg_record.chck).errm;
--                        END IF;
--                 END LOOP; -- Основной цикл Nick 2019-08-13
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 'T_MONEY'|'N'|'T_TEXT'|'Я'|37327|''|''|''|''|''|''|''|'upd abs'|'8431.80'|'(0,"Приведение к типу ""Строка 2048 символов"": проверка, выполнена успешно")'
-- 'T_MONEY'|'N'|'T_TEXT'|'Я'|37326|''|''|''|''|''|''|''|'upd abs'| '345.90'|'(0,"Приведение к типу ""Строка 2048 символов"": проверка, выполнена успешно")'
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
 EXPLAIN ANALYSE
                  WITH 
                    attrs AS ( -- info по новому и старому типу атрибута
                               SELECT
                                       oc.codif_code
                                      ,oc.small_code
                                      ,CASE ndc.attr_id
                                               WHEN 100 THEN TRUE
                                                              ELSE FALSE
                                       END AS new_type
                               FROM ONLY com.nso_domain_column ndc
                                 JOIN ONLY com.obj_codifier    oc   ON (oc.codif_id = ndc.attr_type_id)
                               WHERE (ndc.attr_id = 100) OR (ndc.attr_id = 37)
                    )
--                       SELECT * FROM attrs;
--                       'T_MONEY'|'N'|f
--                       'T_TEXT'|'Я'|t
                   ,change AS ( -- формируем ключевую строку "было - стало"
                       SELECT
                            CAST (MAX(CASE new_type WHEN FALSE THEN codif_code ELSE NULL END) AS public.t_str60) AS old_code
                           ,CAST (MAX(CASE new_type WHEN FALSE THEN small_code ELSE NULL END) AS public.t_code1) AS old_scode
                           ,CAST (MAX(CASE new_type WHEN TRUE  THEN codif_code ELSE NULL END) AS public.t_str60) AS new_code
                           ,CAST (MAX(CASE new_type WHEN TRUE  THEN small_code ELSE NULL END) AS public.t_code1) AS new_scode
                       FROM attrs  -- Свёртываем в одну строку.
                    )
--                       SELECT * FROM change;
--                       'T_MONEY'|'N'|'T_TEXT'|'Я'
                    
                   ,records AS ( -- Существующие данные Nick 2019-08-13. Основа, содержит section_sign.
                                 SELECT rec_id FROM ONLY nso.nso_record WHERE (nso_id = 109)
                    )
--                       SELECT * FROM records;   -- Всего две записи.
                      ----------------------------------------------
-- 			37327
-- 			37326
                   ,oldrefs AS ( -- разыменование ссылок если был T_REF а будет не T_BLOB
                                 SELECT
                                         nr.rec_id
                                        ,nr.col_id
                                        ,nso.nso_f_record_def_val (nr.ref_rec_id) AS def_val
                                 FROM
                                         change
                                        ,records r
                                        ,ONLY nso.nso_ref nr
                                 WHERE -- если был T_REF и будет любой скалярный тип, иначе блок не вычисляется ~ WHERE FALSE
                                         ( old_code  = 'T_REF' ) AND ( new_code != 'T_REF' )
                                     AND ( new_code != 'T_BLOB') AND ( nr.rec_id = r.rec_id )
                                     AND ( nr.col_id = 401 )
                    )
                    -- SELECT * FROM oldrefs; -- Пусто, всё правильно
                    
                   ,clearref AS ( -- чистим nso_ref если был T_REF а будет не T_REF
                                   DELETE FROM ONLY nso.nso_ref rf
                                       USING change, records r
                                   WHERE
                                           ( old_code = 'T_REF' )     AND ( new_code != 'T_REF' )
                                       AND ( rf.rec_id = r.rec_id ) AND ( rf.col_id = 401 )
                                   RETURNING r.rec_id
                    )
                     -- SELECT * FROM clearref;  -- Пусто, один столбец "rec_id"
                     
                   ,clearblob AS ( -- чистим nso_blob если был T_BLOB а будет не T_BLOB
                                   DELETE FROM ONLY nso.nso_blob b
                                       USING change, records r
                                   WHERE
                                           (change.old_code = 'T_BLOB') AND (change.new_code != 'T_BLOB')
                                       AND (b.rec_id = r.rec_id)      AND (b.col_id = 401)
                                   RETURNING r.rec_id
                    )
                     -- SELECT * FROM clearblob; -- Пусто, один столбец
                     
                   ,clearabs AS ( -- чистим nso_abs если был скалярный тип(не T_REF и не T_BLOB) а будет не скалярный тип(T_REF или T_BLOB)
                                  DELETE FROM ONLY nso.nso_abs a
                                       USING change, records r
                                  WHERE
                                          (change.old_code != 'T_REF') AND (change.old_code != 'T_BLOB')
                                      AND (change.new_code = 'T_REF' OR change.new_code = 'T_BLOB')
                                      AND (a.rec_id = r.rec_id) AND (a.col_id = 401)
                                  RETURNING r.rec_id
                    )
                      --SELECT * FROM clearabs;
                      
                   ,addref AS ( -- Nick 2019-08-13 Несекционированная таблица
                                 INSERT INTO nso.nso_ref (rec_id, col_id, ref_rec_id)
                                 SELECT
                                         rec_id, 401, NULL
                                 FROM
                                         change, records
                                 WHERE
                                         (change.old_code != 'T_REF')  AND (change.new_code = 'T_REF')
                                 RETURNING rec_id
                    )
                    -- SELECT * FROM addref;
                    
                   ,addblob AS ( -- Nick 2019-08-13 Секционированная таблица.
                                 INSERT INTO nso.nso_blob (
                                         rec_id
                                        ,col_id
                                        ,val_cel_hash
                                        ,val_cel_data_name
                                        ,val_cell_blob
                                 )
                                 SELECT  rec_id
                                        ,401
                                        ,NULL
                                        ,NULL
                                        ,NULL
                                 FROM
                                      change, records
                                 WHERE
                                        ( change.old_code != 'T_BLOB') AND (change.new_code = 'T_BLOB')
                                 RETURNING rec_id
                    )
                     -- SELECT * FROM addblob;
                      
                   ,addabs AS (  -- Nick 2019-08-13 Секционированная таблица.
                                 INSERT INTO nso.nso_abs (
                                         rec_id
                                        ,col_id
                                        ,s_type_code
                                        ,s_key_code
                                        ,val_cell_abs
                                 )
                                 SELECT  r.rec_id
                                        ,401
                                        ,change.new_scode
                                        ,COALESCE(
                                                 (SELECT k.key_small_code
                                                 FROM
                                                         ONLY nso.nso_key k
                                                        ,ONLY nso.nso_key_attr a
                                                 WHERE
                                                         k.key_id = a.key_id
                                                     AND a.col_id = 401
                                                 )
                                                ,'0'
                                         )
                                        ,orf.def_val
                                 FROM
                                         change, records r
                                         
                                 LEFT JOIN oldrefs orf ON (orf.rec_id = r.rec_id)
                                 WHERE
                                         ( change.old_code = 'T_REF' OR change.old_code = 'T_BLOB' )
                                     AND ( change.new_code != 'T_REF') AND (change.new_code != 'T_BLOB')
                                 RETURNING rec_id
                    )
                   ,updabs AS (
                                UPDATE ONLY nso.nso_abs a SET s_type_code = change.new_scode
                                FROM
                                     change, records r
                                WHERE
                                        (change.new_code != 'T_REF')
                                    AND (change.new_code != 'T_BLOB')
                                    AND (change.new_code != change.old_code)
                                    AND (a.rec_id = r.rec_id)
                                    AND (a.col_id = 401)
                                RETURNING r.rec_id
                    )
--                      SELECT * FROM updabs;
--                      37327
--                      37326
                    SELECT
                         c.old_code
                        ,c.old_scode
                        ,c.new_code
                        ,c.new_scode
                        ,r.rec_id
                        ,left (dv.def_val, 64) -- ??? Nick 2019-08-13
                        ,CASE WHEN cr.rec_id IS NULL THEN NULL ELSE 'rem ref'  END
                        ,CASE WHEN cb.rec_id IS NULL THEN NULL ELSE 'rem blob' END
                        ,CASE WHEN ca.rec_id IS NULL THEN NULL ELSE 'rem abs'  END
                        ,CASE WHEN ar.rec_id IS NULL THEN NULL ELSE 'add ref'  END
                        ,CASE WHEN ab.rec_id IS NULL THEN NULL ELSE 'add blob' END
                        ,CASE WHEN aa.rec_id IS NULL THEN NULL ELSE 'add abs'  END
                        ,CASE WHEN ua.rec_id IS NULL THEN NULL ELSE 'upd abs'  END
                        ,left(a.val_cell_abs, 64)
                        ,CASE
                                 WHEN c.new_code != 'T_REF' AND c.new_code != 'T_BLOB'
                                 THEN com.com_f_value_check (c.new_scode, val_cell_abs)
                         END AS chck
                    FROM
                            change c, records r
                                 LEFT JOIN oldrefs     dv ON (dv.rec_id = r.rec_id)
                                 LEFT JOIN clearref    cr ON (cr.rec_id = r.rec_id)
                                 LEFT JOIN clearblob   cb ON (cb.rec_id = r.rec_id)
                                 LEFT JOIN clearabs    ca ON (ca.rec_id = r.rec_id)
                                 LEFT JOIN addref      ar ON (ar.rec_id = r.rec_id)
                                 LEFT JOIN addblob     ab ON (ab.rec_id = r.rec_id)
                                 LEFT JOIN addabs      aa ON (aa.rec_id = r.rec_id)
                                 LEFT JOIN updabs      ua ON (ua.rec_id = r.rec_id)
                                 JOIN ONLY nso.nso_abs  a ON ( a.rec_id = r.rec_id)
                    WHERE (a.col_id = 401);
--------------------------------------------------------------------------------------
-- Nested Loop  (cost=763.81..1010.85 rows=1 width=456) (actual time=3.607..4.117 rows=2 loops=1)
--   CTE attrs
--     ->  Hash Join  (cost=6.46..22.41 rows=2 width=14) (actual time=0.135..0.420 rows=2 loops=1)
--           Hash Cond: (oc.codif_id = (ndc.attr_type_id)::bigint)
--           ->  Seq Scan on obj_codifier oc  (cost=0.00..13.62 rows=462 width=21) (actual time=0.026..0.166 rows=462 loops=1)
--           ->  Hash  (cost=6.43..6.43 rows=2 width=16) (actual time=0.084..0.084 rows=2 loops=1)
--                 Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                 ->  Seq Scan on nso_domain_column ndc  (cost=0.00..6.43 rows=2 width=16) (actual time=0.056..0.078 rows=2 loops=1)
--                       Filter: ((attr_id = 100) OR (attr_id = 37))
--                       Rows Removed by Filter: 160
--   CTE change
--     ->  Aggregate  (cost=0.06..0.09 rows=1 width=128) (actual time=0.446..0.446 rows=1 loops=1)
--           ->  CTE Scan on attrs  (cost=0.00..0.04 rows=2 width=65) (actual time=0.138..0.425 rows=2 loops=1)
--   CTE records
--     ->  Index Scan using ie2_nso_record on nso_record  (cost=0.29..51.34 rows=29 width=8) (actual time=0.048..0.054 rows=2 loops=1)
--           Index Cond: ((nso_id)::bigint = 109)
--   CTE oldrefs
--     ->  Nested Loop  (cost=0.00..91.10 rows=1 width=48) (actual time=0.455..0.455 rows=0 loops=1)
--           Join Filter: ((nr.rec_id)::bigint = r_1.rec_id)
--           ->  Nested Loop  (cost=0.00..89.90 rows=1 width=24) (actual time=0.454..0.454 rows=0 loops=1)
--                 ->  CTE Scan on change  (cost=0.00..0.03 rows=1 width=0) (actual time=0.453..0.453 rows=0 loops=1)
--                       Filter: (((new_code)::text <> 'T_REF'::text) AND ((new_code)::text <> 'T_BLOB'::text) AND ((old_code)::text = 'T_REF'::text))'
--                       Rows Removed by Filter: 1
--                 ->  Seq Scan on nso_ref nr  (cost=0.00..89.86 rows=1 width=24) (never executed)
--                       Filter: ((col_id)::bigint = 401)
--           ->  CTE Scan on records r_1  (cost=0.00..0.58 rows=29 width=8) (never executed)
--   CTE clearref
--     ->  Delete on nso_ref rf  (cost=0.00..90.84 rows=1 width=70) (actual time=0.725..0.726 rows=0 loops=1)
--           ->  Nested Loop  (cost=0.00..90.84 rows=1 width=70) (actual time=0.723..0.723 rows=0 loops=1)
--                 ->  Nested Loop  (cost=0.00..90.81 rows=1 width=46) (actual time=0.723..0.723 rows=0 loops=1)
--                       Join Filter: ((rf.rec_id)::bigint = r_2.rec_id)
--                       ->  Seq Scan on nso_ref rf  (cost=0.00..89.86 rows=1 width=14) (actual time=0.721..0.722 rows=0 loops=1)
--                             Filter: ((col_id)::bigint = 401)
--                             Rows Removed by Filter: 4389
--                       ->  CTE Scan on records r_2  (cost=0.00..0.58 rows=29 width=40) (never executed)
--                 ->  CTE Scan on change change_1  (cost=0.00..0.03 rows=1 width=24) (never executed)
--                       Filter: (((new_code)::text <> 'T_REF'::text) AND ((old_code)::text = 'T_REF'::text)) 
--   CTE clearblob
--     ->  Delete on nso_blob b  (cost=1.07..1.78 rows=1 width=70) (actual time=0.031..0.031 rows=0 loops=1)
--           ->  Nested Loop  (cost=1.07..1.78 rows=1 width=70) (actual time=0.030..0.031 rows=0 loops=1)
--                 ->  Hash Join  (cost=1.07..1.74 rows=1 width=46) (actual time=0.030..0.030 rows=0 loops=1)
--                       Hash Cond: (r_3.rec_id = (b.rec_id)::bigint)
--                       ->  CTE Scan on records r_3  (cost=0.00..0.58 rows=29 width=40) (actual time=0.010..0.010 rows=1 loops=1)
--                       ->  Hash  (cost=1.06..1.06 rows=1 width=14) (actual time=0.015..0.015 rows=0 loops=1)
--                             Buckets: 1024  Batches: 1  Memory Usage: 8kB
--                             ->  Seq Scan on nso_blob b  (cost=0.00..1.06 rows=1 width=14) (actual time=0.014..0.014 rows=0 loops=1)
--                                   Filter: ((col_id)::bigint = 401)
--                                   Rows Removed by Filter: 5
--                 ->  CTE Scan on change change_2  (cost=0.00..0.03 rows=1 width=24) (never executed)
--                       Filter: (((new_code)::text <> 'T_BLOB'::text) AND ((old_code)::text = 'T_BLOB'::text))
--   CTE clearabs
--     ->  Delete on nso_abs a_1  (cost=0.42..245.50 rows=1 width=70) (actual time=0.058..0.058 rows=0 loops=1)
--           ->  Nested Loop  (cost=0.42..245.50 rows=1 width=70) (actual time=0.057..0.057 rows=0 loops=1)
--                 ->  Nested Loop  (cost=0.42..245.46 rows=1 width=46) (actual time=0.036..0.052 rows=2 loops=1)
--                       ->  CTE Scan on records r_4  (cost=0.00..0.58 rows=29 width=40) (actual time=0.005..0.013 rows=2 loops=1)
--                       ->  Index Scan using pk_nso_abs on nso_abs a_1  (cost=0.42..8.44 rows=1 width=14) (actual time=0.016..0.016 rows=1 loops=2)
--                             Index Cond: (((rec_id)::bigint = r_4.rec_id) AND ((col_id)::bigint = 401))
--                 ->  CTE Scan on change change_3  (cost=0.00..0.03 rows=1 width=24) (actual time=0.002..0.002 rows=0 loops=2)
--                       Filter: (((old_code)::text <> 'T_REF'::text) AND ((old_code)::text <> 'T_BLOB'::text) AND (((new_code)::text = 'T_REF'::text) OR ((new_code)::text = 'T_BLOB'::text)))
--                       Rows Removed by Filter: 1
--   CTE addref
--     ->  Insert on nso_ref  (cost=0.00..1.26 rows=29 width=33) (actual time=0.003..0.003 rows=0 loops=1)
--           ->  Nested Loop  (cost=0.00..1.26 rows=29 width=33) (actual time=0.002..0.002 rows=0 loops=1)
--                 ->  CTE Scan on change change_4  (cost=0.00..0.03 rows=1 width=0) (actual time=0.002..0.002 rows=0 loops=1)
--                       Filter: (((old_code)::text <> 'T_REF'::text) AND ((new_code)::text = 'T_REF'::text))
--                       Rows Removed by Filter: 1
--                 ->  CTE Scan on records  (cost=0.00..0.58 rows=29 width=8) (never executed)
--   CTE addblob
--     ->  Insert on nso_blob  (cost=0.00..1.48 rows=29 width=153) (actual time=0.002..0.002 rows=0 loops=1)
--           ->  Nested Loop  (cost=0.00..1.48 rows=29 width=153) (actual time=0.002..0.002 rows=0 loops=1)
--                 ->  CTE Scan on change change_5  (cost=0.00..0.03 rows=1 width=0) (actual time=0.001..0.001 rows=0 loops=1)
--                       Filter: (((old_code)::text <> 'T_BLOB'::text) AND ((new_code)::text = 'T_BLOB'::text))'
--                       Rows Removed by Filter: 1
--                 ->  CTE Scan on records records_1  (cost=0.00..0.58 rows=29 width=8) (never executed)
--   CTE addabs
--     ->  Insert on nso_abs  (cost=7.61..9.14 rows=29 width=121) (actual time=0.003..0.003 rows=0 loops=1)
--           InitPlan 10 (returns $15)
--             ->  Hash Join  (cost=3.94..7.58 rows=1 width=2) (never executed)
--                   Hash Cond: (k.key_id = (a_2.key_id)::bigint)
--                   ->  Seq Scan on nso_key k  (cost=0.00..3.29 rows=129 width=10) (never executed)
--                   ->  Hash  (cost=3.92..3.92 rows=1 width=8) (never executed)
--                         ->  Seq Scan on nso_key_attr a_2  (cost=0.00..3.92 rows=1 width=8) (never executed)
--                               Filter: ((col_id)::bigint = 401)
--           ->  Hash Left Join  (cost=0.03..1.56 rows=29 width=121) (actual time=0.002..0.003 rows=0 loops=1)
--                 Hash Cond: (r_5.rec_id = (orf.rec_id)::bigint)
--                 ->  Nested Loop  (cost=0.00..0.90 rows=29 width=40) (actual time=0.002..0.002 rows=0 loops=1)
--                       ->  CTE Scan on change change_6  (cost=0.00..0.03 rows=1 width=32) (actual time=0.002..0.002 rows=0 loops=1)
--                             Filter: (((new_code)::text <> 'T_REF'::text) AND ((new_code)::text <> 'T_BLOB'::text) AND (((old_code)::text = 'T_REF'::text) OR ((old_code)::text = 'T_BLOB'::text)))
--                             Rows Removed by Filter: 1
--                       ->  CTE Scan on records r_5  (cost=0.00..0.58 rows=29 width=8) (never executed)
--                 ->  Hash  (cost=0.02..0.02 rows=1 width=40) (never executed)
--                       ->  CTE Scan on oldrefs orf  (cost=0.00..0.02 rows=1 width=40) (never executed)
--   CTE updabs
--     ->  Update on nso_abs a_3  (cost=0.42..245.50 rows=1 width=248) (actual time=1.911..2.317 rows=2 loops=1)
--           ->  Nested Loop  (cost=0.42..245.50 rows=1 width=248) (actual time=0.020..0.048 rows=2 loops=1)
--                 ->  Nested Loop  (cost=0.42..245.46 rows=1 width=160) (actual time=0.012..0.034 rows=2 loops=1)
--                       ->  CTE Scan on records r_6  (cost=0.00..0.58 rows=29 width=40) (actual time=0.003..0.006 rows=2 loops=1)
--                       ->  Index Scan using pk_nso_abs on nso_abs a_3  (cost=0.42..8.44 rows=1 width=120) (actual time=0.011..0.011 rows=1 loops=2)
--                             Index Cond: (((rec_id)::bigint = r_6.rec_id) AND ((col_id)::bigint = 401))
--                 ->  CTE Scan on change change_7  (cost=0.00..0.03 rows=1 width=88) (actual time=0.005..0.005 rows=1 loops=2)
--                       Filter: (((new_code)::text <> 'T_REF'::text) AND ((new_code)::text <> 'T_BLOB'::text) AND ((new_code)::text <> (old_code)::text))'
--   ->  Nested Loop Left Join  (cost=3.38..250.13 rows=1 width=183) (actual time=3.333..3.770 rows=2 loops=1)'
--         Join Filter: (ua.rec_id = r.rec_id)
--         Rows Removed by Join Filter: 2
--         ->  Nested Loop  (cost=3.38..250.09 rows=1 width=175) (actual time=1.418..1.443 rows=2 loops=1)
--               ->  Hash Left Join  (cost=2.96..5.21 rows=29 width=88) (actual time=1.408..1.420 rows=2 loops=1)
--                     Hash Cond: (r.rec_id = (aa.rec_id)::bigint)
--                     ->  Hash Left Join  (cost=2.01..3.87 rows=29 width=80) (actual time=1.397..1.408 rows=2 loops=1)
--                           Hash Cond: (r.rec_id = (ab.rec_id)::bigint)
--                           ->  Hash Left Join  (cost=1.07..2.53 rows=29 width=72) (actual time=1.389..1.398 rows=2 loops=1)
--                                 Hash Cond: (r.rec_id = (ar.rec_id)::bigint)
--                                 ->  Hash Left Join  (cost=0.13..1.19 rows=29 width=64) (actual time=1.378..1.385 rows=2 loops=1)
--                                       Hash Cond: (r.rec_id = ca.rec_id)
--                                       ->  Hash Left Join  (cost=0.10..1.03 rows=29 width=56) (actual time=1.312..1.318 rows=2 loops=1)
--                                             Hash Cond: (r.rec_id = cb.rec_id)
--                                             ->  Hash Left Join  (cost=0.07..0.88 rows=29 width=48) (actual time=1.269..1.274 rows=2 loops=1)
--                                                   Hash Cond: (r.rec_id = cr.rec_id)
--                                                   ->  Hash Left Join  (cost=0.03..0.73 rows=29 width=40) (actual time=0.530..0.534 rows=2 loops=1)
--                                                         Hash Cond: (r.rec_id = (dv.rec_id)::bigint)
--                                                         ->  CTE Scan on records r  (cost=0.00..0.58 rows=29 width=8) (actual time=0.054..0.055 rows=2 loops=1)
--                                                         ->  Hash  (cost=0.02..0.02 rows=1 width=40) (actual time=0.457..0.457 rows=0 loops=1)
--                                                               Buckets: 1024  Batches: 1  Memory Usage: 8kB
--                                                               ->  CTE Scan on oldrefs dv  (cost=0.00..0.02 rows=1 width=40) (actual time=0.456..0.456 rows=0 loops=1)
--                                                   ->  Hash  (cost=0.02..0.02 rows=1 width=8) (actual time=0.727..0.727 rows=0 loops=1)
--                                                         Buckets: 1024  Batches: 1  Memory Usage: 8kB
--                                                         ->  CTE Scan on clearref cr  (cost=0.00..0.02 rows=1 width=8) (actual time=0.727..0.727 rows=0 loops=1)
--                                             ->  Hash  (cost=0.02..0.02 rows=1 width=8) (actual time=0.033..0.033 rows=0 loops=1)
--                                                   Buckets: 1024  Batches: 1  Memory Usage: 8kB
--                                                   ->  CTE Scan on clearblob cb  (cost=0.00..0.02 rows=1 width=8) (actual time=0.033..0.033 rows=0 loops=1)
--                                       ->  Hash  (cost=0.02..0.02 rows=1 width=8) (actual time=0.059..0.059 rows=0 loops=1)
--                                             Buckets: 1024  Batches: 1  Memory Usage: 8kB
--                                             ->  CTE Scan on clearabs ca  (cost=0.00..0.02 rows=1 width=8) (actual time=0.059..0.059 rows=0 loops=1)
--                                 ->  Hash  (cost=0.58..0.58 rows=29 width=8) (actual time=0.004..0.004 rows=0 loops=1)
--                                       Buckets: 1024  Batches: 1  Memory Usage: 8kB
--                                       ->  CTE Scan on addref ar  (cost=0.00..0.58 rows=29 width=8) (actual time=0.004..0.004 rows=0 loops=1)
--                           ->  Hash  (cost=0.58..0.58 rows=29 width=8) (actual time=0.003..0.003 rows=0 loops=1)
--                                 Buckets: 1024  Batches: 1  Memory Usage: 8kB
--                                 ->  CTE Scan on addblob ab  (cost=0.00..0.58 rows=29 width=8) (actual time=0.003..0.003 rows=0 loops=1)
--                     ->  Hash  (cost=0.58..0.58 rows=29 width=8) (actual time=0.004..0.004 rows=0 loops=1)
--                           Buckets: 1024  Batches: 1  Memory Usage: 8kB
--                           ->  CTE Scan on addabs aa  (cost=0.00..0.58 rows=29 width=8) (actual time=0.004..0.004 rows=0 loops=1)
--               ->  Index Scan using pk_nso_abs on nso_abs a  (cost=0.42..8.44 rows=1 width=95) (actual time=0.009..0.009 rows=1 loops=2)
--                     Index Cond: (((rec_id)::bigint = r.rec_id) AND ((col_id)::bigint = 401))
--         ->  CTE Scan on updabs ua  (cost=0.00..0.02 rows=1 width=8) (actual time=0.957..1.161 rows=2 loops=2)
--   ->  CTE Scan on change c  (cost=0.00..0.02 rows=1 width=128) (actual time=0.000..0.001 rows=1 loops=2)
-- Planning time: 6.260 ms
-- Trigger tr_nso_abs_ud on nso_abs: time=2.194 calls=2
-- Execution time: 5.119 ms
                    

