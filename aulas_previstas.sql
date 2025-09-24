SELECT tda.cd_turma,
tda.cd_disciplina,
tda.nr_mes_aula,
count(*)as aulasPrevistas
FROM academico.tb_dia_aula tda
JOIN academico.tb_turmadisciplina ttd on ttd.cd_turma = tda.cd_turma and ttd.cd_disciplina = tda.cd_disciplina 
	and (ttd.nr_semestre = tda.nr_semestre or ttd.nr_semestre = 0) and ttd.nr_anoletivo = tda.nr_anoletivo and ttd.fl_ativo like 'S'
where 1=1
    AND tda.nr_anoletivo = 2024
    and tda.cd_unidade_trabalho = 517 --PARÂMETRO DA ESCOLA
group by tda.cd_turma,tda.cd_disciplina,tda.nr_mes_aula