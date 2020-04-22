DROP FUNCTION IF EXISTS com_codifier.obj_p_codifier_d ( public.t_str60 );
CREATE OR REPLACE FUNCTION com_codifier.obj_p_codifier_d ( p_codif_code public.t_str60 )

  RETURNS  public.result_t
   SET search_path = com_codifier, com_error, com, public, pg_catalog
   SECURITY DEFINER 
   LANGUAGE plpgsql AS 

$$
-- =====================================================================================
-- Author:	SVETA
-- Create date: 2013-08-14
-- Description:	Удаление записи в кодификаторе
-- 2015-04-05  SECURITY DEFINER 
-- 2015-07-20 Gregory «FROM com.obj_codifier» изменено на «FROM ONLY com.obj_codifier»
-- 2019-06-09 Nick Новое ядро.
-- =====================================================================================
 DECLARE 
  с_ERR_FUNC_NAME  public.t_sysname := 'obj_p_codifier_d';
  c_MESS00         public.t_str1024 := 'Запись успешно удалена';

  _codif_id  public.id_t;

  rsp_main    public.result_t; 
  _exception  public.exception_type_t;
  _err_args   public.t_arr_text := ARRAY [''];
    
 BEGIN
    IF ( p_codif_code IS NULL) 
       THEN
       RAISE SQLSTATE '60000'; -- NULL значения запрещены
    END IF;

    _codif_id := com_codifier.com_f_obj_codifier_get_id (utl.com_f_empty_string_to_null (upper(btrim (p_codif_code))));

    DELETE FROM ONLY com.obj_codifier WHERE ( codif_id = _codif_id );
    IF FOUND THEN
          rsp_main := ( _codif_id, c_MESS00 );
		ELSE
		     _err_args [1] := p_codif_code;  
		     RAISE SQLSTATE '61011';
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
             ,_exception.context         := PG_EXCEPTION_CONTEXT;         -- 

             _exception.func_name := с_ERR_FUNC_NAME; 
		
	   rsp_main := (-1, (com_error.f_error_handling (_exception, _err_args)));
			
	   RETURN rsp_main;			
	 END;
 END;
$$;

COMMENT ON FUNCTION com_codifier.obj_p_codifier_d ( public.t_str60 ) 
   IS '65: Удаление записи в кодификаторе, аргумент Код записи.';

---
--- SELECT * FROM com_codifier.com_f_obj_codifier_s_sys ();
--- SELECT * FROM com_codifier.obj_p_codifier_d ('C_E_COPY_TYPE');	
--- SELECT * FROM com.obj_p_codifier_d ('C_NSO_RBR');	
--- SELECT * FROM com.obj_p_codifier_d ('C_ATTR_TYPE');   -- У него есть дети
--- SELECT * FROM com.obj_p_codifier_d ('sssssss'); --  Нет ничего
--- SELECT * FROM com.obj_p_codifier_d (NULL); --  Нет ничего

