EXPLAIN ANALYZE
SELECT fias_guid_new, fias_guid_old, obj_level, date_create
	FROM gar_fias.twin_addr_objects WHERE (fias_guid_old = '0090ad69-933d-4751-9f9c-7bb24e64a87d')
	--ORDER BY fias_guid_new;
--
DROP INDEX IF EXISTS gar_fias.ie1_twin_addr_objects;
CREATE INDEX ie1_twin_addr_objects ON gar_fias.twin_addr_objects (fias_guid_old);

SELECT count(1), fias_guid_old, date_create
	FROM gar_fias.twin_addr_objects WHERE (date_create > '2023-11-09') GROUP BY fias_guid_old, date_create 
ORDER BY 1 DESC, date_create DESC ;
--	
SELECT count(1), fias_guid_old, date_create
	FROM gar_fias.twin_addr_objects WHERE (date_create = '2023-11-09') GROUP BY fias_guid_old, date_create 
ORDER BY 1 DESC, date_create DESC ;
--
--  a25b2d21-a398-47da-aaa8-451c29e67bf4 
--
SELECT fias_guid_new, fias_guid_old, obj_level, date_create FROM gar_fias.twin_addr_objects 
WHERE (obj_level IN (0,1,2)) AND (fias_guid_old = 'a25b2d21-a398-47da-aaa8-451c29e67bf4') ORDER BY obj_level; --НЕТ


SELECT * FROM gar_fias.as_addr_obj WHERE (object_guid = 'a25b2d21-a398-47da-aaa8-451c29e67bf4')
    UNION ALL
SELECT * FROM gar_fias.as_addr_obj WHERE (object_guid IN (SELECT fias_guid_new FROM gar_fias.twin_addr_objects 
                                                             WHERE (fias_guid_old = 'a25b2d21-a398-47da-aaa8-451c29e67bf4')
                                                          )
                                         );    
---------------------------------------------------------------------------------------------------------------------------------------------
-- 51004|44275|'41170db5-ad4d-4cee-bba7-0c989ab79703'|118458|'Скотомогильник'|305|'тер.'|7|10|0|0|'2019-02-27'|'2019-02-19'|'2079-06-06'|t|t
--
EXPLAIN ANALYZE
SELECT t.fias_guid_new, t.fias_guid_old, t.obj_level, t.date_create, s.end_date 
FROM gar_fias.twin_addr_objects t 
    INNER JOIN gar_fias.as_addr_obj s ON (t.fias_guid_new = s.object_guid)
WHERE (s.end_date > current_date) AND 
    (t.fias_guid_old = 'a25b2d21-a398-47da-aaa8-451c29e67bf4') ; --НЕТ
    ----------------------------------------------------------------------------
EXPLAIN ANALYZE
SELECT t.fias_guid_new, t.fias_guid_old, t.obj_level, t.date_create, s.end_date 
FROM gar_fias.twin_addr_objects t 
    INNER JOIN gar_fias.as_addr_obj s ON (t.fias_guid_new = s.object_guid)
WHERE (s.end_date > current_date) AND 
    (t.fias_guid_old = 'c774b5d0-bd2d-4159-87c3-c08edd1bcedc') LIMIT 1; --НЕТ
-------------------------------------------------------------------------------    

-- ----------------------------------------------------------------------------
SELECT t.fias_guid_new, t.fias_guid_old, t.obj_level, t.date_create, s.end_date 
FROM gar_fias.twin_addr_objects t 
    INNER JOIN gar_fias.as_addr_obj s ON (t.fias_guid_new = s.object_guid)
WHERE (s.end_date > current_date) AND 
    (t.fias_guid_old = 'c43ced7d-94ca-424a-bc69-bc7e5c4b1ad5') ; --НЕТ

-------------------------------------------------------------------------------
SELECT fias_guid_new, fias_guid_old, obj_level, date_create
	FROM gar_fias.twin_addr_objects WHERE (obj_level = 2);

-- '23f6da51-e5a2-42a2-aa41-b6448ff7b690'|'f38c7e80-cf78-43d1-92db-ebbc10f0088d' 2

SELECT * FROM gar_fias.as_addr_obj s WHERE('f38c7e80-cf78-43d1-92db-ebbc10f0088d' = s.object_guid) -- НЕТ
SELECT * FROM gar_fias.as_addr_obj s WHERE('23f6da51-e5a2-42a2-aa41-b6448ff7b690' = s.object_guid) -- НЕТ

SELECT * FROM gar_fias.as_houses WHERE (object_guid IN ('23f6da51-e5a2-42a2-aa41-b6448ff7b690','f38c7e80-cf78-43d1-92db-ebbc10f0088d'));

SELECT fias_guid_new, fias_guid_old, obj_level, date_create
	FROM gar_fias.twin_addr_objects WHERE (obj_level = 0);
--
'75e6b874-cbbf-42bf-9014-a24c24060b25'|'9455353f-a2c6-43c3-8680-e356badf38e0'

SELECT * FROM gar_fias.as_addr_obj s WHERE(object_guid IN ('75e6b874-cbbf-42bf-9014-a24c24060b25','9455353f-a2c6-43c3-8680-e356badf38e0'))

	
SELECT fias_guid_new, fias_guid_old, obj_level, date_create FROM gar_fias.twin_addr_objects WHERE (obj_level = 2);


SELECT t.fias_guid_new FROM gar_fias.twin_addr_objects t 
                                       INNER JOIN gar_fias.as_houses h ON (t.fias_guid_new = h.object_guid)
                            WHERE ((h.end_date > current_date) AND (t.fias_guid_old = 'f38c7e80-cf78-43d1-92db-ebbc10f0088d'));
--------------------------------------------------------------------------------------------------------------------------------
--                            '23f6da51-e5a2-42a2-aa41-b6448ff7b690'|'f38c7e80-cf78-43d1-92db-ebbc10f0088d'|2|'2023-11-14'
    