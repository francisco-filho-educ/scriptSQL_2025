with poco as (
select 
co_entidade,
in_agua_cacimba,
in_agua_rede_publica 
from censo_esc_d.tb_escola te 
where 
tp_dependencia = 2
and in_agua_cacimba <> 1
and tp_localizacao = 2
)
select 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
id_municipio,
nm_municipio,
id_escola_inep,
tde.ds_dependencia,
nm_escola,
ds_categoria_escola_sige,
ds_localizacao,
case when in_agua_cacimba = 1 then 'SIM' else 'NÃO' end ds_poco,
case when in_agua_rede_publica = 1 then 'SIM' else 'NÃO' end ds_rede_agua,
sum(tde.nr_matriculas) nr_matriculas
from dw_censo.tb_cubo_matricula tde 
join poco on co_entidade = id_escola_inep
where nr_ano_censo = 2022
and cd_dependencia = 2
and cd_localizacao = 2
and cd_etapa in (1,2,3)
group by 1,2,3,4,5,6,7,8,9,10,11,12
having sum(tde.nr_matriculas)>50



