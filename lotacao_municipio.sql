with mun as (
select 
tmc.ci_municipio_censo,
nm_municipio
from util.tb_municipio_censo tmc 
where (nm_municipio in ('Acarape','Salitre','Ereré','Milagres','Beberibe','Ibaretama','Nova Olinda','Pindoretama','Alto Santo','Forquilha','Ocara') or nm_municipio ilike 'Erer_')
and tmc.cd_uf_censo = 23
)
select
tt.nr_anoletivo,
tut.cd_unidade_trabalho_pai cd_crede,
concat('CREDE ',tut.cd_unidade_trabalho_pai::text) nm_crede,
'Estadual' ds_dependencia,
nm_municipio,
count(distinct cpf) nr_cpf
from academico.tb_ultimaenturmacao tue
join academico.tb_turma tt on tt.ci_turma = tue.cd_turma and tue.nr_anoletivo = tt.nr_anoletivo
join lotacaocoave.mvw_coave_turmas_presenciais lt on lt.ci_turma = tt.ci_turma
join lotacaocoave.mvw_coave_docentes dl on dl.cd_vinculo = lt.cd_vinculo
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
join mun on mun.ci_municipio_censo =tlf.cd_municipio_censo 
where 
tt.nr_anoletivo::int = 2021
and tut.cd_dependencia_administrativa::int = 2
and tut.cd_tipo_unid_trab in (401,402)
and tt.cd_prefeitura::int = 0
and tue.fl_tipo_atividade <>'AC'
and cd_nivel::int in (26,27,28)
and cd_etapa in(162,184,188)
and tlut.fl_sede 
group by 1,2,3,4,5
order by 2,5