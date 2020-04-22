-- ====================================================================================================================
-- Author: Gregory
-- Create date: 2016-02-24
-- Description:	Получение описания столбцов функции
-- ====================================================================================================================
/* --------------------------------------------------------------------------------------------------------------------
	Входные параметры:
                1) p_schema_name VARCHAR (20) -- Наименование схемы
                2) p_obj_name    VARCHAR (64) -- Наименование объекта
	Выходные параметры:
		1) schema_name        VARCHAR (20)  -- Наименование схемы
                2) objoid             INTEGER       -- OID объекта
                3) obj_type           VARCHAR (20)  -- Тип объекта
                4) obj_name           VARCHAR (64)  -- Наименование объекта
                5) attr_number        SMALLINT      -- Номер атрибута
                6) column_name        VARCHAR (64)  -- Наименование атрибута
                7) type_name          VARCHAR (64)  -- Наименование типа
                8) type_len           INT           -- Длина типа
                9) column_description VARCHAR (250) -- Описание столбца
-------------------------------------------------------------------------------------------------------------------- */
SET search_path = db_info, public;
DROP FUNCTION IF EXISTS db_info.f_show_arg_descr(varchar,varchar);
CREATE OR REPLACE FUNCTION db_info.f_show_arg_descr
(
        p_schema_name VARCHAR (20) -- Наименование схемы
       ,p_obj_name    VARCHAR (64) -- Наименование объекта

)
RETURNS TABLE
(
        schema_name        VARCHAR (20)  -- Наименование схемы
       ,objoid             INTEGER       -- OID объекта
       ,obj_type           VARCHAR (20)  -- Тип объекта
       ,obj_name           VARCHAR (64)  -- Наименование объекта
       ,attr_number        SMALLINT      -- Номер атрибута
       ,attr_mode          CHAR          -- Режим атрибута
       ,column_name        VARCHAR (64)  -- Наименование атрибута
       ,type_name          VARCHAR (64)  -- Наименование типа
       ,type_len           INT           -- Длина типа
       ,column_description VARCHAR (250) -- Описание столбца
)
AS
$$
BEGIN
        RETURN QUERY
        WITH proc AS (
                WITH info AS (
                        WITH sem AS (
                                SELECT
                                        row_number() OVER() AS ord
                                       ,prts.txt AS prt
                                       ,CASE
                                        WHEN prts.txt = ANY(nsps.arr)
                                        THEN 'N' -- namespace
                                        WHEN prts.txt = ANY(prcs.arr)
                                        THEN 'P' -- proc
                                        WHEN prts.txt = ANY(typs.arr)
                                        THEN 'T' -- type
                                        ELSE 'U' -- unknown
                                        END AS typ
                                FROM
                                        (
                                                SELECT unnest(
                                                        regexp_matches(
                                                                p_obj_name -- 'com.obj_p_codifier_u(public.id_t,public.t_str60)'
                                                               ,'([^.,\x28\x29]+)'
                                                               ,'g'
                                                        )
                                                ) AS txt
                                        ) prts
                                        -- -- in
                                        -- com.obj_p_codifier_u(public.id_t,public.t_str60)
                                        -- -- out
                                        -- com
                                        -- obj_p_codifier_u
                                        -- public
                                        -- id_t
                                        -- public
                                        -- t_str60
                                       ,(
                                                SELECT array_agg(nspname) AS arr
                                                FROM pg_catalog.pg_namespace
                                        ) nsps
                                        -- {pg_toast,pg_temp_1,pg_toast_temp_1,pg_catalog,public,information_schema,app,auth,...}
                                       ,(
                                                SELECT array_agg(proname) AS arr
                                                FROM pg_catalog.pg_proc
                                        ) prcs
                                        -- {...,com_f_com_log_s,com_f_com_log_s,com_f_empty_string_to_null,com_f_interval_to_human_readable,...}
                                       ,(
                                                SELECT array_agg(typname) AS arr
                                                FROM pg_catalog.pg_type
                                        ) typs
                                        -- {bool,bytea,char,name,int8,int2,int2vector,int4,regproc,text,oid,tid,xid,cid,oidvector,...}
                        )
                        SELECT
                                MAX (
                                        CASE
                                        WHEN ord = 1 AND typ = 'N'
                                        THEN prt
                                        ELSE NULL
                                        END
                                ) AS nspname
                                -- com
                               ,MAX (
                                        CASE
                                        WHEN typ = 'P'
                                        THEN prt
                                        ELSE NULL
                                        END
                                ) AS proname
                                -- obj_p_codifier_u
                               ,(
                                        SELECT array_agg(
                                                COALESCE(
                                                        nsp.prt
                                                       ,(
                                                                SELECT nspname
                                                                FROM pg_catalog.pg_type pcpt
                                                                JOIN pg_catalog.pg_namespace pcpn
                                                                ON pcpn.oid = pcpt.typnamespace
                                                                WHERE typname = typ.prt
                                                        )
                                                )
                                             || '.'
                                             || typ.prt
                                        )
                                        FROM sem typ
                                        LEFT JOIN sem nsp
                                        ON
                                                nsp.ord = typ.ord - 1
                                            AND nsp.typ = 'N'
                                        WHERE typ.typ = 'T'
                                ) AS proargs
                                -- !!! pg_catalog.pg_type.typname is not PK for PostgreSQL !!!
                                -- !!! or all types in public, or typname dont repeat !!!
                                -- -- in
                                -- ...(public.id_t,public.t_str60)
                                -- -- or
                                -- ...(id_t,t_str60)
                                -- -- out
                                -- {public.id_t,public.t_str60}
                        FROM sem
                        -- "com";"obj_p_codifier_u";"{public.id_t,public.t_str60}"
                )
                SELECT
                        pcpn.nspname
                       ,pcpp.oid
                       ,CASE
                        WHEN pcpp.prorettype = 'trigger'::regtype::oid
                        THEN 'C_TRIGGER'
                        ELSE 'C_FUNCTION'
                        END::varchar AS protype
                       ,pcpp.proname::varchar
                       ,
                                info.proargs IS NULL
                             OR (
                                        info.proargs IS NOT NULL
                                    AND info.proargs = (
                                                SELECT array_agg('public.' || arg_type::text) -- !!! HARD public !!!
                                                FROM db_info.f_show_proc_args(pcpp.oid)
                                                WHERE arg_in_out = 'i'
                                        )
                                ) AS find
                FROM
                        info
                       ,pg_catalog.pg_proc pcpp
                JOIN pg_catalog.pg_namespace pcpn
                ON pcpn.oid = pcpp.pronamespace
                JOIN pg_catalog.pg_language pcpl
                ON pcpl.oid = pcpp.prolang
                WHERE
                        pcpl.lanispl IS TRUE
                    AND (
                                (
                                        p_schema_name IS NULL
                                    AND (
                                                info.nspname IS NULL
                                             OR (
                                                        info.nspname IS NOT NULL
                                                    AND pcpn.nspname = info.nspname -- p_schema_name
                                                )
                                        )
                                )
                             OR (
                                        p_schema_name IS NOT NULL
                                    AND pcpn.nspname = p_schema_name
                                )
                        )
                    AND (
                                info.proname IS NULL -- p_obj_name
                             OR (
                                        info.proname IS NOT NULL
                                    AND pcpp.proname = info.proname
                                )
                        )
        )
        SELECT
                proc.nspname::varchar
               ,proc.oid::integer
               ,proc.protype::varchar
               ,proc.proname::varchar
               ,args.arg_sequ_num::smallint --,row_number() OVER()::smallint
               ,args.arg_in_out::char -- 2016-03-10 Gregory
               ,args.arg_name::varchar
               ,args.arg_type::varchar
               ,args.arg_length::integer
               ,args.arg_info::varchar
        FROM
                proc
               ,db_info.f_show_proc_args(proc.oid) args
        WHERE proc.find IS TRUE;
