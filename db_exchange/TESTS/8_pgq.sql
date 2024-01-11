SELECT tick_queue, tick_id, tick_time, tick_snapshot, tick_event_seq
	FROM pgq.tick ORDER BY tick_event_seq DESC;