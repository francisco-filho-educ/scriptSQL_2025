with mat as (
select 
tt.cd_unidade_trabalho,
ds_ofertaitem,
cd_aluno
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on tt.ci_turma = cd_turma
join academico.tb_etapa te on te.ci_etapa = cd_etapa
where cd_prefeitura =0
and tu.fl_tipo_atividade <>'AC'
and tu.nr_anoletivo = 2021
and tt.cd_nivel in(26,27,28)
), movimento as (
select 
cd_aluno, 
max(tm.ci_movimento) ci_movimento
from academico.tb_movimento tm 
where nr_anoletivo = 2021
and tm.cd_situacao = 2
and  tm.cd_situacaoanterior <> 2
and exists (select 1 from mat where mat.cd_aluno = tm.cd_aluno)
group by 1
), data_matricula as (
select 
tm2.cd_aluno,
to_char(tm2.dt_criacao::date,'dd/mm/yyyy') dt_matricula
from academico.tb_movimento tm2
join movimento using(ci_movimento,cd_aluno)
where tm2.nr_anoletivo = 2021
), --select *  from data_matricula
alunos as (
select 
ci_aluno cd_aluno, nm_aluno nm_pessoa, nm_mae,nr_cpf cpf, dt_nascimento::text
from academico.tb_aluno ta
where exists (select 1 from mat where mat.cd_aluno = ci_aluno)
) 
SELECT 
crede.ci_unidade_trabalho, 
crede.nm_sigla, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab, 
tut.nm_unidade_trabalho,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
mat.cd_unidade_trabalho,
ds_ofertaitem,
a.cd_aluno,
dt_matricula,
nm_pessoa, 
nm_mae,
cpf, 
dt_nascimento
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
left join data_matricula dm on dm.cd_aluno = mat.cd_aluno
join alunos a on mat.cd_aluno = a.cd_aluno  
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
ORDER BY 1,3,4,6;