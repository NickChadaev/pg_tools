-- 
-- Тесты:  3) Обновление статуса чека.  0 -->> 1
--    Выбираем чеки со статусом = 0, потом обновим выбранные записи до статуса = 1 
--
-- Статус  Описание
--   0        Чек добавлен в систему ожидает постановки в очередь
--   1        Чек отправлен на фискализацию
--   2        Чек успешно фискализирован
--   3        Чек ожидает свободной кассы, очередь переполнена
--   4        Чек с ошибкой (фискализация не будет выполнена)
--   5        Ошибка кассы (попытка фискализации будет выполнена повторно)

BEGIN;
COMMIT;                              
ROLLBACK;

        --EXPLAIN  
        WITH z10 AS (
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
                            , id_fsc_provider
                            , rcp_type
                            , rcp_received
                            , rcp_notify_send
                            , id_pay
                            , resend_pr
                             
                	 FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0 ) 
                                        	    ORDER BY id_receipt
                      FOR UPDATE
                  
          ), z20 AS (
                     DELETE FROM fiscalization.fsc_receipt AS x USING z10
                         WHERE (x.id_receipt = z10.id_receipt) --  AND (x.rcp_status = 0)
                     RETURNING  
                               x.id_receipt
                             , x.dt_create
                             , x.rcp_status
                             , x.dt_update
                             , x.inn
                             , x.rcp_nmb
                             , x.rcp_fp
                             , x.dt_fp
                             , x.id_org_app
                             , x.rcp_status_descr
                             , x.rcp_order
                             , x.rcp_receipt
                             , x.id_fsc_provider
                             , x.rcp_type
                             , x.rcp_received
                             , x.rcp_notify_send
                             , x.id_pay                 
                             , x.resend_pr
                    ), 
             
              z30 AS (
                       --         
                       -- Первая часть обновления завершилась, записи со старым статусом удалены           
                       --   Далее, записи снова создаются, но с новым статусом.
                       --
                       INSERT INTO fiscalization.fsc_receipt (         
                                           id_receipt
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
                                         , id_fsc_provider
                                         , rcp_type
                                         , rcp_received
                                         , rcp_notify_send
                                         , id_pay
                                         , resend_pr          
                       )
                         SELECT
                                            z20.id_receipt
                                          , z20.dt_create
                                          , 1  AS rcp_status      -- Новое значение.      
                                          , z20.dt_update
                                          , z20.inn
                                          , z20.rcp_nmb
                                          , z20.rcp_fp
                                          , z20.dt_fp
                                          , z20.id_org_app
                                          , 'Отправлен на фискализацию' AS rcp_status_descr
                                          , z20.rcp_order                            
                                          , z20.rcp_receipt
                                          , z20.id_fsc_provider
                                          , z20.rcp_type
                                          , z20.rcp_received
                                          , z20.rcp_notify_send
                                          , z20.id_pay                            
                                          , z20.resend_pr
                         
                         FROM z20
                         
                         RETURNING     id_receipt
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
                                     , id_fsc_provider
                                     , rcp_type
                                     , rcp_received
                                     , rcp_notify_send
                                     , id_pay
                                     , resend_pr          
                     )    
                     SELECT * FROM z30;
                      
--
--  Проверяю что получилось.
--
SELECT count(1) FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0);  -- 80000 строк
SELECT count(1) FROM fiscalization.fsc_receipt WHERE ( rcp_status = 1 ); -- 20001 строка                  
SELECT * FROM fiscalization.fsc_receipt WHERE ( rcp_status = 1 ); -- 3652976667 -- ????
--Попробовать функцию.

-- COMMIT;                              
-- ROLLBACK;



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
                            , id_fsc_provider
                            , rcp_type
                            , rcp_received
                            , rcp_notify_send
                            , id_pay
                            , resend_pr
                             
                	 FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0 ) 
                     --      AND (dt_create between '2023-05-12' and 'infinity')  -- '2023-05-12'
					      AND (dt_create between '2023-05-13' and 'infinity')  -- '2023-05-12'
						  
						  SELECT NOW() - interval '1 day'; -- 2023-08-08 18:20:42.592073+03
                          SELECT NOW()                     -- 2023-08-09 18:21:33.81217+03
						  SELECT NOW() + interval '1 day';