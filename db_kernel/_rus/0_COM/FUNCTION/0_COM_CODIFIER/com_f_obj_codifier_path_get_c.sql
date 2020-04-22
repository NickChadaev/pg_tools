-- ================================================================== 
--  Author:		 Nick 
--  Create date: 2016-09-18
--  Description:	Маршрут от текущего элемента кодификатора до корня.
/* -- =============================================================== 
	Входные параметры
	              p_codif_code  public.t_str60  - код элемента
   ------------------------------------------------------------------ 
	Выходные параметры
			        Маршрут до корня  public.t_arr_code
   -- =============================================================== */
SET search_path=com,public,pg_catalog;

DROP FUNCTION IF EXISTS com.com_f_obj_codifier_path_get_get ( public.t_str60 );
CREATE OR REPLACE FUNCTION com.com_f_obj_codifier_path_get_get ( p_codif_code  public.t_str60 )
  RETURNS public.t_arr_code   
AS
 $$
   BEGIN
       RETURN ( WITH RECURSIVE cd_u (   parent_codif_code
                                       ,parent_codif_id
                                       ,tree_d
                                       ,cicle_d
                                 ) AS ( SELECT 
                                           b.codif_code
                                         , c.parent_codif_id  
                                         , CAST ( ARRAY [c.codif_id] AS t_arr_id ) 
                                         , FALSE
                                        FROM ONLY com.obj_codifier c, ONLY com.obj_codifier b
                                           WHERE ( c.parent_codif_id = b.codif_id ) 
                                             AND ( c.codif_code = btrim(upper(p_codif_code)) )
                 
                                         UNION ALL
                 
                                        SELECT 
                                           l.codif_code
                                         , c.parent_codif_id  
                                         , CAST (  d.tree_d || c.codif_id AS t_arr_id )
                                         , c.codif_id = ANY ( d.tree_d )
                                        FROM ONLY com.obj_codifier c 
                                         INNER JOIN cd_u d ON ( d.parent_codif_id  = c.codif_id ) AND ( NOT cicle_d )
                                         INNER JOIN ONLY com.obj_codifier l ON ( c.parent_codif_id = l.codif_id )
                                   )
                                     SELECT  
                                            array_agg (su.parent_codif_code::VARCHAR(60))  
                                      FROM cd_u su  
              );
   END;
 $$
    STABLE  -- Пока, потому, что использую SET
    SECURITY INVOKER -- 2015-04-05 Nick
    LANGUAGE plpgsql;

COMMENT ON FUNCTION com.com_f_obj_codifier_path_get_get ( public.t_str60 ) IS '3854. Маршрут от текущего элемента кодификатора до корня.
	Входные параметры
	              p_codif_code  public.t_str60  - код элемента
   ---------------------------------------------------------------- 
	Выходные параметры
			        Маршрут до корня  public.t_arr_code
 ';
-- ----------------------------------------------------------------------
-- SELECT * FROM com.com_f_obj_codifier_path_get_get ( 'C_doc_type22' ); 
-- '{C_DOC_TYPE2,C_DOC_TYPE,C_CODIF_ROOT}'
