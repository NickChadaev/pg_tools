1) Функция f_show_tbv_descr. Получить описание таблицы/представления.
---------------------------------------------------------------------
Входные параметры:
   	 p_schema_name    VARCHAR (20) -- Наименование схемы
        ,p_object_type    CHAR(1)      -- тип объекта 'r' - таблица, 'v' - представление.

Выходные параметры: 
  (
	 schema_name     VARCHAR  (20)  NOT NULL - Наименование схемы
	,objoid          INTEGER        NOT NULL - OID объекта
	,obj_type        VARCHAR  (20)  NOT NULL - Тип объекта
	,obj_name        VARCHAR  (64)  NOT NULL - Наименование объекта
	,obj_description VARCHAR (250)      NULL - Описание объекта
   )
Пример использования: SELECT * FROM f_show_tbv_descr ( 'com', 'r' );

Результат выполнения: 
---------------------
com  |33934|TABLE|ddl_log       |Журнал изменений структуры
com  |33959|TABLE|error_handling|Таблица ошибок
com  |33940|TABLE|obj_codifier  |Кодификатор ЕМД

2) Функция f_show_col_descr. Получить описание столбцов таблицы/представления.
------------------------------------------------------------------------------
Входные параметры:
       p_schema_name    VARCHAR (20)  -- Наименование схемы
      ,p_obj_name       VARCHAR (64)  -- Наименование объекта
      ,p_object_type    CHAR(1)       -- Тип объекта 'r' - таблица, 'v' - представление.

Выходные параметры: 
 (
        schema_name          VARCHAR  (20)  NOT NULL - Наименование схемы
        objoid               INTEGER        NOT NULL - OID объекта
        obj_type             VARCHAR  (20)  NOT NULL - Тип объекта
        obj_name             VARCHAR  (64)  NOT NULL - Наименование объекта
        attr_number          SMALLINT       NOT NULL - Номер атрибута 
        column_name          VARCHAR  (64)  NOT NULL - Наименование атрибута
        type_name            VARCHAR  (64)  NOT NULL - Наименование типа
        type_len             SMALLINT       NOT NULL - Длина типа
        column_description   VARCHAR (250)      NULL - Описание столбца
        not_null             BOOLEAN        NOT NULL - Признак NOT NULL  
        has_default          BOOLEAN        NOT NULL - Признак DEFAULT VALUE
  )
Пример использования: SELECT * FROM f_show_col_descr ( 'ind', 'ind_type', 'r' );
                      SELECT * FROM f_show_col_descr ( 'obj', NULL, 'r' ) ORDER BY schema_name, obj_name;
                      SELECT * FROM f_show_col_descr ( NULL, NULL, 'v' ) ORDER BY schema_name, obj_name;
                      SELECT * FROM f_show_col_descr ( 'obj', 'contr', 'r' ) ORDER BY schema_name, obj_name, attr_number;

Результат выполнения:
---------------------
nso|34384|VIEW|kl_ok_okei|11|nomdescr|text|-1||f|f
nso|34384|VIEW|kl_ok_okei|10|nomkomm |text|-1||f|f
nso|34384|VIEW|kl_ok_okei| 1|rec_id  |int8| 8|Идентификатор записи|f|f
nso|34384|VIEW|kl_ok_okei| 2|razdel  |text|-1|Раздел|f|f
nso|34384|VIEW|kl_ok_okei| 3|grup_ed |text|-1|Группа единиц - определяет группу измерения (скорости, массы, мощности и тп)|f|f
nso|34384|VIEW|kl_ok_okei| 4|kod     |text|-1||f|f

3) Функция:  f_show_unique_descr. Получаем описание ограничение уникальности, в нашем случае это первичный ключ и          
      альтернативный ключ. С альтернативным ключом всё просто, с первичным немного сложнее:   
      PK является CONSTRAINT и для него строится индекс по умолчанию. Поэтому он упоминается  
      сразу в двух таблицах: PG_INDEX и PG_CONSTRAINT. Описание его хранится в PG_DESCRIPTION 
      и связано только с PG_CONSTRAINT, запрос получился довольно громоздким.                 
---------------------------------------------------------------------------------------------     
Входные параметры:
       p_schema_name  VARCHAR (20) -- Наименование схемы
      ,p_table_name   VARCHAR (64) -- Наименование объекта
      ,p_unique_name  VARCHAR (64) -- Наименование ограничения

