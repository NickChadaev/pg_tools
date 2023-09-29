--
--  2023-05-11
--
-- fsc_app.id_app
--
SELECT setval('fiscalization.fsc_app_id_app_seq'::regclass,
   (SELECT COALESCE ((max(id_app) + 10), 1) FROM fiscalization.fsc_app)
);
SELECT * FROM fiscalization.fsc_app_id_app_seq; -- 66
--
-- fsc_org.id_org
--
SELECT setval('fiscalization.fsc_org_id_org_seq'::regclass,
   (SELECT COALESCE ((max(id_org) + 10), 1) FROM fiscalization.fsc_org)
);
SELECT * FROM fiscalization.fsc_org_id_org_seq;  -- 123
--
--  fsc_receipt.id_receipt
--
SELECT setval('fiscalization.fsc_receipt_id_receipt_seq'::regclass,
   (SELECT COALESCE ((max(id_receipt) + 1000), 1) FROM fiscalization.fsc_receipt)
);
SELECT * FROM fiscalization.fsc_receipt_id_receipt_seq; -- 8557712715
--
--  fsc_org_app.id_org_app
--
SELECT setval('fiscalization.fsc_org_app_id_org_app_seq'::regclass,
   (SELECT COALESCE ((max(id_org_app) + 10), 1) FROM fiscalization.fsc_org_app)
);
SELECT * FROM fiscalization.fsc_org_app_id_org_app_seq; -- 188
--
-- fsc_provider.id_fsc_provider
--
SELECT setval('fiscalization.fsc_provider_id_seq'::regclass,
   (SELECT COALESCE ((max(id_fsc_provider) + 10), 1) FROM fiscalization.fsc_provider)
);
SELECT * FROM fiscalization.fsc_provider_id_seq; --12
--
--  fsc_org_cash.id_org_cash
--  
SELECT setval('fiscalization.fsc_org_cash_id_seq'::regclass,
   (SELECT COALESCE ((max(id_org_cash) + 10), 1) FROM fiscalization.fsc_org_cash)
);
SELECT * FROM fiscalization.fsc_org_cash_id_seq; -- 63
--  
-- fsc_app_param.id_app_param
--
SELECT setval('fiscalization.fsc_app_param_id_seq'::regclass,
   (SELECT COALESCE ((max(id_app_param) + 10), 1) FROM fiscalization.fsc_app_param)
);
SELECT * FROM fiscalization.fsc_app_param_id_seq; -- 1
--  
--  fsc_data_operator.id_fsc_data_operator
--
SELECT setval('fiscalization.fsc_data_operator_id_seq'::regclass,
   (SELECT COALESCE ((max(id_fsc_data_operator) + 10), 1) FROM fiscalization.fsc_data_operator)
);
SELECT * FROM fiscalization.fsc_data_operator_id_seq; -- 20

--  2023-06-02

SELECT setval('fiscalization.fsc_source_reestr_id_reestr_seq'::regclass,
   (SELECT COALESCE ((max(id_source_reestr) + 10), 1) FROM fiscalization.fsc_source_reestr)
);
SELECT * FROM fiscalization.fsc_source_reestr_id_reestr_seq; --
