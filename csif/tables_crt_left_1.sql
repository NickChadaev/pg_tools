/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     04.05.2023                                   */ 
/*  Modified on: 12.05.2023/16.05.2023/28-07-2023               */
/*     04-08-2023  Добавлены ID_PAY, FSC_PROV_TYPE              */
/*     31-08-2023  Добавлен новый статус чека 6                 */
/*==============================================================*/

SET search_path=fiscalization;

DROP TABLE IF EXISTS fiscalization.fsc_receipt CASCADE;
/*==============================================================*/
/* Table: fsc_receipt                                           */
/*==============================================================*/
create table fiscalization.fsc_receipt (
   id_receipt bigint NOT NULL DEFAULT nextval('fiscalization.fsc_receipt_id_receipt_seq'::regclass),
   dt_create            TIMESTAMP(0)  with time zone not null default now(),
   rcp_status           INT4          not null default 0,
   dt_update            TIMESTAMP(0)  with time zone  null,
   inn                  VARCHAR(12)          null,
   rcp_nmb              TEXT                 null,
   rcp_fp               char(10)             null,
   dt_fp                TIMESTAMP(0) with time zone null,
   id_org_app           INT4                 null,
   rcp_status_descr     TEXT                 null,
   rcp_order            jsonb                null,   
   rcp_receipt          jsonb                null,
   id_fsc_provider      INT4                 NOT NULL, 
   rcp_type             INT4                 not null default 0,
   rcp_received         BOOL                 not null default FALSE,
   rcp_notify_send      BOOL                 not null default FALSE,
   id_pay               bigint               null,
   resend_pr            INT4             NOT NULL DEFAULT 0
) PARTITION BY LIST (rcp_status);

alter table fiscalization.fsc_receipt
   add constraint pk_receipt primary key (id_receipt, rcp_status, dt_create);

alter table fiscalization.fsc_receipt   
   add CONSTRAINT chk_receipt_type CHECK (rcp_type IN (0,1,2));
   
alter table fiscalization.fsc_receipt   
   add CONSTRAINT chk_receipt_status CHECK (rcp_status IN (0,1,2,3,4,5,6));   

alter table fiscalization.fsc_receipt   
   add CONSTRAINT chk_resend_pr CHECK (resend_pr IN (0,1,2,3,4,5));   
   
--   Возможные значения:
--   0 - попыток повторной фискализации не осуществлялось;
--   1 - осуществлялась одна попытка повторной отправки на фискализацию;
--   2 - осуществлялось две попытки повторной отправки на фискализацию;
--   3 - осуществлялось три попытки повторной отправки на фискализацию;
--   4 - осуществлялось четыре попытки повторной отправки на фискализацию;
--   5 - осуществлялось (максимум) пять попыток повторной отправки на фискализацию

COMMENT ON TABLE fiscalization.fsc_receipt
    IS 'Чек';

COMMENT ON COLUMN fiscalization.fsc_receipt.id_receipt
    IS 'ID Чека';

COMMENT ON COLUMN fiscalization.fsc_receipt.dt_create
    IS 'Дата создания';

COMMENT ON COLUMN fiscalization.fsc_receipt.dt_update
    IS 'Дата обновления';

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_status
    IS 'Статус чека';
    
-- COMMENT ON COLUMN fiscalization.fsc_receipt.kd_oper_type  
--     IS 'Код операции в on-line кассе';
    
COMMENT ON COLUMN fiscalization.fsc_receipt.inn
    IS 'ИНН';

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_nmb
    IS 'Номер чека';

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_fp
    IS 'Фискальный признак';

COMMENT ON COLUMN fiscalization.fsc_receipt.dt_fp
    IS 'Дата фискализации';

COMMENT ON COLUMN fiscalization.fsc_receipt.id_org_app
    IS 'ID пары Организация-Приложение';

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_status_descr
    IS 'Описание статуса';

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_type
    IS 'Тип (0-кассовый чек/1-чек корреции/2-возврат платежа)';

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_received
    IS 'Чек принят';

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_notify_send
    IS 'Извещение отослано';   

COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_order
    IS 'Запрос на фискализацию';
    
COMMENT ON COLUMN fiscalization.fsc_receipt.rcp_receipt
    IS 'Результат фискализации';  
    
