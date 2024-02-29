CREATE OR REPLACE FUNCTION contacts.derive_period (
  p_zone text,
  out dt_st date,
  out dt_en date
)
RETURNS record AS
$body$
with ins as
 (insert into public.mb_loadinfo (nm_zone)
  values (p_zone)
  on conflict (nm_zone, dt_till) do nothing
  returning dt_till),
lockrec as materialized
 (select dt_till
    from public.mb_loadinfo
   where not exists (table ins)
     and nm_zone = p_zone
     and dt_till = date_trunc('day', localtimestamp)
     and dt_start < localtimestamp - interval 'PT5M'
     and not pr_finish
     for update skip locked),
upd as
 (update public.mb_loadinfo
     set dt_start = localtimestamp
   where nm_zone = p_zone
     and dt_till = (table lockrec)
  returning dt_till),
lastrec as
 (select max(dt_till) dt_from
    from public.mb_loadinfo
   where nm_zone = p_zone
   	 and dt_till < date_trunc('day', localtimestamp)
   	 and pr_finish)
select dt_from, dt_till
  from (table ins
        union all
        table upd) u
 cross join lastrec;
$body$
LANGUAGE 'sql'
VOLATILE
RETURNS NULL ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;