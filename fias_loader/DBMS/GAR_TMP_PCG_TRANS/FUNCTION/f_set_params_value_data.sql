DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_set_params_value (bigint[]);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_set_params_value (
       p_param_type_ids  bigint[] = ARRAY [5,6,7,10,11]::bigint[]
) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO gar_tmp, public
 AS
  $$
    -- ----------------------------------------------------------------------------------------------
    --  2021-11-24 Nick Для каждого объекта запомнить пары "Тип" - "Значение"
    -- ----------------------------------------------------------------------------------------------
    --           p_param_type_ids bigint[] -- Список типов параметров 
    -- ----------------------------------------------------------------------------------------------
    DECLARE
      _r  integer;
    
    BEGIN    
       INSERT INTO gar_tmp.xxx_type_param_value (object_id, type_param_value) 
             SELECT object_id, type_param_value 
                          FROM gar_tmp_pcg_trans.f_show_params_value (p_param_type_ids)
        ON CONFLICT (object_id) DO NOTHING;                  
             
       GET DIAGNOSTICS _r = ROW_COUNT;
       RETURN _r;      
    END;         
$$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_set_params_value (bigint[]) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_set_params_value (bigint[]) 
IS ' Запомнить агрегированные пары "Тип" - "Значение"';
----------------------------------------------------------------------------------
-- USE CASE:
--  truncate table gar_tmp.xxx_type_param_value ;
-- SELECT gar_tmp_pcg_trans.f_set_params_value (); -- NN 2862964
-- select * from  gar_tmp.xxx_type_param_value ;
--
--  SELECT object_id
--     ,(type_param_value -> '5') AS zipcode
--     ,(type_param_value -> '6') AS okato
--     ,(type_param_value -> '7') AS oktmo
--     ,(type_param_value -> '11') AS kladr
-- FROM gar_tmp.xxx_type_param_value WHERE (object_id <= 3);
 
	 
