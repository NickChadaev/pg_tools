CREATE OR REPLACE PROCEDURE contacts.load_contacts (
)
AS
$body$
DECLARE
  v_dt_st timestamp;
  v_dt_en timestamp;
BEGIN
  set session session authorization mb_owner;
  
  select dt_st, dt_en
    into v_dt_st, v_dt_en
    from contacts.derive_period('dicts');
  if v_dt_st is not null and v_dt_en is not null then
    raise notice 'loading dicts data...';
    commit;
    perform contacts.lock_rec('dicts', v_dt_en::date);
    set local application_name to 'load dicts: dicts';
    perform dict.load_dict();
    perform contacts.upd_rec('dicts', v_dt_en::date);
    commit;
    raise notice 'loaded dicts data';
  else
    raise notice 'skipped load dicts data';
    rollback;
  end if;
  
  select dt_st, dt_en
    into v_dt_st, v_dt_en
    from contacts.derive_period('client');
  if v_dt_st is not null and v_dt_en is not null then
    raise notice 'loading clients data...';
    commit;
    perform contacts.lock_rec('client', v_dt_en::date);
    set local application_name to 'load contacts: client';
    perform contacts.clients(v_dt_st, v_dt_en);
    perform contacts.upd_rec('client', v_dt_en::date);
    commit;
    raise notice 'loaded clients data';
  else
    raise notice 'skipped load clients data';
    rollback;
  end if;

  select dt_st, dt_en
    into v_dt_st, v_dt_en
    from contacts.derive_period('contact');
  if v_dt_st is not null and v_dt_en is not null then
    raise notice 'loading contacts data...';
    commit;
    perform contacts.lock_rec('contact', v_dt_en::date);
    set local application_name to 'load fact: contact';
    perform contacts.contact(v_dt_st, v_dt_en);
    perform contacts.upd_rec('contact', v_dt_en::date);
    commit;
    raise notice 'loaded contacts data';
  else
    raise notice 'skipped load contacts data';
    rollback;
  end if;

  select dt_st, dt_en
    into v_dt_st, v_dt_en
    from contacts.derive_period('service');
  if v_dt_st is not null and v_dt_en is not null then
    raise notice 'loading services data...';
    commit;
    perform contacts.lock_rec('service', v_dt_en::date);
    set local application_name to 'load fact: service';
    perform contacts.services(v_dt_st, v_dt_en);
    perform contacts.upd_rec('service', v_dt_en::date);
    commit;
    raise notice 'loaded services data';
  else
    raise notice 'skipped load services data';
    rollback;
  end if;

  select dt_st, dt_en
    into v_dt_st, v_dt_en
    from contacts.derive_period('task');
  if v_dt_st is not null and v_dt_en is not null then
    raise notice 'loading tasks data...';
    commit;
    perform contacts.lock_rec('task', v_dt_en::date);
    set local application_name to 'load fact: task';
    perform contacts.tasks(v_dt_st, v_dt_en);
    perform contacts.upd_rec('task', v_dt_en::date);
    commit;
    raise notice 'loaded tasks data';
  else
    raise notice 'skipped load tasks data';
    rollback;
  end if;
  
  select dt_st, dt_en
    into v_dt_st, v_dt_en
    from contacts.derive_period('camunda_activity');
  if v_dt_st is not null and v_dt_en is not null then
    raise notice 'loading camunda activities data...';
    commit;
    perform contacts.lock_rec('camunda activities', v_dt_en::date);
    set local application_name to 'load fact: camunda activities';
    perform camunda.activities(v_dt_st, v_dt_en);
    perform contacts.upd_rec('camunda activities', v_dt_en::date);
    commit;
    raise notice 'loaded camunda activities data';
  else
    raise notice 'skipped load camunda activities data';
    rollback;
  end if;
END;
$body$
LANGUAGE 'plpgsql'
SECURITY INVOKER;