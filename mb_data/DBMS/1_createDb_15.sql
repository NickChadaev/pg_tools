/*==============================================================*/
/* DBMS name:      PostgreSQL 13.12    2024-02-29               */
/*==============================================================*/

DROP DATABASE IF EXISTS mb_data_01;
CREATE DATABASE mb_data_01
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru_RU.utf8'
    LC_CTYPE = 'ru_RU.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE mb_data_01
    IS 'ООО "Газпром межрегионгаз Киров". Id=22 (metabase). 2024-02-29';

DROP DATABASE IF EXISTS mb_data_02; 
CREATE DATABASE mb_data_02
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru_RU.utf8'
    LC_CTYPE = 'ru_RU.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE mb_data_02
    IS 'Нижний Новгород ГРО ID=101 (metabase). 2024-02-29';

DROP DATABASE IF EXISTS mb_data_03;
CREATE DATABASE mb_data_03
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru_RU.utf8'
    LC_CTYPE = 'ru_RU.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE mb_data_03
    IS 'Нижний Новгород РГК ID=1 (metabase). 2024-02-29';

DROP DATABASE IF EXISTS mb_data_04; 
CREATE DATABASE mb_data_04
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru_RU.utf8'
    LC_CTYPE = 'ru_RU.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE mb_data_04
    IS 'Данные для metabase. РЕЗЕРВ. 2024-02-29';

DROP DATABASE IF EXISTS mb_data_05; 
CREATE DATABASE mb_data_05
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru_RU.utf8'
    LC_CTYPE = 'ru_RU.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE mb_data_05
    IS 'Данные для metabase. РЕЗЕРВ. 2024-02-29
 ';
              
