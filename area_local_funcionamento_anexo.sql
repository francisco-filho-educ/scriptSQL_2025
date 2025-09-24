with area_anexo as (
select
tut.nr_codigo_unid_trab id_escola_inep,
tlf.nm_local_funcionamento,
tlf.nr_area_terreno nr_area_terreno_anexo,
tlf.na_area_construida nr_area_construida_anexo
from rede_fisica.tb_unidade_trabalho tut 
join rede_fisica.tb_local_unid_trab tlut on tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho 
join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = tlut.cd_local_funcionamento 
where tlut.fl_sede = false
and tut.cd_dependencia_administrativa  = 2
and tut.cd_tipo_unid_trab = 401
and tut.cd_situacao_funcionamento = 1 order by 1
),
area_sede as (
select
tut.nr_codigo_unid_trab id_escola_inep,
tlf.nr_area_terreno nr_area_terreno,
tlf.na_area_construida nr_area_construida
from rede_fisica.tb_unidade_trabalho tut 
join rede_fisica.tb_local_unid_trab tlut on tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho 
join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = tlut.cd_local_funcionamento 
where tlut.fl_sede = true
and  cd_categoria = 7
and tut.cd_dependencia_administrativa  = 2
and tut.cd_tipo_unid_trab = 401
and tut.cd_situacao_funcionamento = 1 order by 1
)
select 
nr_anoletivo,
nm_crede_sefor,
nm_municipio,
nm_categoria,
c.id_escola_inep,
nm_escola,
nr_area_terreno,
nr_area_construida,
c.nm_local_funcionamento,
nr_area_terreno,
nr_area_construida,
count(1) qtd
from tmp.cubo c
left join area_anexo ae on ae.id_escola_inep =  c.id_escola_inep and c.nm_local_funcionamento = ae.nm_local_funcionamento
left join area_sede sd on sd.id_escola_inep =  c.id_escola_inep 
where nm_categoria ilike '%IND%' 
--order by cd_aluno
group by 
nr_anoletivo,
nm_crede_sefor,
nm_municipio,
nm_categoria,
c.id_escola_inep,
nm_escola,
nr_area_terreno,
nr_area_construida,
c.nm_local_funcionamento,
nr_area_terreno,
nr_area_construida