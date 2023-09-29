DROP FUNCTION IF EXISTS fsc_orange_pcg.fsc_order_crt (
      text, text, text, json, text, text, text, text, boolean 
);      
CREATE OR REPLACE FUNCTION fsc_orange_pcg.fsc_order_crt (
     
       p_external_id       text -- Внешний идентификатолр документа 
     , p_inn               text -- ИНН организации, для которой пробивается чек
     , p_group             text -- Группа устройств, с помощью которых будет пробит чек
     , p_content           json -- Содержимое документа
     , p_key               text -- Название ключа, который должен быть использован для проверки подписи
     , p_call_back_url     text DEFAULT NULL -- URL для отправки результатов обработки чека 
     , p_call_back_apikey  text DEFAULT NULL -- API-ключ для вызова колбэка
     , p_meta              text DEFAULT NULL -- Метаданные запроса 
     , p_ignore_item_code_check boolean DEFAULT false-- Флаг указывающий стоит ли игнорировать проверку КМ.
 )
 
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ================================================================ --
   --  2023-08-23  Создание объекта "order" (Данные для POST-запроса)
   -- ================================================================ --
   
   DECLARE
    JKEY  CONSTANT text := 'order';
     --                                 1             2                  3        4                    5              
    JKEYS CONSTANT text[] := array [ 'id',          'inn',            'group', 'content',           'key'
                                   , 'callbackUrl', 'callbackApiKey', 'meta',  'ignoreItemCodeCheck' 
                                   ]::text[];  
     --                                 6             7                  8        9           
     JQ CONSTANT integer[] := array [  64,           NULL,              32,     NULL,                 32,
                                     1024,           3072,             128,     NULL            
                                    ]::integer[];
    
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)'; 
    
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s", "%s", "%s", "%s"';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';

     __data    json;
     __result  json;
        
   BEGIN
   
     IF (p_external_id IS NULL) OR (p_inn IS NULL) OR (p_content IS NULL) OR (p_key IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY, JKEYS[1], JKEYS[2], JKEYS[4], JKEYS[5]);        

       ELSIF NOT (p_inn ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[2], p_inn);              
----++++            
       ELSIF NOT (char_length(p_external_id) <= JQ[1])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[1], JQ[1]);                 
                 
       ELSIF NOT (char_length(p_group) <= JQ[3])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[3], JQ[3]);                 
                 
       ELSIF NOT (char_length(p_key) <= JQ[5])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[5], JQ[5]);                 
                 
       ELSIF NOT (char_length(p_call_back_url) <= JQ[6])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[6], JQ[6]);                 

       ELSIF NOT (char_length(p_call_back_apikey) <= JQ[7])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[7], JQ[7]);                 

       ELSIF NOT (char_length(p_meta) <= JQ[8])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[8], JQ[8]);                 
----++++                 
     END IF;       
       
     __result := ( (json_build_object (
                         JKEYS[1], p_external_id
                       , JKEYS[2], p_inn
                       , JKEYS[3], p_group
                       , JKEYS[4], p_content
                       , JKEYS[5], p_key
                     )
                  )::jsonb || (
                                json_strip_nulls (json_build_object (
                                                 JKEYS[6], p_call_back_url         
                                               , JKEYS[7], p_call_back_apikey      
                                               , JKEYS[8], p_meta                  
                                               , JKEYS[9], p_ignore_item_code_check
                                     )
                                 )                  
                  )::jsonb
                 )::json;
				 
     RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_orange_pcg.fsc_order_crt (
                text, text, text, json, text, text, text, text, boolean
)     
    IS 'Создание объекта "order" (Данные для POST-запроса) ORANGE';	
--
--  USE CASE:
--

