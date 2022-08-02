-- -------------------------------------------
--  Замечания к тексту функции.
--   - 1) Режим создантие новых записей
--   - 2) Режим обновления
--   - 3) Одно действие для списка схем  (Din SQL)
--     4) Курсор ??
--   + 5) Либо функция с отдельными параметрами
--   + 6) Курсор строитсмя извне ??


DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_area_type_set (
              text,integer,varchar(50),varchar(10),smallint,timestamp without time zone                   
);
CREATE OR REPLACE PROCEDURE gar_tmp_pcg_trans.p_adr_area_type_set (
            p_schema_name        text  
           ,p_id_area_type       integer                     
           ,p_nm_area_type       varchar (50)                
           ,p_nm_area_type_short varchar(10)                 = NULL           
           ,p_pr_lead            smallint                    = 0                    
           ,p_dt_data_del        timestamp without time zone = NULL 
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- ----------------------------------------------------------------------
    --    2021-12-03  Создание/Обновление записи в ОТДАЛЁННОМ справочнике  
    --                  типов адресных пространств
    -- ----------------------------------------------------------------------
    DECLARE
      _exec text;
      
      _ins text = $_$
               INSERT INTO %I.adr_area_type ( 
                    id_area_type       
                   ,nm_area_type       
                   ,nm_area_type_short 
                   ,pr_lead            
                   ,dt_data_del
               )
                 VALUES (   %L::integer
                           ,%L::varchar(50)           
                           ,%L::varchar(10)                 
                           ,%L::smallint
                           ,%L::timestamp without time zone 
                 );      
              $_$;

      _upd text = $_$
                      UPDATE %I.adr_area_type SET  
                               nm_area_type       = %L::varchar(50)           
                              ,nm_area_type_short = %L::varchar(10)                           
                              ,pr_lead            = %L::smallint                 
                              ,dt_data_del        = %L::timestamp without time zone           
                      WHERE (id_area_type = %L::integer);        
        $_$;      
    BEGIN
    _exec := format (_ins, p_schema_name, p_id_area_type, p_nm_area_type, p_nm_area_type_short 
                      ,p_pr_lead, p_dt_data_del);            
     EXECUTE _exec;
    
    EXCEPTION  -- Возникает на отдалённоми сервере            
       WHEN unique_violation THEN 

            _exec := format (_upd, p_schema_name, p_nm_area_type, p_nm_area_type_short 
                             ,p_pr_lead, p_dt_data_del, p_id_area_type
            );            
            EXECUTE _exec;  
    END;
  $$;

COMMENT ON PROCEDURE gar_tmp_pcg_trans.p_adr_area_type_set ( text,integer,varchar(50),varchar(10),smallint,timestamp without time zone) 
         IS 'Создание/Обновление записи в ОТДАЛЁННОМ справочнике типов адресных пространств';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
--     CALL gar_tmp_pcg_trans.p_adr_area_type_set ('unsi', 1, 'fff', 'sss', 0::smallint, NULL);
--     CALL gar_tmp_pcg_trans.p_adr_area_type_set ('unsi', 3, 'Автономная область', 'Аобл', 0::smallint, NULL);

--ЗАМЕЧАНИЕ:  повторяющееся значение ключа нарушает ограничение уникальности "cin_p_area_type"
--ЗАМЕЧАНИЕ:  23505


-- Класс 23 — Нарушение ограничения целостности
-- 23000	integrity_constraint_violation
-- 23001	restrict_violation
-- 23502	not_null_violation
-- 23503	foreign_key_violation
-- 23505	unique_violation
-- 23514	check_violation
-- 23P01	exclusion_violation


