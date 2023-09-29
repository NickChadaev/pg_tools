--
--   2023-06-13
--
SELECT id_receipt
     , dt_create
	 , rcp_status
	 , dt_update
	 , inn
	 , rcp_nmb
	 , rcp_fp
	 , dt_fp
	 , id_org_app
	 , rcp_status_descr
	 , rcp_order
	 , rcp_receipt
	 , rcp_type
	 , rcp_received
	 , rcp_notify_send
	 , id_pmt_reestr
	 , resend_pr
	FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0 );
	--
	--  org_app, забsл про это совсем.
	--
	SELECT x.*, z.* FROM fiscalization.fsc_org_app y
	    JOIN fiscalization.fsc_org x ON (x.id_org = y.id_org)
		JOIN fiscalization.fsc_app z ON (z.id_app = y.id_app)
	WHERE (id_org_app = 189);
	
	
INSERT INTO fiscalization.fsc_receipt(
	  id_receipt
	, dt_create       -- d
	, rcp_status      -- 0
	, dt_update
	, inn             -- d
	, rcp_nmb         -- d
	, rcp_fp
	, dt_fp
	, id_org_app      -- 189
	, rcp_status_descr
	, rcp_order       -- d
	, rcp_receipt
	, rcp_type        -- 0
	, rcp_received    -- false
	, rcp_notify_send -- false
	, id_pmt_reestr   -- d
	, resend_pr       -- 0    
  )
	VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);	
