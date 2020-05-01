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
	BEGIN
	 RETURN ( SELECT pg_stat_get_live_tuples (c.oid) AS live_tuples 
              FROM pg_namespace n 
                 JOIN pg_class c ON n.oid = c.relnamespace
              WHERE (
                          ( n.nspname <> 'information_schema' )
                      AND ( n.nspname <> 'pg_catalog' )
                      AND ( n.nspname NOT LIKE 'pg_temp%' ) 
                      AND ( n.nspname = btrim ( lower ( p_schema_name ))) 
                      AND ( c.relkind = 'r' )  
                      AND ( c.relname = btrim ( lower ( p_object_name ))) 
              )
           );  
   END;
	$$
          STABLE            
          SECURITY DEFINER
          LANGUAGE plpgsql;

COMMENT ON FUNCTION f_table_get_live_tuples ( public.t_sysname, public.t_sysname ) IS '2614: Получить актуальный размер таблицы
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
