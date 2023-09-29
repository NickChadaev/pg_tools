--
-- 2023-07-26
--
BEGIN;
COMMIT;
ROLLBACK;

INSERT INTO fiscalization.fsc_receipt(
	  dt_create
	, rcp_status
	, inn
	, rcp_nmb
	, id_org_app
	, rcp_order
	, rcp_type
	, rcp_received
	, rcp_notify_send
	, id_pay
	, resend_pr
	,id_fsc_provider
	)
	VALUES ( now()  -- 1
	        , 0
	        , '772374659607'
	        , 'e6a8e854-b905-4f35-bfea-d24e197b92f0'
	        , 193
	        , $$
			{}
	         $$
	        , 0
	        , FALSE
	        , FALSE
	        , 1111
	        , 0
			,2
	    )
	   ,( now()   --2
	        , 0
	        , '480302439318'
	        , 'e1c96791-8b2d-4ffb-b258-96967ba4cfa7'
	        , 193
	        , $$
	            {}
	         $$
	        , 0
	        , FALSE
	        , FALSE
	        , 2222
	        , 0
		 ,2
	    )
	    ,(   now()  -- Его нет -- 3
	        , 0
	        , '501399333899'
	        , '7c3b0621-136e-418e-9f53-773a16f01b2b'
	        , 193
	        , $$
	           {}
	         $$
	        , 0
	        , FALSE
	        , FALSE
	        , 3333
	        , 0
		  ,2
	    )
	   ,( now() -- Секция 1 --4
	        , 1
	        , '480302439318'
	        , 'e1c96791-8b2d-4ffb-b258-96967ba4cfa7'
	        , 193
	        , $$
	            {}
	         $$
	        , 0
	        , FALSE
	        , FALSE
	        , 2222
	        , 0
		 ,2
	    )		
	;
	
--
SELECT * FROM fiscalization.fsc_receipt_0 LIMIT 10;
SELECT * FROM fiscalization.fsc_receipt_1;
-----------------------------------------------
--- id_receipt	dt_create	         rcp_status	dt_update	inn	rcp_nmb
--- 8557733490	2023-05-12 00:00:00+03	0	NULL	772374659607	0e3eae07-641d-4649-b939-a79198ada260
--- 8557733491	2023-05-12 00:00:00+03	0	NULL	480302439318	e1c96791-8b2d-4ffb-b258-96967ba4cfa7
--- 8557733492	2023-05-12 00:00:00+03	0	NULL	501300333831	7c3b0621-136e-418e-9e43-773a16f01b2b
--- 8557733493	2023-05-12 00:00:00+03	0	NULL	525704023313	8755d78c-ebdb-46ed-b3ad-22f8210902f3
--- 8557733494	2023-05-12 00:00:00+03	0	NULL	772374659607	9b48da60-f155-475d-9b20-6bd9c79f7a0e
--- 8557733495	2023-05-12 00:00:00+03	0	NULL	330570563700	0ec74dea-5a4f-4df6-916d-c76d36884d66
--- 8557733496	2023-05-12 00:00:00+03	0	NULL	330570563700	cf9efe77-36b7-4f6e-bf93-26c20c5c774e
--- 8557733497	2023-05-12 00:00:00+03	0	NULL	772146242437	7bd983a9-ebc8-46f1-95be-f8f4983e1889
--- 8557733498	2023-05-12 00:00:00+03	0	NULL	503217920531	e8690b61-0156-4360-9022-5aa904803187
--- 8557733499	2023-05-12 00:00:00+03	0	NULL	503608917174	a9041a18-6316-457f-9cf1-9b3da02e3470
