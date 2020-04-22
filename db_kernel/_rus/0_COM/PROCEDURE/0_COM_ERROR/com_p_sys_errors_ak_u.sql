DROP FUNCTION IF EXISTS com.com_p_sys_errors_ak_u (public.t_arr_text);
CREATE OR REPLACE FUNCTION com.com_p_sys_errors_ak_u ( 
        p_schema_name public.t_arr_text = ARRAY['com'::text, 'nso'::text, 'auth'::text, 'ind'::text, 'uio'::text, 'utl'::text ]
    ) 
    RETURNS public.result_long_t
    LANGUAGE plpgsql SECURITY DEFINER
    AS 
$$
  -- ========================================================================== --
  --  2015-06-15  Скрипт обновления описания кодов системных ошибок Роман.      --
  --  2017-06-01  Nick  Скрипт оказался неправильным. Оформлено в виде функций  --
  --  2020-01-01  Nick  Рефакторинг. Убрано обращение к "auth_server_object"    --
  -- ========================================================================== --

  DECLARE
    c_ERR_FUNP_NAME t_sysname := 'com_p_sys_errors_pk_u'; --имя процедуры
    c_DEBUG         public.t_boolean := utl.f_debug_status();

	_pk_desc_rec  RECORD;
	_err_rec      RECORD;
	_info	      public.t_text      := '';
	_index_1      public.t_int       := 0;
	_dtab	      public.t_text 	 := chr(9)||chr(9);
	_only_schema  public.t_arr_text := COALESCE (p_schema_name, ARRAY ['com', 'nso', 'auth', 'ind', 'uio', 'utl']);  -- auth
	_err_id	      public.id_t; 
	
    rsp_main    public.result_long_t;             -- Nick 2020-01-02
    _exception  public.exception_type_t;
    _err_args   public.t_arr_text := ARRAY [''];	
	
  BEGIN
	CREATE TEMPORARY TABLE tmp_constr_description
	ON COMMIT DROP
	AS ( WITH pk_lst (  constr_name  
                       ,schemaname
                       ,auth_server_object_name
                       ,t1      -- Имя таблицы
                       ,c1      -- Имя столбца
                       ,c1_desc -- Описание солбца
              )
	      AS ( SELECT
 		            z.index_name
                  , z.schema_name
       		      , CASE index_type 
       		            WHEN 'C_PRIMARY_KEY' THEN 'Первичный ключ: '
                        WHEN  'C_UNIQUE_INDEX' THEN 'Ограничение уникальности: '
                        ELSE  'Поисковый индекс: ' 
                    END || table_name  || ' ('  || string_agg (field_name, ', ') || ')' 
   	              , z.table_name
                  , (string_agg (z.field_name::text, ', ')) AS field_name
                  , (string_agg (z.field_desc::text, ', ')) AS field_desc
               FROM db_info.f_show_unique_descr () z
                 WHERE ((z.index_type = 'C_UNIQUE_INDEX') AND 
                        (z.schema_name = ANY ( _only_schema ))
                       )
                         GROUP BY z.index_name, z.schema_name, z.table_name, z.index_type
                 ) SELECT * FROM pk_lst 
	); -- end temporary table 

	--- Обновляем ошибки первичных ключей с кодом "23505'" для оператора INSERT
	_info := _info || 'I) Обновляем ошибки уникальностей с кодом "23505" для оператора INSERT';   
	FOR _pk_desc_rec IN ( SELECT constr_name, schemaname, t1, c1, c1_desc-- , i2, i2
	            FROM tmp_constr_description) 
	LOOP
		SELECT '23505'::public.t_code5 AS err_code
			,CAST( (z.auth_server_object_name || '. Нарушается уникальность в: "' ||
			 COALESCE (c1, '') || '" - "' || COALESCE (UPPER (c1_desc),'') || '"'
                               ) AS public.t_text
                         ) AS message_out
			,CAST (z.schemaname  AS public.t_sysname) AS sch_name
			,CAST (z.constr_name AS public.t_sysname)
			,'i'::public.t_code1 AS opr_type
			,CAST ( t1 AS public.t_sysname ) AS tbl_name
		FROM tmp_constr_description z
		 WHERE (constr_name = _pk_desc_rec.constr_name) AND
		       (schemaname = _pk_desc_rec.schemaname) INTO _err_rec LIMIT 1 ;
                 
        IF c_DEBUG THEN 
		       RAISE NOTICE '<%>, Pont 1: %, %', c_ERR_FUNP_NAME, _err_rec, _index_1;
		END IF;
		_index_1 = _index_1 + 1;
		_info := _info || chr(10) || chr(9) || _index_1 || ')' || 
			chr(10) || chr(9) || chr(9) || 'сообщение:' || chr(9) || _err_rec.message_out ||
			chr(10) || chr(9) || chr(9) || 'схема:'     || _dtab  || _err_rec.sch_name ||
			chr(10) || chr(9) || chr(9) || 'ключ:'      || _dtab  || _err_rec.constr_name ||
			chr(10) || chr(9) || chr(9) || 'оператор: ' || chr(9) || _err_rec.opr_type ||
			chr(10) || chr(9) || chr(9) || 'таблица: '  || chr(9) || _err_rec.tbl_name ;
		
		UPDATE com.sys_errors SET message_out = _err_rec.message_out
			WHERE  (sch_name    = _err_rec.sch_name) AND 
			       (err_code    = _err_rec.err_code) AND 
			       (constr_name = _err_rec.constr_name) AND 
			       (opr_type    = _err_rec.opr_type);  
	END LOOP;

  RETURN (_index_1, _info)::public.result_long_t;
  
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
		
	     rsp_main := (-1, ( com_error.f_error_handling ( _exception, _err_args )));
		RETURN  rsp_main;
      END;
  END;
