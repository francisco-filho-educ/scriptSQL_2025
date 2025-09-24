with fato as (
select 
cd_ano_serie,
nr_ano_censo,
nr_aprovados,
nr_reprovados,
nr_abandono,
nr_matricula_situacao
from dw_censo.tb_ft_situacao tfs 
join dw_censo.tb_dm_escola tde using(id_escola_inep,nr_ano_censo)
where 
cd_dependencia = 2
and fl_regular = 1 
and cd_etapa  = 3
and cd_ano_serie in (10,11,12,13)
)
,ano_1 as (
select 
nr_ano_censo,
sum(nr_aprovados) as nr_aprovados_1,
round(sum(nr_aprovados)/sum(nr_matricula_situacao),2) tx_aprovados_1,
sum(nr_reprovados) nr_reprovados_1,
round(sum(nr_reprovados)/sum(nr_matricula_situacao) ,2)tx_reprovados_1,
sum(nr_abandono) nr_abandono_1,
round(sum(nr_abandono) /sum(nr_matricula_situacao),2) tx_abandono_1
from fato
where 
cd_ano_serie = 10
group by 1
)
,ano_2 as (
select 
nr_ano_censo,
sum(nr_aprovados) as nr_aprovados_2,
round(sum(nr_aprovados)/sum(nr_matricula_situacao),2) tx_aprovados_2,
sum(nr_reprovados) nr_reprovados_2,
round(sum(nr_reprovados)/sum(nr_matricula_situacao) ,2)tx_reprovados_2,
sum(nr_abandono) nr_abandono_2,
round(sum(nr_abandono) /sum(nr_matricula_situacao),2) tx_abandono_2
from fato
where 
cd_ano_serie = 11
group by 1
)
,ano_3 as (
select 
nr_ano_censo,
sum(nr_aprovados) as nr_aprovados_3,
round(sum(nr_aprovados)/sum(nr_matricula_situacao),2) tx_aprovados_3,
sum(nr_reprovados) nr_reprovados_3,
round(sum(nr_reprovados)/sum(nr_matricula_situacao) ,2)tx_reprovados_3,
sum(nr_abandono) nr_abandono_3,
round(sum(nr_abandono) /sum(nr_matricula_situacao),2) tx_abandono_3
from fato
where 
cd_ano_serie = 12
group by 1
)
,ano_4 as(
select 
nr_ano_censo,
sum(nr_aprovados) as nr_aprovados_4,
round(sum(nr_aprovados)/sum(nr_matricula_situacao),2) tx_aprovados_4,
sum(nr_reprovados) nr_reprovados_4,
round(sum(nr_reprovados)/sum(nr_matricula_situacao) ,2)tx_reprovados_4,
sum(nr_abandono) nr_abandono_4,
round(sum(nr_abandono) /sum(nr_matricula_situacao),2) tx_abandono_4
from fato
where 
cd_ano_serie = 13
group by 1
)
,geral as (
select 
nr_ano_censo,
sum(nr_aprovados) as nr_aprovados,
round(sum(nr_aprovados)/sum(nr_matricula_situacao),2) tx_aprovados,
sum(nr_reprovados) nr_reprovados,
round(sum(nr_reprovados)/sum(nr_matricula_situacao) ,2)tx_reprovados,
sum(nr_abandono) nr_abandono,
round(sum(nr_abandono) /sum(nr_matricula_situacao),2) tx_abandono
from fato 
group by 1
)
select * 
from geral 
join ano_1 using(nr_ano_censo)
join ano_2 using(nr_ano_censo)
join ano_3 using(nr_ano_censo)
join ano_4 using(nr_ano_censo)
order by 1

/*
* RESULTADI POR ESCOLAS
*/

