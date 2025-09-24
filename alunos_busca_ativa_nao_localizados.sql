--LISTA ALUNOS NÃO CONCLUÍNTES MATRICULADOS EM 2021 E NÃO LOCALIZADOS EM 2022
--Seleciona as turmas e alunos da rede estadual dos anos analizados
with turmas as ( 
select 
nr_anoletivo,
cd_unidade_trabalho,
ci_turma cd_turma,
cd_etapa, 
ds_ofertaitem
from academico.tb_turma t
where nr_anoletivo >2020
and cd_prefeitura  = 0
and cd_nivel in (26,27)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = t.cd_unidade_trabalho and tut.cd_unidade_trabalho_pai = 6)
),
ult_ent as (
  select
  tu2.nr_anoletivo,
  cd_aluno, 
  cd_turma 
  from academico.tb_ultimaenturmacao tu2 
  where exists (select 1 from turmas t where tu2.cd_turma = t.cd_turma)
  and tu2.fl_tipo_atividade <> 'AC'
) --select count(1) from  ult_ent
-- Lista os alunos concluintes do ano anterior
,ultimomovimento as (
select cd_aluno,max(ci_movimento) ci_movimento
from academico.tb_movimento tu  where nr_anoletivo  = 2021
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tu.cd_unidade_trabalho_destino and tut.cd_dependencia_administrativa = 2)
and exists (select 1 from ult_ent ut  where ut.cd_aluno = tu.cd_aluno)
group by 1
)
  ,concluintes as (
  SELECT 
  tum.cd_aluno,
  1 fl_concluinte
  from academico.tb_movimento tum 
  join ultimomovimento using(ci_movimento)
  inner join academico.tb_resultado trs ON trs.cd_aluno = tum.cd_aluno
  join academico.tb_turma t on trs.cd_turma = ci_turma
  where tum.nr_anoletivo =2021 
  and t.cd_etapa in (164,186,190,191) -- Aprovados no (3º e 4º serie EM)
  and trs.cd_tiporesultado in (1,2,6)
  ) --select count(1) from concluintes
-- Seleciona as informações gerais do aluno residentes nos bairros alvos
, alunos as (
select 
a.ci_aluno cd_aluno,
nm_aluno,
nm_mae,
nm_pai,
to_char(a.dt_nascimento,'dd/mm/yyyy') dt_nascimento,
tl.ds_localidade nm_municipio,
a.ds_logradouro,
a.ds_numero,
a.ds_complemento,
ds_bairro,
a.ds_cep,
a.nr_fone_celular,
a.nr_fone_residencia,
a.nr_fone_residencia_responsavel,
a.nr_fone_celular_responsavel
from academico.tb_aluno a
left join util.tb_bairros tb on tb.ci_bairro = a.cd_bairro 
left join util.tb_localidades tl on tl.ci_localidade = a.cd_municipio
where exists (select 1 from ult_ent ut where ut.cd_aluno = a.ci_aluno and ut.nr_anoletivo = 2021)
and a.cd_bairro in (39151,1002,1045,38414,1004,38399,1008,1009,38424,38412,38420,40215,1019,38400,38418,1027,38409,1028,1032,38432,38374,1038,1041,1046,1052,38419,38456,38413,1059,38411,1061,1065)
and extract(year from age(a.dt_nascimento::date)) between 15 and 18
from academico.tb_aluno a
where exists (select 1 from ult_ent ut where ut.cd_aluno = a.ci_aluno and ut.nr_anoletivo = 2021)
--and a.cd_bairro in (39151,1002,1045,38414,1004,38399,1008,1009,38424,38412,38420,40215,1019,38400,38418,1027,38409,1028,1032,38432,38374,1038,1041,1046,1052,38419,38456,38413,1059,38411,1061,1065)
--and extract(year from age(a.dt_nascimento::date)) between 15 and 18
) --select count(1) from alunos
 ,mat as ( --gera a lista de alunos 
 select
 et.cd_turma,
 cd_unidade_trabalho,
 ds_ofertaitem,
 a.*,
 case when exists (select 1 from ult_ent et2 where et2.cd_aluno = et.cd_aluno and et2.nr_anoletivo = 2022  ) then 'LOCALIZADO EM 2022' else 'NÃO LOCALIZADO' end situacao
 from ult_ent et
 join turmas t on t.cd_turma=et.cd_turma
 join alunos a on a.cd_aluno= et.cd_aluno
 where 
 et.nr_anoletivo = 2021
 --and not exists (select 1 from ult_ent et2 where et2.cd_aluno = et.cd_aluno and et2.nr_anoletivo = 2022  ) -- retira os alunos matriculados em 2022
 and not exists (select 1 from concluintes c where c.cd_aluno = et.cd_aluno) --retira os alunos concluintes 
 ) --select *  from mat
select 
tut.cd_unidade_trabalho_pai id_crede_sefor,
crede.nm_sigla nm_crede_sefor,
tmc.ci_municipio_censo id_municipio,
nm_municipio,
tut.nr_codigo_unid_trab id_escola,
tut.nm_unidade_trabalho  nm_escola,
tc.nm_categoria,
mat.*
from  mat
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = mat.cd_unidade_trabalho 
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


