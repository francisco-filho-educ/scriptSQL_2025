with turma as ( 
select
cd_unidade_trabalho,
cd_aluno,
cd_turma,
ds_turno,
cd_etapa
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on tt.ci_turma = tu.cd_turma 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where tu.nr_anoletivo = 2024
and cd_nivel = 27 
and cd_etapa in (162,163,164,184,185,186,188,189,190)
), alunos as (
select 
ci_aluno cd_aluno,
ta.cd_municipio 
from academico.tb_aluno ta 
where ta.fl_transporte = 'S'
and exists (select 1 from turma t where t.cd_aluno = ci_aluno)
), mat as (
select 
cd_unidade_trabalho,
cd_municipio,
ds_turno,
cd_etapa,
cd_aluno 
from turma
join alunos using(cd_aluno)
)
SELECT 
2024 ano,
--crede.ci_unidade_trabalho, 
--crede.nm_sigla, 
upper(tl.ds_localidade) AS nm_municipio_aluno,
upper(tmc.nm_municipio) AS nm_municipio_esc,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
upper(ds_turno) ds_turno,
count(1) total,
sum(case when cd_etapa in(162,184,188) then 1 else 0 end) nr_1_serie,
sum(case when cd_etapa in(163,185,189) then 1 else 0 end) nr_2_serie,
sum(case when cd_etapa in(164,186,190) then 1 else 0 end) nr_3_serie
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
join util.tb_localidades tl on tl.ci_localidade = mat.cd_municipio 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
group by 1,2,3,4,5