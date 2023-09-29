DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_paying_agent_crt_3 (text, text[]);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_paying_agent_crt_3(
       p_operation  text   DEFAULT NULL -- Наименование операции
     , p_phones     text[] DEFAULT NULL -- Номера телефонов
  )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================= --
   --    2023-05-22  Создание объекта  "paying_agent" - атрибуты Платёжного агента
   -- ============================================================================= --

   DECLARE
     JKEY  CONSTANT text := 'paying_agent';
     JKEYS CONSTANT text[]    := array['operation', 'phones']::text[];  
     JQ    CONSTANT integer[] := array[   24,         NULL]::integer[];
     --                                    1           2  
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';       
     
     __result json;
      
   BEGIN
      IF NOT (char_length (p_operation) <= JQ[1])
            THEN
                RAISE '%', format (__lts_mess, JKEY, JKEYS[1], JQ[1]);                 
      END IF;    
   
      __result := json_strip_nulls (json_build_object (JKEYS[1], p_operation::text, JKEYS[2], p_phones::text[]));
       
      RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_paying_agent_crt_3 (text, text[])     
    IS 'Создание объекта  "paying_agent" - атрибуты Платёжного агента';
--
--  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_paying_agent_crt_3 ('Платёж', ARRAY['9211773067', '+38980935788', '4953367178']);
--            SELECT fsc_receipt_pcg.fsc_paying_agent_crt_3 ('Платёж');
--            SELECT fsc_receipt_pcg.fsc_paying_agent_crt_3 ('Платёж 2222222222222222222222222');
--            SELECT fsc_receipt_pcg.fsc_paying_agent_crt_3 ();
--------------------------------------------------------------------------------------------------------------
-- {"operation":"Платёж","phones":["9211773067","+38980935788","4953367178"]}
-- {"operation":"Платёж"}
-- {}
-- "paying_agent": Длина "operation" должна быть не больше 24 символов