COMMENT ON COLUMN fiscalization.fsc_receipt.id_fsc_provider
    IS 'ID провайдера фискализации';

COMMENT ON COLUMN fiscalization.fsc_receipt.id_pay
    IS 'ID платежа';  
    
COMMENT ON COLUMN fiscalization.fsc_receipt.resend_pr
    IS 'Признак повторной фискализации: 0 - первичная, 1,2,3,4,5 - повторная';    
--    
--    
CREATE TABLE fiscalization.fsc_receipt_0 PARTITION OF fiscalization.fsc_receipt
( 
    CONSTRAINT chk_receipt_0 CHECK (rcp_status = 0)
)
    FOR VALUES IN (0);    
    
COMMENT ON TABLE fiscalization.fsc_receipt_0 IS 'Запрос на фискализацию';    
    
CREATE TABLE fiscalization.fsc_receipt_1 PARTITION OF fiscalization.fsc_receipt
( 
    CONSTRAINT chk_receipt_1 CHECK (rcp_status = 1)
)
    FOR VALUES IN (1);
    
COMMENT ON TABLE fiscalization.fsc_receipt_1 IS 'Отправлено на фискализацию';    
    
CREATE TABLE fiscalization.fsc_receipt_3 PARTITION OF fiscalization.fsc_receipt
( 
    CONSTRAINT chk_receipt_3 CHECK (rcp_status = 3)
)
    FOR VALUES IN (3);

COMMENT ON TABLE fiscalization.fsc_receipt_3 IS 'Чек ожидает свободной кассы, очередь переполнена';    
--
-- 2023-08-31
-- ------------------------------------------------------------------------------

CREATE TABLE fiscalization.fsc_receipt_4 PARTITION OF fiscalization.fsc_receipt
( 
    CONSTRAINT chk_receipt_4 CHECK (rcp_status = 4)
)
    FOR VALUES IN (4);

COMMENT ON TABLE fiscalization.fsc_receipt_4 IS 'Чек с ошибкой (фискализация не будет выполнена)';    

CREATE TABLE fiscalization.fsc_receipt_5 PARTITION OF fiscalization.fsc_receipt
( 
    CONSTRAINT chk_receipt_5 CHECK (rcp_status = 5)
)
    FOR VALUES IN (5);

COMMENT ON TABLE fiscalization.fsc_receipt_5 IS ' Ошибка кассы (попытка фискализации может быть выполнена повторно)';    

CREATE TABLE fiscalization.fsc_receipt_6 PARTITION OF fiscalization.fsc_receipt
( 
    CONSTRAINT chk_receipt_6 CHECK (rcp_status = 6)
)
    FOR VALUES IN (6);

COMMENT ON TABLE fiscalization.fsc_receipt_6 IS 'Ошибка сервиса (попытка фискализации может быть выполнена повторно)';    

-- -----------------------------------------------------------------------------

CREATE TABLE fiscalization.fsc_receipt_default PARTITION OF fiscalization.fsc_receipt
    DEFAULT;

COMMENT ON TABLE fiscalization.fsc_receipt_default IS 'Неклассифицированные данные фискализации';    
--
-- Самая нагруженная таблица секционируется по квартальным диапазонам.    
--    
DROP TABLE IF EXISTS fiscalization.fsc_receipt_2;    
CREATE TABLE fiscalization.fsc_receipt_2 PARTITION OF fiscalization.fsc_receipt
( 
    CONSTRAINT chk_receipt_2 CHECK (rcp_status IN (2))
)
    FOR VALUES IN (2)
    
PARTITION BY RANGE (dt_create);   

COMMENT ON TABLE fiscalization.fsc_receipt_2 IS 'Результаты фискализации';   

-- ==========================================================================================================

CREATE TABLE fiscalization_part.fsc_receipt_2_2021_1 PARTITION OF fiscalization.fsc_receipt_2
( 
    CONSTRAINT chk_receipt_2_dt_create_2021_1 CHECK (dt_create >= '2021-01-01' AND dt_create < '2021-04-01')
)
    FOR VALUES FROM ('2021-01-01') TO ('2021-04-01');

COMMENT ON TABLE fiscalization_part.fsc_receipt_2_2021_1 IS 'Результаты фискализации. 2021 год, первый квартал';   
    
