SELECT nr_anoletivo,nr_ano,nr_mes,cd_turma,cd_aluno,sum(nr_aulas)nr_aulas,sum(nr_aulas)-sum(nr_faltas) nr_frequencia
FROM (	SELECT taft.nr_anoletivo,taft.nr_ano,taft.nr_mes,taft.cd_turma,taft.cd_disciplina,tue.cd_aluno,taft.nr_aulas,
	coalesce(taf.nr_faltas, 0)AS nr_faltas
	FROM academico.tb_ultimaenturmacao tue
	JOIN (	SELECT taft.nr_anoletivo,nr_ano,nr_mes,cd_turma,cd_disciplina,max(nr_aulas)AS nr_aulas
		FROM academico.tb_alunofrequencia_total_aulas_mes taft
		JOIN academico.tb_turma tt ON tt.nr_anoletivo = taft.nr_anoletivo
			AND tt.ci_turma = taft.cd_turma
		WHERE tt.nr_anoletivo = 2024 --ANO LETIVO
			AND tt.cd_unidade_trabalho=678 --ADAUTO BEZERRA
			AND taft.nr_mes< extract(month from current_date)
		GROUP BY 1,2,3,4,5
		)taft ON tue.nr_anoletivo = taft.nr_anoletivo
	AND tue.cd_turma = taft.cd_turma
	LEFT
	JOIN (	SELECT tt.nr_anoletivo,nr_ano,nr_mes,tue.cd_turma,cd_disciplina,tue.cd_aluno,max(nr_faltas)AS nr_faltas
		FROM academico.tb_ultimaenturmacao tue
		JOIN academico.tb_turma tt ON tue.nr_anoletivo = tt.nr_anoletivo
			AND tue.cd_turma = tt.ci_turma
			AND tt.fl_tipo_seriacao = tue.fl_tipo_atividade
		JOIN academico.tb_alunofrequencia taf ON taf.nr_anoletivo = tt.nr_anoletivo
			AND taf.cd_aluno = tue.cd_aluno
		WHERE tt.nr_anoletivo = 2024 --ANO LETIVO
		AND tt.cd_unidade_trabalho=678 --ADAUTO BEZERRA
		GROUP BY 1,2,3,4,5,6
		)taf ON taft.nr_anoletivo = taf.nr_anoletivo
	AND taft.nr_ano = taf.nr_ano
	AND taft.nr_mes = taf.nr_mes
	AND taft.cd_turma = taf.cd_turma
	AND taft.cd_disciplina = taf.cd_disciplina
	AND taf.cd_aluno = tue.cd_aluno
	WHERE taft.nr_aulas != 0 
	) foo
WHERE foo.nr_mes=2 --MÊS DE REFERÊNCIA
GROUP BY 1,2,3,4,5;
