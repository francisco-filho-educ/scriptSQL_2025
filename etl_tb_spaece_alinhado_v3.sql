drop table if exists base_identificada.tb_spaece_alinhado;
create table base_identificada.tb_spaece_alinhado as 
-- 2019 --
select
2019 nr_ano,
lp.nu_sequencial,
lp.cd_escola,
lp.cd_turma::text,--
lp.cd_turma_censo::text,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_aplicacao cd_etapa_aplicacao_turma,
lp.dc_etapa_aplicacao dc_etapa_aplicacao_turma,
' - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno,
lp.cd_aluno_inep,
lp.cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2019_ef_lp lp
left join spaece.tb_spaece_2019_ef_mt mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2019 nr_ano,
lp.nu_sequencial,
lp.cd_escola,
lp.cd_turma::text,--
lp.cd_turma_instituicao::text cd_tuma_censo,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa_aplicacao cd_etapa_aplicacao_turma,
lp.dc_etapa_aplicacao dc_etapa_aplicacao_turma,
' - ENSINO MEDIO' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno,
lp.cd_aluno_inep,
lp.cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2019_em_lp lp
left join spaece.tb_spaece_2019_em_mt mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union -- 2018 --
select
2018 nr_ano,
lp.nu_sequencial,
lp.cd_escola,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma,
lp.dc_etapa_aplicacao_turma,
' - ENSINO MEDIO' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno,
lp.cd_aluno_inep,
lp.cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2018_lp_em lp
left join spaece.tb_spaece_2018_mt_em mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2018 nr_ano,
lp.nu_sequencial,
lp.cd_escola,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma,
lp.dc_etapa_aplicacao_turma,
' - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno,
lp.cd_aluno_inep,
lp.cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2018_lp_ef lp
left join spaece.tb_spaece_2018_mt_ef mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union ------- 2017 ---------------
SELECT 
2017 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
' - ENSINO MEDIO' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno_institucional::text cd_aluno_inep,
lp.cd_aluno_institucional::text,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2017_lp_em lp
left join spaece.tb_spaece_2017_mt_em mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2017 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
' - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno_institucional::text cd_aluno_inep,
lp.cd_aluno_institucional::text,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
case when lp.vl_perc_acertos='' then null else replace(lp.vl_perc_acertos, ',','.')::numeric end vl_perc_acertos_lp,
case when lp.vl_proficiencia = '' then null else replace( lp.vl_proficiencia,',','.') end::numeric prof_lp,
case when lp.vl_proficiencia_erro = '' then null else replace( lp.vl_proficiencia_erro,',','.') end::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
case when mt.vl_perc_acertos='' then null else replace(mt.vl_perc_acertos, ',','.')::numeric end vl_perc_acertos_mt,
case when mt.vl_proficiencia = '' then null else replace( mt.vl_proficiencia,',','.') end::numeric prof_mt,
case when mt.vl_proficiencia_erro = '' then null else replace( mt.vl_proficiencia_erro ,',','.') end::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2017_profic_ef_lp lp
left join spaece.tb_spaece_2017_profic_ef_mt mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union ----------------2016 ---------------------
SELECT 
2016 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
'5 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno_institucional::text cd_aluno_inep,
lp.cd_aluno_institucional::text,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
case when lp.vl_perc_acertos='' then null else replace(lp.vl_perc_acertos, ',','.')::numeric end vl_perc_acertos_lp,
case when lp.vl_proficiencia = '' then null else replace( lp.vl_proficiencia,',','.') end::numeric prof_lp,
case when lp.vl_proficiencia_erro = '' then null else replace( lp.vl_proficiencia,',','.') end::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
case when mt.vl_perc_acertos='' then null else replace(mt.vl_perc_acertos, ',','.')::numeric end vl_perc_acertos_mt,
case when mt.vl_proficiencia = '' then null else replace( mt.vl_proficiencia,',','.') end::numeric prof_mt,
case when mt.vl_proficiencia_erro = '' then null else replace( mt.vl_proficiencia,',','.') end::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2016_lp_5ef lp
left join spaece.tb_spaece_2016_mt_5ef mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2016 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
'9 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno_institucional::text cd_aluno_inep,
lp.cd_aluno_institucional::text,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2016_lp_9ef lp
left join spaece.tb_spaece_2016_mt_9ef mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2016 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
' - ENSINO MEDIO' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno_institucional::text cd_aluno_inep,
lp.cd_aluno_institucional::text,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2016_lp_em lp
left join spaece.tb_spaece_2016_mt_em mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2016 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
'EJA - ENSINO MEDIO' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno_institucional::text cd_aluno_inep,
lp.cd_aluno_institucional::text,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2016_lp_eja lp
left join spaece.tb_spaece_2016_mt_eja mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2016 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
'2 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno_institucional::text cd_aluno_inep,
lp.cd_aluno_institucional::text,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
NULL nu_pontos_mt,
null  vl_perc_acertos_mt,
NULL prof_mt,
NULL prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2016_lp_2ef lp
union ---------- 2015 ----------------------------
SELECT 
2015 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
'5 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno_institucional::text cd_aluno_inep,
lp.cd_aluno_institucional::text,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2015_lp_5f lp
left join spaece.tb_spaece_2015_mt_5f mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2015 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
'9 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno_institucional::text cd_aluno_inep,
lp.cd_aluno_institucional::text,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2015_lp_9f lp
left join spaece.tb_spaece_2015_mt_9f mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2015 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
' - ENSINO MEDIO' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno_institucional::text cd_aluno_inep,
lp.cd_aluno_institucional::text,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2015_lp_em lp
left join spaece.tb_spaece_2015_mt_em mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2015 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
'EJA - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno_institucional::text cd_aluno_inep,
lp.cd_aluno_institucional::text,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2015_lp_eja lp
left join spaece.tb_spaece_2015_mt_eja mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union 
SELECT 
2015 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
'2 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno_institucional::text cd_aluno_inep,
lp.cd_aluno_institucional::text,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
NULL nu_pontos_mt,
null  vl_perc_acertos_mt,
NULL prof_mt,
NULL prof_mt_erro,
lp.fl_avaliado::int
--select distinct  dc_etapa_aplicacao_turma
FROM spaece.tb_spaece_2015_alfa lp
union ----------- 2014 --------------------------------
SELECT 
2014 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
' - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno::text cd_aluno_inep,
lp.cd_aluno::text cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2014_pt_ef lp
left join spaece.tb_spaece_2014_mt_ef mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2014 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa_aplicacao_turma::text,
lp.dc_etapa_aplicacao_turma,
' - ENSINO MEDIO' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno::text cd_aluno_inep,
lp.cd_aluno::text cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
replace(lp.vl_perc_acertos, ',','.')::numeric vl_perc_acertos_lp,
replace(lp.vl_proficiencia,',','.')::numeric prof_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt,
replace(mt.vl_proficiencia,',','.')::numeric prof_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2014_pt_em lp
left join spaece.tb_spaece_2014_mt_em mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union ---------------------- 2013 --------------------------------
SELECT 
2013 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_divulgacao_turma::text cd_etapa_aplicacao_turma,
lp.dc_etapa_divulgacao_turma dc_etapa_aplicacao_turma,
'5 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
NULL cd_aluno_inep,
NULL cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
(replace(lp.vl_d_pct_aln_13,',','.')::numeric*100) vl_perc_acertos_lp,
replace(lp.vl_prf_aln_13,',','.')::numeric prof_lp,
replace(lp.vl_erro_prf_aln_13,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
(replace(mt.vl_d_pct_aln_13,',','.')::numeric*100) vl_perc_acertos_mt,
replace(mt.vl_prf_aln_13,',','.')::numeric prof_mt,
replace(mt.vl_erro_prf_aln_13,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2013_lp_5f lp
left join spaece.tb_spaece_2013_mt_5f mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2013 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_divulgacao_turma::text cd_etapa_aplicacao_turma,
lp.dc_etapa_divulgacao_turma dc_etapa_aplicacao_turma,
'9 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
NULL cd_aluno_inep,
NULL cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
(replace(lp.vl_d_pct_aln_13,',','.')::numeric*100) vl_perc_acertos_lp,
replace(lp.vl_prf_aln_13,',','.')::numeric prof_lp,
replace(lp.vl_erro_prf_aln_13,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
(replace(mt.vl_d_pct_aln_13,',','.')::numeric*100) vl_perc_acertos_mt,
replace(mt.vl_prf_aln_13,',','.')::numeric prof_mt,
replace(mt.vl_erro_prf_aln_13,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2013_lp_9f lp
left join spaece.tb_spaece_2013_mt_9f mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2013 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_divulgacao_turma::text cd_etapa_aplicacao_turma,
lp.dc_etapa_divulgacao_turma dc_etapa_aplicacao_turma,
'EJA - ENSINO MEDIO' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
NULL cd_aluno_inep,
NULL cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
(replace(lp.vl_d_pct_aln_13,',','.')::numeric*100) vl_perc_acertos_lp,
replace(lp.vl_prf_aln_13,',','.')::numeric prof_lp,
replace(lp.vl_erro_prf_aln_13,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
(replace(mt.vl_d_pct_aln_13,',','.')::numeric*100) vl_perc_acertos_mt,
replace(mt.vl_prf_aln_13,',','.')::numeric prof_mt,
replace(mt.vl_erro_prf_aln_13,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
--select distinct LP.dc_etapa_divulgacao_turma
FROM spaece.tb_spaece_2013_lp_eja lp
left join spaece.tb_spaece_2013_mt_eja mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2013 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa_divulgacao_turma::text cd_etapa_aplicacao_turma,
lp.dc_etapa_divulgacao_turma dc_etapa_aplicacao_turma,
' - ENSINO MEDIO' ds_etapa_serie_tabela,
lp.cd_aluno::text,
NULL cd_aluno_inep,
NULL cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
(replace(lp.vl_d_pct_aln_13,',','.')::numeric*100) vl_perc_acertos_lp,
replace(lp.vl_prf_aln_13,',','.')::numeric prof_lp,
replace(lp.vl_erro_prf_aln_13,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
(replace(mt.vl_d_pct_aln_13,',','.')::numeric*100) vl_perc_acertos_mt,
replace(mt.vl_prf_aln_13,',','.')::numeric prof_mt,
replace(mt.vl_erro_prf_aln_13,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2013_lp_em lp
left join spaece.tb_spaece_2013_mt_em mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union 
SELECT 
2013 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_divulgacao_turma::text,
lp.dc_etapa_divulgacao_turma,
'2 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
NULL cd_aluno_inep,
NULL cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
(replace(lp.vl_d_pct_aln_13,',','.')::numeric*100) vl_perc_acertos_lp,
replace(lp.vl_prf_aln_13,',','.')::numeric prof_lp,
replace(lp.vl_erro_prf_aln_13,',','.')::numeric prof_lp_erro,
NULL nu_pontos_mt,
null vl_perc_acertos_mt,
NULL prof_mt,
NULL prof_mt_erro,
lp.fl_avaliado::int
--select distinct  dc_etapa_divulgacao_turma
FROM spaece.tb_spaece_2013_lp_2f lp
union --------------------2012 ----------------------------
SELECT 
2012 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_divulgacao_turma::text cd_etapa_aplicacao_turma,
lp.dc_etapa_divulgacao_turma dc_etapa_aplicacao_turma,
' - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno::text cd_aluno_inep,
lp.cd_aluno::text cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
(replace(lp.vl_d_pct_aln_12,',','.')::numeric*100) vl_perc_acertos_lp,
replace(lp.vl_prf_aln_12,',','.')::numeric proef_lp,
replace(lp.vl_erro_prf_aln_12,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
(replace(mt.vl_d_pct_aln_12,',','.')::numeric*100) vl_perc_acertos_mt,
replace(mt.vl_prf_aln_12,',','.')::numeric prof_mt,
replace(mt.vl_erro_prf_aln_12,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2012_lp_ef lp
left join spaece.tb_spaece_2012_mt_ef mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2012 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa_divulgacao_turma::text cd_etapa_aplicacao_turma,
lp.dc_etapa_divulgacao_turma dc_etapa_aplicacao_turma,
' - ENSINO MEDIO' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno::text cd_aluno_inep,
lp.cd_aluno::text cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
(replace(lp.vl_d_pct_aln_12,',','.')::numeric*100) vl_perc_acertos_lp,
replace(lp.vl_prf_aln_12,',','.')::numeric proef_lp,
replace(lp.vl_erro_prf_aln_12,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
(replace(mt.vl_d_pct_aln_12,',','.')::numeric*100) vl_perc_acertos_mt,
replace(mt.vl_prf_aln_12,',','.')::numeric prof_mt,
replace(mt.vl_erro_prf_aln_12,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2012_lp_em lp
left join spaece.tb_spaece_2012_mt_em mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union 
SELECT 
2012 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno_turma::int cd_turno,
lp.dc_turno_turma dc_turma,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_divulgacao_turma::text cd_etapa_aplicacao_turma,
lp.dc_etapa_divulgacao_turma dc_etapa_aplicacao_turma,
'2 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno::text cd_aluno_inep,
lp.cd_aluno::text cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
(replace(lp.vl_d_pct_aln_12,',','.')::numeric*100) vl_perc_acertos_lp,
replace(lp.vl_prf_aln_12,',','.')::numeric proef_lp,
replace(lp.vl_erro_prf_aln_12,',','.')::numeric prof_lp_erro,
NULL nu_pontos_mt,
null  vl_perc_acertos_mt,
NULL prof_mt,
NULL prof_mt_erro,
lp.fl_avaliado::int
--select distinct  dc_etapa_divulgacao_turma
FROM spaece.tb_spaece_2012_lp_alfa lp
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union---------------------2011 -----------------------------
SELECT 
2011 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa::text cd_etapa_aplicacao_turma,
lp.dc_etapa dc_etapa_aplicacao_turma,
' - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno::text cd_aluno_inep,
lp.cd_aluno::text cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
(replace(lp.vl_d_pct_aln_11,',','.')::numeric*100) vl_perc_acertos_lp,
replace(lp.vl_prf_aln_11,',','.')::numeric proef_lp,
replace(lp.vl_erro_prf_aln_11,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
(replace(mt.vl_d_pct_aln_11,',','.')::numeric*100) vl_perc_acertos_mt,
replace(mt.vl_prf_aln_11,',','.')::numeric prof_mt,
replace(mt.vl_erro_prf_aln_11,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
--select distinct dc_etapa
FROM spaece.tb_spaece_2011_lp_ef lp
left join spaece.tb_spaece_2011_mt_ef mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2011 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa::text cd_etapa_aplicacao_turma,
lp.dc_etapa dc_etapa_aplicacao_turma,
' - ENSINO MEDIO' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
lp.cd_aluno::text cd_aluno_inep,
lp.cd_aluno::text cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
(replace(lp.vl_d_pct_aln_11,',','.')::numeric*100) vl_perc_acertos_lp,
replace(lp.vl_prf_aln_11,',','.')::numeric proef_lp,
replace(lp.vl_erro_prf_aln_11,',','.')::numeric prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
(replace(mt.vl_d_pct_aln_11,',','.')::numeric*100) vl_perc_acertos_mt,
replace(mt.vl_prf_aln_11,',','.')::numeric prof_mt,
replace(mt.vl_erro_prf_aln_11,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2011_lp_em lp
left join spaece.tb_spaece_2011_mt_em mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union ------------- 2010 -----------------------------
SELECT 
2010 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
case when lp.cd_etapa::int > 9 then 3 else 2 end cd_etapa_ceipe,
lp.cd_etapa::text cd_etapa_aplicacao_turma,
lp.dc_etapa dc_etapa_aplicacao_turma,
case when lp.cd_etapa::int > 9 then ' - ENSINO MEDIO' else ' - ENSINO FUNDAMENTAL' end ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno::text,
null cd_aluno_inep,
null cd_aluno_institucional,
lp.nm_aluno,
null nu_pontos_lp,
(replace(lp.vl_d_pct_aln_10,',','.')::numeric*100) vl_perc_acertos_lp,
replace(lp.vl_prf_aln_10,',','.')::numeric prof_lp,
replace(lp.vl_erro_prf_aln_10,',','.')::numeric prof_lp_erro,
null nu_pontos_mt,
(replace(mt.vl_d_pct_aln_10,',','.')::numeric*100) vl_perc_acertos_mt,
replace(mt.vl_prf_aln_10,',','.')::numeric prof_mt,
replace(mt.vl_erro_prf_aln_10,',','.')::numeric prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2010_lp_em_ef lp
left join spaece.tb_spaece_2010_mt_em_ef mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union ------------2009 -------------------------------------
SELECT 
2009 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
case when lp.dc_etapa ilike '% EM%' then 3 else 2 end cd_etapa_ceipe,
lp.cd_etapa::text cd_etapa_aplicacao_turma,
lp.dc_etapa dc_etapa_aplicacao_turma,
case when lp.dc_etapa ilike '% EM%' then ' - ENSINO MEDIO' else ' - ENSINO FUNDAMENTAL' end ds_etapa_serie_tabela,
'' cd_aluno,
'' cd_aluno_inep,
'' cd_aluno_institucional,
lp.nm_aluno,
null nu_pontos_lp,
null vl_perc_acertos_lp,
replace(lp.vl_prf_aln_09,',','.')::numeric prof_lp,
null prof_lp_erro ,
null nu_pontos_mt,
null vl_perc_acertos_mt,
replace(mt.vl_prf_aln_09,',','.')::numeric prof_mt,
null prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2009_lp_ef_em lp
left join spaece.tb_spaece_2009_mt_ef_em mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union 
SELECT 
2009 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
case when lp.dc_etapa ilike '% EM%' then 2 else 2 end cd_etapa_ceipe,
lp.cd_etapa::text cd_etapa_aplicacao_turma,
lp.dc_etapa dc_etapa_aplicacao_turma,
'2 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela,
'' cd_aluno,
'' cd_aluno_inep,
'' cd_aluno_institucional,
lp.nm_aluno,
null nu_pontos_lp,
null vl_perc_acertos_lp,
replace(lp.vl_prf_aln_09,',','.')::numeric prof_lp,
null prof_lp_erro ,
null nu_pontos_mt,
null vl_perc_acertos_mt,
null prof_mt,
null prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2009_lp_alfa_ef lp
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union ------------------ 2008 --------------------------
SELECT 
2008 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa::text cd_etapa_aplicacao_turma,
'1 Serie Ensino Medio' dc_etapa_aplicacao_turma,
'1 SERIE - ENSINO MEDIO' ds_etapa_serie_tabela,
'' cd_aluno,
'' cd_aluno_inep,
'' cd_aluno_institucional,
lp.nm_aluno,
null nu_pontos_lp,
null vl_perc_acertos_lp,
replace(lp.vl_prf_aln_08::text,',','.')::numeric prof_lp,
null prof_lp_erro,
null nu_pontos_mt,
null vl_perc_acertos_mt,
replace(mt.vl_prf_aln_08::text,',','.')::numeric prof_mt,
null prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2008_1_serie_em_lp lp
left join  spaece.tb_spaece_2008_1_serie_em_mt mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2008 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa::text cd_etapa_aplicacao_turma,
'2 Serie Ensino Medio' dc_etapa_aplicacao_turma,
'2 SERIE - ENSINO MEDIO' ds_etapa_serie_tabela,
'' cd_aluno,
'' cd_aluno_inep,
'' cd_aluno_institucional,
lp.nm_aluno,
null nu_pontos_lp,
null vl_perc_acertos_lp,
replace(lp.vl_prf_aln_08::text,',','.')::numeric prof_lp,
null prof_lp_erro,
null nu_pontos_mt,
null vl_perc_acertos_mt,
replace(mt.vl_prf_aln_08::text,',','.')::numeric prof_mt,
null prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2008_2_serie_em_lp lp
left join  spaece.tb_spaece_2008_2_serie_em_mt mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2008 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa::text cd_etapa_aplicacao_turma,
'3 Serie Ensino Medio' dc_etapa_aplicacao_turma,
'3 SERIE - ENSINO MEDIO' ds_etapa_serie_tabela,
'' cd_aluno,
'' cd_aluno_inep,
'' cd_aluno_institucional,
lp.nm_aluno,
null nu_pontos_lp,
null vl_perc_acertos_lp,
replace(lp.vl_prf_aln_08::text,',','.')::numeric prof_lp,
null prof_lp_erro,
null nu_pontos_mt,
null vl_perc_acertos_mt,
replace(mt.vl_prf_aln_08::text,',','.')::numeric prof_mt,
null prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2008_3_serie_em_lp lp
left join  spaece.tb_spaece_2008_3_serie_em_mt mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2008 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa::text cd_etapa_aplicacao_turma,
'5 Ano Ensino Fundamental' dc_etapa_aplicacao_turma,
'5 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela,
'' cd_aluno,
'' cd_aluno_inep,
'' cd_aluno_institucional,
lp.nm_aluno,
null nu_pontos_lp,
null vl_perc_acertos_lp,
replace(lp.vl_prf_aln_08::text,',','.')::numeric prof_lp,
null prof_lp_erro,
null nu_pontos_mt,
null vl_perc_acertos_mt,
replace(mt.vl_prf_aln_08::text,',','.')::numeric prof_mt,
null prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2008_5_ano_ef_lp lp
left join  spaece.tb_spaece_2008_5_ano_ef_mt mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2008 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa::text cd_etapa_aplicacao_turma,
'9 Ano Ensino Fundamental' dc_etapa_aplicacao_turma,
'9 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela,
'' cd_aluno,
'' cd_aluno_inep,
'' cd_aluno_institucional,
lp.nm_aluno,
null nu_pontos_lp,
null vl_perc_acertos_lp,
replace(lp.vl_prf_aln_08::text,',','.')::numeric prof_lp,
null prof_lp_erro,
null nu_pontos_mt,
null vl_perc_acertos_mt,
replace(mt.vl_prf_aln_08::text,',','.')::numeric prof_mt,
null prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2008_9_ano_ef_lp lp
left join  spaece.tb_spaece_2008_9_ano_ef_mt mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union
SELECT 
2008 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa::text cd_etapa_aplicacao_turma,
'2 Ano Ensino Fundamental' dc_etapa_aplicacao_turma,
'2 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela,
'' cd_aluno,
'' cd_aluno_inep,
'' cd_aluno_institucional,
lp.nm_aluno,
null nu_pontos_lp,
null vl_perc_acertos_lp,
replace(lp.vl_prf_aln_08::text,',','.')::numeric prof_lp,
null prof_lp_erro,
null nu_pontos_mt,
null vl_perc_acertos_mt,
null prof_mt,
null prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2008_alfa_ef_lp lp
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union ------------ 2007 -----------------
SELECT 
2007 nr_ano,
lp.nu_sequencial::text,
lp.cd_escola::text,
lp.cd_turma::text,--
lp.cd_turma::text cd_turma_censo,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
2 cd_etapa_ceipe,
'2' cd_etapa_aplicacao_turma,
'2 Ano Ensino Fundamental' dc_etapa_aplicacao_turma,
'2 ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela,
'' cd_aluno,
'' cd_aluno_inep,
'' cd_aluno_institucional,
lp.nm_aluno,
null nu_pontos_lp,
null vl_perc_acertos_lp,
replace(lp.vl_prf_aln_07::text,',','.')::numeric proef_lp,
null prof_erro_lp,
null nu_pontos_mt,
null vl_perc_acertos_mt,
null proef_mt,
null prof_erro_mt,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2007_lp_alfa lp
where lp.nm_aluno is not null and lp.nu_sequencial is not null 

/*
select 
cd_etapa_ceipe,
cd_etapa_aplicacao_turma,
tsa.dc_etapa_aplicacao_turma,
ds_etapa_serie_tabela
from base_identificada.tb_spaece_alinhado tsa 
group by 1,2,3,4
*/

----------- indentificacao do aluno----------
/*
select 
a.ci_aluno::text cd_aluno_sige,
a.cd_inep_aluno::text,
a.nm_aluno nm_aluno_sige,
to_char(a.dt_nascimento,'DD/MM/YYYY') dt_nascimento,
a.nm_mae,
a.nr_identificacao_social nis,
a.nr_cpf
from sige_2019.academico_tb_aluno a
where date_part('YEAR',a.dt_nascimento) between 1991 and 1993*/