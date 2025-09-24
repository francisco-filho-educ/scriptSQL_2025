select --* from mat
2022 nr_anoletivo,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
--SALA DE AULA,
count(distinct case when ta.cd_tipo_ambiente = 3 then ta.ci_ambiente end) nr_salas,
--SECRETARIA, 
count(distinct case when ta.cd_tipo_ambiente = 69 then ta.ci_ambiente end) nr_secret,
--QUADRA, 
count(distinct case when ta.cd_tipo_ambiente in (52,74) then ta.ci_ambiente end) nr_quadra,
--BANHEIROS, 
count(distinct case when ta.cd_tipo_ambiente in (36,38,49,53,82) then ta.ci_ambiente end) nr_banheiro,
--VESTIÁRIOS, 
count(distinct case when ta.cd_tipo_ambiente =53 then ta.ci_ambiente end) nr_banheiro_chuveiro,
--COZINHA
count(distinct case when ta.cd_tipo_ambiente = 30 then ta.ci_ambiente end) nr_coz
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
join rede_fisica.tb_ambiente ta on ta.cd_local_funcionamento = ci_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
--and tut.cd_categoria =9
group by 1,2,3,4,5,6,7,8
ORDER BY 2,4,4,7;
