with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2021 
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
  where tu.nr_anoletivo = 2021 
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ), vacina as (
  select 
  cd_turma,
  tca.cd_aluno,
  max(tca.cd_etapa_vacina) cd_etapa_vacina
  from aluno_online.tb_condicao_acesso tca 
  where 
exists (select 1 from ult_ent t where t.cd_turma = tca.cd_turma and t.cd_aluno = tca.cd_aluno)
group by 1,2
  )  
 select 
nr_anoletivo,
cd_unidade_trabalho,
ut.cd_turma,
ut.cd_aluno,
cd_nivel,
cd_etapa,
ds_etapa,
ds_ofertaitem,
cd_etapa_vacina
from ult_ent ut
join turma tt on ci_turma = ut.cd_turma
join academico.tb_etapa et on et.ci_etapa = tt.cd_etapa 
left join vacina v on tt.ci_turma = v.cd_turma and v.cd_aluno = ut.cd_aluno

