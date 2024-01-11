-- ---------------
--  2020-11-02
--
-- db_k2
DO
 $$
   DECLARE
     _event_id   bigint;
     _queue_name text := 'sDEMO';
     _port       RECORD;
     _i          smallint := 0;
  
   BEGIN
    FOR _port IN SELECT a FROM bookings.airports a
      LOOP 
          _event_id := pgq.insert_event (	
                queue_name  := _queue_name
               ,ev_type     := 'DATA'
               ,ev_data     := _port::text
               ,ev_extra1   := 'ALL'
               ,ev_extra2   := 'bookings.airports (airport_code char(3), airport_name text, city text, longitude double precision,  latitude double precision, timezone text)'
               ,ev_extra3   := 'RECORD'
               ,ev_extra4   := NULL
          );
          --
          INSERT INTO uio.send_receive_mess (addr_name, data_type, send_type, event_id)     
                   VALUES ('{ALL}', 'RECORD', 'DATA', _event_id  
                );
          PERFORM pg_sleep (10);
          _i := _i + 1;
          --
          RAISE NOTICE 'Step: %', _i;
    END LOOP;      
   END; 
 $$ LANGUAGE plpgsql;
