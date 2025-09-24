SELECT crede.ci_unidade_trabalho,
 TRIM(crede.nm_sigla) AS "CREDE/SEFOR", 
 tut.nr_codigo_unid_trab AS "INEP", 
 tut.nm_unidade_trabalho AS "ESCOLA", 
 tt.ds_ofertaitem AS "OFERTA", 
 tt.ds_turma AS "TURMA", 
 ta.ci_aluno AS "MATRICULA", 
 ta.nm_aluno AS "ALUNO", 
 tu.nm_google_email AS "EMAIL"
--to_char(tue.dt_enturmacao,'dd/mm/yyyy') as "DATA ENTURMA��O"
FROM academico.tb_ultimaenturmacao tue
JOIN academico.tb_aluno ta ON ta.ci_aluno = tue.cd_aluno
JOIN academico.tb_turma tt ON tt.ci_turma = tue.cd_turma
JOIN rede_fisica.tb_unidade_trabalho tut ON tut.ci_unidade_trabalho = tt.cd_unidade_trabalho
	AND tut.cd_situacao_funcionamento = 1
	AND tut.cd_tipo_unid_trab = 401
	AND tut.cd_dependencia_administrativa = 2
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
LEFT JOIN google.tbg_usuarios tu ON tu.nr_matricula = ta.ci_aluno::TEXT
WHERE tue.nr_anoletivo = 2025
AND tue.fl_tipo_atividade <> 'AC'
GROUP BY 1,2,3,4,5,6,7,8,9
ORDER BY 1,4,5,6,8;
