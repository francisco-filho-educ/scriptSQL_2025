create table  base_identificada.tb_mae as (
select  
tpc.no_pessoa_fisica,
tpc.no_mae,
tpc.dt_nascimento,
tpc.codigo_fonetico,
tpc.codigo_fonetico_mae,
max(tpc.co_pessoa_fisica) co_pessoa_fisica  
from base_identificada.tb_pessoa_censo tpc  
join base_identificada.tb_ultima_situacao tus using(nu_ano_censo,co_pessoa_fisica)
where tp_etapa_ensino not in (68,39,40)
and no_mae is not null
group by 1,2,3,4,5
)
-- select count(1), count(distinct co_pessoa_fisica) from base_identificada.tb_mae
drop table if exists base_identificada.tb_pai; 
create table  base_identificada.tb_pai as (
select  
tpc.no_pessoa_fisica,
tpc.no_pai,
tpc.dt_nascimento,
tpc.codigo_fonetico,
tpc.codigo_fonetico_pai,
max(tpc.co_pessoa_fisica) co_pessoa_fisica
from base_identificada.tb_pessoa_censo tpc  
join base_identificada.tb_ultima_situacao tus using(nu_ano_censo,co_pessoa_fisica)
where tp_etapa_ensino not in (68,39,40)
and no_pai is not null
group by 1,2,3,4,5
);
-- select count(1), count(distinct co_pessoa_fisica) from base_identificada.tb_pai


create table  base_identificada.tb_cpf as (
select  
tpc.no_pessoa_fisica,
tpc.nu_cpf,
tpc.dt_nascimento,
max(tpc.co_pessoa_fisica) co_pessoa_fisica  
from base_identificada.tb_pessoa_censo tpc  
join base_identificada.tb_ultima_situacao tus using(nu_ano_censo,co_pessoa_fisica)
where tp_etapa_ensino not in (68,39,40)
and tpc.nu_cpf is not null
group by 1,2,3
)
select count(1), count(distinct co_pessoa_fisica) from base_identificada.tb_cpf


create table  base_identificada.tb_nis as (
select  
tpc.no_pessoa_fisica,
tpc.nu_nis,
tpc.dt_nascimento,
max(tpc.co_pessoa_fisica) co_pessoa_fisica  
from base_identificada.tb_pessoa_censo tpc  
join base_identificada.tb_ultima_situacao tus using(nu_ano_censo,co_pessoa_fisica)
where tp_etapa_ensino not in (68,39,40)
and tpc.nu_nis is not null
group by 1,2,3
)
select count(1), count(distinct co_pessoa_fisica) from base_identificada.tb_nis


create table base_identificada.tb_pessoa_final_i as (
select 
m.co_pessoa_fisica,
m.no_pessoa_fisica,
m.no_mae,
p.no_pai,
m.dt_nascimento,
m.codigo_fonetico,
m.codigo_fonetico_mae,
p.codigo_fonetico_pai
from base_identificada.tb_mae m
left join base_identificada.tb_pai p using (co_pessoa_fisica)
union 
select
co_pessoa_fisica,
no_pessoa_fisica,
'' no_mae,
no_pai,
dt_nascimento,
codigo_fonetico,
'' codigo_fonetico_mae,
codigo_fonetico_pai
from base_identificada.tb_pai p
where 
not exists (select 1 from base_identificada.tb_mae m where m.co_pessoa_fisica = p.co_pessoa_fisica)
) 

select count(1), count(distinct co_pessoa_fisica) from base_identificada.tb_pessoa_final_i

create table base_identificada.tb_pessoa_final as (
select 
i.*,
cpf.nu_cpf,
nis.nu_nis
from base_identificada.tb_pessoa_final_i i
left join base_identificada.tb_cpf cpf using(co_pessoa_fisica)
left join base_identificada.tb_nis nis using(co_pessoa_fisica)
)
select count(1), count(distinct co_pessoa_fisica) from base_identificada.tb_pessoa_final

with ultima_mat as (
select 
co_pessoa_fisica,
max(nu_ano_censo) nu_ano_censo 
from censo_esc_ce.tb_matricula_censo_alinhado tmca 
where 
tp_etapa_ensino is not null 
and tp_etapa_ensino not in (68,39,40)
)
select 


select nu_ano_censo,  count(1), count(distinct co_pessoa_fisica) from  base_identificada.tb_ultima_situacao tus  where tp_situacao = 5 group by 1



with ultima as (
select 
co_pessoa_fisica,
count(1) qtd
from  base_identificada.tb_ultima_situacao tus 
where nu_ano_censo = 2023 
and tp_etapa_ensino not in (68,39,40) and IN_TRANSFERIDO = 0
group by 1 having count(1) > 1
)
select * from  base_identificada.tb_ultima_situacao tus  join ultima using(co_pessoa_fisica) where nu_ano_censo = 2023 and tp_etapa_ensino not in (68,39,40) and IN_TRANSFERIDO = 0


