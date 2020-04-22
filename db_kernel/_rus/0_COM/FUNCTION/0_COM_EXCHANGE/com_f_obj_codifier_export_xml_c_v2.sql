/* --------------------------------------------------------------------------------------------------------------------
	Входные параметры:
		1) p_codif_code   t_str60       -- Код
		2) p_is_need_file t_boolean     -- Выгрузка в файл / в результат процедуры
		3) p_dir          t_str1024     -- Каталог
		4) p_date_from    t_timestamp   -- Начало периода актуальности
		5) p_date_to      t_timestamp   -- Окончание периода актуальности
	Выходные параметры:
		1) _result        result_long_t -- Путь к файлу / Результирующий контент / Ошибка
-------------------------------------------------------------------------------------------------------------------- */

DROP FUNCTION IF EXISTS com_exchange.com_f_obj_codifier_export_xml (public.t_str60, public.t_boolean, public.t_filename, public.t_timestamp, public.t_timestamp);
CREATE OR REPLACE FUNCTION com_exchange.com_f_obj_codifier_export_xml
(
    p_codif_code   public.t_str60                    -- Код
   ,p_is_need_file public.t_boolean   DEFAULT true   -- Выгрузка в файл / в результат процедуры
   ,p_dir          public.t_filename  DEFAULT '/tmp' -- Каталог
   ,p_date_from    public.t_timestamp DEFAULT '1970-01-01 00:00:00'::public.t_timestamp -- Начало периода актуальности
   ,p_date_to      public.t_timestamp DEFAULT '9999-12-31 00:00:00'::public.t_timestamp -- Окончание периода актуальности
)
 RETURNS public.result_long_t 
 SET search_path = com_exchange, com, public
  AS 
   $$
   -- ====================================================================================================================
   -- Author: Gregory
   -- Create date: 2015-11-25
   -- Description:	Экспорт кодификатора в XML
   -- 2016-05-29 Gregory Версия 2. Функция-перегрузка
   -- 2019-06-22 Nick Новое ядро
   -- ====================================================================================================================

    DECLARE
      _begin    public.t_text = '<body>';
      _end      public.t_text = '</body>';
	  _file     public.t_filename;
	  _execute  public.t_text;
      _result   public.result_long_t;

	  с_ERR_FUNC_NAME public.t_sysname = 'com_f_obj_codifier_export_xml';
	  _codif_code public.t_str60 := utl.com_f_empty_string_to_null (upper(btrim (p_codif_code)));   -- Код                                                          
	  
      _exception  public.exception_type_t; -- Nick 2019-06-22
      _err_args   public.t_arr_text := ARRAY [''];
      
    BEGIN
     PERFORM com.com_p_com_log_i('D', 'Экспорт ветви кодификатора "' || _codif_code || '" в XML.');-- Nick 2016-05-16 Исправил русский язык.

     IF _codif_code IS NULL
     THEN
             RAISE SQLSTATE '60000'; -- NULL значения запрещены
     END IF;

     IF NOT EXISTS (SELECT 1 FROM ONLY com.obj_codifier WHERE codif_code = _codif_code) -- Nick 2016-05-16 Добавил ONLY
     THEN
           _err_args [1] := _codif_code;
           RAISE SQLSTATE '61041'; -- Запись не найдена 
     END IF;

     -- Gregory 2016-05-29
     DROP TABLE IF EXISTS _tbl_obj_codifier;
     CREATE TEMPORARY TABLE _tbl_obj_codifier (
             codif_uuid  public.t_guid
            ,parent_uuid public.t_guid
            ,codif_code  public.t_str60
            ,codif_name  public.t_str250
            ,small_code  public.t_code1
            ,date_from   public.t_timestamp
            ,date_to     public.t_timestamp
            ,impact      public.t_code1
     )
     ON COMMIT DROP;

     INSERT INTO _tbl_obj_codifier
       WITH RECURSIVE complete AS (
           WITH format AS (
              WITH RECURSIVE branch AS (
                  WITH section AS (
                     WITH history AS (
                         SELECT
                             parent_codif_id
                            ,codif_id
       
                            ,codif_uuid
                            --parent_uuid
                            ,codif_code
                            ,codif_name
                            ,small_code
                            ,date_from
                            ,date_to
                             
                             -- history
                            ,tableoid = 'com.obj_codifier'::regclass::oid AS opr
                            ,row_number() OVER ( PARTITION BY codif_id
                                                 ORDER BY
                                                         date_from ASC
                                                        ,date_to   ASC
                                                        ,id_log    ASC
                                                        ,tableoid  DESC
                             ) AS num
                            ,count(*) OVER ( PARTITION BY codif_id
                             ) AS cnt
                         FROM com.obj_codifier
                     ) -- history
                         SELECT DISTINCT ON (codif_id)
                              pre.parent_codif_id AS previous_parent_id
                             ,cur.parent_codif_id
                             ,cur.codif_id
                             ,cur.codif_uuid
                             --parent_uuid
                             ,cur.codif_code
                             ,cur.codif_name
                             ,cur.small_code
                             ,cur.date_from
                             ,cur.date_to
                             ,CASE
                                  WHEN (cur.num = cur.cnt) AND (cur.opr = FALSE)
                                      THEN 'D'
                                  WHEN cur.num = 1
                                      THEN 'I'
                                  ELSE 'U'
                              END AS impact
                          FROM history cur
                            LEFT JOIN history pre ON (pre.codif_id = cur.codif_id) AND (pre.num = cur.num - 1)
                          WHERE  (cur.date_from <= p_date_to) AND (p_date_from <= cur.date_to)
                          ORDER BY
                                  cur.codif_id, cur.num DESC
                  ) -- section
                    SELECT
                          previous_parent_id
                         ,parent_codif_id
                         ,codif_id
                         ,codif_uuid
                         --parent_uuid
                         ,codif_code
                         ,codif_name
                         ,small_code
                         ,date_from
                         ,date_to
                         ,impact
                         ,'N' AS role
                  FROM section WHERE (codif_code = _codif_code)
       
                  UNION
       
                  SELECT
                      sec.previous_parent_id
                     ,sec.parent_codif_id
                     ,sec.codif_id
                     ,sec.codif_uuid
                     --parent_uuid
                     ,sec.codif_code
                     ,sec.codif_name
                     ,sec.small_code
                     ,sec.date_from
                     ,sec.date_to
                     ,sec.impact
                     ,CASE
                           WHEN (sec.codif_id = bra.parent_codif_id)
                                 AND (bra.role = 'N' OR bra.role = 'P')
                            THEN 'P'
                            
                           WHEN (sec.codif_id = bra.parent_codif_id)
                                AND (bra.role = 'PC' OR bra.role = 'PPC')
                            THEN 'PPC'
                            
                           WHEN (sec.parent_codif_id != bra.codif_id)
                                AND (sec.previous_parent_id = bra.codif_id)
                            THEN 'PC'
                            
                           ELSE 'C'
                      END AS role
                  FROM 
                          branch bra, section sec
                  WHERE
                       ((sec.codif_id = bra.parent_codif_id) AND (bra.role != 'C'))
                          OR 
                       (((sec.parent_codif_id = bra.codif_id) OR (sec.previous_parent_id = bra.codif_id))
                              AND 
                         ((bra.role = 'N') OR (bra.role = 'C'))
                       )
              ) -- branch
              --
              SELECT DISTINCT ON (cur.codif_id)
                  cur.codif_uuid
                 ,par.codif_uuid AS parent_uuid
                 ,cur.codif_code
                 ,cur.codif_name
                 ,cur.small_code
                 ,cur.date_from
                 ,cur.date_to
                 ,CASE
                       WHEN (cur.role = 'N') OR (cur.role = 'C')
                       THEN cur.impact
                       ELSE 'T'
                  END AS impact
              FROM branch cur
               LEFT JOIN branch par ON (par.codif_id = cur.parent_codif_id)
              ORDER BY cur.codif_id, cur.role ASC
           ) -- format
           SELECT
                   codif_uuid
                  ,parent_uuid
                  ,codif_code
                  ,codif_name
                  ,small_code
                  ,date_from
                  ,date_to
       
                  ,impact
           FROM format
           WHERE 
                 (p_date_from = p_date_to) 
                     OR 
                 ((p_date_from != p_date_to)
                       AND 
                  ((p_date_from <= date_from) OR (date_to <= p_date_to))
                 )
                   
           UNION
       
           SELECT
                   frm.codif_uuid
                  ,frm.parent_uuid
                  ,frm.codif_code
                  ,frm.codif_name
                  ,frm.small_code
                  ,frm.date_from
                  ,frm.date_to
                  ,frm.impact
           FROM
                 complete com, format frm
           WHERE (frm.codif_uuid = com.parent_uuid)
       ) -- complete
       SELECT
             codif_uuid
            ,parent_uuid
            ,codif_code
            ,codif_name
            ,small_code
            ,date_from
            ,date_to
            ,impact
       FROM complete;
     --
     -- Nick 2019-06-23 Заполнена "_tbl_obj_codifier".
     --
     DROP TABLE IF EXISTS _tbl_xml;
     CREATE TEMPORARY TABLE _tbl_xml (
             unit_name public.t_str60
            ,xml_text  public.t_text
     )
     ON COMMIT DROP;

     INSERT INTO _tbl_xml
     SELECT
             'info'
            ,'<codif_code>' || _codif_code || '</codif_code>' ||
                     '<date_from>' || p_date_from || '</date_from>' ||
                     '<date_to>' || p_date_to || '</date_to>';
     --
     INSERT INTO _tbl_xml
             SELECT
                     'codifiers'
                    ,query_to_xml (
                             'SELECT
                                     codif_uuid
                                    ,parent_uuid
                                    ,codif_code
                                    ,codif_name
                                    ,small_code
                                    ,date_from
                                    ,date_to
                                     
                                    ,impact
                             FROM _tbl_obj_codifier'
                            ,true
                            ,true
                            ,''
                     );
     -- Gregory 2016-05-29

     _file = p_dir || '/' || 'com_obj_codifier_' || _codif_code || '_' ||
             replace (replace (((current_timestamp)::public.t_timestamp)::public.t_str100, ':', '-'), ' ', '-') ||
             '.xml';

     -- Gregory 2016-05-29
     IF p_is_need_file IS TRUE
     THEN
             _execute =
                     'COPY (
                             SELECT ''<?xml version="1.0" encoding="UTF-8"?>' ||
                                     _begin || ''' ||
                                     regexp_replace (
                                             string_agg (
                                                     ''<'' || unit_name || ''>'' ||
                                                     xml_text ||
                                                     ''</'' || unit_name || ''>''
                                                    ,''''
                                             )
                                            ,''[\n\r]+''
                                            ,''''
                                            ,''g''
                                     ) ||
                                     ''' || _end || ''' 
                             FROM _tbl_xml
                     ) TO ''' || _file || '''';
             EXECUTE _execute;
             _result := ( 0, _file );
     ELSE
             _execute =
                     'SELECT
                             ''' || _begin || ''' ||
                             regexp_replace (
                                     string_agg (
                                             ''<'' || unit_name || ''>'' ||
                                             xml_text ||
                                             ''</'' || unit_name || ''>''
                                            ,''''
                                     )
                                    ,''[\n\r]+''
                                    ,''''
                                    ,''g''
                             ) ||
                             ''' || _end || ''' 
                     FROM _tbl_xml;';
             EXECUTE _execute INTO _result.errm;
             _result.rc = 1;
     END IF;
     -- Gregory 2016-05-29

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
         	
         	_result := (-1, ( com_error.f_error_handling ( _exception, _err_args )))::public.result_long_t;
          RETURN _result;			
        END;
    END;
   $$
LANGUAGE plpgsql SECURITY INVOKER;

COMMENT ON FUNCTION com_exchange.com_f_obj_codifier_export_xml (public.t_str60, public.t_boolean, public.t_filename, public.t_timestamp, public.t_timestamp)
IS '85: Экспорт кодификатора в XML.

	Входные параметры:
		1) p_codif_code   public.t_str60       -- Код
		2) p_is_need_file public.t_boolean     -- Выгрузка в файл / в результат процедуры DEFAULT true
		3) p_dir          public.t_filename    -- Каталог                                 DEFAULT ''/tmp''
		4) p_date_from    public.t_timestamp   -- Начало периода актуальности             DEFAULT ''1970-01-01 00:00:00''
		5) p_date_to      public.t_timestamp   -- Окончание периода актуальности          DEFAULT ''9999-12-31 00:00:00''
		
	Выходные параметры:
		1) _result        public.result_long_t -- Путь к файлу / Результирующий контент / Ошибка';
-- -------------------------------------------------------------------------------------------------------------------
-- SELECT * FROM com_codifier.com_f_obj_codifier_s_sys ();
-- SELECT * FROM com_codifier.com_f_obj_codifier_s_sys ('C_KEY_TYPE2'); -- 8 rows
--
-- SELECT * FROM com_exchange.com_f_obj_codifier_export_xml ('C_KEY_TYPE2'); 
-- 0;"/tmp/com_obj_codifier_C_KEY_TYPE_2019-06-23-18-31-35.xml"
-- SELECT * FROM com.com_f_obj_codifier_export_xml ('C_OKR', TRUE, '/tmp', now()::t_timestamp, now()::t_timestamp);
