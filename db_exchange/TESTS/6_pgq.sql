SELECT pgq.create_queue ('sAS224');
SELECT pgq.register_consumer ('sAS224',  'subs_AS224');
SELECT pgq.current_event_table('sAS224'); -- 'pgq.event_2_0'