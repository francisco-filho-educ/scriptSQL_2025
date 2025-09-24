drop table if exists public.tb_infrequencia_aluno_disc_2023;
create table public.tb_infrequencia_aluno_disc_2023 as (
with turmas as (
select
nr_anoletivo,
ci_turma,
ds_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_turno,
cd_unidade_trabalho
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2023
and tt.fl_tipo_seriacao = 'RG' and tt.cd_tpensino = 1 
and tt.fl_ativo = 'S'
--and tt.cd_modalidade <> 38
and cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) 
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27 --and ci_turma = 887127
--and tt.cd_unidade_trabalho = 593
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
                 and tut.cd_dependencia_administrativa = 2 )
) --select count(1) from turma
, enturmados as (
select 
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
where tu.nr_anoletivo = 2023
and tu.fl_tipo_atividade <> 'AC'
and exists (select 1 from turmas t where t.ci_turma = tu.cd_turma) 
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
	max(coalesce(nr_aulas,0)) nr_aulas 
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
et.cd_aluno,
a.nr_mes,
a.cd_disciplina,
cd_grupodisciplina,
coalesce(nr_aulas,0) nr_aulas,
coalesce(nr_faltas,0) nr_faltas
from enturmados et
join aulas a on a.cd_turma = et.cd_turma
join disciplinas td2 on ci_disciplina = a.cd_disciplina
left join faltas f on a.cd_turma=f.cd_turma and f.cd_disciplina = a.cd_disciplina and a.nr_mes = f.nr_mes and et.cd_aluno = f.cd_aluno
);