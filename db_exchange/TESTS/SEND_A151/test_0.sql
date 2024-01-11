-- ---------------
--  2020-11-02
--
-- db_k2
DO
 $$
   DECLARE
     _result     public.result_long_t;
     _event_id   bigint;
     _queue_name text := 'sAS224';
     _qty        smallint := 100;
     _i          smallint := 0;
     
   BEGIN
    LOOP
       BEGIN 
          _result := com.com_f_nso_domain_column_export_xml ( 
              'APP_NODE'
              ,FALSE
              ,'/tmp'
              ,'2020-12-01'
              ,'2020-12-01'
            );
          --
          _event_id := pgq.insert_event (	
                queue_name  := _queue_name
               ,ev_type     := 'DATA'
               ,ev_data     := _result.errm
               ,ev_extra1   := 'ALL'
               ,ev_extra2   := 'com.com_p_domain_column_import_xml(%1$I, %2$2, %3$3)'
               ,ev_extra3   := 'XML'
               ,ev_extra4   := NULL
          );
 --  ---------------------------------------------------------------------------------------------------------
 --      ОШИБКА:  функция pgq.insert_event_raw(text, unknown, timestamp with time zone, unknown, unknown, text, text, text, text, text, text) не существует
 --   СТРОКА 1: SELECT pgq.insert_event_raw(queue_name, null, now(), null, n...
 --                    ^
 --   ПОДСКАЗКА:  Функция с данными именем и типами аргументов не найдена. Возможно, вам следует добавить явные приведения типов.
 --   ЗАПРОС:  SELECT pgq.insert_event_raw(queue_name, null, now(), null, null,
 --               ev_type, ev_data, ev_extra1, ev_extra2, ev_extra3, ev_extra4)
 --   КОНТЕКСТ:  функция PL/pgSQL pgq.insert_event(text,text,text,text,text,text,text), строка 24, оператор RETURN
 --   функция PL/pgSQL inline_code_block, строка 20, оператор присваивание

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
