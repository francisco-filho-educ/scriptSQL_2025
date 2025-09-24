with dados as (
select 
nu_ano_censo,
tm.co_municipio,
count(1) qtd,
sum(in_transporte_publico) qtd_transp
from censo_esc_ce.tb_matricula_2007_2018 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where tm.nu_ano_censo >2014
and tp_dependencia = 2 
and tde.cd_etapa = 3 
group by 1,2
union 
select 
nu_ano_censo,
tm.co_municipio,
count(1) qtd,
sum(in_transporte_publico) qtd_transp
from censo_esc_ce.tb_matricula_2019 tm
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where tm.nu_ano_censo >2014
and tp_dependencia = 2 
and tde.cd_etapa = 3 
group by 1,2
union 
select 
nu_ano_censo,
tm.co_municipio,
count(1) qtd,
sum(in_transporte_publico) qtd_transp
from censo_esc_ce.tb_matricula_2020 tm
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where tm.nu_ano_censo >2014
and tp_dependencia = 2 
and tde.cd_etapa = 3 
group by 1,2
union 
select 
nu_ano_censo,
tm.co_municipio,
count(1) qtd,
sum(in_transporte_publico) qtd_transp
from censo_esc_ce.tb_matricula_2021 tm
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where tm.nu_ano_censo >2014
and tp_dependencia = 2 
and tde.cd_etapa = 3 
group by 1,2
union 
select 
nu_ano_censo,
tm.co_municipio,
count(1) qtd,
sum(in_transporte_publico) qtd_transp
from censo_esc_ce.tb_matricula_2022 tm
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where tm.nu_ano_censo >2014
and tp_dependencia = 2 
and tde.cd_etapa = 3 
group by 1,2
union 
select 
nu_ano_censo,
tm.co_municipio,
count(1) qtd,
sum(in_transporte_publico) qtd_transp
from censo_esc_ce.tb_matricula_2023 tm
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where tm.nu_ano_censo >2014
and tp_dependencia = 2 
and tde.cd_etapa = 3 
group by 1,2
)
select 
nu_ano_censo,
co_municipio,
nm_municipio,
qtd,
qtd_transp
from dados d 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio  = co_municipio


