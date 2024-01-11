SELECT * FROM pgq.next_batch_info ('sAS222', 'subs_AS222'); -- 1  	
SELECT * FROM pgq.next_batch_custom (
            i_queue_name    := 'sAS222'
           ,i_consumer_name := 'subs_AS222'
           ,i_min_lag       := interval '30 days'
           ,i_min_count 	:= 500
           ,i_min_interval 	:= interval '30 days'
); 
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
