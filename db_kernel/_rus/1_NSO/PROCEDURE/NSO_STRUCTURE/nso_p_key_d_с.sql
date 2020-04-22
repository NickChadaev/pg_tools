/* --------------------------------------------------------------------------------------------------------------------
	Входные параметры:
		1) p_key_code public.t_str60 -- Код ключа
	Выходные параметры:
		1) _result        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение
-------------------------------------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS nso_structure.nso_p_key_d ( public.t_str60 );
CREATE OR REPLACE FUNCTION nso_structure.nso_p_key_d (
        p_key_code public.t_str60 -- Код ключа
)
RETURNS public.result_long_t 
   SET search_path = nso, com, utl, com_codifier, com_domain, nso_strucrure, com_error, public,pg_catalog
AS
 $$
    -- ====================================================================== 
    --    Author: Gregory
    --    Create date: 2015-12-07
    --    Description:	Удаление ключа по коду
    -- ----------------------------------------------------------------------
    --    2019-08-29 Nick Новое ядро.
    -- ====================================================================== 
  DECLARE
    _key_id public.id_t;
    _nso_id public.id_t;
    _s_code public.t_code1;
    _col_id public.t_arr_id;
    
    _key_code public.t_str60 := utl.com_f_empty_string_to_null (upper( btrim (p_key_code)));   -- Код ключа/марекера ключа
    
    c_ERR_FUNC_NAME public.t_sysname := 'nso_p_key_d'; -- Имя функции в которой произошла ошибка.
	
    rsp_main    public.result_long_t;
    --
    _exception  public.exception_type_t;
    _err_args   public.t_arr_text := ARRAY [''];
    --
    C_DEBUG public.t_boolean := utl.f_debug_status();
	
  BEGIN
	IF _key_code IS NULL
	THEN
		RAISE SQLSTATE '60000'; -- NULL значения запрещены
        ELSE
                SELECT key_id, nso_id, key_small_code  INTO _key_id, _nso_id, _s_code
                    FROM ONLY nso.nso_key WHERE key_code = _key_code;
	END IF;

    PERFORM nso.nso_p_nso_log_i ('E','Удаление заголовка ключа: ' || _key_code);

    SELECT array_agg (col_id::bigint) INTO _col_id FROM ONLY nso.nso_key_attr WHERE key_id = _key_id;
    -- Nick 2019-08-29
    IF C_DEBUG
      THEN
          RAISE NOTICE '<%>, %, %, %', c_ERR_FUNC_NAME, _key_code, _key_id, _col_id;
     END IF; 
    -- Nick 2019-08-29
    UPDATE ONLY nso.nso_abs SET s_key_code = '0' WHERE col_id = ANY(_col_id) AND s_key_code = _s_code;

    UPDATE ONLY nso.nso_object
    SET     nso_release = nso_release + 1
           ,nso_select = nso_structure.nso_f_select_c (nso_code)
    WHERE nso_id = _nso_id;

    DELETE FROM ONLY nso.nso_key_attr WHERE key_id = _key_id;
	DELETE FROM ONLY nso.nso_key WHERE key_code = _key_code;
	--
	IF FOUND
	THEN
	    rsp_main.rc   := _key_id;
		rsp_main.errm := 'Успешно удален ключ "' || _key_code || '"';	
	ELSE
		RAISE SQLSTATE '60004'; -- Запись не найдена
	END IF;
	--
	RETURN rsp_main;
	
  EXCEPTION
	WHEN OTHERS
	THEN
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
			
	   RETURN rsp_main;			
	 END;
  END;
 $$
LANGUAGE plpgsql
SECURITY DEFINER;

COMMENT ON FUNCTION nso_structure.nso_p_key_d (public.t_str60) IS '230: Удаление ключа по коду.
	Входные параметры:
		1) p_key_code public.t_str60 -- Код ключа
		
	Выходные параметры:
		1) _result        public.result_long_t    -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint          -- ID удалённой записи при успехе / -1 (при ошибке)
                1.2) _result.errm text -- Сообщение';

-- SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_p_key_d (public.t_str60)');
-- SELECT * FROM ONLY nso.nso_key
-- SELECT * FROM nso.nso_p_key_d('K_SPR_EX_ENTERPRISE_IEKEY')
-- SELECT * FROM ONLY nso.nso_key_hist

-- SELECT * FROM ONLY nso.nso_key_attr
-- SELECT * FROM nso.nso_key_attr_hist
-- SELECT * FROM ONLY nso.nso_key
-- SELECT * FROM nso.nso_key_hist
-- SELECT * FROM ONLY nso.nso_abs WHERE log_id = 205
-- SELECT * FROM nso.nso_abs_hist
-- SELECT * FROM nso.nso_p_key_d('K_SPR_EMPLOYE_DEFKEY');
-- SELECT * FROM nso.nso_log
