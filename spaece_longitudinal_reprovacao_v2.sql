with codigo as ( 
select 
distinct cd_aluno_inep
from base_identificada.tb_base_spaece_censo tbsc 
where cd_ano_serie_ceipe = 12
and nr_ano =2019
and cd_aluno_inep is not null  --and cd_aluno_inep = 117987114196
--and tbsc.cd_escola::int = 23323434
--and exists (select 1 from base_identificada.tb_base_spaece_censo tbs where cd_ano_serie_ceipe = 2 and fl_avaliado = 1 and tbs.cd_aluno_inep = tbsc.cd_aluno_inep and tbs.fl_avaliado = 1)
and exists (select 1 from base_identificada.tb_base_spaece_censo tbs where cd_ano_serie_ceipe = 5 and fl_avaliado = 1 and tbs.cd_aluno_inep = tbsc.cd_aluno_inep and prof_lp is not null)
and exists (select 1 from base_identificada.tb_base_spaece_censo tbs where cd_ano_serie_ceipe = 9 and fl_avaliado = 1 and tbs.cd_aluno_inep = tbsc.cd_aluno_inep and prof_lp is not null)
and vl_perc_acertos_lp is not null
and vl_perc_acertos_mt is not null
and prof_lp is not null
and prof_lp_erro is not null
and prof_mt is not null
and prof_mt_erro is not null
and fl_avaliado = 1 
)
,rep as (
select 
ts.co_pessoa_fisica, 
nu_ano_censo,
case when ts.tp_situacao = 4 then 'Reprovado' else 'Aprovado' end ds_situacao
from censo_esc_ce.tb_situacao_2007_2018 ts 
join codigo c on c.cd_aluno_inep = co_pessoa_fisica
where 
ts.tp_situacao in (4,5)
and nu_ano_censo<2019
) 
,proficiencias as (
select --count(distinct cd_aluno_inep)
nr_ano ano_spaece,
nu_sequencial,
de.id_crede_sefor,
de.nm_crede_sefor,
de.id_escola_inep,
de.nm_escola_recente,
cd_ano_serie_ceipe,
case when tbsc.cd_ano_serie_ceipe = 2 then 'Alfa - Fundamental'
     when tbsc.cd_ano_serie_ceipe = 5 then '5º Ano - Fundamental'
     when tbsc.cd_ano_serie_ceipe = 9 then '9º Ano - Fundamental'
     when tbsc.cd_ano_serie_ceipe = 12 then '3ª Série - Medio' end ds_ano_serie,
tbsc.cd_aluno_inep,
tbsc.vl_perc_acertos_lp,
tbsc.prof_lp,
tbsc.prof_lp_erro,
tbsc.vl_perc_acertos_mt,
tbsc.prof_mt,
tbsc.prof_mt_erro
from base_identificada.tb_base_spaece_censo tbsc 
join dw_censo.tb_dm_escola de on id_escola_inep =  cd_escola::int and de.nr_ano_censo = nr_ano
join codigo using (cd_aluno_inep)
where  cd_aluno_inep is not null 
--and vl_perc_acertos_lp is not null
--and vl_perc_acertos_mt is not null
and prof_lp is not null
and prof_lp_erro is not null
--and prof_mt is not null
--and prof_mt_erro is not null
and fl_avaliado = 1 
and cd_ano_serie_ceipe in (2,5,9,12) 
-- and cd_aluno_inep = 116796342088 --and cd_aluno_inep = 2
--order by  cd_aluno_inep , cd_ano_serie_ceipe

------ VERSÃO USANDO SCHEMA TMP:
with 
/*
codigo as ( 
--create table tmp.tb_codigo as (
select 
distinct cd_aluno_inep
from base_identificada.tb_base_spaece_censo tbsc 
where cd_ano_serie_ceipe = 12
and nr_ano =2019
and cd_aluno_inep is not null  --and cd_aluno_inep = 117987114196
--and tbsc.cd_escola::int = 23323434
--and exists (select 1 from base_identificada.tb_base_spaece_censo tbs where cd_ano_serie_ceipe = 2 and fl_avaliado = 1 and tbs.cd_aluno_inep = tbsc.cd_aluno_inep and tbs.fl_avaliado = 1)
and exists (select 1 from base_identificada.tb_base_spaece_censo tbs where cd_ano_serie_ceipe = 5 and fl_avaliado = 1 and tbs.cd_aluno_inep = tbsc.cd_aluno_inep and prof_lp is not null)
and exists (select 1 from base_identificada.tb_base_spaece_censo tbs where cd_ano_serie_ceipe = 9 and fl_avaliado = 1 and tbs.cd_aluno_inep = tbsc.cd_aluno_inep and prof_lp is not null)
and vl_perc_acertos_lp is not null
and vl_perc_acertos_mt is not null
and prof_lp is not null
and prof_lp_erro is not null
and prof_mt is not null
and prof_mt_erro is not null
and fl_avaliado = 1 
), 
rep as (
create table tmp.tb_sit_spaece as (
select 
ts.co_entidade cd_escola,
ts.co_pessoa_fisica cd_aluno_inep, 
nu_ano_censo nr_ano,
case when ts.tp_situacao = 4 then 'Reprovado'
     when ts.tp_situacao = 5 then 'Aprovado'
     when ts.tp_situacao = 2 then 'Abandono' end ds_situacao
from censo_esc_ce.tb_situacao_2007_2018 ts 
join tmp.tb_codigo c on c.cd_aluno_inep = co_pessoa_fisica
where 
ts.tp_situacao in (4,5,2) --
union 
select 
ts.co_entidade cd_escola,
ts.co_pessoa_fisica cd_aluno_inep, 
nu_ano_censo nr_ano,
case when ts.tp_situacao = 4 then 'Reprovado'
     when ts.tp_situacao = 5 then 'Aprovado'
     when ts.tp_situacao = 2 then 'Abandono' end ds_situacao
from censo_esc_ce.tb_situacao_2019 ts
join tmp.tb_codigo c on c.cd_aluno_inep = co_pessoa_fisica
where 
ts.tp_situacao in (4,5,2) --
) 
--select count(distin) from rep group by 1
,

distorcao as (
--create table tmp.tb_distorcao as (
select 
tm.nu_ano_censo nr_ano,
tm.co_pessoa_fisica cd_aluno_inep, 
max(case when (tm.nu_idade_referencia - tde.cd_ano_serie) <= 6 then 0 else (tm.nu_idade_referencia - tde.cd_ano_serie) - 6  end) qtd_anos_distorcao
from censo_esc_ce.tb_matricula_2019 tm 
join tmp.tb_codigo on  cd_aluno_inep = tm.co_pessoa_fisica 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where tde.cd_ano_serie in (2,5,9,12)
--and cd_aluno_inep = 117987114196
group by 1,2
union 
select 
tm.nu_ano_censo nr_ano,
tm.co_pessoa_fisica cd_aluno_inep, 
max(case when (tm.nu_idade_referencia - tde.cd_ano_serie) <= 6 then 0 else (tm.nu_idade_referencia - tde.cd_ano_serie) - 6  end) qtd_anos_distorcao
from censo_esc_ce.tb_matricula_2007_2018 tm
join tmp.tb_codigo on  cd_aluno_inep = tm.co_pessoa_fisica 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where tde.cd_ano_serie in (2,5,9,12)
group by 1,2
)
*/
proficiencias as (
select --count(distinct cd_aluno_inep)
nr_ano,
nu_sequencial,
tbsc.cd_escola,
cd_ano_serie_ceipe,
case when tbsc.cd_ano_serie_ceipe = 2 then 'Alfa - Fundamental'
     when tbsc.cd_ano_serie_ceipe = 5 then '5º Ano - Fundamental'
     when tbsc.cd_ano_serie_ceipe = 9 then '9º Ano - Fundamental'
     when tbsc.cd_ano_serie_ceipe = 12 then '3ª Série - Medio' end ds_ano_serie,
tbsc.cd_aluno_inep,
tbsc.vl_perc_acertos_lp,
tbsc.prof_lp,
tbsc.prof_lp_erro,
tbsc.vl_perc_acertos_mt,
tbsc.prof_mt,
tbsc.prof_mt_erro
from base_identificada.tb_base_spaece_censo tbsc 
join tmp.tb_codigo using (cd_aluno_inep)
where  cd_aluno_inep is not null 
and vl_perc_acertos_lp is not null
and vl_perc_acertos_mt is not null
and prof_lp is not null
and prof_lp_erro is not null
and prof_mt is not null
and prof_mt_erro is not null
and fl_avaliado = 1 
and cd_ano_serie_ceipe in (2,5,9,12) 
) --select * from proficiencias
select --count(1)
p.nr_ano  "ANO_EDICAO",
nu_sequencial  "SEQUENCIAL",
de.id_crede_sefor,
de.nm_crede_sefor,
p.cd_escola    "CD_ESCOLA",
de.nm_escola,
p.cd_ano_serie_ceipe     "CD_ANO_SERIE",
ds_ano_serie   "DS_ANO_SERIE",
p.cd_aluno_inep     "CD_ALUNO_INEP",
replace(vl_perc_acertos_lp::text,'.',',')    "VL_PERC_ACERTOS_LP",
replace(prof_lp::text,'.',',')     "PROFICIENCIA_LP",
replace(prof_lp_erro::text,'.',',')     "PROFICIENCIA_LP_ERRO",
replace(vl_perc_acertos_mt::text,'.',',')    "VL_PERC_ACERTOS_MT",
replace(prof_mt::text,'.',',')     "PROFICIENCIA_MT",
replace(prof_mt_erro::text,'.',',')     "PROFICIENCIA_MT_ERRO",
coalesce(ds_situacao::text,'Sem Informação') "DS_SITUACAO",
qtd_anos_distorcao  "QTD_ANOS_DISTORCAO"
from proficiencias p 
join dw_censo.tb_dm_escola de on de.id_escola_inep = p.cd_escola::int and p.nr_ano = de.nr_ano_censo 
left join tmp.tb_sit_spaece s on s.cd_aluno_inep = p.cd_aluno_inep and s.nr_ano = p.nr_ano
left join tmp.tb_distorcao d on d.cd_aluno_inep = p.cd_aluno_inep and d.nr_ano = p.nr_ano 