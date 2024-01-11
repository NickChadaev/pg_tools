-- ---------------
--  2020-11-02
--
-- db_k2
DO
 $$
   DECLARE
     _result     public.result_long_t;
     _event_id   bigint;
     _queue_name text := 'sKRNL';
     _qty        smallint := 100;
     _i          smallint := 0;
     
   BEGIN
    LOOP
       BEGIN 
          _result := com_exchange.com_f_obj_codifier_export_xml (
                                   'C_CODIF_ROOT'
                                  , FALSE
                                  , NULL
                                  , '2020-12-01' 
                                  , '2020-12-01'
          );
          --
          _event_id := pgq.insert_event (	
                queue_name  := _queue_name
               ,ev_type     := 'DATA'
               ,ev_data     := _result.errm
               ,ev_extra1   := 'ALL'
               ,ev_extra2   := 'com.com_p_obj_codifier_import_xml(%1$I, %2$2, %3$3)'
               ,ev_extra3   := 'XML'
               ,ev_extra4   := NULL
          );
          --
          INSERT INTO uio.send_receive_mess (addr_name, data_type, send_type, event_id)     
                   VALUES ('{ALL}', 'XML', 'DATA', _event_id  
                );
          PERFORM pg_sleep (10);
       END;
       
       _i := _i +1;
       RAISE NOTICE 'Step: %', _i;
       EXIT WHEN (_i> _qty) ;
    END LOOP;      
   END; 
 $$ LANGUAGE plpgsql;
