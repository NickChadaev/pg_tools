/* --------------------------------------------------------------------------------------------------------------------
	Входные параметры:
		p_attr_code t_str60 -- Код атрибута
	Выходные параметры:	
		при успешном завершении:
                        rsp_main.rc   = <0>
                        rsp_main.errm = <Сообщение о успешности завершения>
		при неуспешном завершении:
			rsp_main.rc   = <-1>
			rsp_main.errm = <Сообщение об ошибке> 
-----------------------------------------------------------------------------------------------------------------------
	Особенности:
		перегрузка процедуры удаления атрибута по идентификатору
		com.nso_p_domain_column_d(id_t)
-------------------------------------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS com_domain.nso_p_domain_column_d ( public.id_t );
CREATE OR REPLACE FUNCTION com_domain.nso_p_domain_column_d (
	          p_attr_id  public.id_t -- ID атрибута
)
RETURNS public.result_long_t 
   SET search_path = com_domain, com_domaincom, nso, public 
  AS
  $$
  -- =============================================================================================== 
  -- Author: Gregory
  -- Create date: 2015-06-09
  -- Description:	Удаление атрибута по ID.
  -- 2015-07-20 Gregory «FROM com.nso_domain_column» изменено на «FROM ONLY com.nso_domain_column»
  -- 2019-07-01 Nick  Новое ядро
  -- =============================================================================================== 
  DECLARE
    c_ERR_FUNC_NAME public.t_sysname := 'nso_p_domain_column_d'; -- Имя функции в которой произошла ошибка.
      --
    rsp_main public.result_long_t;
      --
   _exception  public.exception_type_t;
   _err_args   public.t_arr_text := ARRAY [''];  	
  	
  BEGIN
  	IF p_attr_id IS NULL
  	THEN
  		RAISE SQLSTATE '60000'; -- NULL значения запрещены
  	END IF;
  
  	DELETE FROM ONLY com.nso_domain_column WHERE (attr_id = p_attr_id);
  	
  	IF FOUND
  	THEN
       	RETURN (p_attr_id::bigint, 'Успешно удален атрибут'::text )::public.result_long_t;
  	ELSE
        _err_args [1] := p_attr_id::text;
  	    RAISE SQLSTATE '61073'; -- Запись не найдена
  	END IF;
  	
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
			
	   RETURN rsp_main;			
	END;
  END;
  $$
LANGUAGE plpgsql
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION com_domain.nso_p_domain_column_d (public.id_t) IS '107: Удаление записи в домене атрибутов. Агрумент ID атрибута
	Аргументы:
		1) p_attr_id	  public.id_t	-- Идентификатор атрибута
	Выходные данные:
		1) result_t.rc    bigint	    -- 0 при удачном завешении функции, в случае неудачи -1
		2) result_t.errm  text	       -- Сообщение';

-- SELECT * FROM com.nso_p_domain_column_d(NULL::id_t);
-- -1;"Все параметры явялются обязательными, NULL значения запрещены. Ошибка произошла в функции: "nso_p_domain_column_d(id_t)"."
		
-- SELECT * FROM com.nso_p_domain_column_d(100500);
--   -1;"Запись не найдена. Ошибка произошла в функции: "nso_p_domain_column_d(id_t)"."
--   'Необработанная ошибка: код = 42P01, текст = отношение "com.nso_domain_column" не существует. Ошибка произошла в функции: "nso_p_domain_column_d(id_t)".'
--
-- SELECT newid()
-- "4dacac54-c177-44e8-887c-1c589d4c808a"
-- SELECT * FROM com.nso_p_domain_column_i('APP_NODE', 't_str60', 'TEST_ATTR', 'Тест', '4dacac54-c177-44e8-887c-1c589d4c808a');
-- 50;"Выполнено успешно"
-- SELECT * FROM com.nso_p_domain_column_d(50);
-- 0;"Успешно удален атрибут"

-- SELECT attr_id FROM com.nso_domain_column WHERE attr_code = 'FC_PHONE';
-- 29
-- SELECT * FROM com.nso_p_domain_column_d(29);
-- -1;"Ошибка при удалении атрибута. Он уже используется в заголовке.. Ошибка произошла в функции: "nso_p_domain_column_d(id_t)"."
