with turma as (
select
cd_unidade_trabalho,
nr_anoletivo,
ci_turma,
ds_anofinaleja,
tt.cd_nivel,
tt.cd_etapa,
ds_etapa,
ds_turma,
ds_turno
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
join academico.tb_etapa te on cd_etapa = ci_etapa
where
tt.nr_anoletivo = 2024
and tt.cd_nivel  in (27,26)
and cd_etapa in (213,214,195,194,175,196,174,173,176)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
            and tut.cd_dependencia_administrativa = 2 ) -- municipal e estadual
)
,ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turma t on ci_turma=cd_turma 
  where e.nr_anoletivo=2024 --- ANO LETIVO
        and dt_enturmacao::date<='2024-02-01'  -- DATA DA ENTURMAÇAO > DATA DA DESENTURMAÇAO OU ESTA DEVE SER NULA
        and (dt_desenturmacao::date>'2024-02-01' or dt_desenturmacao is null)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,cd_turma
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join turma t on cd_turma=ci_turma 
) 
,alunos as (
select 
ci_aluno cd_aluno,
nm_aluno,
extract(year from AGE('2024-05-31'::date,ta.dt_nascimento)) nr_idade,
to_char(ta.dt_nascimento,'dd/mm/yyyy') dt_nascimento
from academico.tb_aluno ta 
where exists (select 1 from ult_ent where cd_aluno = ci_aluno)
) 
select 
t.nr_anoletivo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
tde.ds_categoria,
ci_turma,
ds_turma,
ds_etapa,
ds_turno,
a.*
from turma t
join ult_ent on ci_turma = cd_turma
join alunos a using(cd_aluno)
join dw_sige.tb_dm_escola tde on tde.id_escola_sige = cd_unidade_trabalho 
order by 1


