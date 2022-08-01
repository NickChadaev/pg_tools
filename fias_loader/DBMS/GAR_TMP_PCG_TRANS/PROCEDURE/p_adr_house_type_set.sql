DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_type_set (
              text,integer,varchar(50),varchar(10), integer, timestamp without time zone                   
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_house_type_set (
            p_schema_name          text  
           ,p_id_house_type        integer  
           ,p_nm_house_type        varchar(50)  
           ,p_nm_house_type_short  varchar(10) 
           ,p_kd_house_type_lvl    integer
           ,p_dt_data_del          timestamp without time zone = NULL 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ----------------------------------------------------------------------
    --    2021-12-03  Создание/Обновление записи в ОТДАЛЁННОМ справочнике  
    --                  типов домов/строений
    -- ----------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _ins text = $_$
               INSERT INTO %I.adr_house_type ( 
                    id_house_type       
                   ,nm_house_type       
                   ,nm_house_type_short
                   ,kd_house_type_lvl
                   ,dt_data_del
               )
                 VALUES (   %L::integer
                           ,%L::varchar(50)           
                           ,%L::varchar(10)  
                           ,%L::integer
                           ,%L::timestamp without time zone 
                 );      
              $_$;

      _upd text = $_$
                      UPDATE %I.adr_house_type SET  
                               nm_house_type       = %L::varchar(50)           
                              ,nm_house_type_short = %L::varchar(10)      
                              ,kd_house_type_lvl   = %L::integer
                              ,dt_data_del         = %L::timestamp without time zone           
                      WHERE (id_house_type = %L::integer);        
        $_$;      
    BEGIN
    _exec := format (_ins, p_schema_name, p_id_house_type, p_nm_house_type
                      ,p_nm_house_type_short, p_kd_house_type_lvl, p_dt_data_del 
     );            
     EXECUTE _exec;
    
    EXCEPTION  -- Возникает на отдалённоми сервере            
       WHEN unique_violation THEN 

            _exec := format (_upd, p_schema_name, p_nm_house_type, p_nm_house_type_short 
                             ,p_kd_house_type_lvl, p_dt_data_del, p_id_house_type  
            );            
            EXECUTE _exec;  
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_house_type_set 
  (text, integer, varchar(50), varchar(10), integer, timestamp without time zone) 
         IS 'Создание/Обновление записи в ОТДАЛЁННОМ справочнике типов типов домов/строений';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_house_type_set ('unsi', 1, 'fff', 'sss',  NULL);
--     CALL gar_tmp_pcg_trans.p_adr_house_type_set ('unsi', 4, 'Корпус','корп.', 2, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_house_type_set ('unsi', 24, 'Корпус','корп.', 2, NULL);
--     4	Корпус	корп.	2	NULL
-- ----------------------------------------------------------------------------------------------
