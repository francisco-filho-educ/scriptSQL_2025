SELECT 
crede.ci_unidade_trabalho id_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) nm_municipio,
upper(tc.nm_categoria) nm_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
tu.cd_turma,
tt.ds_turma,
tt.ds_ofertaitem,
te.ds_etapa,
tn.ds_turno,
tu.cd_aluno,
ta.nm_aluno,
ta.dt_nascimento
from academico.tb_ultimaenturmacao tu 
join academico.tb_aluno ta on ta.ci_aluno = tu.cd_aluno 
join academico.tb_turma tt on tt.ci_turma = tu.cd_turma
join academico.tb_etapa te on te.ci_etapa = tt.cd_etapa
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno
join academico.tb_nivel nv on nv.ci_nivel = tt.cd_nivel 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho =  tt.cd_unidade_trabalho 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
where
tt.nr_anoletivo = 2024
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tt.fl_ativo = 'S'
and tu.fl_tipo_atividade <> 'AC'
and tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
ORDER BY 1,3,4,6;
