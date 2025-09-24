drop table  if exists base_identificada.tb_situacao_censo;
create table base_identificada.tb_situacao_censo as (
with situacao as (
select 
	nu_ano_censo ,
	co_pessoa_fisica ,
	co_entidade ,
	id_turma ,
	in_concluinte,
	tp_etapa_ensino,
	tp_situacao
from censo_esc_ce.tb_situacao_2022 tm
where tp_etapa_ensino is not null
union 
select 
	nu_ano_censo ,
	co_pessoa_fisica ,
	co_entidade ,
	id_turma ,
	in_concluinte,
	tp_etapa_ensino,
	tp_situacao
from censo_esc_ce.tb_situacao_2021 tm
where tp_etapa_ensino is not null
union 
select 
	nu_ano_censo ,
	co_pessoa_fisica ,
	co_entidade ,
	id_turma ,
	in_concluinte,
	tp_etapa_ensino,
	tp_situacao
from censo_esc_ce.tb_situacao_2020 tm
where tp_etapa_ensino is not null
union 
select 
	nu_ano_censo ,
	co_pessoa_fisica ,
	co_entidade ,
	id_turma ,
	in_concluinte,
	tp_etapa_ensino,
	tp_situacao
from censo_esc_ce.tb_situacao_2019 tm
where tp_etapa_ensino is not null
union 
select 
	nu_ano_censo ,
	co_pessoa_fisica ,
	co_entidade ,
	id_turma ,
	in_concluinte,
	tp_etapa_ensino,
	tp_situacao
from censo_esc_ce.tb_situacao_2007_2018 tm
where tp_etapa_ensino is not null
)
select 
	nu_ano_censo ,
	co_pessoa_fisica ,
	co_entidade ,
	id_turma ,
	cd_etapa,
	cd_ano_serie,
	in_concluinte,
	tp_etapa_ensino,
	tp_situacao
from situacao tm
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino
) ; 
ALTER TABLE base_identificada.tb_situacao_censo ADD COLUMN id_situacao_ceipe SERIAL;
alter table base_identificada.tb_situacao_censo add primary key (id_situacao_ceipe);
create index idx_pessoa_fisica_situacao on base_identificada.tb_situacao_censo (co_pessoa_fisica);

