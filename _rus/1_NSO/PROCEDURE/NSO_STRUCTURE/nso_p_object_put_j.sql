/*
  Входные параметры:
     p_nso_strct public.t_text    -- Структура НСО в  JSON-формат
    ,p_date_create        public.t_timestamp = now()::public.t_timestamp -- Дата создания

  Выходные параметры:
    1)  rsp_main.rc = < 0 > при успешном завершении
        rsp_main.rc = -1 при ошибке
    2)  rsp_main.errm - Строка состояния выполнения запроса
 -----------------------------------------------------------------------------------*/
DROP FUNCTION IF EXISTS nso_structure.nso_p_object_put ( public.t_text, public.t_timestamp );
CREATE OR REPLACE FUNCTION nso_structure.nso_p_object_put (
     p_nso_strct   public.t_text    -- Структура НСО в  JSON-формат
    ,p_date_create public.t_timestamp = now()::public.t_timestamp -- Дата создания
)
RETURNS public.result_long_t
    SECURITY DEFINER
    LANGUAGE plpgsql
    SET search_path = nso, com, utl, com_codifier, com_domain, nso_strucrure, com_error, public,pg_catalog
AS
 $$
   /*===================================================================================*/
   /* Created on:  2018-08-21 Nick Cоздание НСО                                         */
   /* Структура описана в JSON-формате с комментариями (автор структуры - Роман Шляхов. */
   /*===================================================================================*/ 
  DECLARE
     c_ERR_F_NAME   public.t_sysname = 'nso_p_object_put';  --имя процедуры
 
     c_MESS00 public.t_str1024 = 'Создание НСО выполнено успешно';
     c_MESS11 public.t_str1024 = 'Обновление НСО выполнено успешно';
 
     c_MESS10 public.t_str1024 = 'Создание элемента заголовка НСО выполнено успешно';
     c_MESS20 public.t_str1024 = 'Создание элемента заголовка ключа выполнено успешно';
 
     c_MESS01  public.t_str60  = 'Ошибка: ';
     c_MESS02  public.t_str60  = 'Детали: ';
     c_MESS03  public.t_str60  = 'Совет: ';
     c_MESS04  public.t_str60  = 'Контекст: ';
 
     txt_ERR_PG_EXCP_DTL    public.t_text;
     txt_ERR_PG_EXCP_HINT   public.t_text;
     txt_ERR_PG_EXCPT_CONT  public.t_text;
 
     c_DEBUG  public.t_boolean := utl.f_debug_status (); -- Nick 2016-02-16
 
     ch_new_line  public.t_code1  = chr(10)::public.t_code1;
     ch_tab       public.t_code1  = chr(9)::public.t_code1;
 
     --- Регулярка для удаления комментариев из JSON данных, т.к. в PostgreSQL они не поддерживаются ( Можно использовать только комментарии вида /* комментарий */)
     _rx_comment public.t_text = '/\*(.|\n)*?\*/';
     --- JSON данные
     _js_data_string json;
 
     rsp_main public.result_long_t; -- Nick 2016_02_17
 
     _nso_prop        RECORD;
     _nso_column      RECORD;
     _nso_column_real RECORD;
     _nso_key         RECORD;
     _nso_key_real    RECORD;
     --
     _qty_column public.t_int;
     --
     _nso_id  public.id_t;
     --
     _head_nso_is_exists public.t_boolean;
     --
     _attr_codes public.t_arr_code;
     --
     _mode PUBLIC.t_int := 0; -- Создание
     --
     _exception  public.exception_type_t;
     _err_args   public.t_arr_text := ARRAY [''];
     --
  BEGIN
    IF ( (p_nso_strct IS NULL) OR (p_date_create IS NULL) )
    THEN
        RAISE SQLSTATE '60000'; -- NULL значения запрещены
    END IF;
 
    _js_data_string := regexp_replace (btrim (p_nso_strct), _rx_comment, '', 'g');
 
    CREATE TEMPORARY TABLE tmp_nso_object_1 ON COMMIT DROP
    AS (
        WITH pref ( j_data ) 
         AS
           (
             SELECT (_js_data_string)::json AS j_data
           )
           , nso_prop AS 
             (
               SELECT
                   upper (j_data #>> '{nso_object, nso_code}'       )::public.t_str60     AS nso_code      
                        ,(j_data #>> '{nso_object, nso_name}'       )::public.t_str250    AS nso_name      
                        ,(j_data #>> '{nso_object, nso_uuid}'       )::public.t_guid      AS nso_uuid      
                  ,upper (j_data #>> '{nso_object, parent_nso_code}')::public.t_str60     AS parent_nso_code
                  ,upper (j_data #>> '{nso_object, nso_type_code}'  )::public.t_str60     AS nso_type_code 
                        ,(j_data #>> '{nso_object, is_group_nso}'   )::public.t_boolean   AS is_group_nso  
                        ,(j_data #>> '{nso_object, date_from}'      )::public.t_timestamp AS date_from     
                        ,(j_data #>> '{nso_object, date_to}'        )::public.t_timestamp AS date_to       
                        ,(j_data #>> '{nso_object, unique_control}' )::public.t_boolean   AS unique_control
                        ,(j_data #>> '{nso_object, view_create}'    )::public.t_boolean   AS view_create   
                FROM pref  
             ) SELECT * FROM nso_prop
    ); -- end temporary
    --
    CREATE TEMPORARY TABLE tmp_nso_object_2 ON COMMIT DROP
    AS (
        WITH pref ( j_data ) 
         AS
           (
             SELECT (_js_data_string)::json AS j_data
           )
           , nso_columns AS 
             (
              SELECT 
                 generate_series (1, json_array_length (j_data #> '{nso_object, columns}')) AS col_nmb
                ,json_array_elements (j_data #> '{nso_object, columns}') AS col_data
              FROM pref
             ) SELECT * FROM nso_columns 
    ); -- end temporary
    --
    CREATE TEMPORARY TABLE tmp_nso_object_3 ON COMMIT DROP
    AS (
        WITH pref ( j_data ) 
         AS
           (
             SELECT (_js_data_string)::json AS j_data
           )
           , nso_marks_keys AS 
             (
              SELECT 
                 generate_series (1, json_array_length (j_data #> '{nso_object, marks_keys}')) AS key_nmb
                ,json_array_elements (j_data #> '{nso_object, marks_keys}') AS key_data
              FROM pref
             ) SELECT * FROM nso_marks_keys 
    ); -- end temporary
 
    FOR _nso_prop IN SELECT * FROM tmp_nso_object_1  
       LOOP
         IF C_DEBUG THEN
              RAISE NOTICE '<%>, %', c_ERR_F_NAME, _nso_prop;
         END IF;
         --
         _nso_id := nso_structure.nso_f_object_get_id (_nso_prop.nso_code); 
         IF  (_nso_id IS NULL) 
         THEN
            RAISE NOTICE '<%>, Объект создаётся', c_ERR_F_NAME;
            -- 
            rsp_main := nso_structure.nso_p_object_i (       
                 p_parent_nso_code := _nso_prop.parent_nso_code  --  Код родительского НСО
                ,p_nso_type_code   := _nso_prop.nso_type_code    --  Тип НСО
                ,p_nso_code        := _nso_prop.nso_code         --  Код НСО
                ,p_nso_name        := _nso_prop.nso_name         --  Наименование НСО
                ,p_nso_uuid        := _nso_prop.nso_uuid         --  UUID НСО
                 --------  По умолчанию
                ,p_is_group_nso := COALESCE (_nso_prop.is_group_nso, FALSE)  --   Признак узлового НСО
                ,p_date_from    := COALESCE (_nso_prop.date_from, now()::public.t_timestamp)
                ,p_date_to      := COALESCE (_nso_prop.date_to, '9999-12-31 00:00:00'::public.t_timestamp)
            );
            IF (rsp_main.rc > 0) THEN
               RAISE NOTICE '<%>, %, ID = "%"', c_ERR_F_NAME, rsp_main.errm, rsp_main.rc;
               _nso_id := rsp_main.rc;
            ELSE
                RAISE '%', rsp_main.errm; 
            END IF;
          ELSE
              RAISE NOTICE '<%>, Объект уже существует', c_ERR_F_NAME;
              _mode := 1;
              -- Код объекта не меняется  
              -- 2019-09-04 Nick убраны "date_from", "date_to"
              rsp_main := nso_structure.nso_p_object_u (
                  p_parent_nso_code := _nso_prop.parent_nso_code --  Код родительского НСО
                 ,p_nso_type_code   := _nso_prop.nso_type_code   --  Код типа НСО
                 ,p_nso_code        := _nso_prop.nso_code        --+ Код НСО, поисковый аргумент, всегда NOT NULL ОСНОВА
                 ,p_nso_name        := _nso_prop.nso_name        --  Наименование НСО
                 ,p_nso_uuid        := _nso_prop.nso_uuid        --  UUID НСО
              );
              IF (rsp_main.rc >= 0) THEN
                 RAISE NOTICE '<%>, %, ID = "%"', c_ERR_F_NAME, rsp_main.errm, rsp_main.rc;
                 _nso_id := rsp_main.rc;
              ELSE
                  RAISE '%', rsp_main.errm; 
              END IF;
         END IF;
    END LOOP;
    --
    -- Столбцы
    --
    _head_nso_is_exists := (
           EXISTS ( 
               SELECT 1 FROM nso_structure.nso_f_column_head_nso_s (_nso_prop.nso_code) WHERE (number_col > 0)
           )
    );
    SELECT count (*) FROM tmp_nso_object_2 INTO _qty_column;
    FOR _nso_column IN SELECT * FROM tmp_nso_object_2  
     LOOP
       IF C_DEBUG THEN
            RAISE NOTICE '<%>, %, %', c_ERR_F_NAME, _head_nso_is_exists, _nso_column;
       END IF;
       --  
       IF NOT _head_nso_is_exists THEN
          RAISE NOTICE '<%>, Элемент заголовка создаётся', c_ERR_F_NAME; 
 
          -- Nick 2019-09-04 Изменилась сигнатура функции
          rsp_main := nso_structure.nso_p_column_head_i (	 
                 p_nso_code  := _nso_prop.nso_code -- Код объекта владельца
                ,p_attr_code := upper (_nso_column.col_data ->> 'attr_code')::public.t_str60 -- Код атрибута
                -- По умолчанию
                ,p_number_col := COALESCE ((_nso_column.col_data ->> 'number_col')::public.small_t
                                          , _nso_column.col_nmb::public.small_t
                                 )  -- Номер колонки, 
                ,p_mandatory  := COALESCE ((_nso_column.col_data ->> 'is_mandatory')::public.t_boolean
                                         , FALSE::public.t_boolean
                                 ) -- Обязательность заполнения
                ,p_act_code  := upper(_nso_column.col_data ->> 'act_code')::public.t_str60   -- Актуальный код, если NULL то берём код родителя +  код НСО + номер строки
                ,p_act_name  := (_nso_column.col_data ->> 'act_name')::public.t_str250  -- Актуальное имя, если NULL берём имя домена 
                ,p_final_sw  := (_qty_column = _nso_column.col_nmb) -- если TRUE то записываем сообщение в LOG 
          );
          IF (rsp_main.rc >= 0) THEN
             RAISE NOTICE '<%>, %, rc = "%"', c_ERR_F_NAME, c_MESS10, rsp_main.rc;
          ELSE
              RAISE '%', rsp_main.errm; 
          END IF;
        ELSE
           RAISE NOTICE '<%>, Элемент заголовка уже существует', c_ERR_F_NAME; 
           _mode := 1;
 
           SELECT * INTO _nso_column_real FROM nso_structure.nso_f_column_head_nso_s (_nso_prop.nso_code) 
           WHERE ( attr_code = upper(_nso_column.col_data ->> 'act_code')::public.t_str60);
           --
           IF C_DEBUG THEN
              RAISE NOTICE '<%>, %', c_ERR_F_NAME, _nso_column_real;
           END IF;
           --
           rsp_main := nso_structure.nso_p_column_head_u (        
               p_col_id     := _nso_column_real.col_id  --+ Идентификатор колонки, всегда NOT NULL Это основа       
              ,p_attr_id    := _nso_column_real.attr_id --+ Идентификатор атрибута из домена атрибутов        
              ,p_col_code   := upper(_nso_column.col_data ->> 'act_code')::public.t_str60 --+  Код колонки        
              ,p_col_name   := (_nso_column.col_data ->> 'act_name')::public.t_str250 --  Имя колонки        
              ,p_number_col := COALESCE ((_nso_column.col_data ->> 'number_col')::public.small_t
                                , _nso_column.col_nmb::public.small_t
                                ) --  Номер колонки        
           );        
           IF (rsp_main.rc >= 0) THEN
              RAISE NOTICE '<%>, %, rc = "%"', c_ERR_F_NAME, rsp_main.errm, rsp_main.rc;
           ELSE
               RAISE '%', rsp_main.errm; 
           END IF;
       END IF;
    END LOOP;
    --
    -- Маркеры  "data_from", "data_to"
    --
    FOR _nso_key IN SELECT * FROM tmp_nso_object_3  
     LOOP
       --
       _attr_codes := ( WITH z (f1) AS 
                        ( SELECT json_array_elements_text (_nso_key.key_data -> 'attr_codes') AS x)
                         SELECT array_agg (upper (f1)) FROM z
                      )::public.t_arr_code; -- Массив кодов атрибутов, образующих ключ
 
       SELECT DISTINCT k2.key_id, k2.key_code, k1.key_type_code INTO _nso_key_real
           FROM nso_structure.nso_f_column_head_nso_s (_nso_prop.nso_code, TRUE) k1
             INNER JOIN ONLY nso.nso_key k2 ON ( k1.key_id = k2.key_id)
       WHERE ( k1.attr_code = ANY (_attr_codes));                      
       --
       IF C_DEBUG THEN
            RAISE NOTICE '<%>, % % %', c_ERR_F_NAME, _nso_key, _nso_key_real, _attr_codes;
       END IF;
       --
       IF ( _nso_key_real IS NULL ) 
       THEN
          RAISE NOTICE '<%>, Маркер в заголовке создаётся', c_ERR_F_NAME; 
 
          rsp_main := nso_structure.nso_p_key_i (				         
              p_nso_code	     := _nso_prop.nso_code -- Код НСО
             ,p_key_type_code := upper(_nso_key.key_data ->> 'key_type_code')::public.t_str60 -- Тип кода ключа
             ,p_attr_codes    := _attr_codes  -- Массив кодов атрибутов, образующих ключ 
            );
          IF (rsp_main.rc >= 0) THEN
               RAISE NOTICE '<%>, %, rc = "%"', c_ERR_F_NAME, c_MESS20, rsp_main.rc;
          ELSE
              RAISE '%', rsp_main.errm; 
          END IF;
          
       ELSE  -- Существует, обновляем.
          -----------------------
          RAISE NOTICE '<%>, Маркер в заголовке уже существует', c_ERR_F_NAME; 
          _mode := 1;
 
          rsp_main := nso_structure.nso_p_key_u (				         
                    p_key_code      := _nso_key_real.key_code  --+ Код ключа
                   ,p_key_type_code := upper(_nso_key.key_data ->> 'key_type_code')::public.t_str60 -- Код типа ключа
                   ,p_attr_codes    := _attr_codes -- Массив кодов атрибутов, образующих ключ
              );
          IF (rsp_main.rc >= 0) THEN
               RAISE NOTICE '<%>, %, rc = "%"', c_ERR_F_NAME, c_MESS20, rsp_main.rc;
          ELSE
              RAISE '%', rsp_main.errm; 
          END IF;
       END IF;
       --
    END LOOP;
    --
    IF (_nso_prop.unique_control) 
      THEN
         rsp_main := nso_data.nso_p_object_unique_check_on (_nso_prop.nso_code);
         IF (rsp_main.rc >= 0) THEN
              RAISE NOTICE '<%>, %, rc = "%"', c_ERR_F_NAME, rsp_main.errm, rsp_main.rc;
         ELSE
             RAISE '%', rsp_main.errm; 
         END IF;   
    END IF;
    --
    IF (_nso_prop.view_create) 
    THEN
         rsp_main := nso_structure.nso_p_view_c (_nso_prop.nso_code);
         IF (rsp_main.rc >= 0) THEN
              RAISE NOTICE '<%>, %, OID = "%"', c_ERR_F_NAME, rsp_main.errm, rsp_main.rc;
         ELSE
             RAISE '%', rsp_main.errm; 
         END IF;
    END IF;
    --
    rsp_main := ( _mode, (CASE _mode WHEN 0 THEN c_MESS00 ELSE c_MESS11 END)::text);
    
    RETURN rsp_main; 
 
  EXCEPTION
     WHEN OTHERS THEN
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
        
               _exception.func_name := c_ERR_F_NAME; 
		   
	     rsp_main := (-1, ( com_error.f_error_handling ( _exception, _err_args )));
		   
	     RETURN rsp_main;			
        
      END;
  END;
 $$;

COMMENT ON FUNCTION nso_structure.nso_p_object_put ( public.t_text, public.t_timestamp ) 
   IS '232: Создание НСО. Аргумент - Описание структуры объекта в JSON-формате

Входные параметры:
   1)  p_nso_strct   public.t_text                                  -- Структура НСО в  JSON-формат
   2) ,p_date_create public.t_timestamp = now()::public.t_timestamp -- Дата создания

Выходные параметры:
   1)  rsp_main.rc = < 0/1 > при успешном завершении
       rsp_main.rc = -1 при ошибке
   2)  rsp_main.errm - Строка состояния выполнения запроса';
-- ----------------------------------------------------------------------------
/**
SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_p_object_put ( public.t_text, public.t_timestamp )');  
-----------------------------------------------------------------------------------------------------------------
'nso_p_object_put'|57|'assignment'|'42804'|'target type is different type than source type'|'cast "text" value to "json" type'|'The input expression type does not have an assignment cast to the target type.'|'warning'||''|'at assignment to variable "_js_data_string" declared on line 28'
'nso_p_object_put'|115|'FOR over SELECT rows'|'42P01'|'relation "tmp_nso_object_1" does not exist'|''|''|'error'|15|'SELECT * FROM tmp_nso_object_1'|''
             
**/

-- ЗАМЕЧАНИЕ:  <nso_p_object_put>, Создание НСО выполнено успешно, ID = "115"
-- --------------------------------------------------------------------------------------------
-- ЗАМЕЧАНИЕ:  <nso_p_object_put>, Создание элемента заголовка НСО выполнено успешно, ID = "416"
-- ЗАМЕЧАНИЕ:  <nso_p_object_put>, Создание элемента заголовка НСО выполнено успешно, ID = "417"
