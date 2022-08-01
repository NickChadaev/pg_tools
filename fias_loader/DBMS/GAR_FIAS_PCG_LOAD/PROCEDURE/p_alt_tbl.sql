DROP PROCEDURE IF EXISTS gar_fias_pcg_load.p_alt_tbl (boolean);
CREATE OR REPLACE PROCEDURE gar_fias_pcg_load.p_alt_tbl (
        p_all  boolean = TRUE
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ====================================================================================================
    -- Author: Nick
    -- Create date: 2021-10-13/2021-11-29
    -- ----------------------------------------------------------------------------------------------------  
    -- Модификация таблиц в схеме gar_fias. false - UNLOGGED таблицы.
    --                                      true  - LOGGED таблицы.
    -- ====================================================================================================
   
    BEGIN
       IF p_all THEN 
                ALTER TABLE  gar_fias.as_addr_obj SET LOGGED;
                ALTER TABLE  gar_fias.as_addr_obj_division SET LOGGED;
                ALTER TABLE  gar_fias.as_addr_obj_params SET LOGGED;
                ALTER TABLE  gar_fias.as_addr_obj_type SET LOGGED;
                ALTER TABLE  gar_fias.as_add_house_type SET LOGGED;
                ALTER TABLE  gar_fias.as_adm_hierarchy SET LOGGED;
                ALTER TABLE  gar_fias.as_apartments SET LOGGED;
                ALTER TABLE  gar_fias.as_apartments_params SET LOGGED;
                ALTER TABLE  gar_fias.as_apartment_type SET LOGGED;
                ALTER TABLE  gar_fias.as_carplaces SET LOGGED;
                ALTER TABLE  gar_fias.as_carplaces_params SET LOGGED;
                ALTER TABLE  gar_fias.as_change_history SET LOGGED;
                ALTER TABLE  gar_fias.as_houses SET LOGGED;
                ALTER TABLE  gar_fias.as_houses_params SET LOGGED;
                ALTER TABLE  gar_fias.as_house_type SET LOGGED; 
                ALTER TABLE  gar_fias.as_mun_hierarchy SET LOGGED;
                ALTER TABLE  gar_fias.as_normative_docs SET LOGGED;
                ALTER TABLE  gar_fias.as_norm_docs_kinds SET LOGGED;
                ALTER TABLE  gar_fias.as_norm_docs_types SET LOGGED;
                ALTER TABLE  gar_fias.as_object_level SET LOGGED;
                ALTER TABLE  gar_fias.as_operation_type SET LOGGED; 
                ALTER TABLE  gar_fias.as_param_type SET LOGGED;
                ALTER TABLE  gar_fias.as_reestr_objects SET LOGGED;
                ALTER TABLE  gar_fias.as_rooms SET LOGGED;
                ALTER TABLE  gar_fias.as_rooms_params SET LOGGED;
                ALTER TABLE  gar_fias.as_room_type SET LOGGED;
                ALTER TABLE  gar_fias.as_steads SET LOGGED;
                ALTER TABLE  gar_fias.as_steads_params SET LOGGED;         
         ELSE
                ALTER TABLE  gar_fias.as_addr_obj SET UNLOGGED;
                ALTER TABLE  gar_fias.as_addr_obj_division SET UNLOGGED;
                ALTER TABLE  gar_fias.as_addr_obj_params SET UNLOGGED;
                ALTER TABLE  gar_fias.as_addr_obj_type SET UNLOGGED;
                ALTER TABLE  gar_fias.as_add_house_type SET UNLOGGED;
                ALTER TABLE  gar_fias.as_adm_hierarchy SET UNLOGGED;
                ALTER TABLE  gar_fias.as_apartments SET UNLOGGED;
                ALTER TABLE  gar_fias.as_apartments_params SET UNLOGGED;
                ALTER TABLE  gar_fias.as_apartment_type SET UNLOGGED;
                ALTER TABLE  gar_fias.as_carplaces SET UNLOGGED;
                ALTER TABLE  gar_fias.as_carplaces_params SET UNLOGGED;
                ALTER TABLE  gar_fias.as_change_history SET UNLOGGED;
                ALTER TABLE  gar_fias.as_houses SET UNLOGGED;
                ALTER TABLE  gar_fias.as_houses_params SET UNLOGGED;
                ALTER TABLE  gar_fias.as_house_type SET UNLOGGED; 
                ALTER TABLE  gar_fias.as_mun_hierarchy SET UNLOGGED;
                ALTER TABLE  gar_fias.as_normative_docs SET UNLOGGED;
                ALTER TABLE  gar_fias.as_norm_docs_kinds SET UNLOGGED;
                ALTER TABLE  gar_fias.as_norm_docs_types SET UNLOGGED;
                ALTER TABLE  gar_fias.as_object_level SET UNLOGGED;
                ALTER TABLE  gar_fias.as_operation_type SET UNLOGGED; 
                ALTER TABLE  gar_fias.as_param_type SET UNLOGGED;
                ALTER TABLE  gar_fias.as_reestr_objects SET UNLOGGED;
                ALTER TABLE  gar_fias.as_rooms SET UNLOGGED;
                ALTER TABLE  gar_fias.as_rooms_params SET UNLOGGED;
                ALTER TABLE  gar_fias.as_room_type SET UNLOGGED;
                ALTER TABLE  gar_fias.as_steads SET UNLOGGED;
                ALTER TABLE  gar_fias.as_steads_params SET UNLOGGED;         
       END IF;       
        
       RETURN;
    END;
  $$;

ALTER PROCEDURE gar_fias_pcg_load.p_alt_tbl (boolean) OWNER TO postgres;

COMMENT ON PROCEDURE gar_fias_pcg_load.p_alt_tbl (boolean) IS 'Модификация таблиц в схеме gar_fias.';
--
--  USE CASE:
--             CALL gar_fias_pcg_load.p_alt_tbl (FALSE); --  
--             CALL gar_fias_pcg_load.p_alt_tbl ();
