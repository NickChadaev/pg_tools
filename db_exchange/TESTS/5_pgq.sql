SELECT tick_queue, tick_id, tick_time, tick_snapshot, tick_event_seq FROM pgq.tick;
SELECT pgq.register_consumer ('sBATCH1', 'subs_BATCH');
SELECT pgq.register_consumer ('rBATCH1', 'subs_BATCH');