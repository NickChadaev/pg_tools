select * from fiscalization.fsc_receipt WHERE (id_receipt = 3651966647);

SELECT id_receipt, dt_create, rcp_receipt
	FROM "_OLD_4_fiscalization".fsc_receipt_result WHERE (id_receipt = 3651966647);
	
{
    "fp": "2145058077",
    "id": "6758116",
    "change": 0,
    "ofdinn": "7605016030",
    "content": {
        "type": 1,
        "positions": [
            {
                "tax": 1,
                "text": "Сетевой газ (ЛС 280000372121)",
                "price": 368.84,
                "quantity": 1,
                "paymentMethodType": 4,
                "paymentSubjectType": 4
            }
        ],
        "checkClose": {
            "payments": [
                {
                    "type": 2,
                    "amount": 368.84
                }
            ],
            "taxationSystem": 0
        },
        "customerContact": "molochinskaye@mail.ru"
    },
    "ofdName": "КОМПАНИЯ ТЕНЗОР ООО",
    "deviceRN": "0002639429058789",
    "deviceSN": "0163760038004721",
    "fsNumber": "9285440300311381",
    "companyINN": "2308070396",
    "fnsWebsite": "www.nalog.ru",
    "ofdWebsite": "www.sbis.ru",
    "companyName": "Общество с ограниченной ответственностью  \"ГАЗПРОМ МЕЖРЕГИОНГАЗ КРАСНОДАР\"",
    "processedAt": "2021-01-01T00:00:00",
    "shiftNumber": 3,
    "documentIndex": 45,
    "documentNumber": 9386
}	
-------------------------------------------------------------

SELECT id_receipt, dt_create, rcp_receipt
	FROM "_OLD_4_fiscalization".fsc_receipt_result LIMIT 10; --- 3651966647
-------------------------------------------------------------
{
    "fp": "2145058077",
    "id": "6758116",
    "change": 0,
    "ofdinn": "7605016030",
    "content": {
        "type": 1,
        "positions": [
            {
                "tax": 1,
                "text": "Сетевой газ (ЛС 280000372121)",
                "price": 368.84,
                "quantity": 1,
                "paymentMethodType": 4,
                "paymentSubjectType": 4
            }
        ],
        "checkClose": {
            "payments": [
                {
                    "type": 2,
                    "amount": 368.84
                }
            ],
            "taxationSystem": 0
        },
        "customerContact": "molochinskaye@mail.ru"
    },
    "ofdName": "КОМПАНИЯ ТЕНЗОР ООО",
    "deviceRN": "0002639429058789",
    "deviceSN": "0163760038004721",
    "fsNumber": "9285440300311381",
    "companyINN": "2308070396",
    "fnsWebsite": "www.nalog.ru",
    "ofdWebsite": "www.sbis.ru",
    "companyName": "Общество с ограниченной ответственностью  \"ГАЗПРОМ МЕЖРЕГИОНГАЗ КРАСНОДАР\"",
    "processedAt": "2021-01-01T00:00:00",
    "shiftNumber": 3,
    "documentIndex": 45,
    "documentNumber": 9386
}
