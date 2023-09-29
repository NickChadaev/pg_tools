--
--   2023-08-11 --
--
SELECT id_receipt, dt_create, rcp_status, dt_update, inn, rcp_nmb, rcp_fp, dt_fp, id_org_app, rcp_status_descr, rcp_order
, rcp_receipt, id_fsc_provider, rcp_type, rcp_received, rcp_notify_send, id_pay, resend_pr
	FROM fiscalization.fsc_receipt WHERE (rcp_status = 0) AND (id_pay = 382322);
--
{
    "receipt": {
        "items": [
            {
                "sum": 10550.37,
                "vat": {
                    "type": "vat0"
                },
                "name": ", НДС не облагается, <ЛС 81590188;ПРД04.2023>",
                "price": 10550.37,
                "measure": 0,
                "quantity": 1,
                "agent_info": {
                    "type": "bank_paying_agent",
                    "paying_agent": {
                        "phones": [
                            "+74212455455"
                        ],
                        "operation": "Платёж"
                    },
                    "money_transfer_operator": {
                        "inn": "7702070139",
                        "name": "ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск",
                        "phones": [
                            "+74212455455"
                        ],
                        "address": "680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1"
                    },
                    "receive_payments_operator": {
                        "phones": [
                            "+74212455455"
                        ]
                    }
                },
                "supplier_info": {
                    "inn": "7702070139",
                    "name": "ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск",
                    "phones": [
                        "+74212455455"
                    ]
                },
                "payment_method": "full_payment",
                "payment_object": 1
            }
        ],
        "total": 10550.37,
        "client": {
            "inn": "272011197560",
            "name": "ИНН 272011197560 Суворов Сергей Александрович"
        },
        "company": {
            "inn": "7702070139",
            "sno": "osn",
            "email": "email@ofd.ru",
            "payment_address": "680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1"
        },
        "payments": [
            {
                "pmt_sum": 10550.37,
                "pmt_type": 1
            }
        ]
    },
    "service": {
        "callback_url": "www.xxx.ru"
    },
    "timestamp": "13.05.2023 12:05::00",
    "external_id": "a8c63070-b8f7-429d-a494-710d7fee87e0",
    "ism_optional": true
}

{
    "receipt": {
        "items": [
            {
                "sum": 10550.37,
                "vat": {
                    "type": "vat0"
                },
                "name": ", НДС не облагается, <ЛС 81590188;ПРД04.2023>",
                "price": 10550.37,
                "measure": 0,
                "quantity": 1,
                "agent_info": {
                    "type": "bank_paying_agent",
                    "paying_agent": {
                        "phones": [
                            "+74212455455"
                        ],
                        "operation": "Платёж"
                    },
                    "money_transfer_operator": {
                        "inn": "7702070139",
                        "name": "ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск",
                        "phones": [
                            "+74212455455"
                        ],
                        "address": "680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1"
                    },
                    "receive_payments_operator": {
                        "phones": [
                            "+74212455455"
                        ]
                    }
                },
                "supplier_info": {
                    "inn": "7702070139",
                    "name": "ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск",
                    "phones": [
                        "+74212455455"
                    ]
                },
                "payment_method": "full_payment",
                "payment_object": 1
            }
        ],
        "total": 10550.37,
        "client": {
            "inn": "272011197560",
            "name": "ИНН 272011197560 Суворов Сергей Александрович"
        },
        "company": {
            "inn": "7702070139",
            "sno": "osn",
            "email": "email@ofd.ru",
            "payment_address": "680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1"
        },
        "payments": [
            {
                "pmt_sum": 10550.37,
                "pmt_type": 1
            }
        ]
    },
    "service": {
        "callback_url": "email@ofd.ru"
    },
    "timestamp": "13.05.2023 12:05::00",
    "external_id": "a8c63070-b8f7-429d-a494-710d7fee87e0",
    "ism_optional": true
}
