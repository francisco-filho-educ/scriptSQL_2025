with turma as (
select 
*
from academico.tb_turma tt 
join academico.tb_etapa te on te.ci_etapa = tt.cd_etapa 
where nr_anoletivo = 2023
and cd_nivel = 27 
and (cd_etapa in (214,164,186,190) or (cd_etapa = 173 and cd_anofinaleja = 2) ) and cd_etapa = 164 and tt.fl_ativo ='S' and ci_turma = 893568
)
  ,ult_ent as (
  select cd_aluno,max(ci_enturmacao) ci_enturmacao 
  from academico.tb_enturmacao te
  join turma t1 on ci_turma=cd_turma  and te.nr_anoletivo=t1.nr_anoletivo
  group by 1
  )
  , enturmados as (
  select *
  from academico.tb_enturmacao te2 
  join ult_ent using(cd_aluno,ci_enturmacao)
  ) 
  ,concluintes as (
  SELECT 
  t.nr_anoletivo, 
  t.cd_unidade_trabalho,
  te.cd_turma,
  te.cd_aluno
  from enturmados  te 
  join turma t on te.cd_turma = t.ci_turma 
  left join academico.tb_resultado trs ON trs.cd_aluno = te.cd_aluno and te.cd_turma = trs.cd_turma
  where
  t.nr_anoletivo =  2023
  and cd_tiporesultado in (1,2,6)
  )
  --select count(1) from concluintes 
  ,alunos as (
    select 
    ci_aluno cd_aluno,
    nm_aluno,
    dt_nascimento::text,
    nm_mae filiacao_1,
    nm_pai filiacao_2,
    nr_cpf::numeric,
    ta.cd_municipio_nascimento
    from academico.tb_aluno ta 
    where exists (select 1 from concluintes  where ci_aluno = cd_aluno)
    )
    select  * from concluintes 
    join alunos using(cd_aluno)
