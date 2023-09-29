DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_additional_user_props_crt_1 (text, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_additional_user_props_crt_1(
       p_name    text  -- Наименование доп. реквизита
     , p_value   text  -- Величина доп. реквизита
  )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-05-23  "additional_user_props" - Дополнительные реквизиты клиента
   -- ============================================================================ --

   DECLARE
     JKEY  CONSTANT text = 'additional_user_props';
     JKEYS CONSTANT text[] = array['name', 'value']::text[];  

     QTY_NAME CONSTANT integer := 64;
     QTY_VALUE CONSTANT integer := 256;

     __mess      text := '"%s": Все данные являются обязательными: "%s" = %L, "%s" = %L';
     __eqs_mess  text := '"%s": Длина "%s" должна быть равна %s символам';      
     
     __result json;
      
   BEGIN
      IF (p_name IS NULL) OR (p_value IS NULL) 
        THEN
              RAISE '%', format(__mess, JKEY, JKEYS[1], p_name, JKEYS[2], p_value);
              
        ELSIF NOT (char_length(p_name) <= QTY_NAME)
             THEN
                    RAISE '%', format(__eqs_mess, JKEY, JKEYS[1], QTY_NAME);
                    
        ELSIF NOT (char_length(p_value) <= QTY_VALUE)
             THEN
                    RAISE '%', format(__eqs_mess, JKEY, JKEYS[2], QTY_VALUE);
                    
      END IF;
   
      __result := json_strip_nulls (json_build_object(JKEYS[1], p_name, JKEYS[2], p_value));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_additional_user_props_crt_1 (text, text)
    IS 'Создание объекта "additional_user_props" - Дополнительные реквизиты клиента';
--
--  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_additional_user_props_crt_1 (NULL,NULL);
--            SELECT fsc_receipt_pcg.fsc_additional_user_props_crt_1 ('R2','V4444');
--            SELECT fsc_receipt_pcg.fsc_additional_user_props_crt_1 ('0000000000000000000000000000000000000000000000000000000000000000000000000000000000000a','ss');
--------------------------------------------------------------------------------------------------------------
-- ERROR:  Все данные являются обязательными: "name" = NULL, "value" = NULL
-- "name":"R2","value":"V4444"}
--ERROR:  Длина "name" должна быть равна 64 символам
