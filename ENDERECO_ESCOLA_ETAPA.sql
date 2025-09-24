select 
2023 nr_anoletivo,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
nm_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
tlf.nm_bairro,
tlf.nm_logradouro,
tlf.ds_numero,
tlf.ds_complemento,
tlf.nr_cep,
tut.ds_email_corporativo,
tut.ds_email_alternativo,
tut.ds_telefone1,
tut.ds_telefone2
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = true and tmc.nm_municipio ilike '%MORADA NOVA%'
and tut.ci_unidade_trabalho in (select distinct tt.cd_unidade_trabalho from academico.tb_turma tt 
									   where tt.nr_anoletivo = 2023 
									   and tt.cd_prefeitura = 0 
									   and cd_nivel = 27
									   and tt.fl_tipo_seriacao = 'RG')
ORDER BY 1,2,4,6,8;
