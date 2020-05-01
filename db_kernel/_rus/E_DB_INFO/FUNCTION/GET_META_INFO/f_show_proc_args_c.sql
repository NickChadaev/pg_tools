-- ====================================================================================================================
-- Author: Gregory
-- Create date: 2016-04-03
-- Description:	Получение описания входных и выходных аргументов процедуры
--  2019-03-01  За основу берётся функция db_info.f_show_proc_args (oid.
-- ====================================================================================================================
/* --------------------------------------------------------------------------------------------------------------------
	Входные параметры:
		1) p_obj_name     public.t_text        -- Имя функции + её сигнатура.
		
	Выходные параметры:
                1) arg_sequ_num   public.small_t       -- Последовательный номер аргумента
                2) arg_parent_num public.small_t       -- Номер родительского аргумента в последовательности
                3) arg_in_out     public.t_code1       -- Входной или выходной аргумент (i - in, o - out, t - table)
                4) arg_name       public.t_sysname     -- Название аргумента
                5) arg_type       public.t_sysname     -- Тип аргумента
                6) base_name      public.t_sysname     -- Имя базового типа
                7) type_category  public.t_code1       -- Категория типа
                8) type_len       public.t_int         -- Длина типа
                9) type_prec      public.t_int         -- Точность поля
               10) arg_default    public.t_description -- Значение по умолчанию
               11) arg_info       public.t_description -- Пользовательское название или описание
-------------------------------------------------------------------------------------------------------------------- */
SET search_path = db_info, public, pg_catalog;

DROP FUNCTION IF EXISTS db_info.f_show_proc_args(varchar);
DROP FUNCTION IF EXISTS db_info.f_show_proc_args(public.t_text);

CREATE OR REPLACE FUNCTION db_info.f_show_proc_args
(
        p_obj_name  public.t_text -- Имя функции + её сигнатура.
)
RETURNS TABLE
(
        arg_sequ_num   public.small_t       -- Последовательный номер аргумента
       ,arg_parent_num public.small_t       -- Номер родительского аргумента в последовательности
       ,arg_in_out     public.t_code1       -- Входной или выходной аргумент (i - in, o - out, t - table)
       ,arg_name       public.t_sysname     -- Название аргумента
       ,arg_type       public.t_sysname     -- Тип аргумента
       ,base_name      public.t_sysname     -- Имя базового типа
       ,type_category  public.t_code1       -- Категория типа
       ,type_len       public.t_int         -- Длина типа
       ,type_prec      public.t_int         -- Точность поля
       ,arg_default    public.t_description -- Значение по умолчанию
       ,arg_info       public.t_description -- Пользовательское название или описание
)
AS
$$
  DECLARE
    _proc_oid oid;
    _obj_name public.t_text := com.com_f_empty_string_to_null (btrim (lower (p_obj_name)));
        
  BEGIN
   SELECT oid FROM pg_proc INTO _proc_oid WHERE (proname = _obj_name) LIMIT 1; 
    --  
   RETURN QUERY
   WITH nums AS (
           WITH RECURSIVE args AS (
                   WITH root AS (
                           WITH pro AS (
                                        SELECT
                                                proname
                                               ,pronargs
                                               ,pronargdefaults
                                               ,prorettype
                                               ,proargtypes
                                               ,proallargtypes
                                               ,proargmodes
                                               ,proargnames
                                               ,proargdefaults
                                        FROM pg_catalog.pg_proc
                                        WHERE oid = _proc_oid
                           )
                           SELECT
                                   argnum
                                  ,0::bigint AS argparent
                                  ,'i' AS argmode
                                  ,argnames.argname
                                  ,argtypes.argtype
                                  ,argdefaults.argdefault
                           FROM (
                                   SELECT
                                           row_number() OVER() AS argnum
                                          ,argtype
                                   FROM
                                           pro
                                          ,unnest(pro.proargtypes) argtype
                           ) argtypes
                           LEFT JOIN (
                                   SELECT
                                           row_number() OVER() AS argnum
                                          ,argname
                                   FROM
                                           pro
                                          ,unnest(pro.proargnames) argname
                           ) argnames
                           USING(argnum)
                           LEFT JOIN (
                                   SELECT
                                           row_number() OVER() + pro.pronargs - pro.pronargdefaults AS argnum
                                          ,argdefault
                                   FROM
                                           pro
                                          ,unnest(string_to_array(pg_get_expr(pro.proargdefaults,0),', ')) argdefault
                           ) argdefaults
                           USING(argnum)

                           UNION

                           SELECT
                                   CASE
                                    WHEN argnum > pro.pronargs THEN argnum + 1
                                    ELSE argnum
                                   END
                                  ,CASE
                                    WHEN argnum > pro.pronargs THEN pro.pronargs + 1
                                    ELSE 0
                                   END
                                  ,argmode
                                  ,argnames.argname
                                  ,argtypes.argtype
                                  ,argdefaults.argdefault
                           FROM
                                   pro
                                  ,(
                                           SELECT
                                                   row_number() OVER() AS argnum
                                                  ,argtype
                                           FROM
                                                   pro
                                                  ,unnest(pro.proallargtypes) argtype
                                   ) argtypes
                           LEFT JOIN (
                                   SELECT
                                           row_number() OVER() AS argnum
                                          ,argmode
                                   FROM
                                           pro
                                          ,unnest(pro.proargmodes) argmode
                           ) argmodes
                           USING(argnum)
                           LEFT JOIN (
                                   SELECT
                                           row_number() OVER() AS argnum
                                          ,argname
                                   FROM
                                           pro
                                          ,unnest(pro.proargnames) argname
                           ) argnames
                           USING(argnum)
                           LEFT JOIN (
                                   SELECT
                                           row_number() OVER() + pro.pronargs - pro.pronargdefaults AS argnum
                                          ,argdefault
                                   FROM
                                           pro
                                          ,unnest(string_to_array(pg_get_expr(pro.proargdefaults,0),', ')) argdefault
                           ) argdefaults
                           USING(argnum)

                           UNION

                           SELECT
                                   pro.pronargs + 1
                                  ,0
                                  ,'o'
                                  ,pro.proname
                                  ,pro.prorettype
                                  ,NULL
                           FROM pro
                           ORDER BY argnum
                   )
                   SELECT
                           argmode
                          ,argname
                          ,argtype
                          ,NULL::integer AS arglength
                          ,argdefault
                          ,CASE
                            WHEN argparent > 0 THEN ARRAY[argparent] || ARRAY[argnum - argparent]
                            ELSE ARRAY[argnum]
                           END AS argtree
                   FROM root

                   UNION ALL

                   SELECT
                           args.argmode
                          ,pcpa.attname
                          ,pcpa.atttypid
                          ,pcpa.atttypmod
                          ,NULL
                          ,args.argtree || ARRAY[pcpa.attnum::bigint]
                   FROM
                           args
                          ,pg_catalog.pg_attribute pcpa
                     JOIN pg_catalog.pg_type pcpt ON pcpa.attrelid = pcpt.typrelid
                   WHERE pcpt.oid = args.argtype
           )
           SELECT
                   row_number() OVER(ORDER BY argtree)::smallint AS argnum
                  ,argtree
                  ,argmode
                  ,argname
                  ,format_type(pcpt.typname::regtype, arglength)::name AS argtype
                  ,pcptb.typname AS basetype
                  ,pcpt.typtypmod AS typemod
                  ,pcpt.typcategory
                  ,CASE
                   WHEN pcpt.typcategory = 'I' -- Network address types
                   -- cidr     7 or 19 bytes  IPv4 and IPv6 networks
                   -- inet     7 or 19 bytes  IPv4 and IPv6 hosts and networks
                   -- macaddr  6 bytes        MAC addresses
                   -- !!! macaddr is 'U' User-defined types by select
                   -- !!! SELECT * FROM pg_catalog.pg_type WHERE typname = 'macaddr'
                   -- !!! typname macaddr, typlen 6, typcategory U
                   THEN 19
                   WHEN pcpt.typrelid != 0 -- for struct (result_t), recursive
                   THEN (
                           WITH leaves AS (
                                   WITH RECURSIVE typtree AS (
                                           SELECT
                                                   ipcpt.oid
                                                  ,NULL::oid AS paroid
                                                  ,ipcpt.typrelid
                                                  ,ipcpt.typlen
                                                  ,ipcpt.typtypmod
                                                  ,ipcpt.typalign
                                           FROM pg_catalog.pg_type ipcpt
                                           WHERE ipcpt.oid = pcpt.oid
                                           UNION
                                           SELECT
                                                   ipcpt.oid
                                                  ,typtree.oid
                                                  ,ipcpt.typrelid
                                                  ,ipcpa.attlen
                                                  ,ipcpa.atttypmod
                                                  ,ipcpa.attalign
                                           FROM typtree, pg_catalog.pg_attribute ipcpa
                                             JOIN pg_catalog.pg_type ipcpt ON ipcpt.oid = ipcpa.atttypid
                                           WHERE ipcpa.attrelid = typtree.typrelid
                                   )
                                   SELECT * FROM typtree
                                   EXCEPT
                                   SELECT * FROM typtree
                                   WHERE oid IN (SELECT paroid FROM typtree)
                           )
                           SELECT SUM (
                                   COALESCE (
                                       NULLIF(leaves.typlen, -1)
                                      ,CASE
                                         WHEN leaves.typtypmod = -1 THEN NULL
                                       ELSE
                                           leaves.typtypmod
                                              -CASE
                                                  WHEN leaves.typalign = 'c' THEN 0
                                                  WHEN leaves.typalign = 's' THEN 2
                                                  WHEN leaves.typalign = 'i' THEN 4
                                                  WHEN leaves.typalign = 'd' THEN 8
                                               END
                                       END
                                   )
                           )
                           FROM leaves
                   )
                   WHEN pcpt.typlen > 0  THEN pcpt.typlen
                   WHEN -- numeric 
                           pcpt.typtypmod > 0
                       AND pcpt.typcategory = 'N' -- Numeric types
                       AND pcpt.typstorage = 'm' -- Value can be stored compressed inline
                   THEN
                           pcpt.typtypmod / 65536 -- precision
                         --+ pcpt.typtypmod - pcpt.typtypmod / 65536 * 65536 -- full - clear precission
                         --- CASE
                         --  WHEN pcpt.typalign = 'c' -- char alignment, i.e., no alignment needed
                         --  THEN 0
                         --  WHEN pcpt.typalign = 's' -- short alignment (2 bytes on most machines)
                         --  THEN 2
                         --  WHEN pcpt.typalign = 'i' -- int alignment (4 bytes on most machines) -- ! на практике работает только этот ! везде !
                         --  THEN 4
                         --  WHEN pcpt.typalign = 'd' -- double alignment (8 bytes on many machines, but by no means all)
                         --  THEN 8
                         --  END
                         --+ 1 -- '.'
                   WHEN pcpt.typtypmod > 0
                   THEN
                       pcpt.typtypmod
                         - CASE
                               WHEN pcpt.typalign = 'c' THEN 0
                               WHEN pcpt.typalign = 's' THEN 2
                               WHEN pcpt.typalign = 'i' THEN 4
                               WHEN pcpt.typalign = 'd' THEN 8
                           END
                   WHEN arglength > 0
                   THEN
                           arglength
                         - CASE
                              WHEN pcpt.typalign = 'c' THEN 0
                              WHEN pcpt.typalign = 's' THEN 2
                              WHEN pcpt.typalign = 'i' THEN 4
                              WHEN pcpt.typalign = 'd' THEN 8
                           END
                   ELSE -1 -- NULL 
                   END AS argsize
                  ,CASE
                   WHEN
                           pcpt.typtypmod > 0
                       AND pcpt.typcategory = 'N' -- Numeric types
                       AND pcpt.typstorage = 'm' -- Value can be stored compressed inline
                   THEN
                           pcpt.typtypmod - pcpt.typtypmod / 65536 * 65536 -- full - clear precission
                         - CASE
                              WHEN pcpt.typalign = 'c' THEN 0
                              WHEN pcpt.typalign = 's' THEN 2
                              WHEN pcpt.typalign = 'i' THEN 4
                              WHEN pcpt.typalign = 'd' THEN 8
                           END
                   ELSE
                           0
                   END AS argprec
                  ,argdefault
           FROM args
           JOIN pg_catalog.pg_type pcpt       ON args.argtype = pcpt.oid
           LEFT JOIN pg_catalog.pg_type pcptb ON pcpt.typbasetype = pcptb.oid                     
   )
   SELECT
           argnum::public.small_t
          ,COALESCE (
                     (
                       SELECT par.argnum FROM nums par
                       WHERE par.argtree = ARRAY (SELECT unnest(fin.argtree) LIMIT array_upper(fin.argtree, 1) - 1)
                     )   
                  ,0
           )::public.small_t AS argparent
          ,argmode::public.t_code1
          ,argname::public.t_sysname
          ,argtype::public.t_sysname
          ,format_type(basetype::regtype, typemod)::public.t_sysname
          ,typcategory::public.t_code1
          ,argsize::public.t_int
          ,argprec::public.t_int
          ,argdefault::public.t_description
          ,substring (
                      (SELECT description FROM pg_catalog.pg_description WHERE objoid = _proc_oid)
                      ,argname || '[^\r\n]*[-]{2}[\s]*([^\r\n]*)[\s]*[\r\n]?'::text
           )::public.t_description AS arginfo
   FROM nums fin;
END;
$$
 SET search_path = db_info, public, pg_catalog
 LANGUAGE plpgsql
 SECURITY DEFINER ;

COMMENT ON FUNCTION db_info.f_show_proc_args (public.t_text)
IS '24dbg/2257: Получение описания входных и выходных аргументов процедуры.

        Входные параметры:
		1) p_obj_name     public.t_text -- Имя функции + её сигнатура
		
        Выходные параметры:
                1) arg_sequ_num   public.small_t       -- Последовательный номер аргумента
                2) arg_parent_num public.small_t       -- Номер родительского аргумента в последовательности
                3) arg_in_out     public.t_code1       -- Входной или выходной аргумент (i - in, o - out, t - table)
                4) arg_name       public.t_sysname     -- Название аргумента
                5) arg_type       public.t_sysname     -- Тип аргумента
                6) base_name      public.t_sysname     -- Имя базового типа
                7) type_category  public.t_code1       -- Категория типа
                8) type_len       public.t_int         -- Длина типа
                9) type_prec      public.t_int         -- Точность поля
               10) arg_default    public.t_description -- Значение по умолчанию
               11) arg_info       public.t_description -- Пользовательское название или описание
