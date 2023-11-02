--
--   2023-10-31  Тестирование.
--
BEGIN;
   SELECT * FROM gar_fias_pcg_load.f_addr_area_show_data (p_fias_guid := NULL::uuid, p_qty := 1);  -- 35
   ----------------------------------------------------------------------------------------------------
-- 99943763|294728|'2a379956-d5f4-4562-88ca-c2d78fbba9d5'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Адлерский'|294|'р-н'|7|'Элемент планировочной структуры'|'23'|'0'|'7'|'0'|'124'|'0'|168015178|0|10|'Добавление'|'2021-01-14'|'2079-06-06'|99943763|'{294673,294728,99943763}'|3
-- 294949|294728|'f1acccf5-36e2-44d5-9143-437cc7459ed1'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Адлерский'|44|'р-н'|14|'Уровень внутригородской территории (устаревшее)'|'23'|'0'|'7'|'0'|'0'|'0'|750158|0|10|'Добавление'|'2016-01-27'|'2079-06-06'|99943763|'{294673,294728,294949}'|3
-- 294889|294728|'c1a53fdf-ae81-45fe-9fa2-7d0f6a8fee29'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Лазаревский'|44|'р-н'|14|'Уровень внутригородской территории (устаревшее)'|'23'|'0'|'7'|'0'|'0'|'0'|749922|0|10|'Добавление'|'2016-01-27'|'2079-06-06'|99943765|'{294673,294728,294889}'|3
-- 99943765|294728|'a7c3f354-52c1-4a5d-ad86-5cc6e23290b0'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Лазаревский'|294|'р-н'|7|'Элемент планировочной структуры'|'23'|'0'|'7'|'0'|'154'|'0'|168015180|0|10|'Добавление'|'2021-01-14'|'2079-06-06'|99943765|'{294673,294728,99943765}'|3
-- 99943764|294728|'19525af7-ff4b-41e6-bd2c-3c3eeff87bc0'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Хостинский'|294|'р-н'|7|'Элемент планировочной структуры'|'23'|'0'|'7'|'0'|'125'|'0'|168015179|0|10|'Добавление'|'2021-01-14'|'2079-06-06'|99943764|'{294673,294728,99943764}'|3
-- 294943|294728|'f6b06e5e-8595-4d53-a350-d639279d8d76'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Хостинский'|44|'р-н'|14|'Уровень внутригородской территории (устаревшее)'|'23'|'0'|'7'|'0'|'0'|'0'|750138|0|10|'Добавление'|'2016-01-27'|'2079-06-06'|99943764|'{294673,294728,294943}'|3
-- 293153|294728|'7904ecca-69e9-470a-9ac9-2fc617cd26f5'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Барановка'|103|'с'|6|'Населенный пункт'|'23'|'0'|'7'|'152'|'0'|'0'|744885|0|10|'Добавление'|'2016-03-16'|'2079-06-06'|295241|'{294673,294728,293153}'|3
-- 295241|294728|'71352f32-e764-48de-b0f5-35d1e5edf4b4'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Барановка'|103|'с'|6|'Населенный пункт'|'23'|'0'|'7'|'190'|'0'|'0'|751024|0|10|'Добавление'|'2016-03-17'|'2079-06-06'|295241|'{294673,294728,295241}'|3
-- 301231|294728|'00e07bc0-ce54-4e4f-8506-940701fc1065'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Садовод-2'|194|'снт'|8|'Элемент улично-дорожной сети'|'23'|'0'|'7'|'0'|'0'|'1259'|770661|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|312066|'{294673,294728,301231}'|3
-- 312066|294728|'8e9dfc95-df54-41e9-a781-863684049ae8'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Садовод-2'|428|'снт'|7|'Элемент планировочной структуры'|'23'|'0'|'7'|'0'|'1371'|'0'|803393|380646|50|'Переподчинение'|'2016-09-29'|'2079-06-06'|312066|'{294673,294728,312066}'|3
-- 325226|329347|'3bb9df71-9cf3-443d-bcb0-331cc078d059'|'72700ecb-d9cb-4bcf-82f6-b55b06637d0b'|'Северный'|90|'п'|6|'Населенный пункт'|'23'|'19'|'0'|'45'|'0'|'0'|835167|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|325949|'{294673,329347,325226}'|3
-- 325949|329347|'d02344b2-1d15-4f21-8ff1-d4e9f5faa2a3'|'72700ecb-d9cb-4bcf-82f6-b55b06637d0b'|'Северный'|90|'п'|6|'Населенный пункт'|'23'|'19'|'0'|'27'|'0'|'0'|836903|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|325949|'{294673,329347,325949}'|3
-- 330053|329692|'d2a047a9-09ec-4ce3-9a72-6f3ae6807363'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Веселый'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'16'|'0'|'0'|848084|401502|20|'Изменение'|'2019-05-21'|'2079-06-06'|330195|'{294673,329692,330053}'|3
-- 326475|329692|'90053520-f8a3-4d82-9638-2cc3f2a081d0'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Веселый'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'111'|'0'|'0'|838240|397515|20|'Изменение'|'2019-05-21'|'2079-06-06'|330195|'{294673,329692,326475}'|3
-- 330195|329692|'e667eb59-42c7-4810-9381-8ed5e7779d19'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Веселый'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'17'|'0'|'0'|848426|401659|20|'Изменение'|'2019-05-21'|'2079-06-06'|330195|'{294673,329692,330195}'|3
-- 324606|329692|'6bc1ac1b-655c-46a0-9ca1-f9a248c0f4c5'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Красный'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'112'|'0'|'0'|833734|395308|20|'Изменение'|'2019-05-21'|'2079-06-06'|330138|'{294673,329692,324606}'|3
-- 330138|329692|'7f3cd943-57b5-4907-9835-1cf0265a8aea'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Красный'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'38'|'0'|'0'|848246|401596|20|'Изменение'|'2019-05-21'|'2079-06-06'|330138|'{294673,329692,330138}'|3
-- 330285|329692|'afcf4c3b-0b37-4257-b31e-f37664118131'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Ленинский'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'114'|'0'|'0'|848658|401758|20|'Изменение'|'2019-05-21'|'2079-06-06'|330285|'{294673,329692,330285}'|3
-- 327816|329692|'6ad576a4-47d5-4624-b7e4-546e70c15fb1'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Ленинский'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'42'|'0'|'0'|841567|399017|20|'Изменение'|'2019-05-21'|'2079-06-06'|330285|'{294673,329692,327816}'|3
-- 329712|329692|'cfeb9372-59a8-42d1-a465-c21076e4f2b2'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Садовый'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'81'|'0'|'0'|846917|401115|20|'Изменение'|'2019-05-21'|'2079-06-06'|329831|'{294673,329692,329712}'|3
-- 329831|329692|'548c9025-f0d4-45d8-b044-85d095311604'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Садовый'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'82'|'0'|'0'|847397|401247|20|'Изменение'|'2019-05-21'|'2079-06-06'|329831|'{294673,329692,329831}'|3
-- 326942|330990|'ae1161cf-e1ba-41f6-a12b-8f1aae1d03dc'|'5238a201-1524-4759-b69b-8fbd454db279'|'Водяная Балка'|112|'х'|6|'Населенный пункт'|'23'|'20'|'0'|'90'|'0'|'0'|839313|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|327868|'{294673,330990,326942}'|3
-- 327868|330990|'ab2ab96d-6248-466c-aca3-e2f5a8d01727'|'5238a201-1524-4759-b69b-8fbd454db279'|'Водяная Балка'|112|'х'|6|'Населенный пункт'|'23'|'20'|'0'|'11'|'0'|'0'|841686|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|327868|'{294673,330990,327868}'|3
-- 327570|330990|'51f1ee41-eaca-4d28-85dd-1dce14ce5adb'|'5238a201-1524-4759-b69b-8fbd454db279'|'Красный'|112|'х'|6|'Населенный пункт'|'23'|'20'|'0'|'88'|'0'|'0'|840891|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|389265|'{294673,330990,327570}'|3
-- 389265|330990|'e720ecb6-7f06-44cb-99bc-acb7c8ccd459'|'5238a201-1524-4759-b69b-8fbd454db279'|'Красный'|112|'х'|6|'Населенный пункт'|'23'|'20'|'0'|'40'|'0'|'0'|990253|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|389265|'{294673,330990,389265}'|3
-- 330996|334129|'d6aec81c-3e8d-4f8b-89f3-b6e8d55bb0bf'|'caed4250-d7fc-4e45-b431-5e1ae870cac5'|'Степной'|90|'п'|6|'Населенный пункт'|'23'|'24'|'0'|'48'|'0'|'0'|850942|402537|20|'Изменение'|'2014-01-04'|'2079-06-06'|331700|'{294673,334129,330996}'|3
-- 331700|334129|'d91fcad5-da7c-476c-ad6b-8425886a16ff'|'caed4250-d7fc-4e45-b431-5e1ae870cac5'|'Степной'|90|'п'|6|'Населенный пункт'|'23'|'24'|'0'|'70'|'0'|'0'|853150|0|10|'Добавление'|'2019-05-20'|'2079-06-06'|331700|'{294673,334129,331700}'|3
-- 339029|337704|'764a31e3-3127-439f-9cdc-94465ab0502b'|'f4ab6f10-4f56-4ebd-a881-4b767dbf4473'|'Октябрьский'|90|'п'|6|'Населенный пункт'|'23'|'33'|'0'|'47'|'0'|'0'|871959|0|10|'Добавление'|'2012-03-15'|'2079-06-06'|339029|'{294673,337704,339029}'|3
-- 338004|337704|'5d03768e-ff31-47bb-b31b-3bd99d6045aa'|'f4ab6f10-4f56-4ebd-a881-4b767dbf4473'|'Октябрьский'|90|'п'|6|'Населенный пункт'|'23'|'33'|'0'|'44'|'0'|'0'|869745|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|339029|'{294673,337704,338004}'|3
-- 338208|337720|'d4598143-50c8-4ac5-a619-db5fa892a620'|'f86e1bda-2165-4dc1-904e-604d2f468702'|'Прикубанский'|112|'х'|6|'Населенный пункт'|'23'|'30'|'0'|'52'|'0'|'0'|870221|410709|20|'Изменение'|'2019-05-21'|'2079-06-06'|338208|'{294673,337720,338208}'|3
-- 335167|337720|'48bc5212-3a9e-406f-85ab-60fee33b6f2e'|'f86e1bda-2165-4dc1-904e-604d2f468702'|'Прикубанский'|112|'х'|6|'Населенный пункт'|'23'|'30'|'0'|'27'|'0'|'0'|863368|407229|20|'Изменение'|'2019-05-21'|'2079-06-06'|338208|'{294673,337720,335167}'|3
-- 341903|340477|'8ef5cd22-95e8-42bd-a663-5325df6f14d1'|'2b521963-2a08-4198-89a4-23981e86b3fb'|'Ленинский'|112|'х'|6|'Населенный пункт'|'23'|'34'|'0'|'24'|'0'|'0'|879186|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|342196|'{294673,340477,341903}'|3
-- 342196|340477|'cb683ebb-fa49-45c1-a51c-18175b4e0e60'|'2b521963-2a08-4198-89a4-23981e86b3fb'|'Ленинский'|112|'х'|6|'Населенный пункт'|'23'|'34'|'0'|'50'|'0'|'0'|880000|0|10|'Добавление'|'2016-01-21'|'2079-06-06'|342196|'{294673,340477,342196}'|3
-- 341997|343780|'20849f44-cc25-41fc-be44-8f9eb57b1dbb'|'8bd71693-7c44-4550-ae82-f17a0379ebaf'|'Западный'|90|'п'|6|'Населенный пункт'|'23'|'35'|'0'|'72'|'0'|'0'|879439|0|10|'Добавление'|'1992-01-01'|'2079-06-06'|341997|'{294673,343780,341997}'|3
-- 341363|343780|'ab99f93d-f4c6-4c38-ad17-91a0765930a4'|'8bd71693-7c44-4550-ae82-f17a0379ebaf'|'Западный'|90|'п'|6|'Населенный пункт'|'23'|'35'|'0'|'12'|'0'|'0'|877581|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|341997|'{294673,343780,341363}'|3

