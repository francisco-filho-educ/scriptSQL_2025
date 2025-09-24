with dados as (
select 
extract (year from age ('2015-03-31',concat( V3033,'-',V3032,'-',V3031)::date)) idade_pne,
tp.v4729::int peso,
V0601::int leitura,
V4803::int anos_estudo,
V8005::int idade_ibge
from pnad.tb_pnad_2015 tp 
where uf::int = 23
and V3033::int between 1900 and 2015
and V3032::int between 1 and  12
and V3031::int between 1 and 31
)
select 
sum(case when  idade_pne between 6 and 10 and leitura = 3 then peso else 0 end)::numeric /sum(case when  idade_pne between 6 and 10 then peso else 0 end)::numeric a6_10,
sum(case when  idade_pne between 11 and 14 and leitura = 3 then peso else 0 end)::numeric /sum(case when  idade_pne between 11 and 14 then peso else 0 end)::numeric a11_14,
sum(case when  idade_pne between 15 and 17 and leitura = 3 then peso else 0 end)::numeric /sum(case when  idade_pne between 15 and 17 then peso else 0 end)::numeric a15_17,
sum(case when  idade_pne >=18 and leitura = 3 then peso else 0 end)::numeric /sum(case when  idade_pne >=8 then peso else 0 end)::numeric a18,
sum(case when  idade_pne >=6 and leitura = 3 then peso else 0 end)::numeric /sum(case when  idade_pne >=6 then peso else 0 end)::numeric a06
--sum(case when  leitura = 3  then peso else 0 end)::numeric /sum(peso)::numeric
from dados 
where idade_pne between 1 and 1000
