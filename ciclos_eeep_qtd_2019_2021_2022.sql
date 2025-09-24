with turmas as ( 
select 
t.nr_anoletivo,
t.cd_unidade_trabalho,
t.ci_turma,
t.cd_etapa,
cd_aluno
from academico.tb_turma t
join academico.tb_ultimaenturmacao tu2 on tu2.cd_turma = t.ci_turma
where t.nr_anoletivo >= 2019
and cd_prefeitura  = 0
and cd_nivel = 27
and cd_modalidade = 40
and cd_etapa in (184,185,186)
and fl_tipo_atividade <> 'AC'
),
ciclo_1 as (
select 
cd_unidade_trabalho,
count(case when cd_etapa  = 184 then cd_aluno end) serie_1_2019,
count(case when exists (select 1 from turmas t1 
								where t1.nr_anoletivo = 2020 
								and t1.cd_etapa = 185
								and t1.cd_aluno = t.cd_aluno 
								and t.cd_unidade_trabalho = t1.cd_unidade_trabalho) then cd_aluno end) serie_2_2020,
count(case when exists (select 1 from turmas t1 
								where t1.nr_anoletivo = 2021 
								and t1.cd_etapa = 186
								and t1.cd_aluno = t.cd_aluno 
								and t.cd_unidade_trabalho = t1.cd_unidade_trabalho) then cd_aluno end) serie_3_2021
from turmas t 
where nr_anoletivo = 2019
group by 1
),
ciclo_2 as (
select 
cd_unidade_trabalho,
count(case when cd_etapa  = 184  then cd_aluno end) serie_1_2020,
count(case when exists (select 1 from turmas t1 
								where t1.nr_anoletivo = 2021
								and t1.cd_etapa = 185
								and t1.cd_aluno = t.cd_aluno 
								and t.cd_unidade_trabalho = t1.cd_unidade_trabalho) then cd_aluno end) serie_2_2021,
count(case when exists (select 1 from turmas t1 
								where t1.nr_anoletivo = 2022
								and t1.cd_etapa = 186
								and t1.cd_aluno = t.cd_aluno 
								and t.cd_unidade_trabalho = t1.cd_unidade_trabalho) then cd_aluno end) serie_3_2022
from turmas t 
where nr_anoletivo = 2020
group by 1
)
,
ciclo_3 as (
select 
cd_unidade_trabalho,
count(case when cd_etapa  = 184  then cd_aluno end) serie_1_2021,
count(case when exists (select 1 from turmas t1 
								where t1.nr_anoletivo = 2022
								and t1.cd_etapa = 185
								and t1.cd_aluno = t.cd_aluno 
								and t.cd_unidade_trabalho = t1.cd_unidade_trabalho) then cd_aluno end) serie_2_2022,
count(case when exists (select 1 from turmas t1 
								where t1.nr_anoletivo = 2023
								and t1.cd_etapa = 186
								and t1.cd_aluno = t.cd_aluno 
								and t.cd_unidade_trabalho = t1.cd_unidade_trabalho) then cd_aluno end) serie_3_2023
from turmas t 
where nr_anoletivo = 2021
group by 1
)
SELECT 
crede.ci_unidade_trabalho, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
case when tut.cd_categoria is null then 'Não se aplica'
           when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
	       when  tut.ci_unidade_trabalho = 47258 then 'CREAECE' else upper(tc.nm_categoria) end AS ds_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
c.*
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
join ciclo_3 c on c.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
order by 1,3,7
