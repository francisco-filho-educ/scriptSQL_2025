with turma as (
select
*
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2013
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
),
ult_ent as (
  select
  cd_aluno,
  cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  )
  ,mat as(
    select 
    cd_aluno,
    cd_etapa,
    cd_unidade_trabalho,
    cd_turno,
    cd_turma,
     case when cd_etapa = 121 then 1
     when cd_etapa = 122 then 2
     when cd_etapa = 123 then 3
     when cd_etapa = 124 then 4
     when cd_etapa = 125 then 5
     when cd_etapa = 126 then 6
     when cd_etapa = 127 then 7
     when cd_etapa = 128 then 8
     when cd_etapa = 129 then 9
     when cd_etapa in(162,184,188) then 10 
     when cd_etapa in(163,185,189) then 11 
     when cd_etapa in(164,186,190) then 12 
     when cd_etapa in(165,187,191) then 13 else 99 end cd_ano_serie
    from ult_ent
    join turma on cd_turma = ci_turma
    )
    select
    tut.ci_unidade_trabalho id_escola_sige,
    tut.nr_codigo_unid_trab id_escola_unep,
    tut.cd_unidade_trabalho_pai id_crede_sefor,
    mat.*
    from rede_fisica.tb_unidade_trabalho tut 
    join mat on cd_unidade_trabalho  = tut.ci_unidade_trabalho 
    ---
    ---
  