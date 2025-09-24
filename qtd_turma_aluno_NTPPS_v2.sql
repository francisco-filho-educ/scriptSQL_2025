with 
turmas as (
select *
from academico.tb_turma tt
where tt.nr_anoletivo = 2022
and cd_nivel in (26,27,28)
and cd_prefeitura= 0
and ci_turma in (select distinct cd_turma from academico.tb_turmadisciplina ttd where ttd.cd_turma = tt.ci_turma and tt.nr_anoletivo = ttd.nr_anoletivo and  ttd.cd_disciplina in (101709,100482))
) --select count(distinct cd_unidade_trabalho )from turmas
,enturmacao as (
select 
cd_aluno,cd_turma
from academico.tb_ultimaenturmacao tu 
where exists (select 1 from turmas t where ci_turma = cd_turma)
and tu.fl_tipo_atividade <> 'AC'
)-- select count(1 )from enturmacao 
,escolas as (
SELECT
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria)  AS ds_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = TRUE 
) select ds_localizacao,COUNT(1) from escolas group by 1
select 
id_escola_sige,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
ds_categoria,
id_escola_inep,
nm_escola,
ds_localizacao,
case when cd_etapa = 162 then 10
	 when cd_etapa = 163 then 11 else 12 end cd_ano_serie,
count(1) nr_aluno
from enturmacao 
join turmas on ci_turma = cd_turma 
join escolas on id_escola_sige = cd_unidade_trabalho 
group by 1,2,3,4,5,6,7,8,9