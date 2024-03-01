/*==============================================================*/
/* DBMS name:      PostgreSQL 13.12    2024-02-29               */
/*==============================================================*/

ALTER DATABASE mb_data_01 OWNER TO mb_owner_01;
ALTER DATABASE mb_data_02 OWNER TO mb_owner_02;
ALTER DATABASE mb_data_03 OWNER TO mb_owner_03;
ALTER DATABASE mb_data_04 OWNER TO mb_owner_04;
ALTER DATABASE mb_data_05 OWNER TO mb_owner_05;
--
--
GRANT ALL ON DATABASE mb_data_01 TO mb_owner_01, mb_reader_01;
REVOKE ALL ON DATABASE mb_data_01 FROM PUBLIC;
--
GRANT ALL ON DATABASE mb_data_02 TO mb_owner_02, mb_reader_02;
REVOKE ALL ON DATABASE mb_data_02 FROM PUBLIC;
--
GRANT ALL ON DATABASE mb_data_03 TO mb_owner_03, mb_reader_03;
REVOKE ALL ON DATABASE mb_data_03 FROM PUBLIC;
--
GRANT ALL ON DATABASE mb_data_04 TO mb_owner_04, mb_reader_04;
REVOKE ALL ON DATABASE mb_data_04 FROM PUBLIC;
--
GRANT ALL ON DATABASE mb_data_05 TO mb_owner_05, mb_reader_05;
REVOKE ALL ON DATABASE mb_data_05 FROM PUBLIC;