with fato as (
select 
cd_ano_serie,
id_escola_inep,
nr_ano_censo,
nr_aprovados,
nr_reprovados,
nr_abandono,
nr_matricula_situacao
from dw_censo.tb_ft_situacao tfs 
join dw_censo.tb_dm_escola tde using(id_escola_inep,nr_ano_censo)
where 
cd_dependencia = 2
and fl_regular = 1 
and cd_etapa  = 3
and cd_ano_serie in (10,11,12,13)
)
,ano_1 as (
select 
nr_ano_censo,
id_escola_inep,
sum(nr_aprovados) as nr_aprovados_1,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_aprovados)/sum(nr_matricula_situacao) end ,2) tx_aprovados_1,
sum(nr_reprovados) nr_reprovados_1,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_reprovados)/sum(nr_matricula_situacao) end ,2) tx_reprovados_1,
sum(nr_abandono) nr_abandono_1,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_abandono) /sum(nr_matricula_situacao) end ,2)tx_abandono_1
from fato
where 
cd_ano_serie = 10
group by 1,2
)--select  * from ano_1 
,ano_2 as (
select 
nr_ano_censo,
id_escola_inep,
sum(nr_aprovados) as nr_aprovados_2,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_aprovados)/sum(nr_matricula_situacao) end ,2) tx_aprovados_2,
sum(nr_reprovados) nr_reprovados_2,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_reprovados)/sum(nr_matricula_situacao) end ,2) tx_reprovados_2,
sum(nr_abandono) nr_abandono_2,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_abandono) /sum(nr_matricula_situacao) end ,2)tx_abandono_2
from fato
where 
cd_ano_serie = 11
group by 1,2
)
,ano_3 as (
select 
nr_ano_censo,
id_escola_inep,
sum(nr_aprovados) as nr_aprovados_3,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_aprovados)/sum(nr_matricula_situacao) end ,2) tx_aprovados_3,
sum(nr_reprovados) nr_reprovados_3,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_reprovados)/sum(nr_matricula_situacao) end ,2) tx_reprovados_3,
sum(nr_abandono) nr_abandono_3,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_abandono) /sum(nr_matricula_situacao) end ,2)tx_abandono_3
from fato
where 
cd_ano_serie = 12
group by 1,2
)
,ano_4 as(
select 
nr_ano_censo,
id_escola_inep,
sum(nr_aprovados) as nr_aprovados_4,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_aprovados)/sum(nr_matricula_situacao) end ,2) tx_aprovados_4,
sum(nr_reprovados) nr_reprovados_4,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_reprovados)/sum(nr_matricula_situacao) end ,2) tx_reprovados_4,
sum(nr_abandono) nr_abandono_4,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_abandono) /sum(nr_matricula_situacao) end ,2)tx_abandono_4
from fato
where 
cd_ano_serie = 13
group by 1,2
)
,geral as (
select 
nr_ano_censo,
id_escola_inep,
sum(nr_aprovados) as nr_aprovados_4,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_aprovados)/sum(nr_matricula_situacao) end ,2) tx_aprovados_4,
sum(nr_reprovados) nr_reprovados_4,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_reprovados)/sum(nr_matricula_situacao) end ,2) tx_reprovados_4,
sum(nr_abandono) nr_abandono_4,
round(
case when sum(nr_matricula_situacao) <1 then 0.0 else 
sum(nr_abandono) /sum(nr_matricula_situacao) end ,2)tx_abandono_4
from fato 
group by 1,2
)
select 
nr_ano_censo, 
id_crede_sefor,
nm_crede_sefor, 
nm_municipio, 
id_escola_inep,
nm_escola,
ds_categoria_escola_sige,
geral.*,
ano_1.*,
ano_2.*,
ano_3.*,
ano_4.*
from dw_censo.tb_dm_escola tde2 
join dw_censo.tb_dm_municipio tdm using(id_municipio)
join geral using(nr_ano_censo,id_escola_inep)
join ano_1 using(nr_ano_censo,id_escola_inep)
join ano_2 using(nr_ano_censo,id_escola_inep)
join ano_3 using(nr_ano_censo,id_escola_inep)
join ano_4 using(nr_ano_censo,id_escola_inep)
where 
tde2.nr_ano_censo >2016
and cd_dependencia = 2
and tde2.cd_categoria_escola_sige <> 99
order by 1