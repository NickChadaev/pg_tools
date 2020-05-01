--  ===================================================================================================================
--  Author: Gregory
--  Create date: 2017-12-26
--  Description: Отображение списка процедур
--  2018-01-17 Gregory добавлен proc_info (первая строка из комментария)
--  2019-03-01 Nick Переход на pg 11.1  
--  ===================================================================================================================
/*  -------------------------------------------------------------------------------------------------------------------
    Входные параметры:
        1) p_nsp_name_list   public.t_text  -- Список схем ( NULL / '[NOT] public, db_info' / 'com, nso' )
                DEFAULT 'NOT pg_catalog, information_schema, public, db_info'
        2) p_proc_name_like  public.t_text  -- Фрагменты наименования процедуры ( NULL / '[NOT] _p_' / '_f_, _sys' )
                DEFAULT NULL
        3) p_proc_type_list  public.t_text  -- Список типов процедур ( NULL / '[NOT] agg, trigger, window' / 'normal' )
                DEFAULT 'normal'
        4) p_proc_lang_list  public.t_text  -- Список языков ( NULL / '[NOT] internal, c' / 'sql, plpgsql' )
                DEFAULT 'sql, plpgsql'
 
    Выходные параметры:
        1) proc_oid   oid               -- OID процедуры
        2) proc_type  public.t_sysname  -- Тип процедуры
        3) proc_lang  public.t_sysname  -- Язык процедуры
        4) nsp_name   public.t_sysname  -- Наименование схемы
        5) proc_name  public.t_sysname  -- Наименование процедуры
        6) args_line  public.t_text     -- Строка аргументов
        7) proc_info  public.t_text     -- Описание процедуры
    ---------------------------------------------------------------------------------------------------------------- */
SET search_path = db_info, public, pg_catalog;

DROP FUNCTION IF EXISTS db_info.f_show_proc_list ( public.t_text, public.t_text, public.t_text, public.t_text );
CREATE OR REPLACE FUNCTION db_info.f_show_proc_list
(
        p_nsp_name_list   public.t_text  -- Список схем ( NULL / '[NOT] public, db_info' / 'com, nso' )
                DEFAULT 'NOT pg_catalog, information_schema, public, db_info'
       ,p_proc_name_like  public.t_text  -- Фрагменты наименования процедуры ( NULL / '[NOT] _p_' / '_f_, _sys' )
                DEFAULT NULL
       ,p_proc_type_list  public.t_text  -- Список типов процедур ( NULL / '[NOT] agg, trigger, window' / 'normal' )
                DEFAULT 'normal'
       ,p_proc_lang_list  public.t_text  -- Список языков ( NULL / '[NOT] internal, c' / 'sql, plpgsql' )
                DEFAULT 'sql, plpgsql'
)
RETURNS TABLE (
        proc_oid   oid               -- OID процедуры
       ,proc_type  public.t_sysname  -- Тип процедуры
       ,proc_lang  public.t_sysname  -- Язык процедуры
       ,nsp_name   public.t_sysname  -- Наименование схемы
       ,proc_name  public.t_sysname  -- Наименование процедуры
       ,args_line  public.t_text     -- Строка аргументов
       ,proc_info  public.t_text     -- Описание процедуры
)
AS
$$
  DECLARE
        _nsp_arr    public.t_arr_text := string_to_array(regexp_replace(p_nsp_name_list, 'not|[\r\n\s]?', '', 'ig'), ',');
        _nsp_not    public.t_boolean  := EXISTS (SELECT regexp_matches(p_nsp_name_list, '(not)', 'i'));
        _name_parts public.t_text := '%' || replace(replace(regexp_replace(p_proc_name_like, 'not|[\r\n\s]?', '', 'ig'), ',', '%'), '_', '\_') || '%';
        _name_not   public.t_boolean  := EXISTS (SELECT regexp_matches(p_proc_name_like, '(not)', 'i'));
        _type_arr   public.t_arr_text := string_to_array(regexp_replace(p_proc_type_list, 'not|[\r\n\s]?', '', 'ig'), ',');
        _type_not   public.t_boolean  := EXISTS (SELECT regexp_matches(p_proc_type_list, '(not)', 'i'));
        _lang_arr   public.t_arr_text := string_to_array(regexp_replace(p_proc_lang_list, 'not|[\r\n\s]?', '', 'ig'), ',');
        _lang_not   public.t_boolean  := EXISTS (SELECT regexp_matches(p_proc_lang_list, '(not)', 'i'));
