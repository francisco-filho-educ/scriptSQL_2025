drop table if exists public.tb_infrequencia_aluno_disc;
create table public.tb_infrequencia_aluno_disc as (
with 
turma as (
	select 
	nr_anoletivo, 
	cd_unidade_trabalho,
	cd_nivel,
	ci_turma cd_turma
	from academico.tb_turma tt
	where
tt.nr_anoletivo = 2024
and tt.cd_prefeitura = 0 --and ci_turma = 960373
and tt.cd_nivel in (27,26,28)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
                  and tut.cd_dependencia_administrativa = 2
                  )                  
)
,enturmados as (
select 
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
join turma t using(cd_turma)
where tu.nr_anoletivo = 2024
and tu.fl_tipo_atividade <> 'AC'
)
,disciplinas as (
select 
	td.ci_disciplina,
	td.cd_grupodisciplina
from academico.tb_disciplinas td 
where td.fl_possui_avaliacao  ilike 'S'
and td.cd_prefeitura = 0
--and td.cd_grupodisciplina between 1 and 14
)
,aulas as (
	select 
	af.nr_anoletivo,
	t.cd_unidade_trabalho,
	cd_turma,
	af.nr_ano,
	af.nr_mes,
	af.cd_disciplina, 
	max(coalesce(nr_aulas,0)) nr_aulas 
	from academico.tb_alunofrequencia_total_aulas_mes af
	join turma t using(cd_turma)
	where 
	af.nr_anoletivo = 2024 
	and exists(select 1 from disciplinas where ci_disciplina = cd_disciplina  )
	and af.nr_mes< extract(month from current_date)
	and nr_aulas <> 0
	group by 1,2,3,4,5,6
)
,aluno_aula as (
select 
*
from enturmados
join aulas using ( cd_turma)
)
,
faltas as (
	select 
	cd_aluno, 
	cd_turma, 
	af.nr_ano,
	nr_mes,
	af.cd_disciplina,
	max(nr_faltas) nr_faltas
	from academico.tb_alunofrequencia af
	join turma t using(cd_turma)
	where 	af.nr_anoletivo = 2024
	and exists(select 1 from disciplinas where ci_disciplina = cd_disciplina  )
	and nr_mes< extract(month from current_date)
	group by 1,2,3,4,5
)
select
	nr_anoletivo,
	cd_unidade_trabalho,
	a.cd_turma,
	cd_aluno,
	a.nr_ano,
	a.nr_mes,
	a.cd_disciplina,
	cd_grupodisciplina,
	sum(nr_aulas) nr_aulas,
	sum(coalesce(nr_faltas,0)) nr_faltas
from aluno_aula  a
join disciplinas td2 on ci_disciplina = a.cd_disciplina
left join faltas f using(cd_aluno,cd_turma, cd_disciplina,nr_mes,nr_ano)
group by 1,2,3,4,5,6,7,8 
);

/*
--calculo infrequencia
--calculo infrequencia
with mes_bimestre as (
select 
tp.cd_unidade_trabalho,
cd_periodo,
dt_fim
from academico.tb_periodounidadetrabalho tp 
where 
nr_anoletivo = 2024
and cd_periodo = 1
)
,infreq as ( 
select
cd_aluno,
cd_turma,
sum(nr_aulas) total_aulas,
sum(nr_faltas) total_faltas,
sum(nr_faltas)/sum(nr_aulas) p_infreq
from public.tb_infrequencia_aluno_disc
join mes_bimestre b using (cd_unidade_trabalho)
where extract( month from dt_fim) <= nr_mes
group by 1,2
)
select 
cd_aluno,
cd_turma,
case when p_infreq > 0.2 then 1 else 0 end fl_infrequente
from infreq
*/


/*
select 
cd_periodo,
extract (month from dt_fim) mes, count(1)
from academico.tb_periodounidadetrabalho tp 
where 
nr_anoletivo = 2024
and cd_periodo = 1
group by 1,2
*/