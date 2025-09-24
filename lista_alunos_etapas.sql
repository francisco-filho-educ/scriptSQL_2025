with anoletivo as (
select 
max(nr_anoletivo) nr_anoletivo
from academico.tb_turma
where nr_anoletivo > 2022
and cd_prefeitura = 0
), 
turma as (
select
tt.nr_anoletivo,
ci_turma cd_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho
from academico.tb_turma tt 
join anoletivo a on tt.nr_anoletivo = a.nr_anoletivo
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tt.cd_etapa in(162,184,188)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2
						--and tut.cd_unidade_trabalho_pai = 1 -- crede
						)
)
,ult_ent as (
  select
  cd_aluno,cd_turma
  from academico.tb_ultimaenturmacao tu 
  join anoletivo a on tu.nr_anoletivo = a.nr_anoletivo
  where 
  tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.cd_turma = tu.cd_turma)
  )
,alunos as (
select 
ci_aluno cd_aluno,	
nm_aluno,
to_char(dt_nascimento,'dd/mm/yyyy') dt_nascimento,	
nm_mae,
case when ta.fl_bolsaescola ilike 'S' then 'SIM' else 'NÃO' end benfps
from academico.tb_aluno ta 
where exists(select 1 from ult_ent et where  ta.ci_aluno = et.cd_aluno)
--and ta.fl_sexo ilike 'F'
),
mat as (
select * from turma 
		 join ult_ent using(cd_turma)
		 join alunos using(cd_aluno)
)
select  
nr_anoletivo,	
crede.ci_unidade_trabalho id_crede_sefor,
crede.nm_sigla nm_crede_sefor,	
nm_municipio,	
tut.nr_codigo_unid_trab id_escola_inep,	
tut.nm_unidade_trabalho	,
nm_categoria,	
ds_ofertaitem,
cd_aluno,	
nm_aluno,	
dt_nascimento,	
nm_mae,
cd_etapa 
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 