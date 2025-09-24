SELECT tt.ds_ofertaitem, 
	(
		SELECT split_part(tt2.ds_ofertaitem,'|', 1) || ' ' || tt2.ds_turma 
		FROM academico.tb_ultimaenturmacao tue,academico.tb_turma tt2 
		WHERE tt2.ci_turma = tue.cd_turma 
		AND tt2.nr_anoletivo = tue.nr_anoletivo 
		AND tt2.nr_anoletivo = tt.nr_anoletivo 
		AND tt2.fl_tipo_seriacao <> 'AC' 
		AND tue.cd_aluno=tea.cd_aluno 
		AND tt2.cd_unidade_trabalho= 545 
		ORDER BY tue.ci_enturmacao desc LIMIT 1
	) AS ds_turma, 
	ta.ci_aluno, 
	ta.nm_aluno, 
	tta.ci_turma_atividade, 
	taae.ci_alunoavaliacao_eletiva, 
	taae.nr_frequencia, 
	taae.nr_nota 
FROM academico.tb_enturmacao_atividade tea 
JOIN academico.tb_turma tt on tt.ci_turma = tea.cd_turma 
JOIN academico.tb_etapa te on te.ci_etapa = tt.cd_etapa 
JOIN academico.tb_turma_atividade tta on tta.ci_turma_atividade = tea.cd_turma_atividade 
JOIN academico.tb_aluno ta on ta.ci_aluno = tea.cd_aluno 
LEFT JOIN academico.tb_alunoavaliacao_eletiva taae on taae.cd_turma_atividade = tta.ci_turma_atividade 
	AND taae.cd_aluno = tea.cd_aluno 
WHERE tea.cd_turma_atividade = 197580 
ORDER by 4;