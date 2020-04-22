-- ------------------------------------ 
-- 2015-02-22 Таблица ошибок Nick
-- 2018-12-16 Nick - Новое ядро
-- 2020-02-15 Nick - Установка в базу.
-- ------------------------------------
SET search_path=com,public, pg_catalog;

DROP VIEW IF EXISTS com.v_errors;
CREATE OR REPLACE VIEW com.v_errors ( err_id
                                        , err_code
                                        , message_out
                                        , sch_name
                                        , constr_name
                                        , opr_type
                                        , tbl_name
                                        , qty
                                        , db_engine 
) AS 

SELECT err_id
     , err_code
     , message_out
     , sch_name
     , constr_name
     , ( CASE WHEN opr_type = 'i' THEN 'INSERT'
              WHEN opr_type = 'u' THEN 'UPDATE' 
              WHEN opr_type = 'd' THEN 'DELETE' 
        END ) AS opr_type                                 
     , tbl_name
     , 0 AS qty
     , true AS db_engine
  FROM com.sys_errors 

 UNION ALL

SELECT 0 AS err_id
     , err_code
     , message_out
     , sch_name
     , '' AS constr_name
     , '' AS opr_type
     , '' AS tbl_name
     , qty
     , false AS db_engine
  FROM com.obj_errors

  ORDER BY 2, 4, 5;

COMMENT ON VIEW  com.v_errors  IS '278: Таблица ошибок';

COMMENT ON COLUMN com.v_errors.err_id      IS 'Внутренний номер ошибки, только для ошибок DB-engine';
COMMENT ON COLUMN com.v_errors.err_code    IS 'Код ошибки';
COMMENT ON COLUMN com.v_errors.message_out IS 'Текст сообщения об ошибке';
COMMENT ON COLUMN com.v_errors.sch_name    IS 'Имя схемы';
COMMENT ON COLUMN com.v_errors.constr_name IS 'Имя ограничения';
COMMENT ON COLUMN com.v_errors.opr_type    IS 'Тип операции';
COMMENT ON COLUMN com.v_errors.tbl_name    IS 'Имя таблицы';
COMMENT ON COLUMN com.v_errors.qty         IS 'Количество метасимволов';
COMMENT ON COLUMN com.v_errors.db_engine   IS 'Признак ошибки ядра базы';


--  SELECT * FROM com.v_errors WHERE ( not db_engine)
