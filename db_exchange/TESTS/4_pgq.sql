SELECT queue_id, queue_name, queue_ntables, queue_cur_table, queue_rotation_period, queue_switch_step1, queue_switch_step2, queue_switch_time, queue_external_ticker, queue_disable_insert, queue_ticker_paused, queue_ticker_max_count, queue_ticker_max_lag, queue_ticker_idle_period, queue_per_tx_limit, queue_data_pfx, queue_event_seq, queue_tick_seq, queue_extra_maint
	FROM pgq.queue;

SELECT pgq.register_consumer(	'rKRNL', 'subs_KRNL');
SELECT pgq.register_consumer ('rAS222', 'subs_AS222');
SELECT pgq.register_consumer ('rAS224', 'subs_AS224');
SELECT pgq.register_consumer ('rDEMO',  'subs_DEMO');