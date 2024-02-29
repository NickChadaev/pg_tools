\encoding UTF8
begin;
set search_path to contacts, public;

\ir lock_rec.sql
\ir upd_rec.sql
\ir derive_period.sql

\ir clients.sql
\ir contact.sql
\ir services.sql
\ir tasks.sql

\ir load_contacts.sql

end;