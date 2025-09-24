with docs as (
select 
nu_ano_censo nr_ano_censo,
co_municipio id_municipio,
count(distinct td.co_pessoa_fisica) nr_doc
from  censo_esc_ce.tb_docente_2007_2018 td 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = td.tp_etapa_ensino 
where 
nu_ano_censo between 2015 and 2019 
and in_regular = 1
and cd_etapa = 2
and tp_dependencia = 3
and co_municipio in (2304400,2303709,2307304,2307650,2312908,2306405,2304202,2307700,2305506,2313401)
group by 1,2
union 
select 
nu_ano_censo nr_ano_censo,
co_municipio id_municipio,
count(distinct td.co_pessoa_fisica) nr_doc
from  censo_esc_ce.tb_docente_2019 td
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = td.tp_etapa_ensino 
where 
nu_ano_censo = 2019
and in_regular = 1
and cd_etapa = 2
and tp_dependencia = 3
and co_municipio in (2304400,2303709,2307304,2307650,2312908,2306405,2304202,2307700,2305506,2313401)
group by 1,2
),
ideb_af as (
select 
2015 nr_ano_censo,
af.co_municipio,
af.vl_observado_2015::numeric ideb_af
from ideb.tb_ideb_municipio_af af 
where co_municipio in (2304400,2303709,2307304,2307650,2312908,2306405,2304202,2307700,2305506,2313401)
and rede ='Municipal'
union 
select 
2017 nr_ano_censo,
af.co_municipio,
af.vl_observado_2017::numeric ideb_af
from ideb.tb_ideb_municipio_af af 
where co_municipio in (2304400,2303709,2307304,2307650,2312908,2306405,2304202,2307700,2305506,2313401)
and rede ='Municipal'
union 
select 
2019 nr_ano_censo,
af.co_municipio,
af.vl_observado_2019::numeric ideb_af
from ideb.tb_ideb_municipio_af af 
where co_municipio in (2304400,2303709,2307304,2307650,2312908,2306405,2304202,2307700,2305506,2313401)
and rede ='Municipal'
),
ideb_ai as (
select 
2015 nr_ano_censo,
ai.co_municipio,
ai.vl_observado_2015::numeric ideb_ai
from ideb.tb_ideb_municipio_ai ai 
where co_municipio in (2304400,2303709,2307304,2307650,2312908,2306405,2304202,2307700,2305506,2313401)
and rede ='Municipal'
union 
select 
2017 nr_ano_censo,
ai.co_municipio,
ai.vl_observado_2017::numeric ideb_ai
from ideb.tb_ideb_municipio_ai ai 
where co_municipio in (2304400,2303709,2307304,2307650,2312908,2306405,2304202,2307700,2305506,2313401)
and rede ='Municipal'
union 
select 
2019 nr_ano_censo,
ai.co_municipio,
ai.vl_observado_2019::numeric ideb_ai
from ideb.tb_ideb_municipio_ai ai 
where co_municipio in (2304400,2303709,2307304,2307650,2312908,2306405,2304202,2307700,2305506,2313401)
and rede ='Municipal'
)
select 
tcm.nr_ano_censo,
tcm.id_municipio,
nm_municipio,
count(distinct id_escola_inep ) qtd_escolas,
sum(nr_matriculas) mat_t,
sum(case when cd_localizacao = 1 then nr_matriculas else 0 end) mat_u,
sum(case when cd_localizacao = 2 then nr_matriculas else 0 end) mat_r,
nr_doc,
ideb_ai,
ideb_af
from dw_censo.tb_cubo_matricula tcm 
join docs on docs.nr_ano_censo = tcm.nr_ano_censo and docs.id_municipio = tcm.id_municipio 
left join ideb_ai ai on  ai.nr_ano_censo = tcm.nr_ano_censo and ai.co_municipio = tcm.id_municipio 
left join ideb_af af on  af.nr_ano_censo = tcm.nr_ano_censo and af.co_municipio = tcm.id_municipio 
where 
tcm.nr_ano_censo between 2015 and 2019 
and fl_regular = 1
and cd_etapa = 2
and cd_dependencia = 3
and tcm.id_municipio in (2304400,2303709,2307304,2307650,2312908,2306405,2304202,2307700,2305506,2313401)
group by 1,2,3,8,9,10
order by nm_municipio,nr_ano_censo