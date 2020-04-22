/* -----------------------------------------------------------------------------------------------------	Входные параметры:
		1) p_file   t_filename -- Файл
                2) c_DEBUG t_boolean  -- Переменная для управления режимом отладки
                3) p_xml    t_text     -- содержание <body>...</body>
	Выходные параметры:
		1) _result        result_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение
----------------------------------------------------------------------------------------------------- */
;

DROP FUNCTION IF EXISTS com_exchange.com_p_nso_domain_column_import_xml (public.t_filename, public.t_text);
CREATE OR REPLACE FUNCTION com_exchange.com_p_nso_domain_column_import_xml
(
        p_file  public.t_filename DEFAULT NULL  -- Файл  Nick 2016-04-05
       ,p_xml   public.t_text     DEFAULT NULL  -- содержание <body>...</body> DEFAULT NULL
)
 RETURNS public.result_long_t 																																																																							
 SET search_path = com_exchange, com_domain, com_codifier, nso_structure, nso, com, public
AS 																		
 $$
    -- ==========================================================================================
    -- Author: Gregory
    -- Create date: 2016-01-25
    -- Description:	Импорт домена колонки из XML
    --  2016-04-05 Nick - для имени файла использую домен t_filename, e.g. varchar(1024) 
    --  2016-06-24 Gregory Добавлена информация по объектам
    --  2019-07-09 Nick Новое ядро.
    -- ==========================================================================================
 
   DECLARE
        _root_code public.t_str60;
        _date_from public.t_timestamp;
        _date_to   public.t_timestamp;
        _execute   public.t_text;
        _current   record;
        _result    public.result_long_t;
        --
        с_ERR_FUNC_NAME public.t_sysname = 'com_p_nso_domain_column_import_xml';
    	C_MESS00        public.t_text := 'Импорт выполнен успешно';
        c_DEBUG         public.t_boolean := utl.f_debug_status();

       _exception  public.exception_type_t; -- Nick 2019-06-22
        
   BEGIN
     IF (p_file IS NULL) AND (p_xml IS NULL)  -- Nick 2019-06-22
       THEN
             RAISE SQLSTATE '60000';
     END IF;
     
     DROP TABLE IF EXISTS _tbl_xml;
     CREATE TEMPORARY TABLE _tbl_xml(id serial, data xml) ON COMMIT DROP;

     IF p_xml IS NULL 
     THEN
             _execute = 'COPY _tbl_xml(data) FROM ''' || p_file || ''' ENCODING ''UTF8''';
             IF c_DEBUG
             THEN
                     RAISE NOTICE '<%>, %', с_ERR_FUNC_NAME, _execute;
             END IF;
             EXECUTE _execute;
     ELSE
             INSERT INTO _tbl_xml(data) VALUES (p_xml::xml);
     END  IF;

     SELECT 
             NULLIF (attr_code, NULL)::public.t_str60
            ,NULLIF (date_from, NULL)::public.t_timestamp
            ,NULLIF (date_to,   NULL)::public.t_timestamp
     INTO
             _root_code
            ,_date_from
            ,_date_to
            
     FROM xpath_table (
             'id'
            ,'data'
            ,'_tbl_xml'
            ,'info/attr_code'
                     || '|info/date_from'
                     || '|info/date_to'
            ,'1 = 1'
     )
     AS t (
             id integer
            ,attr_code public.t_str60
            ,date_from public.t_timestamp
            ,date_to   public.t_timestamp
     );

     DROP TABLE IF EXISTS _tbl_nso_object;
     CREATE TEMPORARY TABLE _tbl_nso_object (
             parent_nso_code public.t_str60
            ,nso_type_code   public.t_str60
            ,nso_code        public.t_str60
            ,nso_name        public.t_str250
            ,nso_uuid        public.t_guid
            ,is_group_nso    public.t_boolean
            ,date_from       public.t_timestamp
            ,date_to         public.t_timestamp
            ,tree_role       public.t_code1
     )
     ON COMMIT DROP;

     INSERT INTO _tbl_nso_object (
             parent_nso_code
            ,nso_type_code
            ,nso_code
            ,nso_name
            ,nso_uuid
            ,is_group_nso
            ,date_from
            ,date_to
            ,tree_role
     )
     SELECT
             NULLIF (parent_nso_code, '')::public.t_str60
            ,NULLIF (nso_type_code,   '')::public.t_str60
            ,NULLIF (nso_code,        '')::public.t_str60
            ,NULLIF (nso_name,        '')::public.t_str250
            ,NULLIF (nso_uuid,      NULL)::public.t_guid
            ,NULLIF (is_group_nso,  NULL)::public.t_boolean
            ,NULLIF (date_from,     NULL)::public.t_timestamp
            ,NULLIF (date_to,       NULL)::public.t_timestamp
            ,NULLIF (tree_role,       '')::public.t_code1
     FROM xpath_table (
             'id'
            ,'data'
            ,'_tbl_xml'
            ,'objects/row/parent_nso_code'
                     || '|objects/row/nso_type_code'
                     || '|objects/row/nso_code'
                     || '|objects/row/nso_name'
                     || '|objects/row/nso_uuid'
                     || '|objects/row/is_group_nso'
                     || '|objects/row/date_from'
                     || '|objects/row/date_to'
                     || '|objects/row/tree_role'
            ,'1 = 1'
     )
      AS t (
              id integer
             ,parent_nso_code  public.t_str60
             ,nso_type_code    public.t_str60
             ,nso_code         public.t_str60
             ,nso_name         public.t_str250
             ,nso_uuid         public.t_guid
             ,is_group_nso     public.t_boolean
             ,date_from        public.t_timestamp
             ,date_to          public.t_timestamp
             ,tree_role        public.t_code1
      );

     FOR _current IN
             WITH RECURSIVE tree AS (
                     SELECT
                             parent_nso_code
                            ,nso_type_code
                            ,nso_code
                            ,nso_name
                            ,nso_uuid
                            ,is_group_nso
                            ,date_from
                            ,date_to
                            ,tree_role
                     FROM _tbl_nso_object
                     WHERE parent_nso_code IS NULL

                     UNION

                     SELECT
                             o.parent_nso_code
                            ,o.nso_type_code
                            ,o.nso_code
                            ,o.nso_name
                            ,o.nso_uuid
                            ,o.is_group_nso
                            ,o.date_from
                            ,o.date_to
                            ,o.tree_role
                     FROM
                             tree t
                            ,_tbl_nso_object o
                     WHERE o.parent_nso_code = t.nso_code
             )
             SELECT
                     parent_nso_code
                    ,nso_type_code
                    ,nso_code
                    ,nso_name
                    ,nso_uuid
                    ,is_group_nso
                    ,date_from
                    ,date_to
                    ,tree_role
             FROM tree
      LOOP
          IF NOT EXISTS (
                           SELECT 1 FROM ONLY nso.nso_object WHERE nso_code = _current.nso_code
                           LIMIT 1
          )
          THEN
               IF c_DEBUG
               THEN
                    RAISE NOTICE '<%> INSERT nso_object %, role %, name "%"',
                                         с_ERR_FUNC_NAME, _current.nso_code, _current.tree_role, _current.nso_name;
               END IF;
               _result = nso_structure.nso_p_object_i (
                       _current.parent_nso_code
                      ,_current.nso_type_code
                      ,_current.nso_code
                      ,_current.nso_name
                      ,_current.nso_uuid
                      ,_current.is_group_nso
                      ,_current.date_from    -- Nick 2019-07-15
                      ,_current.date_to
               );
               IF _result.rc < 0
               THEN
                      RAISE EXCEPTION '<%> %', с_ERR_FUNC_NAME, _result.errm;
                   ELSE   
                      IF c_DEBUG
                        THEN
                            RAISE NOTICE '<%> INSERT nso_object % ', с_ERR_FUNC_NAME, _result.errm;
                      END IF;
               END IF;                  
          ELSE
                  IF c_DEBUG
                  THEN
                       RAISE NOTICE '<%> EXISTS nso_object % (%)', 
                                          с_ERR_FUNC_NAME,  _current.nso_code, _current.tree_role;
                  END IF;
          END IF;
      END LOOP;

     DROP TABLE IF EXISTS _tbl_nso_domain_column;
     CREATE TEMPORARY TABLE _tbl_nso_domain_column (
             parent_attr_code public.t_str60 
            ,attr_type_code   public.t_str60 
            ,attr_code        public.t_str60
            ,attr_name        public.t_str250
            ,attr_uuid        public.t_guid
            ,nso_code         public.t_str60
            ,date_from        public.t_timestamp
            ,date_to          public.t_timestamp
            ,is_intra_op      public.t_boolean
            ,impact           public.t_code1
     )
     ON COMMIT DROP;

     INSERT INTO _tbl_nso_domain_column
     (
             parent_attr_code 
            ,attr_type_code 
            ,attr_code
            ,attr_name
            ,attr_uuid
            ,nso_code
            ,date_from
            ,date_to
            --,doc_uuid
            ,is_intra_op
            ,impact
     )
     SELECT
             NULLIF (parent_attr_code, '')::public.t_str60
            ,NULLIF (attr_type_code,   '')::public.t_str60
            ,NULLIF (attr_code,        '')::public.t_str60
            ,NULLIF (attr_name,        '')::public.t_str250
            ,CASE  -- Nick 2016-03-22  Зачем это, не понимаю.
                     WHEN attr_uuid = ''
                     THEN NULL
                     ELSE attr_uuid
             END::t_guid  
            ,NULLIF (nso_code,      '')::public.t_str60
            ,NULLIF (date_from,   NULL)::public.t_timestamp
            ,NULLIF (date_to,     NULL)::public.t_timestamp
            ,NULLIF (is_intra_op, NULL)::public.t_boolean
            ,NULLIF (impact,        '')::public.t_code1
     FROM xpath_table
     (
             'id'
            ,'data'
            ,'_tbl_xml'
            ,'domains/row/parent_attr_code'
                     || '|domains/row/attr_type_code'
                     || '|domains/row/attr_code'
                     || '|domains/row/attr_name'
                     || '|domains/row/attr_uuid'
                     || '|domains/row/nso_code'
                     || '|domains/row/date_from'
                     || '|domains/row/date_to'
                     || '|domains/row/is_intra_op'
                     || '|domains/row/impact'
            ,'1 = 1'
     )
     AS t
     (
             id               integer
            ,parent_attr_code public.t_str60 
            ,attr_type_code   public.t_str60 
            ,attr_code        public.t_str60
            ,attr_name        public.t_str250
            ,attr_uuid        varchar -- t_guid
            ,nso_code         public.t_str60
            ,date_from        public.t_timestamp
            ,date_to          public.t_timestamp
            ,is_intra_op      public.t_boolean
            ,impact           public.t_code1
     );

