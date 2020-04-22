/* --------------------------------------------------------------------------------------------------------------------
	Входные параметры:
		1) p_file   t_filename -- Файл
                2) IS_DBG t_boolean  -- Переменная для управления режимом отладки
                3) p_xml    t_text     -- содержание <body>...</body>
	Выходные параметры:
		1) _result        result_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение
-------------------------------------------------------------------------------------------------------------------- */

DROP FUNCTION IF EXISTS com_exchange.com_p_obj_codifier_import_xml (public.t_filename, public.t_text);
CREATE OR REPLACE FUNCTION com_exchange.com_p_obj_codifier_import_xml
(
        p_file public.t_filename = NULL -- Файл
       ,p_xml  public.t_text     = NULL -- содержание <body>...</body> DEFAULT NULL
                
)
 RETURNS public.result_long_t
 SET search_path = com_exchange, com, public
AS 
  $$
    -- ====================================================================================================
    -- Author: Gregory
    -- Create date: 2015-11-25
    -- Description:	Импорт кодификатора из XML
    -- Modification: 2016-01-10  Nick. Несколько замечаний с исправлениями самых существенных мест.
    --               2016-04-05  Nick. Для имени файла - домен t_filename
    --               2016-05-29  Gregory Версия 2
    --               2017-01-29  Gregory Приведение к общему стандарту
    --   2019-06-22 Nick  Новое ядро.
    -- ====================================================================================================
    DECLARE
        _root_code  public.t_str60;
        _codif_code public.t_str60;
        _date_from  public.t_timestamp;
        _date_to    public.t_timestamp;
        _execute    public.t_text;
        _result     public.result_long_t;  -- Nick 2019-06-22
        _current record;
            
    	с_ERR_FUNC_NAME public.t_sysname = 'com_p_obj_codifier_import_xml';
    	IS_DBG public.t_boolean := utl.f_debug_status();
    	
    	C_MESS00 public.t_text := 'Импорт выполнен успешно';

      _exception  public.exception_type_t; -- Nick 2019-06-22

    BEGIN
        IF (p_file IS NULL) AND (p_xml IS NULL)  -- Nick 2019-06-22
          THEN
                RAISE SQLSTATE '60000';
        END IF;
        --
        DROP TABLE IF EXISTS _tbl_xml;
        CREATE TEMPORARY TABLE _tbl_xml(id serial, data xml) ON COMMIT DROP;
    
        IF p_xml IS NULL 
        THEN
                _execute = 'COPY _tbl_xml(data) FROM ''' || p_file || ''' ENCODING ''UTF8''';
                IF IS_DBG
                THEN
                        RAISE NOTICE '<%>, %', с_ERR_FUNC_NAME, _execute;
                END IF;
                EXECUTE _execute;
        ELSE
                INSERT INTO _tbl_xml(data) VALUES (p_xml::xml);
        END  IF;
    
        -- Gregory 2016-05-29
        SELECT 
                NULLIF (codif_code, NULL)::public.t_str60
               ,NULLIF (date_from, NULL)::public.t_timestamp
               ,NULLIF (date_to, NULL)::public.t_timestamp
        INTO
                _codif_code
               ,_date_from
               ,_date_to
        FROM xpath_table (
                'id'
               ,'data'
               ,'_tbl_xml'
               ,'info/codif_code'
                        || '|info/date_from'
                        || '|info/date_to'
               ,'1 = 1'
        )
        AS t (
                id         integer
               ,codif_code public.t_str60
               ,date_from  public.t_timestamp
               ,date_to    public.t_timestamp
        );
        -- Gregory 2016-05-29
    
        IF IS_DBG
        THEN
                RAISE NOTICE '<%>, codif_code = %', с_ERR_FUNC_NAME, _codif_code;
        END IF;
        -- _codif_code := 'C_CODIF_ROOT';
        PERFORM com.com_p_com_log_i ('E', 'Импорт ветви кодификатора "' || _codif_code || '" из XML.');
        -- Nick 2016-12-23
    
        DROP TABLE IF EXISTS _tbl_obj_codifier;
        CREATE TEMPORARY TABLE _tbl_obj_codifier
        (
                codif_uuid  public.t_guid
               ,parent_uuid public.t_guid
               ,small_code  public.t_code1
               ,codif_code  public.t_str60
               ,codif_name  public.t_str250
               ,date_from   public.t_timestamp
               ,date_to     public.t_timestamp
               ,impact      public.t_code1
        )
        ON COMMIT DROP;
    
        INSERT INTO _tbl_obj_codifier
        (
                codif_uuid
               ,parent_uuid
               ,small_code
               ,codif_code
               ,codif_name
               ,date_from
               ,date_to
               ,impact
        )
        SELECT
                NULLIF (codif_uuid, NULL)::public.t_guid
               ,(CASE WHEN parent_uuid = '' THEN NULL ELSE parent_uuid END)::public.t_guid --NULLIF(parent_uuid, NULL)::t_guid
               ,NULLIF (small_code, '')::public.t_code1
               ,NULLIF (codif_code, '')::public.t_str60
               ,NULLIF (codif_name, '')::public.t_str250
               ,NULLIF (date_from, NULL)::public.t_timestamp
               ,NULLIF (date_to, NULL)::public.t_timestamp
               ,NULLIF (impact, NULL)::public.t_code1
        FROM xpath_table
        (
                'id'
               ,'data'
               ,'_tbl_xml'
               ,'codifiers/row/codif_uuid'
                        || '|codifiers/row/parent_uuid'
                        || '|codifiers/row/small_code'
                        || '|codifiers/row/codif_code'
                        || '|codifiers/row/codif_name'
                        || '|codifiers/row/date_from'
                        || '|codifiers/row/date_to'
                        || '|codifiers/row/impact'
               ,'1 = 1'
        )
        AS t
        (
                id          integer
               ,codif_uuid  public.t_guid
               ,parent_uuid varchar --t_guid
               ,small_code  public.t_code1
               ,codif_code  public.t_str60
               ,codif_name  public.t_str250
               ,date_from   public.t_timestamp
               ,date_to     public.t_timestamp
               ,impact      public.t_code1
        );
    
        -- ----------------------------------------------------------------
        -- Корень один и он всегда во вне временной таблицы Nick 2016-01-10
        -- ----------------------------------------------------------------
        SELECT codif_code INTO _root_code FROM _tbl_obj_codifier
        WHERE  (parent_uuid IS NULL ) OR 
                parent_uuid IN ( SELECT parent_uuid FROM _tbl_obj_codifier
                                    EXCEPT
                                 SELECT codif_uuid FROM _tbl_obj_codifier
                               );
        FOR _current IN
        WITH RECURSIVE t AS
        (
                SELECT
                        codif_uuid
                       ,parent_uuid
                       ,small_code
                       ,codif_code
                       ,codif_name
                       ,date_from
                       ,date_to
                       ,impact
                FROM _tbl_obj_codifier
                WHERE codif_code = _root_code
        
                UNION
        
                SELECT
                        c.codif_uuid
                       ,c.parent_uuid
                       ,c.small_code
                       ,c.codif_code
                       ,c.codif_name
                       ,c.date_from
                       ,c.date_to
                       ,c.impact
                FROM _tbl_obj_codifier c, t
                WHERE c.parent_uuid = t.codif_uuid
        )
        SELECT
                codif_uuid
               ,parent_uuid
               ,small_code
               ,codif_code
               ,codif_name
               ,date_from
               ,date_to
               ,impact
        FROM t
    
        LOOP
           IF EXISTS (SELECT 1 FROM ONLY com.obj_codifier 
                                       WHERE codif_code = _current.codif_code LIMIT 1
                     )
           THEN
               IF _current.impact = 'T'
               THEN
                    IF IS_DBG
                    THEN
                        RAISE NOTICE '<%>, CHECK % (%)', с_ERR_FUNC_NAME, _current.codif_code, _current.impact;
                    END IF;
               ELSIF _current.impact = 'D'
               THEN
                    IF IS_DBG
                    THEN
                         RAISE NOTICE '<%>, DELETE % (%)', с_ERR_FUNC_NAME, _current.codif_code, _current.impact;
                    END IF;
                    --
                    _result = com_codifier.obj_p_codifier_d (_current.codif_code);
               ELSE
                    IF IS_DBG
                    THEN
                        RAISE NOTICE '<%>, UPDATE % (%)', с_ERR_FUNC_NAME, _current.codif_code, _current.impact;
                    END IF;
                    --
                    _result = com_codifier.obj_p_codifier_u
                    (
                        _current.codif_code
                       ,(SELECT codif_code FROM _tbl_obj_codifier WHERE codif_uuid = _current.parent_uuid)
                       ,_current.codif_name
                       ,_current.small_code
                    --   ,_current.date_from
                    --   ,NULL
                       ,_current.codif_uuid
                    );
               END IF;
           ELSE
              IF _current.impact = 'D'
              THEN
                    IF IS_DBG
                    THEN
                         RAISE NOTICE '<%>, PASS % (%)', с_ERR_FUNC_NAME, _current.codif_code, _current.impact;
                    END IF;
              ELSE
                    IF IS_DBG
                    THEN
                         RAISE NOTICE '<%>, INSERT % (%)', с_ERR_FUNC_NAME, _current.codif_code, _current.impact;
                    END IF;
                    _result = com_codifier.obj_p_codifier_i
                    (
                        COALESCE (
                                  (SELECT codif_code FROM _tbl_obj_codifier WHERE codif_uuid = _current.parent_uuid)
                                 ,(SELECT codif_code FROM ONLY com.obj_codifier WHERE parent_codif_id IS NULL)
                        )
                       ,_current.codif_code
                       ,_current.codif_name
                       ,_current.codif_uuid
                       ,_current.small_code
                       ,_current.date_from
                    );
              END IF;
           END IF;
           -- -----------------------------------------------------------------------------
           -- Где диагностика ??? Проверяем _result.rc, если <0 то exeption Nick 2016-01-10
           -- -----------------------------------------------------------------------------
           IF _result.rc < 0
           THEN
                   RAISE EXCEPTION '%', _result.errm;
               ELSE
                   IF IS_DBG
                     THEN
                        RAISE NOTICE '<%>, %', с_ERR_FUNC_NAME, _result.errm;  
                   END IF;     
           END IF;
        END LOOP;
    
        _result := (0, C_MESS00);
    	RETURN _result;
    	
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
         
                      _exception.func_name := с_ERR_FUNC_NAME; 
         		
         	   _result := (-1, ( com_error.f_error_handling ( _exception, NULL )));
               RETURN _result;			
       	 END;
    END;
  $$
 LANGUAGE plpgsql 
 SECURITY DEFINER;
 
COMMENT ON FUNCTION com_exchange.com_p_obj_codifier_import_xml (public.t_filename, public.t_text )
IS '167: Импорт кодификатора из XML. 

	Входные параметры:
		     1) p_file   public.t_filename -- Файл
             2) p_xml    public.t_text     -- содержание <body>...</body>

    Должен быть выбран один из двух вариантов импорта: 
                   1 - из внешнего файла "p_file", 
                   2 - либо из переменной-аргумента "p_xml"
             
	Выходные параметры:
		1) _result        result_t        -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm text    -- Сообщение';
--------------------------------------------------------------------------------------------------------------------
-- SELECT utl.f_debug_on();
-- SELECT * FROM com_exchange.com_p_obj_codifier_import_xml ('/tmp/com_obj_codifier_C_CODIF_ROOT_2018-05-22-13-11-24.xml');
-- SELECT * FROM com_exchange.com_p_obj_codifier_import_xml ('/tmp/com_obj_codifier_C_CODIF_ROOT_2018-03-02-11-56-22.xml');
-- SELECT * FROM com_codifier.com_f_obj_codifier_s_sys ();

--0;"/tmp/com_obj_codifier_C_CODIF_ROOT_2018-05-22-13-11-24.xml"
