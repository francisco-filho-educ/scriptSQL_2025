drop table  if exists base_identificada.tb_matricula_censo;
create table base_identificada.tb_matricula_censo as (
with matricula as (
select 
	nu_ano_censo ,
	id_matricula,
	co_pessoa_fisica ,
	co_entidade ,
	id_turma ,
	tp_etapa_ensino ,
	tm.co_municipio_nasc,
	tm.co_municipio_end,
	tm.tp_zona_residencial,
	tp_sexo,
	nu_dia,
	nu_mes,
	nu_ano,
	in_eja
from censo_esc_d.tb_matricula_2023 tm 
where tp_etapa_ensino is not null
union
select 
	nu_ano_censo ,
	id_matricula,
	co_pessoa_fisica ,
	co_entidade ,
	id_turma ,
	tp_etapa_ensino ,
	tm.co_municipio_nasc,
	tm.co_municipio_end,
	tm.tp_zona_residencial,
	tp_sexo,
	nu_dia,
	nu_mes,
	nu_ano,
	in_eja
from censo_esc_ce.tb_matricula_2022 tm
where tp_etapa_ensino is not null
union 
select 
	nu_ano_censo ,
	id_matricula,
	co_pessoa_fisica ,
	co_entidade ,
	id_turma ,
	tp_etapa_ensino ,
	tm.co_municipio_nasc,
	tm.co_municipio_end,
	tm.tp_zona_residencial,
	tp_sexo,
	nu_dia,
	nu_mes,
	nu_ano,
	in_eja
from censo_esc_ce.tb_matricula_2021 tm
where tp_etapa_ensino is not null
union 
select 
	nu_ano_censo ,
	id_matricula,
	co_pessoa_fisica ,
	co_entidade ,
	id_turma ,
	tp_etapa_ensino ,
	tm.co_municipio_nasc,
	tm.co_municipio_end,
	tm.tp_zona_residencial,
	tp_sexo,
	nu_dia,
	nu_mes,
	nu_ano,
	in_eja
from censo_esc_ce.tb_matricula_2020 tm
where tp_etapa_ensino is not null
union 
select 
	nu_ano_censo ,
	id_matricula,
	co_pessoa_fisica ,
	co_entidade ,
	id_turma ,
	tp_etapa_ensino ,
	tm.co_municipio_nasc,
	tm.co_municipio_end,
	tm.tp_zona_residencial,
	tp_sexo,
	nu_dia,
	nu_mes,
	nu_ano,
	in_eja
from censo_esc_ce.tb_matricula_2019 tm
where tp_etapa_ensino is not null
union 
select 
	nu_ano_censo ,
	id_matricula,
	co_pessoa_fisica ,
	co_entidade ,
	id_turma ,
	tp_etapa_ensino ,
	tm.co_municipio_nasc,
	tm.co_municipio_end,
	tm.tp_zona_residencial,
	tp_sexo,
	nu_dia,
	nu_mes,
	nu_ano,
	in_eja
from censo_esc_ce.tb_matricula_2007_2018 tm
where tp_etapa_ensino is not null
)
select 
	nu_ano_censo ,
	id_matricula,
	co_pessoa_fisica ,
	co_entidade ,
	id_turma ,
	tp_etapa_ensino ,
	tm.co_municipio_nasc,
	tm.co_municipio_end,
	tm.tp_zona_residencial,
	tp_sexo,
	nu_dia,
	nu_mes,
	nu_ano,
	in_eja
from matricula tm
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino
) ; 
ALTER TABLE base_identificada.tb_matricula_censo ADD COLUMN id_matricula_ceipe SERIAL;
alter table base_identificada.tb_matricula_censo add primary key (id_matricula_ceipe);
create index idx_pessoa_fisica on base_identificada.tb_matricula_censo (co_pessoa_fisica);

