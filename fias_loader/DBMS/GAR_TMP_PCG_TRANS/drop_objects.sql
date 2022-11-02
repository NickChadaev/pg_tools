--
--  2022-11-02
--
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_del_twin_0(text,bigint,bigint,bigint,varchar(250),uuid,boolean,date,text);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_del_twin_1(text,bigint,bigint,bigint,varchar(250),uuid,boolean,date,text);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.fp_adr_house_del_twin_2(text,bigint,bigint,bigint,varchar(250),uuid,boolean,date,text);
--
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_check_twins(text,text,bigint[][],boolean,date,text);
DROP PROCEDURE IF EXISTS gar_tmp_pcg_trans.p_adr_house_check_twins_1(text,text,boolean,date,text);