$$;

COMMENT ON FUNCTION com.com_p_sys_errors_ak_u (public.t_arr_text) 
IS '248: Обновление таблицы ошибок (системная часть). Уникальности.
	Входные параметры:
		1) p_schema_name public.t_arr_text = ARRAY [''com'', ''nso'', ''auth'', ''ind'', ''uio'', ''utl'']

	Выходные параметры:
		1) public.result_long_t -- Отчёт о выполнении';
-- --------------------------------------------------------------------------------------------------------------
-- SELECT * FROM plpgsql_check_function ('com.com_p_sys_errors_ak_u (public.t_arr_text) ');
-- SELECT * FROM plpgsql_show_dependency_tb ('com.com_p_sys_errors_ak_u (public.t_arr_text)'); 
-- SELECT * FROM com.com_p_sys_errors_ak_u (ARRAY['com', 'nso']); 19
--
-- 11|'I) Обновляем ошибки уникальностей с кодом "23505" для оператора INSERT
-- 	1)
-- 		сообщение:	Ограничение уникальности: nso_domain_column_hist (attr_id, id_log). Нарушается уникальность в: "attr_id, id_log" - "ИДЕНТИФИКАТОР АТРИБУТА, ИДЕНТИФИКАТОР ЖУРНАЛА"
-- 		схема:		com
-- 		ключ:		ak1_domain_hist
-- 		оператор: 	i
-- 		таблица: 	nso_domain_column_hist
-- 	2)
-- 		сообщение:	Ограничение уникальности: nso_domain_column (attr_code). Нарушается уникальность в: "attr_code" - "КОД АТРИБУТА"
-- 		схема:		com
-- 		ключ:		ak1_nso_domain_column
-- 		оператор: 	i
-- 		таблица: 	nso_domain_column
-- 	3)
-- 		сообщение:	Ограничение уникальности: obj_codifier (codif_code). Нарушается уникальность в: "codif_code" - "КОД"
-- 		схема:		com
-- 		ключ:		ak1_obj_codifier
-- 		оператор: 	i
-- 		таблица: 	obj_codifier
-- 	4)
-- 		сообщение:	Ограничение уникальности: obj_object (object_uuid). Нарушается уникальность в: "object_uuid" - "UUID ОБЪЕКТА"
-- 		схема:		com
-- 		ключ:		ak1_obj_object
-- 		оператор: 	i
-- 		таблица: 	obj_object
-- 	5)
-- 		сообщение:	Ограничение уникальности: sys_errors (tbl_name, opr_type, constr_name, err_code). Нарушается уникальность в: "tbl_name, opr_type, constr_name, err_code" - "ИМЯ ТАБЛИЦЫ, ТИП ОПЕРАЦИИ, ИМЯ ОГРАНИЧЕНИЯ, КОД ОШИБКИ"
-- 		схема:		com
-- 		ключ:		ak1_sys_errors
-- 		оператор: 	i
-- 		таблица: 	sys_errors
-- 	6)
-- 		сообщение:	Ограничение уникальности: com_log (id_log). Нарушается уникальность в: "id_log" - ""
-- 		схема:		com
-- 		ключ:		ak2_com_log
-- 		оператор: 	i
-- 		таблица: 	com_log
-- 	7)
-- 		сообщение:	Ограничение уникальности: nso_domain_column (attr_name). Нарушается уникальность в: "attr_name" - "НАИМЕНОВАНИЕ АТРИБУТА"
-- 		схема:		com
-- 		ключ:		ak2_nso_domain_column
-- 		оператор: 	i
-- 		таблица: 	nso_domain_column
-- 	8)
-- 		сообщение:	Ограничение уникальности: obj_codifier (codif_name, parent_codif_id). Нарушается уникальность в: "codif_name, parent_codif_id" - "НАИМЕНОВАНИЕ, ИДЕНТИФИКАТОР РОДИТЕЛЯ"
-- 		схема:		com
-- 		ключ:		ak2_obj_codifier
-- 		оператор: 	i
-- 		таблица: 	obj_codifier
-- 	9)
-- 		сообщение:	Ограничение уникальности: nso_domain_column (attr_uuid). Нарушается уникальность в: "attr_uuid" - "UUID АТРИБУТА"
-- 		схема:		com
-- 		ключ:		ak3_nso_domain_column
-- 		оператор: 	i
-- 		таблица: 	nso_domain_column
-- 	10)
-- 		сообщение:	Ограничение уникальности: obj_codifier (small_code). Нарушается уникальность в: "small_code" - "КРАТКИЙ КОД"
-- 		схема:		com
-- 		ключ:		ak3_obj_codifier
-- 		оператор: 	i
-- 		таблица: 	obj_codifier
-- 	11)
-- 		сообщение:	Ограничение уникальности: obj_codifier (codif_uuid). Нарушается уникальность в: "codif_uuid" - "UUID"
-- 		схема:		com
-- 		ключ:		ak4_obj_codifier
-- 		оператор: 	i
-- 		таблица: 	obj_codifier'
-- ------------------------------------------
-- SELECT * FROM com.sys_errors WHERE (sch_name = 'nso') AND (err_code = '23505');
