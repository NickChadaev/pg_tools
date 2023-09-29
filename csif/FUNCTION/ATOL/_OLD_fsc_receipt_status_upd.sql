DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_receipt_status_upd            
        (  integer
         , integer
         , integer
         , bigint[] 
         , timestamp(0) with time zone
         , timestamp(0) with time zone
         , integer
        ) CASCADE;        
        
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_receipt_status_upd (

              p_old_rcp_status  integer  
            , p_new_rcp_status  integer  
            , p_id_fsc_provider integer
              --
            , p_ids_receipt    bigint []                   DEFAULT NULL 
            , p_min_dt_create  timestamp(0) with time zone DEFAULT '-infinity'
            , p_max_dt_create  timestamp(0) with time zone DEFAULT 'infinity'
            , p_limit          integer                     DEFAULT 1000
)

RETURNS TABLE (
    id_receipt           bigint                        
   ,dt_create            timestamp(0)  with time zone  
   ,rcp_status           integer                       
   ,dt_update            timestamp(0)  with time zone  
   ,inn                  varchar(12)                   
   ,rcp_nmb              text                          
   ,rcp_fp               char(10)                      
   ,dt_fp                timestamp(0) with time zone   
   ,id_org_app           integer                       
   ,rcp_status_descr     text                          
   ,rcp_order            jsonb                         
   ,rcp_receipt          jsonb                         
   ,id_fsc_provider      integer                       
   ,rcp_type             integer                       
   ,rcp_received         bool                          
   ,rcp_notify_send      bool                          
   ,id_pay               bigint                        
   ,resend_pr            integer                       
)

    SECURITY DEFINER
    LANGUAGE plpgsql 
AS
$$
-- ==============================================================================================================
--   2023-08-09
--
-- Обновление статуса чека.  p_old_rcp_status -->> p_new_rcp_status
--    Выбираем чеки со статусом = p_old_rcp_status, потом обновим выбранные записи до статуса = p_new_rcp_status
--     Возращаем  data set? все записи с обновлённым статусом.
-- --------------------------------------------------------------------------------------------------------------
-- Статус  Описание
--   0        Запрос на фискализацию. Чек добавлен в БД, ожидает отправки на FISC-server
--   1        Чек отправлен на фискализацию
--   2        Чек успешно фискализирован
--   3        Чек ожидает свободной кассы, очередь переполнена
--   4        Чек с ошибкой (фискализация не будет выполнена)
--   5        Ошибка кассы (попытка фискализации будет выполнена повторно)
--   6        Ошибка сервиса (попытка фискализации может быть выполнена повторно)
-- ==============================================================================================================

  BEGIN
        RETURN QUERY
          WITH z10 AS (
                       SELECT z.id_receipt
                            , z.dt_create
                            , z.rcp_status
                            , z.dt_update
                            , z.inn
                            , z.rcp_nmb
                            , z.rcp_fp
                            , z.dt_fp
                            , z.id_org_app
                            , z.rcp_status_descr
                            , z.rcp_order
                            , z.rcp_receipt
                            , z.id_fsc_provider
                            , z.rcp_type
                            , z.rcp_received
                            , z.rcp_notify_send
                            , z.id_pay
                            , z.resend_pr
                             
                	 FROM fiscalization.fsc_receipt z 
                	 WHERE ( 
			                 (z.rcp_status = p_old_rcp_status) AND 
                             (z.dt_create BETWEEN p_min_dt_create AND p_max_dt_create) AND
                             (((z.id_receipt = ANY (p_ids_receipt)) AND (p_ids_receipt IS NOT NULL))
                                  OR
                              (p_ids_receipt IS NULL) 
                             ) AND 
                             (p_id_fsc_provider = z.id_fsc_provider)
                        )  LIMIT p_limit	
                        
                      FOR UPDATE
                  
          ), z20 AS (
                      DELETE FROM fiscalization.fsc_receipt AS x USING z10 WHERE (x.id_receipt = z10.id_receipt)  
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
                    )  
                       --         
                       -- Первая часть обновления завершилась, записи со старым статусом удалены           
                       --   Далее, записи снова создаются, но с новым статусом.
                       --
                       INSERT INTO fiscalization.fsc_receipt AS k (         
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
                                          , p_new_rcp_status  AS rcp_status      -- Новое значение.      
                                          , z20.dt_update
                                          , z20.inn
                                          , z20.rcp_nmb
                                          , z20.rcp_fp
                                          , z20.dt_fp
                                          , z20.id_org_app
                                          , CASE p_new_rcp_status
                                               WHEN 1 THEN 'Отправлен на фискализацию'
                                               ELSE
                                                    NULL
                                            END AS rcp_status_descr
                                          , z20.rcp_order                            
                                          , z20.rcp_receipt
                                          , z20.id_fsc_provider
                                          , z20.rcp_type
                                          , z20.rcp_received
                                          , z20.rcp_notify_send
                                          , z20.id_pay                            
                                          , z20.resend_pr
                         
                         FROM z20
                         
                         RETURNING     k.id_receipt
                                     , k.dt_create
                                     , k.rcp_status
                                     , k.dt_update
                                     , k.inn
                                     , k.rcp_nmb
                                     , k.rcp_fp
                                     , k.dt_fp
                                     , k.id_org_app
                                     , k.rcp_status_descr
                                     , k.rcp_order
                                     , k.rcp_receipt
                                     , k.id_fsc_provider
                                     , k.rcp_type
                                     , k.rcp_received
                                     , k.rcp_notify_send
                                     , k.id_pay
                                     , k.resend_pr
                        ;
  END;
$$;


COMMENT ON FUNCTION fsc_receipt_pcg.fsc_receipt_status_upd
   (       integer
         , integer
         , integer
         , bigint[] 
         , timestamp(0) with time zone
         , timestamp(0) with time zone
         , integer
        )
    IS 'Смена статуса чека, перемещение из секции в секцию. Формирует DATA-SET';	
-- ----------
--  USE CASE:
--      SELECT * FROM fsc_receipt_pcg.fsc_receipt_status_upd (0,1);
--      SELECT count (1) FROM fiscalization.fsc_receipt WHERE (rcp_status = 1); -- 49
--      SELECT * FROM fsc_receipt_pcg.fsc_receipt_status_upd (1, 0, '2023-05-12', '2023-05-13');
--      SELECT count (1) FROM fiscalization.fsc_receipt WHERE (rcp_status = 1); -- 1
--      SELECT count (1) FROM fiscalization.fsc_receipt WHERE (rcp_status = 0); -- 48
--      SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 0); -- 48
--      SELECT * FROM fsc_receipt_pcg.fsc_receipt_status_upd (0, 1, '2023-05-12', '2023-05-13', 10);
--      SELECT * FROM fsc_receipt_pcg.fsc_receipt_status_upd (1, 0, '2023-05-12', '2023-05-13', 10);
-- -------------------------------------------------------------------------------------------------
--      SELECT * FROM fsc_receipt_pcg.fsc_receipt_status_upd (0, 1, 2, p_limit := 1000); 
-- BEGIN;
--      SELECT * FROM fsc_receipt_pcg.fsc_receipt_status_upd (0, 1, ARRAY[8557733579,  8557734614]::bigint[]);
-- COMMIT;
--
-- SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 0);
-- SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 1);