--      IF c_DEBUG THEN
--              RAISE NOTICE '<%>, 1) IMPORT %', с_ERR_FUNC_NAME, _root_code;        
--      END IF;
     
     PERFORM com.com_p_com_log_i('G', 'Импорт ветви домена колонок "' || _root_code || '" из XML.');

     FOR _current IN
        WITH RECURSIVE t AS
        (
             SELECT
                     parent_attr_code 
                    ,attr_type_code 
                    ,attr_code
                    ,attr_name
                    ,attr_uuid
                    ,nso_code
                    ,date_from
                    ,date_to
                    --,doc_uuid
                    ,is_intra_op
                    ,impact
             FROM _tbl_nso_domain_column
             WHERE parent_attr_code IS NULL --attr_code = _root_code
     
             UNION
     
             SELECT
                     d.parent_attr_code 
                    ,d.attr_type_code 
                    ,d.attr_code
                    ,d.attr_name
                    ,d.attr_uuid
                    ,d.nso_code
                    ,d.date_from
                    ,d.date_to
                    --,doc_uuid
                    ,d.is_intra_op
                    ,d.impact
             FROM _tbl_nso_domain_column d, t
             WHERE d.parent_attr_code = t.attr_code
        )
         SELECT
             parent_attr_code 
            ,attr_type_code 
            ,attr_code
            ,attr_name
            ,attr_uuid
            ,nso_code
            ,date_from
            ,date_to
            --,doc_uuid
            ,is_intra_op
            ,impact
     FROM t

     LOOP
        IF EXISTS (SELECT 1 FROM ONLY com.nso_domain_column WHERE attr_code = _current.attr_code)
        THEN
                IF ( _current.impact = 'T' )
