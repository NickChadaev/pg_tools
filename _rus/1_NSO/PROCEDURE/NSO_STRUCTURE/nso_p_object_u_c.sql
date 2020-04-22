/* ---------------------------------------------------------------------------------------------------------------------
        Входные параметры:
                1) p_nso_code        public.t_str60     -- Код НСО, поисковый аргумент, всегда NOT NULL
                2) p_parent_nso_code public.t_str60     -- Код родительского НСО,       если NULL - сохраняется старое значение.
                3) p_nso_type_code   public.t_str60     -- Код типа НСО,                если NULL - сохраняется старое значение.
                4) p_nso_uuid        public.t_guid      -- UUID НСО,                    если NULL - сохраняется старое значение. 
                5) p_is_intra_op     public.t_boolean   -- Признак интраоперабельности, если NULL - сохраняется старое значение. 
                6) p_new_nso_code    public.t_str60     -- Код НСО, новое значение,     если NULL - сохраняется старое значение.
                7) p_nso_name        public.t_str250    -- Наименование НСО,            если NULL - сохраняется старое значение. 
                8) p_date_from       public.t_timestamp -- Дата начала актуальности,    если NULL - сохраняется старое значение. 
                9) p_date_to         public.t_timestamp -- Дата конца актуальтности,    если NULL - сохраняется старое значение. 
	Выходные параметры:
                1) _result        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- ID НСО (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение
--------------------------------------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS nso_structure.nso_p_object_u (public.t_str60, public.t_str60, public.t_str60, public.t_guid, public.t_boolean, public.t_str60, public.t_str250);
CREATE OR REPLACE FUNCTION nso_structure.nso_p_object_u
(
        p_nso_code        public.t_str60         -- Код НСО, поисковый аргумент, всегда NOT NULL
       ,p_parent_nso_code public.t_str60   = NULL -- Код родительского НСО, если NULL - сохраняется старое значение.
       ,p_nso_type_code   public.t_str60   = NULL -- Код типа НСО
       ,p_nso_uuid        public.t_guid    = NULL -- UUID НСО
       ,p_is_intra_op     public.t_boolean = NULL -- Признак интраоперабельности
       ,p_new_nso_code    public.t_str60   = NULL -- Код НСО, новое значение
       ,p_nso_name        public.t_str250  = NULL -- Наименование НСО
)
RETURNS public.result_long_t 
      SET search_path = nso, com, utl, com_codifier, com_domain, nso_strucrure, com_error, public,pg_catalog
AS 
 $$
    -- ==============================================================================================
    -- Author: Gregory
    -- Create date: 2015-09-03
    -- Description: Обновление нормативно-справочного объекта
    -- Modification: 2015-11-02 Gregory добавлен аргумент p_new_nso_code.  Ревизия 1044.
    --     2016-05-15 Nick Внесены изменения в коды объектов базы: 'C_VIEW' и 'C_MAT_VIEW'
    --     2019-08-20 Nick Новое ядро. Убраны "p_date_from", "p_date_to".
    -- ==============================================================================================
  DECLARE
     _nso_id      public.id_t;
     _nso_code    public.t_str60 := utl.com_f_empty_string_to_null (upper( btrim (p_nso_code)));    -- Код НСО, новое значение
     --
     _is_group      public.t_boolean;
     --
     _parent_nso_code public.t_str60 := utl.com_f_empty_string_to_null (upper( btrim (p_parent_nso_code))); -- Код родительского НСО, если NULL - сохраняется старое значение.
     _parent_nso_id   public.id_t;

     _nso_type_code   public.t_str60 := utl.com_f_empty_string_to_null (upper( btrim (p_nso_type_code)));   -- Код типа НСО если NULL - сохраняется старое значение.
     _nso_type_id     public.id_t;
      -- 
     _new_nso_code    public.t_str60 := utl.com_f_empty_string_to_null (upper( btrim (p_new_nso_code)));    -- Код НСО, новое значение
     --
     _nso_code_old    public.t_str60; -- Вторичные переменные.
     _nso_code_new    public.t_str60;
     --     
     _nso_name        public.t_str250 := utl.com_f_empty_string_to_null (btrim (p_nso_name));-- Наименование НСО
     --
     _record record;
     
     _result                 public.result_long_t;
     c_ERR_FUNC_NAME         public.t_sysname = 'nso_p_object_u';
     --
    -- c_MESS_PARENT_FIND_FAIL public.t_str1024 = 'Запись родительского НСО с кодом "' || p_parent_nso_code || '" не найдена.';
    -- c_MESS_TYPE_FIND_FAIL   public.t_str1024 = 'Запись типа НСО с кодом "' || p_nso_type_code || '" не найдена.';

    c_MESS_OK_0 public.t_text = 'Успешно обновлен нормативно-справочный объект, код = "';
    c_MESS_OK_1 public.t_text = '".';
     --    
    _exception  public.exception_type_t;
    _err_args   public.t_arr_text := ARRAY [''];        
        
  BEGIN
        IF _nso_code IS NOT NULL
        THEN
             _nso_id := nso_structure.nso_f_object_get_id (_nso_code);
        ELSE
             RAISE SQLSTATE '60000'; -- NULL значения запрещены
        END IF;

        SELECT nso_id, is_group_nso INTO _parent_nso_id, _is_group
        FROM ONLY nso.nso_object WHERE (nso_code = _parent_nso_code);

        IF (_parent_nso_code IS NOT NULL) AND (_parent_nso_id IS NULL)
        THEN
                _err_args [1] := _parent_nso_code;
                RAISE SQLSTATE '62003';
        END IF;
        --
        IF NOT (_is_group)
          THEN
                _err_args [1] := _parent_nso_code;
                RAISE SQLSTATE '62003';
        END IF;
        --
        _nso_type_id := com_codifier.com_f_obj_codifier_get_id (_nso_type_code);
        
        IF (_nso_type_code IS NOT NULL) AND (_nso_type_id IS NULL)
        THEN
                _err_args [1] := _nso_type_code;
                RAISE SQLSTATE '62010';
        END IF;        

        _nso_code_old := nso_structure.nso_f_object_get_code (_nso_id);

        UPDATE ONLY nso.nso_object
        SET
                parent_nso_id = COALESCE (_parent_nso_id, parent_nso_id) -- Идентификатор родительского НСО
               ,nso_type_id   = COALESCE (_nso_type_id, nso_type_id) -- Тип НСО
               ,nso_uuid      = COALESCE (p_nso_uuid, nso_uuid) -- UUID НСО
               ,nso_release   = nso_release + 1 -- Версия НСО
               ,is_intra_op   = COALESCE (p_is_intra_op, is_intra_op) -- Признак интраоперабельности
               ,nso_code      = COALESCE (_new_nso_code, nso_code) -- Код НСО, новое значение
               ,nso_name      = COALESCE (_nso_name, nso_name) -- Наименование НСО
  	    WHERE (nso_id = _nso_id);
  
        IF FOUND
        THEN
             _result.rc = _nso_id;
             _result.errm = c_MESS_OK_0 || _new_nso_code || c_MESS_OK_1;
        ELSE
             _err_args [1] := _nso_code::text; 
              RAISE SQLSTATE '62020'; -- Запись не найдена 
  	END IF;
    -- Nick 2019-07-29
  	_nso_code_new := nso_structure.nso_f_object_get_code (_nso_id);

    IF _nso_code_old != _nso_code_new
    THEN
      RAISE NOTICE 
         'Изменился код НСО: % -> %, обновляются связанные структуры (заголовок, запрос, представление)'
        ,_nso_code_old, _nso_code_new;
      
      UPDATE ONLY nso.nso_column_head SET col_code = replace(col_code, _nso_code_old, _nso_code_new)
      WHERE col_code LIKE '%' || _nso_code_old || '%'  AND nso_id = _nso_id;

      UPDATE ONLY com.nso_domain_column SET attr_code = replace(attr_code, _nso_code_old, _nso_code_new)
      WHERE attr_code LIKE '%' || _nso_code_old || '%';

      UPDATE ONLY nso.nso_key SET key_code = replace(key_code, _nso_code_old, _nso_code_new)
      WHERE key_code LIKE '%' || _nso_code_old || '%';

      UPDATE ONLY nso.nso_object SET nso_select = nso_structure.nso_f_select_c(nso_code)
      WHERE nso_id = _nso_id;

      -- Nick 2015-11-09
      FOR _record IN
          SELECT schema_name
               , obj_name
               , obj_type 
               , nso_structure.nso_p_view_c ( upper( btrim ( _nso_code_new ))::public.t_str60, (obj_type = 'C_MAT_VIEW' ), schema_name )
               FROM db_info.f_show_tbv_descr ( NULL, NULL ) WHERE obj_name = 'v_' || lower ( btrim ( _nso_code_old ))    
      LOOP
          IF _record.obj_type = 'C_MAT_VIEW' -- -- Nick 2016-05-16
          THEN
                  EXECUTE 'DROP ' || _record.obj_type || ' IF EXISTS ' || _record.schema_name || '.' || _record.obj_name;
            ELSIF _record.obj_type = 'C_VIEW' -- Nick 2016-05-16
            THEN
                  EXECUTE 'DROP ' || _record.obj_type || ' IF EXISTS ' || _record.schema_name || '.' || _record.obj_name;
          END IF;
      END LOOP;
      -- Nick 2015-11-09
    END IF;
  	
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

COMMENT ON FUNCTION nso_structure.nso_p_object_u (public.t_str60, public.t_str60, public.t_str60, public.t_guid, public.t_boolean, public.t_str60, public.t_str250)
IS '222: Обновление Нормативно-Справочного Объекта, аргумент Код НСО
        Входные параметры:
                1) p_nso_code        public.t_str60     -- Код НСО, поисковый аргумент, всегда NOT NULL
                2) p_parent_nso_code public.t_str60     -- Код родительского НСО,       если NULL - сохраняется старое значение.
                3) p_nso_type_code   public.t_str60     -- Код типа НСО,                если NULL - сохраняется старое значение.
                4) p_nso_uuid        public.t_guid      -- UUID НСО,                    если NULL - сохраняется старое значение. 
                5) p_is_intra_op     public.t_boolean   -- Признак интраоперабельности, если NULL - сохраняется старое значение. 
                6) p_new_nso_code    public.t_str60     -- Код НСО, новое значение,     если NULL - сохраняется старое значение.
                7) p_nso_name        public.t_str250    -- Наименование НСО,            если NULL - сохраняется старое значение. 

        Выходные параметры:
                1) _result        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- ID НСО (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение';

-- ----------------------------------------------------------------------------------------            
-- SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_p_object_u (public.t_str60, public.t_str60, public.t_str60, public.t_guid, public.t_boolean, public.t_str60, public.t_str250)');
--
-- SELECT * FROM plpgsql_check_function_tb (
--     'nso_structure.nso_p_object_u (public.t_str60, public.t_str60, public.t_str60, public.t_guid, public.t_boolean, public.t_str60, public.t_str250)'
--     , security_warnings := true, fatal_errors := false
--     );
-- --------------------------------
-- ERROR:  function "nso_structure.nso_p_object_u (public.t_str60, public.t_str60, public.t_str60, public.t_guid, public.t_boolean, public.t_str60, public.t_str250)" does not exist
-- CONTEXT:  PL/pgSQL function __plpgsql_check_getfuncid(text) line 9 at RETURN
-- PL/pgSQL function plpgsql_check_function_tb(text,regclass,boolean,boolean,boolean,boolean,boolean,name,name) line 3 at RETURN QUERY
-- 
-- ********** Ошибка **********
-- 
-- ERROR: function "nso_structure.nso_p_object_u (public.t_str60, public.t_str60, public.t_str60, public.t_guid, public.t_boolean, public.t_str60, public.t_str250)" does not exist
-- SQL-состояние: 42883
-- Контекст: PL/pgSQL function __plpgsql_check_getfuncid(text) line 9 at RETURN
-- PL/pgSQL function plpgsql_check_function_tb(text,regclass,boolean,boolean,boolean,boolean,boolean,name,name) line 3 at RETURN QUERY

-- SELECT * FROM nso_structure.nso_p_object_u(NULL);
-- -1;"Все параметры явялются обязательными, NULL значения запрещены. Ошибка произошла в функции: "nso_p_object_u"."

-- SELECT * FROM nso.nso_p_object_u('CL_TEST22'); -- -1|'Ошибка, НСО с ID = None отсутствует
--	Контекст: PL/pgSQL function nso_p_object_u(t_str60,t_str60,t_str60,t_guid,t_boolean,t_str60,t_str250) line 93 at RAISE'
-- -1;"Запись не найдена. Ошибка произошла в функции: "nso_p_object_u". 

-- SELECT * FROM nso.nso_p_object_u('SPR_PAYMENT_STATUS');
-- 24;"Успешно обновлен нормативно-справочный объект с кодом "SPR_PAYMENT_STATUS"."

-- SELECT * FROM nso.nso_p_object_u('SPR_PAYMENT_STATUS', 'BUBLIK');
-- -1;"Запись родительского НСО с кодом "BUBLIK" не найдена."

-- SELECT * FROM nso.nso_p_object_u('SPR_PAYMENT_STATUS', 'SPR_LOCAL');
-- 24;"Успешно обновлен нормативно-справочный объект с кодом "SPR_PAYMENT_STATUS"."

-- SELECT * FROM nso.nso_p_object_u('SPR_PAYMENT_STATUS', 'SPR_LOCAL', 'BUBLIK');
-- -1;"Запись типа НСО с кодом "BUBLIK" не найдена."

-- SELECT * FROM nso.nso_p_object_u('SPR_PAYMENT_STATUS', 'SPR_LOCAL', 'C_NSO_SPR');
-- 24;"Успешно обновлен нормативно-справочный объект с кодом "SPR_PAYMENT_STATUS"."

-- SELECT * FROM nso.nso_object_hist

-- SELECT * FROM nso.nso_p_object_u ('KL_SECR', 'SPR_EMPLOYE');
-- -1;"Родительского НСО нет, либо он не узловой. Ошибка произошла в функции: "nso_p_object_u"."

-- SELECT * FROM nso.nso_p_object_u ('CL_TEST', NULL, NULL, NULL, NULL, 'CL_TST')
-- SELECT * FROM nso.nso_p_object_u ('CL_TST', NULL, NULL, NULL, NULL, 'CL_TEST')
-- SELECT * FROM nso.v_cl_tst;
-- SELECT * FROM nso.v_cl_test;
-- SELECT * FROM ONLY nso.nso_object
-- SELECT * FROM ONLY com.nso_domain_column
-- SELECT * FROM ONLY nso.nso_column_head
-- SELECT * FROM ONLY nso.nso_key
