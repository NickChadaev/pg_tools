--
--  2020-04-29 Nick  Тест на вложенное секционирование. Схема NSO.
--
CREATE TABLE nso.nso_log_1 PARTITION OF com.all_log_1 
    FOR VALUES IN ( 'nso', 'nso_data', 'nso_exchange', 'nso_structure')  
            PARTITION BY RANGE (impact_date);  
COMMENT ON TABLE nso.nso_log_1 IS 'Схема NSO. Журнал регистрации операций и ошибок';            
 --
CREATE TABLE nso.nso_log_1_19 PARTITION OF nso.nso_log_1
       FOR VALUES FROM ('2019-01-01 00:00:00') TO ('2019-12-31 23:58:50')
    PARTITION BY LIST (impact_type);   
COMMENT ON TABLE nso.nso_log_1_19 IS 'Схема NSO. Журнал регистрации операций и ошибок. 2019 год';
    -- 
CREATE TABLE nso.nso_log_1_20 PARTITION OF nso.nso_log_1
       FOR VALUES FROM ('2020-01-01 00:00:00') TO ('2020-12-31 23:58:50')
    PARTITION BY LIST (impact_type);
COMMENT ON TABLE nso.nso_log_1_20 IS 'Схема NSO. Журнал регистрации операций и ошибок. 2020 год';
--      --
CREATE TABLE nso.nso_log_1_19_op PARTITION OF nso.nso_log_1_19 
       FOR VALUES IN 
         ('0','1','2','3','4','5','X','8','9','A','B','C','D','E','F','G','H','Y','Z','I','J','6','7');
COMMENT ON TABLE nso.nso_log_1_19_op IS 'Схема NSO. Журнал регистрации операций. 2019 год';         
 -- 
CREATE TABLE nso.nso_log_1_19_er PARTITION OF nso.nso_log_1_19 FOR VALUES IN ('!');
COMMENT ON TABLE nso.nso_log_1_19_er IS 'Схема NSO. Журнал регистрации ошибок. 2019 год';
--      --
CREATE TABLE nso.nso_log_1_20_op PARTITION OF nso.nso_log_1_20 
       FOR VALUES IN 
         ('0','1','2','3','4','5','X','8','9','A','B','C','D','E','F','G','H','Y','Z','I','J','6','7');
COMMENT ON TABLE nso.nso_log_1_20_op IS 'Схема NSO. Журнал регистрации операций. 2020 год';         
--
CREATE TABLE nso.nso_log_1_20_er PARTITION OF nso.nso_log_1_20 FOR VALUES IN ('!');
COMMENT ON TABLE nso.nso_log_1_20_er IS 'Схема NSO. Журнал регистрации ошибок. 2020 год';