END;
$$
LANGUAGE plpgsql
SECURITY DEFINER ;

COMMENT ON FUNCTION db_info.f_show_arg_descr(varchar,varchar)
IS '2257: Получение описания столбцов функции.
	Входные параметры:
                1) p_schema_name VARCHAR (20) -- Наименование схемы
                2) p_obj_name    VARCHAR (64) -- Наименование объекта
	Выходные параметры:
		1) schema_name        VARCHAR (20)  -- Наименование схемы
                2) objoid             INTEGER       -- OID объекта
                3) obj_type           VARCHAR (20)  -- Тип объекта
                4) obj_name           VARCHAR (64)  -- Наименование объекта
                5) attr_number        SMALLINT      -- Номер атрибута
                6) column_name        VARCHAR (64)  -- Наименование атрибута
                7) type_name          VARCHAR (64)  -- Наименование типа
                8) type_len           INT           -- Длина типа
                9) column_description VARCHAR (250) -- Описание столбца';

-- 2016-03-10 Gregory
-- SELECT * FROM db_info.f_show_arg_descr(NULL,NULL); -- 2966
-- SELECT * FROM db_info.f_show_arg_descr('com',NULL); -- 358
-- SELECT * FROM db_info.f_show_arg_descr('com','obj_p_codifier_u'); -- 21

