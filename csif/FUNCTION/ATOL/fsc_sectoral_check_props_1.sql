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
