-- RELATORIO ALUNO X FREQUENCIA
select  -- cruzamento aluno x ffrequencia
	nr_anoletivo,
	cd_grupodisciplina,
	ds_grupodisciplina, 
	cd_turma,
	ci_aluno,
	nr_ano,
	nr_mes,
	coalesce(ds_raca, 'não declarado') ds_raca,
	case when ta.fl_sexo = 'm' then 'masculino' else 'feminino' end ds_sexo, -- 1: masculino | 2: feminino 
	sum(nr_aulas)nr_aulas,
	sum(nr_frequencia)nr_frequencia
from academico.tb_aluno ta
left join academico.tb_aluno_deficiencia tad on tad.cd_aluno = ta.ci_aluno 
left join academico.tb_raca tr on tr.ci_raca = ta.cd_raca
join ( --- inicio 1º join
	select  --- calculo da frequencia
		nr_anoletivo,
		cd_aluno,
		cd_disciplina,
		cd_grupodisciplina,
		ds_grupodisciplina, 
		cd_turma,
		nr_ano,
		nr_mes,
		sum(nr_aulas)nr_aulas,
		sum(nr_aulas)-sum(nr_faltas) nr_frequencia
	from (	
		select -- cruzamento aulas x faltas 
		taft.nr_anoletivo,
		taft.nr_ano,
		taft.nr_mes,
		taft.cd_turma,
		taft.cd_disciplina,
		tue.cd_aluno,
		taft.nr_aulas,
		coalesce(taf.nr_faltas, 0) as nr_faltas
		from academico.tb_ultimaenturmacao tue
		join (	-- aulas   --- inicio 2º join
			select 
			taft.nr_anoletivo,
			nr_ano,
			nr_mes,
			cd_turma,
			cd_disciplina,
			max(nr_aulas)as nr_aulas
			from academico.tb_alunofrequencia_total_aulas_mes taft
			join academico.tb_turma tt on tt.nr_anoletivo = taft.nr_anoletivo and tt.ci_turma = taft.cd_turma
			where tt.nr_anoletivo = 2024 --ano letivo
				and tt.cd_unidade_trabalho=678 -- filtro de escola ---
				and taft.nr_mes< extract(month from current_date)
				and tt.cd_prefeitura = 0 
				and tt.cd_nivel = 27
			group by 1,2,3,4,5
			) taft on tue.nr_anoletivo = taft.nr_anoletivo -- fim 2º join 
		and tue.cd_turma = taft.cd_turma
		left join (	 --- inicio 3º join
			select --- faltas
			tt.nr_anoletivo,
			nr_ano,
			nr_mes,
			tue.cd_turma,
			cd_disciplina,
			tue.cd_aluno,
			max(nr_faltas)as nr_faltas
			from academico.tb_ultimaenturmacao tue
			join academico.tb_turma tt on tue.nr_anoletivo = tt.nr_anoletivo and tue.cd_turma = tt.ci_turma
			join academico.tb_alunofrequencia taf on taf.nr_anoletivo = tt.nr_anoletivo
				and taf.cd_aluno = tue.cd_aluno
			where tt.nr_anoletivo = 2024 --ano letivo
				and tt.fl_tipo_seriacao = tue.fl_tipo_atividade
				and tt.cd_prefeitura = 0 
				and tt.cd_nivel =27
				and tt.cd_unidade_trabalho=678 -- filtro de escola ---
			group by 1,2,3,4,5,6
			)  -- fim do 3º join 
			taf on taft.nr_anoletivo = taf.nr_anoletivo
		and taft.nr_ano = taf.nr_ano
		and taft.nr_mes = taf.nr_mes
		and taft.cd_turma = taf.cd_turma
		and taft.cd_disciplina = taf.cd_disciplina
		and taf.cd_aluno = tue.cd_aluno
	where taft.nr_aulas != 0 
	) foo -- fim do `from` calculo da frequencia 
	join academico.tb_disciplinas td on td.ci_disciplina = foo.cd_disciplina
	join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina = td.cd_grupodisciplina 
--where foo.nr_mes>=1 --mês de referência
group by 1,2,3,4,5,6,7,8) as freq on freq.cd_aluno = ta.ci_aluno -- fim do 1º join
group by 1,2,3,4,5,6,7,8,9


-- RELATÓRIO COMPLETO ----------------------------------------------------------------
select 
	tut.cd_unidade_trabalho_pai id_crede_sefor, 
	tutpai.nm_sigla nm_crede_sefor, 
	tl.ci_municipio_censo id_municipio,
	tl.nm_municipio nm_municipio, 
	tut.nr_codigo_unid_trab id_escola, 
	tut.nm_unidade_trabalho nm_escola, 
	nm_categoria, 
	tee.cd_newetapa cd_etapa,
	tee.ds_newetapa ds_etapa,
	tt2.ds_turno,
	tt.ds_turma,
	freq.*
