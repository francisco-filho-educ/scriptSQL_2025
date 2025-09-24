with conc as (
select 
nu_ano_censo,
id_turma,
count(1) in_concluinte
from censo_esc_ce.tb_situacao_2021 tmd
where
in_concluinte = 1
group by 1,2/*
union 
select 
nu_ano_censo,
id_turma,
count(1) in_concluinte
from censo_esc_ce.tb_situacao_2020 tmd
where
in_concluinte = 1
group by 1,2
union 
select
nu_ano_censo,
id_turma,
count(1) in_concluinte
from censo_esc_ce.tb_situacao_2019 tmd
where
in_concluinte = 1
group by 1,2
union 
select 
nu_ano_censo,
id_turma,
count(1) in_concluinte
from censo_esc_ce.tb_situacao_2007_2018 tmd
where
in_concluinte = 1
and nu_ano_censo = 2015
group by 1,2 */
),
mat as (
select 
nu_ano_censo,
co_entidade,
id_turma,
tmd.co_curso_educ_profissional,
tp_etapa_ensino,
count(1) qt_matricula
from censo_esc_ce.tb_matricula_2021_d tmd
where co_curso_educ_profissional is not null
group by 1,2,3,4,5/*
union 
select 
nu_ano_censo,
co_entidade,
id_turma,
tmd.co_curso_educ_profissional,
tp_etapa_ensino,
count(1) qt_matricula
from censo_esc_ce.tb_matricula_2020 tmd
where co_curso_educ_profissional is not null
group by 1,2,3,4,5
union 
select 
nu_ano_censo,
co_entidade,
id_turma,
tmd.co_curso_educ_profissional,
tp_etapa_ensino,
count(1) qt_matricula
from censo_esc_ce.tb_matricula_2019 tmd
where co_curso_educ_profissional is not null
group by 1,2,3,4,5
union 
select 
nu_ano_censo,
co_entidade,
id_turma,
tmd.co_curso_educ_profissional,
tp_etapa_ensino,
count(1) qt_matricula
from censo_esc_ce.tb_matricula_2007_2018 tmd
where co_curso_educ_profissional is not null
and nu_ano_censo >2011
group by 1,2,3,4,5 */
),
escolas as (
select 
ted.nu_ano_censo,
ted.co_orgao_regional,
tdm.nm_mesorregiao,
ted.co_municipio,
nm_municipio,
case when ted.tp_dependencia = 1 then 'Federal' 
  when ted.tp_dependencia = 2 then 'Estadual' 
  when ted.tp_dependencia = 3 then 'MUnicipal' 
  when ted.tp_dependencia = 4 then 'Privada'  end ds_dependencia,
ted.co_entidade,
no_entidade
from censo_esc_ce.tb_escola_2021_d ted 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = ted.co_municipio
union 
select 
ted.nu_ano_censo,
ted.co_orgao_regional,
tdm.nm_mesorregiao,
ted.co_municipio,
nm_municipio,
case when ted.tp_dependencia = 1 then 'Federal' 
  when ted.tp_dependencia = 2 then 'Estadual' 
  when ted.tp_dependencia = 3 then 'MUnicipal' 
  when ted.tp_dependencia = 4 then 'Privada'  end ds_dependencia,
ted.co_entidade,
no_entidade
from censo_esc_ce.tb_escola_2019_2020 ted 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = ted.co_municipio
union 
select 
ted.nu_ano_censo,
ted.co_orgao_regional,
tdm.nm_mesorregiao,
ted.co_municipio,
nm_municipio,
case when ted.tp_dependencia = 1 then 'Federal' 
  when ted.tp_dependencia = 2 then 'Estadual' 
  when ted.tp_dependencia = 3 then 'MUnicipal' 
  when ted.tp_dependencia = 4 then 'Privada'  end ds_dependencia,
ted.co_entidade,
no_entidade
from censo_esc_ce.tb_escola_2007_2018 ted 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = ted.co_municipio
where nu_ano_censo >2011
)/*
select 
tmd.nu_ano_censo::int,
ted.co_orgao_regional,
nm_mesorregiao,
ted.co_municipio,
nm_municipio,
ds_dependencia,
ted.co_entidade,
no_entidade,
tcep.id_area_curso_educ_profissional,
tcep.no_area_curso_educ_profissional,
tcep.co_curso_educ_profissional,
tcep.no_curso_educ_profissional,
tde.ds_etapa_ensino,
sum (qt_matricula) "QT_MATRICULAS",
sum(coalesce(in_concluinte,0)) "QT_CONCLUINTE_CURSO"
from mat tmd
left join conc on conc.id_turma = tmd.id_turma and conc.nu_ano_censo = tmd.nu_ano_censo 
join censo_esc_ce.tb_curso_educ_profissional tcep on tcep.co_curso_educ_profissional =  tmd.co_curso_educ_profissional and tmd.nu_ano_censo =  tcep.nu_ano_censo 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tmd.tp_etapa_ensino 
join escolas ted on tmd.co_entidade =  ted.co_entidade and tmd.nu_ano_censo = ted.nu_ano_censo 
where tmd.nu_ano_censo >2011
group by 1,2,3,4,5,6,7,8,9,10,11,12,13

*/
select
tmd.nu_ano_censo::int "ANO_CENSO",
'' "Cluster",
tcep.no_curso_educ_profissional "NO_OCDE",
ds_dependencia "DS_CATEGORIA_ADMINISTRATIVA",
'Técnico' "NÍVEL DE ENSINO",
'' "DS_ORGANIZACAO_ACADEMICA",
'' "DS_GRAU_ACADEMICO",
tmd.co_entidade "CO_ENTIDADE",
ted.no_entidade "NO_ENTIDADE",
'' Colunas1,
tcep.co_curso_educ_profissional "CO_CURSO_EDUC_PROFISSIONAL",
tde.ds_etapa_ensino "NO_CURSO",
co_municipio::int cod_municipio,
nm_municipio desc_municipio,
nm_mesorregiao desc_regional,
sum (qt_matricula) "QT_MATRICULAS",
sum(coalesce(in_concluinte,0)) "QT_CONCLUINTE_CURSO"
from mat tmd
left join conc on conc.id_turma = tmd.id_turma and conc.nu_ano_censo = tmd.nu_ano_censo 
join censo_esc_ce.tb_curso_educ_profissional tcep on tcep.co_curso_educ_profissional =  tmd.co_curso_educ_profissional and tmd.nu_ano_censo =  tcep.nu_ano_censo 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tmd.tp_etapa_ensino 
join escolas ted on tmd.co_entidade =  ted.co_entidade and tmd.nu_ano_censo = ted.nu_ano_censo 
where tmd.nu_ano_censo = 2021
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15





--ANO_CENSO
--Cluster
--NO_OCDE
--DS_CATEGORIA_ADMINISTRATIVA
--NÍVEL DE ENSINO
--DS_ORGANIZACAO_ACADEMICA
--DS_GRAU_ACADEMICO
--CO_ENTIDADE
--NO_ENTIDADE
--Colunas1
--CO_CURSO_EDUC_PROFISSIONAL
--NO_CURSO
--cod_municipio
--desc_municipio
--desc_regional
--QT_MATRICULAS
--QT_CONCLUINTE_CURSO