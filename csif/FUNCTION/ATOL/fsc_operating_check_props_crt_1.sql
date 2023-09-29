DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_operating_check_props_crt_1 (text, text, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_operating_check_props_crt_1(
       p_name       text  -- Идентификатор операции
     , p_value      text  -- Данные операции
     , p_timestamp  text  -- Дата и время операции "dd.mm.yyyy HH:MM:SS"  --Преобразовывать при вызове.
  )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ======================================================================================== --
   --    2023-05-24  Создание объекта  "operating_check_props" - Операционный реквизит чека.
   -- ======================================================================================== --

   DECLARE
     JKEY    CONSTANT text   := 'operating_check_props';
     JKEYS   CONSTANT text[] := array['name', 'value', 'timestamp']::text[];  
     QTY_VAL CONSTANT integer := 64;

     __result json;
     __mess      text := '"%s": Все данные являются обязательными: "%s" = %L, "%s" = %L, "%s" = %L';
     __eqs_mess  text := '"%s": Длина "%s" должна быть равна %s символам';      
     
   BEGIN
      IF (p_name IS NULL) OR (p_value IS NULL) OR (p_timestamp IS NULL)
         THEN
              RAISE '%', format(__mess, JKEY, JKEYS[1], p_name, JKEYS[2], p_value, JKEYS[3], p_timestamp);
              
        ELSIF NOT (char_length(p_value) <= QTY_VAL)
             THEN
                    RAISE '%', format(__eqs_mess, JKEY, JKEYS[2], QTY_VAL);
      END IF;
      
       __result := json_strip_nulls (json_build_object (JKEYS[1], p_name, JKEYS[2], p_value, JKEYS[3], p_timestamp));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_operating_check_props_crt_1 (text, text, text)     
    IS 'Создание объекта "operating_check_props" - Операционный реквизит чека.';
--
--  USE CASE:
--    SELECT fsc_receipt_pcg.fsc_operating_check_props_crt_1 ('0', '888888', to_char (now(), 'dd.mm.yyyy HH:MM:SS'));
--    SELECT fsc_receipt_pcg.fsc_operating_check_props_crt_1  ('0', '8888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', to_char (now(), 'dd.mm.yyyy HH:MM:SS'));
--    SELECT fsc_receipt_pcg.fsc_operating_check_props_crt_1 (NULL,NULL, to_char (now(), 'dd.mm.yyyy HH:MM:SS'));
--------------------------------------------------------------------------------------------------------------
-- {"name":"0","value":"888888","timestamp":"24.05.2023 07:05:28"}
--  Длина "value" должна быть равна 64 символам
--  ERROR:   Все данные являются обязательными: "name" = NULL, "value" = NULL, "timestamp" = '24.05.2023 08:05:37'

