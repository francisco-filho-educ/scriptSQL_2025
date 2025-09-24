with turma as (
select
*
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2023
and tt.fl_tipo_seriacao = 'RG' and tt.cd_tpensino = 1 and tt.fl_ativo = 'S'
and tt.cd_modalidade <> 38
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2 --and tut.ci_unidade_trabalho = 37
						)
						)
,aluno_turma as (
select 
nr_anoletivo,
cd_unidade_trabalho,
concat(tta.nr_semestre,' Semestre') semestre,
ds_disciplina_atividade,
ds_codigo,
nr_semestre,
count(distinct tta.ci_turma_atividade)nr_turmas,
count(ue.cd_aluno) nr_alunos
from academico.tb_turma_atividade tta
left join academico.tb_enturmacao_atividade ue on ue.cd_turma_atividade = tta.ci_turma_atividade
join academico.tb_disciplina_atividade da on da.ci_disciplina_atividade = tta.cd_disciplina_atividade and da.ds_codigo  = 'CHS014'
where tta.nr_anoletivo = 2023
and exists (select 1 from turma where ci_turma = ue.cd_turma)
--and nr_semestre = 1
--and ds_codigo in ('CHS053')
group by 1,2,3,4,5,6
) 
,escola_categoria_atual as (
select 
tut.ci_unidade_trabalho,
case when tut.nr_codigo_unid_trab in (
'23246618',
'23279150',
'23076194',
'23081988',
'23044560',
'23264888',
'23041412',
'23041510',
'23046449',
'23001011',
'23252626',
'23252642',
'23252863',
'23004088',
'23275049',
'23245000',
'23242426',
'23026596',
'23027584',
'23010851',
'23010886',
'23265876',
'23016876',
'23018178',
'23015594',
'23236507',
'23019344',
'23545500',
'23022655',
'23545488',
'23023953',
'23044756',
'23050055',
'23032103',
'23054808',
'23244828',
'23274972',
'23060174',
'23248998',
'23125012',
'23125314',
'23130890',
'23131365',
'23133295',
'23137657',
'23134488',
'23234474',
'23273526',
'23273534',
'23085711',
'23028068',
'23564431',
'23089164',
'23090235',
'23091240',
'23118709',
'23275065',
'23105828',
'23252618',
'23209585',
'23000283',
'23272201',
'23146990',
'23139382',
'23545755',
'23149795',
'23151650',
'23277971',
'23164867',
'23277548',
'23159766',
'23340622',
'23065389',
'23071044',
'23072377',
'23070897',
'23064676',
'23071095',
'23186364',
'23259639'
) then 9 else tut.cd_categoria end cd_categoria_atual
from rede_fisica.tb_unidade_trabalho tut 
where tut.cd_dependencia_administrativa  = 2
and tut.cd_tipo_unid_trab = 401
and tut.cd_categoria is not null
)
,esc as
(
select
tut.ci_unidade_trabalho,
crede.ci_unidade_trabalho id_crede_sefor,
crede.nm_sigla nm_crede_sefor,
upper(nm_municipio) nm_municipio,
tut.nr_codigo_unid_trab id_escola_inep,
tut.nm_unidade_trabalho nm_escola
FROM rede_fisica.tb_unidade_trabalho tut 
join escola_categoria_atual ea on tut.ci_unidade_trabalho = ea.ci_unidade_trabalho
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc on cd_categoria_atual = ci_categoria 
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
--and tut.nr_codigo_unid_trab = '23000116'
)
select 
coalesce(nr_anoletivo,2023) nr_anoletivo,
nr_semestre,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
ds_disciplina_atividade,
ds_codigo,
sum(coalesce (nr_turmas,0)) nr_turmas,
sum(coalesce (nr_alunos,0)) nr_alunos
from esc 
join aluno_turma on ci_unidade_trabalho = cd_unidade_trabalho
group by 1,2,3,4,5,6,7,8,9
order by 3,7,2