CREATE TABLE fiscalization_part.fsc_receipt_2_2021_2 PARTITION OF fiscalization.fsc_receipt_2
( 
    CONSTRAINT chk_receipt_2_dt_create_2021_2 CHECK (dt_create >= '2021-04-01' AND dt_create < '2021-07-01')
)
    FOR VALUES FROM ('2021-04-01') TO ('2021-07-01');

COMMENT ON TABLE fiscalization_part.fsc_receipt_2_2021_2 IS 'Результаты фискализации. 2021 год, второй квартал';   
    
CREATE TABLE fiscalization_part.fsc_receipt_2_2021_3 PARTITION OF fiscalization.fsc_receipt_2
( 
    CONSTRAINT chk_receipt_2_dt_create_2021_3 CHECK (dt_create >= '2021-07-01' AND dt_create < '2021-10-01')
)
    FOR VALUES FROM ('2021-07-01') TO ('2021-10-01');

COMMENT ON TABLE fiscalization_part.fsc_receipt_2_2021_3 IS 'Результаты фискализации. 2021 год, третий квартал';   
    
CREATE TABLE fiscalization_part.fsc_receipt_2_2021_4 PARTITION OF fiscalization.fsc_receipt_2
( 
    CONSTRAINT chk_receipt_2_dt_create_2021_4 CHECK (dt_create >= '2021-10-01' AND dt_create < '2022-01-01')
)
    FOR VALUES FROM ('2021-10-01') TO ('2022-01-01');

COMMENT ON TABLE fiscalization_part.fsc_receipt_2_2021_4 IS 'Результаты фискализации. 2021 год, четвёртый квартал'; 
  
-- ================================================================================================================  

CREATE TABLE fiscalization_part.fsc_receipt_2_2023_1 PARTITION OF fiscalization.fsc_receipt_2
( 
    CONSTRAINT chk_receipt_2_dt_create_2023_1 CHECK (dt_create >= '2023-01-01' AND dt_create < '2023-04-01')
)
    FOR VALUES FROM ('2023-01-01') TO ('2023-04-01');

COMMENT ON TABLE fiscalization_part.fsc_receipt_2_2023_1 IS 'Результаты фискализации. 2023 год, первый квартал';   
    
CREATE TABLE fiscalization_part.fsc_receipt_2_2023_2 PARTITION OF fiscalization.fsc_receipt_2
( 
    CONSTRAINT chk_receipt_2_dt_create_2023_2 CHECK (dt_create >= '2023-04-01' AND dt_create < '2023-07-01')
)
    FOR VALUES FROM ('2023-04-01') TO ('2023-07-01');

COMMENT ON TABLE fiscalization_part.fsc_receipt_2_2023_2 IS 'Результаты фискализации. 2023 год, второй квартал';   
    
CREATE TABLE fiscalization_part.fsc_receipt_2_2023_3 PARTITION OF fiscalization.fsc_receipt_2
( 
    CONSTRAINT chk_receipt_2_dt_create_2023_3 CHECK (dt_create >= '2023-07-01' AND dt_create < '2023-10-01')
)
    FOR VALUES FROM ('2023-07-01') TO ('2023-10-01');

COMMENT ON TABLE fiscalization_part.fsc_receipt_2_2023_3 IS 'Результаты фискализации. 2023 год, третий квартал';   
    
CREATE TABLE fiscalization_part.fsc_receipt_2_2023_4 PARTITION OF fiscalization.fsc_receipt_2
( 
    CONSTRAINT chk_receipt_2_dt_create_2023_4 CHECK (dt_create >= '2023-10-01' AND dt_create < '2024-01-01')
)
    FOR VALUES FROM ('2023-10-01') TO ('2024-01-01');

COMMENT ON TABLE fiscalization_part.fsc_receipt_2_2023_4 IS 'Результаты фискализации. 2023 год, четвёртый квартал'; 
--
--  2023-08-29
--
CREATE TABLE fiscalization.fsc_receipt_2_default PARTITION OF fiscalization.fsc_receipt_2 DEFAULT;
COMMENT ON TABLE fiscalization.fsc_receipt_2_default IS 'Неклассифицированные данные фискализации СОСТОЯНИЕ 2';    
--
