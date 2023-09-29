DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_receive_payments_operators_crt_3 (text[]);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_receive_payments_operators_crt_3(
       p_phones  text[] DEFAULT NULL -- Номера телефонов
  )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- =============================================================================================== --
   --   2023-05-23  "receive_payments_operators" - Контактные номера опраторов по приёму платежей.
   -- =============================================================================================== --

   DECLARE
     JKEY  CONSTANT text = 'receive_payments_operators';
     JKEYS CONSTANT text[] = array['phones']::text[];  

     __result json;
      
   BEGIN
       __result := json_strip_nulls (json_build_object (JKEYS[1], p_phones::text[]));
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_receive_payments_operators_crt_3 (text[])     
    IS ' Контактные номера опраторов по приёму платежей.';
--
--  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_receive_payments_operators_crt_3 (ARRAY['9211773067', '+38980935788', '4953367178']);
--            SELECT fsc_receipt_pcg.fsc_receive_payments_operators_crt_3 ();
--            SELECT NULLIF (fsc_receipt_pcg.fsc_receive_payments_operators_crt_3 (NULL)::text, '{}')::json;
--------------------------------------------------------------------------------------------------------------------------------
-- {"phones":["9211773067","+38980935788","4953367178"]}
