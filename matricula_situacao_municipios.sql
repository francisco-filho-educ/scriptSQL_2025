-- DISTORCAO

with distorcao as (
select 
co_pessoa_fisica,
1 fl_distorcao
from censo_esc_d.tb_matricula tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where tm.co_municipio in ('2300200','2301257','2302107','2302206','2302404','2302503','2302602','2302800','2303501','2303709','2304103','2304202','2304269','2305407','2305506','2305605','2305654','2305902','2306306','2306900','2307304','2307635','2307650','2308351','2308500','2308609','2309300','2309409','2310506','2310852','2310902','2311009','2311264','2311306','2311405','2311801','2312700','2312908','2313005','2313203','2313302','2313401')
and cd_ano_serie between 1 and 13
and  tm.nu_idade_referencia - tde.cd_ano_serie > 6 
),
matricula_distocao as (
select 
nu_ano_censo,
nm_municipio,
case when tp_dependencia = 1 then 'Federal'
when tp_dependencia = 2 then 'Estadual'
when tp_dependencia = 3 then 'Municipal'
when tp_dependencia = 4 then 'Privada' end  ds_dependencia,
count(1) nr_total,
sum(case when cd_etapa = 2 and in_regular = 1 then 1 else 0 end ) nr_fundamental,
sum(case when cd_etapa = 2 and in_regular = 1 and tde.cd_etapa_fase = 3 then 1 else 0 end ) nr_fundamental_ai,
sum(case when cd_etapa = 2 and in_regular = 1 and tde.cd_etapa_fase = 4 then 1 else 0 end ) nr_fundamental_af,
sum(case when cd_etapa = 3 and in_regular = 1 then 1 else 0 end ) nr_medio,
sum(fl_distorcao) nr_total_dist,
sum(case when cd_etapa = 2 and in_regular = 1 then fl_distorcao else 0 end ) nr_fundamental_dist,
sum(case when cd_etapa = 2 and in_regular = 1 and tde.cd_etapa_fase = 3 then fl_distorcao else 0 end ) nr_fundamental_ai_dist,
sum(case when cd_etapa = 2 and in_regular = 1 and tde.cd_etapa_fase = 4 then fl_distorcao else 0 end ) nr_fundamental_af_dist,
sum(case when cd_etapa = 3 and in_regular = 1 then fl_distorcao else 0 end ) nr_medio_dist
from censo_esc_d.tb_matricula tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio
left join distorcao using(co_pessoa_fisica)
where tm.co_municipio in ('2300200','2301257','2302107','2302206','2302404','2302503','2302602','2302800','2303501','2303709','2304103','2304202','2304269','2305407','2305506','2305605','2305654','2305902','2306306','2306900','2307304','2307635','2307650','2308351','2308500','2308609','2309300','2309409','2310506','2310852','2310902','2311009','2311264','2311306','2311405','2311801','2312700','2312908','2313005','2313203','2313302','2313401')
and cd_ano_serie between 1 and 13
group by 1,2,3
) 
select 
nu_ano_censo,
nm_municipio,
nr_total,
round(nr_total_dist/nr_total::numeric,1) tx_total,
nr_fundamental,
round(nr_fundamental_dist/nr_fundamental::numeric,1) tx_fundamental
from matricula_distocao

