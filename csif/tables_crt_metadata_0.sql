--
--  2023-06-19   Метаданные для загрузки реестров.
--  2023-06-21   Уточняю временные структуры
--  2023-06-29   Дополнение строкой вызова хранимки

        -- Временная таблица для хранения данных взятых из файла-реестра
        -- Временная таблица (наследник) для хранения некорректных данных.
--
DROP TABLE IF EXISTS dict.metadata CASCADE;
CREATE TABLE dict.metadata (
     id_metadata     serial  NOT NULL
    ,code_metadata   char(4) NOT NULL
    ,descr_metadata  text    NOT NULL  -- 0
    ,crt_table       text    NOT NULL 
     --
    ,ins_table_0     text    NOT NULL  -- 2
    ,ins_table_1     text    NULL
    ,ins_table_2     text    NULL
     --    
    ,sel_table_0     text    NOT NULL  -- 5	
    ,sel_table_1     text    NOT NULL	
    ,sel_table_2     text    NULL	    
     --
    ,drop_table      text    NOT NULL  -- 8
    ,delete_from     text    NOT NULL  
    ,where_bad       text              -- 10
     --
    ,call_proc_fin   text    NULL 
);
--
--
COMMENT ON TABLE dict.metadata 
   IS 'Временые хранилища (структуры и методы доступа), для различных типов платёжных реестров';

COMMENT ON COLUMN dict.metadata.id_metadata    IS 'ID записи'; 
COMMENT ON COLUMN dict.metadata.code_metadata  IS 'Код записи (уникален)'; 
COMMENT ON COLUMN dict.metadata.descr_metadata IS 'Описание экземпляра метаданных'; 
COMMENT ON COLUMN dict.metadata.crt_table      IS 'Создание временных таблиц'; 

COMMENT ON COLUMN dict.metadata.ins_table_0    IS 'Оператор INSERT для зарузки данных из файла-реестра во временную таблицу'; 
COMMENT ON COLUMN dict.metadata.ins_table_1    IS 'Оператор INSERT для загрузки ОБЩЕГО РЕЕСТРА исходных данных'; 
COMMENT ON COLUMN dict.metadata.ins_table_2    IS 'Оператор INSERT для загрузки таблицы с дефетными  данными';

COMMENT ON COLUMN dict.metadata.sel_table_0    IS 'Оператор SELECT для выборки данных из временной таблицы'; 
COMMENT ON COLUMN dict.metadata.sel_table_1    IS 'Оператор SELECT для выборки данных из временной таблицы ДЕФЕКТОВ'; 
COMMENT ON COLUMN dict.metadata.sel_table_2    IS 'Оператор SELECT формирующий данные для загрузки в ОБЩИЙ РЕЕСТР'; 
--
COMMENT ON COLUMN dict.metadata.drop_table     IS 'Оператор DROP TABLE'; 
COMMENT ON COLUMN dict.metadata.delete_from    IS 'Оператор DELETE FROM'; 
-- 
COMMENT ON COLUMN dict.metadata.where_bad      IS 'Условие для фильтрации дефектных записей'; 
--
COMMENT ON COLUMN dict.metadata.call_proc_fin  IS 'Шаблон вызова процедуры "fsc_receipt_pcg.p_source_reestr_ins_0"';

-- SELECT * FROM dict.metadata;
