-- SIGE----

with infra as (
select --* from mat
2023 nr_anoletivo,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
--1. Biblioteca
max(case when ta.cd_tipo_ambiente in (13,15) then 1 else 0 end) IN_BIBLIOTECA,
--2. Quadra
max(case when ta.cd_tipo_ambiente in (52,74)  then 1 else 0 end) IN_QUADRA_ESPORTES,
--3. Sala dos professores 
max(case when ta.cd_tipo_ambiente in (25,119)  then 1 else 0 end) IN_SALA_PROFESSOR,
--4. Lei
max(case when tta.cod_censo = 3  then 1 else 0 end) IN_LABORATORIO_INFORMATICA,
--5. Lec
--max(case when tamb.cd_tipo_ambiente in (19,20,21,71,22,115,118)  then cd_tipo_ambiente end) fl_lec
max(case when tta.cod_censo = 4  then 1 else 0 end) IN_LABORATORIO_CIENCIAS
--select count(distinct tut.ci_unidade_trabalho)
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
join rede_fisica.tb_ambiente ta on ta.cd_local_funcionamento = ci_local_funcionamento
join rede_fisica.tb_tipo_ambiente tta on tta.ci_tipo_ambiente = ta.cd_tipo_ambiente 
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
--and tut.cd_categoria =9
group by 1,2,3,4,5,6,7,8
) 
select 
nr_anoletivo,
cd_crede_sefor,
nm_crede_sefor,
nm_municipio,
nm_categoria,
id_escola_inep,
nm_escola,
nm_localizacao_zona,
--1. Biblioteca
case when IN_BIBLIOTECA = 1 then 'Sim' else 'Não' end bib_sige,
--2. Quadra
case when IN_QUADRA_ESPORTES = 1  then 'Sim' else 'Não' end quadra_sige,
--3. Sala dos professores 
case when IN_SALA_PROFESSOR = 1  then 'Sim' else 'Não' end sala_prof_sige,
--4. Lei
case when IN_LABORATORIO_INFORMATICA = 1  then 'Sim' else 'Não' end lei_sige,
--5. Lec
case when IN_LABORATORIO_CIENCIAS = 1  then 'Sim' else 'Não' end lec_sige
from infra
ORDER BY 2,4,4,7;

-- CENSO ESCOLAR -----
select 
tte.co_entidade,
--1. Biblioteca
case when IN_BIBLIOTECA = 1 or IN_BIBLIOTECA_SALA_LEITURA = 1 then 'Sim' else 'Não' end bib_censo,
--2. Quadra
case when IN_QUADRA_ESPORTES = 1  then 'Sim' else 'Não' end quadra_censo,
--3. Sala dos professores 
case when IN_SALA_PROFESSOR = 1  then 'Sim' else 'Não' end sala_prof_censo,
--4. Lei
case when IN_LABORATORIO_INFORMATICA = 1  then 'Sim' else 'Não' end lei_censo,
--5. Lec
case when IN_LABORATORIO_CIENCIAS = 1  then 'Sim' else 'Não' end lec_censo
from censo_esc_d.tb_tb_escola_2023 tte 
where tp_dependencia = 2 
and tp_situacao_funcionamento = 1