from academico.tb_turma tt
join academico.tb_turno tt2 on tt.cd_turno = ci_turno
join academico.tb_etapa_etapamodalidade tee on tee.cd_etapa = tt.cd_etapa and tee.cd_modalidade = tt.cd_modalidade and tee.cd_nivel = tt.cd_nivel 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
join rede_fisica.tb_unidade_trabalho tutpai on tut.cd_unidade_trabalho_pai = tutpai.ci_unidade_trabalho 
join rede_fisica.tb_local_unid_trab tlu on tlu.cd_unidade_trabalho = tut.ci_unidade_trabalho 
join rede_fisica.tb_local_funcionamento tlf on tlu.cd_local_funcionamento = tlf.ci_local_funcionamento 
join util.tb_municipio_censo tl on tlf.cd_municipio_censo = tl.ci_municipio_censo
join rede_fisica.tb_categoria tc on tc.ci_categoria = tut.cd_categoria
join ( -- join  turma x escola frequencia
--
select  -- cruzamento aluno x ffrequencia
	nr_anoletivo,
	cd_grupodisciplina,
	ds_grupodisciplina, 
	cd_turma,
	ci_aluno,
	nr_ano,
	nr_mes,
	coalesce(ds_raca, 'não declarado') ds_raca,
	case when ta.fl_sexo = 'm' then 'masculino' else 'feminino' end ds_sexo, -- 1: masculino | 2: feminino 
	sum(nr_aulas)nr_aulas,
	sum(nr_frequencia)nr_frequencia
from academico.tb_aluno ta
left join academico.tb_aluno_deficiencia tad on tad.cd_aluno = ta.ci_aluno 
left join academico.tb_raca tr on tr.ci_raca = ta.cd_raca
join ( --- inicio 1º join
	select  --- calculo da frequencia
		nr_anoletivo,
		cd_aluno,
		cd_disciplina,
		cd_grupodisciplina,
		ds_grupodisciplina, 
		cd_turma,
		nr_ano,
		nr_mes,
		sum(nr_aulas)nr_aulas,
		sum(nr_aulas)-sum(nr_faltas) nr_frequencia
	from (	
		select -- cruzamento aulas x faltas 
		taft.nr_anoletivo,
		taft.nr_ano,
		taft.nr_mes,
		taft.cd_turma,
		taft.cd_disciplina,
		tue.cd_aluno,
		taft.nr_aulas,
		coalesce(taf.nr_faltas, 0) as nr_faltas
		from academico.tb_ultimaenturmacao tue
		join (	-- aulas   --- inicio 2º join
			select 
			taft.nr_anoletivo,
			nr_ano,
			nr_mes,
			cd_turma,
			cd_disciplina,
			max(nr_aulas)as nr_aulas
			from academico.tb_alunofrequencia_total_aulas_mes taft
			join academico.tb_turma tt on tt.nr_anoletivo = taft.nr_anoletivo and tt.ci_turma = taft.cd_turma
			where tt.nr_anoletivo = 2024 --ano letivo
				and tt.cd_unidade_trabalho=678 -- filtro de escola ---
				and taft.nr_mes< extract(month from current_date)
				and tt.cd_prefeitura = 0 
				and tt.cd_nivel = 27
			group by 1,2,3,4,5
			) taft on tue.nr_anoletivo = taft.nr_anoletivo -- fim 2º join 
		and tue.cd_turma = taft.cd_turma
		left join (	 --- inicio 3º join
			select --- faltas
			tt.nr_anoletivo,
			nr_ano,
			nr_mes,
			tue.cd_turma,
			cd_disciplina,
			tue.cd_aluno,
			max(nr_faltas)as nr_faltas
			from academico.tb_ultimaenturmacao tue
			join academico.tb_turma tt on tue.nr_anoletivo = tt.nr_anoletivo and tue.cd_turma = tt.ci_turma
			join academico.tb_alunofrequencia taf on taf.nr_anoletivo = tt.nr_anoletivo
				and taf.cd_aluno = tue.cd_aluno
			where tt.nr_anoletivo = 2024 --ano letivo
				and tt.fl_tipo_seriacao = tue.fl_tipo_atividade
				and tt.cd_prefeitura = 0 
				and tt.cd_nivel =27
				and tt.cd_unidade_trabalho=678 -- filtro de escola ---
			group by 1,2,3,4,5,6
			)  -- fim do 3º join 
			taf on taft.nr_anoletivo = taf.nr_anoletivo
		and taft.nr_ano = taf.nr_ano
		and taft.nr_mes = taf.nr_mes
		and taft.cd_turma = taf.cd_turma
		and taft.cd_disciplina = taf.cd_disciplina
		and taf.cd_aluno = tue.cd_aluno
	where taft.nr_aulas != 0 
	) foo -- fim do `from` calculo da frequencia 
	join academico.tb_disciplinas td on td.ci_disciplina = foo.cd_disciplina
	join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina = td.cd_grupodisciplina 
--where foo.nr_mes>=1 --mês de referência
group by 1,2,3,4,5,6,7,8) as freq on freq.cd_aluno = ta.ci_aluno -- fim do 1º join
group by 1,2,3,4,5,6,7,8,9

) as freq on freq.cd_turma = tt.ci_turma -- join  turma x escola x frequencia
--filtro escola x turma-----------------------------
where tt.nr_anoletivo = 2024 --ano letivo
and tt.cd_prefeitura = 0 
and tt.cd_nivel =27
and tt.cd_unidade_trabalho=678 -- filtro de escola ---
and tut.cd_tipo_unid_trab = 401
and tut.cd_dependencia_administrativa = 2