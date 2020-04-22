/* ---------------------------------------------------------------------------------------------------------------------
        Входные параметры:
                1) p_col_id     public.id_t     -- Идентификатор колонки, всегда NOT NULL
                2) p_attr_id    public.id_t     -- Идентификатор атрибута, если NULL - сохраняется старое значение.
                3) p_col_code   public.t_str60  -- Код колонки,            если NULL - сохраняется старое значение.
                4) p_col_name   public.t_str250 -- Имя колонки,            если NULL - сохраняется старое значение.
                5) p_number_col public.small_t  -- Номер колонки,          если NULL - сохраняется старое значение.
	Выходные параметры:
                1) _result        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение
--------------------------------------------------------------------------------------------------------------------- */

DROP FUNCTION IF EXISTS nso_structure.nso_p_column_head_u ( public.id_t, public.id_t, public.t_str60, public.t_str250, public.small_t );
CREATE OR REPLACE FUNCTION nso_structure.nso_p_column_head_u
(
     p_col_id     public.id_t                  -- Идентификатор колонки, всегда NOT NULL
    ,p_attr_id    public.id_t     DEFAULT NULL -- Идентификатор атрибута из домена атрибутов -- если NULL - сохраняется старое значение.
    ,p_col_code   public.t_str60  DEFAULT NULL -- Код колонки   -- если NULL - сохраняется старое значение.
    ,p_col_name   public.t_str250 DEFAULT NULL -- Имя колонки   -- если NULL - сохраняется старое значение.
    ,p_number_col public.small_t  DEFAULT NULL -- Номер колонки -- если NULL - сохраняется старое значение.
)
   RETURNS public.result_long_t 
   SET search_path = nso, com, utl, com_codifier, com_domain, nso_strucrure, com_error, public,pg_catalog
