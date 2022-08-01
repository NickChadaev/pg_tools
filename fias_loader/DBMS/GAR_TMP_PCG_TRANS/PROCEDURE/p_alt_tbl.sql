DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_alt_tbl (boolean);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_alt_tbl (
        p_all  boolean = TRUE
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-13/2021-11-29/2022-03-03
    -- ----------------------------------------------------------------------------------------------------  
    -- Модификация таблиц в схеме gar_tmp. false - UNLOGGED таблицы.
    --                                      true  - LOGGED таблицы.
    -- ====================================================================================================
   
    BEGIN
       IF p_all THEN 
                ALTER TABLE  gar_tmp.adr_area    SET LOGGED;
                ALTER TABLE  gar_tmp.adr_street  SET LOGGED;
                ALTER TABLE  gar_tmp.adr_house   SET LOGGED;
                ALTER TABLE  gar_tmp.adr_objects SET LOGGED;
         ELSE
                ALTER TABLE  gar_tmp.adr_area     SET UNLOGGED;
                ALTER TABLE  gar_tmp.adr_street   SET UNLOGGED;
                ALTER TABLE  gar_tmp.adr_house    SET UNLOGGED;
                ALTER TABLE  gar_tmp.adr_objects  SET UNLOGGED;
       END IF;       
        
       RETURN;
    END;
  $$;

ALTER PROCEDURE gar_tmp_pcg_trans.p_alt_tbl (boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_alt_tbl (boolean) IS 'Модификация таблиц в схеме gar_fias.';
--
--  USE CASE:
--             CALL gar_tmp_pcg_trans.p_alt_tbl (FALSE); --  
--             CALL gar_tmp_pcg_trans.p_alt_tbl ();
