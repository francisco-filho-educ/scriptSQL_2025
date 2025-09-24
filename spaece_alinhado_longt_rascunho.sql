create table tmp.df as (
select 
lp.nu_sequencial::text,
2022 nr_ano_aplicacao,
lp.cd_escola,
lp.cd_turma_instituicao::text,
lp.cd_etapa_publicacao,
9 cd_ano_serie,
lp.dc_turno,
lp.cd_aluno_inep,
lp.cd_aluno_institucional,
lp.nm_aluno,
lp.dt_nascimento,
replace(lp.nm_aluno,' ','') key_nome,
public.fonetico_nome_completo(lp.nm_aluno) key_nome_sx,
------------------------ lp
lp.vl_proficiencia vl_proficiencia_lp,
lp.vl_proficiencia_erro vl_proficiencia_erro_lp,
lp.vl_perc_acertos vl_perc_acertos_lp,
--lp.dc_padrao dc_padrao_lp,
-------------------------mt
mt.vl_proficiencia vl_proficiencia_mt,
mt.vl_proficiencia_erro vl_proficiencia_erro_mt,
mt.vl_perc_acertos vl_perc_acertos_mt
--mt.dc_padrao dc_padrao_mt
--select *
from spaece.tb_spaece_2022_lp_ef_5_9ano  lp
join spaece.tb_spaece_2022_mt_ef_5_9ano  mt using(nu_sequencial)
where 
lp.fl_avaliado = 1 and lp.cd_etapa_avaliada = 41
union 
select 
lp.nu_sequencial::text,
2018 nr_ano_aplicacao,
lp.cd_escola::numeric,
lp.cd_turma::text cd_turma_instituicao,
18 cd_etapa_publicacao,
5 cd_ano_serie,
lp.dc_turno_turma dc_turno,
lp.cd_aluno_inep::numeric,
lp.cd_aluno_institucional::numeric,
lp.nm_aluno,
'' dt_nascimento,
replace(lp.nm_aluno,' ','') key_nome,
public.fonetico_nome_completo(lp.nm_aluno) key_nome_sx,
------------------------ lp
replace(lp.vl_proficiencia,',','.')::numeric vl_proficiencia_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric vl_proficiencia_erro_lp,
replace(lp.vl_perc_acertos,',','.')::numeric vl_perc_acertos_lp,
--lp.dc_padrao dc_padrao_lp,
-------------------------mt
replace(mt.vl_proficiencia,',','.')::numeric vl_proficiencia_mt,
replace(mt.vl_proficiencia_erro,',','.')::numeric vl_proficiencia_erro_mt,
replace(mt.vl_perc_acertos,',','.')::numeric vl_perc_acertos_mt
--mt.dc_padrao dc_padrao_mt
--select *
from spaece.tb_spaece_2018_lp_ef lp
join spaece.tb_spaece_2018_mt_ef  mt using(nu_sequencial)
where 
lp.fl_avaliado::numeric = 1 
and lp.cd_etapa::int = 5
union 
select 
lp.nu_sequencial::text,
2015 nr_ano_aplicacao,
lp.cd_escola::numeric,
lp.cd_turma::text cd_turma_instituicao,
15 cd_etapa_publicacao,
2 cd_ano_serie,
lp.dc_turno_turma dc_turno,
cd_aluno_institucional::numeric cd_aluno_inep,
null cd_aluno_institucional,
lp.nm_aluno,
'' dt_nascimento,
replace(lp.nm_aluno,' ','') key_nome,
public.fonetico_nome_completo(lp.nm_aluno) key_nome_sx,
------------------------ lp
replace(lp.vl_proficiencia,',','.')::numeric vl_proficiencia_lp,
replace(lp.vl_proficiencia_erro,',','.')::numeric vl_proficiencia_erro_lp,
replace(lp.vl_perc_acertos,',','.')::numeric vl_perc_acertos_lp,
--lp.dc_padrao dc_padrao_lp,
-------------------------mt
NULL vl_proficiencia_mt,
NULL vl_proficiencia_erro_mt,
NULL vl_perc_acertos_mt
--mt.dc_padrao dc_padrao_mt
--select *
from spaece.tb_spaece_2015_alfa lp
where 
lp.fl_avaliado::numeric = 1 
)

select 
*,
proficiencias_padrao(vl_proficiencia_lp, cd_ano_serie, 1) ds_padrao_lp,
proficiencias_padrao(vl_proficiencia_mt, cd_ano_serie, 2) ds_padrao_mt
from tmp.df df 