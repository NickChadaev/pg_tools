DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_supplier_info_crt_2 (text[], text, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_supplier_info_crt_2(
       p_phones  text[] -- Номера телефонов
      ,p_name    text   DEFAULT NULL -- Наименование поставщика
      ,p_inn     text   DEFAULT NULL -- Наименование операции
  )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================= --
   --    2023-05-22  Создание объекта  "supplier_info" - атрибуты Поставщика услуг
   -- ============================================================================= --

   DECLARE
     JKEY  CONSTANT text      := 'supplier_info';
     JKEYS CONSTANT text[]    := array['phones', 'name', 'inn']::text[];  
     JQ    CONSTANT integer[] := array[  NULL,    256,    NULL]::integer[];
     --                                   1        2        3       
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s" = %L';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';

     __result json;
      
   BEGIN

     IF (p_phones IS NULL)
       THEN
            RAISE '%', format ( __null_mess, JKEY, JKEYS[1], p_phones );      
            
       ELSIF NOT (p_inn ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[3], p_inn);   
                 
       ELSIF NOT (char_length (p_name) <= JQ[2])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[2], JQ[2]);                 
       END IF;      
      
       __result := json_strip_nulls (json_build_object (JKEYS[1], p_phones::text[], JKEYS[2], p_name::text, JKEYS[3], p_inn::text));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_supplier_info_crt_2 (text[], text, text)     
    IS 'Создание объекта  "supplier_info" - атрибуты Поставщика услуг';
--
--  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_supplier_info_crt_2 (ARRAY['9211773067', '+38980935788', '4953367178'], 'xxxxx', '778907872311');
--            SELECT fsc_receipt_pcg.fsc_supplier_info_crt_2 (ARRAY['9211773067', '+38980935788', '4953367178'], 'xxxxx', '778907DDDD872311');
--            SELECT fsc_receipt_pcg.fsc_supplier_info_crt_2 (ARRAY['9211773067', '+38980935788', '4953367178']);
--------------------------------------------------------------------------------------------------------------
-- {"phones":["9211773067","+38980935788","4953367178"],"name":"xxxxx","inn":"778907872311"}
-- ERROR:  "supplier_info": Неправильный формат ИНН: "inn" = '778907DDDD872311'