-- SITUACAO
/*
with sit as( 
select
nu_ano_censo,
--co_entidade,
tm.co_municipio,
tp_dependencia,
count(1) nr_matriculas,
sum(case when tp_situacao = 5 then 1 else 0 end)::numeric  nr_aprovados,	
sum(case when tp_situacao = 4 then 1 else 0 end)::numeric  nr_reprovados,	
sum(case when tp_situacao = 2 then 1 else 0 end)::numeric  nr_abandono,
sum(case when cd_etapa = 2 then 1 else 0 end)::numeric  nr_matricula_fund,
sum(case when tp_situacao = 5 and  cd_etapa = 2  then 1 else 0 end)::numeric  nr_aprovados_fund,
sum(case when tp_situacao = 4 and  cd_etapa = 2  then 1 else 0 end)::numeric  nr_reprovados_fund,	
sum(case when tp_situacao = 2 and  cd_etapa = 2  then 1 else 0 end)::numeric  nr_abandono_fund,
sum(case when cd_etapa_fase = 3 then 1 else 0 end)::numeric  nr_matricula_ai,
sum(case when tp_situacao = 5 and  cd_etapa_fase = 3  then 1 else 0 end)::numeric  nr_aprovados_ai,	
sum(case when tp_situacao = 4 and  cd_etapa_fase = 3  then 1 else 0 end)::numeric  nr_reprovados_ai,	
sum(case when tp_situacao = 2 and  cd_etapa_fase = 3  then 1 else 0 end)::numeric  nr_abandono_ai,
sum(case when cd_etapa_fase = 4 then 1 else 0 end)::numeric  nr_matricula_af,
sum(case when tp_situacao = 5 and  cd_etapa_fase = 4 then 1 else 0 end)::numeric  nr_aprovados_af,	
sum(case when tp_situacao = 4 and  cd_etapa_fase = 4 then 1 else 0 end)::numeric  nr_reprovados_af,	
sum(case when tp_situacao = 2 and  cd_etapa_fase = 4 then 1 else 0 end)::numeric  nr_abandono_af,
sum(case when cd_etapa = 3 then 1 else 0 end)::numeric  nr_matricula_med,
sum(case when tp_situacao = 5 and  cd_ano_serie = 10 then 1 else 0 end)::numeric  nr_aprovados_med,	
sum(case when tp_situacao = 4 and  cd_ano_serie = 11 then 1 else 0 end)::numeric  nr_reprovados_med,	
sum(case when tp_situacao = 2 and  cd_ano_serie = 12 then 1 else 0 end)::numeric  nr_abandono_med
from censo_esc_ce.tb_situacao_2020 tm
join bi_ce.tb_censo_dm_etapa on tp_etapa_ensino_censo = tp_etapa_ensino
where nu_ano_censo = 2020-- = 2018 and co_municipio = 2304400
and cd_etapa in (2,3)
and in_regular = 1
and tp_situacao in (2,4,5)
--and tp_dependencia = 2
group by 1,2,3
)*/ 
/*
select --* from sit
nu_ano_censo,
--id_crede_sefor,
--nm_crede_sefor,
nm_municipio,
case when tp_dependencia = 1 then 'Federal'
when tp_dependencia = 2 then 'Estadual'
when tp_dependencia = 3 then 'Municipal'
when tp_dependencia = 4 then 'Privada' end  ds_dependencia,
/*ds_dependencia,
ds_categoria_escola_sige,
id_escola_inep,
nm_escola,*/
nr_aprovados,
round(case when nr_aprovados <1 then 0.0 else nr_aprovados/nr_matriculas*100 end,1) tx_aprovacao,
nr_reprovados,
round(case when nr_reprovados <1 then 0.0 else nr_reprovados/nr_matriculas*100 end,1) tx_reprovacao,
nr_abandono,
round(case when nr_abandono <1 then 0.0 else nr_abandono/nr_matriculas*100 end,1) tx_abandono,
nr_aprovados_fund,
round(case when nr_aprovados_fund <1 then 0.0 else nr_aprovados_fund/nr_matricula_fund*100 end,1) tx_aprovacao_fund,
nr_reprovados_fund,
round(case when nr_reprovados_fund <1 then 0.0 else nr_reprovados_fund/nr_matricula_fund*100 end,1) tx_reprovacao_fund,
nr_abandono_fund,
round(case when nr_abandono_fund <1 then 0.0 else nr_abandono_fund/nr_matricula_fund*100 end,1) tx_abandono_fund,
nr_aprovados_ai,
round(case when nr_aprovados_ai <1 then 0.0 else nr_aprovados_ai/nr_matricula_ai*100 end,1) tx_aprovacao_ai,
nr_reprovados_ai,
round(case when nr_reprovados_ai <1 then 0.0 else nr_reprovados_ai/nr_matricula_ai*100 end,1) tx_reprovacao_ai,
nr_abandono_ai,
round(case when nr_abandono_ai <1 then 0.0 else nr_abandono_ai/nr_matricula_ai*100 end,1) tx_abandono_ai,
nr_aprovados_af,
round(case when nr_aprovados_af <1 then 0.0 else nr_aprovados_af/nr_matricula_af*100 end,1) tx_aprovacao_af,
nr_reprovados_af,
round(case when nr_reprovados_af <1 then 0.0 else nr_reprovados_af/nr_matricula_af*100 end,1) tx_reprovacao_af,
nr_abandono_af,
round(case when nr_abandono_af <1 then 0.0 else nr_abandono_af/nr_matricula_af*100 end,1) tx_abandono_af,
nr_aprovados_med,
round(case when nr_aprovados_med <1 then 0.0 else nr_aprovados_med/nr_matricula_med*100 end,1) tx_aprovacao_med,
nr_reprovados_med,
round(case when nr_reprovados_med <1 then 0.0 else nr_reprovados_med/nr_matricula_med*100 end,1) tx_reprovacao_med,
nr_abandono_med,
round(case when nr_abandono_med <1 then 0.0 else nr_abandono_med/nr_matricula_med*100 end,1) tx_abandono_med
from sit tm
--join dw_censo.tb_dm_escola tde on id_escola_inep  = tm.co_entidade and tm.nu_ano_censo = tde.nr_ano_censo 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio 
where co_municipio in ('2300200','2301257','2302107','2302206','2302404','2302503','2302602','2302800','2303501','2303709','2304103','2304202','2304269','2305407','2305506','2305605','2305654','2305902','2306306','2306900','2307304','2307635','2307650','2308351','2308500','2308609','2309300','2309409','2310506','2310852','2310902','2311009','2311264','2311306','2311405','2311801','2312700','2312908','2313005','2313203','2313302','2313401')
order by 2,3
*/
/*
select --* from sit
nu_ano_censo,
--id_crede_sefor,
--nm_crede_sefor,
nm_municipio,
'TOTAL' ds_dependencia,
/*ds_dependencia,
ds_categoria_escola_sige,
id_escola_inep,
nm_escola,*/
nr_aprovados,
round(case when nr_aprovados <1 then 0.0 else nr_aprovados/nr_matriculas*100 end,1) tx_aprovacao,
nr_reprovados,
round(case when nr_reprovados <1 then 0.0 else nr_reprovados/nr_matriculas*100 end,1) tx_reprovacao,
nr_abandono,
round(case when nr_abandono <1 then 0.0 else nr_abandono/nr_matriculas*100 end,1) tx_abandono,
nr_aprovados_fund,
round(case when nr_aprovados_fund <1 then 0.0 else nr_aprovados_fund/nr_matricula_fund*100 end,1) tx_aprovacao_fund,
nr_reprovados_fund,
round(case when nr_reprovados_fund <1 then 0.0 else nr_reprovados_fund/nr_matricula_fund*100 end,1) tx_reprovacao_fund,
nr_abandono_fund,
round(case when nr_abandono_fund <1 then 0.0 else nr_abandono_fund/nr_matricula_fund*100 end,1) tx_abandono_fund,
nr_aprovados_ai,
round(case when nr_aprovados_ai <1 then 0.0 else nr_aprovados_ai/nr_matricula_ai*100 end,1) tx_aprovacao_ai,
nr_reprovados_ai,
round(case when nr_reprovados_ai <1 then 0.0 else nr_reprovados_ai/nr_matricula_ai*100 end,1) tx_reprovacao_ai,
nr_abandono_ai,
round(case when nr_abandono_ai <1 then 0.0 else nr_abandono_ai/nr_matricula_ai*100 end,1) tx_abandono_ai,
nr_aprovados_af,
round(case when nr_aprovados_af <1 then 0.0 else nr_aprovados_af/nr_matricula_af*100 end,1) tx_aprovacao_af,
nr_reprovados_af,
round(case when nr_reprovados_af <1 then 0.0 else nr_reprovados_af/nr_matricula_af*100 end,1) tx_reprovacao_af,
nr_abandono_af,
round(case when nr_abandono_af <1 then 0.0 else nr_abandono_af/nr_matricula_af*100 end,1) tx_abandono_af,
nr_aprovados_med,
round(case when nr_aprovados_med <1 then 0.0 else nr_aprovados_med/nr_matricula_med*100 end,1) tx_aprovacao_med,
nr_reprovados_med,
round(case when nr_reprovados_med <1 then 0.0 else nr_reprovados_med/nr_matricula_med*100 end,1) tx_reprovacao_med,
nr_abandono_med,
round(case when nr_abandono_med <1 then 0.0 else nr_abandono_med/nr_matricula_med*100 end,1) tx_abandono_med
from sit tm
--join dw_censo.tb_dm_escola tde on id_escola_inep  = tm.co_entidade and tm.nu_ano_censo = tde.nr_ano_censo 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio 
where co_municipio in ('2300200','2301257','2302107','2302206','2302404','2302503','2302602','2302800','2303501','2303709','2304103','2304202','2304269','2305407','2305506','2305605','2305654','2305902','2306306','2306900','2307304','2307635','2307650','2308351','2308500','2308609','2309300','2309409','2310506','2310852','2310902','2311009','2311264','2311306','2311405','2311801','2312700','2312908','2313005','2313203','2313302','2313401')
order by 2,3
*/



