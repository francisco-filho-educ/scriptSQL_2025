-- TABELA ALUNO INFREQUENCIA: aluno_infrequencia.csv
/*
drop table if exists tmp.tb_frequencias;
create table tmp.tb_frequencias as (
with 
disciplinas as (
select 
ci_disciplina,
cd_grupodisciplina,
tg.ds_grupodisciplina ds_disciplina
from academico.tb_disciplinas td 
join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina = td.cd_grupodisciplina 
where
	cd_grupodisciplina between 1 and 16 and not cd_grupodisciplina = 15
)
,turmas as (
	select * from academico.tb_turma 
	where nr_anoletivo = 2024
	and cd_prefeitura = 0
	and cd_etapa in (162,184,188,163,185,189,164,186,190,165,187,191) 
	--and cd_unidade_trabalho = ",unidade," 
)
select 
	cd_aluno, 
	cd_turma,
	cd_grupodisciplina,
	nr_mes, 
	sum(nr_faltas) nr_faltas 
	from academico.tb_alunofrequencia af
	join disciplinas on cd_disciplina = ci_disciplina 
	where
	af.nr_anoletivo  = 2024
	and exists(select 1 from turmas t where t.ci_turma=af.cd_turma)
	group by 1,2,3,4
);
*/
----------------------------------------------------------------------------------------------------
/*
drop table if exists tmp.tb_aulas;
create table tmp.tb_aulas as (
with 
disciplinas as (
select 
ci_disciplina,
cd_grupodisciplina,
tg.ds_grupodisciplina ds_disciplina
from academico.tb_disciplinas td 
join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina = td.cd_grupodisciplina 
where
	cd_grupodisciplina between 1 and 16 and not cd_grupodisciplina = 15
)
,turmas as (
	select * from academico.tb_turma 
	where nr_anoletivo = 2024
	and cd_prefeitura = 0
	and cd_etapa in (162,184,188,163,185,189,164,186,190,165,187,191) 
)
	select
	nr_anoletivo,
	cd_turma, 
	cd_grupodisciplina,
	nr_mes,
	sum(nr_aulas) nr_aulas 
	from academico.tb_alunofrequencia_total_aulas_mes aftam
	join disciplinas on cd_disciplina = ci_disciplina 
	where 
	nr_anoletivo = 2024
	and exists(select 1 from turmas t where t.ci_turma=aftam.cd_turma)
	group by 1,2,3,4
)
*/
with alunos_aulas as (
select 
tu.nr_anoletivo,
tu.cd_aluno,
tu.cd_turma,
sit.cd_grupodisciplina,
sit.nr_mes,
sit.nr_aulas,
tf.nr_faltas
from academico.tb_ultimaenturmacao tu 
join tmp.tb_aulas sit using (cd_turma)
left join tmp.tb_frequencias tf on tf.cd_aluno = tu.cd_aluno and tf.cd_grupodisciplina = sit.cd_grupodisciplina and sit.nr_mes = tf.nr_mes and tf.cd_turma = tu.cd_turma   
where tu.nr_anoletivo = 2024
and tu.fl_tipo_atividade <> 'AC' 
--and tu.cd_turma = 962312
)
select 
  a.nr_anoletivo,
  a.cd_turma,
  a.cd_aluno,
  0 cd_disciplina,
  '--' ds_disciplina,
  a.nr_mes,
  sum(coalesce(nr_aulas,0)) nr_aulas,
  sum(coalesce(nr_faltas,0)) nr_faltas
from alunos_aulas a 
--where nr_mes = 12 -- FILTRO DE MÊS
group by 1,2,3,4,5,6

----------------------------------------------------------------------------------------------------------------------------------------------

--TABELA ALIMENTACAO INFREQUENCIA: alimentacao_infrequencia.csv
select 
tip.cd_turma,
nr_ano,
nr_mes,
cd_disciplina,
ds_disciplina,
nr_freq,
nr_registrado,
nr_aulas,
nr_faltas 
from saladesituacao.tb_infrequencia_percentual_2024



