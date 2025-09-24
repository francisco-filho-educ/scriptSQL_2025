create table base_identificada.tb_co_pessoa_cpf_1 as (
select 
co_pessoa_fisica::bigint, nu_cpf::bigint
from censo_esc_ce.tb_pessoa_fisica_2007_2017 tpf 
where nu_cpf is not null
group by 1,2
);
create table base_identificada.tb_co_pessoa_cpf_2 as (
select 
co_pessoa_fisica::bigint, nu_cpf::bigint
from censo_esc_ce.tb_pessoa_fisica_2018 tpf 
where nu_cpf is not null
group by 1,2
);
create table base_identificada.tb_co_pessoa_cpf_3 as (
select 
co_pessoa_fisica::bigint, nu_cpf::bigint
from censo_esc_ce.tb_pessoa_fisica_2019 tpf 
where nu_cpf is not null
group by 1,2
);
create table base_identificada.tb_co_pessoa_cpf_4 as (
select 
co_pessoa_fisica::bigint,
replace (replace (replace (nu_cpf,'.',''),'-',''),' ','')::bigint nu_cpf
from censo_esc_ce.tb_pessoa_fisica_2020 tpf 
where nu_cpf is not null
group by 1,2
);
create table base_identificada.tb_co_pessoa_cpf_tmp as (
select * from base_identificada.tb_co_pessoa_cpf_1
union
select * from base_identificada.tb_co_pessoa_cpf_2
union
select * from base_identificada.tb_co_pessoa_cpf_3
union 
select * from base_identificada.tb_co_pessoa_cpf_4
);
create table base_identificada.tb_co_pessoa_cpf as (
select 
co_pessoa_fisica,
nu_cpf
from base_identificada.tb_co_pessoa_cpf_tmp
group by 1,2
);
drop table base_identificada.tb_co_pessoa_cpf_1;
drop table base_identificada.tb_co_pessoa_cpf_2;
drop table base_identificada.tb_co_pessoa_cpf_3;
drop table base_identificada.tb_co_pessoa_cpf_4;
create table base_identificada.tb_qtd_co_pessoa_by_cpf as (
select
nu_cpf,
count(1) qtd_co_pesssoa
from base_identificada.tb_co_pessoa_cpf
where co_pessoa_fisica is not null
group by 1
order by 2 desc
);
create table base_identificada.tb_qtd_cpf_by_co_pessoa as (
select
co_pessoa_fisica,
count(1) qtd_cpf
from base_identificada.tb_co_pessoa_cpf
where co_pessoa_fisica is not null
group by 1
order by 2 desc
);


