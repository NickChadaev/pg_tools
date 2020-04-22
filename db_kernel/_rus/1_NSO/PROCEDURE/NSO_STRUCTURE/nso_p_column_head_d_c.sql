/* ----------------------------------------------- 
        Входные параметры:
                1) p_nso_code   public.t_str60 -- Код НСО
                2) p_number_col public.small_t -- Номер элемента заголовка
	Выходные параметры:
                1) _result        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение
--------------------------------------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS nso_structure.nso_p_column_head_d (public.t_str60, public.small_t);
CREATE OR REPLACE FUNCTION nso_structure.nso_p_column_head_d
(
        p_nso_code   public.t_str60 -- Код НСО
       ,p_number_col public.small_t -- номер элемента заголовка
)
   RETURNS public.result_long_t 
   SET search_path = nso, com, utl, com_codifier, com_domain, nso_strucrure, com_error, public,pg_catalog
AS 
 $$
 -- =============================================== 
 -- Author: Gregory
 -- Create date: 2015-10-04
 -- Description: Удаление элемента заголовка
 -- ----------------------------------------------- 
 -- 2015-10-14 Исправления ревизия 846  Gregory                         
 -- 2019-08-11 Nick Новое ядро.
 -- =============================================== 
  DECLARE
   _nso_id    public.id_t;
   _col_id    public.id_t;
   _col_code  public.t_str60;
   _nso_code  public.t_str60 := utl.com_f_empty_string_to_null (btrim (upper (p_nso_code))); -- Код объекта владельца  -- Nick 2015-10-13
   _key_id    public.id_t;
   
   _section_number smallint; -- Nick 2019-08-11/2020-04-14
   
   _result    public.result_long_t;
    --
   c_ERR_FUNC_NAME public.t_sysname = 'nso_p_column_head_d';
   c_MESS_OK       public.t_str1024;
    --
   _exception  public.exception_type_t;
   _err_args   public.t_arr_text := ARRAY [''];
    --
   C_DEBUG public.t_boolean := utl.f_debug_status();
   
  BEGIN
    IF (_nso_code IS NOT NULL) AND (p_number_col IS NOT NULL)
    THEN
      SELECT nso_id, col_id, col_code INTO _nso_id, _col_id, _col_code FROM ONLY nso.nso_column_head 
            JOIN ONLY nso.nso_object USING (nso_id)
      WHERE nso_code = _nso_code AND number_col = p_number_col;
      --
      IF (_col_id IS NOT NULL) AND (_nso_code IS NOT NULL)
      THEN
          IF C_DEBUG
            THEN
               RAISE NOTICE '<%>, %, %, %, %, %', c_ERR_FUNC_NAME
                                 ,_nso_code,  p_number_col, _nso_id, _col_id, _col_code;
          END IF;
          -- Nick 2019-08-11 Определение номера секции
          SELECT section_number INTO _section_number FROM nso.nso_record WHERE (nso_id = _nso_id) LIMIT 1;   
          -- Nick 2019-08-11
          
          c_MESS_OK = 'Успешно удален элемента заголовка "' || _col_code || '", НСО "' || _nso_code || '".';
          --
          PERFORM nso.nso_p_nso_log_i ('B', 'Удаление элемента заголовка: "' || _col_code || '". ДАННЫЕ ПРОПАЛИ.');
          
          -- Nick 2019-08-11
          DELETE FROM nso.nso_abs  
                   WHERE (col_id = _col_id) AND ((section_number = _section_number) AND (_section_number IS NOT NULL));
          --          
          DELETE FROM nso.nso_blob 
                   WHERE (col_id = _col_id) AND ((section_number = _section_number) AND (_section_number IS NOT NULL));
          -- Nick 2019-08-11        
          
          DELETE FROM ONLY nso.nso_ref  WHERE col_id = _col_id;
          -- ???
          SELECT key_id INTO _key_id FROM ONLY nso.nso_key_attr WHERE col_id = _col_id;
          --
          IF C_DEBUG
            THEN
                 RAISE NOTICE '<%>, %', c_ERR_FUNC_NAME, _key_id;
          END IF;
          --
          DELETE FROM ONLY nso.nso_key_attr WHERE col_id = _col_id;
          
          IF NOT EXISTS (SELECT 1 FROM ONLY nso.nso_key_attr WHERE key_id = _key_id)
          THEN
                  DELETE FROM ONLY nso.nso_key WHERE key_id = _key_id;
          END IF;

          -- IF NOT EXISTS (SELECT 1 FROM ONLY nso.nso_key WHERE nso_id = _nso_id)
          -- THEN
          --        RAISE SQLSTATE '63019'; -- Удаление последнего ключевого поля запрещено
          -- END IF;
          -- ??? Nick 2019-08-11
          
          DELETE FROM ONLY nso.nso_column_head WHERE col_id = _col_id;

          UPDATE ONLY nso.nso_object
          SET
               nso_release = nso_release + 1 -- Версия НСО
             , nso_select  = nso_structure.nso_f_select_c (_nso_code) -- Конструкция SELECT   -- Nick 2015-10-13
          WHERE nso_id = _nso_id;

       ELSE -- НСО с кодом = <>, не имеет колонки с номером = <>
              _err_args [1] := _nso_code; 
              _err_args [2] := p_number_col::text;
              RAISE SQLSTATE '62031'; -- Запись не найдена 
      END IF;
    ELSE
            RAISE SQLSTATE '60000'; -- NULL значения запрещены
    END IF;
    	
  	_result.rc = _col_id; -- Nick 2019-08-11
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

COMMENT ON FUNCTION nso_structure.nso_p_column_head_d (public.t_str60, public.small_t)
IS '298: Удаление элемента заголовка
        Входные параметры:
                1) p_nso_code   public.t_str60 -- Код НСО
                2) p_number_col public.small_t -- Номер элемента заголовка
	Выходные параметры:
                1) _result        public.result_long_t    -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm text                    -- Сообщение';
--
-- ---------------------------------------------------------------------------------------

--  SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_p_column_head_d (public.t_str60, public.small_t)');
