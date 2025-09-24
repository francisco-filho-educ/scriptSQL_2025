with mat as (
select 
co_pessoa_fisica,
id_turma,
co_entidade,
concat(nu_ano,'-',nu_mes,'-',nu_dia)::date dt_nascimento
from censo_esc_d.tb_matricula tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino 
where cd_ano_serie = 9
and tp_dependencia in (2,3)
)
,pessoa as (
select
co_pessoa_fisica,
no_pessoa_fisica,
no_mae,
no_pai
from base_identificada.tb_pessoa_censo tpc 
join base_identificada.tb_co_pessoa_fisica_ano using(nu_ano_censo,co_pessoa_fisica)
where exists (select 1 from mat where mat.co_pessoa_fisica =  tpc.co_pessoa_fisica)
)
select  
mat.nu_ano_censo,
mat.co_pessoa_fisica,
co_entidade,
id_turma,
no_pessoa_fisica,
dt_nascimento,
no_mae,
no_pai
from mat 
left join pessoa p on mat.co_pessoa_fisica = p.co_pessoa_fisica