Выходные параметры: 
  (
         schema_name  VARCHAR  (20) -- Наименование схемы
       , table_oid    INTEGER       -- OID таблицы
       , table_name   VARCHAR  (64) -- Наименование таблицы
       , table_desc   VARCHAR (250) -- Описание таблицы
       , attr_number  SMALLINT      -- Номер атрибута 
       , field_name   VARCHAR  (64) -- Наименование атрибута
       , field_desc   VARCHAR (250) -- Описание атрибута
       , index_name   VARCHAR  (64) -- Наименование уникальности 
       , index_type   VARCHAR  (20) -- Тип уникальности
       , index_desc   VARCHAR (250) -- Описание уникальности
  )
Пример использования: SELECT * FROM f_show_unique_descr ( 'ind', 'ind_hist', null );

Результат выполнения:
---------------------
ind|34634|ind_hist     |Исторический показатель (как было)| 1|ind_id         |Идентификатор показателя           |pk_ind_hist                          |PRIMARY KEY|Первичный ключ исторического показателя
ind|34634|ind_hist     |Исторический показатель (как было)| 2|inf_section_id |Идентификатор инф. разреза         |pk_ind_hist                          |PRIMARY KEY|Первичный ключ исторического показателя
ind|34634|ind_hist     |Исторический показатель (как было)| 3|date_of_ind_end|Время окончания действия показателя|pk_ind_hist                          |PRIMARY KEY|Первичный ключ исторического показателя
ind|34634|ind_hist     |Исторический показатель (как было)| 9|counter_c      |Счётчик                            |pk_ind_hist                          |PRIMARY KEY|Первичный ключ исторического показателя
ind|34634|ind_hist     |Исторический показатель (как было)| 1|ind_id         |Идентификатор показателя           |xfk_ind_indicator_is_ind_hist        |INDEX      |Индекс для ограничения уникальности ID показателя для исторического показателя
ind|34634|ind_hist     |Исторический показатель (как было)| 2|inf_section_id |Идентификатор инф. разреза         |xfk_ind_inf_section_clarify_ind_hist |INDEX      |Индекс для ограничения ID инф. разреза для исторического показателя
ind|34642|ind_hist_base|Основание исторического показателя| 1|ind_id         |Идентификатор показателя           |pk_ind_hist_base                     |PRIMARY KEY|Первичный ключ основания исторического показателя
ind|34642|ind_hist_base|Основание исторического показателя| 2|inf_section_id |Идентификатор инф. разреза         |pk_ind_hist_base                     |PRIMARY KEY|Первичный ключ основания исторического показателя
ind|34642|ind_hist_base|Основание исторического показателя| 3|date_of_ind_end|Время окончания действия показателя|pk_ind_hist_base                     |PRIMARY KEY|Первичный ключ основания исторического показателя
ind|34642|ind_hist_base|Основание исторического показателя|10|counter_c      |Счётчик                            |pk_ind_hist_base                     |PRIMARY KEY|Первичный ключ основания исторического показателя

4) Функция:f_show_check_descr. Получить описание ограничения CHECK.
-------------------------------------------------------------------
Входные параметры:
       p_schema_name  VARCHAR (20)   -- Наименование схемы
      ,p_obj_name     VARCHAR (64)   -- Наименование объекта
      ,p_check_name   VARCHAR (64)   -- Наименование ограничения

Выходные параметры: 
    (
          schema_name  VARCHAR  (20)  -- Наименование схемы
        , table_oid    INTEGER        -- OID таблицы
        , table_name   VARCHAR  (64)  -- Наименование таблицы
        , table_desc   VARCHAR (250)  -- Описание таблицы
        , attr_number  SMALLINT       -- Номер атрибута 
        , field_name   VARCHAR  (64)  -- Наименование атрибута
        , field_desc   VARCHAR (250)  -- Описание атрибута
        , check_name   VARCHAR  (64)  -- Наименование ограничения
        , check_desc   VARCHAR (250)  -- Описание ограничения
        , check_expr   VARCHAR (250)  -- Выражение ограничения
    )
