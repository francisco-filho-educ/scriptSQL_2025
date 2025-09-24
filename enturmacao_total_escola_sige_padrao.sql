with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
ds_turma,
fl_tipo_seriacao,
cd_unidade_trabalho,
cd_prefeitura
from academico.tb_turma tt 
join academico.tb_turno tr on tr.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2022 
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28) and cd_etapa in(164,186,190)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
),
ult_ent as (
  select
  cd_aluno,
  cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2022 
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  )
  --,mat as (
select 
--tt.nr_anoletivo,
--cd_unidade_trabalho,
count(1) nr_matriculas
from ult_ent tue
join turma tt on tt.ci_turma = tue.cd_turma
group by 1,2 

union 
select 
nr_anoletivo,
tut.ci_unidade_trabalho cd_unidade_trabalho,
count(1) nr_matriculas
from util.tb_unidade_trabalho tut 
left join sigecci.tb_enturmacao te on tut.ci_unidade_trabalho = te.cd_cci_indicado 
where
te.nr_anoletivo = 2022
and te.fl_apto 
and te.fl_ultima_enturmacao 
and te.fl_enturmado
group by 1,2
)
select 
nr_anoletivo,
tut.cd_unidade_trabalho_pai id_crede_sefor,
tutpai.nm_sigla nm_crede_sefor, 
tl.ci_municipio_censo id_municipio,
upper(tl.nm_municipio) nm_municipio, 
tut.nr_codigo_unid_trab id_escola_inep,
tut.ci_unidade_trabalho id_escola_sige,
tut.nm_unidade_trabalho nm_escola,
upper( case when tut.cd_tipo_unid_trab  = 402 then 'CCI' else tc.nm_categoria end) ds_categoria,
nr_matriculas
from mat m
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = m.cd_unidade_trabalho 
join rede_fisica.tb_unidade_trabalho tutpai on tut.cd_unidade_trabalho_pai = tutpai.ci_unidade_trabalho 
join rede_fisica.tb_local_unid_trab tlu on tlu.cd_unidade_trabalho  = tut.ci_unidade_trabalho 
join rede_fisica.tb_local_funcionamento tlf on tlu.cd_local_funcionamento  = tlf.ci_local_funcionamento 
join util.tb_municipio_censo tl on tlf.cd_municipio_censo = tl.ci_municipio_censo
join rede_fisica.tb_categoria tc on tc.ci_categoria = tut.cd_categoria
where 1= 1
and tut.cd_situacao_funcionamento = 1 
and tlu.fl_sede = true
and tut.cd_tipo_unid_trab in (401,402)



