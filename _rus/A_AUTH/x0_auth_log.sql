CREATE TABLE auth.auth_log (
	id_log       public.id_t DEFAULT nextval('com.all_history_id_seq'::regclass) NOT NULL,
	user_name    public.t_str250 NOT NULL,
	host_name    public.t_str250,
	impact_date  public.t_timestamp DEFAULT (now())::timestamp(0) without time zone NOT NULL
);

COMMENT ON TABLE auth.auth_log IS 'Журнал изменений';

COMMENT ON COLUMN auth.auth_log.id_log      IS 'Идентификатор журнала';
COMMENT ON COLUMN auth.auth_log.user_name   IS 'Имя пользователя';
COMMENT ON COLUMN auth.auth_log.host_name   IS 'Имя хоста';
COMMENT ON COLUMN auth.auth_log.impact_date IS 'Дата воздействия';

--------------------------------------------------------------------------------

CREATE INDEX ie1_auth_log ON auth.auth_log USING btree (user_name);

--------------------------------------------------------------------------------

CREATE INDEX ie2_auth_log ON auth.auth_log USING btree (user_name, impact_date);

--------------------------------------------------------------------------------

ALTER TABLE auth.auth_log
	ADD CONSTRAINT pk_auth_log PRIMARY KEY (id_log);
