SELECT id_app, dt_create, dt_update, dt_remove, app_guid, secret_key, nm_app, notification_url, provaider_key, app_status
	FROM fiscalization.fsc_app WHERE (id_app IN (10, 67));
	
SELECT * FROM fiscalization.fsc_org_app ORDER BY 1 DESC;
SELECT * FROM fiscalization.fsc_org ORDER BY 1 DESC;


SELECT    
   	                      x.id_source_reestr
                        , x.dt_create
                        , x.company_email
                        , x.company_sno
						, x.company_name
						, z.nm_org_name
						, z.id_org
						, (SELECT k.id_org_app FROM fiscalization.fsc_org_app k WHERE (z.id_org = k.id_org) LIMIT 1)
                        , x.company_inn
						, x.company_bik
                        , x.company_payment_address
                        , x.client_name
                        , x.client_inn
                        , x.pmt_type
                        , x.pmt_sum
                        , substr (x.item_name, 1, 1300) AS item_name  -- ???
                        , x.item_price
                        , x.item_measure
                        , x.item_quantity
                        , x.item_sum
                        , x.item_payment_method
                        , x.payment_object
                        , x.item_vat
                        , x.client_account
                        , x.company_account
                        , x.company_phones
                        , x.company_name
                        , x.company_bik
                        , x.company_paying_agent
                        , x.bank_name
                        , x.bank_addr
                        , x.bank_inn
                        , x.bank_bik
                        , x.bank_phones 
                        , x.external_id
						---
                FROM fiscalization.fsc_source_reestr x 
				  INNER JOIN  fiscalization.fsc_org z ON ( fsc_receipt_pcg.f_xxx_replace_char(x.company_name) =
						                                   fsc_receipt_pcg.f_xxx_replace_char(z.nm_org_name)
														 )
                        WHERE (x.type_source_reestr = 0) 
-- -------------------------------------------------------------
SELECT  count (1)
      , x.company_bik
                          
                FROM fiscalization.fsc_source_reestr x 
                        WHERE (x.type_source_reestr = 0) 
                 GROUP BY x.company_bik
---------------------------------------------------------
-- count	company_bik
-- 1	040813713
-- 1	042007855
-- 30	044525745
-- 21	044525974



						7702070139
						7710140679