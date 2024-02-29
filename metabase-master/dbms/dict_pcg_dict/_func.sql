\encoding UTF8
begin;
set search_path to dict_pcg_dict, public;
--drop schema if exists dict_pcg_dict;
create schema if not exists dict_pcg_dict authorization mb_owner;
grant all on schema dict_pcg_dict to mb_owner;
grant usage on schema dict_pcg_dict to mb_reader;

\ir fnc_get_as_otd.sql

end;