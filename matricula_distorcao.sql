select 
nu_ano_censo,
tm.co_pessoa_fisica,
ds_etapa,
ds_ano_serie,
case when in_eja = 1 then 'EJA' else 'Ensino Regular' end ds_oferta, 
case when tp_sexo = 1 then 'M' else 'F' end ds_sexo,
case when in_eja = 1 then null else 
			case when nu_idade_referencia - cd_ano_serie >6 then 1 else 0 end end fl_distorcao,
nu_idade_referencia 
from censo_esc_ce.tb_matricula_2022 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where 
tp_dependencia = 2
and cd_etapa in (2,3)
union 
select 
nu_ano_censo,
tm.co_pessoa_fisica,
ds_etapa,
ds_ano_serie,
case when in_eja = 1 then 'EJA' else 'Ensino Regular' end ds_oferta, 
case when tp_sexo = 1 then 'M' else 'F' end ds_sexo,
case when in_eja = 1 then null else 
			case when nu_idade_referencia - cd_ano_serie >6 then 1 else 0 end end fl_distorcao,
nu_idade_referencia 
from censo_esc_ce.tb_matricula_2021 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where 
tp_dependencia = 2
and cd_etapa in (2,3)
union 
select 
nu_ano_censo,
tm.co_pessoa_fisica,
ds_etapa,
ds_ano_serie,
case when in_eja = 1 then 'EJA' else 'Ensino Regular' end ds_oferta, 
case when tp_sexo = 1 then 'M' else 'F' end ds_sexo,
case when in_eja = 1 then null else 
			case when nu_idade_referencia - cd_ano_serie >6 then 1 else 0 end end fl_distorcao,
nu_idade_referencia 
from censo_esc_ce.tb_matricula_2020 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where 
tp_dependencia = 2
and cd_etapa in (2,3)
union 
select 
nu_ano_censo,
tm.co_pessoa_fisica,
ds_etapa,
ds_ano_serie,
case when in_eja = 1 then 'EJA' else 'Ensino Regular' end ds_oferta, 
case when tp_sexo = 1 then 'M' else 'F' end ds_sexo,
case when in_eja = 1 then null else 
			case when nu_idade_referencia - cd_ano_serie >6 then 1 else 0 end end fl_distorcao,
nu_idade_referencia 
from censo_esc_ce.tb_matricula_2019 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where 
tp_dependencia = 2
and cd_etapa in (2,3)

