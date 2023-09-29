
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Версия пакета. Дата общей сборки, либо максимальная дата обновления.
--
CREATE OR REPLACE VIEW fsc_receipt_pcg.version
 AS
 SELECT '$Revision:f57c3f3$ modified $RevDate:2023-07-17$'::text AS version; 

-- SELECT * FROM fsc_receipt_pcg.version;
-- [atol c0aad62]  Реестр исходных данных и функции -- совместимость FIX-0

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP INDEX IF EXISTS fiscalization.ak1_org; 

DROP FUNCTION fsc_receipt_pcg.f_xxx_replace_char(text) CASCADE;
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.f_xxx_replace_char(p_str text)
    RETURNS text
    LANGUAGE plpgsql

    IMMUTABLE 
    
AS $$
    DECLARE
      PCHAR  CONSTANT text[]  = ARRAY[ 'Г. ЕКАТЕРИНБУРГ','Г. КРАСНОЯРСК','Г. ВОРОНЕЖ',
                              'Г. ХАБАРОВСК','Г. МОСКВА','*','&','$','@',':','.','(',')',
                              '/', '-', '_', '\','ЛС','N','"', '№'];
      --                        
      cEMP   CONSTANT text = ''; 
      _char  text;
      _r     text;
     
    BEGIN
        _r := upper(btrim(p_str));
        FOREACH _char IN ARRAY PCHAR 
           LOOP
           _r := REPLACE (_r, _char, cEMP);
           END LOOP;
           
        RETURN REPLACE (_r, ' ', ''); -- Только явно указанные константы
    END;
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.f_xxx_replace_char(text)
    IS 'Функция удаляет мусорные символы из строки';

CREATE UNIQUE INDEX IF NOT EXISTS ak1_org ON fiscalization.fsc_org 
  USING btree (fsc_receipt_pcg.f_xxx_replace_char(nm_org_name), inn);
   

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_mark_quantity_crt_2 (integer, integer);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_mark_quantity_crt_2(
      p_numerator    integer
     ,p_denominator  integer
     
  )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- =========================================================================================== --
   --    2023-05-19'Создание объекта "mark_quantity" - дробное количество маркированного товара'
   -- =========================================================================================== --

   DECLARE
     JKEY  CONSTANT text = 'mark_quantity';
     JKEYS CONSTANT text[] = array['numerator', 'denominator']::text[];  

     __result json;
      
   BEGIN
     IF NOT ((p_numerator IS NOT NULL) AND (p_denominator IS NOT NULL)) 
        THEN
             RAISE 'mark_quantity: NULL значения запрещены';
     END IF;   
   
     IF (p_numerator <= 0) 
        THEN
             RAISE 'mark_quantity: %: "numerator" должен быть > 0', p_numerator;
     END IF;
   
     IF (p_denominator <= 0) 
        THEN
             RAISE 'mark_quantity: %: "denominator" должен быть > 0', p_denominator;
     END IF;

     IF NOT (p_numerator < p_denominator) 
        THEN
             RAISE 'mark_quantity: %, %: "numerator" должен быть меньше, чем "denominator"', p_numerator, p_denominator;
     END IF;
     
       __result := json_strip_nulls (json_build_object(JKEYS[1], p_numerator, JKEYS[2], p_denominator));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_mark_quantity_crt_2 (integer, integer)     
    IS 'Создание объекта "mark_quantity" - дробное количество маркированного товара';
--
--  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_mark_quantity_crt_2 (1,2);
--            SELECT fsc_receipt_pcg.fsc_mark_quantity_crt_2 (10,2);
--            SELECT fsc_receipt_pcg.fsc_mark_quantity_crt_2 (0,133);
--            SELECT fsc_receipt_pcg.fsc_mark_quantity_crt_2 (133, -33);
--            SELECT fsc_receipt_pcg.fsc_mark_quantity_crt_2 (NULL, -33);
--------------------------------------------------------------------------------------------------------------
-- {"numerator":1,"denominator":2}
-- ERROR:  10, 2: "numerator" должен быть меньше, чем "denominator"
-- ERROR:  0: "numerator" должен быть > 0

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_mark_code_crt_2 (text, text, text, text, text, text, text, text, text, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_mark_code_crt_2 (

      p_unknown text DEFAULT NULL -- нераспознанный код товара
     ,p_ean8    text DEFAULT NULL -- Код товара в формате EAN-8
     ,p_ean13   text DEFAULT NULL -- Код товара в формате EAN-13.
     ,p_itf14   text DEFAULT NULL -- Код товара в формате ITF-14.
     ,p_gs10    text DEFAULT NULL -- Код товара в формате GS1, нанесенный на товар, не подлежащий маркировке средствами идентификации.
     ,p_gs1m    text DEFAULT NULL -- Код товара в формате GS1, нанесенный на товар, подлежащий маркировке средствами идентификации.
     ,p_short   text DEFAULT NULL -- Код товара в формате короткого кода маркировки, нанесенный на товар, подлежащий маркировке средствами идентификации.
     ,p_fur     text DEFAULT NULL -- Контрольно-идентификационный знак мехового изделия.
     ,p_egais20 text DEFAULT NULL -- Код товара в формате ЕГАИС-2.0.
     ,p_egais30 text DEFAULT NULL -- Код товара в формате ЕГАИС-3.0.
  )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ========================================================================================= --
   --    2023-05-22  Создание объекта "mark_code" - Маркировка товара средствами идентификации
   -- ========================================================================================= --

   DECLARE
     JKEY  CONSTANT text      := 'makr_code';
     JKEYS CONSTANT text[]    := array ['unknown', 'ean8', 'ean13', 'itf14', 'gs10', 'gs1m', 'short', 'fur', 'egais20', 'egais30']::text[];  
     JQ    CONSTANT integer[] := array [   32,       8,      13,      14,      38,    200,      38,     20,    33,        14     ]::integer[];
     -- --------------------------------------------------------------------------------------------------------------------------------------
     --                                     1        2        3        4        5      6         7       8      9         10
     
     __lts_mess text := '"%s": Длина "%s" должна быть не больше %s символов';
     __eqs_mess text := '"%s": Длина "%s" должна быть ровно %s символов';
     __eqn_mess text := '"%s": Длина "%s" должна быть ровно %s цифр';
     
     __jdata text [] := array[NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL]::text[];
     
     __result json;
      
   BEGIN
      IF (p_unknown IS NOT NULL) 
         THEN
             IF NOT (char_length(p_unknown) <= JQ[1])
               THEN
                  RAISE '%', format (__lts_mess, JKEY, JKEYS[1], JQ[1]);
             END IF;           
             __jdata [1] := p_unknown;
             
      ELSIF (p_ean8 IS NOT NULL)
         THEN
              IF NOT (char_length(p_ean8) =  JQ[2])
               THEN
                  RAISE '%', format (__eqn_mess, JKEY, JKEYS[2], JQ[2]);         
             END IF;          
             __jdata [2] := p_ean8;
             
      ELSIF (p_ean13 IS NOT NULL)
         THEN
              IF NOT (char_length(p_ean13) = JQ[3])
               THEN
                  RAISE '%', format (__eqn_mess, JKEY, JKEYS[3], JQ[3]);        
             END IF;          
             __jdata [3] := p_ean13;
             
      ELSIF (p_itf14 IS NOT NULL)
         THEN
             IF NOT (char_length(p_itf14) = JQ[4])
               THEN
                  RAISE  '%', format (__eqn_mess, JKEY, JKEYS[4], JQ[4]);           
             END IF;     
             __jdata [4] := p_itf14;
         
      ELSIF (p_gs10 IS NOT NULL)
         THEN
             IF NOT (char_length(p_gs10) <= JQ[5])
               THEN
                  RAISE '%', format (__lts_mess, JKEY, JKEYS[5], JQ[5]);
             END IF;           
             __jdata [5] := p_gs10;             
             
      ELSIF (p_gs1m IS NOT NULL)
         THEN
             IF NOT (char_length(p_gs10) <= JQ[6])
               THEN
                  RAISE '%', format (__lts_mess, JKEY, JKEYS[6], JQ[6]);
             END IF;            
             __jdata [6] := p_gs1m;                                

      ELSIF (p_short IS NOT NULL)
         THEN
             IF NOT (char_length(p_short) <= JQ[7])
               THEN
                  RAISE '%', format (__lts_mess, JKEY, JKEYS[7], JQ[7]);
             END IF;            
             __jdata [7] := p_short;                                

      ELSIF (p_fur IS NOT NULL)
         THEN
             IF NOT (char_length(p_fur) = JQ[8])
               THEN
                  RAISE  '%', format (__eqs_mess, JKEY, JKEYS[8], JQ[8]);        
             END IF;           
             __jdata [8] := p_fur;     

      ELSIF ( p_egais20 IS NOT NULL)
         THEN
             IF NOT (char_length(p_egais20) = JQ[9])
               THEN
                  RAISE  '%', format (__eqs_mess, JKEY, JKEYS[9], JQ[9]);  
             END IF;  
             __jdata [9] := p_egais20;   

      ELSIF ( p_egais30 IS NOT NULL)
         THEN
             IF NOT (char_length(p_egais30) = JQ[10])
               THEN
                  RAISE '%', format (__eqs_mess, JKEY, JKEYS[10], JQ[10]);
             END IF;  
             __jdata [10] := p_egais30;               
      END IF;

      __result := json_strip_nulls (json_object (JKEYS, __jdata));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_mark_code_crt_2 (text, text, text, text, text, text, text, text, text, text)
    IS 'Создание объекта "mark_code" - Маркировка товара средствами идентификации';
--
--  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_mark_code_crt_2 (p_unknown := '123456789--9999999999999999999999999999999999999999999999999999999999999999www');
--            SELECT fsc_receipt_pcg.fsc_mark_code_crt_2 (p_ean13 := '1234567890123', p_egais30 :='jkhhhhh');
--            SELECT fsc_receipt_pcg.fsc_mark_code_crt_2 (p_egais30 := '12345678901234');
--------------------------------------------------------------------------------------------------------------

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_agent_info_crt_2(agent_info_t, json, json, json);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_agent_info_crt_2(
       p_type                      agent_info_t       -- Тип агента по предмету расчёта 
     , p_paying_agent              json DEFAULT NULL  -- Атрибуты платёжного агента
     , p_receive_payments_operator json DEFAULT NULL  -- Атрибуты по приёму платежей
     , p_money_transfer_operator   json DEFAULT NULL  -- Атрибуты оператора перевода  
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --  2023-05-19  Все матрёшки (первого, второго и третьего уровней должны 
   --               возвращать значение, ключ -- в вызывающей функциии   ????
   --  2023-05-23  Создание объекта  "agent_info" - платёжный агент.
   -- ============================================================================ --

   DECLARE
     JKEY2 CONSTANT text = 'agent_info';
     JKEYS3 CONSTANT text[] = array['type', 'paying_agent', 'receive_payments_operator', 'money_transfer_operator']::text[];  

     __result json;
      
   BEGIN
       __result := json_build_object ( JKEYS3[1], p_type
                                      ,JKEYS3[2], p_paying_agent
                                      ,JKEYS3[3], p_receive_payments_operator
                                      ,JKEYS3[4], p_money_transfer_operator                                                                
       );
       
       RETURN json_strip_nulls (__result);
       
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_agent_info_crt_2 (agent_info_t, json, json, json)     
    IS 'Создание объекта "Платёжный агент"';
--
--  USE CASE:
--              see "_TEST_fsc_agent_info_crt_2"   
  

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_sectoral_item_props_crt_2 (sectoral_item_props_t[]);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_sectoral_item_props_crt_2(
       p_sectoral_item_props   sectoral_item_props_t[] 
)
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ====================================================================================    --    2023-05-22 Создание объекта "sectoral_item_props" - Отраслевые реквизиты товара.
   -- ==================================================================================== --

   DECLARE
    
     JKEY    CONSTANT text    := 'sectoral_item_props';
     JKEYS   CONSTANT text[] := ARRAY['federal_id', 'date', 'number', 'value'];
     
     DD_MM_YYYY_PATTERN  CONSTANT text := '^(0[1-9]|[12]\\d|3[01])\\.(0[1-9]|1[0-2])\\.(19|20)\\d\\d$'; -- ??!!
     
     QTY_SIP CONSTANT integer := 6; 
     QTY_NMB CONSTANT integer := 32; 
     QTY_VAL CONSTANT integer := 256; 
     
     __len_mess  text := '"%s": Количество различных отраслевых реквизитов не должно превышать: s%';
     __null_mess text := '"%s": Все данные являются обязательными: "%s" = %L, "%s" = %L, "%s" = %L, "%s" = %L';
     __eqs_mess  text := '"%s": Длина "%s" должна быть равна %s символам';     
     
     __sectoral_item_prop  sectoral_item_props_t;

     __result json;
      
   BEGIN
      IF (array_length (p_sectoral_item_props, 1) > QTY_SIP) 
        THEN
          RAISE'%', format (__len_mess, QTY_SIP);
      END IF;  
   
      FOREACH __sectoral_item_prop IN ARRAY p_sectoral_item_props
      
          LOOP
             IF (__sectoral_item_prop.federal_id IS NULL) OR (__sectoral_item_prop.date IS NULL) OR 
                (__sectoral_item_prop.number IS NULL) OR (__sectoral_item_prop.value IS NULL)
               THEN
                    RAISE '%', format (__null_mess, JKEY
                                                  , JKEYS[1], __sectoral_item_prop.federal_id
                                                  , JKEYS[2], __sectoral_item_prop.date
                                                  , JKEYS[3], __sectoral_item_prop.number
                                                  , JKEYS[4], __sectoral_item_prop.value                                                 
                    );
                    
               ELSIF NOT (char_length(__sectoral_item_prop.number) <= QTY_NMB)
                    THEN
                           RAISE '%', format(__eqs_mess, JKEY, JKEYS[3], QTY_NMB);
                           
               ELSIF NOT (char_length(__sectoral_item_prop.value) <= QTY_VAL)
                    THEN
                           RAISE '%', format(__eqs_mess, JKEY, JKEYS[4], QTY_VAL);                           
             END IF;   
          
          END LOOP;
      
      __result := json_strip_nulls (to_json(p_sectoral_item_props));
      
      RETURN __result;      
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_sectoral_item_props_crt_2 (sectoral_item_props_t[])     
    IS ' Создание объекта "sectoral_item_props" - Отраслевые реквизиты товара.';
--
--  USE CASE:
--               SELECT fsc_receipt_pcg.fsc_sectoral_item_props_crt_2 
--                 (array[ ('001', to_char('2023-05-23'::date, 'DD.MM.YYYY'), '123/43', 'Ид1=Знач1&Ид2=Знач2&Ид3=Знач3')
--                        ,('002', to_char('2023-03-20'::date, 'DD.MM.YYY'), '923/43', 'Ид1=Знач1&Ид2=Знач2&Ид3=Знач3')  ]::sectoral_item_props_t[]);

--               SELECT fsc_receipt_pcg.fsc_sectoral_item_props_crt_2 
--                 (array[ ('001', to_char('2023-05-23'::date, 'DD.MM.YYYY'), NULL, 'Ид1=Знач1&Ид2=Знач2&Ид3=Знач3')
--                        ,('002', to_char('2023-03-20'::date, 'DD.MM.YYY'), '923/43', 'Ид1=Знач1&Ид2=Знач2&Ид3=Знач3')  ]::sectoral_item_props_t[]);


-- ERROR:  Все данные являются обязательными: "federal_id" = '001', "date" = '23.05.2023', "number" = NULL, "value" = 'Ид1=Знач1&Ид2=Знач2&Ид3=Знач3'

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_vats_crt_1 (vats_type_sum_t[]);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_vats_crt_1(
       p_vats_type_sum    vats_type_sum_t[] 
)
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-05-19 Создание объекта `vats" - Ставка и сумма налогов в кассе.
   -- ============================================================================ --

   DECLARE
    JKEY    CONSTANT text    := 'vats';
    QTY_VTS CONSTANT integer := 6; 
     
    __lts_vats_mess text := '"%s": Количество различных видов оплаты не должно превышать: %s';
    __null_mess     text := '"%s": Эти данные являются обязательными: "%s[%s]" = %L';
    __result json;
    
    __vats_type_sum  vats_type_sum_t; 
    __i integer;
      
   BEGIN
      IF (array_length (p_vats_type_sum, 1) > QTY_VTS) 
        THEN
           RAISE '%', format (__lts_vats_mess, JKEY, QTY_VTS);
      END IF;

      __i := 1;
      FOREACH __vats_type_sum IN ARRAY p_vats_type_sum
        LOOP
           IF (__vats_type_sum.vats_type IS NULL)
             THEN
                  RAISE '%', format (__null_mess, JKEY, 'vats_type', __i, __vats_type_sum.vats_type);     
           END IF; 
		   
           __i := __i + 1;
        END LOOP;
   
      __result := json_strip_nulls (to_json(p_vats_type_sum));
      
      RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_vats_crt_1 (vats_type_sum_t[])     
    IS 'Создание объекта `vats" - Ставка и сумма налогов в кассе.';
--
--  USE CASE:
          --    SELECT fsc_receipt_pcg.fsc_vats_crt_1 (array[('vat0', 200.2)]::vats_type_sum_t[]);
          --    SELECT fsc_receipt_pcg.fsc_vats_crt_1 (array[('vat20', 200.2), ('vat10', 300.01)]::vats_type_sum_t[]);
          --    SELECT fsc_receipt_pcg.fsc_vats_crt_1 (array[('vat20', 200.2), (NULL, 300.01)]::vats_type_sum_t[]);
          --    SELECT fsc_receipt_pcg.fsc_vats_crt_1 (array[('vat20', NULL), ('vat10', 300.01)]::vats_type_sum_t[]);
		  
-- NOTICE: [{"vats_type":"vat0","vats_sum":200.20}]
-- NOTICE: [{"vats_type":"vat20","vats_sum":200.20},{"vats_type":"vat10","vats_sum":300.01}]
-- ERROR:  "vats": Эти данные являются обязательными: "vats_type[2]" = NULL
-- [{"vats_type":"vat20"},{"vats_type":"vat10","vats_sum":300.01}]



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_sectoral_check_props_crt_1 (sectoral_item_props_t[]);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_sectoral_check_props_crt_1(
       p_sectoral_check_props   sectoral_item_props_t[] 
)
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================================ --
   --    2023-05-25 Создание объекта "sectoral_check_prop" - Отраслевые реквизиты кассового чека.
   -- ============================================================================================ --

   DECLARE
     JKEY    CONSTANT text    := 'sectoral_check_prop';
     JKEYS   CONSTANT text[] := ARRAY['federal_id', 'date', 'number', 'value'];
     
     DD_MM_YYYY_PATTERN  CONSTANT text := '^(0[1-9]|[12]\\d|3[01])\\.(0[1-9]|1[0-2])\\.(19|20)\\d\\d$'; -- ??!!
     
     QTY_SIP CONSTANT integer := 6; 
     QTY_NMB CONSTANT integer := 32; 
     QTY_VAL CONSTANT integer := 256; 
     
     __len_mess  text := '"%s": Количество различных отраслевых реквизитов не должно превышать: s%';
     __null_mess text := '"%s": Все данные являются обязательными: "%s" = %L, "%s" = %L, "%s" = %L, "%s" = %L';
     __eqs_mess  text := '"%s": Длина "%s" должна быть равна %s символам';     
     
     
     __sectoral_check_prop  sectoral_item_props_t;
     __result json;
      
   BEGIN
      IF (array_length (p_sectoral_check_props, 1) > QTY_SIP) 
        THEN
          RAISE'%', format (__len_mess, QTY_SIP);
      END IF;  
   
      FOREACH __sectoral_check_prop IN ARRAY p_sectoral_check_props
      
          LOOP
             IF (__sectoral_check_prop.federal_id IS NULL) OR (__sectoral_check_prop.date IS NULL) OR 
                (__sectoral_check_prop.number IS NULL) OR (__sectoral_check_prop.value IS NULL)
               THEN
                    RAISE '%', format (__null_mess, JKEY 
                                                  , JKEYS[1], __sectoral_check_prop.federal_id
                                                  , JKEYS[2], __sectoral_check_prop.date
                                                  , JKEYS[3], __sectoral_check_prop.number
                                                  , JKEYS[4], __sectoral_check_prop.value                                                 
                    );
                    
               ELSIF NOT (char_length(__sectoral_check_prop.number) <= QTY_NMB)
                    THEN
                           RAISE '%', format(__eqs_mess, JKEY, JKEYS[3], QTY_NMB);
                           
               ELSIF NOT (char_length(__sectoral_check_prop.value) <= QTY_VAL)
                    THEN
                           RAISE '%', format(__eqs_mess, JKEY, JKEYS[4], QTY_VAL);                           
             END IF;   
          
          END LOOP;
      
      __result := json_strip_nulls (to_json(p_sectoral_check_props));
      
      RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_sectoral_check_props_crt_1 (sectoral_item_props_t[])     
    IS ' Создание объекта "sectoral_check_prop" - Отраслевые реквизиты кассового чека.';
--
--  USE CASE:
--               SELECT fsc_receipt_pcg.fsc_sectoral_check_props_crt_1 
--                 (array[ ('001', to_char('2023-05-23'::date, 'DD.MM.YYYY'), '123/43', 'Ид1=Знач1&Ид2=Знач2&Ид3=Знач3')
--                        ,('002', to_char('2023-03-20'::date, 'DD.MM.YYYY'), '923/43', 'Ид1=Знач1&Ид2=Знач2&Ид3=Знач3')  ]::sectoral_item_props_t[]);

-- [ {"federal_id":"001","date":"23:05:2023","number":"123/43","value":"Ид1=Знач1&Ид2=Знач2&Ид3=Знач3"}
--  ,{"federal_id":"002","date":"20:03:2023","number":"923/43","value":"Ид1=Знач1&Ид2=Знач2&Ид3=Знач3"}
-- ]

--               SELECT fsc_receipt_pcg.fsc_sectoral_check_props_crt_1 
--                 (array[ ('001', to_char('2023-05-23'::date, 'DD:MM:YYYY'), '123/43', 'Ид1=Знач1&Ид2=Знач2&Ид3=Знач3')
--                        ,('002', NULL, NULL, 'Ид1=Знач1&Ид2=Знач2&Ид3=Знач3')  ]::sectoral_item_props_t[]);
					   
--  ERROR:  Все данные являются обязательными: "federal_id" = '002', "date" = NULL, "number" = '923/43', "value" = 'Ид1=Знач1&Ид2=Знач2&Ид3=Знач3'

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_payments_crt_1 (pmt_type_sum_t[]);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_payments_crt_1(
       p_pmt_type_sum    pmt_type_sum_t[] 
)
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-05-19 Создание объекта "payments" - Вид и сумма оплаты
   -- ============================================================================ --

   DECLARE
     JKEY     CONSTANT text       := 'payments';
     QTY_PMT  CONSTANT integer    := 10; 
     PMT_TYPE CONSTANT int4range  := int4range('[0,9]');
     
     __pmt_type_sum  pmt_type_sum_t;
     __result        json;
      
   BEGIN
      IF (array_length (p_pmt_type_sum, 1) > QTY_PMT) 
        THEN
          RAISE '"payments": Количество различных видов оплаты не должно превышать: %', QTY_PMT;
      END IF;  

      FOREACH __pmt_type_sum IN ARRAY p_pmt_type_sum
         LOOP
           IF NOT (PMT_TYPE @> __pmt_type_sum.pmt_type)
             THEN
                RAISE '"payments": Вид оплаты должен находится в диапазоне от % до %', lower(PMT_TYPE), upper(PMT_TYPE)-1;
		   END IF;	  
         END LOOP;
      
      __result := json_strip_nulls (to_json(p_pmt_type_sum));
      
      RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_payments_crt_1 (pmt_type_sum_t[])     
    IS 'Создание объекта "payments" - Вид и сумма оплаты';
--
--  USE CASE:
          --    SELECT fsc_receipt_pcg.fsc_payments_crt_1 (array[('1', 200.2)]::pmt_type_sum_t[]);
          --    SELECT fsc_receipt_pcg.fsc_payments_crt_1 (array[(12, 200.2), (0, 300.01)]::pmt_type_sum_t[]);
          -- ERROR:  Вид оплаты должен находится в диапазоне от 0 до 9
-- NOTICE: [{"pmt_type":1,"pmt_sum":200.20}]
-- NOTICE: [{"pmt_type":1,"pmt_sum":200.20},{"pmt_type":0,"pmt_sum":300.01}]


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_items_crt_1 (item_t[]);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_items_crt_1(
       p_item item_t[] 
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-05-18  Создание объекта  "item"
   -- ---------------------------------------------------------------------------- --
   --   Обязательные и опциональные аторибуты типа:
   --  
   --   CREATE TYPE item_t AS (    
   --      name                 text             -- Наименование товара/услуги      
   --     ,price                numeric (10,2)   -- Цена в рублях
   --     ,quantity             numeric (8,3)    -- Количество
   --     ,measure              integer          -- measure_t   -- Единица измерения  --!!! Значения контролирую в функции
   --     ,sum                  numeric (10,2)   -- Сумма в рублях
   --     ,payment_method       payment_method_t -- Способ расчёта
   --     ,payment_object       integer          -- Признак предмета расчёта  !!! Значения контролирую в функции
   --     ,vat                  json             -- Атрибуты налога на позицию
   -- -------------------------------------------------------------------------
   --     ,user_data            text          DEFAULT NULL -- Дополнительный реквизит предмета расчёта
   --     ,excise               numeric(10,2) DEFAULT NULL -- Сумма акциза в рублях 
   --     ,country_code         text          DEFAULT NULL -- Цифровой код страны происхождения товара 
   --     ,declaration_number   text          DEFAULT NULL -- Номер таможенной декларации
   --     ,mark_quantity        json          DEFAULT NULL -- Дробное количество маркированного товара
   --     ,mark_processing_mode text          DEFAULT NULL -- 
   --     ,sectoral_item_props  json          DEFAULT NULL --
   --     ,mark_code            json          DEFAULT NULL -- МАркировка средствами идентификации 
   --     ,agent_info           json          DEFAULT NULL -- Атрибуты агента
   --     ,supplier_info        json          DEFAULT NULL -- Поставщик 
   --                                         Поле обязательно, если передан «agent_info». 
   -- );
   --   COMMENT ON TYPE item_t IS 'Описание товара/услуги';
   -- ============================================================================ --

   DECLARE
     QTY_ITMS CONSTANT integer := 100; 
     
     JKEY     CONSTANT text := 'item'; --  1/7/13          2/8/14                   3/9/15                4/10/16       5/11/17             6/12/18                                
     JKEYS    CONSTANT text[]:= ARRAY [ 'name',           'price',                'quantity',            'measure',   'sum',          'payment_method'      
                                       ,'payment_object', 'vat',                  'user_data',           'excise',    'country_code', 'declaration_number'  
                                       ,'mark_quantity',  'mark_processing_mode', 'sectoral_item_props', 'mark_code', 'agent_info',   'supplier_info'
                                ]::text[];

     JMAX CONSTANT numeric (10,2)[]:= ARRAY [ 
                                        128.0,            42949672.95,              99999.99,               NULL,     42949672.95,     NULL      
                                       , NULL,              NULL,                     64.0,              42949672.95,    3.0,           32.0  
                                       , NULL,              NULL,                     NULL,                 NULL,        NULL,         NULL          
                                ]::text[];

     MEASURE_0 CONSTANT int4range  := int4range('[0,0]');                            
     MEASURE_1 CONSTANT int4range  := int4range('[10,12]');                            
     MEASURE_2 CONSTANT int4range  := int4range('[20,22]');                            
     MEASURE_3 CONSTANT int4range  := int4range('[30,32]');                            
     MEASURE_4 CONSTANT int4range  := int4range('[40,42]');                            
     MEASURE_5 CONSTANT int4range  := int4range('[50,51]');                            
     MEASURE_6 CONSTANT int4range  := int4range('[70,73]');                            
     MEASURE_7 CONSTANT int4range  := int4range('[80,83]');                            
     MEASURE_8 CONSTANT int4range  := int4range('[255,255]');   
     
     PAYMENT_OBJECT_0 CONSTANT int4range  := int4range('[1,27]');  
     PAYMENT_OBJECT_1 CONSTANT int4range  := int4range('[30,33]');                               
                                
     __lts_items_mess text := '"%s": Количество различных товаров/услуг не должно превышать: %s';
     __lts_mess       text := '"%s": Длина "%s" должна быть не больше %s символов';
     __eqs_mess       text := '"%s": Длина "%s" должна быть равна %s символам';     
     __ltn_mess       text := '"%s": Величина "%s" не должна превышать %s';
     __ptn_mess       text := '"%s": Величина "%s" не должна превышать %s и должна быть положительной';    
     __msr_mess       text := '"%s": Неправильный тип единицы измерения товара: "%s" = %s';           
     __mpo_mess       text := '"%s": Неправильный признак предмета расчёта: "%s" = %s';
     
     __null_mess text := '"%s[%s]": Все данные являются обязательными: "%s" = %L, "%s" = %L, "%s" = %L, "%s" = %L'
                         ', "%s" = %L, "%s" = %L, "%s" = %L, "%s" = %L';     
     __items item_t[];
     __item  item_t;
     __i  integer;
     
     __result json;
      
   BEGIN
      IF (array_length (p_item, 1) > QTY_ITMS) 
        THEN
          RAISE '%', format (__lts_items_mess, JKEY, QTY_ITMS);
      END IF;  
      
      -- Теперь цикл по входному массиву, на каждой итерации, выполняются проверки.
      
      __i := 1;
      FOREACH __item IN ARRAY p_item
      
          LOOP
             IF  (__item.name IS NULL) OR (__item.price IS NULL) OR (__item.quantity IS NULL) OR 
                 (__item.measure IS NULL) OR (__item.sum IS NULL) OR (__item.payment_method IS NULL) OR 
                 (__item.payment_object IS NULL) OR (__item.vat IS NULL)
               THEN
                    RAISE '%', format (__null_mess, JKEY, __i
                                              , JKEYS[1], __item.name  
                                              , JKEYS[2], __item.price
                                              , JKEYS[3], __item.quantity
                                              , JKEYS[4], __item.measure
                                              , JKEYS[5], __item.sum
                                              , JKEYS[6], __item.payment_method 
                                              , JKEYS[7], __item.payment_object  
                                              , JKEYS[8], __item.vat
                                      );

                ELSIF NOT (char_length(__item.name) <= JMAX[1]::integer)   
                    THEN
                         RAISE '%', format (__lts_mess, JKEY, JKEYS[1], JMAX[1]::integer);
                    
                ELSIF (__item.price > JMAX[2]) 
                    THEN
                         RAISE '%', format (__ltn_mess, JKEY, JKEYS[2], JMAX[2]::integer);
                         
                ELSIF (__item.quantity > JMAX[3]) 
                    THEN
                         RAISE '%', format (__ltn_mess, JKEY, JKEYS[3], JMAX[3]::integer);
                         
                ELSIF NOT (( MEASURE_0 @> __item.measure) OR ( MEASURE_1 @> __item.measure) OR ( MEASURE_2 @> __item.measure) OR 
                           ( MEASURE_3 @> __item.measure) OR ( MEASURE_4 @> __item.measure) OR ( MEASURE_5 @> __item.measure) OR 
                           ( MEASURE_6 @> __item.measure) OR ( MEASURE_7 @> __item.measure) OR ( MEASURE_8 @> __item.measure)
                          )                                                                                   
                    THEN
                        RAISE '%', format (__msr_mess, JKEY, JKEYS[4], __item.measure);
     
                ELSIF (__item.sum > JMAX[5]) 
                    THEN
                         RAISE '%', format (__ltn_mess, JKEY, JKEYS[5], JMAX[5]::integer);           
             
                ELSIF NOT ((PAYMENT_OBJECT_0 @> __item.payment_object) OR (PAYMENT_OBJECT_1 @> __item.payment_object)) 
                    THEN                
                        RAISE '%', format (__mpo_mess, JKEY, JKEYS[7], __item.payment_object);
                
                ELSIF NOT (char_length(__item.user_data) <= JMAX[9]::integer)
                    THEN
                        RAISE '%', format (__lts_mess, JKEY, JKEYS[9], JMAX[9]::integer);               
             
                ELSIF NOT ((__item.excise <= JMAX[10]) AND (__item.excise > 0)) 
                    THEN
                         RAISE '%', format (__ptn_mess, JKEY, JKEYS[10], JMAX[10]::integer);

                ELSIF NOT (char_length(__item.country_code) = JMAX[11]::integer)
                    THEN                
                         RAISE '%', format (__eqs_mess, JKEY, JKEYS[11], JMAX[11]::integer); 
                    
                ELSIF NOT (char_length(__item.declaration_number) <= JMAX[12]::integer)
                    THEN
                         RAISE '%', format (__lts_mess, JKEY, JKEYS[12], JMAX[12]::integer);
             END IF;

             __items [__i] := __item ;
             __i := __i + 1;
          END LOOP;
      
       __result := json_strip_nulls (to_json(__items));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_items_crt_1 (item_t[])     
    IS 'Создание объекта "item" -- описание товаров/услуг';
--
--  USE CASE:
--             SEE TESTS
--------------------------------------------------------------------------------------------------------------

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_client_crt_1 (text, text, text, text, text, text, text, text, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_client_crt_1 (

       p_name           text DEFAULT NULL::text
     , p_inn            text DEFAULT NULL::text
     , p_email          text DEFAULT NULL::text              -- НЕТ ЕГО
     , p_phone          text DEFAULT NULL::text              -- НЕТ ЕГО
     , p_birthdate      text DEFAULT NULL::text
     , p_citizenship    text DEFAULT NULL::text 
     , p_document_code  text DEFAULT NULL::text 
     , p_document_data  text DEFAULT NULL::text 
     , p_address        text DEFAULT NULL::text 
     
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql

AS $$
   -- ============================================================================ --
   --    2023-05-18  Создание объекта  "client"  Уровень 1.
   -- ============================================================================ --

   DECLARE
     JKEY  CONSTANT text      := 'client';
     JKEYS CONSTANT text[]    := array['email', 'phone','name','inn','birthdate','citizenship','document_code','document_data','address']::text[];  
     JQ    CONSTANT integer[] := array[  64,     19,     256,   NULL,    10,          3,            2,               64,          256]::integer[];
     --                                   1       2       3      4      5           6             7                  8           9
     
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __eqs_mess  text := '"%s": Длина "%s" должна быть ровно %s символов';
     __eqn_mess  text := '"%s": Длина "%s" должна быть ровно %s цифр';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s" = %L, "%s" = %L';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';

     __jdata  text[];
     __result json;
      
   BEGIN
     __jdata := array [p_email, p_phone, p_name, p_inn, p_birthdate, p_citizenship, p_document_code, p_document_data, p_address];
     
     IF NOT (char_length(__jdata[1]) <= JQ[1]) 
       THEN
           RAISE '%', format (__lts_mess, JKEY, JKEYS[1], JQ[1]);              
            
       ELSIF NOT (char_length(__jdata[2]) <= JQ[2])
            THEN  
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[2], JQ[2]);      

       ELSIF NOT (char_length(__jdata[3]) <= JQ[3])
            THEN  
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[3], JQ[3]);   
                 
       ELSIF NOT (__jdata[4] ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[4], __jdata[4]);   
                 
       ELSIF NOT (char_length(__jdata[5]) = JQ[5])
             THEN
                 RAISE '%', format (__eqs_mess, JKEY, JKEYS[5], JQ[5]);                 
                 
       ELSIF NOT (char_length(__jdata[6]) = JQ[6])
             THEN
                 RAISE '%', format (__eqs_mess, JKEY, JKEYS[6], JQ[6]);                 

       ELSIF NOT (char_length(__jdata[7]) = JQ[7])
             THEN
                 RAISE '%', format (__eqs_mess, JKEY, JKEYS[7], JQ[7]);                 
                 
       ELSIF NOT (char_length(__jdata[8]) <= JQ[8])
            THEN  
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[8], JQ[8]);   

       ELSIF NOT (char_length(__jdata[9]) <= JQ[9])
            THEN  
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[9], JQ[9]);   
                 
       END IF;
      
       __result := json_strip_nulls (json_object (JKEYS, __jdata));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_client_crt_1 (text, text, text, text, text, text, text, text, text)     
    IS 'Создание объекта "client"';
--
--  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_client_crt_1 ();
--            SELECT fsc_receipt_pcg.fsc_client_crt_1 ('1','2','3','4', p_address := 'xxxx');
--            SELECT fsc_receipt_pcg.fsc_client_crt_1 (p_name := 'ООО "МОСОБЛЕИРЦ"', p_inn := '5037008735');
--            SELECT fsc_receipt_pcg.fsc_client_crt_1 (p_name := 'ООО "МОСОБЛЕИРЦ"', p_inn := '5037008735'
--                   , p_document_data := 'QWEERTTYYOPUOIP[I[[B,BNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN2222222222]]]'                              
-- );
--------------------------------------------------------------------------------------------------------------
-- {}
--{"client" : {"email":"1","phone":"2","name":"3","inn":"4","address":"xxxx"}}
-- {"email":"3","phone":"4","name":"1","inn":"2","address":"xxxx"}
--
-- {"client" : {"name":"ООО \"МОСОБЛЕИРЦ\"","inn":"5037008735"}}
  

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_receipt_crt_0(json, json, json, json, numeric (10,2), json, text, text, text, json, json, json  );
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_receipt_crt_0(
       p_client                  json -- Покупатель / клиент 
     , p_company                 json -- Компания
     , p_items                   json -- Товары, услуги
     , p_payments                json -- Оплаты
     , p_total                   numeric (10,2) -- Итоговая сумма чека в рублях
     , p_vats                    json  DEFAULT NULL -- Атрибуты налогов на чек
     , p_cashier                 text  DEFAULT NULL -- ФИО кассира
     , p_cashier_inn             text  DEFAULT NULL -- ИНН кассира
     , p_additional_check_props  text  DEFAULT NULL -- Дополнительный реквизит чека
     , p_additional_user_props   json  DEFAULT NULL -- Дополнительный реквизит пользователя
     , p_operating_check_props   json  DEFAULT NULL -- Операционныц реквизит чека
     , p_sectoral_check_props    json  DEFAULT NULL -- Отраслевой реквизит кассового чека
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-05-26  Создание объекта "receipt"
   -- ============================================================================ --
   
   DECLARE
     JKEY  CONSTANT text      := 'receipt';
     JKEYS CONSTANT text[]    := array [ 'client',                 'company',                'items',                 'payments'
     --                                     1                         2                         3                         4      
                                       , 'total',                  'vats',                   'cashier',               'cashier_inn'
     --                                     5                         6                         7                         8      
                                       , 'additional_check_props', 'additional_user_proips', 'operating_check_props', 'sectoral_check_props'
     --                                     9                         10                         11                       12      
                                       ]::text[];  
                                       
     JQ    CONSTANT integer[] := array[    NULL,                     NULL,                      NULL,                    NULL
                                          ,NULL,                     NULL,                      64,                      NULL
                                          , 16,                      NULL,                      NULL,                    NULL
     ]::integer[];
     
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s", "%s", "%s", "%s", "%s"';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';

     __result json;
      
   BEGIN
   
     IF (p_client IS NULL) OR (p_company IS NULL) OR 
        (p_items IS NULL) OR (p_payments IS NULL) OR (p_total IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY, JKEYS[1], JKEYS[2], JKEYS[3], JKEYS[4], JKEYS[5]
            );      
            
       ELSIF NOT (p_cashier_inn ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[8], p_cashier_inn);   
                 
       ELSIF NOT (char_length(p_cashier) <= JQ[7])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[7], JQ[7]);                 
                 
       ELSIF NOT (char_length(p_additional_check_props) <= JQ[9])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[9], JQ[9]);                 
                 
       END IF;       
       
       __result := json_strip_nulls (json_build_object (
                 JKEYS [1], p_client, JKEYS[2], p_company, JKEYS[3], p_items,   JKEYS[ 4], p_payments 
                ,JKEYS [5], p_total,  JKEYS[6], p_vats,    JKEYS[7], p_cashier, JKEYS[ 8], p_cashier_inn
                ,JKEYS [9], p_additional_check_props, JKEYS[10], p_additional_user_props 
                ,JKEYS[11], p_operating_check_props,  JKEYS[12], p_sectoral_check_props  
       ));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_receipt_crt_0 (json, json, json, json, numeric (10,2), json, text, text, text, json, json, json)     
    IS 'Создание объекта "receipt"';
--
--  USE CASE:
--

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_correction_crt_0 
             (json, json, json, json, json, numeric (10,2), json, text, text, text, json, json, json);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_correction_crt_0(
       p_client                  json -- Покупатель / клиент 
     , p_company                 json -- Компания
     , p_correction_info         json -- Информация о типе коррекции 
     , p_items                   json -- Товары, услуги
     , p_payments                json -- Оплаты
     , p_total                   numeric (10,2) -- Итоговая сумма чека в рублях
     , p_vats                    json  DEFAULT NULL -- Атрибуты налогов на чек
     , p_cashier                 text  DEFAULT NULL -- ФИО кассира
     , p_cashier_inn             text  DEFAULT NULL -- ИНН кассира
     , p_additional_check_props  text  DEFAULT NULL -- Дополнительный реквизит чека
     , p_additional_user_props   json  DEFAULT NULL -- Дополнительный реквизит пользователя
     , p_operating_check_props   json  DEFAULT NULL -- Операционныц реквизит чека
     , p_sectoral_check_props    json  DEFAULT NULL -- Отраслевой реквизит кассового чека
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-05-30  Создание объекта "correction"
   -- ============================================================================ --
   
   DECLARE
     JKEY  CONSTANT text      := 'correction';
     JKEYS CONSTANT text[]    := array [ 'client',                 'company',            'correction_info',             'items'
     --                                     1                         2                         3                         4      
                                       , 'payments',               'total',                  'vats',                   'cashier'
     --                                     5                         6                         7                         8      
                                       , 'cashier_inn', 'additional_check_props', 'additional_user_proips', 'operating_check_props'
     --                                     9                         10                       11                        12      
                                       , 'sectoral_check_props'     
     --                                     13                                       
                                       ]::text[];  
                                       
     JQ    CONSTANT integer[] := array[    NULL,                     NULL,                      NULL,                    NULL
                                          ,NULL,                     NULL,                      NULL,                     64                     
                                          ,NULL,                       16,                      NULL,                     NULL
                                          ,NULL
     ]::integer[];
     
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s", "%s", "%s", "%s", "%s", "%s"';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';

     __result json;
      
   BEGIN
   
     IF (p_client IS NULL) OR (p_company IS NULL) OR (p_correction_info IS NULL) OR
        (p_items IS NULL) OR (p_payments IS NULL) OR (p_total IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY, JKEYS[1], JKEYS[2], JKEYS[3], JKEYS[4], JKEYS[5], JKEYS[6]);      
            
       ELSIF NOT (p_cashier_inn ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[9], p_cashier_inn);   
                 
       ELSIF NOT (char_length(p_cashier) <= JQ[8])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[8], JQ[8]);                 
                 
       ELSIF NOT (char_length(p_additional_check_props) <= JQ[10])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[10], JQ[10]);                 
                 
       END IF;       
       
       __result := json_strip_nulls (json_build_object (
                 JKEYS  [1], p_client,      JKEYS  [2], p_company, JKEYS [3], p_correction_info, JKEYS[4], p_items
                ,JKEYS  [5], p_payments,    JKEYS  [6], p_total,   JKEYS [7], p_vats,            JKEYS[8], p_cashier
                ,JKEYS  [9], p_cashier_inn, JKEYS [10], p_additional_check_props, JKEYS[11], p_additional_user_props 
                ,JKEYS [12], p_operating_check_props
                ,JKEYS [13], p_sectoral_check_props  
                                    )
       );
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_correction_crt_0 
            (json, json, json, json, json, numeric (10,2), json, text, text, text, json, json, json)     
    IS 'Создание объекта "correction"';
--
--  USE CASE:
--
-- SELECT fsc_receipt_pcg.fsc_correction_crt_0 (
--        p_client         := NULL -- Покупатель / клиент 
--      , p_company        := NULL -- Компания
--      , p_correction_info := NULL -- Информация о типе коррекции 
--      , p_items          := NULL -- Товары, услуги
--      , p_payments       := '{}' -- Оплаты
--      , p_total          := 9999.99 -- Итоговая сумма чека в рублях
-- );	
-- ERROR:  "correction": Эти данные являются обязательными: "client", "company", "correction_info", "items", "payments", "total"

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_order_crt (timestamp, text, json, boolean, text);
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_order_crt (timestamp, text, operation_t, json, boolean, text);

DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_order_crt (
      timestamp, text, operation_t, json, json, json, json, json, numeric(10,2)
    , json, text, text, text, json, json, json, boolean, text
);      
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_order_crt (
     
       p_timestamp        timestamp   -- Дата и время документа
     , p_external_id      text        -- Внешний идентификатолр документа 
     , p_operation        operation_t -- Тип выполняемой операции
     , p_correction_info  json        -- Информация о типе коррекции ОПЦИОНАЛЬНО МОЖЕТ БЫТЬ "NULL"
     
     -- ----------------------------------------------------------------
     
     , p_client                 json -- Покупатель / клиент 
     , p_company                json -- Компания
     , p_items                  json -- Товары, услуги
     , p_payments               json -- Оплаты
     , p_total                  numeric (10,2) -- Итоговая сумма чека в рублях
     
     , p_vats                   json  DEFAULT NULL -- Атрибуты налогов на чек
     , p_cashier                text  DEFAULT NULL -- ФИО кассира
     , p_cashier_inn            text  DEFAULT NULL -- ИНН кассира
     , p_additional_check_props text  DEFAULT NULL -- Дополнительный реквизит чека
     , p_additional_user_props  json  DEFAULT NULL -- Дополнительный реквизит пользователя
     , p_operating_check_props  json  DEFAULT NULL -- Операционныц реквизит чека
     , p_sectoral_check_props   json  DEFAULT NULL -- Отраслевой реквизит кассового чека
     
     -- ----------------------------------------------------------------
     
     , p_ism_optional boolean DEFAULT NULL -- Регистрация в случае недоступности проверки кода маркировки
     , p_callback_url text    DEFAULT NULL -- Адрес ответа, (используем после обработки чека)
 )
 
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ========================================================================================== --
   --  2023-05-29  Создание объекта "order", данные для POST-запроса на сервер фискализации.     --
   --  2023-06-01  Типизация запросов:  "Просто запрос"/"Корреция".  
   --      + Новый вариант функции, объединяющий в себе как "fsc_receipt_crt_0" 
   --        так и "fsc_correction_crt_0".  Сразу новый запрос на выполнение фискализации.                   
   -- ========================================================================================== --
   
   DECLARE
     JKEY   CONSTANT text := 'order';
     JKEY_0 CONSTANT text := 'service';
     
     RECEIPT    CONSTANT text := 'receipt';
     CORRECTION CONSTANT text := 'correction';
     
     JKEYS       text[] := array [ 'timestamp', 'external_id',  'XXXXX', 'ism_optional', 'callback_url', 'operation' ]::text[];  
     --                                 1            2             3           4               5               6 
     -- Перестал быть константой, JKEYS[3] принимает значения "receipt", "correction"
     
     JQ    CONSTANT integer[] := array [NULL,      128,          NULL,        NULL,           256,           NULL]::integer[];
    
     __lts_mess       text := '"%s": Длина "%s" должна быть не больше %s символов';
     __null_mess      text := '"%s": Эти данные являются обязательными: "%s", "%s", "%s"';
     __null_mess_corr text := '"%s": Данные о коррекции чека являются обязательными';

     __data    json;
     __result  json;
     
   BEGIN
   
     IF (p_timestamp IS NULL) OR (p_external_id IS NULL) OR (p_operation IS NULL)
       THEN
            RAISE '%', format (__null_mess, JKEY, JKEYS[1], JKEYS[2],  JKEYS[6]);        
            
       ELSIF NOT (char_length(p_external_id) <= JQ[2])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[2], JQ[2]);                 
                 
       ELSIF NOT (char_length(p_callback_url) <= JQ[5])
             THEN
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[5], JQ[5]);                 
     END IF;       
       
     IF ( p_operation::text = ANY (enum_range('sell'::operation_t, 'buy_refund'::operation_t)::text[])) 
        THEN 
               JKEYS[3] := RECEIPT; 
               __data := fsc_receipt_pcg.fsc_receipt_crt_0 (
              
                      p_client                 := p_client                 -- Покупатель / клиент 
                    , p_company                := p_company                -- Компания
                    , p_items                  := p_items                  -- Товары, услуги
                    , p_payments               := p_payments               -- Оплаты
                    , p_total                  := p_total                  -- Итоговая сумма чека в рублях
                    , p_vats                   := p_vats                   -- Атрибуты налогов на чек
                    , p_cashier                := p_cashier                -- ФИО кассира
                    , p_cashier_inn            := p_cashier_inn            -- ИНН кассира
                    , p_additional_check_props := p_additional_check_props -- Дополнительный реквизит чека
                    , p_additional_user_props  := p_additional_user_props  -- Дополнительный реквизит пользователя
                    , p_operating_check_props  := p_operating_check_props  -- Операционныц реквизит чека
                    , p_sectoral_check_props   := p_sectoral_check_props   -- Отраслевой реквизит кассового чека
               );
 
        ELSE
               IF (p_correction_info IS NULL)  
                 THEN
                       RAISE '%', format (__null_mess_corr, JKEY);
               END IF;
               
               JKEYS[3] := CORRECTION;
               
               __data := fsc_receipt_pcg.fsc_correction_crt_0 (
               
                             p_client                 :=  p_client                 -- Покупатель / клиент 
                           , p_company                :=  p_company                -- Компания
                           , p_correction_info        :=  p_correction_info        -- Информация о типе коррекции 
                           , p_items                  :=  p_items                  -- Товары, услуги
                           , p_payments               :=  p_payments               -- Оплаты
                           , p_total                  :=  p_total                  -- Итоговая сумма чека в рублях
                           , p_vats                   :=  p_vats                   -- Атрибуты налогов на чек
                           , p_cashier                :=  p_cashier                -- ФИО кассира
                           , p_cashier_inn            :=  p_cashier_inn            -- ИНН кассира
                           , p_additional_check_props :=  p_additional_check_props -- Дополнительный реквизит чека
                           , p_additional_user_props  :=  p_additional_user_props  -- Дополнительный реквизит пользователя
                           , p_operating_check_props  :=  p_operating_check_props  -- Операционныц реквизит чека
                           , p_sectoral_check_props   :=  p_sectoral_check_props   -- Отраслевой реквизит кассового чека
               ); 
     END IF;
       
     __result := json_strip_nulls (json_build_object (
                 JKEYS[1], to_char (p_timestamp, 'dd.mm.yyyy HH:MM::SS')
               , JKEYS[2], p_external_id
               , JKEYS[3], __data
               , JKEYS[4], p_ism_optional
               , JKEY_0, json_build_object (JKEYS[5], p_callback_url)
     ));

     RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_order_crt (
      timestamp, text, operation_t, json, json, json, json, json, numeric(10,2)
    , json, text, text, text, json, json, json, boolean, text
)     
    IS 'Создание объекта "order" (Данные для POST-запроса)';	
