select 
tp_situacao,
count(1)
from censo_esc_ce.tb_situacao_2022 ts 
join dw_censo.tb_dm_etapa tde on cd_etapa_ensino =  tp_etapa_ensino 
where 
tp_dependencia = 3
and cd_ano_serie = 9
and co_municipio = 2304400
and tp_situacao in (2,4,5)
group by 1



select
id_municipio id, 
nm_municipio,
'Crítico' ds_padrao
from dw_censo.tb_dm_municipio tdm 
where id_uf = 23
and id_municipio = 2306207
union 
select
id_municipio id, 
nm_municipio,
'Intermediário' ds_padrao
from dw_censo.tb_dm_municipio tdm 
where id_uf = 23
and id_municipio = 2306256
union 
select
id_municipio id, 
nm_municipio,
'Adequado' ds_padrao
from dw_censo.tb_dm_municipio tdm 
where id_uf = 23
and id_municipio = 2306306
union 
select
id_municipio id, 
nm_municipio,
'Muito Crítico' ds_padrao
from dw_censo.tb_dm_municipio tdm 
where id_uf = 23
and id_municipio not in (2306306,2306256,2306207)




select
id_municipio id, 
nm_municipio,
'Não Alfabetizado' ds_padrao
from dw_censo.tb_dm_municipio tdm 
where id_uf = 23
and id_municipio = 2306207
union 
select
id_municipio id, 
nm_municipio,
'Alfabetização Incompleta' ds_padrao
from dw_censo.tb_dm_municipio tdm 
where id_uf = 23
and id_municipio = 2306256
union 
select
id_municipio id, 
nm_municipio,
'Intermediário' ds_padrao
from dw_censo.tb_dm_municipio tdm 
where id_uf = 23
and id_municipio = 2306306
union 
select
id_municipio id, 
nm_municipio,
'Suficiente' ds_padrao
from dw_censo.tb_dm_municipio tdm 
where id_uf = 23
and id_municipio = 2313252
union 
select
id_municipio id, 
nm_municipio,
'Desejável' ds_padrao
from dw_censo.tb_dm_municipio tdm 
where id_uf = 23
and id_municipio not in (2306306,2306256,2306207,2313252)