-- MATRICULAS
/*
select 
nu_ano_censo,
nm_municipio,
case when tp_dependencia = 1 then 'Federal'
when tp_dependencia = 2 then 'Estadual'
when tp_dependencia = 3 then 'Municipal'
when tp_dependencia = 4 then 'Privada' end  ds_dependencia,
count(1) nr_total,
sum(case when cd_etapa = 1 and in_regular = 1 then 1 else 0 end ) nr_infantil,
sum(case when cd_etapa = 2 and in_regular = 1 then 1 else 0 end ) nr_fundamental,
sum(case when cd_etapa = 2 and in_regular = 1 and tde.cd_etapa_fase = 3 then 1 else 0 end ) nr_fundamental_ai,
sum(case when cd_etapa = 2 and in_regular = 1 and tde.cd_etapa_fase = 4 then 1 else 0 end ) nr_fundamental_af,
sum(case when cd_etapa = 3 and in_regular = 1 then 1 else 0 end ) nr_medio,
sum(case when in_eja = 1 then 1 else 0 end ) nr_ejas
from censo_esc_d.tb_matricula tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio
where tm.co_municipio in ('2300200','2301257','2302107','2302206','2302404','2302503','2302602','2302800','2303501','2303709','2304103','2304202','2304269','2305407','2305506','2305605','2305654','2305902','2306306','2306900','2307304','2307635','2307650','2308351','2308500','2308609','2309300','2309409','2310506','2310852','2310902','2311009','2311264','2311306','2311405','2311801','2312700','2312908','2313005','2313203','2313302','2313401')
group by 1,2,3
union 
select 
nu_ano_censo,
nm_municipio,
'TOTAL' ds_dependencia,
count(1) nr_total,
sum(case when cd_etapa = 1 and in_regular = 1 then 1 else 0 end ) nr_infantil,
sum(case when cd_etapa = 2 and in_regular = 1 then 1 else 0 end ) nr_fundamental,
sum(case when cd_etapa = 2 and in_regular = 1 and tde.cd_etapa_fase = 3 then 1 else 0 end ) nr_fundamental_ai,
sum(case when cd_etapa = 2 and in_regular = 1 and tde.cd_etapa_fase = 4 then 1 else 0 end ) nr_fundamental_af,
sum(case when cd_etapa = 3 and in_regular = 1 then 1 else 0 end ) nr_medio,
sum(case when in_eja = 1 then 1 else 0 end ) nr_ejas
from censo_esc_d.tb_matricula tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio
where tm.co_municipio in ('2300200','2301257','2302107','2302206','2302404','2302503','2302602','2302800','2303501','2303709','2304103','2304202','2304269','2305407','2305506','2305605','2305654','2305902','2306306','2306900','2307304','2307635','2307650','2308351','2308500','2308609','2309300','2309409','2310506','2310852','2310902','2311009','2311264','2311306','2311405','2311801','2312700','2312908','2313005','2313203','2313302','2313401')
group by 1,2,3
order by 2,3
*/

