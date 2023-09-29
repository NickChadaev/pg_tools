DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_money_transfer_operator_crt_3 (text[], text, text, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_money_transfer_operator_crt_3(
       p_phones  text[] DEFAULT NULL -- Номера телефонов
      ,p_name    text   DEFAULT NULL -- Наименование оператора перевода
      ,p_address text   DEFAULT NULL -- Адрес оператора перевода
      ,p_inn     text   DEFAULT NULL -- ИНН оператора перевода
  )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- =============================================================================================== --
   --   2023-05-23  Создание объекта  "money_transfer_operator" - Оператор перевода денежных средств.
   -- =============================================================================================== --

   DECLARE
     JKEY  CONSTANT text := 'money_transfer_operator';
     JKEYS CONSTANT text[]    := array['phones', 'name', 'address', 'inn']::text[];  
     JQ    CONSTANT integer[] := array[ 19,        64,      256,     NULL]::integer[];
     --                                  1          2         3        4
  
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
    
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';     
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';
     
     __result json;
      
   BEGIN
      IF NOT (p_inn ~ INN_PATTERN)
        THEN
           RAISE '%', format (__inn_mess, JKEY, JKEYS[4], p_inn);         
           
      ELSIF NOT (char_length (p_name) <= JQ[2])
            THEN
                RAISE '%', format (__lts_mess, JKEY, JKEYS[2], JQ[2]);                 
                
      ELSIF NOT (char_length (p_address) <= JQ[3])
            THEN
                RAISE '%', format (__lts_mess, JKEY, JKEYS[3], JQ[3]);                 
      END IF;      
   
      __result := json_strip_nulls (json_build_object ( JKEYS[1], p_phones::text[]
                                                      , JKEYS[2], p_name::text
                                                      , JKEYS[3], p_address::text
                                                      , JKEYS[4], p_inn::text)
      );
       
      RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_money_transfer_operator_crt_3 (text[], text, text, text)     
    IS 'Создание объекта  "money_transfer_operator" - Оператор перевода денежных средств.';
--
-- --  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_money_transfer_operator_crt_3 (ARRAY['9211773067', '+38980935788', '4953367178']
--                                                       , 'xxxxx', 'г. Москва, ул. Складочная д.3', '778907872311'
-- );
-- --
--            SELECT fsc_receipt_pcg.fsc_money_transfer_operator_crt_3 (ARRAY['9211773067', '+38980935788', '4953367178']
--                                                       , 'xxx11111111111111111115555555555555555555555555555555551111111111xx'
-- 																	 , 'г. Москва, ул. Складочная д.3', '778907872311'
-- );
--            SELECT fsc_receipt_pcg.fsc_money_transfer_operator_crt_3 ();
--------------------------------------------------------------------------------------------------------------
-- {"phones":["9211773067","+38980935788","4953367178"],"name":"xxxxx","address":"г. Москва, ул. Складочная д.3","inn":"778907872311"}
-- {}}
-- ERROR:  "money_transfer_operator": Длина "name" должна быть не больше 64 символов