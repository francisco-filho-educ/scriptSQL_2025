with 
turmas as (
	select * from academico.tb_turma t
	where nr_anoletivo = 2019
	and cd_prefeitura = 0
	and cd_nivel = 27
    and cd_modalidade in (36,40)
    --and cd_etapa = 162
    and t.fl_ativo = 'S'
    and t.cd_turno in (5,8,9)
)
,enturmados as (
	select cd_aluno,cd_turma 
	from academico.tb_ultimaenturmacao e
	where e.nr_anoletivo = 2019
	and  exists(select 1 from turmas t where t.ci_turma=e.cd_turma)
),
max_aulas as (
	select
	nr_anoletivo,
	nr_ano,
	nr_mes,
	cd_turma, 
	cd_disciplina,
	max(nr_aulas) nr_cargahoraria
	from academico.tb_alunofrequencia_total_aulas_mes ttd
	where 
	nr_anoletivo = 2019
	and exists(select 1 from enturmados ent where ent.cd_turma=ttd.cd_turma) --and nr_mes between 1 and 12
	and nr_aulas>0
	group by 1,2,3,4,5
),soma_aulas as (
select 
    cd_turma,
    tg2.ci_grupodisciplina cd_disciplina,
    tg2.ds_grupodisciplina ds_disciplina,
    ta.ds_areatrabalho,
   sum(nr_cargahoraria) nr_cargahoraria
	from max_aulas au
    join academico.tb_disciplinas td on td.ci_disciplina = au.cd_disciplina
	join academico.tb_grupodisciplina tg2 on tg2.ci_grupodisciplina = td.cd_grupodisciplina 
	join academico.tb_areatrabalho ta on ci_areatrabalho = td.cd_areatrabalho
	group by 1,2,3,4
)
select 
nr_anoletivo,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
ds_etapa,
ds_areatrabalho,
cd_disciplina,
ds_disciplina,
max(nr_cargahoraria) cargahoraria
from soma_aulas sa
join turmas t on t.ci_turma = sa.cd_turma
join  rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join academico.tb_etapa te on te.ci_etapa = t.cd_etapa 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
group by 1,2,3,4,5,6,7,8,9,10,11,12
ORDER BY 1,3,4,6;


