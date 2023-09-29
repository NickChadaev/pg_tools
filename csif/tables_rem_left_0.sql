/*==============================================================*/
/* Table: fsc_source_reestr                                     */
/*==============================================================*/
CREATE TABLE fiscalization.fsc_source_reestr (
   ,dt_create               timestamp(0)  without time zone NOT NULL DEFAULT now()
   ,id_pay                  bigint           NOT NULL
   ,rcp_type                operation_t      NOT NULL DEFAULT 'sell'
 
   ,company_email           text             NOT NULL 
   ,company_sno             sno_t            NOT NULL DEFAULT 'osn'
   ,company_inn             text             NOT NULL 
   ,company_payment_address text             NOT NULL 

   ,company_phones        text[]

   ,company_name          text 
   ,company_bik           text
   ,company_paying_agent  boolean NOT NULL DEFAULT false
   
   ,client_name             text             NOT NULL 
   ,client_account          text
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
   --
   
   ,bank_name             text
   ,bank_addr             text
   ,bank_inn              text
   ,bank_bik              text
   ,bank_phones           text[]
);
