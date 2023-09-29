--
--  2023-08-24
--
BEGIN;
-- ROLLBACK;
CREATE TABLE fiscalization.fsc_goback_orange  
AS
SELECT receipt_id
     , (dt_create + interval '4 years') AS dt_create
	 , (dt_update + interval '4 years') AS dt_update
	 --, dt_remove
	 , org_id
	 , app_id
	 , (dt_fp + interval '4 years')  AS dt_fp
	 , fp
	 , ("order" ->> 'id')  AS ord__external_id
	 , ("order" ->> 'inn') AS ord__inn	
	 , ("order" ->> 'group') AS ord__group	
	 , ("order" ->> 'key') AS ord__key		 
	 , ("order" -> 'content') AS ord__content	
	-- , receipt
	-- , uid
	 , inn
	 , amount
	 , contact
--	, correction, notify_send, receipt_received, receipt_status, receipt_status_description, attributes
	FROM public.receipt_old LIMIT 100000;

SELECT * FROM fiscalization.fsc_goback_orange LIMIT 10;  	
SELECT * FROM fiscalization.fsc_org_cash WHERE (id_org = 101);
SELECT * FROM fiscalization.fsc_provider;


COMMIT;
SELECT * FROM fiscalization.fsc_org WHERE (id_org = 101); -- 5501174543
-- ---------------------------------------------------------------------
-- ИНН организации, для которой фискализируются чеки, клиент вроде бы и не нужен.
--
-- DROP TABLE fiscalization.fsc_goback_orange;

CREATE TABLE fiscalization.fsc_goback_orange
(
    receipt_id        bigint,
    dt_create         timestamp with time zone,
    dt_update         timestamp with time zone,
    org_id            integer,
    app_id            integer,
    dt_fp             timestamp with time zone,
    fp                character varying(255) COLLATE pg_catalog."default",
    ord__external_id  text COLLATE pg_catalog."default",
    ord__inn          text COLLATE pg_catalog."default",
    ord__group        text COLLATE pg_catalog."default",
    ord__key          text COLLATE pg_catalog."default",
    ord__content      json,
    inn               character varying(255) COLLATE pg_catalog."default",
    amount            real,
    contact           character varying(255) COLLATE pg_catalog."default"
);
--
{"type":1,"positions":[{ "quantity":1
                        ,"price":8.58
                        ,"tax":1
                        ,"text":"Газоснабжение природным газом (ЛС: 23101387)"
                        ,"paymentMethodType":4
                        ,"paymentSubjectType":4}
                     ],"checkClose":{"taxationSystem":0
                                     ,"payments":[{"type":14
                                                  ,"amount":8.58
                                                  }
                                                  ]
                                     }
                    ,"customerContact":"lk_query@prg.sura.ru"}
--
 { "id":"2015410"
  ,"inn":"7838056212"
  ,"group":"3010071"
  ,"key":"3010071"
  ,"content":{"type":1
              ,"positions":[
                    {"quantity":1
                    ,"price":86.62
                    ,"tax":1
                    ,"text":"ГАЗ (ЛС 721013989)"
                    ,"paymentMethodType":4
                    ,"paymentSubjectType":4
                    ,"nomenclatureCode":null
                    }
                    ]
              ,"checkClose":{"taxationSystem":0
                                   ,"payments":[{"type":2,"amount":86.62}]
                            }
              ,"customerContact":"daryag245@gmail.com"
             }
 }    
   
 SELECT ord__content
    ,(ord__content ->> 'type')::integer AS type  
    ,(ord__content ->> 'customerContact')::text AS customerContact
    --
    ,(ord__content #>> '{positions, 0, quantity}')::integer AS quantity
    ,(ord__content #>> '{positions, 0, price}')::numeric(10,2) AS price
    ,(ord__content #>> '{positions, 0, tax}')::integer AS tax
    ,(ord__content #>> '{positions, 0, text}')::text AS text
    ,(ord__content #>> '{positions, 0, paymentMethodType}')::integer AS paymentMethodType
    ,(ord__content #>> '{positions, 0, paymentSubjectType}')::integer AS paymentSubjectType
    ,(ord__content #>> '{positions, 0, nomenclatureCode}')::text AS paymentSubjectType
    --
    ,(ord__content #>> '{checkClose, taxationSystem}')::integer AS taxationSystem
    ,(ord__content #>> '{checkClose, payments, 0, type}')::integer AS pmt_type
    ,(ord__content #>> '{checkClose, payments, 0, amount}')::numeric(10,2) AS amount
    
 FROM fiscalization.fsc_goback_orange LIMIT 10;    
 
