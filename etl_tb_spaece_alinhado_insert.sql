delete  from base_identificada.tb_spaece_alinhado where nr_ano = 2022;
insert into base_identificada.tb_spaece_alinhado 
select
2022 nr_ano,
lp.nu_sequencial,
lp.cd_escola,
lp.cd_turma::text,--
lp.cd_turma_instituicao::text,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
3 cd_etapa_ceipe,
lp.cd_etapa_aplicacao::int cd_etapa_aplicacao_turma,
lp.dc_etapa_aplicacao dc_etapa_aplicacao_turma,
lp.cd_etapa_avaliada::int cd_etapa_avaliada_turma ,
lp.dc_etapa_avaliada dc_etapa_avaliada_turma,
' - ENSINO MÉDIO' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno,
lp.cd_aluno_inep,
lp.cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
lp.vl_perc_acertos vl_perc_acertos_lp,
lp.vl_proficiencia prof_lp,
lp.vl_proficiencia_erro prof_lp_erro,
mt.nu_pontos nu_pontos_mt,
mt.vl_perc_acertos vl_perc_acertos_mt,
mt.vl_proficiencia prof_mt,
mt.vl_proficiencia_erro prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2022_lp_em lp
left join spaece.tb_spaece_2022_mt_em mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null ;

-- BASE FUNDAMENTAL 
insert into base_identificada.tb_spaece_alinhado 
select
2022 nr_ano,
lp.nu_sequencial,
lp.cd_escola,
lp.cd_turma::text,--
lp.cd_turma_instituicao::text,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_aplicacao::int cd_etapa_aplicacao_turma,
lp.dc_etapa_aplicacao dc_etapa_aplicacao_turma,
lp.cd_etapa_avaliada::int cd_etapa_avaliada_turma ,
lp.dc_etapa_avaliada dc_etapa_avaliada_turma,
'2º ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno,
lp.cd_aluno_inep,
lp.cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
lp.vl_perc_acertos vl_perc_acertos_lp,
lp.vl_proficiencia prof_lp,
lp.vl_proficiencia_erro prof_lp_erro,
null nu_pontos_mt,
null vl_perc_acertos_mt,
null prof_mt,
NULL prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2022_lp_ef_2ano lp
where lp.nm_aluno is not null and lp.nu_sequencial is not null 
union 
select
2022 nr_ano,
lp.nu_sequencial,
lp.cd_escola,
lp.cd_turma::text,--
lp.cd_turma_instituicao::text,--
lp.cd_turno::int,
lp.dc_turno,
lp.nm_turma,--
2 cd_etapa_ceipe,
lp.cd_etapa_aplicacao::int cd_etapa_aplicacao_turma,
lp.dc_etapa_aplicacao dc_etapa_aplicacao_turma,
lp.cd_etapa_avaliada::int cd_etapa_avaliada_turma ,
lp.dc_etapa_avaliada dc_etapa_avaliada_turma,
'5º e 9º ANO - ENSINO FUNDAMENTAL' ds_etapa_serie_tabela, -- identificacao da serie/etapa atraves do nome original da tabela
lp.cd_aluno,
lp.cd_aluno_inep,
lp.cd_aluno_institucional,
lp.nm_aluno,
lp.nu_pontos::numeric nu_pontos_lp,
lp.vl_perc_acertos vl_perc_acertos_lp,
lp.vl_proficiencia prof_lp,
lp.vl_proficiencia_erro prof_lp_erro,
mt.nu_pontos::numeric nu_pontos_mt,
mt.vl_perc_acertos vl_perc_acertos_mt,
mt.vl_proficiencia prof_mt,
mt.vl_proficiencia_erro prof_mt_erro,
lp.fl_avaliado::int
FROM spaece.tb_spaece_2022_lp_ef_5_9ano lp
join spaece.tb_spaece_2022_mt_ef_5_9ano mt using(nu_sequencial)
where lp.nm_aluno is not null and lp.nu_sequencial is not null ;