Пример использования: SELECT * FROM f_show_check_descr ( 'ind', 'ind_real', 'chk' );   
Результат выполнения:
--------------------
ind|34691|ind_real_base|Основание текущего показателя|4|value_type|Тип основания|chk_ind_real_base_value_type_smallint_012|Допустимый тип величины в основании ист.показателя: 0-абс.значение, 1-geography, 2-geometry, 3-ссылка на НСО|((((value_type = 0::smallint) OR (value_type = 1::smallint)) OR (value_type = 2::smallint)) OR (value_type = 3::smallint))

5) Функция: f_show_check_descr. Получить описание ограничения FK.
-----------------------------------------------------------------
Входные параметры:
       p_schema_name     VARCHAR (20) -- Наименование схемы
      ,p_table_name      VARCHAR (64) -- Наименование таблицы
      ,p_fk_name         VARCHAR (64) -- Наименование ссылки
      ,p_ref_schema_name VARCHAR (20) -- Наименование родительской схемы
      ,p_ref_table_name  VARCHAR (64) -- Наименование родительской таблицы

Выходные параметры: 
  (
      schema_name    VARCHAR  (20) -- Наименование схемы
      table_name     VARCHAR  (64) -- Наименование таблицы
      table_desc     VARCHAR (250) -- Описание таблицы
      constr_name    VARCHAR  (64) -- Наименование ссылки
      constr_descr   VARCHAR (250) -- Описание ссылки
      attr_number    SMALLINT      -- Номер атрибута
      field_name     VARCHAR  (64) -- Наименование атрибута
      not_null       BOOLEAN       -- Признак NOT NULL
      field_desc     VARCHAR (250) -- Описание атрибута
      ref_schema     VARCHAR  (20) -- Наименование родительской схемы
      ref_table      VARCHAR  (64) -- Наименование родительской таблицы
      ref_table_desc VARCHAR (250) -- Описание родительской таблицы
      ref_attr_num   SMALLINT      -- Номер родительского атрибута                
      ref_field_name VARCHAR  (64) -- Наименование родительского атрибута 
      ref_not_null   BOOLEAN       -- Признак NOT NULL                   
      ref_field_desc VARCHAR (250) -- Описание родительского атрибута         
      update_action  VARCHAR  (20) -- действия при обновлении
      delete_action  VARCHAR  (20) -- действие при удалении
      ct_conkey      VARCHAR  (64) -- индесный массив
      ct_confkey     VARCHAR  (64) -- родительский индексный массив
  )
Пример использования: SELECT * FROM f_show_fk_descr ( 'ind', null, null, 'nso', null );

Результат выполнения:
--------------------
ind|ind_real_base            |Основание текущего показателя  |fk_nso_record_may_by_value_ind_real_base           |Ограничение ID записи НСО для основания текущего показателя |8|rec_value_id |f|Значение ссылка           |nso|nso_record|Объект Запись|1|rec_id|f|Первичный ключ  записи|RESTRICT|RESTRICT|8|1
ind|ind_tree_val_inf_section |Дерево информационных разрезов |fk_nso_record_define_value_ind_tree_val_inf_section|Ограничение ID записи НСО для дерева инф. разрезов          |5|rec_id       |t|Ссылка на НСО (Id записи) |nso|nso_record|Объект Запись|1|rec_id|t|Первичный ключ  записи|RESTRICT|RESTRICT|5|1
ind|ind_indicator            |Показатель, постоянная часть   |fk_nso_record_define_measure_unit_ind_indicator    |Ограничение ID единицы измерения для экземпляра показателя  |4|measure_id   |t|Единица измерения         |nso|nso_record|Объект Запись|1|rec_id|t|Первичный ключ  записи|RESTRICT|RESTRICT|4|1
ind|ind_planned_base         |Плановый показатель            |fk_nso_record_may_by_value_ind_planned_base        |Ограничение ID записи НСО для основания планового показателя|9|rec_value_id |f|Значение ссылка           |nso|nso_record|Объект Запись|1|rec_id|f|Первичный ключ  записи|RESTRICT|RESTRICT|9|1


6) Функция f_show_ufk_descr: Получаем описание UNIQUE CONSTRAINT которые определяются внешними ссылками.

