CREATE TABLE dw_censo.tb_dm_municipio as (
select 
co_municipio::int4 id_municipio,
no_municipio nm_municipio,
co_microrregiao::int4 id_microrregiao,
no_microrregiao nm_microrregiao,
co_mesorregiao::int4 id_mesorregiao,
no_mesorregiao nm_mesorregiao,
co_uf::int id_uf,
no_uf nm_uf,
case when co_uf = 12 then 'AC'
     when co_uf = 27 then 'AL'
     when co_uf = 16 then 'AP'
     when co_uf = 13 then 'AM'
     when co_uf = 29 then 'BA'
     when co_uf = 23 then 'CE'
     when co_uf = 53 then 'DF'
     when co_uf = 32 then 'ES'
     when co_uf = 52 then 'GO'
     when co_uf = 21 then 'MA'
     when co_uf = 51 then 'MT'
     when co_uf = 50 then 'MS'
     when co_uf = 31 then 'MG'
     when co_uf = 15 then 'PA'
     when co_uf = 25 then 'PB'
     when co_uf = 41 then 'PR'
     when co_uf = 26 then 'PE'
     when co_uf = 22 then 'PI'
     when co_uf = 33 then 'RJ'
     when co_uf = 24 then 'RN'
     when co_uf = 43 then 'RS'
     when co_uf = 11 then 'RO'
     when co_uf = 14 then 'RR'
     when co_uf = 42 then 'SC'
     when co_uf = 35 then 'SP'
     when co_uf = 28 then 'SE'
     when co_uf = 17 then 'TO' end sg_uf,
co_regiao::int id_regiao,
no_regiao nm_regiao,
case when co_municipio in (1100205,1302603,1200401,5002704,1600303,5300108,1400100,5103403,1721000,3550308,2211001,3304557,1501402,5208707,2927408,4205407,2111300,2704302,4314902,4106902,3106200,2304400,2611606,2507507,2800308,2408102,3205309)
then 1 else 0 end fl_capital,
case when co_municipio in (1100205,1302603,1200401,5002704,1600303,5300108,1400100,5103403,1721000,3550308,2211001,3304557,1501402,5208707,2927408,4205407,2111300,2704302,4314902,4106902,3106200,2304400,2611606,2507507,2800308,2408102,3205309)
then 'Capital' else 'Não capital' end ds_capital
from censo_esc_ce.tb_uf_mun_dist tumd 
group by 1,2,3,4,5,6,7,8,9,10,11,12,13
order by 2
);