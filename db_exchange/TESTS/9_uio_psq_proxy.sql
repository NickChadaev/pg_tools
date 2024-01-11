SELECT * FROM plproxy.get_cluster_partitions();
SELECT * FROM uio.service_config;
1 - host=192.168.56.222 dbname=ASK_GP_0_26 user=postgres password=
2 - host=192.168.56.224 dbname=ASK_GP_1x user=postgres password=
UPDATE uio.service_config SET service_dsn='host=192.168.56.222 dbname=ASK_GP_0_26 user=postgres password=' WHERE (service_id = 1);
UPDATE uio.service_config SET service_dsn='host=192.168.56.224 dbname=ASK_GP_1x user=postgres password=' WHERE (service_id = 2);