--
SELECT * FROM gar_fias_pcg_load.f_addr_area_set_data ( 
       p_fias_guid  := NULL::uuid     
      ,p_qty        := 1
      ,p_descr      := 'ТЕСТ. Краснодар'   
);      --  35

SELECT * FROM gar_fias.gap_adr_area WHERE (date_create = current_date) ORDER BY nm_addr_obj;
--------------------------------------------------------------------------------------------
-- 294949|294728|'f1acccf5-36e2-44d5-9143-437cc7459ed1'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Адлерский'|44|'р-н'|14|'Уровень внутригородской территории (устаревшее)'|'23'|'0'|'7'|'0'|'0'|'0'|750158|0|10|'Добавление'|'2016-01-27'|'2079-06-06'|99943763|'{294673,294728,294949}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 99943763|294728|'2a379956-d5f4-4562-88ca-c2d78fbba9d5'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Адлерский'|294|'р-н'|7|'Элемент планировочной структуры'|'23'|'0'|'7'|'0'|'124'|'0'|168015178|0|10|'Добавление'|'2021-01-14'|'2079-06-06'|99943763|'{294673,294728,99943763}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 293153|294728|'7904ecca-69e9-470a-9ac9-2fc617cd26f5'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Барановка'|103|'с'|6|'Населенный пункт'|'23'|'0'|'7'|'152'|'0'|'0'|744885|0|10|'Добавление'|'2016-03-16'|'2079-06-06'|295241|'{294673,294728,293153}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 295241|294728|'71352f32-e764-48de-b0f5-35d1e5edf4b4'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Барановка'|103|'с'|6|'Населенный пункт'|'23'|'0'|'7'|'190'|'0'|'0'|751024|0|10|'Добавление'|'2016-03-17'|'2079-06-06'|295241|'{294673,294728,295241}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 330053|329692|'d2a047a9-09ec-4ce3-9a72-6f3ae6807363'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Веселый'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'16'|'0'|'0'|848084|401502|20|'Изменение'|'2019-05-21'|'2079-06-06'|330195|'{294673,329692,330053}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 330195|329692|'e667eb59-42c7-4810-9381-8ed5e7779d19'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Веселый'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'17'|'0'|'0'|848426|401659|20|'Изменение'|'2019-05-21'|'2079-06-06'|330195|'{294673,329692,330195}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 326475|329692|'90053520-f8a3-4d82-9638-2cc3f2a081d0'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Веселый'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'111'|'0'|'0'|838240|397515|20|'Изменение'|'2019-05-21'|'2079-06-06'|330195|'{294673,329692,326475}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 327868|330990|'ab2ab96d-6248-466c-aca3-e2f5a8d01727'|'5238a201-1524-4759-b69b-8fbd454db279'|'Водяная Балка'|112|'х'|6|'Населенный пункт'|'23'|'20'|'0'|'11'|'0'|'0'|841686|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|327868|'{294673,330990,327868}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 326942|330990|'ae1161cf-e1ba-41f6-a12b-8f1aae1d03dc'|'5238a201-1524-4759-b69b-8fbd454db279'|'Водяная Балка'|112|'х'|6|'Населенный пункт'|'23'|'20'|'0'|'90'|'0'|'0'|839313|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|327868|'{294673,330990,326942}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 341363|343780|'ab99f93d-f4c6-4c38-ad17-91a0765930a4'|'8bd71693-7c44-4550-ae82-f17a0379ebaf'|'Западный'|90|'п'|6|'Населенный пункт'|'23'|'35'|'0'|'12'|'0'|'0'|877581|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|341997|'{294673,343780,341363}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 341997|343780|'20849f44-cc25-41fc-be44-8f9eb57b1dbb'|'8bd71693-7c44-4550-ae82-f17a0379ebaf'|'Западный'|90|'п'|6|'Населенный пункт'|'23'|'35'|'0'|'72'|'0'|'0'|879439|0|10|'Добавление'|'1992-01-01'|'2079-06-06'|341997|'{294673,343780,341997}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 324606|329692|'6bc1ac1b-655c-46a0-9ca1-f9a248c0f4c5'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Красный'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'112'|'0'|'0'|833734|395308|20|'Изменение'|'2019-05-21'|'2079-06-06'|330138|'{294673,329692,324606}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 330138|329692|'7f3cd943-57b5-4907-9835-1cf0265a8aea'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Красный'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'38'|'0'|'0'|848246|401596|20|'Изменение'|'2019-05-21'|'2079-06-06'|330138|'{294673,329692,330138}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 389265|330990|'e720ecb6-7f06-44cb-99bc-acb7c8ccd459'|'5238a201-1524-4759-b69b-8fbd454db279'|'Красный'|112|'х'|6|'Населенный пункт'|'23'|'20'|'0'|'40'|'0'|'0'|990253|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|389265|'{294673,330990,389265}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 327570|330990|'51f1ee41-eaca-4d28-85dd-1dce14ce5adb'|'5238a201-1524-4759-b69b-8fbd454db279'|'Красный'|112|'х'|6|'Населенный пункт'|'23'|'20'|'0'|'88'|'0'|'0'|840891|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|389265|'{294673,330990,327570}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 99943765|294728|'a7c3f354-52c1-4a5d-ad86-5cc6e23290b0'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Лазаревский'|294|'р-н'|7|'Элемент планировочной структуры'|'23'|'0'|'7'|'0'|'154'|'0'|168015180|0|10|'Добавление'|'2021-01-14'|'2079-06-06'|99943765|'{294673,294728,99943765}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 294889|294728|'c1a53fdf-ae81-45fe-9fa2-7d0f6a8fee29'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Лазаревский'|44|'р-н'|14|'Уровень внутригородской территории (устаревшее)'|'23'|'0'|'7'|'0'|'0'|'0'|749922|0|10|'Добавление'|'2016-01-27'|'2079-06-06'|99943765|'{294673,294728,294889}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 330285|329692|'afcf4c3b-0b37-4257-b31e-f37664118131'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Ленинский'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'114'|'0'|'0'|848658|401758|20|'Изменение'|'2019-05-21'|'2079-06-06'|330285|'{294673,329692,330285}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 327816|329692|'6ad576a4-47d5-4624-b7e4-546e70c15fb1'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Ленинский'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'42'|'0'|'0'|841567|399017|20|'Изменение'|'2019-05-21'|'2079-06-06'|330285|'{294673,329692,327816}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 341903|340477|'8ef5cd22-95e8-42bd-a663-5325df6f14d1'|'2b521963-2a08-4198-89a4-23981e86b3fb'|'Ленинский'|112|'х'|6|'Населенный пункт'|'23'|'34'|'0'|'24'|'0'|'0'|879186|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|342196|'{294673,340477,341903}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 342196|340477|'cb683ebb-fa49-45c1-a51c-18175b4e0e60'|'2b521963-2a08-4198-89a4-23981e86b3fb'|'Ленинский'|112|'х'|6|'Населенный пункт'|'23'|'34'|'0'|'50'|'0'|'0'|880000|0|10|'Добавление'|'2016-01-21'|'2079-06-06'|342196|'{294673,340477,342196}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 339029|337704|'764a31e3-3127-439f-9cdc-94465ab0502b'|'f4ab6f10-4f56-4ebd-a881-4b767dbf4473'|'Октябрьский'|90|'п'|6|'Населенный пункт'|'23'|'33'|'0'|'47'|'0'|'0'|871959|0|10|'Добавление'|'2012-03-15'|'2079-06-06'|339029|'{294673,337704,339029}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 338004|337704|'5d03768e-ff31-47bb-b31b-3bd99d6045aa'|'f4ab6f10-4f56-4ebd-a881-4b767dbf4473'|'Октябрьский'|90|'п'|6|'Населенный пункт'|'23'|'33'|'0'|'44'|'0'|'0'|869745|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|339029|'{294673,337704,338004}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 338208|337720|'d4598143-50c8-4ac5-a619-db5fa892a620'|'f86e1bda-2165-4dc1-904e-604d2f468702'|'Прикубанский'|112|'х'|6|'Населенный пункт'|'23'|'30'|'0'|'52'|'0'|'0'|870221|410709|20|'Изменение'|'2019-05-21'|'2079-06-06'|338208|'{294673,337720,338208}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 335167|337720|'48bc5212-3a9e-406f-85ab-60fee33b6f2e'|'f86e1bda-2165-4dc1-904e-604d2f468702'|'Прикубанский'|112|'х'|6|'Населенный пункт'|'23'|'30'|'0'|'27'|'0'|'0'|863368|407229|20|'Изменение'|'2019-05-21'|'2079-06-06'|338208|'{294673,337720,335167}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 312066|294728|'8e9dfc95-df54-41e9-a781-863684049ae8'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Садовод-2'|428|'снт'|7|'Элемент планировочной структуры'|'23'|'0'|'7'|'0'|'1371'|'0'|803393|380646|50|'Переподчинение'|'2016-09-29'|'2079-06-06'|312066|'{294673,294728,312066}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 301231|294728|'00e07bc0-ce54-4e4f-8506-940701fc1065'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Садовод-2'|194|'снт'|8|'Элемент улично-дорожной сети'|'23'|'0'|'7'|'0'|'0'|'1259'|770661|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|312066|'{294673,294728,301231}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 329712|329692|'cfeb9372-59a8-42d1-a465-c21076e4f2b2'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Садовый'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'81'|'0'|'0'|846917|401115|20|'Изменение'|'2019-05-21'|'2079-06-06'|329831|'{294673,329692,329712}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 329831|329692|'548c9025-f0d4-45d8-b044-85d095311604'|'0af8a5f0-0b4b-4635-b47b-681c451adfca'|'Садовый'|112|'х'|6|'Населенный пункт'|'23'|'18'|'0'|'82'|'0'|'0'|847397|401247|20|'Изменение'|'2019-05-21'|'2079-06-06'|329831|'{294673,329692,329831}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 325226|329347|'3bb9df71-9cf3-443d-bcb0-331cc078d059'|'72700ecb-d9cb-4bcf-82f6-b55b06637d0b'|'Северный'|90|'п'|6|'Населенный пункт'|'23'|'19'|'0'|'45'|'0'|'0'|835167|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|325949|'{294673,329347,325226}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 325949|329347|'d02344b2-1d15-4f21-8ff1-d4e9f5faa2a3'|'72700ecb-d9cb-4bcf-82f6-b55b06637d0b'|'Северный'|90|'п'|6|'Населенный пункт'|'23'|'19'|'0'|'27'|'0'|'0'|836903|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|325949|'{294673,329347,325949}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 330996|334129|'d6aec81c-3e8d-4f8b-89f3-b6e8d55bb0bf'|'caed4250-d7fc-4e45-b431-5e1ae870cac5'|'Степной'|90|'п'|6|'Населенный пункт'|'23'|'24'|'0'|'48'|'0'|'0'|850942|402537|20|'Изменение'|'2014-01-04'|'2079-06-06'|331700|'{294673,334129,330996}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 331700|334129|'d91fcad5-da7c-476c-ad6b-8425886a16ff'|'caed4250-d7fc-4e45-b431-5e1ae870cac5'|'Степной'|90|'п'|6|'Населенный пункт'|'23'|'24'|'0'|'70'|'0'|'0'|853150|0|10|'Добавление'|'2019-05-20'|'2079-06-06'|331700|'{294673,334129,331700}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 99943764|294728|'19525af7-ff4b-41e6-bd2c-3c3eeff87bc0'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Хостинский'|294|'р-н'|7|'Элемент планировочной структуры'|'23'|'0'|'7'|'0'|'125'|'0'|168015179|0|10|'Добавление'|'2021-01-14'|'2079-06-06'|99943764|'{294673,294728,99943764}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 294943|294728|'f6b06e5e-8595-4d53-a350-d639279d8d76'|'79da737a-603b-4c19-9b54-9114c96fb912'|'Хостинский'|44|'р-н'|14|'Уровень внутригородской территории (устаревшее)'|'23'|'0'|'7'|'0'|'0'|'0'|750138|0|10|'Добавление'|'2016-01-27'|'2079-06-06'|99943764|'{294673,294728,294943}'|3|'2023-11-01'|'ТЕСТ. Краснодар'
-- 