';
-- --------------------------------------------------------------------------------------------------
-- SELECT * FROM db_info.f_show_proc_args (
--  'com.obj_p_codifier_u  (public.t_str60, t_str60, t_str250, t_code1, t_timestamp, t_timestamp, t_guid)'
-- );
-- SELECT * FROM db_info.f_show_proc_args('obj_p_codifier_u');
-- 1;0;"i";"p_id";"id_t";8;"";"ID записи аргумент NULL запрещается."
-- 2;0;"i";"p_parent";"id_t";8;"NULL::bigint";"ID родителя, если NULL - сохраняется старое значение "
-- 3;0;"i";"p_code";"t_str60";60;"NULL::character varying";"Код,         если NULL - сохраняется старое значение "
-- 4;0;"i";"p_name";"t_str250";250;"NULL::character varying";"Наименоваие, если NULL - сохраняется старое значение"
-- 5;0;"i";"p_scode";"t_code1";1;"NULL::bpchar";"Краткий код, если NULL - сохраняется старое значение"
-- 6;0;"i";"p_date_from";"t_timestamp";8;"NULL::timestamp without time zone";"Дата начала актуальности"
-- 7;0;"i";"p_date_to";"t_timestamp";8;"NULL::timestamp without time zone";"Дата окончания актуальности"
-- 8;0;"i";"p_codif_uuid";"t_guid";16;"NULL::uuid";"UUID кодификатора"
-- 9;0;"o";"obj_p_codifier_u";"result_t";2056;"";""
-- 10;9;"o";"rc";"bigint";8;"";""
-- 11;9;"o";"errm";"character varying(2048)";2048;"";""
