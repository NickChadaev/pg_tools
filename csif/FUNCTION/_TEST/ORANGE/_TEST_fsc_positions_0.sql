--
--   2023-08-18
--
DO 
     $$
        -- =====================================================================================
        --    2023-05-18  Создание объекта  "Предмет расчета"
        -- -------------------------------------------------------------------------------------
        --                Обязательные и опциональные атрибуты:
        -- ------------------------------------------------------------------------------------- 
        --   CREATE TYPE positions_rt AS (    
        --      quantity                 numeric (16,6) NOT NULL -- Количество
        --     ,price                    numeric (10,2) NOT NULL -- Цена в рублях
        --     ,tax                      integer        NOT NULL -- Ставка НДС, 1199:         int4range
        --     ,text                     text           NOT NULL -- Наименование товара/услуги      
        --     ,paymentMethodType        integer        NOT NULL -- Признак способа расчета   int4range 
        --     ,paymentSubjectType       integer        NOT NULL -- Признак предмета расчета  int4range 
        -- -------------------------------------------------------------------------------------
        --     ,taxSum                   numeric (10,2)  NULL -- Сумма НДС в рублях
        --     ,itemCode                 text            NULL -- Код маркировки
        --     ,supplierInfo             json            NULL -- Поставщик 
        --     ,supplierINN              text            NULL -- ИНН поставщика
        --     ,agentType                integer         NULL -- Признак агента по предмету расчета
        --     ,agentInfo                json            NULL -- Атрибуты агента
        --     ,quantityMeasurementUnit  integer         NULL -- Мера количества предмета расчета  int4range
        --     ,additionalAttribute      text            NULL -- Дополнительный реквизит предмета расчета 
        --     ,manufacturerCountryCode  text            NULL -- Код страны происхождения товара 
        --     ,customsDeclarationNumber text            NULL -- Номер таможенной декларации 
        --     ,excise                   numeric (10,2)  NULL -- Сумма акциза в рублях 
        --     ,unitTaxSum               numeric (10,2)  NULL -- Размер НДС за единицу предмета расчета
        --     ,fractionalQuantity       json                NULL -- Дробное количество маркированного товара 
        --     ,industryAttribute        json                NULL -- Отраслевой реквизит предмета расчета 
        --     ,barcodes                 json                NULL -- Штрих-коды предмета расчета 
        --   );
        --   COMMENT ON TYPE positions_rt IS 'Предмет расчёта (товар/услуга) (ORANGE)';
        -- ============================================================================ --
        DECLARE
        
          __result   json;
        
        
        BEGIN
--             __result := fsc_orange_pcg.fsc_positions_crt_2 (
--                            p_item := ARRAY [NULL, NULL, NULL, NULL, NULL, NULL
--                                            ]::positions_rt[]
--             );
--             RAISE NOTICE '%', _result;
			--
            -- ERROR:  "positions[1]": Все данные являются обязательными: "quantity" = NULL, "price" = NULL, "tax" = NULL, "text" = NULL, "paymentMethodType" = NULL, "paymentSubjectType" = NULL			
 			--
--        __result := fsc_orange_pcg.fsc_positions_crt_2 (
--                              ARRAY [(1.0, 200.22, 2, 'Хренотень', 4, 10
--									 , null, null, null, null, null 
--									 , null, null, null, null, null 										 
--									 , null, null, null, null, null										  
--									 )::positions_rt
--                                    ]::positions_rt[]
--        );
--        RAISE NOTICE '%', __result;
--		-- NOTICE:  [{"quantity":1.000000,"price":200.22,"tax":2,"text":"Хренотень","paymentmethodtype":4,"paymentsubjecttype":10}]
			
--            __result := fsc_orange_pcg.fsc_positions_crt_2 (
--                                  ARRAY [(1.0, 200.22, 2, 'Хренотень #1', 4, 10
-- 									    , null, null, null, null, null 
-- 									    , null, null, null, null, null 										 
-- 									    , null, null, null, null, null										  
-- 									 )::positions_rt
-- 									 -- 
--                                         ,(3.0, 400.00, 1, 'Хренотень#2', 5, 10
-- 									    , null, null, null, null, null 
-- 									    , null, null, null, null, null 										 
-- 									    , null, null, null, null, null										  
-- 									 )::positions_rt										 
--                                        ]::positions_rt[]
--            );
--            RAISE NOTICE '%', __result;
			
--                 NOTICE:  [{"quantity":1.000000,"price":200.22,"tax":2,"text":"Хренотень #1","paymentmethodtype":4,"paymentsubjecttype":10}
-- 						  ,{"quantity":3.000000,"price":400.00,"tax":1,"text":"Хренотень#2","paymentmethodtype":5,"paymentsubjecttype":10}]

            __result := fsc_orange_pcg.fsc_positions_crt_2 (
                                  ARRAY [(1.0, 200.22, 2, 'Хренотень #1', 4, 55
										    , null, null, null, null, null 
										    , null, null, null, null, null 										 
										    , null, null, null, null, null										  
										 )::positions_rt
										 -- 
                                         ,(3.0, 400.00, 1, 'Хренотень#2', 5, 10
										    , null, null, null, null, null 
										    , null, null, null, null, null 										 
										    , null, null, null, null, null										  
										 )::positions_rt										 
                                        ]::positions_rt[]
            );
            RAISE NOTICE '%', __result;
			
            -- ERROR:  "positions": Неправильный код предмета расчёта: "paymentSubjectType" = 55						
            
        END;
     $$;
