DROP FUNCTION IF EXISTS com.com_p_sys_errors_i (public.t_arr_text);
CREATE OR REPLACE FUNCTION com.com_p_sys_errors_i ( 
             p_schema_name public.t_arr_text = ARRAY['com'::text, 'nso'::text, 'auth'::text, 'ind'::text, 'uio'::text, 'utl'::text ]
    ) 
    RETURNS public.result_long_t
    LANGUAGE plpgsql SECURITY DEFINER
    AS 
 $$
  -- ========================================================================== --
  --  2015-06-15  Скрипт обновления описания кодов системных ошибок Роман.      --
  --  2017-06-01  Nick  Скрипт оказался неправильным. Оформлено в виде функций  --
  --  2020-01-02  Nick  Рефакторинг.                                            --
  -- ========================================================================== -- 
   DECLARE 
     _sys_errors RECORD;
     _schema_name public.t_arr_text := COALESCE (p_schema_name, ARRAY ['com', 'nso', 'auth', 'ind', 'uio', 'utl']);
     _mess        public.t_text     := '';
       --
     _count_ins public.small_t := 0;
     _count_old public.small_t := 0;

     c_ERR_FUNC_NAME public.t_sysname := 'com_p_sys_errors_i'; --имя процедуры
     c_DEBUG         public.t_boolean := utl.f_debug_status();
       
     rsp_main    public.result_long_t;             -- Nick 2020-01-02
     _exception  public.exception_type_t;
     _err_args   public.t_arr_text := ARRAY [''];	       
       
   BEGIN
      _count_old := (SELECT COUNT (*) FROM com.sys_errors)::public.small_t;
      -- ---------------------------------------------
      -- 1. Заполнение таблицы  по ошибке 23505 PK+AK
      -- ---------------------------------------------
      FOR _sys_errors IN SELECT DISTINCT
                                   '23505'      AS err_code 
                                  ,schema_name  AS sch_name      
                                  , index_name  AS constr_name
                                  ,'i'          AS opr_type
                                  ,table_name   AS tbl_name
                         FROM db_info.f_show_unique_descr () 
                                      WHERE ((schema_name = ANY (_schema_name)
                                             ) AND (index_type <> 'C_INDEX')
                                            )
                                  ORDER BY schema_name, tbl_name, index_name 
         LOOP
            INSERT INTO com.sys_errors (err_code, sch_name, constr_name, opr_type, tbl_name)
               VALUES (_sys_errors.err_code
                     , _sys_errors.sch_name
                     , _sys_errors.constr_name
                     , _sys_errors.opr_type
                     , _sys_errors.tbl_name
             )
               ON CONFLICT (err_code, constr_name, tbl_name, opr_type)
                                DO NOTHING;
            IF FOUND
              THEN 
                   _count_ins := _count_ins + 1;                
            END IF;
      END LOOP;
      -- ----------------------------------------------------
      -- 2. Заполнение таблицы по ошибке 23503 FK  для детей
      -- ----------------------------------------------------
      FOR _sys_errors IN SELECT DISTINCT
                                        '23503'     AS err_code
                                       ,schema_name AS sch_name 
                                       ,constr_name
                                       ,'i'         AS opr_type
                                       , table_name AS tbl_name
                         FROM db_info.f_show_fk_descr() 
                                  ORDER BY schema_name, tbl_name, constr_name 
         LOOP
            INSERT INTO com.sys_errors (err_code, sch_name, constr_name, opr_type, tbl_name)
               VALUES (_sys_errors.err_code
                     , _sys_errors.sch_name
                     , _sys_errors.constr_name
                     , _sys_errors.opr_type
                     , _sys_errors.tbl_name
             )
               ON CONFLICT (err_code, constr_name, tbl_name, opr_type)
                                DO NOTHING;                
            IF FOUND
              THEN 
                   _count_ins := _count_ins + 1;                
            END IF;
      END LOOP;
      --
      -- 3. Заполнение таблицы по ошибке 23503 FK  для родителей
      --
      FOR _sys_errors IN SELECT DISTINCT
                                        '23503'     AS err_code
                                       ,schema_name AS sch_name 
                                       ,constr_name
                                       ,'d'         AS opr_type
                                       , table_name AS tbl_name
                         FROM db_info.f_show_fk_descr() 
                                  ORDER BY schema_name, tbl_name, constr_name 
         LOOP
            INSERT INTO com.sys_errors (err_code, sch_name, constr_name, opr_type, tbl_name)
              VALUES (_sys_errors.err_code
                    , _sys_errors.sch_name
                    , _sys_errors.constr_name
                    , _sys_errors.opr_type
                    , _sys_errors.tbl_name
            )
              ON CONFLICT (err_code, constr_name, tbl_name, opr_type)
                               DO NOTHING;                
            IF FOUND
              THEN 
                   _count_ins := _count_ins + 1;                
            END IF;                      
      END LOOP;
      --
      -- 4. Заполнение таблицы по ошибке 23514 check
      --
      FOR _sys_errors IN SELECT DISTINCT
                                        '23514'     AS err_code
                                       ,schema_name AS sch_name 
                                       ,check_name  AS constr_name
                                       ,'i'         AS opr_type
                                       , table_name AS tbl_name
                         FROM db_info.f_show_check_descr() 
                                  ORDER BY schema_name, tbl_name, constr_name 
        LOOP
            INSERT INTO com.sys_errors (err_code, sch_name, constr_name, opr_type, tbl_name)
              VALUES (_sys_errors.err_code
                    , _sys_errors.sch_name
                    , _sys_errors.constr_name
                    , _sys_errors.opr_type
                    , _sys_errors.tbl_name
            )
              ON CONFLICT (err_code, constr_name, tbl_name, opr_type)
                               DO NOTHING;                
            IF FOUND
              THEN 
                   _count_ins := _count_ins + 1;                
            END IF; 
      END LOOP;

     _mess := 'Всего было: "' || _count_old || '" Вставлено: "' || _count_ins || '"' ;
              
  RETURN ((_count_old + _count_ins), _mess)::public.result_long_t;
  
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

COMMENT ON FUNCTION com.com_p_sys_errors_i (public.t_arr_text) 
IS '251: Заполнение таблицы ошибок (системная часть).
	Входные параметры:
		1) p_schema_name public.t_arr_text = ARRAY [''com'', ''nso'', ''auth'', ''ind'', ''uio'', ''utl'']

	Выходные параметры:
		1) public.t_text -- Отчёт о выполнении';
------------------------------------------------------------------------------------------
-- SELECT * FROM plpgsql_check_function ('com.com_p_sys_errors_i (public.t_arr_text)');
-- 'warning extra:00000:16:DECLARE:never read variable "c_debug"'

-- SELECT * FROM com.com_p_sys_errors_i (ARRAY['com', 'nso', 'ind', 'auth']); 
-- SELECT * FROM com.sys_errors;
-- SELECT * FROM com.com_p_sys_errors_pk_u (ARRAY['com', 'nso', 'ind', 'auth']);
-- SELECT * FROM com.com_p_sys_errors_ak_u (ARRAY['com', 'nso', 'ind', 'auth']);

-- 'Необработанная ошибка: код = 42703, текст = столбец c.consrc не существует
-- 	Контекст: функция PL/pgSQL db_info.f_show_check_descr(character varying,character varying,character varying), строка 3, оператор RETURN QUERY
-- функция PL/pgSQL com.com_p_sys_errors_i(t_arr_text), строка 108, оператор FOR по результатам SELECT
-- 	Совет: Возможно, предполагалась ссылка на столбец "c.conkey" или столбец "c.conbin".'