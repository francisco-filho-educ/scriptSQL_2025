with 
turmas as (
	select * from academico.tb_turma 
	where nr_anoletivo = 2022
	and cd_prefeitura = 0
	and cd_etapa in (162,163,164,184,185,186,187,188,189,190,191)
	--and cd_unidade_trabalho = 57 
    --and ci_turma =  752317 
)
,enturmados as (
	select cd_aluno,cd_turma 
	from academico.tb_ultimaenturmacao e
	where e.nr_anoletivo = 2022
	and  exists(select 1 from turmas t where t.ci_turma=e.cd_turma)
	and e.fl_tipo_atividade <>'AC'
) --select count(1) nr_aulas, count(distinct cd_turma) nr_t from enturmados --333039	8782
,aulas as (
	select
	cd_turma, 
	nr_mes,
	1 fl_registro,
	sum(nr_aulas) nr_aulas
	from academico.tb_alunofrequencia_total_aulas_mes aftam 
	join academico.tb_disciplinas td on aftam.cd_disciplina = td.ci_disciplina 
	where 
	nr_anoletivo = 2022
	and exists(select 1 from enturmados ent where ent.cd_turma=aftam.cd_turma)
	and aftam.nr_mes = 4
	and td.fl_tipo ='B'
	group by 1,2,3--- order by 1
),faltas as (
	select 
	af.cd_aluno, 
	af.cd_turma,
	nr_mes, 
	sum(nr_faltas) nr_faltas
	--count(1)
	from academico.tb_alunofrequencia af
	join enturmados ent on ent.cd_turma=af.cd_turma and ent.cd_aluno = af.cd_aluno
	join academico.tb_disciplinas td on af.cd_disciplina = td.ci_disciplina 
	where
	af.nr_anoletivo  = 2022
	--and exists(select 1 from enturmados ent where ent.cd_turma=af.cd_turma and ent.cd_aluno = af.cd_aluno)
	and af.nr_mes = 4
	and td.fl_tipo ='B'
	group by 1,2,3 order by 2
) --select * from faltas
, aulas_faltas as (
select
  t.nr_anoletivo,
  t.cd_unidade_trabalho,
  e.cd_turma,
  t.cd_turno,
  t.cd_etapa,
  e.cd_aluno,
  a.nr_mes,
  fl_registro,
  coalesce(a.nr_aulas,0) nr_aulas,
  coalesce(f.nr_faltas,0) nr_faltas
from enturmados e
join turmas t on e.cd_turma=t.ci_turma
left join aulas a on a.cd_turma=e.cd_turma
left join faltas f on a.cd_turma=f.cd_turma and f.cd_aluno = e.cd_aluno
) 
select
nr_anoletivo,
tut.cd_unidade_trabalho_pai id_crede_sefor,
crede.nm_sigla nm_crede_sefor,
tmc.ci_municipio_censo id_municipio,
nm_municipio,
tut.nr_codigo_unid_trab id_escola,
tut.nm_unidade_trabalho  nm_escola,
tc.nm_categoria,
count(distinct cd_aluno) nr_alunos,
sum(nr_aulas)nr_aulas,
sum(nr_faltas)p_faltas	
--select count(1)
from rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join aulas_faltas aft on aft.cd_unidade_trabalho = tut.ci_unidade_trabalho 
where 
tut.cd_dependencia_administrativa::int = 2
AND tut.cd_tipo_unid_trab = 401
and tut.cd_situacao_funcionamento  = 1
AND tlut.fl_sede = TRUE 
and fl_registro is not null
group by 1,2,3,4,5,6,7,8
