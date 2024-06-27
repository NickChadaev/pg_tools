DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_replace_char (text, char[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_replace_char (
        p_str   text 
       ,p_char  char[]  = ARRAY['*','&','$','@',':','.','(',')','/', '-', '_', '\']
)
    RETURNS text
    STABLE
    LANGUAGE plpgsql
 AS
  $$
     DECLARE
      cEMP   constant char = ''; 
      _char  char;
      _r     text;
     
     BEGIN
        _r := lower (btrim(p_str));
        FOREACH _char IN ARRAY p_char 
           LOOP
           _r := REPLACE (_r, _char, cEMP);
           END LOOP;
           
        RETURN  REPLACE (_r, ' ', ''); -- Только явно указанные константы
     END;
  $$;

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_replace_char (text, char[]) 
IS 'Функция удаляет символы-разделители из строки "gar_tmp.xxx_adr_area_type"';
--
-- USE CASE SELECT  gar_tmp_pcg_trans.f_xxx_replace_char (')/--))(as  ad. ((((dg$$5 67)/9---9//90-') 
--                         -- asaddg5679990
