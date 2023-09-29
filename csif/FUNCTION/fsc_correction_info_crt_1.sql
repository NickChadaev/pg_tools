DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_correction_info_crt_1 (correction_type_t, date, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_correction_info_crt_1(
       p_type        correction_type_t -- Тип коррекции. 
     , p_base_date   date              -- Дата совершения корректируемого расчета
     , p_base_number text DEFAULT NULL -- Номер документа основания для коррекции
    
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ===================================================================================== --
   --  2023-05-30  Создание объекта  "correction_info" СВЕДЕНИЯ О КОРРЕКТИРУЮЩЕЙ ОПЕРАЦИИ
   -- ===================================================================================== --

   DECLARE
     JKEY  CONSTANT text      := 'correction_info';
     JKEYS CONSTANT text[]    := array['type', 'base_date', 'base_number']::text[];  
     JQ    CONSTANT integer[] := array[  NULL,    NULL,        32 ]::integer[];
     --                                   1        2            3     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s" = %L, "%s" = %L';

     __jdata  text[];
     __result json;
      
   BEGIN
       __jdata := array [p_type::text, to_char(p_base_date,'dd.mm.yyyy'), p_base_number];

     IF (__jdata[1] IS NULL) OR (__jdata[2] IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY, JKEYS[1], __jdata[1], JKEYS[2], __jdata[2]);      
            
       ELSIF NOT (char_length(__jdata[3]) <= JQ[3])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[3], JQ[3]);                 
       END IF;       
       
       __result := json_strip_nulls (json_object (JKEYS, __jdata));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_correction_info_crt_1 (correction_type_t, date, text)     
    IS 'Создание объекта  "correction_info" СВЕДЕНИЯ О КОРРЕКТИРУЮЩЕЙ ОПЕРАЦИИ';
--
--  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_correction_info_crt_1 ('1',NULL,'4');
--            SELECT fsc_receipt_pcg.fsc_correction_info_crt_1 ('self', '2023-05-31', '5037008735/22');
--            SELECT fsc_receipt_pcg.fsc_correction_info_crt_1 (NULL, NULL);    
--            SELECT fsc_receipt_pcg.fsc_correction_info_crt_1 ('self', '2023-05-31', 'ZZZZZZZZZZZZ50370AAAAAAAAAAAAAAAAAA08735/2SSSSSSSSS2');
--------------------------------------------------------------------------------------------------------------
-- ERROR:  invalid input value for enum correction_type_t: "1"
-- {"type":"self","base_date":"31.05.2023","base_number":"5037008735/22"}
-- ERROR:  "correction_info": Эти данные являются обязательными: "type" = NULL, "base_date" = NULL
-- ERROR:  "correction_info": Длина "base_number" должна быть не больше 32 символов