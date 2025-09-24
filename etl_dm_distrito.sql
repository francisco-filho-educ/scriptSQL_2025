create table dw_censo.tb_dm_distrito as (
select 
co_distrito,
no_distrito nm_municipio,
co_municipio id_municipio
from censo_esc_ce.tb_uf_mun_dist tumd 
group by 1,2,3
)