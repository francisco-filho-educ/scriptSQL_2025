with enturmados as (
select 
	tt.nr_anoletivo,
	cd_turma,
	cd_unidade_trabalho,
	tt.ds_ofertaitem,
	cd_aluno
from academico.tb_turma tt
join academico.tb_ultimaenturmacao tu on tt.ci_turma = tu.cd_turma and tu.nr_anoletivo = 2024
where 
tt.nr_anoletivo = 2024
and tt.cd_nivel in (26,27)
and tt.cd_modalidade <> 38
and tu.fl_tipo_atividade <> 'AC'
) 
,alunos as (
select
	ci_aluno cd_aluno,
	nm_aluno,
	dt_nascimento::text,
	ta.fl_sexo,
	ta.nm_mae,
	ta.nm_pai,
	ta.nr_cpf,
	ta.nr_cia,
	ta.nr_identificacao_social,
	ta.cd_municipio_nascimento 
from academico.tb_aluno ta 
where ci_aluno in (select cd_aluno from  enturmados)
)
select 
	nr_anoletivo,
	cd_turma,
	ds_ofertaitem,
	cd_unidade_trabalho id_escola_sige,
	tl.ds_localidade nm_municipio_nascimento,
	ta.*
from enturmados e
join alunos ta using(cd_aluno)
left join util.tb_localidades tl on tl.ci_localidade = ta.cd_municipio_nascimento 
