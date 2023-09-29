--
--   2023-08-04
--

INSERT INTO fiscalization.fsc_provider (id_fsc_provider, nm_fsc_provider, kd_fsc_provider, fsc_url, fsc_port, fsc_status) 
VALUES (1, 'АТОЛ', 'atol', 'https://testonline.atol.ru/possystem/v4', 'XXX', true)
      ,(2, 'ОРАНЖЕДАТА', 'orangedata', 'https://umka365.ru/kkm-trade/orangepossystem/api/v21', '443', true);

select * from fiscalization.fsc_provider;

