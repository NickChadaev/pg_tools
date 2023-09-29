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
   
