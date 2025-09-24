with turmas as ( 
select 
*
from academico.tb_turma t
where nr_anoletivo = 2023
and cd_prefeitura  = 0
and cd_nivel = 27
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = t.cd_unidade_trabalho)
)
,ult_ent as (
  select
  tu2.nr_anoletivo,
  cd_aluno, 
  cd_turma 
  from academico.tb_ultimaenturmacao tu2 
  where exists (select 1 from turmas t where tu2.cd_turma = t.ci_turma)
  and tu2.fl_tipo_atividade <> 'AC'
) 

select
id_crede_sefor cod_crede,
id_escola_inep cd_escola_inep,
nm_escola,
cd_turma,
ds_turma,
cd_turno,
ds_turno,
cd_etapa,
ds_etapa,
cd_aluno cd_aluno_sige,
ta.cd_inep_aluno cd_inep_aluno,
case when ta.fl_sexo = 'M' then 1 else 2 end cd_sexo,
case when ta.fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo,
cd_raca,
ds_raca,
case when exists (select 1 from academico.tb_aluno_deficiencia tad where tad.cd_aluno = ci_aluno ) then 'Sim' else 'Não' end possui_deficiencia,
case when ta.fl_bolsaescola = 'S' then 'Sim' else 'Não' end recebe_bolsa_familia,
case when ta.fl_transporte = 'S' then 'Sim' else 'Não' end usa_transporte
from academico.tb_aluno ta 
join ult_ent on cd_aluno = ci_aluno
join turmas tt on cd_turma = ci_turma
join academico.tb_turno on ci_turno = cd_turno
join academico.tb_etapa te on te.ci_etapa = cd_etapa
left join academico.tb_raca tr on tr.ci_raca = cd_raca 
join public.tb_dm_escola tde on tde.id_escola_sige = tt.cd_unidade_trabalho

/*
-- REPOR CD_RACA DE ALUNOS 
with turmas as ( 
select 
*
from academico.tb_turma t
where nr_anoletivo = 2023
and cd_prefeitura  = 0
and cd_nivel = 27
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = t.cd_unidade_trabalho)
)
,ult_ent as (
  select
  tu2.nr_anoletivo,
  cd_aluno, 
  cd_turma 
  from academico.tb_ultimaenturmacao tu2 
  where exists (select 1 from turmas t where tu2.cd_turma = t.ci_turma)
  and tu2.fl_tipo_atividade <> 'AC'
)
,aluno_raca as(
select
max(ta.ci_aluno)ci_aluno,
ta.nm_aluno,
ta.nm_mae,
ta.dt_nascimento::date::text
from academico.tb_aluno ta 
join academico.tb_ultimaenturmacao tu on cd_aluno = ci_aluno and tu.nr_anoletivo > 2021 and tu.fl_tipo_atividade <> 'AC'
where ta.cd_raca is not null
group by 2,3,4
)
,aluno_raca_r as (
select 
r.ci_aluno,
ta.nm_aluno,
ta.nm_mae,
ta.dt_nascimento::date::text
from academico.tb_aluno ta 
join ult_ent on cd_aluno = ci_aluno
join aluno_raca r on ta.nm_aluno = r.nm_aluno and ta.nm_mae = r.nm_mae and ta.dt_nascimento::date::text = r.dt_nascimento 
where ta.cd_raca is null --2109
)
select * from aluno_raca_r --where cd_raca is null

*/