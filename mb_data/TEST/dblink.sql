-- Foreign Server: ccrm_pp

-- DROP SERVER IF EXISTS ccrm

CREATE SERVER ccrm
    TYPE 'dblink_fdw'
    FOREIGN DATA WRAPPER dblink_fdw
    OPTIONS (hostaddr '10.196.35.45', dbname 'ccrm_pp');

ALTER SERVER ccrm OWNER TO mb_owner_01;


-- User Mapping : mb_owner

-- DROP USER MAPPING IF EXISTS FOR mb_owner SERVER ccrm

CREATE USER MAPPING FOR mb_owner_01 SERVER ccrm
    OPTIONS ("user" 'crm_rep', password 'crm_rep');

-- Foreign Server: camunda

-- drop server if exists camunda

create server camunda
    type 'dblink_fdw'
    foreign data wrapper dblink_fdw
    options (dbname 'camunda');

alter server camunda owner to mb_owner;

-- user mapping : mb_owner

-- drop user mapping if exists for mb_owner server camunda

create user mapping for mb_owner server camunda
    options ("user" 'camunda_rep', password 'camunda_rep');
