CREATE OR REPLACE FUNCTION contacts.lock_rec (
  p_zone text,
  p_dt_till date
)
RETURNS void AS
$body$
select
  from public.mb_loadinfo
 where nm_zone = p_zone
   and dt_till = p_dt_till
   for update
$body$
LANGUAGE 'sql'
VOLATILE
RETURNS NULL ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;

ALTER FUNCTION contacts.lock_rec (p_zone text, p_dt_till date)
  OWNER TO mb_owner;