--
--  USE CASE:
--


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_orders_load (
              integer, integer, date, date, agent_info_t, text, integer, text, operation_t
);
DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_orders_load (
              integer, date, date, agent_info_t, text, integer, text, operation_t
);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_orders_load (
       p_reestr_type integer = 0 -- Тип реестра с исходными данными
      
      --диапазон, внутри которого фильтруются даты
      ,p_min_date  date = current_date 
      ,p_max_date  date = current_date 
     --
      --Дополнительные атрибуты
     ,p_agent_type          agent_info_t = 'bank_paying_agent'
     ,p_order_callback_url  text         = 'www.xxx.ru' 
     ,p_rcp_type            integer      =  0  --  Кассовый чек
      -- Оплата
     ,p_paying_agent_operation  text        = 'Платёж'
     ,p_order_operation         operation_t = 'sell'
 )
 
    RETURNS integer 
    SECURITY DEFINER
    LANGUAGE plpgsql  
  AS
    $$
-- ------------------------------------------------------------------------------------
--     Загрузка из репестра исходных данных в секцию "0" -- запросы на фискализацию.
--      2023-05-31 -- 2023-06-13  -- Прототип оформленный в виде DO-блока.
--      2023-06-16 -- Первая версия. 
--      2023-07-17 -- Без ссылки на пару "Организация --Приложение".
-- ------------------------------------------------------------------------------------
     DECLARE
       
       __item    item_t;
       __result  json;
       __x       record;
       __i       integer;
       __j       integer;
       --
       __company_phone  text;
       __external_id    uuid;
       
       RCP_STATUS constant integer := 0;  -- Начальное состояние чека.
       RESEND_PR  constant integer := 0;  -- В начальном состоянии количество повторных попыток = 0
     
      -- Далее набор констант, ограничивающий исходные данные,
      -- Хотя плохие исходные данные оставлены, всё равно фильтруем
      --
      MAX_ITEM_NAME_LEN constant integer := 128;
      MAX_ITEM_PRICE    constant numeric(10,2) := 42949673.00;
     
     BEGIN
       __j := 0;
       FOR  __x IN  SELECT    
   	                    x.id_source_reestr
                      , x.dt_create
                      --
                      , x.company_email
                      , x.company_sno
                      , x.company_inn
                      , x.company_payment_address
                      --
                      , x.client_name
                      , x.client_inn
                      , x.pmt_type
                      , x.pmt_sum
                      , substr (x.item_name, 1, MAX_ITEM_NAME_LEN) AS item_name  -- ???
                      , x.item_price
                      , x.item_measure
                      , x.item_quantity
                      , x.item_sum
                      , x.item_payment_method
                      , x.payment_object
                      , x.item_vat
                      , x.client_account
                      --
                      , x.company_account
                      , x.company_phones
                      , x.company_name
                      , z.id_org
                      , (SELECT k.id_org_app FROM fiscalization.fsc_org_app k WHERE (z.id_org = k.id_org) LIMIT 1
                        ) AS id_org_app                     
                      --
                      , x.company_bik
                      , x.company_paying_agent
                      --
                      , x.bank_name
                      , x.bank_addr
                      , x.bank_inn
                      , x.bank_bik
                      , x.bank_phones 
                      , x.external_id
                          
                FROM fiscalization.fsc_source_reestr x 

                     INNER JOIN fiscalization.fsc_org z 
                             ON ( fsc_receipt_pcg.f_xxx_replace_char(x.company_name) =
                                                   fsc_receipt_pcg.f_xxx_replace_char(z.nm_org_name)
                                )
                        WHERE (x.type_source_reestr = p_reestr_type) AND
                              (x.dt_create BETWEEN p_min_date AND p_max_date) AND
                              (x.item_price <= MAX_ITEM_PRICE) 
                           
    			-- 8 ERROR:  "item": Длина "name" должна быть не больше 128 символов
    			--  ERROR:  "item": Величина "price" не должна превышать 42949673
     LOOP           
     
            __external_id  := __x.external_id;
     
           -- Товары, услуги:  элемент структуры
           __item.name     := __x.item_name::text;             
           __item.price    := __x.item_price::numeric(10,2);   
           __item.quantity := __x.item_quantity::numeric(8,3);     
           __item.measure  := __x.item_measure::integer;          
           __item.sum      := __x.item_sum::numeric(10,2);   
           
           __item.payment_method := __x.item_payment_method::payment_method_t; 
           __item.payment_object := __x.payment_object ::integer;         
           
           __item.vat := fsc_receipt_pcg.fsc_vat_crt_2 (
                                    p_type := __x.item_vat -- Номер налога в ККТ
           )::json; 
           ---------------------------------------
           __item.user_data            := NULL::text;         
           __item.excise               := NULL::numeric(10,2);
           __item.country_code         := NULL::text;         
           __item.declaration_number   := NULL::text;         
           __item.mark_quantity        := NULL::json;         
           __item.mark_processing_mode := NULL::text;         
           __item.sectoral_item_props  := NULL::json;         
           __item.mark_code            := NULL::json;  
           
           IF (__x.company_paying_agent)
             THEN
                __i := 1;
                --Уборка мусора из номеров телефонов
                FOREACH __company_phone IN ARRAY __x.company_phones
                 LOOP
                   __company_phone := fsc_receipt_pcg.f_xxx_replace_char(__x.company_phones[__i]);
                   __x.company_phones[__i] := __company_phone;
                   __i := __i + 1;
                END LOOP;
             
                 __item.agent_info := fsc_receipt_pcg.fsc_agent_info_crt_2 (
                       p_type := p_agent_type  -- Тип агента по предмету расчёта 
                      ,p_paying_agent := fsc_receipt_pcg.fsc_paying_agent_crt_3 (
                                   p_paying_agent_operation, __x.company_phones
                       )
                      ,p_receive_payments_operator := 
                           fsc_receipt_pcg.fsc_receive_payments_operators_crt_3 (__x.company_phones)
                      ,p_money_transfer_operator := fsc_receipt_pcg.fsc_money_transfer_operator_crt_3 
                                              ( __x.company_phones
                                               ,__x.company_name
                                               ,__x.company_payment_address
                                               ,__x.company_inn 
                                              )
                  );
                  
                  __item.supplier_info := fsc_receipt_pcg.fsc_supplier_info_crt_2(        
                        p_phones := __x.company_phones -- Номера телефонов        
                       ,p_name   := __x.company_name          
                       ,p_inn    := __x.company_inn      
                  ) ;
             ELSE
                  __item.agent_info    := NULL;
                  __item.supplier_info := NULL;
             END IF;
           
          __result := fsc_receipt_pcg.fsc_order_crt (
          
                 p_timestamp        := __x.dt_create::timestamp -- Дата и время документа
               , p_external_id      := __external_id::text      -- Внешний идентификатолр документа 
               , p_operation        := p_order_operation        -- Тип выполняемой операции
               , p_correction_info  := NULL    -- Информация о типе коррекции ОПЦИОНАЛЬНО МОЖЕТ БЫТЬ "NULL"
                 --     
                -- Покупатель / клиент
               , p_client := fsc_receipt_pcg.fsc_client_crt_1 (
                                                                 p_name := __x.client_name
                                                                ,p_inn  := __x.client_inn
               )::json
              
               -- Компания
               , p_company := fsc_receipt_pcg.fsc_company_crt_1 (
                                p_email           := __x.company_email -- mail отправителя чека (адрес ОФД) 
                              , p_sno             := __x.company_sno   -- Система налогообложения
                              , p_inn             := __x.company_inn   -- ИНН организации
                              , p_payment_address := __x.company_payment_address  -- место расчётов                    
                )::json 
               
               -- Товары, услуги
               , p_items := fsc_receipt_pcg.fsc_items_crt_1 (ARRAY[__item]::item_t[])::json
                
                 --  Оплаты   
               , p_payments := fsc_receipt_pcg.fsc_payments_crt_1 (
                                 p_pmt_type_sum := ARRAY[(__x.pmt_type, __x.pmt_sum)]::pmt_type_sum_t[]
                )::json
                
               , p_total := __x.pmt_sum
               --
               , p_ism_optional := TRUE                 -- Регистрация в случае недоступности проверки кода маркировки  
               , p_callback_url := p_order_callback_url -- Адрес ответа, (используем после обработки чека)   
        
          );
        
         -- RAISE NOTICE '%', __result;   
         
         INSERT INTO fiscalization.fsc_receipt(
                  dt_create       -- d
                , rcp_status      -- 0
                , dt_update
                , inn             -- d
                , rcp_nmb         -- d
                , rcp_fp
                , dt_fp
                , id_org_app      -- 189
                , rcp_status_descr
                , rcp_order       -- d
                , rcp_receipt
                , rcp_type        -- 0
                , rcp_received    -- false
                , rcp_notify_send -- false
                , id_pmt_reestr   -- d
                , resend_pr       -- 0    
           )
         VALUES (      	                      
                    __x.dt_create
                  , RCP_STATUS
                  , NULL
                  , __x.client_inn
                  , __external_id::text
                  , NULL
                  , NULL
                  , __x.id_org_app
                  , NULL
                  , __result::jsonb
                  , NULL
                  , p_rcp_type  -- Тип чека                 -- ??
                  , FALSE
                  , FALSE
                  , __x.id_source_reestr
                  , RESEND_PR
        );
        
        __j := __j + 1;
       END LOOP;
       
       RETURN __j;
    END;
    
   $$;
   
