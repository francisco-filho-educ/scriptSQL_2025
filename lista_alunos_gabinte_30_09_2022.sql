--LISTA ALUNOS NÃO CONCLUÍNTES MATRICULADOS EM 2021 E NÃO LOCALIZADOS EM 2022
--Seleciona as turmas e alunos da rede estadual dos anos analizados
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
and t.cd_unidade_trabalho in (235,223,234,220,233)
),
ult_ent as (
  select
  tu2.nr_anoletivo,
  cd_aluno, 
  cd_turma 
  from academico.tb_ultimaenturmacao tu2 
  where exists (select 1 from turmas t where tu2.cd_turma = t.ci_turma)
  and tu2.fl_tipo_atividade <> 'AC'
) --select count(1) from  ult_ent
, alunos as (
select 
cd_unidade_trabalho,
ds_ofertaitem,
a.ci_aluno cd_aluno,
nm_aluno,
nm_mae,
to_char(a.dt_nascimento,'dd/mm/yyyy') dt_nascimento,
tl.ds_localidade nm_municipio,
a.ds_logradouro,
a.ds_numero,
a.ds_complemento,
ds_bairro,
a.ds_cep,
concat(a.nr_ddd_celular,'-', a.nr_fone_celular,' / ',
a.nr_ddd_residencia,'-',a.nr_fone_residencia) contato 
from academico.tb_aluno a
join ult_ent on cd_aluno = ci_aluno
join turmas on ci_turma = cd_turma
left join util.tb_bairros tb on tb.ci_bairro = a.cd_bairro 
left join util.tb_localidades tl on tl.ci_localidade = a.cd_municipio
)
select/*
crede.nm_sigla  nm_crede_sefor,
tmc.nm_municipio,
tut.nr_codigo_unid_trab id_escola,
tut.nm_unidade_trabalho nm_escola,
nm_categoria,
tlz.nm_localizacao_zona,
ds_ofertaitem,
cd_aluno,
nm_aluno,
nm_mae,
dt_nascimento,
a.nm_municipio,
a.ds_logradouro,
a.ds_numero,
a.ds_complemento,
a.ds_bairro,
a.ds_cep,
a.contato*/ COUNT(1), COUNT(distinct A.CD_ALUNO)
from  rede_fisica.tb_unidade_trabalho tut
join alunos  a on tut.ci_unidade_trabalho = a.cd_unidade_trabalho 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
where 
tut.cd_dependencia_administrativa::int = 2
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
--and tut.nr_codigo_unid_trab in ('23025034','23024631','23185287','23024658','23025263')
