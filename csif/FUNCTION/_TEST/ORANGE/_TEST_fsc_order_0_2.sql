--
--  2023-08-24
--
-- ERROR:  invalid input syntax for type integer: "2.286469"
-- КОНТЕКСТ:  PL/pgSQL function inline_code_block line 14 at FOR over SELECT rows
-- SQL state: 22P02
-- Context: PL/pgSQL function inline_code_block line 14 at FOR over SELECT rows
BEGIN;
-- rollback;
DO
  $$
    DECLARE
  
      __rec         record;
      
      __position  public.positions_rt;
      __pmt       public.payments_rt; 

      __positions   json;
      __check_close json;
      __order       json;
  
    BEGIN
      FOR __rec IN 
      
        SELECT  
                z.receipt_id       
               ,z.dt_create        
               ,z.org_id           
               ,z.app_id           
               ,public.uuid_generate_v4() AS external_id -- z.ord__external_id 
               ,z.ord__inn         
               ,z.inn 
               
               ,f.grp_cash
               ,z.ord__group       
               ,z.ord__key         
               ,z.ord__content 
               ----------------
               ,(z.ord__content ->> 'type')::integer AS con_type  
               ,(z.ord__content ->> 'customerContact')::text AS customerContact
               --
               ,(z.ord__content #>> '{positions, 0, quantity}')::numeric (16,6)  AS quantity
               ,(z.ord__content #>> '{positions, 0, price}')::numeric(10,2) AS price
               ,(z.ord__content #>> '{positions, 0, tax}')::integer AS tax
               ,(z.ord__content #>> '{positions, 0, text}')::text   AS text
               ,(z.ord__content #>> '{positions, 0, paymentMethodType}')::integer  AS paymentMethodType
               ,(z.ord__content #>> '{positions, 0, paymentSubjectType}')::integer AS paymentSubjectType
               ,(z.ord__content #>> '{positions, 0, nomenclatureCode}')::text      AS nomenclatureCode   --
                   -- Почему NULL, почему присутсвует.
               --
               ,(z.ord__content #>> '{checkClose, taxationSystem}')::integer    AS taxationSystem
               ,(z.ord__content #>> '{checkClose, payments, 0, type}')::integer AS pmt_type
               ,(z.ord__content #>> '{checkClose, payments, 0, amount}')::numeric(10,2) AS amount
               ----------------
               ,z.amount           
               ,z.contact          
        
        FROM fiscalization.fsc_goback_orange z 
            INNER JOIN fiscalization.fsc_org_cash f ON (f.id_org = z.org_id)
			
	    WHERE  ((z.ord__content #>> '{positions, 0, quantity}')::numeric (16,6) is not null) and
		       ((z.ord__content #>> '{positions, 0, price}')::numeric(10,2) is not null) and
               ((z.ord__content #>> '{positions, 0, tax}')::integer is not null) and
               ((z.ord__content #>> '{positions, 0, text}')::text is not null)  
			
        
        -- LIMIT 1 

      LOOP 
          __position.quantity           :=  __rec.quantity ; --numeric(16,6),
          __position.price              :=  __rec.price ;    --numeric(10,2),
          __position.tax                :=  __rec.tax ;      --integer,
          __position.text               :=  __rec.text ;     --text,
          __position."paymentMethodType"  :=  coalesce (__rec."paymentMethodType", 3) ;  --integer,
          __position."paymentSubjectType" :=  coalesce (__rec."paymentSubjectType", 4) ; --integer,
          
          __positions := fsc_orange_pcg.fsc_positions_crt_2 ( -- Список предметов расчёта
             p_item := ARRAY [__position]::positions_rt[] 
           );
      
          __pmt.type   := __rec.pmt_type;
          __pmt.amount := __rec.amount;
          __check_close := fsc_orange_pcg.fsc_check_close_crt_2 ( -- Параметры закрытия чека 
                   
               p_taxationSystem := __rec.taxationSystem
              ,p_payments := fsc_orange_pcg.fsc_payments_crt_3(ARRAY[__pmt]::public.payments_rt[])

          );
      
          __order := fsc_orange_pcg.fsc_order_crt (
     
               p_external_id := __rec.external_id::text -- Внешний идентификатолр документа 
             , p_inn         := __rec.inn               -- ИНН организации, для которой пробивается чек
             , p_group       := __rec.grp_cash          -- Информация о типе коррекции ОПЦИОНАЛЬНО МОЖЕТ БЫТЬ "NULL"
             , p_key         := __rec.grp_cash        -- Название ключа, который должен быть использован для проверки подписи
             
             , p_content := fsc_orange_pcg.fsc_content_crt_1 ( -- Содержимое документа
             
                    p_type      := __rec.con_type -- Признак расчета
                   ,p_positions := __positions    -- Список предметов расчета, 1059
                   
                   ,p_check_close      := __check_close  -- Параметры закрытия чека
                   ,p_customer_contact := __rec.contact  -- Телефон или электронный адрес покупателя, 1008             
                 )
        );
        
        -- RAISE NOTICE '%', __order;
        
        INSERT INTO fiscalization.fsc_receipt(
                  dt_create
                , rcp_status
                , inn
                , rcp_nmb
                , id_org_app
                , rcp_order
                , id_fsc_provider
                , rcp_type
                )
        VALUES (
                 __rec.dt_create
                ,0
                ,__rec.inn
                ,__rec.external_id::text
                ,(SELECT id_org_app FROM fiscalization.fsc_org_app
                 	           WHERE (id_org = __rec.org_id) AND (id_app = __rec.app_id)
                 )
                 ,__order::jsonb
                 ,2
                 ,0
               );    
      END LOOP;  
    END;
  $$;    
    
-- BEGIN;
-- COMMIT;
-- ROLLBACK;

-- SELECT * FROM fiscalization.fsc_receipt_0 WHERE (id_fsc_provider = 2) -- 44 /99'999
-- DELETE FROM fiscalization.fsc_receipt_0 WHERE (id_fsc_provider = 2) -- 44
-- SELECT * FROM fiscalization.fsc_receipt_0 WHERE (id_fsc_provider = 1) -- 46
SELECT * FROM FISCALIZATION.FSC_ORG_APP WHERE (id_org_app = 150); -- 6|46
SELECT * FROM FISCALIZATION.fsc_org where (id_org = 6);
SELECT * FROM FISCALIZATION.fsc_app where (id_app = 46);
SELECT * FROM FISCALIZATION.fsc_app_param
    --
--  SELECT ord__content
--     ,(ord__content ->> 'type')::integer AS type  
--     ,(ord__content ->> 'customerContact')::text AS customerContact
--     --
--     ,(ord__content #>> '{positions, 0, quantity}')::integer AS quantity
--     ,(ord__content #>> '{positions, 0, price}')::numeric(10,2) AS price
--     ,(ord__content #>> '{positions, 0, tax}')::integer AS tax
--     ,(ord__content #>> '{positions, 0, text}')::text AS text
--     ,(ord__content #>> '{positions, 0, paymentMethodType}')::integer AS paymentMethodType
--     ,(ord__content #>> '{positions, 0, paymentSubjectType}')::integer AS paymentSubjectType
--     ,(ord__content #>> '{positions, 0, nomenclatureCode}')::text AS paymentSubjectType
--     --
--     ,(ord__content #>> '{checkClose, taxationSystem}')::integer AS taxationSystem
--     ,(ord__content #>> '{checkClose, payments, 0, type}')::integer AS pmt_type
--     ,(ord__content #>> '{checkClose, payments, 0, amount}')::numeric(10,2) AS amount
--     
--  FROM fiscalization.fsc_goback_orange LIMIT 10;    
 
-- NOTICE:  {"id": "e2a38908-52c6-4799-a16b-a6568121cefc", "inn": "5501174543", "group": "3010071", "content": {"type": 1, "positions": [{"tax": 1, "text": "Газоснабжение природным газом", "price": 17.67, "quantity": 1.000000, "paymentmethodtype": 3, "paymentsubjecttype": 4}], "checkClose": {"payments": [{"type": 2, "amount": 17.67}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "a.nasonov@omskregiongaz.ru"}, "          key": "3010071", "ignoreItemCodeCheck": false}
-- NOTICE:  {"id": "b830c43f-50f8-4cde-911e-59fe1c861d37", "inn": "5501174543", "group": "3010071", "content": {"type": 1, "positions": [{"tax": 1, "text": "Газоснабжение природным газом", "price": 17.67, "quantity": 1.000000, "paymentmethodtype": 3, "paymentsubjecttype": 4}], "checkClose": {"payments": [{"type": 2, "amount": 17.67}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "a.nasonov@omskregiongaz.ru"}, "          key": "3010071", "ignoreItemCodeCheck": false}
-- NOTICE:  {"id": "edb89bc1-0454-4a21-b1f7-0d9bffe9993c", "inn": "5501174543", "key": "3010071", "group": "3010071", "content": {"type": 1, "positions": [{"tax": 1, "text": "Газоснабжение природным газом", "price": 17.67, "quantity": 1.000000, "paymentMethodType": 3, "paymentSubjectType": 4}], "checkClose": {"payments": [{"type": 2, "amount": 17.67}], "taxationSystem": 0}, "ffdVersion": 4, "customerContact": "a.nasonov@omskregiongaz.ru"}, "ignoreItemCodeCheck": false}

-- SELECT * FROM fiscalization.fsc_receipt_0;
-- commit;

-- org.default_parameters
--   {"paymentTransferOperatorPhoneNumbers":null
--   ,"paymentOperatorPhoneNumbers":null
--   ,"paymentAgentPhoneNumbers":null
--   ,"supplierPhoneNumbers":null
--   ,"paymentType":"2"
--   ,"paymentOperatorINN":null
--   ,"agentType":"0"
--   ,"paymentAgentOperation":null
--   ,"paymentMethodType":"4"
--   ,"paymentOperatorName":null
--   ,"paymentOperatorAddress":null
--   ,"paymentSubjectType":"4"
--   ,"taxationSystem":"0"
--   ,"prType":"1"
--   ,"tax":"1"
--   }
