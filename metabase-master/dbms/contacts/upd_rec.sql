CREATE OR REPLACE FUNCTION contacts.upd_rec (
  p_zone text,
  p_dt_till date
)
RETURNS void AS
$body$
update public.mb_loadinfo
   set dt_start = localtimestamp,
       dt_finish = clock_timestamp(),
       pr_finish = true
 where nm_zone = p_zone
   and dt_till = p_dt_till;
$body$
LANGUAGE 'sql'
VOLATILE
RETURNS NULL ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;