/* 
select 
nm_municipio,
no_entidade,
tde.ds_etapa_ensino
from censo_esc_d.tb_matricula tm 
join censo_esc_d.tb_escola te on tm.co_entidade = te.co_entidade 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio
where tm.co_pessoa_fisica = 121545579457


with crede as (
select 
tde.ds_orgao_regional,
id_crede_sefor,
nm_crede_sefor
from dw_censo.tb_dm_escola tde 
where nr_ano_censo = 2020 and ds_orgao_regional is not null
group by 1,2,3
)
select 
tm.nu_ano_censo,
id_crede_sefor,
nm_crede_sefor,
ds_orgao_regional,
tm.tp_dependencia, 
case when tm.tp_dependencia = 2 then 'Estadual' else 'Municipal' end dependencia,
count(distinct co_entidade) nr_escola
from censo_esc_d.tb_matricula tm 
join censo_esc_d.tb_escola te using(co_entidade)
join crede c on c.ds_orgao_regional = te.co_orgao_regional 
where tm.co_municipio = 2304400
and tm.tp_dependencia in (2,3)
group by 1,2,3,4,5
union 
select 
tm.nu_ano_censo,
id_crede_sefor,
nm_crede_sefor,
ds_orgao_regional,
9 tp_dependencia, 
'TOTAL' dependencia,
count(distinct co_entidade) nr_escola
from censo_esc_d.tb_matricula tm 
join censo_esc_d.tb_escola te using(co_entidade)
join crede c on c.ds_orgao_regional = te.co_orgao_regional 
where tm.co_municipio = 2304400
and tm.tp_dependencia in (2,3)
group by 1,2,3,4,5
union 
select 
tm.nu_ano_censo,
99 id_crede_sefor,
'TOTAL GERAL' nm_crede_sefor,
'TOTAL' ds_orgao_regional,
9 tp_dependencia, 
'TOTAL' dependencia,
count(distinct co_entidade) nr_escola
from censo_esc_d.tb_matricula tm 
join censo_esc_d.tb_escola te using(co_entidade)
join crede c on c.ds_orgao_regional = te.co_orgao_regional 
where tm.co_municipio = 2304400
and tm.tp_dependencia in (2,3)
group by 1,2,3,4,5
order by id_crede_sefor, ds_orgao_regional, tp_dependencia

*/

