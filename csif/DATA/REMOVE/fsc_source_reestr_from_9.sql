--
--    2023-08-07
--
BEGIN;
COMMIT;
ROLLBACK;

INSERT INTO fiscalization.fsc_source_reestr (
	  id_source_reestr, dt_create, id_pay, rcp_type, company_email, company_sno, company_inn
	, company_payment_address, client_name, client_inn, pmt_type, pmt_sum, item_name, item_price
	, item_measure, item_quantity, item_sum, item_payment_method, payment_object, item_vat, type_source_reestr
	, external_id, client_account, company_account, company_phones, company_name, company_bik, company_paying_agent
	, bank_name, bank_addr, bank_inn, bank_bik, bank_phones
)

SELECT	id_source_reestr, dt_create, id_pay, rcp_type, company_email, company_sno, company_inn
        , company_payment_address, client_name, client_inn, pmt_type, pmt_sum, item_name, item_price
		, item_measure, item_quantity, item_sum, item_payment_method, payment_object, item_vat, type_source_reestr
		, external_id, client_account, company_account, company_phones, company_name, company_bik, company_paying_agent
		, bank_name, bank_addr, bank_inn, bank_bik, bank_phones
FROM "_OLD_9_fiscalization".fsc_source_reestr;	

SELECT	id_source_reestr, dt_create, id_pay, rcp_type, company_email, company_sno, company_inn
        , company_payment_address, client_name, client_inn, pmt_type, pmt_sum, item_name, item_price
		, item_measure, item_quantity, item_sum, item_payment_method, payment_object, item_vat, type_source_reestr
		, external_id, client_account, company_account, company_phones, company_name, company_bik, company_paying_agent
		, bank_name, bank_addr, bank_inn, bank_bik, bank_phones
FROM fiscalization.fsc_source_reestr;	

SELECT count (1), client_inn FROM fiscalization.fsc_source_reestr GROUP BY client_inn ORDER BY 1 desc;	
----
-- count	client_inn
-- 3	773411572003
-- 2	330570563700
-- 2	772374659607
-- 2	260902896607
-- 1	502410561536

SELECT count (1), company_inn FROM fiscalization.fsc_source_reestr GROUP BY company_inn ORDER BY 1 desc;	

-- count	company_inn
-- 32	7702070139
-- 21	7710140679


