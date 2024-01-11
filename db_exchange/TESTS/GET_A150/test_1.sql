SELECT * FROM pgq.next_batch_info ('sAS222', 'subs_AS222'); -- 1  	
    SELECT * FROM uio_pgq.fetch_queue_items (
                i_queue_name    := 'sAS222'
            ,i_consumer_name := 'subs_AS222'
            ,i_min_lag       := interval '30 days'
            ,i_min_count 	:= 500
            ,i_min_interval 	:= interval '30 days'
    ); 
--
        SELECT * FROM uio_pgq.fetch_queue_items (
                    i_queue_name    := 'sKRNL'
                ,i_consumer_name := 'subs_KRNL'
                ,i_min_lag       := interval '30 days'
                ,i_min_count 	:= 500
                ,i_min_interval 	:= interval '30 days'
        ); 

Пусто везде
SELECT * FROM pgq.next_batch_custom (
            i_queue_name    := 'sKRNL'
           ,i_consumer_name := 'subs_KRNL'
           ,i_min_lag       := interval '30 days'
           ,i_min_count 	:= 500
           ,i_min_interval 	:= interval '30 days'
);
------------------------------------------------------
db_k2=#         SELECT * FROM uio_pgq.fetch_queue_items (
                    i_queue_name    := 'sKRNL'
                ,i_consumer_name := 'subs_KRNL'
                ,i_min_lag       := interval '30 days'
                ,i_min_count := 500
                ,i_min_interval := interval '30 days'
        ); 
ЗАМЕЧАНИЕ:  1) (3963,822,821,"2020-11-02 21:59:34.634429+03","2020-11-02 21:58:34.495654+03",4,4), 3963
ЗАМЕЧАНИЕ:  3) t
ЗАМЕЧАНИЕ:  3) t
ЗАМЕЧАНИЕ:  4) 3
-----------------------
-- 2020-11-15          
SELECT * FROM uio_pgq.fetch_queue_items (
                    i_queue_name    := 'sDEMO'
                ,i_consumer_name := 'subs_DEMO'
                ,i_min_lag       := interval '30 days'
                ,i_min_count := 500
                ,i_min_interval := interval '30 days'
        ); 
--
NOTICE:  1) (3673,3731,3730,"2020-11-14 20:34:19.22853+00","2020-11-14 20:33:26.035921+00",523,419), 3673
NOTICE:  2) (420,"2020-11-14 20:34:18.524793+00",223640,,DATA,"(""(MJZ,Мирный,Мирный,114.038928,62.534689,Asia/Yakutsk)"")",ALL,"bookings.airports (airport_code char(3), airport_name text, city text, longitude double precision,  latitude double precision, timezone text)",RECORD,), 420
NOTICE:  4) 3673, 420
NOTICE:  1) (3673,3731,3730,"2020-11-14 20:34:19.22853+00","2020-11-14 20:33:26.035921+00",523,419), 3673

OK

Теперь Astra

    SELECT   batch_id          
            ,cur_tick_id       
            ,cur_tick_event_seq
            --
            ,ev_id         
            ,ev_time      
            ,ev_txid       
            ,ev_retry     
            ,ev_type 
            ,ev_extra1
            ,ev_extra3
                   
    FROM uio_pgq.fetch_queue_items (
                i_queue_name    := 'sAS222'
            ,i_consumer_name := 'subs_AS222'
            ,i_min_lag       := interval '30 days'
            ,i_min_count 	:= 500
            ,i_min_interval 	:= interval '30 days'
    );  
    

    SELECT   batch_id          
            ,cur_tick_id       
            ,cur_tick_event_seq
            --
            ,ev_id         
            ,ev_time      
            ,ev_txid       
            ,ev_retry     
            ,ev_type 
            ,ev_extra1
            ,ev_extra3
                   
    FROM uio_pgq.fetch_queue_items (
                i_queue_name    := 'sAS224'
            ,i_consumer_name := 'subs_AS224'
            ,i_min_lag       := interval '30 days'
            ,i_min_count 	:= 500
            ,i_min_interval 	:= interval '30 days'
    );     
        
        SELECT * FROM pgq.get_consumer_info('sKRNL');
----------------------------------------------------
db_k2=# SELECT * FROM pgq.get_consumer_info('sKRNL');
-[ RECORD 1 ]--+------------------------
queue_name     | sKRNL
consumer_name  | subs_KRNL
lag            | 12 days 23:20:41.534307
last_seen      | 1 day 01:07:51.239422
last_tick      | 26
current_batch  | 
next_tick      | 
pending_events | 105

    SELECT * FROM pgq.next_batch_custom (
                i_queue_name    := 'sKRNL'
            ,i_consumer_name := 'subs_KRNL'
            ,i_min_lag       := interval '30 days'
            ,i_min_count 	:= 500
            ,i_min_interval 	:= interval '1 day'
    );sDEMO       subs_DEMO   fetch_queue_items
    SELECT * FROM pgq.next_batch_info ('sKRNL', 'subs_KRNL');    -- 799

db_k2=# SELECT * FROM pgq.next_batch_info ('sKRNL', 'subs_KRNL');
-[ RECORD 1 ]-------+------------------------------
batch_id            | 3
cur_tick_id         | 27
prev_tick_id        | 26
cur_tick_time       | 2020-11-01 22:41:57.443742+03
prev_tick_time      | 2020-11-01 22:40:57.299999+03
cur_tick_event_seq  | 1
prev_tick_event_seq | 1


Вставлено в тело функции:
------------------------
ЗАМЕЧАНИЕ:  1) (3,27,26,"2020-11-01 22:41:57.443742+03","2020-11-01 22:40:57.299999+03",1,1)
(0 строк)



        
SELECT * FROM pgq.get_batch_events(	1); -- пусто  Закрыть butch ??
SELECT * FROM pgq.finish_batch (1);
----
SELECT * FROM pgq.next_batch_info ('sAS222', 'subs_AS222'); -- 2
--
SELECT * FROM pgq.next_batch_custom (
            i_queue_name    := 'sAS222'
           ,i_consumer_name := 'subs_AS222'
           ,i_min_lag       := interval '30 days'
           ,i_min_count 	:= 500
           ,i_min_interval 	:= interval '30 days'
); -- 2
SELECT * FROM pgq.get_batch_events(	2);  -- Пусто
SELECT * FROM pgq.finish_batch (2);
-- SELECT interval '30 days'
