--
-- 2023-08-21. Пример ответа на успешную фискализацию 
--
-- DROP TABLE fiscalization.fsc_goback;
-- CREATE TABLE fiscalization.fsc_goback (
--    goback_data json
-- );

INSERT INTO  fiscalization.fsc_goback (goback_data)
    VALUES (
'[{ "id": "6157390d-0a09-45f7-84c8-bda391fde932",
    "inn": "1834021673", 
    "deviceSN": "0000000000001358",
    "deviceRN": "0000000400054952",
    "fsNumber": "9999078900001341",
    "ofdName": "НТТ Контур",
    "ofdWebsite": "www.kontur.ru",
    "ofdinn": "7728699517",
    "fnsWebsite": "www.nalog.ru",
    "companyINN": "1834021673",
    "companyName": "ООО \"Газпром межрегионгаз Ижевск\"",
    "documentNumber": 117,
    "shiftNumber": 20,
    "documentIndex": 5,
    "processedAt": "2023-08-10T19:43:39",
    "content": {
          "type": 1,
          "positions": [
              {
                  "tax": 1,
                  "text": "Газоснабжение природным газом",
                  "price": 281.87,
                  "quantity": 1,
                  "paymentMethodType": 4,
                  "paymentSubjectType": 4
              }
          ],
          "checkClose": {
              "payments": [
                  {
                      "type": 14,
                      "amount": 281.87
                  }
              ],
              "taxationSystem": 0
          },
          "ffdVersion": 4,
          "customerContact": "noreply@udmurtgaz.ru"
      },  
  
    "change": 0.01,
    "fp": "2364009522"
  }
, {
    "id": "65dc53cd-e976-4ccc-895a-800ab2eb1028",
    "inn": "3525104171", 
    "deviceSN": "0000000000001358",
    "deviceRN": "0000000400054952",
    "fsNumber": "9999078900001341",
    "ofdName": "НТТ Контур",
    "ofdWebsite": "www.kontur.ru",
    "ofdinn": "7728699517",
    "fnsWebsite": "www.nalog.ru",
    "companyINN": "3525104171",
    "companyName": "ООО \"Газпром межрегионгаз Вологда\"",
    "documentNumber": 118,
    "shiftNumber": 21,
    "documentIndex": 5,
    "processedAt": "2023-08-21T14:57:39",
    "content": {
        "type": 1,
        "positions": [
            {
                "tax": 1,
                "text": "Газоснабжение природным газом (ЛС: 01012495)",
                "price": 75.15,
                "quantity": 1,
                "paymentMethodType": 3,
                "paymentSubjectType": 4
            }
        ],
        "checkClose": {
            "payments": [
                {
                    "type": 2,
                    "amount": 75.52
                }
            ],
            "taxationSystem": 0
        },
        "ffdVersion": 4,
        "customerContact": "checkonlineAO@vologdarg.ru"
    },
  
    "change": 0.11,
    "fp": "2371009411"
  }]'
);

-- ----------------------------------------------------------------
SELECT * FROM fiscalization.fsc_goback;
