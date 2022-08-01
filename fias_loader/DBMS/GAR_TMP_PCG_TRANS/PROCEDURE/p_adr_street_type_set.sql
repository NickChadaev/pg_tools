DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_street_type_set (
              text,integer,varchar(50),varchar(10), timestamp without time zone                   
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_street_type_set (
            p_schema_name          text  
           ,p_id_street_type       integer  
           ,p_nm_street_type       varchar(50)  
           ,p_nm_street_type_short varchar(10)  
           ,p_dt_data_del          timestamp without time zone = NULL 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ----------------------------------------------------------------------
    --    2021-12-03  Создание/Обновление записи в ОТДАЛЁННОМ справочнике  
    --                  типов улиц
    -- ----------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _ins text = $_$
               INSERT INTO %I.adr_street_type ( 
                    id_street_type       
                   ,nm_street_type       
                   ,nm_street_type_short 
                   ,dt_data_del
               )
                 VALUES (   %L::integer
                           ,%L::varchar(50)           
                           ,%L::varchar(10)                 
                           ,%L::timestamp without time zone 
                 );      
              $_$;

      _upd text = $_$
                      UPDATE %I.adr_street_type SET  
                               nm_street_type       = %L::varchar(50)           
                              ,nm_street_type_short = %L::varchar(10)                           
                              ,dt_data_del          = %L::timestamp without time zone           
                      WHERE (id_street_type = %L::integer);        
        $_$;      
    BEGIN
    _exec := format (_ins, p_schema_name, p_id_street_type, p_nm_street_type
                      ,p_nm_street_type_short, p_dt_data_del 
     );            
     EXECUTE _exec;
    
    EXCEPTION  -- Возникает на отдалённоми сервере            
       WHEN unique_violation THEN 

            _exec := format (_upd, p_schema_name, p_nm_street_type, p_nm_street_type_short 
                             ,p_dt_data_del, p_id_street_type  
            );            
            EXECUTE _exec;  
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_street_type_set (text, integer, varchar(50), varchar(10), timestamp without time zone) 
         IS 'Создание/Обновление записи в ОТДАЛЁННОМ справочнике типов улиц';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_street_type_set ('unsi', 1, 'fff', 'sss',  NULL);
--     CALL gar_tmp_pcg_trans.p_adr_street_type_set ('unsi', 12, 'zzzКвартал','xxxкв-л', NULL);
--     CALL gar_tmp_pcg_trans.p_adr_street_type_set ('unsi', 12, 'Квартал','в-л', NULL);
-- ----------------------------------------------------------------------------------------------
-- ERROR: ОШИБКА:  повторяющееся значение ключа нарушает ограничение уникальности "cin_u_street_type_1"
-- ПОДРОБНОСТИ:  Ключ "(nm_street_type)=(zzzКвартал)" уже существует.
------------------------------------------------------------------------------------------------
         --12 Квартал	кв-л	NULL

-- 