--                    AND (
--                          SELECT (par.attr_code = _current.parent_attr_code) OR
--                                  (
--                                          par.attr_code IS NULL
--                                      AND _current.parent_attr_code IS NULL
--                                  )
--                          FROM ONLY com.nso_domain_column cur
--                          LEFT JOIN ONLY com.nso_domain_column par ON (par.attr_id = cur.parent_attr_id)
--                          WHERE (cur.attr_code = _current.attr_code)
--                        )
                THEN    
                        IF c_DEBUG THEN
                           RAISE NOTICE '<%> 2) CHECK % impact="%"', с_ERR_FUNC_NAME, _current.attr_code, _current.impact;
                        END IF;
                ELSIF _current.impact = 'D'
                THEN    IF c_DEBUG THEN
                             RAISE NOTICE '<%> 3) DELETE %', с_ERR_FUNC_NAME, _current.attr_code;
                        END IF;
                        _result = com_domain.nso_p_domain_column_d(_current.attr_code);
                ELSE
                   IF c_DEBUG THEN
                      RAISE NOTICE '<%>, 4) UPDATE %', с_ERR_FUNC_NAME, _current.attr_code;
                      RAISE NOTICE '<%>, 4.1) UPDATE %', с_ERR_FUNC_NAME, _current;
                   END IF;
                        
                   _result = com_domain.nso_p_domain_column_u (
                           -- Nick 2019-07-10
                           com_domain.com_f_domain_get_id (_current.attr_code)
                          ,com_domain.com_f_domain_get_id (_current.parent_attr_code)
                          -- Nick 2019-07-10
                          ,com_codifier.com_f_obj_codifier_get_id ( _current.attr_type_code )  
                          ,_current.is_intra_op
                          ,_current.attr_code
                          ,_current.attr_name
                          ,(SELECT nso_id FROM ONLY nso.nso_object WHERE nso_code = _current.nso_code)
                          ,_current.attr_uuid -- --  2016-06-30 Gregory
                   );

                   IF c_DEBUG THEN
                         RAISE NOTICE '<%> 4.2) UPDATE _result = %', с_ERR_FUNC_NAME, _result;
                   END IF;
                END IF;
        ELSE
                IF (c_DEBUG) THEN
                   RAISE NOTICE '<%> 5) INSERT %', с_ERR_FUNC_NAME, _current.attr_code;
                END IF;
                --
                _result = com_domain.nso_p_domain_column_i (
                        _current.parent_attr_code
                       ,_current.attr_type_code
                       ,_current.attr_code
                       ,_current.attr_name
                       ,_current.attr_uuid
                       ,_current.nso_code
                       ,_current.date_from  -- 2019-07-15 Nick
                       ,_current.date_to
                );
        END IF;
        --
        IF _result.rc < 0
        THEN
             RAISE EXCEPTION '%', _result.errm;
        ELSE     
             IF c_DEBUG THEN 
                  RAISE NOTICE '<%>, %', с_ERR_FUNC_NAME, _result.errm;
             END IF;   
        END IF;
     END LOOP;

     _result := (0, C_MESS00)::public.result_long_t;
        
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
   LANGUAGE plpgsql SECURITY DEFINER;
   
COMMENT ON FUNCTION com_exchange.com_p_nso_domain_column_import_xml (public.t_filename, public.t_text)
IS '135: Импорт домена колонки из XML.
	Входные параметры:
            1) p_file   t_filename -- Файл
            2) p_xml    t_text     -- содержание <body>...</body>
	Выходные параметры:
		1) _result        result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение';
-------------------------------------------------------------------------------------------------------------------------
--  SELECT utl.f_debug_on();
--  SELECT * FROM plpgsql_check_function_tb('com_exchange.com_p_nso_domain_column_import_xml (public.t_filename, public.t_text)');
--  SELECT * FROM plpgsql_show_dependency_tb ('com_exchange.com_p_nso_domain_column_import_xml (public.t_filename, public.t_text)');

-- SELECT * FROM com_domain.nso_f_domain_column_s ('APP_NODE');
-- SELECT * FROM com.com_f_com_log_s ();
-- SELECT * FROM nso.nso_f_nso_log_s ();
-- SELECT * FROM nso_structure.nso_f_object_s_sys();