SELECT * FROM gar_fias_pcg_load.f_addr_obj_update_children() ORDER BY nm_addr_obj; -- 18
---------------------------------------------------------------
-- '19525af7-ff4b-41e6-bd2c-3c3eeff87bc0'|'f6b06e5e-8595-4d53-a350-d639279d8d76'|'ХОСТИНСКИЙ'|44|145|14
-- '20849f44-cc25-41fc-be44-8f9eb57b1dbb'|'ab99f93d-f4c6-4c38-ad17-91a0765930a4'|'ЗАПАДНЫЙ'|90|6|6
-- '2a379956-d5f4-4562-88ca-c2d78fbba9d5'|'f1acccf5-36e2-44d5-9143-437cc7459ed1'|'АДЛЕРСКИЙ'|44|138|14
-- '548c9025-f0d4-45d8-b044-85d095311604'|'cfeb9372-59a8-42d1-a465-c21076e4f2b2'|'САДОВЫЙ'|112|154|6
-- '71352f32-e764-48de-b0f5-35d1e5edf4b4'|'7904ecca-69e9-470a-9ac9-2fc617cd26f5'|'БАРАНОВКА'|103|17|6
-- '764a31e3-3127-439f-9cdc-94465ab0502b'|'5d03768e-ff31-47bb-b31b-3bd99d6045aa'|'ОКТЯБРЬСКИЙ'|90|15|6
-- '7f3cd943-57b5-4907-9835-1cf0265a8aea'|'6bc1ac1b-655c-46a0-9ca1-f9a248c0f4c5'|'КРАСНЫЙ'|112|2|6
-- '8e9dfc95-df54-41e9-a781-863684049ae8'|'00e07bc0-ce54-4e4f-8506-940701fc1065'|'САДОВОД-2'|194|0|8
-- 'a7c3f354-52c1-4a5d-ad86-5cc6e23290b0'|'c1a53fdf-ae81-45fe-9fa2-7d0f6a8fee29'|'ЛАЗАРЕВСКИЙ'|44|299|14
-- 'ab2ab96d-6248-466c-aca3-e2f5a8d01727'|'ae1161cf-e1ba-41f6-a12b-8f1aae1d03dc'|'ВОДЯНАЯ БАЛКА'|112|3|6
-- 'afcf4c3b-0b37-4257-b31e-f37664118131'|'6ad576a4-47d5-4624-b7e4-546e70c15fb1'|'ЛЕНИНСКИЙ'|112|72|6
-- 'cb683ebb-fa49-45c1-a51c-18175b4e0e60'|'8ef5cd22-95e8-42bd-a663-5325df6f14d1'|'ЛЕНИНСКИЙ'|112|8|6
-- 'd02344b2-1d15-4f21-8ff1-d4e9f5faa2a3'|'3bb9df71-9cf3-443d-bcb0-331cc078d059'|'СЕВЕРНЫЙ'|90|4|6
-- 'd4598143-50c8-4ac5-a619-db5fa892a620'|'48bc5212-3a9e-406f-85ab-60fee33b6f2e'|'ПРИКУБАНСКИЙ'|112|53|6
-- 'd91fcad5-da7c-476c-ad6b-8425886a16ff'|'d6aec81c-3e8d-4f8b-89f3-b6e8d55bb0bf'|'СТЕПНОЙ'|90|1|6
-- 'e667eb59-42c7-4810-9381-8ed5e7779d19'|'90053520-f8a3-4d82-9638-2cc3f2a081d0'|'ВЕСЕЛЫЙ'|112|2|6
-- 'e667eb59-42c7-4810-9381-8ed5e7779d19'|'d2a047a9-09ec-4ce3-9a72-6f3ae6807363'|'ВЕСЕЛЫЙ'|112|5|6
-- 'e720ecb6-7f06-44cb-99bc-acb7c8ccd459'|'51f1ee41-eaca-4d28-85dd-1dce14ce5adb'|'КРАСНЫЙ'|112|1|6



