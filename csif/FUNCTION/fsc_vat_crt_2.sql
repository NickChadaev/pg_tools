DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_vat_crt_2 (vat_t, numeric (10,2));
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_vat_crt_2(
       p_type  vat_t                       -- Номер налога в ККТ
     , p_sum   numeric (10,2) DEFAULT NULL -- Сумма налога в рублях
  )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-05-18  Создание объекта  "vat" - атрибуты налога на позицию
   -- ============================================================================ --

   DECLARE
     JKEY  CONSTANT text   := 'vat';
     JKEYS CONSTANT text[] := array['type', 'sum']::text[];  

     __null_mess text := '"%s": Эти данные являются обязательными: "%s" = %L';
     __result json;
      
   BEGIN
   
    IF (p_type IS NULL)
       THEN
            RAISE '%', format ( __null_mess, JKEY, JKEYS[1], p_type);     
    END IF;
    __result := json_strip_nulls (json_build_object(JKEYS[1], p_type::text, JKEYS[2], p_sum));
       
    RETURN __result;
    
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_vat_crt_2 (vat_t, numeric (10,2))     
    IS 'Создание объекта "vat" - атрибуты налога на позицию';
--
--  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_vat_crt_2 ('1',28.02);
--            SELECT fsc_receipt_pcg.fsc_vat_crt_2 ('vat10',28.02);
--            SELECT fsc_receipt_pcg.fsc_vat_crt_2 ('vat10');
--            SELECT fsc_receipt_pcg.fsc_vat_crt_2 (NULL);
------------------------------------------------------------------------------------------------ 
-- ERROR:  invalid input value for enum vat_t: "1"
-- {"type":"vat10","sum":28.02}
-- {"type":"vat10"}
-- ERROR:  "vat": Эти данные являются обязательными: "type" = NULL