/* ============================================================================ */
/*  DBMS name:      PostgreSQL 13                                               */
/*  Created on:     02.06.2023 --Реестр исходных данных.                        */
/*    2023-06-07/2023-06-19 Добавлены опциональные поля, напрямую не связанные  */
/*               со структурами ATOL                                            */
/*    2023-07-28  Тип чека + ID платежа.                                        */
/* ============================================================================ */

SET search_path=fiscalization, public;

DROP SEQUENCE IF EXISTS fiscalization.fsc_source_reestr_id_reestr_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS fiscalization.fsc_source_reestr_id_reestr_seq
AS bigint;

DROP TABLE IF EXISTS fiscalization.fsc_source_reestr CASCADE;
/*==============================================================*/
/* Table: fsc_source_reestr                                     */
/*==============================================================*/
CREATE TABLE fiscalization.fsc_source_reestr (
    id_source_reestr        bigint NOT NULL DEFAULT nextval('fiscalization.fsc_source_reestr_id_reestr_seq'::regclass)
   ,dt_create               timestamp(0)  without time zone NOT NULL DEFAULT now()
   ,id_pay                  bigint           NOT NULL
   ,rcp_type                operation_t      NOT NULL DEFAULT 'sell'
   ,company_email           text             NOT NULL 
   ,company_sno             sno_t            NOT NULL DEFAULT 'osn'
   ,company_inn             text             NOT NULL 
   ,company_payment_address text             NOT NULL 
   ,client_name             text             NOT NULL 
   ,client_inn              text             NOT NULL 
   ,pmt_type                integer          NOT NULL 
   ,pmt_sum                 numeric(10,2)    NOT NULL 
   ,item_name               text             NOT NULL 
   ,item_price              numeric(10,2)    NOT NULL 
   ,item_measure            integer          NOT NULL 
   ,item_quantity           numeric(8,3)     NOT NULL DEFAULT 1.000 
   ,item_sum                numeric(10,2)    NOT NULL 
   ,item_payment_method     payment_method_t NOT NULL 
   ,payment_object          integer          NOT NULL 
   ,item_vat                vat_t            NOT NULL DEFAULT 'vat20'
   ,type_source_reestr      integer          NOT NULL DEFAULT 0 -- 0 -ABR,  1-- PAY
   ,external_id             text             NOT NULL 
   --------------------------------------------------
   --       Опциональные.
   -- 
   ,client_account        text
   --
   ,company_account       text
   ,company_phones        text[]
   ,company_name          text 
   ,company_bik           text
   ,company_paying_agent  boolean NOT NULL DEFAULT false
   
   ,bank_name             text
   ,bank_addr             text
   ,bank_inn              text
   ,bank_bik              text
   ,bank_phones           text[]
);

COMMENT ON TABLE fiscalization.fsc_source_reestr IS 'Реестр исходных данных';

COMMENT ON COLUMN fiscalization.fsc_source_reestr.id_source_reestr        IS 'ID рееестра исходных данных';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.dt_create               IS 'Дата создания записи';

COMMENT ON COLUMN fiscalization.fsc_source_reestr.id_pay                  IS 'ID платежа';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.rcp_type                IS 'Тип операции чека';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_email           IS 'mail отправителя чека (адрес ОФД)';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_sno             IS 'Система налогообложения';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_inn             IS 'ИНН организации';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_payment_address IS 'Место расчётов';


COMMENT ON COLUMN fiscalization.fsc_source_reestr.client_name             IS 'Наименование клиента';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.client_inn              IS 'ИНН клиента';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.pmt_type                IS 'Вид  оплаты';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.pmt_sum                 IS 'Сумма оплаты';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_name               IS 'Наименование товара/услуги';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_price              IS 'Цена в рублях';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_measure            IS 'Единица измерения товара';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_quantity           IS 'Количество товара/Оказанных услуг';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_sum                IS 'Сумма товара в рублях';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_payment_method     IS 'Способ расчёта за товар';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.payment_object          IS 'Признак предмета расчёта';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.item_vat                IS 'Тип налога';
--
COMMENT ON COLUMN fiscalization.fsc_source_reestr.type_source_reestr IS 'Тип реестра исходных данных';   -- 0 -ABR,  1-- PAY
COMMENT ON COLUMN fiscalization.fsc_source_reestr.external_id IS 'Внешний идентификатор строки реестра (Внешний ID чека)'; 

   --------------------------------------------------
   --       Опциональные.
   -- 
COMMENT ON COLUMN fiscalization.fsc_source_reestr.client_account       IS 'Счёт клиента'; --- text
COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_account      IS 'Счёт компании, предоставляющей услуги'; --- text
COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_bik          IS 'БИК компании, предоставляющей услуги'; --- text
COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_paying_agent IS 'Компания -- банковский агент, переход на двухзвенную схему'; --- boolean NOT NULL DEFAULT false
COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_phones       IS 'Контактные телефоны компании'; --- text[]
COMMENT ON COLUMN fiscalization.fsc_source_reestr.company_name         IS 'Наименование компании, предоставляющей услуги'; --- 
--
COMMENT ON COLUMN fiscalization.fsc_source_reestr.bank_name            IS 'Наименование банка (двухзвенная схема)'; --- text
COMMENT ON COLUMN fiscalization.fsc_source_reestr.bank_addr            IS 'Адрес банка';
COMMENT ON COLUMN fiscalization.fsc_source_reestr.bank_inn             IS 'ИНН банка (двухзвенная схема)'; --- text
COMMENT ON COLUMN fiscalization.fsc_source_reestr.bank_bik             IS 'БИК банка (двухзвенная схема)'; --- text
COMMENT ON COLUMN fiscalization.fsc_source_reestr.bank_phones          IS 'Контактные телефоны банка (двухзвенная схема)'; --- text[]
--
ALTER TABLE fiscalization.fsc_source_reestr
   ADD CONSTRAINT pk_source_reestr PRIMARY KEY (id_source_reestr);

ALTER TABLE fiscalization.fsc_source_reestr                    
   ADD CONSTRAINT ak1_source_reestr UNIQUE (external_id);                    

CREATE INDEX ie1_source_reestr 
         ON fiscalization.fsc_source_reestr USING btree (type_source_reestr, dt_create);
                    
CREATE INDEX ie2_source_reestr 
         ON fiscalization.fsc_source_reestr USING btree (id_pay);                    

--------------------------------------------------------------------------------------------------   
-- ALTER TABLE fiscalization.fsc_source_reestr ADD COLUMN id_pay   bigint;    
-- ALTER TABLE fiscalization.fsc_source_reestr ADD COLUMN rcp_type integer --  NOT NULL DEFAULT 0

-- UPDATE fiscalization.fsc_source_reestr SET type_source_reestr = 0;                    
-- ALTER TABLE fiscalization.fsc_source_reestr ADD COLUMN type_source_reestr integer;                    
-- ALTER TABLE fiscalization.fsc_source_reestr ALTER COLUMN type_source_reestr SET NOT NULL;                    
-- ALTER TABLE fiscalization.fsc_source_reestr ALTER COLUMN type_source_reestr SET DEFAULT 0;   
--
-- ALTER TABLE fiscalization.fsc_source_reestr ADD COLUMN external_id text;                    
-- ALTER TABLE fiscalization.fsc_source_reestr ALTER COLUMN external_id SET NOT NULL;                    
-- COMMENT ON COLUMN fiscalization.fsc_source_reestr.external_id IS 'Внешний идентификатор строки реестра (Внешний ID чека)'; 

