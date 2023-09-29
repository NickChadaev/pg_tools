-- DROP TABLE fiscalization.fsc_goback;
CREATE TABLE fiscalization.fsc_goback (
   goback_data json
);

SELECT k.goback_data  FROM fiscalization.fsc_goback k;

BEGIN;
ROLLBACK;
COMMIT;
EXPLAIN
SELECT * FROM fsc_receipt_pcg.fsc_receipt_upd (
	(SELECT k.goback_data  FROM fiscalization.fsc_goback k) --, 0   -- 8557733579,  8557734614++
);	

-- SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 0) AND (rcp_nmb = '320aafd4-e484-43d8-8135-959f6d98b54f');
-- SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 1) AND (rcp_nmb = '320aafd4-e484-43d8-8135-959f6d98b54f');
-- SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 2) AND (rcp_nmb = '320aafd4-e484-43d8-8135-959f6d98b54f');

SELECT      x.uuid        
          , x.error       
          , x.status      
          , x.payload 
          --
          , (to_timestamp (x.timestamp, 'DD.MM.YYYY HH24:MI:SS'))::timestamp(0) without time zone   
          --
		  , (to_timestamp ((x.payload ->> 'receipt_datetime'), 'DD.MM.YYYY HH24:MI:SS'))::timestamp(0) without time zone AS ddt_fp  
          , (x.payload ->> 'fiscal_document_number')  AS fiscal_document_number
          , (x.payload ->> 'fiscal_document_attribute') AS fiscal_document_attribute
          
          , x.external_id 
          ,( json_strip_nulls (
                json_build_object (
                  'uuid ',        x.uuid     
                 ,'error',        x.error     
                 ,'status',       x.status    
                 ,'payload',      x.payload   
                 ,'timestamp',    x.timestamp 
                 ,'group_code',   x.group_code
                 ,'daemon_code',  x.daemon_code 
                 ,'device_code',  x.device_code 
                 ,'external_id',  x.external_id 
                 ,'callback_url', x.callback_url
               )
             )          
          ) AS js

FROM json_to_recordset ((SELECT k.goback_data  FROM fiscalization.fsc_goback k))   

AS x (  uuid         uuid
      , error        text
      , status       text
	  , payload      json
      , timestamp    text
      , group_code   text
      , daemon_code  text
      , device_code  text
      , external_id  text
      , callback_url text      
) WHERE (x.status = 'done');
