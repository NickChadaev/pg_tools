/*
       Аргументы:   
                   p_code    t_str60           -- Код, аргумент NULL запрещается.
				  ,p_parent  t_str60   = NULL  -- Код родителя, если NULL - сохраняется старое значение 
				  ,p_name    t_str250  = NULL  -- Наименоваие,  если NULL - сохраняется старое значение
                  ,p_scode   t_code1   = NULL  -- Краткий код,  если NULL - сохраняется старое значение
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

DROP FUNCTION IF EXISTS com_codifier.obj_p_codifier_u (public.t_str60, public.t_str60, public.t_str250, public.t_code1, public.t_guid);
CREATE OR REPLACE FUNCTION com_codifier.obj_p_codifier_u (
				   p_code        public.t_str60         -- Код, аргумент NULL запрещается.
				  ,p_parent      public.t_str60  = NULL -- Код родителя, если NULL - сохраняется старое значение 
				  ,p_name        public.t_str250 = NULL -- Наименоваие,  если NULL - сохраняется старое значение
                  ,p_scode       public.t_code1  = NULL -- Краткий код,  если NULL - сохраняется старое значение
                  ,p_codif_uuid  public.t_guid   = NULL -- UUID кодификатора, если NULL - сохраняется старое значение
)
     RETURNS public.result_long_t
     SECURITY DEFINER -- 2015-04-05
     LANGUAGE plpgsql 
     SET search_path = com_codifier,com_error, com, public, pg_catalog   
  AS 
$$
  -- ====================================================================================================
  -- Author:	SVETA
  -- Create date: 2013-08-14
  -- Description:	Обновление  записи в кодификаторе
  --  2015-05-30 Добавлены UUID и диапазон актуальности.
  -- 2015-07-20 Gregory «FROM com.obj_codifier» и
  -- «UPDATE com.OBJ_CODIFIER» изменено на «FROM ONLY com.obj_codifier» и «UPDATE ONLY com.OBJ_CODIFIER»
  -- 
  -- ----------------------------------------------------------------------------------------------------
  --  2015-10-01  Nick   Значения NOT NULL - код ошибки 60000
  -- ----------------------------------------------------------------------------------------------------
  --  2019-05-13 Nick  Ядро версия 2.0
  -- ====================================================================================================
 DECLARE 
   c_ERR_FUNC_NAME   public.t_sysname = 'obj_p_codifier_u';
   c_MESS00          public.t_str1024 = 'Запись успешно обновлена.';
   
   rsp_main          public.result_long_t;

   _parent_codif_id  public.id_t;
   _codif_id         public.id_t; 
   	
   _codif_code    public.t_str60  := utl.com_f_empty_string_to_null (upper(btrim (p_code))); 
   _parent_code   public.t_str60  := utl.com_f_empty_string_to_null (upper(btrim (p_parent))); 
   _codif_name    public.t_str250 := utl.com_f_empty_string_to_null (btrim (p_name));
    --
   _exception   public.exception_type_t;
   _err_args    public.t_arr_text := ARRAY [''];
   
  BEGIN
      IF ( p_code IS NULL ) THEN       
     	 RAISE SQLSTATE '60000'; -- NULL значения запрещены Nick 2015-10-01
      END IF;
      --
      IF ( _parent_code IS NOT NULL ) THEN
           _parent_codif_id := com_codifier.com_f_obj_codifier_get_id (_parent_code);
           IF (_parent_codif_id IS NULL) 
             THEN
                _err_args [1] := _parent_code;
                RAISE SQLSTATE '61051';
           END IF;
      END IF;
      
      _codif_id := com_codifier.com_f_obj_codifier_get_id (_codif_code);
      UPDATE ONLY com.obj_codifier
        SET  
        	   parent_codif_id = COALESCE ( _parent_codif_id, parent_codif_id )  
        	  ,codif_name      = COALESCE ( _codif_name,      codif_name )
              ,small_code      = COALESCE ( p_scode,          small_code )
              ,codif_uuid      = COALESCE ( p_codif_uuid,     codif_uuid )
      WHERE codif_id = _codif_id;
  
  		IF FOUND THEN 
  		  rsp_main := ( _codif_id, c_MESS00 );
   		    ELSE 
                _err_args [1] := _codif_code::text;
                RAISE SQLSTATE '61041';
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

COMMENT ON FUNCTION com_codifier.obj_p_codifier_u (public.t_str60, public.t_str60, public.t_str250, public.t_code1, public.t_guid) 
   IS '79: Обновление экземпляра кодификатора. Аргумент код записи
       Аргументы:   
          p_code        public.t_str60         -- Код, аргумент NULL запрещается.
         ,p_parent      public.t_str60  = NULL -- Код родителя,      если NULL - сохраняется старое значение 
         ,p_name        public.t_str250 = NULL -- Наименование,      если NULL - сохраняется старое значение
         ,p_scode       public.t_code1  = NULL -- Краткий код,       если NULL - сохраняется старое значение
              --
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
--- SELECT * FROM com_codifier.com_f_obj_codifier_s_sys ();
--- SELECT * FROM com_codifier.obj_p_codifier_u ( 'C_KEY_TYPE'::public.t_str60, NULL, 'Рубрикатор 1'::public.t_str250);	
--  SELECT * FROM com.com_f_com_log_s();
--  -------------------------------------------------------------------
--  SELECT l.*, c.* FROM com.com_log l, com.obj_codifier c WHERE ( c.id_log = l.id_log ) AND ( l.id_log IN ( 44, 92 )); 
--  SELECT * FROM com.com_v_obj_codifier_log  WHERE ( id_log IN ( 44, 92 ));
--  select * from COM.OBJ_CODIFIER where ( codif_id = 53 );
--  select * from ONLY COM.OBJ_CODIFIER where ( codif_id = 53 );
--  select * from com.obj_codifier_hist ;
--- SELECT * FROM com.obj_p_codifier_u (22, NULL, 'C_NSO_SPR', NULL, NULL);	
--- SELECT * FROM com.obj_p_codifier_u ('22', NULL, 'X_CODE', NULL );		
--- SELECT * FROM com.obj_p_codifier_u ('C_OBJ_TYPE', 'X_CODE1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq==========qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq--------------------qqqqqqqqq', 'Справочник', 'S' );
--- SELECT * FROM com.obj_p_codifier_u ('X_CODE1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq==========qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq--------------------qqqqqqqqq', 'C_OBJ_TYPE', 'Справочник', 'S' );
-- Контрольный запрос:
--  SELECT * FROM com.com_f_obj_codifier_s_sys();
