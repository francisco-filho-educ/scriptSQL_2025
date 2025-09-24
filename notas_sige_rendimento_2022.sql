with turmas as ( 
select 
nr_anoletivo,
cd_unidade_trabalho,
ds_ofertaitem,
ci_turma
from academico.tb_turma t
where nr_anoletivo = 2022
and cd_prefeitura  = 0
and cd_nivel in (26,27,28)
and t.cd_unidade_trabalho = 593
),
ult_ent as (
  select
  tu2.nr_anoletivo,
  cd_aluno, 
  cd_turma 
  from academico.tb_ultimaenturmacao tu2 
  where exists (select 1 from turmas t where tu2.cd_turma = t.ci_turma)
  and tu2.fl_tipo_atividade <> 'AC'
) --select * from  ult_ent
, alunos as (
select 
t.nr_anoletivo,
cd_unidade_trabalho,
ds_ofertaitem,
a.ci_aluno cd_aluno,
cd_turma,
nm_aluno
from academico.tb_aluno a
join ult_ent on cd_aluno = ci_aluno
join turmas t on ci_turma = cd_turma
) --select count(1), count(distinct cd_aluno )  from alunos
,notas as (
select
cd_aluno,
cd_turma,
tg.ds_grupodisciplina,
cd_periodo,
max(taa.nr_nota) nr_nota
from academico.tb_alunoavaliacao taa
join academico.tb_disciplinas d on cd_disciplina=ci_disciplina
join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina =d.cd_grupodisciplina  
join ult_ent using(cd_aluno, cd_turma)
where taa.cd_periodo between 1 and 3
and nr_nota is not null 
group by 1,2,3,4
) 
select --count(1) from notas
nr_anoletivo,
nr_codigo_unid_trab,
nm_unidade_trabalho,
ds_ofertaitem,
ds_grupodisciplina,
cd_aluno,
nm_aluno,
avg(case when cd_periodo = 1 then  nr_nota end) nr_nota_1,
avg(case when cd_periodo = 2 then  nr_nota end) nr_nota_2,
avg(case when cd_periodo = 3 then  nr_nota end) nr_nota_3
from alunos
left join notas using(cd_aluno,cd_turma)
join rede_fisica.tb_unidade_trabalho ut on cd_unidade_trabalho = ci_unidade_trabalho
group by 1,2,3,4,5,6,7

