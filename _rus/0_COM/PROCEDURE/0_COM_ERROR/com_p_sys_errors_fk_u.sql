DROP FUNCTION IF EXISTS com.com_p_sys_errors_fk_u (public.t_arr_text);
CREATE OR REPLACE FUNCTION com.com_p_sys_errors_fk_u (
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
    c_ERR_FUNP_NAME public.t_sysname := 'com_p_sys_errors_u'; --имя процедуры
    c_DEBUG         public.t_boolean := utl.f_debug_status();

	_fk_desc_rec  RECORD;
	_err_rec      RECORD;
	_info	      public.t_text      := '';
	_index_1      public.t_int       := 0;
	_index_2      public.t_int       := 0;
	_dtab	      public.t_text 	 := chr(9)||chr(9);
	_only_schema  public.t_arr_text := COALESCE (p_schema_name, ARRAY ['com', 'nso', 'auth', 'ind', 'uio', 'utl']);  -- auth
	_err_id	      public.id_t; 
	
	rsp_main    public.result_long_t;             -- Nick 2020-01-02
        _exception  public.exception_type_t;
        _err_args   public.t_arr_text := ARRAY [''];
	
  BEGIN
	CREATE TEMPORARY TABLE tmp_fk_description
	ON COMMIT DROP
	AS (
     WITH so_constr_fk_desc (
               constr_name
		     , schemaname
             , auth_server_object_name
		     , t1      -- Имя таблицы
		     , c1      -- Имя столбца
		     , c1_desc -- Описание столбца
		     , t2      -- Таблица-родитель
		     , c2      -- Столбец-родитель 
		     , c2_desc -- Описание столбца-родителя
     
     )
      AS (
		 SELECT d.constr_name 
		     , d.schema_name                       AS schemaname
             , 'Внешний ключ: ' || d.table_name  || '('  || string_agg (d.field_name, ', ') || 
               ')' || ' -> ' || d.ref_table || '(' || string_agg (d.ref_field_name, ', ') || 
               ')'                                 AS auth_server_object_name
		     , d.table_name                        AS t1      -- Имя таблицы
		     , string_agg (d.field_name, ', ')     AS c1      -- Имя столбца
		     , string_agg (d.field_desc, ', ')     AS c1_desc -- Описание столбца
		     , d.ref_table                         AS t2      -- Таблица-родитель
		     , string_agg (d.ref_field_name, ', ') AS c2      -- Столбец-родитель 
		     , string_agg (d.ref_field_desc, ', ') AS c2_desc -- Описание столбца-родителя
		 FROM db_info.f_show_fk_descr () d
		                 WHERE (d.schema_name = ANY (_only_schema))
		 GROUP BY d.constr_name, d.table_name, d.ref_table, 
		          d.ref_field_name, d.schema_name 
         ORDER BY d.constr_name			               
			
		) SELECT * FROM so_constr_fk_desc
	); -- end temporary fk_description

	--- Обновляем ошибки внешних ключей с кодом "23503" для оператора INSERT
	_info := _info || 'I) Обновляем ошибки внешних ключей с кодом "23503" для оператора INSERT';   
	FOR _fk_desc_rec IN ( SELECT constr_name, schemaname, t1, c1, c1_desc, t2, c2, c2_desc 
	                          FROM tmp_fk_description
	            )  
	LOOP
		SELECT '23503'::public.t_code5 AS err_code
			,CAST( ('Значение ' || COALESCE (c1, '') || ' "' || COALESCE (UPPER (c1_desc),'') ||
			        '" из таблицы ' || COALESCE (t1, '') || ' ссылается на несуществующий идентификатор ' || 
			        COALESCE (c2, '') || ' "' || COALESCE (UPPER (c2_desc), '') || '" в таблице ' || t2
                               ) AS public.t_text
                         ) AS message_out
			,CAST (schemaname  AS public.t_sysname) AS sch_name
			,CAST (constr_name AS public.t_sysname)
			,'i'::public.t_code1 AS opr_type
			,CAST ( t1 AS public.t_sysname ) AS tbl_name
		 FROM tmp_fk_description 
		 WHERE (constr_name = _fk_desc_rec.constr_name) AND
		       (schemaname = _fk_desc_rec.schemaname) INTO _err_rec LIMIT 1 ;
                 
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
	
	_index_2 := 0;
	--- Обновляем ошибки внешних ключей с кодом "23503" для оператора DELETE
	_info := _info || chr(10) || chr(10) || 'II) Обновляем ошибки внешних ключей с кодом "23503" для оператора DELETE';
	FOR _fk_desc_rec IN ( SELECT constr_name, schemaname, t1, c1, c1_desc, t2, c2, c2_desc 
	                      FROM tmp_fk_description ) --  WHERE schemaname = ANY (_only_schema)
	LOOP
		SELECT '23503'::public.t_code5 AS err_code 
			,CAST( ('Невозможно удалить запись из таблицы ' ||  COALESCE (t2, '') || 
			        ', т.к. значение из колонки ' ||  COALESCE (c2, '') ||  ' "' || COALESCE (UPPER(c2_desc), '') ||
				'" уже связано со значением в колонке ' ||  COALESCE (c1, '') || 
				' "' ||  COALESCE (UPPER(c1_desc), '') || '" таблицы ' ||  COALESCE (t1, '')
				) 
				
			   AS public.t_text
			 ) AS message_out
			,CAST (schemaname    AS public.t_sysname) AS sch_name
			,CAST (constr_name   AS public.t_sysname)
			,'d'::public.t_code1 AS opr_type
			,CAST( t2 AS public.t_sysname ) AS tbl_name
		FROM tmp_fk_description 
		WHERE (constr_name = _fk_desc_rec.constr_name) AND 
		       (schemaname = _fk_desc_rec.schemaname) INTO _err_rec LIMIT 1 ;
		
        IF c_DEBUG THEN 
		       RAISE NOTICE '<%>, Pont 2: %, %', c_ERR_FUNP_NAME, _err_rec, _index_2;
		END IF;		
		
		_index_2 = _index_2 + 1;
		_info := _info || chr(10) || chr(9) || _index_2 || ')' || 
			chr(10) || chr(9) || chr(9) || 'сообщение:' || chr(9) || _err_rec.message_out ||
			chr(10) || chr(9) || chr(9) || 'схема:' || _dtab || _err_rec.sch_name ||
			chr(10) || chr(9) || chr(9) || 'ключ:' || _dtab || _err_rec.constr_name ||
			chr(10) || chr(9) || chr(9) || 'оператор: ' || chr(9) ||  _err_rec.opr_type ||
			chr(10) || chr(9) || chr(9) || 'таблица: ' || chr(9) || _err_rec.tbl_name;

 		UPDATE com.sys_errors SET message_out = _err_rec.message_out
			WHERE (sch_name    = _err_rec.sch_name) AND 
			      (err_code    = _err_rec.err_code) AND 
			      (constr_name = _err_rec.constr_name) AND 
			       opr_type    = _err_rec.opr_type; 
 	END LOOP;

  RETURN ((_index_1 + _index_2), _info)::public.result_long_t;
  
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

COMMENT ON FUNCTION com.com_p_sys_errors_fk_u (public.t_arr_text) 
IS '251: Обновление таблицы ошибок (системная часть). Внешние ключи.
	Входные параметры:
		1) p_schema_name public.t_arr_text = ARRAY [''com'', ''nso'', ''auth'', ''ind'', ''uio'', ''utl'']

	Выходные параметры:
		1) public.result_long_t -- Отчёт о выполнении';
