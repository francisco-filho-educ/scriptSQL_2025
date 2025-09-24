with 
turmas as (
	select * from academico.tb_turma t
	join academico.tb_turno tn on tn.ci_turno = t.cd_turno 
	left join academico.tb_curso tc2 on tc2.ci_curso = t.cd_curso
	join academico.tb_nivel n on n.ci_nivel = t.cd_nivel 
	where nr_anoletivo > 2015
	and cd_prefeitura = 0
	and cd_nivel = 27
    and cd_modalidade in (36,40)
    --and cd_etapa = 162
    and t.fl_ativo = 'S'
)
select 
t.nr_anoletivo,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
nm_curso,
ds_nivel,
ds_etapa,
ds_areatrabalho,
cd_disciplina,
ds_disciplina,
max(nr_cargahoraria) cargahoraria
from academico.tb_detalhes_boletim tdb 
join turmas t on t.ci_turma = tdb.cd_turma 
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
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
ORDER BY 1,3,4,6;
