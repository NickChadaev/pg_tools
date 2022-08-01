DROP EVENT TRIGGER IF EXISTS etg_check CASCADE;
CREATE OR REPLACE FUNCTION public.etg_check_func() RETURNS event_trigger
AS 
$$
-- --------------------------------------------------------------------------
--  2021-10-28 Nick Триггерная функция для проверки кода создаваемой функции,
--                  с использованием расширения plpgsql_check.
-- --------------------------------------------------------------------------
   DECLARE
   _x oid;
   _z text;
   
   BEGIN
    _x := (SELECT max(p.oid) FROM pg_catalog.pg_proc p);
     
    -- Проверка того факта, что новая функция написана на plpgsql 
    IF (EXISTS (SELECT 1 FROM pg_catalog.pg_proc p
                     JOIN pg_language l ON (l.oid = p.prolang)
                                  WHERE (l.lanname = 'plpgsql') AND (p.oid = _x)    
          )
    ) THEN      
        -- Проверка кода   
        FOR _z IN SELECT public.plpgsql_check_function ( _x
                                                 ,fatal_errors := true
                                                 ,format       := 'text'
                           )
           LOOP                
                RAISE NOTICE '%', _z;
        END LOOP; 
        
        -- Зависимости в коде
        FOR _z IN SELECT public.plpgsql_show_dependency_tb (_x)
            LOOP                
                 RAISE NOTICE '%', _z;
         END LOOP;   
    END IF;
  END;
$$ 
   LANGUAGE plpgsql;

COMMENT ON FUNCTION public.etg_check_func() IS 
'Триггерная функция для проверки кода создаваемой функции, с использованием расширения plpgsql_check';   
 
ALTER FUNCTION public.etg_check_func() OWNER TO postgres;
 
CREATE EVENT TRIGGER etg_check ON ddl_command_end
    WHEN TAG IN ('CREATE FUNCTION', 'CREATE PROCEDURE')
                               EXECUTE PROCEDURE public.etg_check_func ();

ALTER EVENT TRIGGER etg_check OWNER TO postgres;
