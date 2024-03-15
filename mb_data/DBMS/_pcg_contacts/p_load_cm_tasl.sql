CREATE OR REPLACE FUNCTION contacts.tasks (
  p_dt_start timestamp,
  p_dt_end timestamp
)
RETURNS void AS
$body$
BEGIN

insert into contacts.cm_task (id_task, id_service, id_task_type, id_usr_create, id_log, id_task_parent,
                              id_usr_executor, id_reg_executor, dt_create, dt_plan_beg, dt_plan_end,
                              dt_fact_end, id_task_solution, kd_status, dt_status, id_step)                    
SELECT * 
  FROM dblink ('ccrm',
               format($$select ct.id_task,
						       ct.id_service,
                               ct.id_task_type,
                               ct.id_usr_create,
                               ct.id_log,
                               ct.id_task_parent,
                               ct.id_usr_executor,
                               ct.id_reg_executor,
                               ct.dt_create,
                               ct.dt_plan_beg,
                               ct.dt_plan_end,
                               ct.dt_fact_end,
                               ct.id_task_solution,
                               ct.kd_status,
                               sh.dt_change dt_status,
                               il.id_step
                          from contacts.cm_task ct
                        join contacts.cm_status_hist sh
                          on ct.id_task = sh.id_sys_entity
                         and sh.kd_sys_entity = 6
                         and sh.dt_change = (select max(dt_change)
                                               from contacts.cm_status_hist 
                                             where id_sys_entity = sh.id_sys_entity
                                               and kd_sys_entity = 6)
                        left join scenery.bpe_scenario_instance_log il
                          on ct.id_log = il.id_log
                        join contacts.cm_service cs 
                          on ct.id_service = cs.id_service
                         and not cs.pr_previous
                        where (ct.dt_change >= %1L
                          and  ct.dt_change < %2L)
                           or (ct.dt_create >= %3L
                          and  ct.dt_create < %4L)$$, p_dt_start, p_dt_end, p_dt_start, p_dt_end)) 
  AS cm_task (id_task bigint,
              id_service bigint,
              id_task_type int4,
              id_usr_create bigint,
              id_log bigint,
              id_task_parent bigint,
              id_usr_executor bigint,
              id_reg_executor int4,
              dt_create timestamp,
              dt_plan_beg timestamp,
              dt_plan_end timestamp,
              dt_fact_end timestamp,
              id_task_solution int4,
              kd_status int4,
              dt_status timestamp,
              id_step uuid)
where id_usr_create not in (select unnest(vl_param) id_user from dict.dct_spec_params where kd_param = 2)
  and exists (select from contacts.cm_service
              where id_service = cm_task.id_service)         
on conflict (id_task) do
update set id_log = excluded.id_log,
           id_task_parent = excluded.id_task_parent,
           id_usr_executor = excluded.id_usr_executor,
           id_reg_executor = excluded.id_reg_executor,
           dt_plan_beg = excluded.dt_plan_beg,
           dt_plan_end = excluded.dt_plan_end,
           dt_fact_end = excluded.dt_fact_end,
           id_task_solution = excluded.id_task_solution,
           kd_status = excluded.kd_status,
           id_task_type = excluded.id_task_type,
           dt_status = excluded.dt_status,
           id_step = excluded.id_step
where cm_task.id_log is distinct from excluded.id_log
   or cm_task.id_task_parent is distinct from excluded.id_task_parent
   or cm_task.id_usr_executor is distinct from excluded.id_usr_executor
   or cm_task.id_reg_executor is distinct from excluded.id_reg_executor
   or cm_task.dt_plan_beg <> excluded.dt_plan_beg
   or cm_task.dt_plan_end <> excluded.dt_plan_end
   or cm_task.dt_fact_end is distinct from excluded.dt_fact_end
   or cm_task.id_task_solution <> excluded.id_task_solution
   or cm_task.kd_status <> excluded.kd_status
   or cm_task.id_task_type is distinct from excluded.id_task_type
   or cm_task.dt_status is distinct from excluded.dt_status
   or cm_task.id_step is distinct from excluded.id_step;


