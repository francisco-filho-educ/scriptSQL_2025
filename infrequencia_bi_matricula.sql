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
),
turmas as (
	select * from academico.tb_turma 
	where nr_anoletivo = 2024
	and cd_prefeitura = 0
	and cd_etapa in (162,184,188,163,185,189,164,186,190,165,187,191) 
	--and cd_unidade_trabalho = ",unidade," 
)
,enturmados as (
	select cd_aluno,cd_turma 
	from academico.tb_ultimaenturmacao e
	where e.nr_anoletivo = 2024
	and  exists(select 1 from turmas t where t.ci_turma=e.cd_turma)
)
,aulas as (
	select
	cd_turma, 
	cd_grupodisciplina,
	ds_disciplina,
	nr_mes,
	sum(nr_aulas) nr_aulas 
	from academico.tb_alunofrequencia_total_aulas_mes aftam
	join disciplinas on cd_disciplina = ci_disciplina 
	where 
	nr_anoletivo = 2024
	and exists(select 1 from enturmados ent where ent.cd_turma=aftam.cd_turma)
	group by 1,2,3,4 order by 2 desc
)
 select
  t.nr_anoletivo,
  e.cd_turma,
  e.cd_aluno,
  0 cd_disciplina,
  '--' ds_disciplina,
  a.nr_mes,
  sum(nr_aulas) nr_aulas,
  sum(f.nr_faltas) nr_faltas
from enturmados e
join turmas t on e.cd_turma=t.ci_turma
join aulas a on a.cd_turma=e.cd_turma
left join tmp.tb_frequencias  f on a.cd_turma=f.cd_turma 
and f.cd_aluno=e.cd_aluno and a.nr_mes = f.nr_mes and a.cd_grupodisciplina = f.cd_grupodisciplina
group by 1,2,3,4,5,6