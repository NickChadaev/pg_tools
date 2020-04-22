/*-------------------------------------------------------------------------- 
  Описание  f_table_get_live_tuples
  Получение актуального размера таблицы/представления.
  Раздел или область применения:	Сервис
    
  История:
   	 Дата: 2016-04-11 NIck
  -- ----------------------------------------------------------------------- 
*/
SET search_path=db_info, public, pg_catalog;

DROP FUNCTION IF EXISTS f_table_get_live_tuples ( public.t_sysname, public.t_sysname );
CREATE OR REPLACE FUNCTION f_table_get_live_tuples  
	 (
	   p_schema_name  public.t_sysname = NULL -- Наименование схемы    
          ,p_object_name  public.t_sysname = NULL -- Наименование таблицы
	 ) 
RETURNS public.t_int
AS
   $$
        DECLARE 
           _count    public.t_int;
           
	BEGIN
              EXECUTE 'SELECT count(*) FROM ONLY ' || (lower(btrim(p_schema_name)) || '.' || lower(btrim(p_object_name)))::regclass INTO _count;
	      RETURN _count;  
   END;
	$$
          STABLE            
          SECURITY DEFINER
          LANGUAGE plpgsql;

COMMENT ON FUNCTION f_table_get_live_tuples ( public.t_sysname, public.t_sysname ) IS '2627: Получить актуальный размер таблицы
  Раздел или область применения: Сервис
  Входные параметры:
         p_schema_name    public.t_sysname  -- Наименование схемы
        ,p_object_name    public.t_sysname  -- Наименование таблицы   

  Выходные параметры:  <Размер таблицы в строках> public.t_int;
             Пример использования: 
                      SELECT db_info.f_table_get_live_tuples ( ''exn'', ''exn_object_1'');
                       -- 
                      SELECT schema_name, obj_name, db_info.f_table_get_live_tuples ( schema_name, obj_name) 
                                FROM db_info.f_show_tbv_descr ();  
';
-- SELECT db_info.f_table_get_live_tuples ( 'exn', 'exn_object_1');
-- SELECT db_info.f_table_get_live_tuples ( 'app', 'app_appendix');
-- SELECT count(*) from app.app_f_appendix_1_s(); -- 86