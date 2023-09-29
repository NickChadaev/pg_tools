DROP FUNCTION IF EXISTS fsc_receipt_pcg.f_new_status_get (json, text) CASCADE; 
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.f_new_status_get (
                         p_error  json  -- Код ошибки
                        ,p_status text  -- Статус чека в ответе от сервера
                         --
                        ,OUT rcp_status       integer
                        ,OUT rcp_status_descr text
)
    RETURNS setof record
    LANGUAGE plpgsql
    IMMUTABLE

AS $$

  DECLARE
  -- --------------------------------------------------------------------------------------
  --  2023-08-31 Получить новый статус чека (на основе сообщения отсервера).
  -- --------------------------------------------------------------------------------------
  -- Статус чека в БД  Описание
  --   0        Запрос на фискализацию. Чек добавлен в БД, ожидает отправки на FISC-server
  --   1        Чек отправлен на фискализацию
  --   2        Чек успешно фискализирован
  --   3        Чек ожидает свободной кассы, очередь переполнена
  --   4        Чек с ошибкой (фискализация не будет выполнена)
  --   5        Ошибка кассы (попытка фискализации будет выполнена повторно)
  --   6        Ошибка сервиса (попытка фискализации может быть выполнена повторно)
  -- --------------------------------------------------------------------------------------
  
  RCP_STATUS_2 CONSTANT integer := 2;  -- Коды статусов чека в БД.
  RCP_STATUS_3 CONSTANT integer := 3;
  RCP_STATUS_4 CONSTANT integer := 4;
  RCP_STATUS_5 CONSTANT integer := 5;
  RCP_STATUS_6 CONSTANT integer := 6;
  
  MESS_STATUS_2_DEF CONSTANT text := 'Чек успешно фискализирован';
  MESS_STATUS_3_DEF CONSTANT text := 'Чек ожидает свободной кассы, очередь переполнена';    
  MESS_STATUS_4_DEF CONSTANT text := 'Чек с ошибкой (фискализация не будет выполнена)';
  MESS_STATUS_5_DEF CONSTANT text := 'Ошибка кассы (попытка фискализации будет выполнена повторно)';    
  MESS_STATUS_6_DEF CONSTANT text := 'Ошибка сервиса (попытка фискализации может быть выполнена повторно)';
 
  ARR_AGENT_4  CONSTANT integer[] := fsc_receipt_pcg.c_agent_4();
  ARR_AGENT_5  CONSTANT integer[] := fsc_receipt_pcg.c_agent_5();
  --
  ARR_DRIVER_4 CONSTANT integer[] := fsc_receipt_pcg.c_driver_4();
  ARR_DRIVER_5 CONSTANT integer[] := fsc_receipt_pcg.c_driver_5();
  --
  ARR_SYSTEM_4 CONSTANT integer[] := fsc_receipt_pcg.c_arr_system_4();
  ARR_SYSTEM_6 CONSTANT integer[] := fsc_receipt_pcg.c_arr_system_6();
  
 
  --                                 1         2          3          4        5        6  
  -- public.error_type_t AS ENUM ('system', 'driver', 'timeout', 'unknown', 'none', 'agent'); 
  -- public.status_t     AS ENUM ('done',   'fail',   'wait');    

  __error_types text[] := enum_range(NULL::public.error_type_t);
  __statuses    text[] := enum_range(NULL::public.status_t);  
  
  __err_code integer;
  __err_type text;
  __err_text text;  
  
  BEGIN
-- ----------------------------------------------------------------------  
--  "error": {
--             "error_id": "475d6d8d-844d-4d05-aa8b-e3dbdf4defd6",
--             "code": 34,
--             "text": "Состояние чека не найдено. Попробуйте позднее",
--             "type": "system"
--  }, 
-- ----------------------------------------------------------------------  
    IF ((p_error ->> 'error') IS NOT NULL)
    
      THEN
       __err_code := (p_error ->> 'code')::integer;
       __err_type := (p_error ->> 'type')::text;
       __err_text := (p_error ->> 'text')::text;
       
       IF (__err_type = __error_types[3]) AND       -- 'timeout', fail
             (p_status = __statuses[2]) 
             
          THEN
                rcp_status := RCP_STATUS_3;
                rcp_status_descr := __err_text;
                
          ELSIF (__err_type = __error_types[1]) AND -- system , not wait
                (NOT ( p_status = _statuses[3]))
                
               THEN 
                
                     IF (__err_code = ANY (ARR_SYSTEM_4))
                       THEN
                            rcp_status := RCP_STATUS_4;
                            rcp_status_descr := __err_text;
                     END IF;
                     
                     IF (__err_code = ANY (ARR_SYSTEM_6))
                       THEN
                            rcp_status := RCP_STATUS_6;
                            rcp_status_descr := __err_text;
                     END IF;
            
          ELSIF (__err_type = __error_types[2])  -- driver
          
               THEN
                     IF (__err_code = ANY (ARR_DRIVER_4))
                       THEN
                            rcp_status := RCP_STATUS_4;
                            rcp_status_descr := __err_text;
                     END IF;
                     
                     IF (__err_code = ANY (ARR_DRIVER_5))
                       THEN
                            rcp_status := RCP_STATUS_5;
                            rcp_status_descr := __err_text;
                     END IF;          
          
          ELSIF (__err_type = __error_types[6])  -- agent 
             
               THEN
                     IF (__err_code = ANY (ARR_AGENT_4))
                       THEN
                            rcp_status := RCP_STATUS_4;
                            rcp_status_descr := __err_text;
                     END IF;
                     
                     IF (__err_code = ANY (ARR_AGENT_5))
                       THEN
                            rcp_status := RCP_STATUS_5;
                            rcp_status_descr := __err_text;
                     END IF;                   
       END IF;      
    
      ELSIF (p_status = __statuses[1])           -- done, success
     
           THEN
                 rcp_status       := RCP_STATUS_2;
                 rcp_status_descr := MESS_STATUS_2_DEF;  
         
     ELSE     
           NULL;
          
    END IF;
  
    RETURN NEXT;
    
  END;
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.f_new_status_get (json, text) 
IS 'Получить новый статус чека (на основе сообщения об ошибке)';
   --
   -- USE CASE
   --
   -- SELECT * FROM fsc_receipt_pcg.f_new_status_get ('{"error": null}', done') ;
   -- SELECT * FROM fsc_receipt_pcg.f_new_status_get ('{"error": null}', fail') ;
   -- -------------------------------------------------------------------------------------------
--           rcp_status	rcp_status_descr
--              2      	Успешная фискализация
       

