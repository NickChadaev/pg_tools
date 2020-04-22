/* --------------------------------------------------------------------------------
	Входные параметры:
	p_codif_code_parent public.t_str60			, -- Код родительского элемента
	p_codif_code_child public.t_str60	DEFAULT NULL	  -- Код дочернего элемента
	
    Выходные параметры:
	codif_id		public.id_t,		-- Идентификатор кодификатора
	parent_codif_id		public.id_t,		-- Идентификатор родительского элемента
	small_code		public.t_code1,		-- Краткий код
	codif_code		public.t_str60,		-- Тип электронной копии
	codif_name		public.t_str250		-- Наименование
	
    Особенности:
	Отображаются только ближайшие потомки на один уровень вниз,
	В случае, если явно указан "Идентификатор дочернего элемента",
	отображается только одна строка.
----------------------------------------------------------------*/

DROP FUNCTION IF EXISTS com_codifier.com_f_obj_codifier_s (public.t_str60, public.id_t);
CREATE OR REPLACE FUNCTION com_codifier.com_f_obj_codifier_s ( 
                              p_codif_code_parent public.t_str60
                            , p_codif_id_child    public.id_t  
 )                            
  RETURNS TABLE (
                  codif_id        public.id_t        -- ID экземпляра кодификатора 
                 ,parent_codif_id public.id_t        -- ID родительского экземпляра
                 ,small_code      public.t_code1     -- Краткий код 
                 ,codif_code      public.t_str60     -- Код 
                 ,codif_name      public.t_str250    -- Наименование
                 ,qty_d           public.t_int       -- Количество прямых потомков
                 ,is_node_d       public.t_boolean   -- Признак узла
	) AS
$$
	/* ========================================================================== */
	/* DBMS name:     PostgreSQL 8                                                */
	/* Created on:    23.05.2015 10:00:00                                         */
	/* Модификация:   2015-05-25                                                  */
	/*  Отображение ветки кодификатора по коду родительского элемента Роман       */
	/* 2018-07-12 Nick  qty_d      public.t_int     -- количество прямых потомков */
	/*                 ,is_node_d  public.t_boolean -- признак узла               */
	/* 2019-06-11 Nick  Модификация под новое ядро                                */
	/* ========================================================================== */
 DECLARE
   _codif_code_parent public.t_str60 := utl.com_f_empty_string_to_null (btrim (upper (p_codif_code_parent)));

 BEGIN
    RETURN QUERY
      SELECT
          a.codif_id::public.id_t 
         ,a.parent_codif_id::public.id_t
         ,a.small_code
         ,a.codif_code
         ,a.codif_name
         ,(SELECT count(*) FROM ONLY com.obj_codifier x WHERE ( x.parent_codif_id = a.codif_id ))::public.t_int AS qty_d   
         ,(EXISTS (SELECT 1 FROM ONLY com.obj_codifier x WHERE ( x.parent_codif_id = a.codif_id )))::public.t_boolean AS is_node_d
      FROM ONLY com.obj_codifier a 
                 INNER JOIN ONLY com.obj_codifier b ON (b.codif_id = a.parent_codif_id) 
      WHERE ((b.codif_code = _codif_code_parent) AND 
               ((p_codif_id_child IS NULL) OR (p_codif_id_child IS NOT NULL) AND 
                                              (p_codif_id_child = a.codif_id)
               )                 
            );
 END;
$$
  LANGUAGE plpgsql 
  STABLE 
  SET search_path=com_codifier, com, public, pg_catalog
  SECURITY INVOKER;

COMMENT ON FUNCTION com_codifier.com_f_obj_codifier_s (public.t_str60, public.id_t) 
IS '71: Отображение ветки кодификатора на один уровень вниз
 
    Входные параметры:
      1) p_codif_code_parent  public.t_str60			-- Код родительского элемента
      2) p_codif_id_child	  public.id_t	DEFAULT NULL   -- Идентификатор дочернего элемента
	
    Выходные параметры:
      1)  codif_id        public.id_t        -- ID экземпляра кодификатора 
      2) ,parent_codif_id public.id_t        -- ID родительского экземпляра
      3) ,small_code      public.t_code1     -- Краткий код 
      4) ,codif_code      public.t_str60     -- Код 
      5) ,codif_name      public.t_str250    -- Наименование
      6) ,qty_d           public.t_int       -- Количество прямых потомков
      7) ,is_node_d       public.t_boolean   -- Признак узла
	
    Особенности:
	   Отображаются только ближайшие потомки на один уровень вниз,
    	В случае, если явно указан "Код дочернего элемента",тображается только одна строка.
   ----------------------------------------------------------------------------------------
    Использование:
       SELECT * FROM com_codifier.com_f_obj_codifier_s_sys(p_level_d := 2);
       SELECT * FROM com_codifier.com_f_obj_codifier_s (''C_CODIF_ROOT'') ORDER BY 1;
-- ------------------------------------------------------------------------------------------
--   2|1|Y|C_OBJ_TYPE    |Типы объектов                                            | 3|t
--  10|1|0|C_E_COPY_TYPE |Перечень MIME--типов                                     |17|t
--  95|1|0|C_DOC_TYPE    |Перечень видов/типов документов                          |10|t
-- 139|1|0|C_OBJECT_LINK |Типы связей между объектами                              |16|t
-- 160|1|r|C_IND_TYPE    |Типы показателей                                         |24|t
-- 182|1|0|C_EXEC_TYPE   |Типизация исполнения                                     | 2|t
-- 201|1|0|C_AUTH_CONST  |Список констант для схемы AUTH                           | 4|t
-- 233|1|0|C_ACTION_TYPE |Перечень типов действий                                  |60|t
-- 459|1|0|C_ACCOUNT_TYPE|Типы счетов                                              | 3|t
-- 464|1|0|C_APP_ROLE    |Прикладная роль                                          | 1|t
-- -------------------------------------------------------------------------------------------
      SELECT * FROM com_codifier.com_f_obj_codifier_s_sys(''C_ATTR_TYPE'');
      SELECT * FROM com_codifier.com_f_obj_codifier_s (''C_ATTR_TYPE'');
      SELECT * FROM com_codifier.com_f_obj_codifier_s (''C_CODIF_ROOT'',233);
      SELECT * FROM com_codifier.com_f_obj_codifier_s (NULL); 
  ';
--
-- Использование:
--     SELECT * FROM com_codifier.com_f_obj_codifier_s_sys();
--     SELECT * FROM com_codifier.com_f_obj_codifier_s ( 'C_CODIF_ROOT' );
--     SELECT * FROM com_codifier.com_f_obj_codifier_s_sys('C_ATTR_TYPE');
--     SELECT * FROM com_codifier.com_f_obj_codifier_s ('C_ATTR_TYPE');
--     SELECT * FROM com_codifier.com_f_obj_codifier_s ('C_ATTR_TYPE', 41::public.id_t);
--     SELECT * FROM com_codifier.com_f_obj_codifier_s (NULL); 
