-- ================================================================== 
--  Author:		 Nick 
--  Create date: 2016-09-18
--  Description:	Маршрут от текущего элемента кодификатора до корня.
/* -- =============================================================== 
	Входные параметры
	              p_codif_id  public.id_t  - ID элемента
   ------------------------------------------------------------------ 
	Выходные параметры
			        Маршрут до корня  public.t_arr_id
   -- =============================================================== */
SET search_path=com,public,pg_catalog;

DROP FUNCTION IF EXISTS com.com_f_obj_codifier_path_get_get ( public.id_t );
CREATE OR REPLACE FUNCTION com.com_f_obj_codifier_path_get_get ( p_codif_id  public.id_t )
  RETURNS public.t_arr_id   
AS
 $$
   BEGIN
       RETURN ( WITH RECURSIVE cd_u (   parent_codif_id
                                       ,tree_d
                                       ,cicle_d
                                 ) AS ( SELECT 
                                           c.parent_codif_id  
                                         , CAST ( ARRAY [c.codif_id] AS t_arr_id ) 
                                         , FALSE
                                        FROM ONLY com.obj_codifier c
                                            WHERE ( c.codif_id = p_codif_id )                 
                                         UNION ALL
                 
                                        SELECT 
                                           c.parent_codif_id  
                                         , CAST (  d.tree_d || c.codif_id AS t_arr_id )
                                         , c.codif_id = ANY ( d.tree_d )
                                        FROM ONLY com.obj_codifier c 
                                         INNER JOIN cd_u d ON ( d.parent_codif_id  = c.codif_id ) AND ( NOT cicle_d )
                                   )
                                     SELECT  
                                            array_agg (su.parent_codif_id::BIGINT)  
                                      FROM cd_u su  WHERE ( su.parent_codif_id IS NOT NULL )
              );
   END;
 $$
    STABLE  -- Пока, потому, что использую SET
    SECURITY INVOKER -- 2015-04-05 Nick
    LANGUAGE plpgsql;

COMMENT ON FUNCTION com.com_f_obj_codifier_path_get_get ( public.id_t ) IS '3854. Маршрут от текущего элемента кодификатора до корня.
	Входные параметры
	              p_codif_id  public.id_t  - ID элемента кодификатора
   ------------------------------------------------------------------ 
	Выходные параметры
			        Маршрут до корня  public.t_arr_id
 ';
-- ----------------------------------------------------------------------
-- '{C_DOC_TYPE2,C_DOC_TYPE,C_CODIF_ROOT}'
-- SELECT * FROM com.com_f_obj_codifier_s_sys ('C_DOC_TYPE');
-- 227|226|'0'|'C_DOC_TYPE91'|'Рекламации'
-- ---------------------------------------------------------
-- SELECT * FROM com.com_f_obj_codifier_path_get_get ( 'C_DOC_TYPE91'); 
-- '{C_DOC_TYPE9,C_DOC_TYPE,C_CODIF_ROOT}'
-- SELECT * FROM com.com_f_obj_codifier_path_get_get ( 227); 
-- '{226,95,1}'
