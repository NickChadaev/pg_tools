--
--   2023-08-25
--
BEGIN;
-- ROLLBACK;
-- COMMIT;
ALTER TABLE fiscalization.fsc_org_cash ADD COLUMN  org_cash_params	jsonb; 

COMMENT ON COLUMN fiscalization.fsc_org_cash.org_cash_params	
    IS 'Параметры по умолчанию';  

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
WITH x AS (
            SELECT z.org_id
                 , z.dt_create
                 , z.dt_update
                 , z.dt_remove
                 , z.name
                 , z.inn
                 , z.active
                 , z."group"
                 , z.default_parameters
                 , z.kkt_count
                 
            FROM public.org z
            WHERE ( z.dt_remove IS NULL) AND (z.active = 1)
)	
  UPDATE fiscalization.fsc_org_cash AS c
         SET  qty_cash        = x.kkt_count      
             ,grp_cash        = x."group"     
             ,nm_grp_cash     = x."group"
             ,org_cash_params = x.default_parameters
        FROM x     
  WHERE (x.org_id = c.id_org);        
--
--
SELECT * FROM fiscalization.fsc_org_cash;
 --
 
 
 --  Далее приложения.
 --
 --
 
 CREATE TABLE public.app
(
    app_id integer NOT NULL DEFAULT nextval('app_app_id_seq'::regclass),
    dt_create timestamp(6) with time zone NOT NULL DEFAULT now(),
    dt_update timestamp(6) with time zone NOT NULL DEFAULT now(),
    dt_remove timestamp(6) with time zone,
    uuid character varying(255) COLLATE pg_catalog."default" NOT NULL,
    secret character varying(255) COLLATE pg_catalog."default" NOT NULL,
    name character varying(255) COLLATE pg_catalog."default",
    notification_url character varying(255) COLLATE pg_catalog."default",
    orange_key character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT app_pkey PRIMARY KEY (app_id),
    CONSTRAINT uuid UNIQUE (uuid)
)
select * from public.app;
select * from fiscalization.fsc_app;
WITH y AS (
             SELECT 
                   l.app_id     
                 , l.secret         
                 , l.notification_url
                 , l.orange_key
             FROM public.app l
               INNER JOIN fiscalization.fsc_app j ON (j.id_app = l.app_id)
          )
          SELECT * FROM y
BEGIN; 
TRUNCATE TABLE fiscalization.fsc_app_param; 
INSERT INTO fiscalization.fsc_app_param
(
     id_app          
    ,id_fsc_provider 
    ,app_params      
) 
    SELECT 
          l.app_id     
        , 2 AS id_fsc_provider 
        , ( json_build_object (
                  'secret_key', l.secret 
                , 'notification_url', NULLIF (l.notification_url, '')
                , 'provaider_key', l.orange_key
            )
          )::jsonb   
    FROM public.app l
       INNER JOIN fiscalization.fsc_app j ON (j.id_app = l.app_id);

SELECT * FROM fiscalization.fsc_app_param;   
rollback;
commit;       
    
SELECT * FROM fiscalization.fsc_app;   	
   
ALTER TABLE fiscalization.fsc_app DROP COLUMN secret_key;
ALTER TABLE fiscalization.fsc_app DROP COLUMN notification_url;
ALTER TABLE fiscalization.fsc_app DROP COLUMN provaider_key;