SELECT * FROM gar_fias.twin_addr_objects;
-----------------------------------------
-- '769e7d36-8921-4f1a-b980-70840f636368'|'bac56cd5-f1e2-4498-90e8-84aec5db0c2b'|8|'2023-11-01'
-- 'c63b4f41-cf04-4b59-b174-0e69cedafe0e'|'a63fb226-b0f6-4de8-9f57-113f024f0dac'|8|'2023-11-01'
-- '280f1d56-ad45-4f7c-b75c-1b2a0cade632'|'9fdf60d5-9e87-4382-bfcb-ac97cc858991'|8|'2023-11-01'
-- 'f04537c4-55b8-4a5c-9ad7-e3f71fa78f14'|'a8baec50-c786-4d55-aa34-b4a56bff4194'|8|'2023-11-01'
-- 'd3219d58-39bd-47f8-bacb-c22096c28e96'|'2e846204-2ba7-4fcc-81a6-e11b25849c3a'|8|'2023-11-01'
-- '199f4465-a162-43b5-bf4e-c007fecd5ae8'|'ec579713-1d95-436f-9117-62a25debb236'|8|'2023-11-01'
-- '548b862a-4f09-4045-9eaa-9aca36edef83'|'fd7191c5-a2fe-4c9e-b684-2d78f93782a6'|8|'2023-11-01'
-- 'b2d7ca30-a42a-4a75-ad3a-ad156cb59d6c'|'0cfc28b6-de71-458f-8fd8-fb0de152fd88'|8|'2023-11-01'
-- '5cba81cb-b38a-48ca-953f-4f84a60fbfd9'|'6dc3a538-d3ef-4a78-a312-b24f4259f863'|8|'2023-11-01'
-- '1571397a-406e-4dd9-823b-9d2c0724b5ae'|'c228df44-a826-42a7-8302-eb92143d773e'|8|'2023-11-01'
-- 'b8c406b7-f7be-4ac3-a1e0-fdb2d4a7ca17'|'0bd0ae2d-e83a-4adb-a73c-4d4e06992305'|8|'2023-11-01'
-- '90c514c6-f4dd-45ef-9e9f-86d49dab68aa'|'0a5fe358-4ed4-4087-aa46-be80e8bbea07'|8|'2023-11-01'
-- 'a5c27c8b-8401-4965-accf-ac9d15b88880'|'349fc21a-f409-4e01-ac8d-fd62ba830d68'|8|'2023-11-01'


