with fl_mat as(
select 
nu_ano_censo, co_entidade, 1 fl_matricula
from censo_esc_ce.tb_turma_2007_2018 tt
group by 1,2
union
select 
nu_ano_censo, co_entidade, 1 fl_matricula
from censo_esc_ce.tb_turma_2019_2020 tt
group by 1,2
union
select 
nu_ano_censo, co_entidade, 1 fl_matricula
from censo_esc_ce.tb_turma_2021_d tt
group by 1,2
)
select nu_ano_censo::int nr_ano_censo ,
co_entidade::int id_escola_inep ,
no_entidade nm_escola,
tp_situacao_funcionamento::int cd_situacao_funcionamento ,
fl_matricula,
tp_dependencia::int cd_dependencia ,
co_distrito::int id_distrito ,
co_municipio::int id_municipio ,
tp_localizacao::int cd_localizacao ,
case
when te.tp_localizacao_diferenciada::int in (1,2,3) then tp_localizacao_diferenciada::int else 99 end cd_localizacao_diferenciada,
co_orgao_regional ds_orgao_regional ,
case
when tp_categoria_escola_privada::int between 1 and 4 then tp_categoria_escola_privada::int else 99 end cd_categoria_escola_privada,
case
when IN_EDUCACAO_INDIGENA::int = 1 then 1 else 0 end fl_indigena,
case
when TP_LOCALIZACAO_DIFERENCIADA::int = 3 then 1 else 0 end fl_quilombola,
geo_ref_latitude nr_latitude,
geo_ref_longitude nr_longitude
from censo_esc_ce.tb_escola_2019_2020 te
left join fl_mat using(nu_ano_censo,co_entidade)
union
select nu_ano_censo::int nr_ano_censo ,
co_entidade::int id_escola_inep ,
no_entidade nm_escola ,
tp_situacao_funcionamento::int cd_situacao_funcionamento ,
fl_matricula,
tp_dependencia::int cd_dependencia ,
co_distrito::int id_distrito ,
co_municipio::int id_municipio ,
tp_localizacao::int cd_localizacao ,
case
when te.tp_localizacao_diferenciada = 1 then 1
when te.tp_localizacao_diferenciada in (2,5) then 2
when te.tp_localizacao_diferenciada in (3,6) then 3 else 99 end cd_localizacao_diferenciada,
co_orgao_regional ds_orgao_regional ,
case
when tp_categoria_escola_privada::int between 1 and 4 then tp_categoria_escola_privada::int else 99 end cd_categoria_escola_privada,
case
when IN_EDUCACAO_INDIGENA::int = 1 then 1 else 0 end fl_indigena,
case
when TP_LOCALIZACAO_DIFERENCIADA::int = 3 then 1 else 0 end fl_quilombola,
nu_latitude::numeric nr_latitude,
nu_longitude::numeric nr_longitude
from censo_esc_ce.tb_escola_2007_2018 te
left join fl_mat using(nu_ano_censo,co_entidade)
union
select nu_ano_censo::int nr_ano_censo ,
co_entidade::int id_escola_inep ,
no_entidade nm_escola,
tp_situacao_funcionamento::int cd_situacao_funcionamento ,
fl_matricula,
tp_dependencia::int cd_dependencia ,
co_distrito::int id_distrito ,
co_municipio::int id_municipio ,
tp_localizacao::int cd_localizacao ,
case
when te.tp_localizacao_diferenciada::int in (1,2,3) then tp_localizacao_diferenciada::int else 99 end cd_localizacao_diferenciada,
co_orgao_regional ds_orgao_regional ,
case
when tp_categoria_escola_privada::int between 1 and 4 then tp_categoria_escola_privada::int else 99 end cd_categoria_escola_privada,
case
when IN_EDUCACAO_INDIGENA::int = 1 then 1 else 0 end fl_indigena,
case
when TP_LOCALIZACAO_DIFERENCIADA::int = 3 then 1 else 0 end fl_quilombola,
geo_ref_latitude nr_latitude,
geo_ref_longitude nr_longitude
from censo_esc_ce.tb_escola_2019_2020 te
left join fl_mat using(nu_ano_censo,co_entidade)
union
select nu_ano_censo::int nr_ano_censo ,
co_entidade::int id_escola_inep ,
no_entidade nm_escola ,
tp_situacao_funcionamento::int cd_situacao_funcionamento ,
fl_matricula,
tp_dependencia::int cd_dependencia ,
co_distrito::int id_distrito ,
co_municipio::int id_municipio ,
tp_localizacao::int cd_localizacao ,
case
when te.tp_localizacao_diferenciada = 1 then 1
when te.tp_localizacao_diferenciada in (2,5) then 2
when te.tp_localizacao_diferenciada in (3,6) then 3 else 99 end cd_localizacao_diferenciada,
co_orgao_regional ds_orgao_regional ,
case
when tp_categoria_escola_privada::int between 1 and 4 then tp_categoria_escola_privada::int else 99 end cd_categoria_escola_privada,
case
when IN_EDUCACAO_INDIGENA::int = 1 then 1 else 0 end fl_indigena,
case
when TP_LOCALIZACAO_DIFERENCIADA::int = 3 then 1 else 0 end fl_quilombola,
null nr_latitude,
null nr_longitude
from censo_esc_ce.tb_escola_2019_2020 te
left join fl_mat using(nu_ano_censo,co_entidade)
union 
select nu_ano_censo::int nr_ano_censo ,
co_entidade::int id_escola_inep ,
no_entidade nm_escola,
tp_situacao_funcionamento::int cd_situacao_funcionamento ,
fl_matricula,
tp_dependencia::int cd_dependencia ,
co_distrito::int id_distrito ,
co_municipio::int id_municipio ,
tp_localizacao::int cd_localizacao ,
case
when te.tp_localizacao_diferenciada::int in (1,2,3) then tp_localizacao_diferenciada::int else 99 end cd_localizacao_diferenciada,
co_orgao_regional ds_orgao_regional ,
case
when tp_categoria_escola_privada::int between 1 and 4 then tp_categoria_escola_privada::int else 99 end cd_categoria_escola_privada,
case
when IN_EDUCACAO_INDIGENA::int = 1 then 1 else 0 end fl_indigena,
case
when TP_LOCALIZACAO_DIFERENCIADA::int = 3 then 1 else 0 end fl_quilombola,
geo_ref_latitude nr_latitude,
geo_ref_longitude nr_longitude
from censo_esc_ce.tb_escola_2019_2020 te
left join fl_mat using(nu_ano_censo,co_entidade)
union
select nu_ano_censo::int nr_ano_censo ,
co_entidade::int id_escola_inep ,
no_entidade nm_escola ,
tp_situacao_funcionamento::int cd_situacao_funcionamento ,
fl_matricula,
tp_dependencia::int cd_dependencia ,
co_distrito::int id_distrito ,
co_municipio::int id_municipio ,
tp_localizacao::int cd_localizacao ,
case
when te.tp_localizacao_diferenciada = 1 then 1
when te.tp_localizacao_diferenciada in (2,5) then 2
when te.tp_localizacao_diferenciada in (3,6) then 3 else 99 end cd_localizacao_diferenciada,
co_orgao_regional ds_orgao_regional ,
case
when tp_categoria_escola_privada::int between 1 and 4 then tp_categoria_escola_privada::int else 99 end cd_categoria_escola_privada,
case
when IN_EDUCACAO_INDIGENA::int = 1 then 1 else 0 end fl_indigena,
case
when TP_LOCALIZACAO_DIFERENCIADA::int = 3 then 1 else 0 end fl_quilombola,
null nr_latitude,
null nr_longitude
from censo_esc_ce.tb_escola_2021_d te
left join fl_mat using(nu_ano_censo,co_entidade)