Входные параметры:
       p_schema_name      VARCHAR (20) -- Наименование схемы
      ,p_table_name       VARCHAR (64) -- Наименование таблицы
      ,p_unique_name      VARCHAR (64) -- Наименование уникальности
      ,p_ref_name         VARCHAR (64) -- Наименование FK
      ,p_ref_schema_name  VARCHAR (20) -- Наименование родительской схемы
      ,p_ref_table_name   VARCHAR (64) -- Наименование родительской таблицы

Выходные параметры: 
(
   schema_name           VARCHAR  (20) -- Наименование схемы
  ,table_name            VARCHAR  (64) -- Наименование таблицы
  ,table_desc            VARCHAR (250) -- Описание таблицы
  --
  ,attr_num              SMALLINT      -- Номер столбца
  ,attr_name             VARCHAR  (64) -- Наименование столбца
  ,not_null              BOOLEAN       -- Признак NOT NULL 
  ,attr_desc             VARCHAR (250) -- Описание атрибута
  --
  ,unique_name           VARCHAR  (64) -- Наименование ограничения уникальности
  ,unique_constrant_type VARCHAR  (20) -- Тип ограничения уникальности
  ,unique_description    VARCHAR (250) -- Описание уникальности
  --
  ,fk_constraint_name    VARCHAR  (64) -- Наименование ссылки
  ,fk_constraint_descr   VARCHAR (250) -- Описание ссылки
  --  
  ,ref_schema            VARCHAR  (20) -- Наименование родительской схемы
  ,ref_table             VARCHAR  (64) -- Наименование родительской таблицы
  ,ref_table_desc        VARCHAR (250) -- Описание родительской таблицы
  --
  ,ref_attr_num          SMALLINT      -- Номер родительского атрибута                
  ,ref_field_name        VARCHAR  (64) -- Наименование родительского атрибута 
  ,ref_not_null          BOOLEAN       -- Признак NOT NULL                   
  ,ref_field_desc        VARCHAR (250) -- Описание родительского атрибута         
 )

Пример использования: SELECT * FROM f_show_ufk_descr ( 'ind', null, null, null, null, null ) ORDER BY table_name;