AS 
 $$
    -- ============================================================================================================ --
    -- Author: Gregory                                                                                              --
    -- Create date: 2015-11-02                                                                                      --
    -- Description: Обновление элемента заголовка                                                                   --
    -- 2017-01-08 Gregory Исправлена ошибка при обновлении номер колонок, корневой элемент всегда №0. (неудачно)    --
    -- 2017-01-12 Gregory Другой вариант исправления                                                                --
    -- 2017-03-15 Gregory Добавлен функционал изменения атрибута колонки                                            --
    -- 2019-08-13 Nick    Новое ядро, атрибут "section_sign" в таблицах "nso_record", "nso_abs", "nso_blob"         --
    -- 2020-04-14 Nick    Section number
    -- ============================================================================================================ --
  DECLARE
     _nso_id     public.id_t;
     _attr_id    public.id_t;
     _nso_code   public.t_str60;
     _col_code   public.t_str60;
     _parent_col public.id_t;
     _result     public.result_long_t;
     --
     _min_num public.small_t;
     _max_num public.small_t;
     _cur_num public.small_t;
     --
     _dbg_record record;
     --
     c_ERR_FUNC_NAME public.t_sysname = 'nso_p_column_head_u';
     c_MESS_OK       public.t_str1024 = 'Успешно обновлен элемент заголовка.';

     c_APP_NODE      public.t_str60 = 'APP_NODE';
     c_DOMEN_NODE    public.t_str60 = 'C_DOMEN_NODE';
     c_REF           public.t_str60 = 'T_REF';
     c_BLOB          public.t_str60 = 'T_BLOB';
     --
     _exception  public.exception_type_t;
     _err_args   public.t_arr_text := ARRAY [''];
     --
     C_DEBUG public.t_boolean := utl.f_debug_status();
     
  BEGIN
     IF p_col_id IS NOT NULL
     THEN
        SELECT attr_id, nso_id, nso_code, col_code, number_col, parent_col_id
                          INTO _attr_id, _nso_id, _nso_code, _col_code, _cur_num, _parent_col
        FROM ONLY nso.nso_column_head 
                JOIN ONLY nso.nso_object USING (nso_id)
        WHERE col_id = p_col_id;
        --
        IF _parent_col IS NULL OR p_number_col = _cur_num
            THEN 
                 p_number_col = NULL;
        END IF;
        --
        IF C_DEBUG
          THEN
              RAISE NOTICE '<%>, %, %, %, %, %, %, %, %, %, %, %', c_ERR_FUNC_NAME
                         ,p_col_id, p_attr_id, p_col_code, p_col_name, p_number_col
                         ,_attr_id, _nso_id, _nso_code, _col_code, _cur_num, _parent_col;
        END IF;  
        --
        IF _nso_id IS NOT NULL AND _nso_code IS NOT NULL
        THEN
           PERFORM nso.nso_p_nso_log_i( 'A', 'Обновление элемента заголовка: "' || _col_code || '".');

           IF (p_attr_id IS NOT NULL) AND (_attr_id != p_attr_id) -- задано значение и отличается от текущего
           THEN -- Nick 2019-08-13 Смена атрибута, операции над данными 
               IF EXISTS ( -- новый атрибут найден в списке разрешенных
                   SELECT 1 FROM com_domain.nso_f_domain_column_s (c_APP_NODE) -- элементы списка APP_NODE
                       WHERE
                               attr_type_code != c_DOMEN_NODE -- не узловые
                           AND attr_id = p_attr_id
               )
               THEN
                FOR _dbg_record IN (
                  WITH 
                    attrs AS ( -- info по новому и старому типу атрибута
                               SELECT
                                       oc.codif_code
                                      ,oc.small_code
                                      ,CASE ndc.attr_id
                                               WHEN p_attr_id THEN TRUE
                                                              ELSE FALSE
                                       END AS new_type
                               FROM ONLY com.nso_domain_column ndc
                                 JOIN ONLY com.obj_codifier    oc   ON (oc.codif_id = ndc.attr_type_id)
                               WHERE (ndc.attr_id = p_attr_id) OR (ndc.attr_id = _attr_id)
                    )
                   ,change AS ( -- формируем ключевую строку "было - стало"
                       SELECT
                            CAST (MAX(CASE new_type WHEN FALSE THEN codif_code ELSE NULL END) AS public.t_str60) AS old_code
                           ,CAST (MAX(CASE new_type WHEN FALSE THEN small_code ELSE NULL END) AS public.t_code1) AS old_scode
                           ,CAST (MAX(CASE new_type WHEN TRUE  THEN codif_code ELSE NULL END) AS public.t_str60) AS new_code
                           ,CAST (MAX(CASE new_type WHEN TRUE  THEN small_code ELSE NULL END) AS public.t_code1) AS new_scode
                       FROM attrs
                    )
                   ,records AS ( -- Существующие данные Nick 2019-08-13. Основа, содержит section_number.
                                 SELECT rec_id, section_number FROM ONLY nso.nso_record WHERE (nso_id = _nso_id)
                    )
                   ,oldrefs AS ( -- разыменование ссылок если был T_REF а будет не T_BLOB ?? #1
                                 SELECT
                                         nr.rec_id
                                        ,nr.col_id
                                        ,nso_data.nso_f_record_def_val (nr.ref_rec_id) AS def_val
                                 FROM
                                         change  c
                                        ,records r
                                        ,ONLY nso.nso_ref nr
                                 WHERE -- если был T_REF и будет любой скалярный тип, иначе блок не вычисляется ~ WHERE FALSE
                                         ( c.old_code  = c_REF )  AND ( c.new_code != c_REF )
                                     AND ( c.new_code != c_BLOB ) AND ( nr.rec_id = r.rec_id )
                                     AND ( nr.col_id = p_col_id )
                    )
                   ,clearref AS ( -- чистим nso_ref если был T_REF а будет не T_REF
                                   DELETE FROM ONLY nso.nso_ref rf USING change c, records r
                                   WHERE
                                           ( c.old_code = c_REF )   AND ( c.new_code != c_REF )
                                       AND ( rf.rec_id = r.rec_id ) AND ( rf.col_id = p_col_id )
                                   RETURNING r.rec_id
                    )
                   ,clearblob AS ( -- чистим nso_blob если был T_BLOB а будет не T_BLOB
                                   DELETE FROM ONLY nso.nso_blob b USING change c, records r
                                   WHERE
                                           (c.old_code = c_BLOB) AND (c.new_code != c_BLOB)
                                       AND (b.rec_id = r.rec_id) AND (b.col_id = p_col_id)
                                   RETURNING r.rec_id
                    )
                   ,clearabs AS ( -- чистим nso_abs если был скалярный тип(не T_REF и не T_BLOB) а будет не скалярный тип(T_REF или T_BLOB)
                                  DELETE FROM ONLY nso.nso_abs a USING change c, records r
                                  WHERE
                                          (c.old_code != c_REF) AND (c.old_code != c_BLOB)
                                      AND (c.new_code = c_REF OR c.new_code = c_BLOB)
                                      AND (a.rec_id = r.rec_id) AND (a.col_id = p_col_id)
                                  RETURNING r.rec_id
                    )
                   ,addref AS ( -- Nick 2019-08-13 Несекционированная таблица
                                 INSERT INTO nso.nso_ref (rec_id, col_id, ref_rec_id)
                                 SELECT
                                         r.rec_id, p_col_id, NULL
                                 FROM
                                         change c, records r
                                 WHERE
                                         (c.old_code != c_REF)  AND (c.new_code = c_REF)
                                 RETURNING rec_id
                    )
                   ,addblob AS ( -- Nick 2019-08-13 Секционированная таблица.
                                 INSERT INTO nso.nso_blob (
                                         rec_id
                                        ,col_id
                                        ,section_number -- Nick 2019-08-15 
                                        ,val_cel_hash
                                        ,val_cel_data_name
                                        ,val_cell_blob
                                 )
                                 SELECT  r.rec_id
                                        ,p_col_id
                                        ,r.section_number -- Nick 2019-08-15 
                                        ,NULL
                                        ,NULL
                                        ,NULL
                                 FROM
                                      change c, records r
                                 WHERE
                                        ( c.old_code != c_BLOB) AND (c.new_code = c_BLOB)
                                 RETURNING rec_id
                    )
                   ,addabs AS (  -- Nick 2019-08-13 Секционированная таблица.
                                 INSERT INTO nso.nso_abs (
                                         rec_id
                                        ,col_id
                                        ,s_type_code
                                        ,s_key_code
                                        ,section_number -- Nick 2019-08-15
                                        ,val_cell_abs
                                 )
                                 SELECT  r.rec_id
                                        ,p_col_id
                                        ,c.new_scode
                                        ,COALESCE(
                                                 (SELECT k.key_small_code
                                                 FROM
                                                         ONLY nso.nso_key k
                                                        ,ONLY nso.nso_key_attr a
                                                 WHERE
                                                         k.key_id = a.key_id
                                                     AND a.col_id = p_col_id
                                                 )
                                                ,'0'
                                         )
                                        ,r.section_number  -- Nick 2019-08-15
                                        ,dv.def_val
                                 FROM
                                         change c, records r
                                         
                                 LEFT JOIN oldrefs dv ON (dv.rec_id = r.rec_id)
                                 WHERE
                                         ( c.old_code = c_REF OR c.old_code = c_BLOB )
                                     AND ( c.new_code != c_REF) AND (c.new_code != c_BLOB)
                                 RETURNING rec_id
                    )
                   ,updabs AS (
                                UPDATE ONLY nso.nso_abs a SET s_type_code = c.new_scode
                                FROM
                                     change c, records r
                                WHERE
                                        (c.new_code != c_REF)
                                    AND (c.new_code != c_BLOB)
                                    AND (c.new_code != c.old_code)
                                    AND (a.rec_id = r.rec_id)
                                    AND (a.col_id = p_col_id)
                                RETURNING r.rec_id
                    )
                    SELECT
                         c.old_code
                        ,c.old_scode
                        ,c.new_code
                        ,c.new_scode
                        ,r.rec_id
                        ,LEFT (dv.def_val, 64) -- ??? Nick 2019-08-13
                        ,CASE WHEN cr.rec_id IS NULL THEN NULL ELSE 'rem ref'  END
                        ,CASE WHEN cb.rec_id IS NULL THEN NULL ELSE 'rem blob' END
                        ,CASE WHEN ca.rec_id IS NULL THEN NULL ELSE 'rem abs'  END
                        ,CASE WHEN ar.rec_id IS NULL THEN NULL ELSE 'add ref'  END
                        ,CASE WHEN ab.rec_id IS NULL THEN NULL ELSE 'add blob' END
                        ,CASE WHEN aa.rec_id IS NULL THEN NULL ELSE 'add abs'  END
                        ,CASE WHEN ua.rec_id IS NULL THEN NULL ELSE 'upd abs'  END
                        ,LEFT (a.val_cell_abs, 64)
                        ,CASE
                               WHEN (c.new_code != c_REF) AND (c.new_code != c_BLOB)
                               THEN com_error.com_f_value_check (c.new_scode, val_cell_abs)
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
                    WHERE (a.col_id = p_col_id)
               ) -- End of Query
                LOOP
                       IF C_DEBUG
                         THEN
                               RAISE NOTICE '<%>, %', c_ERR_FUNC_NAME, _dbg_record;
                       END IF;
                       
                       IF (_dbg_record.chck).rc < 0 AND (_dbg_record.chck).rc != -9
                       THEN
                               RAISE EXCEPTION '%', (_dbg_record.chck).errm;
                       END IF;
                END LOOP; -- Основной цикл Nick 2019-08-13
               END IF;
           END IF;  -- Nick 2019-08-13 Смена атрибута, операции над данными 

           --
           -- Nick 2019-08-13 Операции над структурой, изменение загололовка.
           --
           IF p_number_col IS NOT NULL
           THEN
                SELECT 1, max(number_col) INTO _min_num, _max_num
                    FROM ONLY nso.nso_column_head WHERE (nso_id = _nso_id);

                IF p_number_col < _min_num
                THEN
                        p_number_col = _min_num;
                END IF;

                IF p_number_col > _max_num
                THEN
                        p_number_col = _max_num;
                END IF;

                UPDATE ONLY nso.nso_column_head SET number_col = number_col - 1
                  WHERE (nso_id = _nso_id) AND (number_col >= _cur_num) AND (parent_col_id IS NOT NULL);
                
                UPDATE ONLY nso.nso_column_head SET number_col = number_col + 1
                  WHERE (nso_id = _nso_id) AND (number_col >= p_number_col);
           END IF;
           
           UPDATE ONLY nso.nso_column_head
           SET
                   attr_id    = COALESCE (p_attr_id,  attr_id) -- Идентификатор атрибута
                  ,col_code   = COALESCE (p_col_code, col_code) -- Код колонки
                  ,col_name   = COALESCE (p_col_name, col_name) -- Имя колонки
                  ,number_col = COALESCE (p_number_col, number_col) -- Номер колонки
           WHERE (col_id = p_col_id);

           UPDATE ONLY nso.nso_object
           SET
               nso_release = nso_release + 1 -- Версия НСО
              ,nso_select = nso_structure.nso_f_select_c(_nso_code) -- Конструкция SELECT
           WHERE (nso_id = _nso_id);
        ELSE
             _err_args [1] := _nso_id::text; 
             RAISE SQLSTATE '62022'; -- Запись не найдена      
        END IF;
     ELSE
          RAISE SQLSTATE '60000'; -- NULL значения запрещены
     END IF;
     --   	
  	 _result.rc = 0;
     _result.errm = c_MESS_OK;
     
     RETURN _result;
        
  EXCEPTION
	WHEN OTHERS  THEN 
	 BEGIN
	   GET STACKED DIAGNOSTICS 
              _exception.state           := RETURNED_SQLSTATE            -- SQLSTATE
             ,_exception.schema_name     := SCHEMA_NAME 
             ,_exception.table_name      := TABLE_NAME 	      
             ,_exception.constraint_name := CONSTRAINT_NAME     
             ,_exception.column_name     := COLUMN_NAME       
             ,_exception.datatype        := PG_DATATYPE_NAME 
             ,_exception.message         := MESSAGE_TEXT                 -- SQLERRM
             ,_exception.detail          := PG_EXCEPTION_DETAIL 
             ,_exception.hint            := PG_EXCEPTION_HINT 
             ,_exception.context         := PG_EXCEPTION_CONTEXT;            -- 

             _exception.func_name := c_ERR_FUNC_NAME; 
		
	   _result := (-1, ( com_error.f_error_handling ( _exception, _err_args )));
			
	   RETURN _result;			
	 END;
  END;
 $$