BEGIN
        RETURN QUERY
        SELECT
                p.oid
               ,t.protype
               ,l.lanname::public.t_sysname
               ,n.nspname::public.t_sysname
               ,p.proname::public.t_sysname
               ,('( ' || pg_get_function_arguments (p.oid)::public.t_text || ' )')::public.t_text
               ,substring (description, '([^\r\n]*)')::public.t_text
        FROM pg_proc p
          JOIN pg_namespace n ON n.oid = p.pronamespace
          JOIN pg_language  l ON l.oid = p.prolang
          LEFT JOIN pg_description d ON d.objoid = p.oid
        JOIN LATERAL ( SELECT  
                         -- Nick 2019-03-01   
                         CASE
--                            WHEN p.proisagg THEN 'agg'
--                            WHEN p.proiswindow THEN 'window'
                            WHEN p.prorettype = 'trigger'::regtype THEN 'trigger'
                             ELSE 'normal'
                         END::public.t_sysname AS protype
                         -- Nick 2019-03-01
        ) AS t
        ON TRUE
        WHERE
                (
                        _nsp_arr IS NULL
                     OR (
                                _nsp_arr IS NOT NULL
                            AND (
                                        (
                                                _nsp_not IS FALSE
                                            AND n.nspname = ANY(_nsp_arr)
                                        )
                                     OR (
                                                _nsp_not IS TRUE
                                            AND n.nspname != ALL(_nsp_arr)
                                        )
                                )
                                
                        )
                )
            AND (
                        _name_parts IS NULL
                     OR (
                                _name_parts IS NOT NULL
                            AND (
                                        (
                                                _name_not IS FALSE
                                            AND p.proname ILIKE _name_parts
                                        )
                                     OR (
                                                _name_not IS TRUE
                                            AND p.proname NOT ILIKE _name_parts
                                        )
                                )
                                
                        )
                )
            AND (
                        _type_arr IS NULL
                     OR (
                                _type_arr IS NOT NULL
                            AND (
                                        (
                                                _type_not IS FALSE
                                            AND protype = ANY(_type_arr)
                                        )
                                     OR (
                                                _type_not IS TRUE
                                            AND protype != ALL(_type_arr)
                                        )
                                )
                                
                        )
                )
            AND (
                        _lang_arr IS NULL
                     OR (
                                _lang_arr IS NOT NULL
                            AND (
                                        (
                                                _lang_not IS FALSE
                                            AND l.lanname = ANY(_lang_arr)
                                        )
                                     OR (
                                                _lang_not IS TRUE
                                            AND l.lanname != ALL(_lang_arr)
                                        )
                                )
                                
                        )
                )
        ORDER BY
                n.nspname
               ,p.proname;
  END;
$$
   SET search_path = db_info, public, pg_catalog
   SECURITY DEFINER
   LANGUAGE plpgsql;

COMMENT ON FUNCTION db_info.f_show_proc_list (public.t_text, public.t_text, public.t_text, public.t_text)
IS '24dbg/7955/646: Отображение списка процедур.
    Входные параметры:
        1) p_nsp_name_list   public.t_text  -- Список схем ( NULL / ''[NOT] public, db_info'' / ''com, nso'' )
                DEFAULT ''NOT pg_catalog, information_schema, public, db_info''
        2) p_proc_name_like  public.t_text  -- Фрагменты наименования процедуры ( NULL / ''[NOT] _p_'' / ''_f_, _sys'' )
                DEFAULT NULL
        3) p_proc_type_list  public.t_text  -- Список типов процедур ( NULL / ''[NOT] agg, trigger, window'' / ''normal'' )
                DEFAULT ''normal''
        4) p_proc_lang_list  public.t_text  -- Список языков ( NULL / ''[NOT] internal, c'' / ''sql, plpgsql'' )
                DEFAULT ''sql, plpgsql''
 
    Выходные параметры:
        1) proc_oid   oid               -- OID процедуры
        2) proc_type  public.t_sysname  -- Тип процедуры
        3) proc_lang  public.t_sysname  -- Язык процедуры
        4) nsp_name   public.t_sysname  -- Наименование схемы
        5) proc_name  public.t_sysname  -- Наименование процедуры
        6) args_line  public.t_text     -- Строка аргументов
        7) proc_info  public.t_text     -- Описание процедуры';

-- SELECT * FROM db_info.f_show_proc_list();
-- SELECT * FROM db_info.f_show_proc_list('nso, com');
-- SELECT * FROM db_info.f_show_proc_list('nso, com', 'search, 2');
-- SELECT * FROM db_info.f_show_proc_list('nso, com', 'NOT _f_, _sys');
-- SELECT * FROM db_info.f_show_proc_list('nso, com', '_f_, _sys');
-- SELECT * FROM db_info.f_show_proc_list('nso, com', 'column');
-- SELECT * FROM db_info.f_show_proc_list(NULL, 'NOT _f_');
-- SELECT * FROM db_info.f_show_proc_list(p_proc_name_like := 'obj');
-- SELECT * FROM db_info.f_show_proc_list(p_proc_name_like := '_p_,_i');
-- SELECT * FROM db_info.f_show_proc_list('nso, com', NULL, 'trigger');
-- SELECT * FROM db_info.f_show_proc_list('nso, com', NULL, 'not normal');
-- SELECT * FROM db_info.f_show_proc_list('nso, com', NULL, NULL, 'sql');
-- SELECT * FROM db_info.f_show_proc_list(NULL, NULL, NULL, 'sql');
-- SELECT * FROM db_info.f_show_proc_list(p_proc_lang_list := 'sql');
-- SELECT * FROM db_info.f_show_proc_list('nso, com', NULL, NULL, 'NOT plpgsql');