COMMENT ON FUNCTION fsc_receipt_pcg.fsc_orders_load (
       integer, date, date, agent_info_t, text, integer, text, operation_t
)     
    IS ' Загрузка из репестра исходных данных в секцию "0" -- запросы на фискализацию.';	   
 -- =====================================================================================================
-- USE CASE:
-- SELECT * FROM fiscalization.fsc_receipt WHERE ( rcp_status = 0 );
--
-- select count (1), x.dt_create, x.type_source_reestr
--  from fiscalization.fsc_source_reestr x group by x.dt_create, x.type_source_reestr ORDER BY 3, 2;
-- ---------------------------
-- count	dt_create	type_source_reestr
-- 2556	2023-05-12 00:00:00	0
-- 73	    2023-05-13 00:00:00	0
-- 15232	2023-05-17 00:00:00	1
-- ==============================
-- 17861


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- FUNCTION: fsc_receipt_pcg.fsc_range_part_crt(text, text, text, date, date, text, text, text)

DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_range_part_crt(text, text, text, date, date, text, text, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_range_part_crt(
       p_parent_sch_name  text 
     , p_parent_tbl_name  text 
     , p_constr_name      text 
     , p_min_bound        date
     , p_max_bound        date
     , p_part_sch_name    text DEFAULT NULL::text 
     , p_pref_1           text DEFAULT 'fsc'::text 
     , p_pref_2           text DEFAULT 'chk'::text 
     , OUT l_result    boolean 
     , OUT l_part_name text
 )
    RETURNS SETOF record 
    SECURITY DEFINER
    LANGUAGE plpgsql

AS $$
   -- ============================================================================ --
   --    2023-04-13  прототип функции, создающей секции с временными диапазонами
   -- ============================================================================ --

   DECLARE
      _crt_part  text = $_$
   
            CREATE TABLE %s.%s_%s PARTITION OF %s.%s
            ( 
                CONSTRAINT %s_%s CHECK (dt_create >= %L AND dt_create < %L)
            )
                FOR VALUES FROM (%L) TO (%L);
               
       $_$;

      _exec text;      
      _part_sch_name text := COALESCE (p_part_sch_name, p_parent_sch_name);
      
   BEGIN
      _exec := format (_crt_part 
                       ,_part_sch_name
                       , p_pref_1 
                       , p_constr_name
                       , p_parent_sch_name 
                       , p_parent_tbl_name 
                       , p_pref_2
                       , p_constr_name
                       , p_min_bound
                       , p_max_bound
                       , p_min_bound
                       , p_max_bound
       );
	     
	  EXECUTE (_exec);
	     
       l_result    := TRUE;
       l_part_name := btrim (_exec);
      
       RETURN NEXT;
   END;
  
$$;

ALTER FUNCTION fsc_receipt_pcg.fsc_range_part_crt(text, text, text, date, date, text, text, text)
    OWNER TO postgres;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_range_part_crt (text, text, text, date, date, text, text, text)     
    IS 'Прототип функции, создающей секции с временными диапазонами';

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
