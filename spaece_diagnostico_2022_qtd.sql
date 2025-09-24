-- BASE SIGE
with turma as (
select *
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2022 
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27)
and tt.fl_ativo = 'S'
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
)
,ult_ent as (
  select
  cd_aluno,cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2022
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  )
 ,mult  as(
select
tm.cd_turma,
ti.cd_nivel,
ti.cd_etapa,
1 fl_multseriado,
tm.cd_aluno
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
where 
tm.nr_anoletivo = 2022
and ti.cd_prefeitura = 0
and ti.cd_etapa in (122,125,129)

) --select * from mult
, outras as (
select
cd_turma,
cd_nivel,
cd_etapa,
0 fl_multseriado,
cd_aluno
from ult_ent tu
join turma tt on tu.cd_turma = ci_turma
where 
not exists (select 1 from mult where tu.cd_aluno = mult.cd_aluno)
),
aluno_etapa as(
select * from mult
union
select * from outras
)
, mat as (
select 
cd_unidade_trabalho,
--TOTAL
count(1) nr_mat,
count(distinct ci_turma) nr_turma,
count(distinct cd_unidade_trabalho) nr_escola,
-- SERIE/ANO
count( case when ae.cd_etapa = 122 then cd_turma  end ) a2_fund_aluno,
count( case when ae.cd_etapa = 125 then cd_turma  end ) a5_fund_aluno,
count( case when ae.cd_etapa = 129 then cd_turma  end ) a9_fund_aluno,
sum( case when ae.cd_etapa in(164,186,190) then 1 else 0  end ) s3_med_mat,
count(distinct case when ae.cd_etapa = 122 then cd_turma  end ) a2_fund_turma,
count(distinct case when ae.cd_etapa = 125 then cd_turma  end ) a5_fund_turma,
count(distinct case when ae.cd_etapa = 129 then cd_turma  end ) a9_fund_turma,
count(distinct case when ae.cd_etapa in(164,186,190) then cd_turma  end ) s3_med_turma,
count(distinct case when ae.cd_etapa = 122 then cd_unidade_trabalho  end ) a2_fund_esc,
count(distinct case when ae.cd_etapa = 125 then cd_unidade_trabalho  end ) a5_fund_esc,
count(distinct case when ae.cd_etapa = 129 then cd_unidade_trabalho  end ) a9_fund_esc,
count(distinct case when ae.cd_etapa in(164,186,190) then cd_unidade_trabalho  end ) s3_med_esc
--cd_nivel, cd_etapa, ds_etapa, count(1)
from  aluno_etapa ae
join turma tt on tt.ci_turma = ae.cd_turma
where ae.cd_etapa in (122,125,129,164,186,190)
group by cd_unidade_trabalho
) --select * from mat
SELECT 
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
--upper(tmc.nm_municipio) AS nm_municipio,
--upper(tc.nm_categoria) AS nm_categoria,
--tut.nr_codigo_unid_trab id_escola_inep, 
--tut.nm_unidade_trabalho nm_escola,
--upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
---
sum(nr_mat) nr_mat,
sum( a2_fund_aluno ) a2_fund_aluno,
sum( a5_fund_aluno ) a5_fund_aluno,
sum( a9_fund_aluno ) a9_fund_aluno,
sum(s3_med_mat ) s3_med_aluno,
---
sum(nr_turma) nr_turma,
sum( a2_fund_turma ) a2_fund_turma,
sum( a5_fund_turma ) a5_fund_turma,
sum( a9_fund_turma ) a9_fund_turma,
sum(s3_med_turma ) s3_med_turma,
---
sum( a2_fund_esc ) a2_fund_esc,
sum( a5_fund_esc ) a5_fund_esc,
sum( a9_fund_esc ) a9_fund_esc,
sum(s3_med_esc ) s3_med_esc,
sum(nr_escola) nr_escola
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
group by 1,2--,3,4,5,6,7
--ORDER BY 1,3,4,6;



