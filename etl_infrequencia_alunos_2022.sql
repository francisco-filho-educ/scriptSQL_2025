drop table if exists public.tb_infrequencia_aluno_disc;
create table public.tb_infrequencia_aluno_disc as (
with 
turmas as (
	select * from academico.tb_turma tt
	where
tt.nr_anoletivo = 2022
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
                  and tut.cd_dependencia_administrativa = 2
                  )
                  
)
,disciplinas as (
select 
td.ci_disciplina,td.cd_grupodisciplina
from academico.tb_disciplinas td 
where td.fl_possui_avaliacao  ilike 'S'
and td.cd_prefeitura = 0
and td.cd_grupodisciplina between 1 and 14
)
,aulas as (
	select 
	cd_turma,
	af.nr_mes,
	af.cd_disciplina, 
	sum(coalesce(nr_aulas,0)) nr_aulas 
	from academico.tb_alunofrequencia_total_aulas_mes af
	where exists(select 1 from disciplinas where ci_disciplina = cd_disciplina  )
	group by 1,2,3
) 
,
faltas as (
	select cd_aluno, cd_turma, nr_mes,af.cd_disciplina , max(nr_faltas) nr_faltas
	from academico.tb_alunofrequencia af
	where exists(select 1 from turmas t where t.ci_turma=af.cd_turma)
	and exists(select 1 from disciplinas where ci_disciplina = cd_disciplina  )
	group by 1,2,3,4
)
select
a.cd_turma,
cd_aluno,
a.nr_mes,
a.cd_disciplina,
cd_grupodisciplina,
sum(nr_aulas) nr_aulas,
sum(nr_faltas) nr_faltas
from aulas a
join disciplinas td2 on ci_disciplina = a.cd_disciplina
join faltas f on a.cd_turma=f.cd_turma and f.cd_disciplina = a.cd_disciplina and a.nr_mes = f.nr_mes
group by 1,2,3,4,5
);