LANGUAGE plpgsql 
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION nso_structure.nso_p_column_head_u(public.id_t,public.id_t,public.t_str60,public.t_str250,public.small_t)
IS '298: Обновление элемента заголовка
        Входные параметры:
                1) p_col_id     public.id_t     -- Идентификатор колонки, всегда NOT NULL
                2) p_attr_id    public.id_t     -- Идентификатор атрибута, если NULL - сохраняется старое значение.
                3) p_col_code   public.t_str60  -- Код колонки,            если NULL - сохраняется старое значение.
                4) p_col_name   public.t_str250 -- Имя колонки,            если NULL - сохраняется старое значение.
                5) p_number_col public.small_t  -- Номер колонки,          если NULL - сохраняется старое значение.
	Выходные параметры:
                1) _result        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение';
--
-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--  SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_p_column_head_u(public.id_t,public.id_t,public.t_str60,public.t_str250,public.small_t)');
-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- ERROR:  improper qualified name (too many dotted names): nso_structure.nso_p_column_head_u(public.id_t,public.id_t,public.t_str60,public.t_str250,public.small_t)
-- CONTEXT:  PL/pgSQL function parse_ident(text) line 3 at RETURN
-- SQL statement "SELECT parse_ident($1)"
-- PL/pgSQL function __plpgsql_check_getfuncid(text) line 4 at PERFORM
-- PL/pgSQL function plpgsql_check_function_tb(text,regclass,boolean,boolean,boolean,boolean,boolean,name,name) line 3 at RETURN QUERY

