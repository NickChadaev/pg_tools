--
-- 2019-07-07 Nick
--
drop table t1 ;
drop table t2 ;
--
DROP SCHEMA test CASCADE;
CREATE SCHEMA test;

create table test.t1 (f1 serial,  f2 date, f3 text, f4 char (1)) PARTITION BY LIST (f4);
create table test.t2 (f11 int, f12 text, f13 char(1)) PARTITION BY LIST (f13); 
--
create table test.t1_1 PARTITION OF test.t1 FOR VALUES IN ('0');
create table test.t1_2 PARTITION OF test.t1 FOR VALUES IN ('1');;
--
create table test.t2 (f11 int, f12 text, f13 char(1)) PARTITION BY LIST (f13); 
--
create table test.t2_1 PARTITION OF test.t2 FOR VALUES IN ('A');
create table test.t2_2 PARTITION OF test.t2 FOR VALUES IN ('B');;

INSERT INTO test.t1 (f2, f3, f4) SELECT now()::date, (random ()*(generate_series(1, 1000000))) || '_TEST', '0'; 
INSERT INTO test.t1 (f2, f3, f4) SELECT now()::date, (random ()*(generate_series(1, 1000000))) || '_TEST', '1'; 
   --
INSERT INTO test.t2 (f11, f12, f13) SELECT generate_series(1, 1000000), (random ()*1000) || '_TEST_2', 'A';   
INSERT INTO test.t2 (f11, f12, f13) SELECT generate_series(1, 1000000), (random ()*1000) || '_TEST_2', 'B';    
--
EXPLAIN ANALYSE 
 SELECT * FROM test.t1 WHERE ( f1 = 780 ) AND ( f3 = '0');
-- 
ALTER TABLE test.t1 ADD CONSTRAINT pk_t1 PRIMARY KEY (f1); 
-- -----------------------------------------------------------------------
-- ERROR:  primary key constraints are not supported on partitioned tables
-- СТРОКА 1: ALTER TABLE test.t1 ADD CONSTRAINT pk_t1 PRIMARY KEY (f1);
--
ALTER TABLE test.t1_1 ADD CONSTRAINT pk_t1_1 PRIMARY KEY (f1); 
ALTER TABLE test.t1_2 ADD CONSTRAINT pk_t1_2 PRIMARY KEY (f1); 

EXPLAIN ANALYSE 
   SELECT * FROM test.t1 WHERE ( f1 = 780 ) AND ( f4 = '0');
--
EXPLAIN ANALYSE 
   SELECT * FROM test.t1 WHERE ( f1 = 1000780 ) AND ( f4 = '1');
-- ---------------------------------------------------------
-- "Append  (cost=0.42..8.45 rows=1 width=31) (actual time=0.015..0.017 rows=1 loops=1)"
-- "  ->  Index Scan using pk_t1_1 on t1_1  (cost=0.42..8.45 rows=1 width=31) (actual time=0.014..0.015 rows=1 loops=1)"
-- "        Index Cond: (f1 = 780)"
-- "        Filter: (f4 = '0'::bpchar)"
-- "Planning time: 0.313 ms"
-- "Execution time: 0.047 ms"

SELECT count(*) FROM test.t1;

SHOW enable_partition_pruning; ---   У меня 10.9 !!
CREATE INDEX ie_t1_1 ON test.t1_1 (f4); -- ERROR:  cannot create index on partitioned table "t1"
CREATE INDEX ie_t1_2 ON test.t1_2 (f4); -- ERROR:  cannot create index on partitioned table "t1"

EXPLAIN ANALYSE 
   SELECT * FROM test.t1 WHERE ( f1 = 1000780 ) AND ( f4 = '1');