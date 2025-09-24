with mat as (
select
nu_ano_censo, 
co_municipio,
count(1) nr_mat
from censo_esc_ce.tb_matricula_2019 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where 1=1
and  cd_etapa = 3
and tp_dependencia = 2
group by 1,2 
union 
select
nu_ano_censo, 
co_municipio,
count(1) nr_mat
from censo_esc_ce.tb_matricula_2020 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where 1=1
and  cd_etapa = 3
and tp_dependencia = 2
group by 1,2 
), aba as (
select
nu_ano_censo, 
co_municipio,
count(1) nr_aba
from censo_esc_ce.tb_situacao_2019 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where 1=1
and  cd_etapa = 3
and tp_dependencia = 2
--and tde.cd_ano_serie in(10,11,12,13)
and tp_situacao = 2 --and co_municipio  = 2304400
group by 1,2 
union 
select
nu_ano_censo, 
co_municipio,
count(1) nr_aba
from censo_esc_ce.tb_situacao_2020 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where 1=1
and  cd_etapa = 3
and tp_dependencia = 2
--and tde.cd_ano_serie in(10,11,12,13)
and tp_situacao = 2 --and co_municipio  = 2304400
group by 1,2 
) 
select 
nm_municipio,
sum(case when nu_ano_censo = 2019 then nr_mat else 0 end) nr_mat_2019,
sum(case when nu_ano_censo = 2019 then nr_aba else 0 end) nr_aba_2019,
sum(case when nu_ano_censo = 2020 then nr_mat else 0 end) nr_mat_2020,
sum(case when nu_ano_censo = 2020 then nr_aba else 0 end) nr_aba_2020
from mat 
left  join aba using (nu_ano_censo,co_municipio)
join dw_censo.tb_dm_municipio on id_municipio = co_municipio
group by 1
order by 1