ROLLBACK;

COMMIT;

           WITH x (
                     id_addr_obj_new
                    ,id_addr_obj_old 
          )      
            AS (
                   SELECT DISTINCT id_lead, min(id_addr_obj) OVER (PARTITION BY id_lead) 
                     FROM gar_fias_pcg_load.f_addr_area_show_data (
                                                         p_fias_guid := '2a379956-d5f4-4562-88ca-c2d78fbba9d5'
                                                        ,p_qty := 0
                  )
               )
           -- select * FRom x
                 SELECT z1.object_guid  AS fias_guid_new 
                       ,z2.object_guid  AS fias_guid_old 
                       ,z1.obj_level 
                       ,current_date
                 FROM x
                   INNER JOIN gar_fias.as_addr_obj z1 ON (z1.object_id = x.id_addr_obj_new)
                   INNER JOIN gar_fias.as_addr_obj z2 ON (z2.object_id = x.id_addr_obj_old);

-- ------------------------------------------------------------------------------------------

SELECT * FROM gar_fias_pcg_load.f_addr_area_show_data (
                                                         p_fias_guid := NULL
                                                        ,p_qty := 0 
                                                        ) WHERE (fias_guid = '769e7d36-8921-4f1a-b980-70840f636368');   

SELECT * FROM gar_fias_pcg_load.f_addr_area_show_data (
                                                         p_fias_guid := '20849f44-cc25-41fc-be44-8f9eb57b1dbb'  -- 'Западный'
                                                        ,p_qty := 0 
                                                        ) ;
