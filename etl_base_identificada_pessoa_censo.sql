drop table  if exists tmp.data_nascimento;
create table tmp.data_nascimento as (
select 
nu_ano_censo,
co_pessoa_fisica, 
to_char(concat(nu_ano,'-',nu_mes,'-',nu_dia)::date,'dd/mm/yyyy') dt_nascimento
from censo_esc_ce.tb_matricula_2007_2018 
where tp_etapa_ensino is not null
group by 1,2,3 
union  
select 
nu_ano_censo,
co_pessoa_fisica, 
to_char(concat(nu_ano,'-',nu_mes,'-',nu_dia)::date,'dd/mm/yyyy') dt_nascimento
from censo_esc_ce.tb_matricula_2019 tm 
where tp_etapa_ensino is not null
group by 1,2,3 
);

create schema  if not exists base_identificada;

drop table  if exists base_identificada.tb_pessoa_censo ;
create table base_identificada.tb_pessoa_censo as (
select 
nu_ano_censo,
f.co_pessoa_fisica,
f.no_pessoa_fisica,
dt_nascimento,
f.nu_nis,
f.no_mae,
f.no_pai,
nu_cpf
from censo_esc_ce.tb_pessoa_fisica_2007_2017 f
left join tmp.data_nascimento tm  using(co_pessoa_fisica,nu_ano_censo)
where tm.nu_ano_censo < 2018
union 
select 
2018 nu_ano_censo,
f.co_pessoa_fisica,
f.no_pessoa_fisica,
dt_nascimento,
f.nu_nis,
f.no_mae,
f.no_pai,
nu_cpf
from censo_esc_ce.tb_pessoa_fisica_2018 f
union 
select 
2019 nu_ano_censo,
p.co_pessoa_fisica,
no_pessoa_fisica,
dt_nascimento,
nu_nis,
no_mae,
no_pai,
nu_cpf::bigint
from censo_esc_ce.tb_pessoa_fisica_2019 p
left join tmp.data_nascimento tm on tm.co_pessoa_fisica = p.co_pessoa_fisica and tm.nu_ano_censo = 2019
union 
select 
2020 nu_ano_censo,
co_pessoa_fisica,
no_pessoa_fisica,
dt_nascimento,
null nu_nis,
no_mae,
'' no_pai,
nu_cpf::bigint
from censo_esc_ce.tb_pessoa_fisica_2020
where co_pessoa_fisica is not null
union 
select 
2021 nu_ano_censo,
co_pessoa_fisica,
no_pessoa_fisica,
dt_nascimento,
null nu_nis,
tpf.no_filiacao_1 no_mae,
tpf.no_filiacao_2 no_pai,
nu_cpf::bigint
from censo_esc_ce.tb_pessoa_fisica_2021 tpf
where co_pessoa_fisica is not null
union 
select 
2022 nu_ano_censo,
co_pessoa_fisica,
no_pessoa_fisica,
dt_nascimento,
null nu_nis,
 no_mae,
no_pai,
nu_cpf::bigint
from censo_esc_ce.tb_pessoa_fisica_2022 tpf
where co_pessoa_fisica is not null
);
alter table base_identificada.tb_pessoa_censo add primary key (nu_ano_censo,co_pessoa_fisica);

--INSERT 
/*
-- DESNECESSÁRIO
insert into base_identificada.tb_pessoa_censo 
select 
2022 nu_ano_censo,
co_pessoa_fisica,
no_pessoa_fisica,
to_char(dt_nascimento::timestamptz, 'dd/mm/yyyy') dt_nascimento,
null nu_nis,
no_mae,
no_pai,
null nu_cpf
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal 
where co_pessoa_fisica is not null
union 
select 
2022 nu_ano_censo,
co_pessoa_fisica,
no_pessoa_fisica,
to_char(dt_nascimento::timestamptz, 'dd/mm/yyyy') dt_nascimento,
null nu_nis,
no_mae,
no_pai,
null nu_cpf
from spaece_aplicacao_2022.tb_base_censo_escolar_estadual
group by 1,2,3,4,5,6,7,8
*/
