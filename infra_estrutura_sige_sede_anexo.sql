select
tta.ci_tipo_ambiente,
tta.nm_tipo_ambiente,
count(distinct ta.ci_ambiente) qtd_total,
count(distinct case when fl_sede then ta.ci_ambiente end ) qtd_sede,
count(distinct case when fl_sede<>TRUE then ta.ci_ambiente end ) qtd_extensao
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
--AND tlut.fl_sede = TRUE 
and tut.nr_codigo_unid_trab = '23016604'
--and tta.ci_tipo_ambiente in (36,13,71,18,6,54,74,25,3,53)
group by 1,2

-- LISTA DE ESC0LAS E LABORATORIOS
select
--tut.ci_unidade_trabalho,
2024 nr_anoletivo,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
case when tut.cd_tipo_unid_trab  = 402 then 'CCI' else  tc.nm_categoria end  nm_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
case when  ci_tipo_ambiente in (18,78) then 'LABORATÓRIO DE INFORMÁTICA' else  tta.nm_tipo_ambiente end ds_laboratorios
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
and ta.cd_tipo_ambiente in (18,19,20,21,71,78,116,22,113,114,115,118,122)
--and tut.nr_codigo_unid_trab = '23016604'
group by 1,2,3,4,5,6,7,8,9
order by cd_crede_sefor, nm_municipio,nm_escola