-- BASE CENSO ESCOLAR
/*
with credes as (
select
tde.ds_orgao_regional,
id_crede_sefor,
nm_crede_sefor
from dw_censo.tb_dm_escola tde 
where tde.nr_ano_censo = 2020
and cd_dependencia = 2 and tde.ds_orgao_regional is not null
group by 1,2,3
)
select 
'CE' "NM_UF",
id_crede_sefor,
nm_crede_sefor "NM_REGIONAL",
case when tm.tp_dependencia = 2 then 'Estadual' else 'Municipal' end depend,
id_municipio "CD_MUNICIPIO",
nm_municipio "NM_MUNICIPIO",
te.co_entidade "CD_ESCOLA",
te.no_entidade "NM_ESCOLA",
sum(case when cd_ano_serie = 1 then 1 else 0 end) nr_aluno_2ano,
sum(case when cd_ano_serie = 4 then 1 else 0 end) nr_aluno_5ano,
sum(case when cd_ano_serie = 8 then 1 else 0 end) nr_aluno_9ano,
sum(case when cd_ano_serie = 11 then 1 else 0 end) nr_aluno_3serie,
count(distinct case when cd_ano_serie = 1 then id_turma end) nr_turma_2ano,
count(distinct case when cd_ano_serie = 4 then id_turma end) nr_turma_5ano,
count(distinct case when cd_ano_serie = 8 then id_turma end) nr_turma_9ano,
count(distinct case when cd_ano_serie = 11 then id_turma end) nr_turma_3serie,
count(distinct case when cd_ano_serie = 1 then tm.co_entidade end) nr_esc_2ano,
count(distinct case when cd_ano_serie = 4 then tm.co_entidade end) nr_esc_5ano,
count(distinct case when cd_ano_serie = 8 then tm.co_entidade end) nr_esc_9ano,
count(distinct case when cd_ano_serie = 11 then tm.co_entidade end) nr_esc_3serie
--select count(1)
from censo_esc_d.tb_matricula tm 
join censo_esc_d.tb_escola te on te.co_entidade = tm.co_entidade 
join dw_censo.tb_dm_etapa tet on tet.cd_etapa_ensino = tm.tp_etapa_ensino 
left join credes on te.co_orgao_regional  = ds_orgao_regional
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = te.co_municipio 
where 
tm.nu_ano_censo = 2021
and tm.tp_dependencia in (2,3)
and cd_ano_serie in (1,4,8,11)
and tm.in_regular = 1
--and (IN_RECURSO_BRAILLE = 1 or IN_RECURSO_AMPLIADA_18  = 1  or IN_RECURSO_AMPLIADA_24 = 1 )
group by 1,2,3,4,5,6,7,8
union 
select 
'CE' "NM_UF",
99 id_crede_sefor,
'TOTAL' "NM_REGIONAL",
case when tm.tp_dependencia = 2 then 'Estadual' else 'Municipal' end depend,
id_municipio "CD_MUNICIPIO",
nm_municipio "NM_MUNICIPIO",
te.co_entidade "CD_ESCOLA",
te.no_entidade "NM_ESCOLA",
sum(case when cd_ano_serie = 1 then 1 else 0 end) nr_aluno_2ano,
sum(case when cd_ano_serie = 4 then 1 else 0 end) nr_aluno_5ano,
sum(case when cd_ano_serie = 8 then 1 else 0 end) nr_aluno_9ano,
sum(case when cd_ano_serie = 11 then 1 else 0 end) nr_aluno_3serie,
count(distinct case when cd_ano_serie = 1 then id_turma end) nr_turma_2ano,
count(distinct case when cd_ano_serie = 4 then id_turma end) nr_turma_5ano,
count(distinct case when cd_ano_serie = 8 then id_turma end) nr_turma_9ano,
count(distinct case when cd_ano_serie = 11 then id_turma end) nr_turma_3serie,
count(distinct case when cd_ano_serie = 1 then tm.co_entidade end) nr_esc_2ano,
count(distinct case when cd_ano_serie = 4 then tm.co_entidade end) nr_esc_5ano,
count(distinct case when cd_ano_serie = 8 then tm.co_entidade end) nr_esc_9ano,
count(distinct case when cd_ano_serie = 11 then tm.co_entidade end) nr_esc_3serie
--select count(1)
from censo_esc_d.tb_matricula tm 
join censo_esc_d.tb_escola te on te.co_entidade = tm.co_entidade 
join dw_censo.tb_dm_etapa tet on tet.cd_etapa_ensino = tm.tp_etapa_ensino 
left join credes on te.co_orgao_regional  = ds_orgao_regional
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = te.co_municipio 
where 
tm.nu_ano_censo = 2021
and tm.tp_dependencia in (2,3)
and cd_ano_serie in (1,4,8,11)
and tm.in_regular = 1
--and (IN_RECURSO_BRAILLE = 1 or IN_RECURSO_AMPLIADA_18  = 1  or IN_RECURSO_AMPLIADA_24 = 1 )
group by 1,2,3,4,5,6,7,8
order by 2
*/