SELECT * FROM gar_fias_pcg_load.f_addr_area_show_data (
                                                         p_fias_guid :=  '8bd71693-7c44-4550-ae82-f17a0379ebaf'  -- 'Тихорецкий'
                                                        ,p_qty := 0 
                                                        ) ;

SELECT * FROM gar_fias_pcg_load.f_addr_area_show_data (
                                                         p_fias_guid :=  'd00e1013-16bd-4c09-b3d5-3cb09fc54bd8'   --  'Краснодарский' -- 48916
                                                        ,p_qty := 1 
                                                        ) ORDER BY level_d
-------------------------------------------------------------------------------
-- 298031|295241|'a63fb226-b0f6-4de8-9f57-113f024f0dac'|'71352f32-e764-48de-b0f5-35d1e5edf4b4'|'Армянская'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'0'|'7'|'152'|'0'|'9'|760354|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|300046|'{294673,294728,295241,298031}'|4
-- 300046|295241|'c63b4f41-cf04-4b59-b174-0e69cedafe0e'|'71352f32-e764-48de-b0f5-35d1e5edf4b4'|'Армянская'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'0'|'7'|'190'|'0'|'2'|766850|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|300046|'{294673,294728,295241,300046}'|4
-- 330096|327868|'9c84ef91-c278-463f-be9e-d99d27356c62'|'ab2ab96d-6248-466c-aca3-e2f5a8d01727'|'Трудовая'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'20'|'0'|'90'|'0'|'1'|848037|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|332764|'{294673,330990,327868,330096}'|4
-- 332764|327868|'12ac3ce8-d532-4dce-9ea7-190ae5c5c48e'|'ab2ab96d-6248-466c-aca3-e2f5a8d01727'|'Трудовая'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'20'|'0'|'11'|'0'|'3'|856359|0|10|'Добавление'|'2016-11-24'|'2079-06-06'|332764|'{294673,330990,327868,332764}'|4
-- 99757393|331700|'e146194f-425a-4e63-a248-4846808f3865'|'d91fcad5-da7c-476c-ad6b-8425886a16ff'|'Степная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'24'|'0'|'70'|'0'|'1'|166369782|0|10|'Добавление'|'2020-12-23'|'2079-06-06'|99757393|'{294673,334129,331700,99757393}'|4
-- 331826|331700|'32dae7ab-7ed4-4d90-94f3-4f69f87c03c1'|'d91fcad5-da7c-476c-ad6b-8425886a16ff'|'Степная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'24'|'0'|'48'|'0'|'1'|853576|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|99757393|'{294673,334129,331700,331826}'|4
-- 338313|338208|'76c6d200-3b0a-4014-a8d4-2b94fad6e6b1'|'d4598143-50c8-4ac5-a619-db5fa892a620'|'Зеленый'|163|'пер'|8|'Элемент улично-дорожной сети'|'23'|'30'|'0'|'27'|'0'|'83'|870390|0|10|'Добавление'|'2018-03-14'|'2079-06-06'|338313|'{294673,337720,338208,338313}'|4
-- 337012|338208|'82e5b9cd-34bf-4cd6-bee4-11fab5ea211a'|'d4598143-50c8-4ac5-a619-db5fa892a620'|'Зеленый'|163|'пер'|8|'Элемент улично-дорожной сети'|'23'|'30'|'0'|'52'|'0'|'2'|867731|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|338313|'{294673,337720,338208,337012}'|4
-- 338672|339029|'fd7191c5-a2fe-4c9e-b684-2d78f93782a6'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Лесной'|163|'пер'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'13'|871164|0|10|'Добавление'|'2007-01-18'|'2079-06-06'|341858|'{294673,337704,339029,338672}'|4
-- 341858|339029|'548b862a-4f09-4045-9eaa-9aca36edef83'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Лесной'|163|'пер'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'5'|879037|0|10|'Добавление'|'2012-03-15'|'2079-06-06'|341858|'{294673,337704,339029,341858}'|4
-- 337596|339029|'0a5fe358-4ed4-4087-aa46-be80e8bbea07'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Новоселов'|163|'пер'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'7'|868894|0|10|'Добавление'|'2007-01-18'|'2079-06-06'|339235|'{294673,337704,339029,337596}'|4
-- 339235|339029|'90c514c6-f4dd-45ef-9e9f-86d49dab68aa'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Новоселов'|163|'пер'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'7'|872414|0|10|'Добавление'|'2007-01-18'|'2079-06-06'|339235|'{294673,337704,339029,339235}'|4
-- 340886|339029|'6dc3a538-d3ef-4a78-a312-b24f4259f863'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Отдельный'|163|'пер'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'14'|876286|0|10|'Добавление'|'2007-01-18'|'2079-06-06'|341893|'{294673,337704,339029,340886}'|4
-- 341893|339029|'5cba81cb-b38a-48ca-953f-4f84a60fbfd9'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Отдельный'|163|'пер'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'8'|879140|0|10|'Добавление'|'2012-03-15'|'2079-06-06'|341893|'{294673,337704,339029,341893}'|4
-- 340832|339029|'349fc21a-f409-4e01-ac8d-fd62ba830d68'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Дорожная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'4'|876158|413958|20|'Изменение'|'2012-03-15'|'2079-06-06'|342417|'{294673,337704,339029,340832}'|4
-- 342417|339029|'a5c27c8b-8401-4965-accf-ac9d15b88880'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Дорожная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'14'|880564|0|10|'Добавление'|'2014-01-05'|'2079-06-06'|342417|'{294673,337704,339029,342417}'|4
-- 340243|339029|'2e846204-2ba7-4fcc-81a6-e11b25849c3a'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Железнодорожная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'18'|874744|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|341059|'{294673,337704,339029,340243}'|4
-- 341059|339029|'d3219d58-39bd-47f8-bacb-c22096c28e96'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Железнодорожная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'2'|876747|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|341059|'{294673,337704,339029,341059}'|4
-- 338565|339029|'b2f7d749-db93-41f9-a2d4-e84eee6783af'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Животноводов'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'6'|870940|411122|20|'Изменение'|'2012-03-15'|'2079-06-06'|339274|'{294673,337704,339029,338565}'|4
-- 339274|339029|'561bce21-ec15-483c-876c-d2ee78a9910f'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Животноводов'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'1'|872496|0|10|'Добавление'|'2007-01-18'|'2079-06-06'|339274|'{294673,337704,339029,339274}'|4
-- 341828|339029|'199f4465-a162-43b5-bf4e-c007fecd5ae8'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Заречная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'2'|878928|0|10|'Добавление'|'2012-03-15'|'2079-06-06'|341828|'{294673,337704,339029,341828}'|4
-- 337909|339029|'ec579713-1d95-436f-9117-62a25debb236'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Заречная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'1'|869549|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|341828|'{294673,337704,339029,337909}'|4
-- 342338|339029|'f04537c4-55b8-4a5c-9ad7-e3f71fa78f14'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Кандаурская'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'17'|880366|0|10|'Добавление'|'2012-03-15'|'2079-06-06'|342338|'{294673,337704,339029,342338}'|4
-- 341726|339029|'a8baec50-c786-4d55-aa34-b4a56bff4194'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Кандаурская'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'3'|878646|0|10|'Добавление'|'2012-03-15'|'2079-06-06'|342338|'{294673,337704,339029,341726}'|4
-- 342365|339029|'a68d779a-db62-47d8-b7e2-9d6b5a9fca34'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Кизилташская'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'18'|880440|0|10|'Добавление'|'2012-03-15'|'2079-06-06'|342365|'{294673,337704,339029,342365}'|4
-- 341757|339029|'6d38779b-3ba4-43a6-8e5e-632dab7d434b'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Кизилташская'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'4'|878741|0|10|'Добавление'|'2012-03-15'|'2079-06-06'|342365|'{294673,337704,339029,341757}'|4
-- 341393|339029|'b2d7ca30-a42a-4a75-ad3a-ad156cb59d6c'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Луговая'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'3'|877666|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|341393|'{294673,337704,339029,341393}'|4
-- 339309|339029|'0cfc28b6-de71-458f-8fd8-fb0de152fd88'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Луговая'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'6'|872584|0|10|'Добавление'|'2007-01-18'|'2079-06-06'|341393|'{294673,337704,339029,339309}'|4
-- 341913|339029|'04c29943-ee5f-4162-8b9b-f22bc90c6c9f'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Пионерская'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'9'|879208|0|10|'Добавление'|'2012-03-15'|'2079-06-06'|341913|'{294673,337704,339029,341913}'|4
-- 340519|339029|'11515d3c-06ae-4769-a18a-49d0b66931b3'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Пионерская'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'16'|875400|0|10|'Добавление'|'2007-01-18'|'2079-06-06'|341913|'{294673,337704,339029,340519}'|4
-- 339924|339029|'9fdf60d5-9e87-4382-bfcb-ac97cc858991'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Прогонная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'5'|873974|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|341942|'{294673,337704,339029,339924}'|4
-- 341942|339029|'280f1d56-ad45-4f7c-b75c-1b2a0cade632'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Прогонная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'10'|879284|0|10|'Добавление'|'2012-03-15'|'2079-06-06'|341942|'{294673,337704,339029,341942}'|4
-- 338625|339029|'c228df44-a826-42a7-8302-eb92143d773e'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Северная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'19'|871067|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|340826|'{294673,337704,339029,338625}'|4
-- 340826|339029|'1571397a-406e-4dd9-823b-9d2c0724b5ae'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Северная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'11'|876121|0|10|'Добавление'|'2007-01-18'|'2079-06-06'|340826|'{294673,337704,339029,340826}'|4
-- 342388|339029|'9c48febe-2563-453c-b84c-7925a68a3b7d'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Сибирских строителей'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'19'|880509|0|10|'Добавление'|'2012-03-15'|'2079-06-06'|342388|'{294673,337704,339029,342388}'|4
-- 341798|339029|'e2d99f31-9c08-497d-9da2-c3dbb18847f8'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Сибирских строителей'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'12'|878882|415244|20|'Изменение'|'2012-03-16'|'2079-06-06'|342388|'{294673,337704,339029,341798}'|4
-- 340855|339029|'0bd0ae2d-e83a-4adb-a73c-4d4e06992305'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Южная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'44'|'0'|'12'|876216|0|10|'Добавление'|'2007-01-18'|'2079-06-06'|342475|'{294673,337704,339029,340855}'|4
-- 342475|339029|'b8c406b7-f7be-4ac3-a1e0-fdb2d4a7ca17'|'764a31e3-3127-439f-9cdc-94465ab0502b'|'Южная'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'33'|'0'|'47'|'0'|'15'|880723|0|10|'Добавление'|'2014-01-05'|'2079-06-06'|342475|'{294673,337704,339029,342475}'|4
-- 345612|341997|'769e7d36-8921-4f1a-b980-70840f636368'|'20849f44-cc25-41fc-be44-8f9eb57b1dbb'|'Зеленая'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'35'|'0'|'72'|'0'|'1'|888912|0|10|'Добавление'|'2016-02-10'|'2079-06-06'|345612|'{294673,343780,341997,345612}'|4
-- 340924|341997|'bac56cd5-f1e2-4498-90e8-84aec5db0c2b'|'20849f44-cc25-41fc-be44-8f9eb57b1dbb'|'Зеленая'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'35'|'0'|'12'|'0'|'2'|876388|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|345612|'{294673,343780,341997,340924}'|4
-- 342349|342196|'4c1742d3-88bb-4d4a-93c0-b96638e72051'|'cb683ebb-fa49-45c1-a51c-18175b4e0e60'|'Луговая'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'34'|'0'|'24'|'0'|'8'|880409|0|1|'Инициация'|'1900-01-01'|'2079-06-06'|342737|'{294673,340477,342196,342349}'|4
-- 342737|342196|'64a985d0-bf2c-4923-bfbd-0c87b8f7f063'|'cb683ebb-fa49-45c1-a51c-18175b4e0e60'|'Луговая'|204|'ул'|8|'Элемент улично-дорожной сети'|'23'|'34'|'0'|'50'|'0'|'17'|881477|0|10|'Добавление'|'2015-11-17'|'2079-06-06'|342737|'{294673,340477,342196,342737}'|4

SELECT * FROM gar_fias_pcg_load.f_addr_area_show_data (
                                                         p_fias_guid :=  NULL   --  'Краснодарский' -- 48916
                                                        ,p_qty := 1 
                                                        ) ORDER BY level_d                                                                   