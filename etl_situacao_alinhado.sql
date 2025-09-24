--drop table tmp.tb_nao_matriculados_sobral

create table censo_esc_ce.tb_situacao_alinhado as (
select 
nu_ano_censo,
co_pessoa_fisica,
tp_etapa_ensino,
co_entidade,
id_turma,
tp_situacao,
in_concluinte,
co_municipio,
concat(nu_ano,'-',nu_mes,'-',nu_dia)::date dt_nascimento
from censo_esc_ce.tb_situacao_2021 ts
union 
select 
nu_ano_censo,
co_pessoa_fisica,
tp_etapa_ensino,
co_entidade,
id_turma,
tp_situacao,
in_concluinte,
co_municipio,
concat(nu_ano,'-',nu_mes,'-',nu_dia)::date dt_nascimento
from censo_esc_ce.tb_situacao_2020 ts
union 
select 
nu_ano_censo,
co_pessoa_fisica,
tp_etapa_ensino,
co_entidade,
id_turma,
tp_situacao,
in_concluinte,
co_municipio,
concat(nu_ano,'-',nu_mes,'-',nu_dia)::date dt_nascimento
from censo_esc_ce.tb_situacao_2019 ts
union 
select 
nu_ano_censo,
co_pessoa_fisica,
tp_etapa_ensino,
co_entidade,
id_turma,
tp_situacao,
in_concluinte,
co_municipio,
concat(nu_ano,'-',nu_mes,'-',nu_dia)::date dt_nascimento
from censo_esc_ce.tb_situacao_2007_2018 ts
) 