with turma as (
select
nr_anoletivo,
ci_turma,
ds_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2022
and tt.fl_tipo_seriacao = 'RG' and tt.cd_tpensino = 1 
and tt.fl_ativo = 'S'
--and tt.cd_modalidade <> 38
and cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191)
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27 --and ci_turma = 812865
and tt.cd_unidade_trabalho = 593
) --select count(1) from turma
, enturmados as (
select 
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
where tu.nr_anoletivo = 2022
and tu.fl_tipo_atividade <> 'AC'
and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
)
, --select count(1) from enturmados --319462
alunos as  (
select 
ci_aluno,
nm_aluno
from academico.tb_aluno
where exists (select 1 from enturmados  where cd_aluno = ci_aluno)
)
select 
nr_anoletivo,
tut.nr_codigo_unid_trab,
tut.nm_unidade_trabalho,
ds_ofertaitem,
ds_turma,
nm.cd_aluno,
nm_aluno,
nr_mes,
ds_grupodisciplina,
nr_aulas,
coalesce(nr_faltas,0) nr_faltas,
round(case when nr_aulas = 0  then null else coalesce(nr_faltas,0)/ nr_aulas end,1) p_faltas
from public.tb_infrequencia_escola_sum 	 nm 
join alunos a on ci_aluno = nm.cd_aluno
join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina = cd_grupodisciplina
join turma tm on tm.ci_turma = nm.cd_turma
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tm.cd_unidade_trabalho
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
left JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
left JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
left join rede_fisica.tb_tipo_unid_trab ttut on ttut.ci_tipo_unid_trab = tut.cd_tipo_unid_trab  
WHERE tlut.fl_sede = TRUE 
and tut.cd_dependencia_administrativa = 2
and tut.cd_tipo_unid_trab = 401

