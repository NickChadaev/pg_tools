DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_company_crt_1(text, sno_t, text, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_company_crt_1(
       p_email            text     -- mail отправителя чека (адрес ОФД) 
     , p_sno              sno_t    -- Система налогообложения
     , p_inn              text     -- ИНН организации
     , p_payment_address  text     -- место расчётов
    
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-05-18  Создание объекта  "company"
   -- ============================================================================ --

   DECLARE
     JKEY  CONSTANT text      := 'company';
     JKEYS CONSTANT text[]    := array['email',  'sno',   'inn', 'payment_address']::text[];  
     JQ    CONSTANT integer[] := array[  64,     NULL,    NULL,       256]::integer[];
     --                                   1        2        3          4      
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __eqs_mess  text := '"%s": Длина "%s" должна быть ровно %s символов';
     __eqn_mess  text := '"%s": Длина "%s" должна быть ровно %s цифр';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s" = %L, "%s" = %L, "%s" = %L, "%s" = %L';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';

     __jdata  text[];
     __result json;
      
   BEGIN
       __jdata := array [p_email, p_sno::text, p_inn, p_payment_address];

     IF (__jdata[1] IS NULL) OR (__jdata[2] IS NULL) OR 
        (__jdata[3] IS NULL) OR (__jdata[4] IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY 
                                  ,JKEYS[1], __jdata[1], JKEYS[2], __jdata[2]
                                  ,JKEYS[3], __jdata[3], JKEYS[4], __jdata[4]
            );      
            
       ELSIF NOT (__jdata[3] ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[3], __jdata[3]);   
                 
       ELSIF NOT (char_length(__jdata[4]) <= JQ[4])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[4], JQ[4]);                 
       END IF;       
       
       __result := json_strip_nulls (json_object (JKEYS, __jdata));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_company_crt_1 (text,sno_t, text, text)     
    IS 'Создание объекта "company"';
--
--  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_company_crt_1 ('1','osn',NULL,'4');
--            SELECT fsc_receipt_pcg.fsc_company_crt_1 ('mail@1-ofd.ru', 'osn', '5037008735', 'shop-url.ru');
--            SELECT fsc_receipt_pcg.fsc_company_crt_1 ('mail@1-ofd.ru', 'osn', '503700aa8735', 'shop-url.ru');    
--------------------------------------------------------------------------------------------------------------
--ERROR:  Эти данные являются обязательными: "email" = '1', "sno" = 'osn', "inn" = NULL, "payment_address" = '4'
-- {"company" : {"email":"mail@1-ofd.ru","sno":"osn","inn":"5037008735","payment_address":"shop-url.ru"}}
-- ERROR:  Неправильный формат ИНН: "inn" = '503700aa8735'  
