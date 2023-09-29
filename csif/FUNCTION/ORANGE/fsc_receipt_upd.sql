DROP FUNCTION IF EXISTS fsc_orange_pcg.fsc_receipt_upd (json, integer, integer) CASCADE; 
CREATE OR REPLACE FUNCTION fsc_orange_pcg.fsc_receipt_upd (
         p_reply           json
       , p_old_rcp_status  integer  DEFAULT 1  
       , p_new_rcp_status  integer  DEFAULT 2 
)

RETURNS TABLE (
                  id_receipt         bigint                        
                 ,dt_create          timestamp(0)  with time zone  
                 ,rcp_status         integer                       
                 ,dt_update          timestamp(0)  with time zone  
                 ,inn                varchar(12)                   
                 ,rcp_nmb            text                          
                 ,rcp_fp             char(10)                      
                 ,dt_fp              timestamp(0) with time zone   
                 ,id_org_app         integer                       
                 ,rcp_status_descr   text                          
                 ,rcp_order          jsonb                         
                 ,rcp_receipt        jsonb                         
                 ,id_fsc_provider    integer                       
                 ,rcp_type           integer                       
                 ,rcp_received       bool                          
                 ,rcp_notify_send    bool                          
                 ,id_pay             bigint                        
                 ,resend_pr          integer                       
)

    SECURITY DEFINER
    LANGUAGE plpgsql 
AS
$$
-- =========================================================================================================
--   2023-08-28
--
--    Получили ответ от сервера фискализации, массив JSON, предполагаю, что на входе чеки, успешно проедшие 
--    фискализацию. Статус 200. Статусы чека в БД и на сервере фискализации разнятся.
-- ---------------------------------------------------------------------------------------------------------
-- Статус чека в БД  Описание
--   0        Чек добавлен в систему ожидает постановки в очередь
--   1        Чек отправлен на фискализацию
--   2        Чек успешно фискализирован
--   3        Чек ожидает свободной кассы, очередь переполнена
--   4        Чек с ошибкой (фискализация не будет выполнена)
--   5        Ошибка кассы (попытка фискализации будет выполнена повторно)
-- --------------------------------------------------------------------------------------------------------------
-- ==============================================================================================================

  BEGIN
      RETURN QUERY
        WITH z00 AS 
             (
                SELECT    
                      x.id  AS external_id      
                    , x.fp 
                    , x."processedAt"
                    , x."callbackUrl"
                    
                    ,( json_strip_nulls (
                                         json_build_object (
                                           'id',             x.id              
                                          ,'deviceSN',       x."deviceSN"      
                                          ,'deviceRN',       x."deviceRN"      
                                          ,'fsNumber',       x."fsNumber"      
                                          ,'ofdName',        x."ofdName"       
                                          ,'odfWebsite',     x."odfWebsite"    
                                          ,'ofdINN',         x."ofdINN"        
                                          ,'fnsWebsite',     x."fnsWebsite"    
                                          ,'companyINN',     x."companyINN"    
                                          ,'companyName',    x."companyName"   
                                          ,'documentNumber', x."documentNumber"
                                          ,'shiftNumber',    x."shiftNumber"   
                                          ,'documentIndex',  x."documentIndex" 
                                          ,'processedAt',    x."processedAt"   
                                          ,'change',         x.change          
                                          ,'fp',             x.fp              
                                          ,'callbackUrl',    x."callbackUrl"   
                                          ,'meta',           x.meta            
                                       )
                        )          
                    ) AS js
               
               FROM json_to_recordset ( p_reply )
               
               AS x (  id               text
                     , "deviceSN"       text
                     , "deviceRN"       text
               	     , "fsNumber"       text
                     , "ofdName"        text
                     , "odfWebsite"     text
                     , "ofdINN"         text
                     , "fnsWebsite"     text
                     , "companyINN"     text
                     , "companyName"    text   
                     , "documentNumber" integer
                     , "shiftNumber"    integer
                     , "documentIndex"  integer
                     , "processedAt"    timestamp(0) without time zone
                     , content          json
                     , change           numeric(10,2)
                     , fp               text
                     , "callbackUrl"    text
                     , meta             text
                     
               )  
            )          
            ,z10 AS (
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
                	        INNER JOIN z00 ON (z00.external_id = z.rcp_nmb)
                	 WHERE (z.rcp_status = p_old_rcp_status)
                     FOR UPDATE
                  
          )
           -- SELECT * FROM z10;
          
          , z20 AS (
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
              --   Далее, записи снова создаются, но с новым статусом и обновлёнными
              --    полями "rcp_fp", "dt_fp", "rcp_receipt". 
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
                               , p_new_rcp_status  AS rcp_status  -- Новое значение.      
                               , z20.dt_update
                               , z20.inn
                               , z20.rcp_nmb
                               , z00.fp                  -- rcp_fp
                               , z00."processedAt"       -- dt_fp
                                --
                               , z20.id_org_app
                               , CASE p_new_rcp_status
                                    WHEN 2 THEN 'Успешная фискализация'
                                    ELSE
                                         NULL
                                 END AS rcp_status_descr
                               , z20.rcp_order  
                               --
                               , z00.js                        -- rcp_receipt
                               --
                               , z20.id_fsc_provider
                               , z20.rcp_type
                               , z20.rcp_received
                               , z20.rcp_notify_send
                               , z20.id_pay                            
                               , z20.resend_pr
                         
                         FROM z20
                           
                         INNER JOIN z00 ON (z00.external_id = z20.rcp_nmb)  
                         
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


COMMENT ON FUNCTION fsc_orange_pcg.fsc_receipt_upd (json, integer, integer)
    IS 'Смена статуса чека, после успешного приёма данных с фикализационного сервера. Формирует DATA-SET. ORANGE';	
-- ----------
--  USE CASE:

