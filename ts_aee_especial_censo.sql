with mat as (
select
nu_ano_censo nr_ano_censo,
co_municipio id_municipio,
count(distinct case when tm.tp_tipo_atendimento_turma = 4 then co_pessoa_fisica end)  nr_aee,
count(distinct case when in_necessidade_especial=1 then co_pessoa_fisica end) nr_def,
count(distinct case when in_baixa_visao=1  then co_pessoa_fisica end) nr_bv,
count(distinct case when in_cegueira=1  then co_pessoa_fisica end) nr_ceg,
count(distinct case when in_def_auditiva=1  then co_pessoa_fisica end) nr_def_aud,
count(distinct case when in_def_fisica=1  then co_pessoa_fisica end) nr_def_fis,
count(distinct case when in_def_intelectual=1  then co_pessoa_fisica end) nr_def_int,
count(distinct case when in_surdez=1  then co_pessoa_fisica end) nr_surd,
count(distinct case when in_surdocegueira=1  then co_pessoa_fisica end)nr_surdo_ceg,
count(distinct case when in_def_multipla=1  then co_pessoa_fisica end) nr_def_mult,
count(distinct case when in_autismo=1  then co_pessoa_fisica end) nr_aut,
count(distinct case when in_superdotacao=1  then co_pessoa_fisica end) nr_super
from censo_esc_d.tb_matricula tm 
where tm.tp_dependencia = 2
group by 1,2
union 
select
nu_ano_censo nr_ano_censo,
co_municipio id_municipio,
count(distinct case when tm.tp_tipo_atendimento_turma = 4 then co_pessoa_fisica end)  nr_aee,
count(distinct case when in_necessidade_especial=1 then co_pessoa_fisica end) nr_def,
count(distinct case when in_baixa_visao=1  then co_pessoa_fisica end) nr_bv,
count(distinct case when in_cegueira=1  then co_pessoa_fisica end) nr_ceg,
count(distinct case when in_def_auditiva=1  then co_pessoa_fisica end) nr_def_aud,
count(distinct case when in_def_fisica=1  then co_pessoa_fisica end) nr_def_fis,
count(distinct case when in_def_intelectual=1  then co_pessoa_fisica end) nr_def_int,
count(distinct case when in_surdez=1  then co_pessoa_fisica end) nr_surd,
count(distinct case when in_surdocegueira=1  then co_pessoa_fisica end)nr_surdo_ceg,
count(distinct case when in_def_multipla=1  then co_pessoa_fisica end) nr_def_mult,
count(distinct case when in_autismo=1  then co_pessoa_fisica end) nr_aut,
count(distinct case when in_superdotacao=1  then co_pessoa_fisica end) nr_super
from censo_esc_ce.tb_matricula_2021 tm 
where tm.tp_dependencia = 2
group by 1,2
union 
select
nu_ano_censo nr_ano_censo,
co_municipio id_municipio,
count(distinct case when tm.tp_tipo_atendimento_turma = 4 then co_pessoa_fisica end)  nr_aee,
count(distinct case when in_necessidade_especial=1 then co_pessoa_fisica end) nr_def,
count(distinct case when in_baixa_visao=1  then co_pessoa_fisica end) nr_bv,
count(distinct case when in_cegueira=1  then co_pessoa_fisica end) nr_ceg,
count(distinct case when in_def_auditiva=1  then co_pessoa_fisica end) nr_def_aud,
count(distinct case when in_def_fisica=1  then co_pessoa_fisica end) nr_def_fis,
count(distinct case when in_def_intelectual=1  then co_pessoa_fisica end) nr_def_int,
count(distinct case when in_surdez=1  then co_pessoa_fisica end) nr_surd,
count(distinct case when in_surdocegueira=1  then co_pessoa_fisica end)nr_surdo_ceg,
count(distinct case when in_def_multipla=1  then co_pessoa_fisica end) nr_def_mult,
count(distinct case when in_autismo=1  then co_pessoa_fisica end) nr_aut,
count(distinct case when in_superdotacao=1  then co_pessoa_fisica end) nr_super
from censo_esc_ce.tb_matricula_2020 tm 
where tm.tp_dependencia = 2
group by 1,2
union 
select
nu_ano_censo nr_ano_censo,
co_municipio id_municipio,
count(distinct case when tm.tp_tipo_atendimento_turma = 4 then co_pessoa_fisica end)  nr_aee,
count(distinct case when in_necessidade_especial=1 then co_pessoa_fisica end) nr_def,
count(distinct case when in_baixa_visao=1  then co_pessoa_fisica end) nr_bv,
count(distinct case when in_cegueira=1  then co_pessoa_fisica end) nr_ceg,
count(distinct case when in_def_auditiva=1  then co_pessoa_fisica end) nr_def_aud,
count(distinct case when in_def_fisica=1  then co_pessoa_fisica end) nr_def_fis,
count(distinct case when in_def_intelectual=1  then co_pessoa_fisica end) nr_def_int,
count(distinct case when in_surdez=1  then co_pessoa_fisica end) nr_surd,
count(distinct case when in_surdocegueira=1  then co_pessoa_fisica end)nr_surdo_ceg,
count(distinct case when in_def_multipla=1  then co_pessoa_fisica end) nr_def_mult,
count(distinct case when in_autismo=1  then co_pessoa_fisica end) nr_aut, -- 800
count(distinct case when in_superdotacao=1  then co_pessoa_fisica end) nr_super
from censo_esc_ce.tb_matricula_2019 tm 
where tm.tp_dependencia = 2
group by 1,2
union 
select
nu_ano_censo nr_ano_censo,
co_municipio id_municipio,
count(distinct case when tm.tp_tipo_turma = 5 then co_pessoa_fisica end)  nr_aee,
count(distinct case when in_necessidade_especial=1 then co_pessoa_fisica end) nr_def,
count(distinct case when in_baixa_visao=1  then co_pessoa_fisica end) nr_bv,
count(distinct case when in_cegueira=1  then co_pessoa_fisica end) nr_ceg,
count(distinct case when in_def_auditiva=1  then co_pessoa_fisica end) nr_def_aud,
count(distinct case when in_def_fisica=1  then co_pessoa_fisica end) nr_def_fis,
count(distinct case when in_def_intelectual=1  then co_pessoa_fisica end) nr_def_int,
count(distinct case when in_surdez=1  then co_pessoa_fisica end) nr_surd,
count(distinct case when in_surdocegueira=1  then co_pessoa_fisica end)nr_surdo_ceg,
count(distinct case when in_def_multipla=1  then co_pessoa_fisica end) nr_def_mult,
count(distinct case when in_autismo=1 or IN_SINDROME_ASPERGER = 1 or IN_SINDROME_RETT = 1 or IN_TRANSTORNO_DI = 1 then co_pessoa_fisica end) nr_aut,
count(distinct case when in_superdotacao=1  then co_pessoa_fisica end) nr_super
from censo_esc_ce.tb_matricula_2007_2018 tm 
where tm.tp_dependencia = 2
group by 1,2
)
,ds_municipio as (
select  
case when id_crede_sefor >20 then 21 else id_crede_sefor end id_crede_sefor,
case when id_crede_sefor >20 then 'SEFOR' else nm_crede_sefor end nm_crede_sefor,
id_municipio,
nm_municipio
from dw_censo.tb_dm_escola_dinamico
join dw_censo.tb_dm_municipio tdm using(id_municipio)
group by 1,2,3,4
)
select 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
id_municipio,
nm_municipio,
nr_aee,
nr_def,
nr_bv,
nr_ceg,
nr_def_aud,
nr_def_fis,
nr_def_int,
nr_surd,
nr_surdo_ceg,
nr_def_mult,
nr_aut,
nr_super
from mat 
join ds_municipio using(id_municipio)