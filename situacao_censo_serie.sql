/*
select 
nu_ano_censo,
nm_crede_sefor,
tde.id_escola_inep,
tde.nm_escola,
sum(case when cd_ano_serie = 4 then 1 else 0 end) nr_serie_4,
sum(case when cd_ano_serie = 5 then 1 else 0 end) nr_serie_5,
sum(case when cd_ano_serie = 6 then 1 else 0 end) nr_serie_6,
sum(case when cd_ano_serie = 7 then 1 else 0 end) nr_serie_7,
sum(case when cd_ano_serie = 8 then 1 else 0 end) nr_serie_8,
sum(case when cd_ano_serie = 9 then 1 else 0 end) nr_serie_9,
sum(case when cd_etapa = 3 then 1 else 0 end) medio,
sum(case when cd_ano_serie = 10 then 1 else 0 end) nr_serie_10,
sum(case when cd_ano_serie = 11 then 1 else 0 end) nr_serie_11,
sum(case when cd_ano_serie = 12 then 1 else 0 end) nr_serie_12
from censo_esc_ce.tb_matricula_2007_2018 tm 
join dw_censo.tb_dm_escola tde on id_escola_inep  = tm.co_entidade and tm.nu_ano_censo = tde.nr_ano_censo 
join dw_censo.tb_dm_etapa et on tp_etapa_ensino = et.cd_etapa_ensino 
where
tm.nu_ano_censo = 2017
and tm.tp_dependencia = 2
and tm.in_regular = 1
--and nm_escola ilike '%surdo%'
and tm.co_entidade =23071265
group by 1,2,3,4
*/
with sit as( 
select
nu_ano_censo,
nm_crede_sefor,
tde.id_escola_inep,
tde.nm_escola,
cd_etapa,
ds_etapa,
cd_etapa_fase,
ds_ano_serie,
cd_ano_serie,
count(1) nr_matriculas,
sum(case when tp_situacao = 5 then 1 else 0 end)::numeric  nr_aprovados,	
sum(case when tp_situacao = 4 then 1 else 0 end)::numeric  nr_reprovados,	
sum(case when tp_situacao = 2 then 1 else 0 end)::numeric  nr_abandono,
count(1)::numeric nr_matricula_situacao
from censo_esc_ce.tb_situacao_2007_2018 tm 
join bi_ce.tb_censo_dm_etapa on tp_etapa_ensino_censo = tp_etapa_ensino
join dw_censo.tb_dm_escola tde on id_escola_inep  = tm.co_entidade and tm.nu_ano_censo = tde.nr_ano_censo 
where nu_ano_censo = 2017-- = 2018 and co_municipio = 2304400
and cd_etapa in (2,3)
and in_regular = 1
and tp_situacao in (2,4,5) and tm.co_entidade =23071265
group by 1,2,3,4,5,6,7,8,9
)
select
nu_ano_censo,
nm_crede_sefor,
id_escola_inep,
nm_escola,
cd_ano_serie,
ds_ano_serie,
nr_aprovados,
round(case when nr_aprovados <1 then 0.0 else nr_aprovados/nr_matriculas*100 end,1) tx_aprovacao,
nr_reprovados,
round(case when nr_reprovados <1 then 0.0 else nr_reprovados/nr_matriculas*100 end,1) tx_reprovacao,
nr_abandono,
round(case when nr_abandono <1 then 0.0 else nr_abandono/nr_matriculas*100 end,1) tx_abandono
from sit 
order by cd_ano_serie






