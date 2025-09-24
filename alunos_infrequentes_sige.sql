with 
turmas as (
	select * from academico.tb_turma 
	where nr_anoletivo = 2021
	and cd_prefeitura = 0
	and cd_etapa in (162,163,164,184,185,186,187,188,189,190,191)
	--and cd_unidade_trabalho = 57 
    --and ci_turma =  752317 
)
,enturmados as (
	select cd_aluno,cd_turma 
	from academico.tb_ultimaenturmacao e
	where e.nr_anoletivo = 2021
	and  exists(select 1 from turmas t where t.ci_turma=e.cd_turma)
	and e.fl_tipo_atividade <>'AC'
) --select count(1) nr_aulas, count(distinct cd_turma) nr_t from enturmados --333039	8782
,aulas as (
	select
	cd_turma, 
	nr_mes,
	1 fl_registro,
	sum(nr_aulas) nr_aulas
	from academico.tb_alunofrequencia_total_aulas_mes aftam 
	where 
	nr_anoletivo = 2021
	and exists(select 1 from enturmados ent where ent.cd_turma=aftam.cd_turma)
	and aftam.nr_mes = 9
	group by 1,2,3--- order by 1
),faltas as (
	select 
	af.cd_aluno, 
	af.cd_turma,
	nr_mes, 
	sum(nr_faltas) nr_faltas
	--count(1)
	from rendimento.tb_alunofrequencia_2021 af
	join enturmados ent on ent.cd_turma=af.cd_turma and ent.cd_aluno = af.cd_aluno
	where
	nr_anoletivo  = 2021
	--and exists(select 1 from enturmados ent where ent.cd_turma=af.cd_turma and ent.cd_aluno = af.cd_aluno)
	and af.nr_mes = 9
	group by 1,2,3 order by 2
), aulas_faltas as(
select
  t.nr_anoletivo,
  t.cd_unidade_trabalho,
  e.cd_turma,
  t.cd_turno,
  t.cd_etapa,
  e.cd_aluno,
  a.nr_mes,
  fl_registro,
  coalesce(a.nr_aulas,0) nr_aulas,
  coalesce(f.nr_faltas,0) nr_faltas
from enturmados e
join turmas t on e.cd_turma=t.ci_turma
left join aulas a on a.cd_turma=e.cd_turma
left join faltas f on a.cd_turma=f.cd_turma and f.cd_aluno = e.cd_aluno
)
select /*
nr_anoletivo,
crede.ci_unidade_trabalho cd_crede,
crede.nm_sigla,
count(1) nr_alunos,
sum(case when nr_aulas<=nr_faltas then 1 else 0 end)nr_infreq,
sum(case when nr_aulas<=nr_faltas then 1 else 0 end)/count(1)::numeric *100 p_inferq	
from rede_fisica.tb_unidade_trabalho tut 
join rede_fisica.tb_unidade_trabalho crede on crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai 
join aulas_faltas aft on aft.cd_unidade_trabalho = tut.ci_unidade_trabalho 
where tut.cd_dependencia_administrativa = 2
and fl_registro is not null
group by 1,2,3
union 
select 
nr_anoletivo,
0 cd_crede,
'CEARÁ' nm_sigla,
count(1) nr_alunos,
sum(case when nr_aulas<=nr_faltas then 1 else 0 end)nr_infreq,
sum(case when nr_aulas<=nr_faltas then 1 else 0 end)/count(1)::numeric *100 p_inferq*/
count(distinct cd_turma )
from rede_fisica.tb_unidade_trabalho tut 
join rede_fisica.tb_unidade_trabalho crede on crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai 
join aulas_faltas aft on aft.cd_unidade_trabalho = tut.ci_unidade_trabalho 
where tut.cd_dependencia_administrativa = 2
--and fl_registro is not null
--group by 1,2,3
--order by 1,2

/*
select * from INFORMATION_SCHEMA.COLUMNS 
where COLUMN_NAME like '%aluno%' 
order by TABLE_NAME
*/
--select 8776- 7933


