SELECT id_source_reestr, dt_create, company_email, company_sno, company_inn, company_payment_address, client_name, client_inn, pmt_type
     , pmt_sum, item_name, item_price, item_measure, item_quantity, item_sum, item_payment_method, payment_object, item_vat
	 , client_account, company_account, company_phones, company_name, company_bik, company_paying_agent, bank_name, bank_addr
	 , bank_inn, bank_bik, bank_phones, type_source_reestr, external_id
	FROM fiscalization.fsc_source_reestr WHERE (type_source_reestr = 0);
---
BEGIN;
SELECT id_source_reestr, dt_create, company_email, company_sno, company_inn, company_payment_address, client_name, client_inn, pmt_type
     , pmt_sum, item_name, item_price, item_measure, item_quantity, item_sum, item_payment_method, payment_object, item_vat
	 , client_account, company_account, company_phones, company_name, company_bik, company_paying_agent, bank_name, bank_addr
	 , bank_inn, bank_bik, bank_phones, type_source_reestr, external_id
	FROM fiscalization.fsc_source_reestr WHERE (type_source_reestr = 1);
--
DELETE FROM fiscalization.fsc_source_reestr WHERE (type_source_reestr = 1); -- DELETE 15232

COMMIT;
ROLLBACK;
---
SELECT * FROM fsc_receipt_pcg.version;