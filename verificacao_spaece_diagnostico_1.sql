with antigo as (
select 
nm_municipio mu_2020,
te.co_entidade,
te.no_entidade nome_2020
from censo_esc_ce.tb_escola_2019_2020 te
join dw_censo.tb_dm_municipio tdm on id_municipio = te.co_municipio 
where nu_ano_censo = 2017
--and te.co_entidade in (23059923,23060719,23146095,23009586,23049391,23009713,23152095,23251140,23089644,23064358,23034076,23059702,23059796,23160578,23064498,23038381,23059788,23084626,23009020,23010126,23248661,23058021,23247843,23206152)
and co_entidade in (23045817,23206152)
)
select 
te.co_entidade,
nm_municipio mu_atual,
nm_municipio mu_2020,
te.no_entidade nome_atual,
nome_2020
from censo_esc_d.tb_escola te 
join dw_censo.tb_dm_municipio tdm on id_municipio = te.co_municipio 
left join antigo using(co_entidade)
where  --te.co_entidade in (23059923,23060719,23146095,23009586,23049391,23009713,23152095,23251140,23089644,23064358,23034076,23059702,23059796,23160578,23064498,23038381,23059788,23084626,23009020,23010126,23248661,23058021,23247843,23206152)
co_entidade in (23045817,23206152)