with tempo_aula as (
SELECT  
distinct tha.cd_unidade_trabalho 
--FROM academico.tb_horarioaula tha -- todas as aulas, eletivas e não eletivas
FROM academico.tb_tempo_eletivo tha -- somente eletivas
WHERE tha.nr_anoletivo=2022 AND tha.nr_aula IN (98,99) -- nr_aula: 1ª aula a 5ª aula é  tempo normal, 98 e 99 aulas no contraturno 
)
SELECT 
2022 nr_ano_sige,
crede.ci_unidade_trabalho, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
nm_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao
--tut.cd_situacao_funcionamento,
--tsf.nm_situacao_funcionamento
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
join tempo_aula ta on ta.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
and tut.cd_categoria not in (8,9,6)
AND tlut.fl_sede = TRUE 