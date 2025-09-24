with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
ds_turma,
ds_turno,
cd_unidade_trabalho
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno
where
tt.nr_anoletivo = 2022 
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and cd_etapa in(164,186,190)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
),
ult_ent as (
  select
  cd_aluno,
  cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2022 
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ), 
  aluno_inep as (
  select 
  et.cd_aluno,
  et.cd_turma, 
  ta.cd_inep_aluno, 
  nm_aluno
  from academico.tb_aluno ta 
  join ult_ent et on ta.ci_aluno = et.cd_aluno 
  where ta.ci_aluno is not null and ta.inep_atualizado 
  ) --select count(1) from   aluno_inep 
  , export_inep as (
  select 
  et.cd_aluno,
  et.cd_turma, 
  p.id_censo cd_inep_aluno,  
  nm_aluno
  from academico.tb_aluno ta  --106343  
  join ult_ent et on ta.ci_aluno = et.cd_aluno 
  join educacenso_exp.tb_pessoa_receita p on p.nr_cpf =ta.nr_cpf and nm_aluno = nm_pessoa
  where not exists (select 1 from aluno_inep et where et.cd_aluno = ta.ci_aluno)
  )select count(1) from  export_inep
   , aluno_s_inep as (
  select 
  et.cd_aluno,
  et.cd_turma, 
  ta.cd_inep_aluno, 
  nm_aluno
  from academico.tb_aluno ta  --106343  
  join ult_ent et on ta.ci_aluno = et.cd_aluno 
  where not exists (select 1 from aluno_inep et where et.cd_aluno = ta.ci_aluno)
  and not exists (select 1 from export_inep et where et.cd_aluno = ta.ci_aluno)
  )
  ,aluno_inep_total as (
  select * from export_inep
  union 
  select * from  aluno_inep
  union 
  select * from  aluno_s_inep
  )
select 
cd_unidade_trabalho,
cd_turma,
cd_etapa,
ds_ofertaitem, 
ds_turma,
ds_turno,
cd_aluno,
cd_inep_aluno
from aluno_inep_total i
join turma tt on tt.ci_turma = i.cd_turma
  /*
select
tut.cd_unidade_trabalho_pai id_crede_sefor,
tutpai.nm_sigla nm_crede_sefor, 
tl.ci_municipio_censo id_municipio,
tl.nm_municipio nm_municipio, 
tut.nr_codigo_unid_trab id_escola,
tut.nm_unidade_trabalho nm_escola,
tc.nm_categoria,
cd_turma,
cd_etapa,
ds_ofertaitem, 
ds_turma,
ds_turno,
cd_aluno,
cd_inep_aluno
  from aluno_inep_total i
  join turma tt on tt.ci_turma = i.cd_turma
  join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
join rede_fisica.tb_unidade_trabalho tutpai on tut.cd_unidade_trabalho_pai = tutpai.ci_unidade_trabalho 
join rede_fisica.tb_local_unid_trab tlu on tlu.cd_unidade_trabalho  = tut.ci_unidade_trabalho 
join rede_fisica.tb_local_funcionamento tlf on tlu.cd_local_funcionamento  = tlf.ci_local_funcionamento 
join util.tb_municipio_censo tl on tlf.cd_municipio_censo = tl.ci_municipio_censo
join rede_fisica.tb_categoria tc on tc.ci_categoria = tut.cd_categoria
where
tut.cd_situacao_funcionamento = 1 
and tlu.fl_sede = true
and tut.cd_tipo_unid_trab = 401
*/

