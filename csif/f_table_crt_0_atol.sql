--
--    2023-07-27
--
-- sudo apt-cache search oracle_fdw 
-- sudo apt-get install postgresql-13-oracle-fdw
-- sudo apt-get install postgresql-13-orafce  

DROP FOREIGN TABLE IF EXISTS fiscalization.ssp_operation_type_fisc;
CREATE FOREIGN TABLE fiscalization.ssp_operation_type_fisc(
     kd_oper_type    integer OPTIONS (key 'true') NOT NULL   -- 'KD_OPER_TYPE'
    ,nm_oper_type    text    NOT NULL                        -- 'NM_OPER_TYPE'
	,descr_oper_type text    NOT NULL                        -- 'DESC_OPER_TYPE' 
)
    SERVER moe_test
    OPTIONS (schema 'CURR', table 'SSP_OPERATION_TYPE_FISC');   

-- ПОДСКАЗКА:  В данном контексте допустимы параметры: dblink, schema, table, max_long, readonly, sample_percent, prefetch

SELECT * FROM fiscalization.ssp_operation_type_fisc order by 1;
----------------------------------------------------
-- kd_oper_type	nm_oper_type	descr_oper_type
-- 1	Приход	sell
-- 2	Возврат прихода	sell_refund
-- 3	Коррекция прихода	sell_correction
-- 4	Коррекция возврата прихода	sell_refund_correction:
-- 5	Расход	buy
-- 6	Возврат расхода	buy_refund
-- 7	Коррекция расхода	buy_correction
-- 8	Коррекция возврата расхода	buy_refund_correction


UPDATE fiscalization.ssp_operation_type_fisc
    SET nm_oper_type = 'Коррекция возврата прихода'
       ,descr_oper_type = 'sell_refund_correction:'
WHERE (kd_oper_type = 4);       

INSERT INTO fiscalization.ssp_operation_type_fisc ( 
                kd_oper_type   
               ,nm_oper_type   
               ,descr_oper_type
)
   VALUES 
      (5, 'Расход', 'buy')
    , (6, 'Возврат расхода', 'buy_refund')
    , (7, 'Коррекция расхода', 'buy_correction')
    , (8, 'Коррекция возврата расхода', 'buy_refund_correction')
;    

--  buy                    чек «Расход»;
--  buy_refund             чек «Возврат расхода»;
--  buy_correction         чек «Коррекция расхода»;
--  buy_refund_correction  чек «Коррекция возврата расхода».

-- ERROR: ОШИБКА:  error executing query: OCIStmtExecute failed to execute remote query
-- ПОДРОБНОСТИ:  ORA-08177: не могу преобразовать в последов.доступ для этой транзакции
-- ERROR: ОШИБКА:  error executing query: OCIStmtExecute failed to execute remote query
-- ПОДРОБНОСТИ:  ORA-08177: не могу преобразовать в последов.доступ для этой транзакции

-- SQL state: 40001
-- Detail: ORA-08177: не могу преобразовать в последов.доступ для этой транзакции

-- SQL state: 40001
-- Detail: ORA-08177: не могу преобразовать в последов.доступ для этой транзакции

-- Со второй попытки прошло
