-- =====================================================================================================================
-- Author: Gregory
-- Create date: 2017-03-25
-- Description: Обновление ключа
-- =====================================================================================================================
/* ---------------------------------------------------------------------------------------------------------------------
        Входные параметры:
                1) p_key_code      public.t_str60     -- Код ключа
                2) p_key_type_code public.t_str60     -- Код типа ключа
                3) p_attr_code     public.t_arr_code  -- Массив кодов атрибутов, образующих ключ
                4) p_on_off        public.t_boolean   -- Признак активного ключа
                5) p_date_from     public.t_timestamp -- Дата начала актуальности
                6) p_date_to       public.t_timestamp -- Дата конца актуальтности
	Выходные параметры:
                1) rsp_main        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) rsp_main.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) rsp_main.errm character varying(2048) -- Сообщение
--------------------------------------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS nso_structure.nso_p_key_u (public.t_str60, public.t_str60, public.t_arr_code, public.t_boolean);
CREATE OR REPLACE FUNCTION nso_structure.nso_p_key_u (				         
        p_key_code      public.t_str60                  -- Код ключа
       ,p_key_type_code public.t_str60     DEFAULT NULL -- Код типа ключа
       ,p_attr_codes    public.t_arr_code  DEFAULT NULL -- Массив кодов атрибутов, образующих ключ
       ,p_on_off        public.t_boolean   DEFAULT NULL -- Признак активного ключа
)
RETURNS public.result_long_t 
   SET search_path = nso, com, utl, com_codifier, com_domain, nso_strucrure, com_error, public,pg_catalog
AS
 $$
   DECLARE
        _key_id             public.id_t;
        _key_cur_type       public.id_t;
        _nso_id             public.id_t;
        _nso_code           public.t_str60;
        _key_type_id        public.id_t;
        _key_cur_small_code public.t_code1;
        _key_small_code     public.t_code1; --Nick 2017-03-29
        --
        _key_code      public.t_str60 := utl.com_f_empty_string_to_null (upper( btrim (p_key_code)));   -- Код ключа/марекера ключа
        _key_type_code public.t_str60 := utl.com_f_empty_string_to_null (upper( btrim (p_key_type_code)));   --  Тип ключа
        _attr_codes    public.t_arr_code; -- Массив кодов атрибутов, образующих ключ
        --
        c_ERR_FUNC_NAME public.t_sysname = 'nso_p_key_u';

        rsp_main         public.result_long_t;
             --
        _exception  public.exception_type_t;
        _err_args   public.t_arr_text := ARRAY [''];
             --
        C_DEBUG public.t_boolean := utl.f_debug_status();
     
   BEGIN
        IF  _key_code IS NULL
        THEN
                RAISE SQLSTATE '60000'; -- NULL значения запрещены
        END IF;
        --
        SELECT  nk.key_id, nk.key_type_id, no.nso_id, no.nso_code 
                                             INTO _key_id, _key_cur_type, _nso_id, _nso_code
        FROM ONLY nso.nso_key nk
             JOIN ONLY nso.nso_object no ON (no.nso_id = nk.nso_id)
        WHERE (nk.key_code = _key_code);
        --
        IF _key_id IS NULL
        THEN
               _err_args [1] := _key_code::text;
               RAISE SQLSTATE '62042'; -- Запись не найдена  -- !!!
        END IF;

        -- Nick 2019-08-26
        IF ( _key_type_code IS NOT NULL )
          THEN
                SELECT codif_id, small_code INTO _key_type_id, _key_small_code 
                       FROM com_codifier.com_f_obj_codifier_s_sys (C_KEY_TYPE) WHERE (codif_code = _key_type_code);                                                                          
                --                                                                              
                IF (( _key_type_id IS NULL ) OR ( _key_small_code IS NULL )) 
                THEN
                     _err_args [1] := _key_type_code::text;
                     _err_args [2] := C_KEY_TYPE::text;
                     RAISE SQLSTATE '62040'; -- Неправильный код типа ключа
                END IF;  
        END IF;
        -- 
        -- Nick 2019-08-25, вычищен мусор в массиве аттрибутов.
        --
        SELECT array_agg (z.col_code::varchar(60) )::public.t_arr_code INTO _attr_codes
        FROM     
            (SELECT unnest (p_attr_codes) AS col_code ) x, ONLY nso.nso_column_head z
         WHERE ( z.col_code = utl.com_f_empty_string_to_null (upper( btrim (x.col_code)))) AND (nso_id = _nso_id);     
        --
        IF (array_length (_attr_codes, 1) IS NULL)
          THEN
             _err_args [1] := p_attr_codes::text;
             RAISE SQLSTATE '62041'; -- Неправильный массив аттрибутов, образующих ключ.     
        END IF;        
        
        SELECT small_code INTO _key_cur_small_code FROM ONLY com.obj_codifier
        WHERE (codif_id = _key_cur_type);

        PERFORM nso.nso_p_nso_log_i ('D', 'Обновление ключа: "' || _key_code || '".');

        UPDATE ONLY nso.nso_key
        SET
                key_type_id    = COALESCE (_key_type_id, key_type_id)
               ,key_small_code = COALESCE (_key_small_code, key_small_code)
               ,key_code       = COALESCE ('K_' || _nso_code || '_' || _key_type_code, key_code)
               ,on_off         = COALESCE (p_on_off, on_off)
        WHERE key_id = _key_id;

        -- Nick 2019-08-27  !!!

        WITH curattrs AS (SELECT col_id FROM ONLY nso.nso_key_attr WHERE key_id = _key_id)
            ,newattrs AS (SELECT col_id, row_number() OVER() AS column_nm FROM unnest (_attr_codes) u
                             JOIN ONLY nso.nso_column_head ON u = col_code
                           WHERE nso_id = _nso_id
             )
            ,allattrs AS (SELECT col_id FROM curattrs          -- Разное количес тво столбцов Nick 2019-08-27
                           UNION
                          SELECT col_id FROM newattrs
             )
            ,forrem AS (SELECT col_id FROM curattrs
                           EXCEPT
                        SELECT col_id FROM newattrs
             )
            ,foradd AS (SELECT col_id FROM newattrs
                           EXCEPT
                        SELECT col_id FROM curattrs
             )
            ,forupd AS (SELECT col_id FROM curattrs
                           INTERSECT
                        SELECT col_id FROM newattrs
             )
            ,remattrs AS (DELETE FROM ONLY nso.nso_key_attr nka USING forrem fr
                                WHERE   (nka.col_id = fr.col_id)
                                    AND (nka.key_id = _key_id)
                                    AND (_attr_codes IS NOT NULL)
                                RETURNING nka.col_id
             )
            ,addattrs AS (INSERT INTO nso.nso_key_attr (
                                  key_id        
                                 ,col_id        
                                 ,column_nm
                                 ,date_from
                                 ,date_to
                          )
                          SELECT  _key_id
                                 ,fa.col_id
                                 ,na.column_nm
                                 ,now()::public.t_timestamp                 -- p_date_from Nick 2019-08-27
                                 ,'9999-12-31 00:00:00'::public.t_timestamp -- p_date_to
                          FROM foradd fa
                                 JOIN newattrs na ON na.col_id = fa.col_id
                          WHERE _attr_codes IS NOT NULL
                          RETURNING col_id
             )
            ,updattrs AS (UPDATE ONLY nso.nso_key_attr nka
                           SET     column_nm = na.column_nm
                               --   ,date_from = COALESCE(p_date_from, date_from)
                               --   ,date_to = COALESCE(p_date_to, date_to)
                           FROM forupd fu
                            JOIN newattrs na ON na.col_id = fu.col_id
                           WHERE   nka.col_id = fu.col_id
                               AND nka.key_id = _key_id
                               AND _attr_codes IS NOT NULL
                           RETURNING nka.col_id
             )
              UPDATE ONLY nso.nso_abs na
              SET s_key_code = CASE
                                  WHEN ra.col_id IS NOT NULL THEN '0'
                                  ELSE COALESCE (_key_small_code, _key_cur_small_code, s_key_code)
                                END
              FROM allattrs al                  
                   LEFT JOIN remattrs ra ON ra.col_id = al.col_id
                   LEFT JOIN addattrs aa ON aa.col_id = al.col_id
                   LEFT JOIN updattrs ua ON ua.col_id = al.col_id
              WHERE  (na.col_id = al.col_id)
                  AND (_key_small_code IS NOT NULL OR _attr_codes IS NOT NULL);
          
        RETURN (_key_id, 'Выполнено успешно.')::public.result_long_t;
        
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
             ,_exception.context         := PG_EXCEPTION_CONTEXT;            -- 

             _exception.func_name := c_ERR_FUNC_NAME; 
		
	   rsp_main := (-1, ( com_error.f_error_handling ( _exception, _err_args )));
			
	   RETURN rsp_main;			
	 END;
   END;
 $$
LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION nso_structure.nso_p_key_u (public.t_str60, public.t_str60, public.t_arr_code, public.t_boolean)
IS '229: Обновление ключа.
        Входные параметры:
                1) p_key_code      public.t_str60     -- Код ключа
                2) p_key_type_code public.t_str60     -- Код типа ключа
                3) p_attr_code     public.t_arr_code  -- Массив кодов атрибутов, образующих ключ
                4) p_on_off        public.t_boolean   -- Признак активного ключа

        Выходные параметры:
                1) rsp_main        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) rsp_main.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) rsp_main.errm character varying(2048) -- Сообщение';

-- SELECT * FROM nso.nso_f_column_head_nso_s ( 'SPR_RNTD' );
-- SELECT * FROM nso.nso_p_key_u ( 'K_SPR_RNTD_DEFKEY', NULL, ARRAY ['SPR_RNTD_FC_CODE_1','SPR_RNTD_FC_NAME_1'], TRUE );
-- -------------------------------------------------------------------------------------------------------------------------------
-- Nick 2017-03-29  0x@118
-- SELECT * FROM nso.nso_f_column_head_nso_s('SPR_PTK');
-- ---------------------------------------------------------------------------------------------------
-- 109|24|2|21|'SPR_PTK_NAME'|'Наименование'|226|'B'|'T_STR250'|'Строка 250 символов'|t|||||''|''|''
-- 108|24|1|16|'SPR_PTK_CODE'|'Код'         |225|'A'|'T_STR60' |'Строка 60 символов' |t|62|t|1|256|'g'|'DEFKEY'|'Значение по умолчанию'
--  24|  |0|77|'D_SPR_PTK'   |'Заголовок - Перечень Программно-Технических Комплексов'|7|'U'|'C_DOMEN_NODE'|'Узловой Атрибут'|f|||||''|''|''
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Nick 2017-03-29  1x@118
-- SELECT * FROM nso.nso_f_column_head_nso_s('SPR_PTK');
-- ----------------------------------------------------------------------------------------------------------------------------------------
--  24|  |0|77|'D_SPR_PTK'   |'Заголовок - Перечень Программно-Технических Комплексов'|7|'U'|'C_DOMEN_NODE'|'Узловой Атрибут'|f|||||''|''
-- 108|24|1|16|'SPR_PTK_CODE'|'Код'         |225|'A'|'T_STR60'|'Строка 60 символов'|t|31|t|1|256|'g'|'DEFKEY'
-- 109|24|2|21|'SPR_PTK_NAME'|'Наименование'|226|'B'|'T_STR250'|'Строка 250 символов'|t|31|t|2|256|'g'|'DEFKEY'
-- ------------------------------------------------------------------------------------------------------------
-- SELECT * FROM nso.nso_p_key_u ( 'K_SPR_PTK_DEFKEY', NULL, ARRAY ['SPR_PTK_CODE'], TRUE );
-- SELECT * FROM nso.nso_f_column_head_nso_s ( 'SPR_PTK' );
-- --------------------------------------------------------
--  24||0|77|'D_SPR_PTK'|'Заголовок - Перечень Программно-Технических Комплексов'|7|'U'|'C_DOMEN_NODE'|'Узловой Атрибут'|f|||||''|''
-- 108|24|1|16|'SPR_PTK_CODE'|'Код'|225|'A'|'T_STR60'|'Строка 60 символов'|t|31|t|1|256|'g'|'DEFKEY'
-- 109|24|2|21|'SPR_PTK_NAME'|'Наименование'|226|'B'|'T_STR250'|'Строка 250 символов'|t|||||''|''
-- ----------------------------------------------------------------------------------------------
-- Nick 2017-03-29  1x@110
-- -----------------------
-- SELECT * FROM nso.nso_p_key_u ( 'K_SPR_PTK_DEFKEY', NULL, ARRAY ['SPR_PTK_CODE'], TRUE );
-- SELECT * FROM nso.nso_f_column_head_nso_s ( 'SPR_PTK' );
-- ---------------------------------------------------------------
-- SELECT DISTINCT * FROM nso.nso_f_column_head_nso_s('SPR_OKEI');
-- 95;20;6;16;'I_NAME';'Международное имя';225;'A';'T_STR60';'Строка 60 символов';f;3;t;1;250;'a';'AKKEY1';'Уникальный ключ 1';1
-- -- 93;20;4;16;'N_NAME';'Национальное имя';225;'A';'T_STR60';'Строка 60 символов';f;5;t;1;251;'b';'AKKEY2';'Уникальный ключ 2';1
-- 94;20;5;16;'I_CODE';'Международный код';225;'A';'T_STR60';'Строка 60 символов';f;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 98;20;9;40;'G_CODE';'Частота использования';242;'T';'T_REF';'Атрибут-ссылка на НСО';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 97;20;8;40;'B_CODE';'Локализация единицы измерения';242;'T';'T_REF';'Атрибут-ссылка на НСО';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 90;20;1;22;'M_CODE';'Номер п/п';216;'1';'SMALL_T';'Короткое целое';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 92;20;3;16;'N_CODE';'Национальный код';225;'A';'T_STR60';'Строка 60 символов';f;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 91;20;2;16;'M_NAME';'Наименование';225;'A';'T_STR60';'Строка 60 символов';f;4;t;1;256;'g';'DEFKEY';'Значение по умолчанию';1
-- 96;20;7;40;'T_CODE';'Тип единицы измерения';242;'T';'T_REF';'Атрибут-ссылка на НСО';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 20;<NULL>;0;73;'D_SPR_OKEI';'Заголовок - Общероссийский классификатор единиц измерения';7;'U';'C_DOMEN_NODE';'Узловой Атрибут';f;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';0

-- 95;20;6;16;'I_NAME';'Международное имя';225;'A';'T_STR60';'Строка 60 символов';f;3;t;1;250;'a';'AKKEY1';'Уникальный ключ 1';1
-- 94;20;5;16;'I_CODE';'Международный код';225;'A';'T_STR60';'Строка 60 символов';f;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 98;20;9;40;'G_CODE';'Частота использования';242;'T';'T_REF';'Атрибут-ссылка на НСО';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- -- 92;20;3;16;'N_CODE';'Национальный код';225;'A';'T_STR60';'Строка 60 символов';f;5;t;1;251;'b';'AKKEY2';'Уникальный ключ 2';1
-- 97;20;8;40;'B_CODE';'Локализация единицы измерения';242;'T';'T_REF';'Атрибут-ссылка на НСО';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 90;20;1;22;'M_CODE';'Номер п/п';216;'1';'SMALL_T';'Короткое целое';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 91;20;2;16;'M_NAME';'Наименование';225;'A';'T_STR60';'Строка 60 символов';f;4;t;1;256;'g';'DEFKEY';'Значение по умолчанию';1
-- 93;20;4;16;'N_NAME';'Национальное имя';225;'A';'T_STR60';'Строка 60 символов';f;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 96;20;7;40;'T_CODE';'Тип единицы измерения';242;'T';'T_REF';'Атрибут-ссылка на НСО';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 20;<NULL>;0;73;'D_SPR_OKEI';'Заголовок - Общероссийский классификатор единиц измерения';7;'U';'C_DOMEN_NODE';'Узловой Атрибут';f;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';0


-- SELECT * FROM nso.nso_p_key_u('K_SPR_OKEI_AKKEY2', NULL, ARRAY['N_CODE']);
-- 0;'Выполнено успешно.'

-- SELECT * FROM nso.nso_log
-- 7715;'postgres';'::1/128';'D';'2017-03-29 01:03:22';'Обновление ключа: "K_SPR_OKEI_AKKEY2".';'NSO';159

-- SELECT * FROM nso.nso_key WHERE log_id = 7715
-- 5;32;251;'b';'K_SPR_OKEI_AKKEY2';t;'2017-03-29 01:03:22';'9999-12-31 00:00:00';7715

-- SELECT * FROM nso.nso_key_attr WHERE log_id = 7715
-- 5;93;1;'2017-01-12 16:23:09';'2017-03-29 01:03:22';7715

-- SELECT * FROM nso.nso_abs WHERE log_id = 7715
-- ...
-- 2392;92;'A';'b';t;7715;'УСЛ ЯЩ'
-- 2392;93;'A';'0';t;7715;'усл. ящ'
-- 2393;92;'A';'b';t;7715;'МЛН Т'
-- 2393;93;'A';'0';t;7715;'10^6 т'
-- 2394;92;'A';'b';t;7715;'ТЫС Т/СЕЗ'
-- 2394;93;'A';'0';t;7715;'10^3 т/сез'
-- ...
-- Суммарное время выполнения запроса: 54 ms.
-- 936 строк получено.

-- SELECT * FROM nso.nso_p_key_u('K_SPR_OKEI_AKKEY2', 'DEFKEY', ARRAY['N_CODE']);
-- -1;'Ошибку: "повторяющееся значение ключа нарушает ограничение уникальности "ak1_nso_key"" с кодом: "23505" необходимо добавить в таблицу по обработки ошибок для функции:  nso_p_key_u. Ошибка произошла в функции: "nso_p_key_u".'

-- SELECT * FROM ONLY nso.nso_key WHERE nso_id = 32
-- 3;32;250;'a';'K_SPR_OKEI_AKKEY1';t;'2015-10-12 14:02:12';'9999-12-31 00:00:00';341
-- 4;32;256;'g';'K_SPR_OKEI_DEFKEY';t;'2015-10-12 14:02:12';'9999-12-31 00:00:00';341
-- 5;32;251;'b';'K_SPR_OKEI_AKKEY2';t;'2017-03-29 01:18:36';'9999-12-31 00:00:00';7715



-- SELECT * FROM nso.nso_p_key_u('K_SPR_OKEI_AKKEY2', NULL, NULL);
-- 0;'Выполнено успешно.'
-- 
-- SELECT * FROM nso.nso_log
-- 8656;'postgres';'::1/128';'D';'2017-03-29 01:24:52';'Обновление ключа: "K_SPR_OKEI_AKKEY2".';'NSO';161
-- 
-- SELECT * FROM nso.nso_key WHERE log_id = 8656
-- 5;32;251;'b';'K_SPR_OKEI_AKKEY2';t;'2017-03-29 01:24:52';'9999-12-31 00:00:00';8656
-- 
-- SELECT * FROM nso.nso_key_attr WHERE log_id = 8656
-- Суммарное время выполнения запроса: 11 ms.
-- 0 строк получено.
-- 
-- SELECT * FROM nso.nso_abs WHERE log_id = 8656
-- Суммарное время выполнения запроса: 21 ms.
-- 0 строк получено.



-- SELECT * FROM nso.nso_p_key_u('K_SPR_OKEI_AKKEY2', NULL, NULL, NULL, NULL, NULL);
-- 0;'Выполнено успешно.'

-- SELECT * FROM nso.nso_p_key_u('K_SPR_OKi');
-- -1;'Запись не найдена. Ошибка произошла в функции: "nso_p_key_u".'



-- SELECT * FROM nso.nso_p_key_u('K_SPR_OKEI_AKKEY2', 'IEKEY');
-- 0;'Выполнено успешно.'
-- 
-- SELECT * FROM nso.nso_log
-- 8664;'postgres';'::1/128';'D';'2017-03-29 01:29:44';'Обновление ключа: "K_SPR_OKEI_AKKEY2".';'NSO';165
-- 
-- SELECT * FROM nso.nso_key WHERE log_id = 8664
-- 5;32;254;'e';'K_SPR_OKEI_IEKEY';t;'2017-03-29 01:29:44';'9999-12-31 00:00:00';8664
-- 
-- SELECT * FROM nso.nso_key_attr WHERE log_id = 8664
-- Суммарное время выполнения запроса: 10 ms.
-- 0 строк получено.
-- 
-- SELECT * FROM nso.nso_abs WHERE log_id = 8664
-- ...
-- 2392;92;'A';'e';t;8664;'УСЛ ЯЩ'
-- 2393;92;'A';'e';t;8664;'МЛН Т'
-- 2394;92;'A';'e';t;8664;'ТЫС Т/СЕЗ'
-- ...
-- Суммарное время выполнения запроса: 31 ms.
-- 468 строк получено.

-- SELECT DISTINCT * FROM nso.nso_f_column_head_nso_s('SPR_OKEI');
-- 95;20;6;16;'I_NAME';'Международное имя';225;'A';'T_STR60';'Строка 60 символов';f;3;t;1;250;'a';'AKKEY1';'Уникальный ключ 1';1
-- 94;20;5;16;'I_CODE';'Международный код';225;'A';'T_STR60';'Строка 60 символов';f;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 98;20;9;40;'G_CODE';'Частота использования';242;'T';'T_REF';'Атрибут-ссылка на НСО';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 97;20;8;40;'B_CODE';'Локализация единицы измерения';242;'T';'T_REF';'Атрибут-ссылка на НСО';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 92;20;3;16;'N_CODE';'Национальный код';225;'A';'T_STR60';'Строка 60 символов';f;5;t;1;254;'e';'IEKEY';'Поисковый ключ';1
-- 90;20;1;22;'M_CODE';'Номер п/п';216;'1';'SMALL_T';'Короткое целое';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 91;20;2;16;'M_NAME';'Наименование';225;'A';'T_STR60';'Строка 60 символов';f;4;t;1;256;'g';'DEFKEY';'Значение по умолчанию';1
-- 93;20;4;16;'N_NAME';'Национальное имя';225;'A';'T_STR60';'Строка 60 символов';f;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 96;20;7;40;'T_CODE';'Тип единицы измерения';242;'T';'T_REF';'Атрибут-ссылка на НСО';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 20;<NULL>;0;73;'D_SPR_OKEI';'Заголовок - Общероссийский классификатор единиц измерения';7;'U';'C_DOMEN_NODE';'Узловой Атрибут';f;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';0

-- SELECT * FROM nso.nso_p_key_u('K_SPR_OKEI_AKKEY2', NULL, ARRAY['']);
-- -1;'Запись не найдена. Ошибка произошла в функции: "nso_p_key_u".'

-- SELECT * FROM nso.nso_p_key_u('K_SPR_OKEI_IEKEY', NULL, ARRAY['']);
-- 0;'Выполнено успешно.'

-- SELECT DISTINCT * FROM nso.nso_f_column_head_nso_s('SPR_OKEI');
-- 95;20;6;16;'I_NAME';'Международное имя';225;'A';'T_STR60';'Строка 60 символов';f;3;t;1;250;'a';'AKKEY1';'Уникальный ключ 1';1
-- 94;20;5;16;'I_CODE';'Международный код';225;'A';'T_STR60';'Строка 60 символов';f;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 98;20;9;40;'G_CODE';'Частота использования';242;'T';'T_REF';'Атрибут-ссылка на НСО';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 97;20;8;40;'B_CODE';'Локализация единицы измерения';242;'T';'T_REF';'Атрибут-ссылка на НСО';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 90;20;1;22;'M_CODE';'Номер п/п';216;'1';'SMALL_T';'Короткое целое';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 92;20;3;16;'N_CODE';'Национальный код';225;'A';'T_STR60';'Строка 60 символов';f;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 91;20;2;16;'M_NAME';'Наименование';225;'A';'T_STR60';'Строка 60 символов';f;4;t;1;256;'g';'DEFKEY';'Значение по умолчанию';1
-- 93;20;4;16;'N_NAME';'Национальное имя';225;'A';'T_STR60';'Строка 60 символов';f;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 96;20;7;40;'T_CODE';'Тип единицы измерения';242;'T';'T_REF';'Атрибут-ссылка на НСО';t;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';1
-- 20;<NULL>;0;73;'D_SPR_OKEI';'Заголовок - Общероссийский классификатор единиц измерения';7;'U';'C_DOMEN_NODE';'Узловой Атрибут';f;<NULL>;<NULL>;<NULL>;<NULL>;'<NULL>';'<NULL>';'<NULL>';0

-- SELECT * FROM nso.nso_log
-- 9134;'postgres';'::1/128';'D';'2017-03-29 01:35:59';'Обновление ключа: "K_SPR_OKEI_IEKEY".';'NSO';166
-- 
-- SELECT * FROM nso.nso_key WHERE log_id = 9134
-- 5;32;254;'e';'K_SPR_OKEI_IEKEY';t;'2017-03-29 01:35:59';'9999-12-31 00:00:00';9134
-- 
-- SELECT * FROM nso.nso_key_attr WHERE key_id = 5
-- 5;93;1;'2017-01-12 16:23:09';'2017-03-29 01:18:36';7715
-- 5;92;1;'2017-03-29 01:18:36';'2017-03-29 01:35:59';9134
-- 
-- SELECT * FROM nso.nso_abs WHERE log_id = 9134
-- 2392;92;'A';'0';t;9134;'УСЛ ЯЩ'
-- 2393;92;'A';'0';t;9134;'МЛН Т'
-- 2394;92;'A';'0';t;9134;'ТЫС Т/СЕЗ'
