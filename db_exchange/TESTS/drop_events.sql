SELECT ev_id, ev_time, ev_type, ev_data, ev_extra1, ev_extra2, ev_extra3, ev_extra4
	FROM uio.event_first ORDER BY ev_time DESC;
	
SELECT ev_id, ev_time, ev_type, ev_data, ev_extra1, ev_extra2, ev_extra3, ev_extra4
	FROM uio.event ORDER BY ev_time DESC;	
	
SELECT ev_id, ev_time, ev_type, ev_data, ev_extra1, ev_extra2, ev_extra3, ev_extra4
	FROM uio.event WHERE (ev_time >= '2023-12-01') --AND (ev_extra4 IS NULL)
	ORDER BY ev_time DESC;	-- 170  полный набор -- 85+ 85
-- ----------------------------
BEGIN;
COMMIT;
ROLLBACK;
DELETE FROM uio.event WHERE (ev_time >= '2023-12-01') AND (ev_extra4 IS NULL); -- 170


SELECT ev_id, ev_time, ev_type, ev_data, ev_extra1, ev_extra2, ev_extra3, ev_extra4
	FROM uio.event_proc;
--
SELECT ev_id, ev_time, ev_type, ev_data, ev_extra1, ev_extra2, ev_extra3, ev_extra4
	FROM uio.event_parse;
--
SELECT ev_id, ev_time, ev_type, ev_data, ev_extra1, ev_extra2, ev_extra3, ev_extra4
	FROM uio.event_r1;
	
SELECT ev_id, ev_time, ev_type, ev_data, ev_extra1, ev_extra2, ev_extra3, ev_extra4
	FROM uio.event_p4;
		