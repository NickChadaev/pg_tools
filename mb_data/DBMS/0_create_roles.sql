/*==============================================================*/
/* DBMS name:      PostgreSQL 13.12                             */
/*==============================================================*/
 
CREATE ROLE mb_reader WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  CONNECTION LIMIT 2
  VALID UNTIL 'infinity';
 
CREATE ROLE mb_owner WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  CONNECTION LIMIT 2
  VALID UNTIL 'infinity';
  
 
