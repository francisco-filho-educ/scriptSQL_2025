with 
turmas as (
	select * from academico.tb_turma tt
	where
	tt.nr_anoletivo = 2024
	and tt.fl_tipo_seriacao = 'RG' and tt.cd_tpensino = 1 
	and tt.cd_modalidade <> 38
	and tt.cd_prefeitura = 0
	and tt.cd_nivel = 27 
	and tt.cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191)
	--and ci_turma =964218
	and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
                  and tut.cd_dependencia_administrativa = 2   --and tut.ci_unidade_trabalho =47724              
	)
)
,enturmados as (
	select 
	cd_aluno,
	cd_turma 
	from academico.tb_ultimaenturmacao e
	where exists(select 1 from turmas t where t.ci_turma=e.cd_turma) --and cd_aluno = 3290058
)
,aulas as (
	select 
	cd_turma, 
	af.nr_mes, 
	td.cd_grupodisciplina, 
	sum(nr_aulas) nr_aulas 
	from academico.tb_alunofrequencia_total_aulas_mes af
	join academico.tb_disciplinas td on td.ci_disciplina = af.cd_disciplina and td.cd_grupodisciplina between 1 and 14
	where exists(select 1 from turmas t where ci_turma=af.cd_turma)
	and nr_aulas>0
	group by 1,2,3
)
,faltas as (
	select 
	cd_aluno, 
	cd_turma, 
	nr_mes, 
	td.cd_grupodisciplina,  
	avg(nr_faltas) nr_faltas 
	from academico.tb_alunofrequencia af
	join academico.tb_disciplinas td on td.ci_disciplina = af.cd_disciplina  and td.cd_grupodisciplina between 1 and 14
	where exists(select 1 from enturmados ent where ent.cd_turma=af.cd_turma and ent.cd_aluno = af.cd_aluno)
	group by 1,2,3,4
)
,frequencia as(
select
e.cd_turma,
a.nr_mes,
e.cd_aluno,
a.cd_grupodisciplina,
ds_grupodisciplina,
nr_aulas,
coalesce(nr_faltas,0) nr_faltas
from enturmados e
join turmas t on t.ci_turma = e.cd_turma
join aulas a on a.cd_turma=ci_turma
join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina =cd_grupodisciplina
left join faltas f on a.cd_turma=f.cd_turma and a.nr_mes = f.nr_mes and f.cd_grupodisciplina = a.cd_grupodisciplina
) 
select 
tut.cd_unidade_trabalho_pai id_crede_sefor, 
tutpai.nm_sigla nm_crede_sefor, 
tl.ci_municipio_censo id_municipio,
tl.nm_municipio nm_municipio, 
tut.nr_codigo_unid_trab id_escola, 
tut.nm_unidade_trabalho nm_escola, 
nm_categoria, 
te.ds_etapa, 
tt2.ds_turno, 
nr_mes, 
tt.nr_anoletivo,
e.cd_turma, 
ds_ofertaitem, 
ds_turma, 
e.cd_aluno, 
nm_aluno, 
to_char (dt_nascimento, 'DD/MM/YYYY') dt_nascimento, 
ta.fl_sexo, 
tr.ds_raca,
cd_grupodisciplina,
ds_grupodisciplina,
nr_aulas,
nr_faltas
from frequencia e
join turmas tt on tt.ci_turma = e.cd_turma
join academico.tb_aluno ta on e.cd_aluno = ci_aluno
join academico.tb_raca tr on cd_raca = ci_raca
join academico.tb_etapa te on tt.cd_etapa = ci_etapa
join academico.tb_turno tt2 on tt.cd_turno = ci_turno
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
join rede_fisica.tb_unidade_trabalho tutpai on tut.cd_unidade_trabalho_pai = tutpai.ci_unidade_trabalho 
join rede_fisica.tb_local_unid_trab tlu on tlu.cd_unidade_trabalho = tut.ci_unidade_trabalho 
join rede_fisica.tb_local_funcionamento tlf on tlu.cd_local_funcionamento = tlf.ci_local_funcionamento 
join util.tb_municipio_censo tl on tlf.cd_municipio_censo = tl.ci_municipio_censo
join rede_fisica.tb_categoria tc on tc.ci_categoria = tut.cd_categoria
order by 1,3,5