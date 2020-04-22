/* --------------------------------------------------------------------------------------------------------------------
	Входные параметры:
		1) p_attr_id      public.id_t          -- ID атрибута
		2) p_is_need_file public.t_boolean     -- Выгрузка в файл /в результат процедуры
		3) p_dir          public.t_sysname     -- Каталог
		4) p_date_from    public.t_timestamp   -- Начало периода актуальности
		5) p_date_to      public.t_timestamp   -- Окончание периода актуальности
	Выходные параметры:
		1) _result        public.result_long_t -- Путь к файлу / Результирующий контент / Ошибка
        Особенности:
                если p_date_from равен p_date_to режим выгрузки состояния на дату
                если p_date_from не равен p_date_to режим выгрузки изменений
-------------------------------------------------------------------------------------------------------------------- */

DROP FUNCTION IF EXISTS com_exchange.com_f_nso_domain_column_export_xml ( public.id_t, public.t_boolean, public.t_sysname, public.t_timestamp, public.t_timestamp );
CREATE OR REPLACE FUNCTION com_exchange.com_f_nso_domain_column_export_xml
(
        p_attr_id      public.id_t                         -- ID атрибута
       ,p_is_need_file public.t_boolean    DEFAULT true    -- Выгрузка в файл / в результат процедуры
       ,p_dir          public.t_sysname    DEFAULT '/tmp'  -- Каталог  -- Nick 2016-03-22 -- /xml_data
       ,p_date_from    public.t_timestamp  DEFAULT '1970-01-01 00:00:00'::public.t_timestamp-- Начало периода актуальности
       ,p_date_to      public.t_timestamp  DEFAULT '9999-12-31 00:00:00'::public.t_timestamp-- Окончание периода актуальности
)
RETURNS public.result_long_t 
SET search_path = com, com_exchange, com_codifier, com_domain, nso, public 
AS 
 $$
    -- =========================================================================================================== --
    -- Author: Gregory                                                                                             --
    -- Create date: 2016-01-24                                                                                     --
    -- Description:	Экспорт домена колонки в XML                                                                   --
    -- 2016-05-16  Nick  Функция-перегрузка, аргумент ID атрибута                                                  --
    -- 2016-05-31  Gregory  Возвращаем результат типа public.result_long_t                                         --
    -- 2016-06-24  Gregory  Добавлена информация по объектам                                                       --
    -- 2017-01-16  Nick     Введена вторая константа, ограничивающая область допустимого экспорта двумя ветвями    --
    --                                "APP_NODE"  и  "IND_TECH_NODE".                                              --
    -- 2019-07-13  Nick     Новое ядро                                                                             --
    -- =========================================================================================================== --
 
   DECLARE
    _oper    oid = 'com.nso_domain_column'::regclass::oid; -- 162920
    _query   public.t_text;
    _begin   public.t_text = '<body>';
    _end     public.t_text = '</body>';
    _file    public.t_sysname;
    _execute public.t_text;
    _result  public.result_long_t;

    _attr_code  public.t_str60;     -- Код атрибута Nick 2016-05-16

    c_PATH_CONSTRAINT   public.t_str60 = 'APP_NODE';
    c_PATH_CONSTRAINT_1 public.t_str60 = 'IND_TECH_NODE'; -- Nick 2017-01-16
    c_ERR_FUNC_NAME     public.t_sysname = 'com_f_nso_domain_column_export_xml';

    _exception  public.exception_type_t;
    _err_args   public.t_arr_text := ARRAY [''];
  
   BEGIN
        IF      p_attr_id      IS NULL
             OR p_is_need_file IS NULL
             OR p_dir          IS NULL -- Nick 2016-05-16
             OR p_date_from    IS NULL
             OR p_date_to      IS NULL
        THEN
                RAISE SQLSTATE '60000'; -- NULL значения запрещены
        END IF;

        _attr_code := com_domain.com_f_domain_get_code (p_attr_id);

        IF ( _attr_code IS NULL )
        THEN
                _err_args [1] := _attr_code;
                RAISE SQLSTATE '61074'; -- Запись не найдена 
        END IF;

        PERFORM com.com_p_com_log_i ('F', 'Экспорт ветви домена колонки "' || _attr_code || '" в XML.');

        /* ---------------------------------------------------------------------------------------------------------------------------- --
           ---   Аббревиатуры временной таблицы для колонок role (real - фактическая, part - ограничение по APP_NODE, exp - на экспорт) --
           ---      N   - стартовая запись обхода                                                                                       --
           ---      C   - дочерний элемент                                                                                              --
           ---      P   - родительский элемент                                                                                          --   
           ---      PP  - предыдущий родитель                                                                                           --
           ---      PPP - родитель предыдущего родителя и далее до корня восстанавливается путь с PPP                                   -- 
           ---      PC  - предыдущий ребенок                                                                                            --
           ---      PPC - родитель предыдущего ребенка ... -//-                                                                         --
           ---                                                                                                                          --  
           ---               если элемент до корня служит и основным узлом и узлом предыдущих элементов                                 --
           ---               принимается основной, т.е. DOMAIN_NODE и P и (PPP или PPC) но выводим P                                    -- 
           ---                                                                                                                          --
           ---      R   - используется при обходе ограничения веткой APP_NODE                                                           -- 
           ---            означает что запись вне ее и нужна для восстановления пути перехода записи                                    --  
           ---                                                                                                                          --
           ---   Финал экспорта - текущее состояние записи - результат:                                                                 --   
           ---      I - добавления                                                                                                      --
           ---      U - обновления                                                                                                      --
           ---      D - удаления                                                                                                        --  
           ---                                                                                                                          --
           ---      T - древообразующая запись, нужна для восстановления путей.                                                         --
           ---  ----------------------------------------------------------------------------------------------------------------------- */

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

        DROP TABLE IF EXISTS _tbl_nso_domain_column;
        CREATE TEMPORARY TABLE _tbl_nso_domain_column (
                parent_attr_code  public.t_str60 
               ,attr_type_code    public.t_str60 
               ,attr_code         public.t_str60
               ,attr_name         public.t_str250
               ,attr_uuid         public.t_guid
               ,nso_code          public.t_str60
               ,date_from         public.t_timestamp
               ,date_to           public.t_timestamp
               --,doc_uuid
               ,is_intra_op       public.t_boolean
               ,impact            public.t_code1
               ,role_real         public.t_code5
               ,role_part         public.t_code1
               ,role_exp          public.t_code1
        )
        ON COMMIT DROP;
        
        WITH codifiers AS (
           WITH history AS (
               SELECT
                     codif_id
                    ,codif_code
                    
                    ,date_from
                    ,date_to
                    ,row_number() OVER ( PARTITION BY codif_id
                             ORDER BY 
                                     date_from ASC
                                    ,date_to   ASC
                                    ,id_log    ASC
                                    ,tableoid  DESC
                     ) AS num
               FROM com.obj_codifier
           )
           SELECT DISTINCT ON (codif_id)
                   codif_id
                  ,codif_code
           FROM history
           WHERE
                   date_from <= p_date_to
               AND p_date_from <= date_to
           ORDER BY
                   codif_id
                  ,num DESC
        )
       ,objects AS (
           WITH history AS (
                SELECT
                      -- temp
                      nso_id
                     ,parent_nso_id
                     ,nso_type_id
                     
                      -- export
                   -- parent_nso_code -- I
                   -- nso_type_code   -- I
                     ,nso_code        -- I
                     ,nso_name        -- I
                     ,nso_uuid        -- I
                     ,is_group_nso    -- I
                     ,date_from       -- I
                     ,date_to         -- I
                   -- tree_role
                     
                      -- history
                     ,row_number() OVER ( PARTITION BY nso_id
                              ORDER BY
                                      date_from ASC
                                     ,date_to   ASC
                                     ,id_log    ASC
                                     ,tableoid  DESC
                        ) AS num
                FROM nso.nso_object
           )
           SELECT DISTINCT ON (nso_id)
                   nso_id
                  ,parent_nso_id
                  ,nso_type_id

                -- parent_nso_code
                -- nso_type_code
                  ,nso_code
                  ,nso_name
                  ,nso_uuid
                  ,is_group_nso
                  ,date_from
                  ,date_to
                -- tree_role
           FROM history
           WHERE
                   date_from <= p_date_to
               AND p_date_from <= date_to
           ORDER BY
                   nso_id
                  ,num DESC
        )
       ,domains AS (
            WITH RECURSIVE export AS (
                 WITH RECURSIVE part AS (
                     WITH format AS (
                         WITH RECURSIVE branch AS (
                            WITH section AS (
                               WITH history AS (
                                  SELECT
                                     attr_id
                                     --                              
                                    ,parent_attr_id -- parent_attr_code -- I (U)
                                    ,attr_type_id   -- attr_type_code -- I (U)
                                    ,attr_code      -- I U UU
                                    ,attr_name      -- I U
                                    ,attr_uuid      -- I UU (U)
                                    ,domain_nso_id  -- domain_nso_code -- I (U)
                                    ,date_from      -- I
                                    ,date_to        -- I
                                    --,doc_uuid     -- I
                                    ,is_intra_op    -- U

                                    ,tableoid = _oper AS opr
                                    ,row_number() OVER ( PARTITION BY attr_id
                                             ORDER BY
                                                     date_from ASC
                                                    ,date_to   ASC
                                                    ,id_log    ASC
                                                    ,tableoid  DESC
                                     ) AS num
                                    ,count(*) OVER ( PARTITION BY attr_id ) AS cnt
                                  FROM com.nso_domain_column
                               )
                               SELECT DISTINCT ON (current.attr_id)
                                       current.attr_id
                                      ,previous.parent_attr_id AS previous_parent_id
                                       
                                      ,current.parent_attr_id
                                      ,current.attr_type_id
                                      ,current.attr_code
                                      ,current.attr_name
                                      ,current.attr_uuid
                                      ,current.domain_nso_id
                                      ,current.date_from
                                      ,current.date_to
                                      ,current.is_intra_op
                                      ,CASE
                                          WHEN
                                                  current.num = current.cnt
                                              AND current.opr = FALSE
                                          THEN 'D'
                                          WHEN current.num = 1
                                          THEN 'I'
                                          ELSE 'U'
                                       END AS impact
                               FROM history current
                               LEFT JOIN history previous
                               ON
                                       previous.attr_id = current.attr_id
                                   AND previous.num = current.num - 1
                               WHERE
                                       current.date_from <= p_date_to
                                   AND p_date_from <= current.date_to
                               ORDER BY current.attr_id, current.num DESC
                            )
                            SELECT
                                    attr_id
                                   ,previous_parent_id

                                   ,parent_attr_id
                                   ,attr_type_id
                                   ,attr_code
                                   ,attr_name
                                   ,attr_uuid
                                   ,domain_nso_id
                                   ,date_from
                                   ,date_to
                                   ,is_intra_op
                                   ,impact
                                   ,'N' AS role_real
                            FROM section
                            WHERE attr_code = _attr_code

                            UNION

                            SELECT
                                    section.attr_id
                                   ,section.previous_parent_id
                                    
                                   ,section.parent_attr_id
                                   ,section.attr_type_id
                                   ,section.attr_code
                                   ,section.attr_name
                                   ,section.attr_uuid
                                   ,section.domain_nso_id
                                   ,section.date_from
                                   ,section.date_to
                                   ,section.is_intra_op
                                   ,section.impact
                                   ,CASE
                                        WHEN
                                                section.attr_id = branch.parent_attr_id
                                            AND (
                                                        branch.role_real = 'N'
                                                     OR branch.role_real = 'P'
                                                )
                                        THEN 'P'
                                        WHEN
                                                section.attr_id = branch.parent_attr_id
                                            AND (
                                                        branch.role_real = 'PP'
                                                     OR branch.role_real = 'PPP'
                                                )
                                        THEN 'PPP'
                                        WHEN
                                                section.attr_id = branch.parent_attr_id
                                            AND (
                                                        branch.role_real = 'PC'
                                                     OR branch.role_real = 'PPC'
                                                )
                                        THEN 'PPC'
                                        WHEN
                                                section.attr_id != branch.parent_attr_id
                                            AND section.attr_id = branch.previous_parent_id
                                        THEN 'PP'
                                        WHEN
                                                section.previous_parent_id = branch.attr_id
                                            AND section.parent_attr_id != branch.attr_id
                                        THEN 'PC'
                                        ELSE 'C'
                                    END AS role_real
                            FROM 
                                    branch
                                   ,section
                            WHERE
                                    (
                                            (
                                                    section.attr_id = branch.parent_attr_id
                                                 OR section.attr_id = branch.previous_parent_id
                                            )
                                        AND branch.role_real != 'C'
                                    )
                                 OR (
                                            (
                                                    section.parent_attr_id = branch.attr_id
                                                 OR section.previous_parent_id = branch.attr_id
                                            )
                                        AND (
                                                    branch.role_real = 'N'
                                                 OR branch.role_real = 'C'
                                            )
                                    )
                         )
                         SELECT DISTINCT ON (atr.attr_id)
                                 atr.attr_id
                                ,atr.previous_parent_id
                                ,atr.parent_attr_id
                                ,atr.domain_nso_id

                                ,par.attr_code AS parent_attr_code
                                ,coc.codif_code AS attr_type_code
                                ,atr.attr_code
                                ,atr.attr_name
                                ,atr.attr_uuid
                                ,nno.nso_code AS domain_nso_code
                                ,atr.date_from
                                ,atr.date_to
                                ,atr.is_intra_op
                                ,atr.impact
                                ,atr.role_real
                         FROM branch atr
                         LEFT JOIN branch par    ON par.attr_id  = atr.parent_attr_id
                         LEFT JOIN codifiers coc ON coc.codif_id = atr.attr_type_id
                         LEFT JOIN objects nno   ON nno.nso_id   = atr.domain_nso_id
                         ORDER BY
                                 atr.attr_id
                                ,atr.role_real ASC
                     )
                     SELECT
                             attr_id
                            ,previous_parent_id
                            ,parent_attr_id
                            ,domain_nso_id

                            ,parent_attr_code
                            ,attr_type_code
                            ,attr_code
                            ,attr_name
                            ,attr_uuid
                            ,domain_nso_code
                            ,date_from
                            ,date_to
                            ,is_intra_op
                            ,impact
                            ,role_real
                            ,'N' AS role_part
                     FROM format
                                WHERE attr_code IN ( c_PATH_CONSTRAINT, c_PATH_CONSTRAINT_1 ) -- Nick 2017-01-16

                     UNION

                     SELECT
                             format.attr_id
                            ,format.previous_parent_id
                            ,format.parent_attr_id
                            ,format.domain_nso_id
                     
                            ,format.parent_attr_code
                            ,format.attr_type_code
                            ,format.attr_code
                            ,format.attr_name
                            ,format.attr_uuid
                            ,format.domain_nso_code
                            ,format.date_from
                            ,format.date_to
                            ,format.is_intra_op
                            ,format.impact
                            ,format.role_real
                            ,CASE
                                  WHEN
                                          format.attr_id = part.parent_attr_id
                                      AND part.role_part != 'R'
                                  THEN 'P'
                                  WHEN
                                          format.parent_attr_id = part.attr_id
                                      AND part.role_part != 'R'
                                  THEN 'C'
                                  ELSE 'R'
                             END AS role_part
                     FROM 
                             part
                            ,format
                     WHERE
                             (
                                     (
                                             format.attr_id = part.parent_attr_id
                                          OR format.attr_id = part.previous_parent_id
                                     )
                                 AND part.role_part != 'C'
                             )
                          OR (
                                     (
                                             format.parent_attr_id = part.attr_id
                                          OR format.previous_parent_id = part.attr_id
                                     )
                                 AND part.role_part != 'P'
                             )
                 )
                 (
                         SELECT DISTINCT ON (attr_id)
                                 domain_nso_id
                                 
                                ,parent_attr_code
                                ,attr_type_code
                                ,attr_code
                                ,attr_name
                                ,attr_uuid
                                ,domain_nso_code
                                ,date_from
                                ,date_to
                                ,is_intra_op
                                ,impact
                                ,role_real
                                ,role_part
                         FROM part
                         WHERE
                                 (
                                         p_date_from != p_date_to
                                     AND (
                                                 p_date_from <= date_from
                                              OR date_to <= p_date_to
                                         )
                                 )
                              OR p_date_from = p_date_to
                         ORDER BY
                                 attr_id
                                ,role_part ASC
                 )

                 UNION
                 
                 SELECT
                         part.domain_nso_id
                         
                        ,part.parent_attr_code
                        ,part.attr_type_code
                        ,part.attr_code
                        ,part.attr_name
                        ,part.attr_uuid
                        ,part.domain_nso_code
                        ,part.date_from
                        ,part.date_to
                        ,part.is_intra_op
                        ,part.impact
                        ,part.role_real
                        ,part.role_part
                 FROM
                         export
                        ,part
                 WHERE
                         part.attr_code = export.parent_attr_code
                     AND p_date_from != p_date_to
            )
            SELECT DISTINCT ON (attr_code)
                    domain_nso_id
                   ,parent_attr_code
                   ,attr_type_code
                   ,attr_code
                   ,attr_name
                   ,attr_uuid
                   ,domain_nso_code
                   ,date_from
                   ,date_to
                   ,is_intra_op
                   ,impact
                   ,role_real
                   ,role_part
                   ,CASE
                         WHEN
                                 (
                                         p_date_from != p_date_to
                                     AND (
                                                 p_date_from <= date_from
                                              OR date_to <= p_date_to
                                         )
                                 )
                              OR (
                                         p_date_from = p_date_to
                                     AND (
                                                 role_real = 'N'
                                              OR role_part != 'R'
                                         )
                                 )
                         THEN impact
                         ELSE 'T'
                    END AS role_exp
            FROM export
            WHERE
                    (
                            p_date_from = p_date_to
                        AND (
                                    role_part != 'R'
                                 OR (
                                            role_part = 'R'
                                        AND role_real != 'C'
                                    )
                            )
                    )
                 OR p_date_from != p_date_to
            ORDER BY
                    attr_code
                   ,role_part ASC
        )
       ,lazy AS (
                WITH RECURSIVE tree AS (
                        SELECT 
                                o.nso_id
                               ,o.parent_nso_id
                               ,o.nso_type_id

                             -- parent_nso_code
                             -- nso_type_code
                               ,o.nso_code
                               ,o.nso_name
                               ,o.nso_uuid
                               ,o.is_group_nso
                               ,o.date_from
                               ,o.date_to
                               ,'R' AS tree_role -- ref
                        FROM objects o
                        JOIN domains d
                        ON o.nso_id = d.domain_nso_id
                        
                        UNION

                        SELECT 
                                o.nso_id
                               ,o.parent_nso_id
                               ,o.nso_type_id

                             -- parent_nso_code
                             -- nso_type_code
                               ,o.nso_code
                               ,o.nso_name
                               ,o.nso_uuid
                               ,o.is_group_nso
                               ,o.date_from
                               ,o.date_to
                               ,'T' -- tree
                        FROM
                                tree t
                               ,objects o
                        WHERE o.nso_id = t.parent_nso_id
                )
                INSERT INTO _tbl_nso_object
                SELECT
                        par.nso_code AS parent_nso_code
                       ,cod.codif_code AS nso_type_code
                       ,cur.nso_code
                       ,cur.nso_name
                       ,cur.nso_uuid
                       ,cur.is_group_nso
                       ,cur.date_from
                       ,cur.date_to
                       ,cur.tree_role
                FROM tree cur
                LEFT JOIN tree par
                ON par.nso_id = cur.parent_nso_id
                LEFT JOIN codifiers cod
                ON cod.codif_id = cur.nso_type_id
        )
        INSERT INTO _tbl_nso_domain_column
        SELECT
                parent_attr_code
               ,attr_type_code
               ,attr_code
               ,attr_name
               ,attr_uuid
               ,domain_nso_code
               ,date_from
               ,date_to
               ,is_intra_op
               ,impact
               ,role_real
               ,role_part
               ,role_exp
        FROM domains
        ORDER BY
                attr_code
               ,role_part ASC;
                
        IF EXISTS (
                SELECT 1
                FROM _tbl_nso_domain_column
                LIMIT 1
        )
        THEN
                DROP TABLE IF EXISTS _tbl_xml;
                CREATE TEMPORARY TABLE _tbl_xml (
                        unit_name public.t_str60
                       ,xml_text  public.t_text
                )
                ON COMMIT DROP;
        
                INSERT INTO _tbl_xml
                SELECT
                        'info'
                       ,'<attr_code>' || _attr_code || '</attr_code>' ||
                                '<date_from>' || p_date_from || '</date_from>' ||
                                '<date_to>' || p_date_to || '</date_to>';

                INSERT INTO _tbl_xml
                SELECT
                        'objects'
                       ,query_to_xml (
                                'SELECT
                                        parent_nso_code
                                       ,nso_type_code
                                       ,nso_code
                                       ,nso_name
                                       ,nso_uuid
                                       ,is_group_nso
                                       ,date_from
                                       ,date_to
                                       ,tree_role
                                FROM _tbl_nso_object'
                               ,true
                               ,true
                               ,''
                        );

                INSERT INTO _tbl_xml
                SELECT
                        'domains'
                       ,query_to_xml (
                                'SELECT
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
                                       ,role_exp AS impact
                                FROM _tbl_nso_domain_column'
                               ,true
                               ,true
                               ,''
                        );

                _file = p_dir || '/' || 'com_nso_domain_column_' || upper(btrim(_attr_code)) || '_' ||
                        replace(replace(((current_timestamp)::public.t_timestamp)::public.t_sysname, ':', '-'), ' ', '-') || '.xml';

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
                     _result.errm := _file;
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
                END IF;
        ELSE
                IF p_date_from = p_date_to
                THEN
                        _result.errm := 'Ограничение: ''' || _attr_code || ''' вне ветви ''' || c_PATH_CONSTRAINT || ''', ''' || c_PATH_CONSTRAINT_1 || '''';
                ELSE
                    IF p_date_to < p_date_from
                    THEN
                            _result.errm := 'Ошибка: дата окончания(' || p_date_to || ') меньше даты начала(' || p_date_from || ').';
                    ELSE
                            _result.errm := 'Изменения ''' || _attr_code || ''' не обнаружены.';
                    END IF;
                END IF;
        END IF;

	RETURN ( 0, _result.errm )::public.result_long_t;                 
	
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
		
	   _result := (-1, ( com_error.f_error_handling ( _exception, _err_args )));
			
	   RETURN _result;			
	 END;   
   END;
 $$
LANGUAGE plpgsql SECURITY INVOKER;
COMMENT ON FUNCTION com_exchange.com_f_nso_domain_column_export_xml ( public.id_t, public.t_boolean, public.t_sysname, public.t_timestamp, public.t_timestamp )
IS '162: Экспорт домена колонки в XML.
	Входные параметры:
		1) p_attr_id      public.id_t          -- ID атрибута
		2) p_is_need_file public.t_boolean     -- Выгрузка в файл / в результат процедуры   DEFAULT true
		3) p_dir          public.t_sysname     -- Каталог                                   DEFAULT ''/tmp''
		4) p_date_from    public.t_timestamp   -- Начало периода актуальности               DEFAULT ''1970-01-01 00:00:00''
		5) p_date_to      public.t_timestamp   -- Окончание периода актуальности            DEFAULT ''9999-12-31 00:00:00''
	
	Выходные параметры:
		1) _result        public.result_long_t -- Результат выполнения
        Особенности:
                если p_date_from равен p_date_to режим выгрузки состояния на дату
                если p_date_from не равен p_date_to режим выгрузки изменений';
-- ------------------------------------------------------------------------------------------------------------- --
-- SELECT * FROM com_domain.nso_f_domain_column_s (); -- Все колонки (атрибуты).                                -- 74 rows
-- SELECT * FROM com_domain.nso_f_domain_column_s ('APP_NODE'); -- Прикладные колонки (атрибуты)                -- 29 rows
-- SELECT * FROM com_domain.nso_f_domain_column_s ('IND_TECH_NODE'); -- Все технические колонки                     -- 44 rows
-- SELECT * FROM com.nso_f_domain_column_s ('NSO_TECH_NODE'); -- Технические колонки схемы "НСО"         -- 32 rows
-- SELECT * FROM com.nso_f_domain_column_s ('IND_TECH_NODE'); -- Технические колонки схемы "Показатель". -- 11 rows