-- 2016-03-31 Gregory
-- SELECT * FROM db_info.f_show_arg_descr('com','com.obj_p_codifier_u'); -- 21
-- SELECT * FROM db_info.f_show_arg_descr(NULL,'com.obj_p_codifier_u'); -- 21
-- SELECT * FROM db_info.f_show_arg_descr('com','com.obj_p_codifier_u(public.id_t,public.id_t,public.t_str60,public.t_str250,public.t_code1,public.t_timestamp,public.t_timestamp,public.t_guid)'); -- 11

-- SELECT * FROM db_info.f_show_arg_descr('com','nso_p_domain_column_i');
-- "com";162237;"C_FUNCTION";"nso_p_domain_column_i";1;"p_parent_attr_code";"t_str60";60;"Код родительского атрибута"
-- "com";162237;"C_FUNCTION";"nso_p_domain_column_i";2;"p_attr_type_code";"t_str60";60;"Код типа атрибута"
-- "com";162237;"C_FUNCTION";"nso_p_domain_column_i";3;"p_attr_code";"t_str60";60;"Код атрибута"
-- "com";162237;"C_FUNCTION";"nso_p_domain_column_i";4;"p_attr_name";"t_str250";250;"Наименование атрибута"
-- "com";162237;"C_FUNCTION";"nso_p_domain_column_i";5;"p_attr_uuid";"t_guid";16;"UUID атрибута"
-- "com";162237;"C_FUNCTION";"nso_p_domain_column_i";6;"p_domain_nso_code";"t_str60";60;"Код НСО-домена"
-- "com";162237;"C_FUNCTION";"nso_p_domain_column_i";7;"p_date_from";"t_timestamp";8;"Начало периода актуальности"
-- "com";162237;"C_FUNCTION";"nso_p_domain_column_i";8;"p_date_to";"t_timestamp";8;"Конец периода актуальности "
-- "com";162237;"C_FUNCTION";"nso_p_domain_column_i";9;"nso_p_domain_column_i";"result_t";;""
-- "com";162237;"C_FUNCTION";"nso_p_domain_column_i";10;"rc";"bigint";8;""
-- "com";162237;"C_FUNCTION";"nso_p_domain_column_i";11;"errm";"character varying(2048)";2048;""

-- SELECT * FROM db_info.f_show_arg_descr('com','tr_nso_domain_column_iud');
-- "com";162251;"C_TRIGGER";"tr_nso_domain_column_iud";1;"tr_nso_domain_column_iud";"trigger";4;""

-- SELECT * FROM db_info.f_show_arg_descr('com','com_f_obj_codifier_s');
-- "com";162210;"C_FUNCTION";"com_f_obj_codifier_s";1;"p_codif_code_parent";"t_str60";60;"Код родительского элемента"
-- "com";162210;"C_FUNCTION";"com_f_obj_codifier_s";2;"p_codif_id_child";"id_t";8;"Идентификатор дочернего элемента"
-- "com";162210;"C_FUNCTION";"com_f_obj_codifier_s";3;"com_f_obj_codifier_s";"record";;""
-- "com";162210;"C_FUNCTION";"com_f_obj_codifier_s";4;"codif_id";"id_t";8;"Идентификатор дочернего элемента"
-- "com";162210;"C_FUNCTION";"com_f_obj_codifier_s";5;"parent_codif_id";"id_t";8;"Идентификатор родительского элемента"
-- "com";162210;"C_FUNCTION";"com_f_obj_codifier_s";6;"small_code";"t_code1";1;"Краткий код"
-- "com";162210;"C_FUNCTION";"com_f_obj_codifier_s";7;"codif_code";"t_str60";60;"Код родительского элемента"
-- "com";162210;"C_FUNCTION";"com_f_obj_codifier_s";8;"codif_name";"t_str250";250;"Наименование"
-- "com";162209;"C_FUNCTION";"com_f_obj_codifier_s";1;"p_codif_code_parent";"t_str60";60;"Код родительского кодификатора"
-- "com";162209;"C_FUNCTION";"com_f_obj_codifier_s";2;"p_codif_code_child";"t_str60";60;"Код дочернего элемента"
-- "com";162209;"C_FUNCTION";"com_f_obj_codifier_s";3;"com_f_obj_codifier_s";"record";;""
-- "com";162209;"C_FUNCTION";"com_f_obj_codifier_s";4;"codif_id";"id_t";8;"Идентификатор кодификатора"
-- "com";162209;"C_FUNCTION";"com_f_obj_codifier_s";5;"parent_codif_id";"id_t";8;"Идентификатор родительского кодификатора"
-- "com";162209;"C_FUNCTION";"com_f_obj_codifier_s";6;"small_code";"t_code1";1;"Краткий код"
-- "com";162209;"C_FUNCTION";"com_f_obj_codifier_s";7;"codif_code";"t_str60";60;"Код родительского кодификатора"
-- "com";162209;"C_FUNCTION";"com_f_obj_codifier_s";8;"codif_name";"t_str250";250;"Наименование"
