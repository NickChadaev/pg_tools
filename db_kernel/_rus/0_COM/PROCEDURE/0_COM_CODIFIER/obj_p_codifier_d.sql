DROP FUNCTION IF EXISTS com_codifier.obj_p_codifier_d (public.id_t);
CREATE OR REPLACE FUNCTION com_codifier.obj_p_codifier_d (p_id  public.id_t)

  RETURNS  public.result_t
   SET search_path = com_codifier, com_error, com, public, pg_catalog
   SECURITY DEFINER
   LANGUAGE plpgsql AS 

$$
       -- ====================================================================================
       -- Author:	SVETA
       -- Create date: 2013-08-14
       -- Description:	Удаление записи в кодификаторе
       -- 2015-04-05  SECURITY DEFINER  
       -- 2015-07-20  Gregory «FROM com.OBJ_CODIFIER» изменено на «FROM ONLY com.OBJ_CODIFIER»
       -- 2019-06-09 Nick Новое ядро.
       -- ====================================================================================
 DECLARE 
  с_ERR_FUNC_NAME  public.t_sysname = 'obj_p_codifier_d';
  c_MESS00         public.t_str1024 = 'Запись успешно удалена';
    --
  rsp_main    public.result_t; 
  _exception  public.exception_type_t;
  _err_args   public.t_arr_text := ARRAY [''];
  
 BEGIN
	 IF ( p_id IS NULL) 
	  THEN
			RAISE SQLSTATE '60000'; -- NULL значения запрещены
	 END IF;

    DELETE FROM ONLY com.obj_codifier WHERE ( codif_id = p_id );
	 IF FOUND THEN
          rsp_main := ( p_id, c_MESS00 );
		ELSE
		     _err_args [1] := p_id::text;  
		     RAISE SQLSTATE '61012';
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

COMMENT ON FUNCTION com_codifier.obj_p_codifier_d (public.id_t) 
       IS '65: Удаление записи в кодификаторе, аргумент ID записи.';
--- ----------------------------------------------------------------------
--- SELECT * FROM com_codifier.com_f_obj_codifier_s_sys ();
--- SELECT * FROM com_codifier.obj_p_codifier_d (351::bigint);	
-- -----------------------------------------------------------------------
-- -1|'Невозможно удаление родительского элемента
-- 	Детали: Key (codif_id)=(35) is still referenced from table "obj_codifier".
-- 	Контекст: SQL statement "DELETE FROM ONLY com.obj_codifier WHERE ( codif_id = p_id )"
--                   PL/pgSQL function obj_p_codifier_d(id_t) line 22 at SQL statement'
-- ------------------------------------------------------------------
-- NOTICE:  (23503
--             ,com
--             ,obj_p_codifier_d
--             ,obj_codifier
--             ,fk_obj_codifier_grouping_obj_codifier
--             ,""
--             ,""
--             ,"update or delete on table ""obj_codifier"" violates foreign key constraint ""fk_obj_codifier_grouping_obj_codifier"" on table ""obj_codifier"""
--             ,"Key (codif_id)=(35) is still referenced from table ""obj_codifier""."
--             ,""
--             ,"SQL statement ""DELETE FROM ONLY com.obj_codifier WHERE ( codif_id = p_id )""
-- 
-- PL/pgSQL function obj_p_codifier_d(id_t) line 22 at SQL statement")
-- Total query runtime: 62 msec
-- 1 строка получена.
-- 
-- select * from com.sys_errors where (err_code = '23503');
