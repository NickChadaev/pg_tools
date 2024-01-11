SELECT pgq.create_queue ('sAS222');
SELECT pgq.register_consumer ('sAS222',  'subs_AS222');
SELECT pgq.current_event_table('sAS222'); -- 'pgq.event_1_0'