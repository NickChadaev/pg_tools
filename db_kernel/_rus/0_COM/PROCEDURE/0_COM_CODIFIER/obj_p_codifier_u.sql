/*
     Аргументы:
                   p_id     id_t             -- ID записи аргумент NULL запрещается.
				   p_parent id_t     = NULL  -- ID родителя, если NULL - сохраняется старое значение 
 						,p_code   t_str60  = NULL  -- Код,         если NULL - сохраняется старое значение 
						,p_name   t_str250 = NULL  -- Наименоваие, если NULL - сохраняется старое значение
                  ,p_scode  t_code1  = NULL  -- Краткий код, если NULL - сохраняется старое значение
                   --
                  ,p_date_from   t_timestamp = NULL -- Дата начала актуальности
                  ,p_date_to     t_timestamp = NULL -- Дата окончания актуальности
                  ,p_codif_uuid  t_guid      = NULL -- UUID кодификатора

     Выходные величины:
				 rsp_main.rc = nn - процедура завершилась успешно
				 rsp_main.rc = -1 - процедура завершилась с ошибкой
             --
             rsp_main.errm = <Сообщение>
*/

DROP FUNCTION IF EXISTS com_codifier.obj_p_codifier_u ( public.id_t, public.id_t, public.t_str60, public.t_str250, public.t_code1, public.t_guid);
CREATE OR REPLACE FUNCTION com_codifier.obj_p_codifier_u (
                   p_id          public.id_t            -- ID записи аргумент NULL запрещается.
                  ,p_parent      public.id_t     = NULL -- ID родителя       если NULL - сохраняется старое значение 
                  ,p_code        public.t_str60  = NULL -- Код               если NULL - сохраняется старое значение 
                  ,p_name        public.t_str250 = NULL -- Наименоваие       если NULL - сохраняется старое значение
                  ,p_scode       public.t_code1  = NULL -- Краткий код       если NULL - сохраняется старое значение
                  ,p_codif_uuid  public.t_guid   = NULL -- UUID кодификатора если NULL - сохраняется старое значение
					)
     RETURNS public.result_long_t
     SECURITY DEFINER -- 2015-04-05
     LANGUAGE plpgsql 
     SET search_path = com_codifier,com_error, com, public, pg_catalog   
AS 
 $$
   -- ===============================================================================================
   -- Author:	SVETA
   -- Create date: 2013-08-14
   -- Description:	Обновление  записи в кодификаторе
   --       2015-07-20 Gregory «UPDATE com.OBJ_CODIFIER» изменено на «UPDATE ONLY com.OBJ_CODIFIER»
   -- -----------------------------------------------------------------------------------------------
   --  2015-10-01 Nick  Значения NOT NULL - код ошибки 60000
   -- -----------------------------------------------------------------------------------------------
   --  2019-05-13 Nick  Ядро версия 2.0
   -- ===============================================================================================
 
  DECLARE 
    c_ERR_FUNC_NAME public.t_sysname = 'obj_p_codifier_u';
    c_MESS00        public.t_str1024 = 'Запись в кодификаторе успешно обновлена. Код мог быть изменён';
    
    rsp_main     public.result_long_t; 
    	
    _codif_code  public.t_str60  := utl.com_f_empty_string_to_null (upper(btrim (p_code)));   -- Код                                                          
    _codif_name  public.t_str250 := utl.com_f_empty_string_to_null (btrim (p_name));          -- Наименование                                        
    --
    _exception   public.exception_type_t;
    _err_args    public.t_arr_text := ARRAY [''];
    --   
  BEGIN
    IF ( p_id IS NULL ) THEN       
			RAISE SQLSTATE '60000'; -- NULL значения запрещены Nick 2015-10-01
	END IF;
    --
    UPDATE ONLY com.obj_codifier
		SET  
             parent_codif_id  = COALESCE (p_parent,     parent_codif_id)
            ,codif_code       = COALESCE (_codif_code,  codif_code) 
            ,codif_name       = COALESCE (_codif_name,  codif_name)
            ,small_code       = COALESCE (p_scode,      small_code) 
            ,codif_uuid       = COALESCE (p_codif_uuid, codif_uuid)
    WHERE (codif_id = p_id);

  	IF FOUND THEN 
		  rsp_main := ( p_id, c_MESS00 );
       ELSE 
           _err_args [1] := p_id::text;
           RAISE SQLSTATE '61040';
  	END IF;
   
   	RETURN rsp_main;
   
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
 $$;

COMMENT ON FUNCTION com_codifier.obj_p_codifier_u ( public.id_t, public.id_t, public.t_str60, public.t_str250, public.t_code1, public.t_guid) 
   IS '79: Обновление экземпляра кодификатора. Аргумент ID записи
     Аргументы:
                   p_id          public.id_t            -- ID записи аргумент NULL запрещается.
                  ,p_parent      public.id_t     = NULL -- ID родителя,       если NULL - сохраняется старое значение 
                  ,p_code        public.t_str60  = NULL -- Код,               если NULL - сохраняется старое значение 
                  ,p_name        public.t_str250 = NULL -- Наименоваие,       если NULL - сохраняется старое значение
                  ,p_scode       public.t_code1  = NULL -- Краткий код,       если NULL - сохраняется старое значение
                  ,p_codif_uuid  public.t_guid   = NULL -- UUID кодификатора, если NULL - сохраняется старое значение

     Выходные величины:
				 rsp_main.rc = nn - процедура завершилась успешно
				 rsp_main.rc = -1 - процедура завершилась с ошибкой
             --
             rsp_main.errm = <Сообщение>
 ';
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- ПРИМЕРЫ ВЫПОЛНЕНИЯ:
---
--- SELECT * FROM com.com_f_obj_codifier_s_sys ('C_ATTR_TYPE') WHERE ( codif_id IN (22, 23));
--- SELECT * FROM com.obj_p_codifier_u (22, NULL, 'T_STR2048', NULL, NULL, '2015-05-30 18:32:01' );	
-- SELECT * FROM com.obj_p_codifier_u (23, NULL, 'T_DESCRIPTION', NULL, NULL, '2015-05-30 18:32:01' );
--- SELECT * FROM com.obj_p_codifier_u (22, NULL, 'X_CODE', NULL );		
--- SELECT * FROM com.obj_p_codifier_u (22, 2, 'X_CODE1', 'Засравочник', 'Z' );    
--- SELECT * FROM com.obj_p_codifier_u (2222, 2, 'X_CODE1', 'Засравочник', 'Z' );   --  Нет ничего
-- SELECT * FROM com.obj_p_codifier_u (22, 2222, 'X_CODE1', 'Засравочник', 'Z' ); 
-- SELECT * FROM com.obj_p_codifier_u (22, 3, 'X_CODE1', 'Засравочник', 'Z' ); 

-- Контрольный запрос:
--  SELECT * FROM com.com_f_obj_codifier_s_sys();