---------------------------------------------------------------------------------------
-- SELECT * FROM plpgsql_check_function ('com.com_p_sys_errors_fk_u (public.t_arr_text)');
-- 'error:42P01:64:FOR over SELECT rows:relation "tmp_fk_description" does not exist'
--
-- SELECT * FROM com.com_p_sys_errors_fk_u (ARRAY ['com', 'nso', 'auth', 'ind']); 
-- -----------------------------------------------------------------------------
-- 22|'I) Обновляем ошибки внешних ключей с кодом "23503" для оператора INSERT
-- 	1)
-- 		сообщение:	Значение id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" из таблицы auth_role_attr ссылается на несуществующий идентификатор id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" в таблице auth_log
-- 		схема:		auth
-- 		ключ:		fk_auth_role_attr_can_have_auth_log
-- 		оператор: 	i
-- 		таблица: 	auth_role_attr
-- 	2)
-- 		сообщение:	Значение id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" из таблицы nso_domain_column ссылается на несуществующий идентификатор id_log "" в таблице com_log
-- 		схема:		com
-- 		ключ:		fk_nso_domain_column_can_have_com_log
-- 		оператор: 	i
-- 		таблица: 	nso_domain_column
-- 	3)
-- 		сообщение:	Значение parent_attr_id "ИДЕНТИФИКАТОР РОДИТЕЛЬСКОГО АТРИБУТА" из таблицы nso_domain_column ссылается на несуществующий идентификатор attr_id "ИДЕНТИФИКАТОР АТРИБУТА" в таблице nso_domain_column
-- 		схема:		com
-- 		ключ:		fk_nso_domain_column_grouping_nso_domain_column
-- 		оператор: 	i
-- 		таблица: 	nso_domain_column
-- 	4)
-- 		сообщение:	Значение id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" из таблицы nso_domain_column_hist ссылается на несуществующий идентификатор id_log "" в таблице com_log
-- 		схема:		com
-- 		ключ:		fk_nso_domain_column_hist_hase_com_log
-- 		оператор: 	i
-- 		таблица: 	nso_domain_column_hist
-- 	5)
-- 		сообщение:	Значение id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" из таблицы obj_codifier ссылается на несуществующий идентификатор id_log "" в таблице com_log
-- 		схема:		com
-- 		ключ:		fk_obj_codifier_can_has_com_log
-- 		оператор: 	i
-- 		таблица: 	obj_codifier
-- 	6)
-- 		сообщение:	Значение parent_codif_id "ИДЕНТИФИКАТОР РОДИТЕЛЯ" из таблицы obj_codifier ссылается на несуществующий идентификатор codif_id "ИДЕНТИФИКАТОР ЭКЗЕМПЛЯРА" в таблице obj_codifier
-- 		схема:		com
-- 		ключ:		fk_obj_codifier_grouping_obj_codifier
-- 		оператор: 	i
-- 		таблица: 	obj_codifier
-- 	7)
-- 		сообщение:	Значение id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" из таблицы obj_codifier_hist ссылается на несуществующий идентификатор id_log "" в таблице com_log
-- 		схема:		com
-- 		ключ:		fk_obj_codifier_hist_has_com_log
-- 		оператор: 	i
-- 		таблица: 	obj_codifier_hist
-- 	8)
-- 		сообщение:	Значение attr_type_id "ТИП АТРИБУТА" из таблицы nso_domain_column ссылается на несуществующий идентификатор codif_id "ИДЕНТИФИКАТОР ЭКЗЕМПЛЯРА" в таблице obj_codifier
-- 		схема:		com
-- 		ключ:		fk_obj_codifier_typify_nso_domain_column
-- 		оператор: 	i
-- 		таблица: 	nso_domain_column
-- 	9)
-- 		сообщение:	Значение id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" из таблицы obj_object ссылается на несуществующий идентификатор id_log "" в таблице com_log
-- 		схема:		com
-- 		ключ:		fk_obj_object_can_have_com_log
-- 		оператор: 	i
-- 		таблица: 	obj_object
-- 	10)
-- 		сообщение:	Значение parent_object_id "ИДЕНТИФИКАТОР РОДИТЕЛЬСКОГО ОБЪЕКТА" из таблицы obj_object ссылается на несуществующий идентификатор object_id "ИДЕНТИФИКАТОР ОБЪЕКТА" в таблице obj_object
-- 		схема:		com
-- 		ключ:		fk_obj_object_grouping
-- 		оператор: 	i
-- 		таблица: 	obj_object
-- 	11)
-- 		сообщение:	Значение id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" из таблицы obj_object_hist ссылается на несуществующий идентификатор id_log "" в таблице com_log
-- 		схема:		com
-- 		ключ:		fk_obj_object_hist_hase_com_log
-- 		оператор: 	i
-- 		таблица: 	obj_object_hist
-- 
-- II) Обновляем ошибки внешних ключей с кодом "23503" для оператора DELETE
-- 	1)
-- 		сообщение:	Невозможно удалить запись из таблицы auth_log, т.к. значение из колонки id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" уже связано со значением в колонке id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" таблицы auth_role_attr
-- 		схема:		auth
-- 		ключ:		fk_auth_role_attr_can_have_auth_log
-- 		оператор: 	d
-- 		таблица: 	auth_log
-- 	2)
-- 		сообщение:	Невозможно удалить запись из таблицы com_log, т.к. значение из колонки id_log "" уже связано со значением в колонке id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" таблицы nso_domain_column
-- 		схема:		com
-- 		ключ:		fk_nso_domain_column_can_have_com_log
-- 		оператор: 	d
-- 		таблица: 	com_log
-- 	3)
-- 		сообщение:	Невозможно удалить запись из таблицы nso_domain_column, т.к. значение из колонки attr_id "ИДЕНТИФИКАТОР АТРИБУТА" уже связано со значением в колонке parent_attr_id "ИДЕНТИФИКАТОР РОДИТЕЛЬСКОГО АТРИБУТА" таблицы nso_domain_column
-- 		схема:		com
-- 		ключ:		fk_nso_domain_column_grouping_nso_domain_column
-- 		оператор: 	d
-- 		таблица: 	nso_domain_column
-- 	4)
-- 		сообщение:	Невозможно удалить запись из таблицы com_log, т.к. значение из колонки id_log "" уже связано со значением в колонке id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" таблицы nso_domain_column_hist
-- 		схема:		com
-- 		ключ:		fk_nso_domain_column_hist_hase_com_log
-- 		оператор: 	d
-- 		таблица: 	com_log
-- 	5)
-- 		сообщение:	Невозможно удалить запись из таблицы com_log, т.к. значение из колонки id_log "" уже связано со значением в колонке id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" таблицы obj_codifier
-- 		схема:		com
-- 		ключ:		fk_obj_codifier_can_has_com_log
-- 		оператор: 	d
-- 		таблица: 	com_log
-- 	6)
-- 		сообщение:	Невозможно удалить запись из таблицы obj_codifier, т.к. значение из колонки codif_id "ИДЕНТИФИКАТОР ЭКЗЕМПЛЯРА" уже связано со значением в колонке parent_codif_id "ИДЕНТИФИКАТОР РОДИТЕЛЯ" таблицы obj_codifier
-- 		схема:		com
-- 		ключ:		fk_obj_codifier_grouping_obj_codifier
-- 		оператор: 	d
-- 		таблица: 	obj_codifier
-- 	7)
-- 		сообщение:	Невозможно удалить запись из таблицы com_log, т.к. значение из колонки id_log "" уже связано со значением в колонке id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" таблицы obj_codifier_hist
-- 		схема:		com
-- 		ключ:		fk_obj_codifier_hist_has_com_log
-- 		оператор: 	d
-- 		таблица: 	com_log
-- 	8)
-- 		сообщение:	Невозможно удалить запись из таблицы obj_codifier, т.к. значение из колонки codif_id "ИДЕНТИФИКАТОР ЭКЗЕМПЛЯРА" уже связано со значением в колонке attr_type_id "ТИП АТРИБУТА" таблицы nso_domain_column
-- 		схема:		com
-- 		ключ:		fk_obj_codifier_typify_nso_domain_column
-- 		оператор: 	d
-- 		таблица: 	obj_codifier
-- 	9)
-- 		сообщение:	Невозможно удалить запись из таблицы com_log, т.к. значение из колонки id_log "" уже связано со значением в колонке id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" таблицы obj_object
-- 		схема:		com
-- 		ключ:		fk_obj_object_can_have_com_log
-- 		оператор: 	d
-- 		таблица: 	com_log
-- 	10)
-- 		сообщение:	Невозможно удалить запись из таблицы obj_object, т.к. значение из колонки object_id "ИДЕНТИФИКАТОР ОБЪЕКТА" уже связано со значением в колонке parent_object_id "ИДЕНТИФИКАТОР РОДИТЕЛЬСКОГО ОБЪЕКТА" таблицы obj_object
-- 		схема:		com
-- 		ключ:		fk_obj_object_grouping
-- 		оператор: 	d
-- 		таблица: 	obj_object
-- 	11)
-- 		сообщение:	Невозможно удалить запись из таблицы com_log, т.к. значение из колонки id_log "" уже связано со значением в колонке id_log "ИДЕНТИФИКАТОР ЖУРНАЛА" таблицы obj_object_hist
-- 		схема:		com
-- 		ключ:		fk_obj_object_hist_hase_com_log
-- 		оператор: 	d
-- 		таблица: 	com_log'
-- 		
-- SELECT * FROM com.sys_errors WHERE ( message_out IS NULL) ORDER BY sch_name, constr_name;;
----------------------------------------------------------------------------------------------
-- 78|'23514'|''|'com'|'chk_com_log_impact_type'                   |'i'|'com_log'
-- 76|'23514'|''|'com'|'chk_sys_errors_operation_iud'              |'i'|'sys_errors'
-- --
-- 48|'23503'|''|'com'|'fk_nso_object_can_define_nso_domain_column'|'i'|'nso_domain_column'
-- 54|'23503'|''|'com'|'fk_nso_record_defines_object_secret_level' |'i'|'obj_object'
-- 55|'23503'|''|'com'|'fk_nso_record_is_owner_obj_object'         |'i'|'obj_object'
-- 69|'23503'|''|'com'|'fk_obj_codifier_can_defines_object_stype'  |'d'|'obj_codifier'
-- 59|'23503'|''|'com'|'fk_obj_codifier_can_defines_object_stype'  |'i'|'obj_object'
-- 56|'23503'|''|'com'|'fk_obj_codifier_defines_object_type'       |'i'|'obj_object'
-- 71|'23503'|''|'com'|'fk_obj_codifier_defines_object_type'       |'d'|'obj_codifier'
-- ------------------------------------------------------------------------------------
-- 77|'23514'|''|'nso'|'chk_nso_log_impact_type'                   |'i'|'nso_log'
-- -
-- 73|'23503'|''|'nso'|'fk_nso_object_can_define_nso_domain_column'|'d'|'nso_object'
-- 75|'23503'|''|'nso'|'fk_nso_record_defines_object_secret_level' |'d'|'nso_record'
-- 74|'23503'|''|'nso'|'fk_nso_record_is_owner_obj_object'         |'d'|'nso_record'
