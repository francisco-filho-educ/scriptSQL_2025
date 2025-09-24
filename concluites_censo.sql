with mat as (
select 
nu_ano_censo,
co_entidade,
id_turma,
count(1) qtd
from censo_esc_ce.tb_situacao_2019 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = ts.tp_etapa_ensino 
where in_concluinte  = 1
and cd_etapa = 3
and tp_situacao = 5
and tp_dependencia = 2
and cd_ano_serie = 12
group by 1,2,3
union 
select 
nu_ano_censo,
co_entidade,
id_turma,
count(1) qtd
from censo_esc_ce.tb_situacao_2020 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = ts.tp_etapa_ensino 
where in_concluinte  = 1
and cd_etapa = 3
and tp_situacao = 5
and tp_dependencia = 2
and cd_ano_serie = 12
group by 1,2,3
union 
select 
nu_ano_censo,
co_entidade,
id_turma,
count(1) qtd
from censo_esc_ce.tb_situacao_2021 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = ts.tp_etapa_ensino 
where --in_concluinte  = 1
cd_etapa = 3
and tp_situacao = 5
and tp_dependencia = 2
and cd_ano_serie = 12
group by 1,2,3
union 
select 
nu_ano_censo,
co_entidade,
id_turma,
count(1) qtd
from censo_esc_ce.tb_situacao_2022 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = ts.tp_etapa_ensino 
where in_concluinte  = 1
and cd_etapa = 3
and tp_situacao = 5
and tp_dependencia = 2
and cd_ano_serie = 12
group by 1,2,3
) 
select 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
ds_dependencia,
id_escola_inep,
nm_escola,
ds_categoria_escola_sige,
ds_localizacao,
sum(qtd) qtd
from dw_censo.tb_dm_escola e
join mat on co_entidade = id_escola_inep and nu_ano_censo = nr_ano_censo
join dw_censo.tb_dm_municipio tdm using(id_municipio)
group by 1,2,3,4,5,6,7,8,9
order by 
nr_ano_censo,
id_crede_sefor,
nm_municipio,
nm_escola
 ----------------------------------------------------
*/
select 
tcm.nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
ds_dependencia,
tcm.id_escola_inep,
nm_escola,
tcm.ds_categoria_escola_sige,
ds_localizacao,
cp.ds_area_curso_profissional,
cp.ds_curso_profissional,
sum(qtd) qtd
from dw_censo.tb_dm_escola tcm
join dw_censo.tb_dm_municipio tdm using(id_municipio)
join mat on co_entidade = id_escola_inep and nu_ano_censo = tcm.nr_ano_censo
join dw_censo.tb_dm_turma tdt on tdt.id_turma = mat.id_turma and tdt.nr_ano_censo = mat.nu_ano_censo
join dw_censo.tb_dm_cursos_profissional cp on cp.cd_curso_profissional = tdt.cd_curso_profissional and cp.nr_ano_censo = tdt.nr_ano_censo 
where tcm.cd_categoria_escola_sige = 8
group by 1,2,3,4,5,6,7,8,9,10,11
order by nr_ano_censo,id_crede_sefor,nm_municipio,nm_escola

