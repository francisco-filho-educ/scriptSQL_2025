with
aluno_aprovado as(
select tae.nr_anoletivo, tae.fl_aprovado, tae.cd_aluno from enem.tb_aluno_enem tae
where nr_anoletivo IN (2022)
),
aprovacao_ies as(
select etai.nr_anoletivo, etai.cd_aluno, etai.cd_turma,etai.cd_ies, eties.nm_ies, eties.cd_uf, eties.sg_uf, eties.cd_municipio, tms.nm_municipio, eties.cd_dep_adm, eties.nm_dep_adm, eties.cd_tpinstituicao, eties.nm_tpinstituicao, eties.status, etai.fl_ead, etai.cd_tipo_ingresso, eti.ds_tipo_ingresso, etai.cd_curso, etcfs.nm_curso, etcfs.cd_classe, etcfs.nm_classe, etcfs.nm_grau, etai.fl_cursar  from enem.tb_aluno_ies as etai
inner join educacenso_exp.tb_curso_formacao_superior as etcfs on etai.cd_curso = etcfs.cd_curso 
inner join educacenso_exp.tb_ies as eties on etai.cd_ies=eties.cd_ies 
inner join enem.tb_tipo_ingresso as eti on etai.cd_tipo_ingresso = eti.ci_tipo_ingresso
inner join enem.tb_tipo_ies as etties on etai.cd_tipo_ies = etties.ci_tipo_ies
inner join util.tb_municipio_censo as tms on eties.cd_municipio = tms.ci_municipio_censo
--inner join util.tb_inep_municipio as tim on eties.cd_municipio = tim.cod_inep
where nr_anoletivo IN (2022)
)

select * from aluno_aprovado aa
left join aprovacao_ies ai on aa.cd_aluno = ai.cd_aluno and aa.nr_anoletivo = ai.nr_anoletivo

--select * from util.tb_inep_municipio where cod_inep=2307304

/*

with
aluno_aprovado as(
select tae.nr_anoletivo, tae.fl_aprovado, tae.cd_aluno from enem.tb_aluno_enem tae
where nr_anoletivo IN (2023)
)
,matricula as (
select 
cd_unidade_trabalho,
cd_turma,
cd_aluno
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on cd_turma =  ci_turma 
where 
tt.nr_anoletivo = 2023
and cd_nivel = 27
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho and cd_categoria = 11)
)
select
id_escola_inep,
nm_escola,
count(distinct cd_aluno) participantes,
count(distinct case when fl_aprovado then cd_aluno end) qtd_aprovados,
round(count(distinct case when fl_aprovado then cd_aluno end) / count(distinct cd_aluno)::numeric *100,2) perc_aprovados
from aluno_aprovado aa
inner join matricula m using(cd_aluno)
inner join dw_sige.tb_dm_escola tde on id_escola_sige =  m.cd_unidade_trabalho
group by 1,2
*/

--APROVADOS IES POR ESCOLA E CURSO 
/*
with
aluno_aprovado as(
select 
tae.nr_anoletivo,
tae.cd_aluno, 
cd_turma ci_turma 
from enem.tb_aluno_enem tae
where nr_anoletivo >= 2014
and tae.fl_aprovado 
group by 1,2,3
)
,aprovacao_ies as(
select 
etai.nr_anoletivo, 
etai.cd_aluno, 
eties.nm_dep_adm, 
eties.cd_tpinstituicao, 
eties.nm_tpinstituicao, 
eti.ds_tipo_ingresso, 
etai.cd_curso, 
etcfs.nm_curso, 
etcfs.nm_classe, 
etcfs.nm_grau, 
case when etai.fl_cursar then 'SIM' else 'NÃO' end ds_cursar   
from enem.tb_aluno_ies as etai
inner join educacenso_exp.tb_curso_formacao_superior as etcfs on etai.cd_curso = etcfs.cd_curso 
inner join educacenso_exp.tb_ies as eties on etai.cd_ies=eties.cd_ies 
inner join enem.tb_tipo_ingresso as eti on etai.cd_tipo_ingresso = eti.ci_tipo_ingresso
inner join enem.tb_tipo_ies as etties on etai.cd_tipo_ies = etties.ci_tipo_ies
inner join util.tb_municipio_censo as tms on eties.cd_municipio = tms.ci_municipio_censo
--inner join util.tb_inep_municipio as tim on eties.cd_municipio = tim.cod_inep
where etai.nr_anoletivo  >= 2014 --21804
) 
select
nr_anoletivo,
tut.cd_unidade_trabalho_pai,
crede.nm_sigla,
tl.cd_inep cd_municipio,
ds_localidade,
tut.nr_codigo_unid_trab,
tut.nm_unidade_trabalho,
--nm_dep_adm,  
--nm_tpinstituicao, 
--ds_tipo_ingresso, 
--a.cd_curso, 
--nm_curso, 
--nm_classe, 
--nm_grau, 
--ds_cursar,
count(distinct cd_aluno) qtd
from aprovacao_ies a 
join aluno_aprovado using(cd_aluno,nr_anoletivo)
join academico.tb_turma tt using(nr_anoletivo,ci_turma)
join util.tb_unidade_trabalho tut on tut.ci_unidade_trabalho =  cd_unidade_trabalho
join util.tb_unidade_trabalho crede on crede.ci_unidade_trabalho =  tut.cd_unidade_trabalho_pai
join util.tb_localidades tl on tl.ci_localidade =  tut.cd_municipio
where tut.cd_dependencia_administrativa = 2
group by 1,2,3,4,5,6,7--,8,9,10,11,12,13,14,15 -- DESCOMENTAR QUANDO FOR POR CURSO

*/