Результа выполнения:
-------------------
ind|ind_domain_inf_section     |Домен информационного разреза.Код и Имя для каждого узла дерева инф. разрезов| 2|parent_id      |f|Родительский идентификатор           |xak2ind_domain_inf_section  |UNIQUE INDEX|Ограничение уникальности имени домена                              |fk_ind_domain_inf_section_grouping_ind_domain_inf_section    |Ограничение уникальности подчинённости в домене инф. разрезов      |ind|ind_domain_inf_section  |Домен информационного разреза.Код и Имя для каждого узла дерева инф. разрезов|1|domain_id          |t|Идентификатор
ind|ind_hist                   |Исторический показатель (как было)                                           | 2|inf_section_id |t|Идентификатор инф. разреза           |pk_ind_hist                 |PRIMARY KEY |Ограничение ID инф. разреза для исторического показателя           |fk_ind_inf_section_clarify_ind_hist                          |Ограничение ID инф. разреза для исторического показателя           |ind|ind_inf_section         |Информационный разрез                                                        |1|inf_section_id     |t|Идентификатор инф.разреза
ind|ind_hist                   |Исторический показатель (как было)                                           | 1|ind_id         |t|Идентификатор показателя             |pk_ind_hist                 |PRIMARY KEY |Ограничение уникальности ID показателя для исторического показателя|fk_ind_indicator_is_ind_hist                                 |Ограничение уникальности ID показателя для исторического показателя|ind|ind_indicator           |Показатель, постоянная часть                                                 |1|ind_id             |t|Идентификатор показателя
ind|ind_hist_base              |Основание исторического показателя                                           | 1|ind_id         |t|Идентификатор показателя             |pk_ind_hist_base            |PRIMARY KEY |Ограничение уникальности ПК для основания исторического показателя |fk_ind_hist_has_ind_hist_base                                |Ограничение уникальности ПК для основания исторического показателя |ind|ind_hist                |Исторический показатель (как было)                                           |1|ind_id             |t|Идентификатор показателя
ind|ind_hist_base              |Основание исторического показателя                                           | 3|date_of_ind_end|t|Время окончания действия показателя  |pk_ind_hist_base            |PRIMARY KEY |Ограничение уникальности ПК для основания исторического показателя |fk_ind_hist_has_ind_hist_base                                |Ограничение уникальности ПК для основания исторического показателя |ind|ind_hist                |Исторический показатель (как было)                                           |3|date_of_ind_end    |t|Время окончания действия показателя
ind|ind_hist_base              |Основание исторического показателя                                           |10|counter_c      |t|Счётчик                              |pk_ind_hist_base            |PRIMARY KEY |Ограничение уникальности ПК для основания исторического показателя |fk_ind_hist_has_ind_hist_base                                |Ограничение уникальности ПК для основания исторического показателя |ind|ind_hist                |Исторический показатель (как было)                                           |9|counter_c          |t|Счётчик
ind|ind_hist_base              |Основание исторического показателя                                           | 2|inf_section_id |t|Идентификатор инф. разреза           |pk_ind_hist_base            |PRIMARY KEY |Ограничение уникальности ПК для основания исторического показателя |fk_ind_hist_has_ind_hist_base                                |Ограничение уникальности ПК для основания исторического показателя |ind|ind_hist                |Исторический показатель (как было)                                           |2|inf_section_id     |t|Идентификатор инф. разреза
ind|ind_indicator              |Показатель, постоянная часть                                                 | 4|measure_id     |t|Единица измерения                    |xak1ind_indicator           |UNIQUE INDEX|Ограничение уникальности экземпляра показателя                     |fk_nso_record_define_measure_unit_ind_indicator              |Ограничение ID единицы измерения для экземпляра показателя         |nso|nso_record              |Объект Запись                                                                |1|rec_id             |t|Первичный ключ  записи
ind|ind_indicator              |Показатель, постоянная часть                                                 | 5|ind_type_id    |t|Тип показателя                       |xak1ind_indicator           |UNIQUE INDEX|Ограничение уникальности экземпляра показателя                     |fk_ind_type_typify_ind_indicator                             |Ограничение ID типа показателя для экземпляра показателя           |ind|ind_type                |Тип показателя                                                               |1|ind_type_id        |t|Идентификатор типа
ind|ind_planned                |Плановый показатель                                                          | 3|inf_section_id |t|Идентификатор инф.разреза            |pk_ind_planned              |PRIMARY KEY |Ограничение ID инф. разреза для планового показателя               |fk_ind_inf_section_clarify_ind_planned                       |Ограничение ID инф. разреза для планового показателя               |ind|ind_inf_section         |Информационный разрез                                                        |1|inf_section_id     |t|Идентификатор инф.разреза
ind|ind_planned                |Плановый показатель                                                          | 1|ind_id         |t|Идентификатор планового показателя   |pk_ind_planned              |PRIMARY KEY |Ограничение уникальности ID показателя для планового показателя    |fk_ind_indicator_may_be_ind_planned                          |Ограничение уникальности ID показателя для планового показателя    |ind|ind_indicator           |Показатель, постоянная часть                                                 |1|ind_id             |t|Идентификатор показателя
ind|ind_planned_base           |Плановый показатель                                                          | 2|doc_id         |t|Документ-источник                    |pk_ind_planned_base         |PRIMARY KEY |Ограничение уникальности ПК для основания планового показателя     |fk_ind_planned_has_ind_planned_base                          |Ограничение уникальности ПК для основания планового показателя     |ind|ind_planned             |Плановый показатель                                                          |2|doc_id             |t|Документ-источник
ind|ind_planned_base           |Плановый показатель                                                          | 3|inf_section_id |t|Идентификатор инф. разреза           |pk_ind_planned_base         |PRIMARY KEY |Ограничение уникальности ПК для основания планового показателя     |fk_ind_planned_has_ind_planned_base                          |Ограничение уникальности ПК для основания планового показателя     |ind|ind_planned             |Плановый показатель                                                          |3|inf_section_id     |t|Идентификатор инф.разреза
ind|ind_planned_base           |Плановый показатель                                                          | 1|ind_id         |t|Идентификатор планового показателя   |pk_ind_planned_base         |PRIMARY KEY |Ограничение уникальности ПК для основания планового показателя     |fk_ind_planned_has_ind_planned_base                          |Ограничение уникальности ПК для основания планового показателя     |ind|ind_planned             |Плановый показатель                                                          |1|ind_id             |t|Идентификатор планового показателя
ind|ind_real                   |Текущий показатель                                                           | 1|ind_id         |t|Идентификатор показателя             |pk_ind_real                 |PRIMARY KEY |Ограничение уникальности ID показателя для текущего показателя     |fk_ind_indicator_may_be_ind_real                             |Ограничение уникальности ID показателя для текущего показателя     |ind|ind_indicator           |Показатель, постоянная часть                                                 |1|ind_id             |t|Идентификатор показателя
ind|ind_real                   |Текущий показатель                                                           | 2|inf_section_id |t|Идентификатор инф. разреза           |pk_ind_real                 |PRIMARY KEY |Ограничение ID инф. разреза для текущего показателя                |fk_ind_inf_section_clarify_ind_real                          |Ограничение ID инф. разреза для текущего показателя                |ind|ind_inf_section         |Информационный разрез                                                        |1|inf_section_id     |t|Идентификатор инф.разреза
ind|ind_real_base              |Основание текущего показателя                                                | 1|ind_id         |t|Идентификатор показателя             |pk_ind_real_base            |PRIMARY KEY |Ограничение уникальности ПК для основания текущего показателя      |fk_ind_real_has_ind_real_base                                |Ограничение уникальности ПК для основания текущего показателя      |ind|ind_real                |Текущий показатель                                                           |1|ind_id             |t|Идентификатор показателя
ind|ind_real_base              |Основание текущего показателя                                                | 2|inf_section_id |t|Идентификатор инф. разреза           |pk_ind_real_base            |PRIMARY KEY |Ограничение уникальности ПК для основания текущего показателя      |fk_ind_real_has_ind_real_base                                |Ограничение уникальности ПК для основания текущего показателя      |ind|ind_real                |Текущий показатель                                                           |2|inf_section_id     |t|Идентификатор инф. разреза
ind|ind_tree_val_inf_section   |Дерево информационных разрезов                                               | 3|parent_id      |f|Родительский идентификатор           |xak1ind_tree_val_inf_section|UNIQUE INDEX|Ограничение уникальности для дерева инф. разрезов                  |fk_ind_tree_val_inf_section_grouping_ind_tree_val_inf_section|Ограничение уникальности подчинённости в дереве инф. разрезов      |ind|ind_tree_val_inf_section|Дерево информационных разрезов                                               |1|inf_disc_section_id|t|Идентификатор
ind|ind_tree_val_inf_section   |Дерево информационных разрезов                                               | 5|rec_id         |t|Ссылка на НСО (Id записи)            |xak1ind_tree_val_inf_section|UNIQUE INDEX|Ограничение уникальности для дерева инф. разрезов                  |fk_nso_record_define_value_ind_tree_val_inf_section          |Ограничение ID записи НСО для дерева инф. разрезов                 |nso|nso_record              |Объект Запись                                                                |1|rec_id             |t|Первичный ключ  записи
ind|ind_tree_val_inf_section   |Дерево информационных разрезов                                               | 2|ind_type_id    |t|Тип показателя                       |xak1ind_tree_val_inf_section|UNIQUE INDEX|Ограничение уникальности для дерева инф. разрезов                  |fk_ind_type_typify_ind_tree_val_inf_section                  |Ограничение уникальности ID типа показателя в дереве инф. разрезов |ind|ind_type                |Тип показателя                                                               |1|ind_type_id        |t|Идентификатор типа
ind|ind_tree_val_inf_section   |Дерево информационных разрезов                                               | 4|domain_id      |t|Домен инф.разреза                    |xak1ind_tree_val_inf_section|UNIQUE INDEX|Ограничение уникальности для дерева инф. разрезов                  |fk_ind_domain_inf_section_naming_ind_tree_val_inf_section    |Ограничение уникальности ID домена в дереве инф. разрезов          |ind|ind_domain_inf_section  |Домен информационного разреза.Код и Имя для каждого узла дерева инф. разрезов|1|domain_id          |t|Идентификатор
ind|ind_type                   |Тип показателя                                                               | 5|parent_id      |f|Родильский идентификатор             |xak2ind_type                |UNIQUE INDEX|Ограничение уникальности имени типа показателя                     |fk_ind_type_grouping_ind_type                                |Ограничение уникальности подчинённости в типах показателей         |ind|ind_type                |Тип показателя                                                               |1|ind_type_id        |t|Идентификатор типа



    
 

 
