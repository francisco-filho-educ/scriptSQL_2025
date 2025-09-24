drop table if exists censo_esc_ce.tb_matricula_censo_alinhado;
create table censo_esc_ce.tb_matricula_censo_alinhado as (
--2007 a 2018 -------------
select 
nu_ano_censo::smallint,
co_projeto::int,
co_evento::smallint,
co_pessoa_fisica,
id_matricula::bigint,
nu_dia::smallint,
nu_mes::smallint,
nu_ano::smallint,
nu_idade_referencia::smallint,
nu_idade::smallint,
tp_sexo::smallint,
tp_cor_raca::smallint,
tp_nacionalidade::smallint,
co_pais_origem::smallint,
co_uf_nasc::smallint,
co_municipio_nasc::int,
null::smallint co_pais_residencia,
co_uf_end::smallint,
co_municipio_end::int,
tp_zona_residencial::smallint,
null::int tp_local_resid_diferenciada,
in_necessidade_especial::smallint,
in_baixa_visao::smallint,
in_cegueira::smallint,
in_def_auditiva::smallint,
in_def_fisica::smallint,
in_def_intelectual::smallint,
in_surdez::smallint,
in_surdocegueira::smallint,
null::int in_visao_monocular,
in_def_multipla::smallint,
case  
	when in_sindrome_asperger = 1  or in_sindrome_rett = 1 or in_transtorno_di = 1 or  in_autismo = 1 then 1 else 0 end in_autismo,
in_superdotacao::smallint,
co_entidade::int,
id_turma::int,
nu_duracao_turma::smallint,
case
when tp_tipo_turma::int in (0,1,2,3) then 1
when tp_tipo_turma::int = 4 then 3
when tp_tipo_turma::int = 5 then 4 end  tp_tipo_local_turma,
tp_unificada::smallint,
tp_etapa_ensino::smallint,
in_especial_exclusiva::smallint,
in_regular::smallint,
in_eja::smallint,
in_profissionalizante::smallint
from censo_esc_ce.tb_matricula_2007_2018 tm 
union 
--2019 -------------
select 
nu_ano_censo::smallint,
co_projeto::int,
co_evento::smallint,
co_pessoa_fisica,
id_matricula::bigint,
nu_dia::smallint,
nu_mes::smallint,
nu_ano::smallint,
nu_idade_referencia::smallint,
nu_idade::smallint,
tp_sexo::smallint,
tp_cor_raca::smallint,
tp_nacionalidade::smallint,
co_pais_origem::smallint,
co_uf_nasc::smallint,
co_municipio_nasc::int,
co_pais_residencia::smallint,
co_uf_end::smallint,
co_municipio_end::int,
tp_zona_residencial::smallint,
tp_local_resid_diferenciada::smallint,
in_necessidade_especial::smallint,
in_baixa_visao::smallint,
in_cegueira::smallint,
in_def_auditiva::smallint,
in_def_fisica::smallint,
in_def_intelectual::smallint,
in_surdez::smallint,
in_surdocegueira::smallint,
null::smallint in_visao_monocular,
in_def_multipla::smallint,
in_autismo::smallint,
in_superdotacao::smallint,
co_entidade::int,
id_turma::int,
nu_duracao_turma::smallint,
tp_tipo_local_turma::smallint,
tp_unificada::smallint,
tp_etapa_ensino::smallint,
in_especial_exclusiva::smallint,
in_regular::smallint,
in_eja::smallint,
in_profissionalizante::smallint
from censo_esc_ce.tb_matricula_2019 tm2 
union 
--2020 -------------
select 
nu_ano_censo::smallint,
co_projeto::int,
co_evento::smallint,
co_pessoa_fisica,
id_matricula::bigint,
nu_dia::smallint,
nu_mes::smallint,
nu_ano::smallint,
nu_idade_referencia::smallint,
nu_idade::smallint,
tp_sexo::smallint,
tp_cor_raca::smallint,
tp_nacionalidade::smallint,
co_pais_origem::smallint,
co_uf_nasc::smallint,
co_municipio_nasc::int,
co_pais_residencia::smallint,
co_uf_end::smallint,
co_municipio_end::int,
tp_zona_residencial::smallint,
tp_local_resid_diferenciada::smallint,
in_necessidade_especial::smallint,
in_baixa_visao::smallint,
in_cegueira::smallint,
in_def_auditiva::smallint,
in_def_fisica::smallint,
in_def_intelectual::smallint,
in_surdez::smallint,
in_surdocegueira::smallint,
null::smallint in_visao_monocular,
in_def_multipla::smallint,
in_autismo::smallint,
in_superdotacao::smallint,
co_entidade::int,
id_turma::int,
nu_duracao_turma::smallint,
tp_tipo_local_turma::smallint,
tp_unificada::smallint,
tp_etapa_ensino::smallint,
in_especial_exclusiva::smallint,
in_regular::smallint,
in_eja::smallint,
in_profissionalizante::smallint
from censo_esc_ce.tb_matricula_2020 tm2 
union 
--2021 -------------
select 
nu_ano_censo::smallint,
co_projeto::int,
co_evento::smallint,
co_pessoa_fisica,
id_matricula::bigint,
nu_dia::smallint,
nu_mes::smallint,
nu_ano::smallint,
nu_idade_referencia::smallint,
nu_idade::smallint,
tp_sexo::smallint,
tp_cor_raca::smallint,
tp_nacionalidade::smallint,
co_pais_origem::smallint,
co_uf_nasc::smallint,
co_municipio_nasc::int,
co_pais_residencia::smallint,
co_uf_end::smallint,
co_municipio_end::int,
tp_zona_residencial::smallint,
tp_local_resid_diferenciada::smallint,
in_necessidade_especial::smallint,
in_baixa_visao::smallint,
in_cegueira::smallint,
in_def_auditiva::smallint,
in_def_fisica::smallint,
in_def_intelectual::smallint,
in_surdez::smallint,
in_surdocegueira::smallint,
null::smallint in_visao_monocular,
in_def_multipla::smallint,
in_autismo::smallint,
in_superdotacao::smallint,
co_entidade::int,
id_turma::int,
nu_duracao_turma::smallint,
tp_tipo_local_turma::smallint,
tp_unificada::smallint,
tp_etapa_ensino::smallint,
in_especial_exclusiva::smallint,
in_regular::smallint,
in_eja::smallint,
in_profissionalizante::smallint
from censo_esc_ce.tb_matricula_2021 tm2 
union 
--2022 -------------
select 
nu_ano_censo::smallint,
co_projeto::int,
co_evento::smallint,
co_pessoa_fisica,
id_matricula::bigint,
nu_dia::smallint,
nu_mes::smallint,
nu_ano::smallint,
nu_idade_referencia::smallint,
nu_idade::smallint,
tp_sexo::smallint,
tp_cor_raca::smallint,
tp_nacionalidade::smallint,
co_pais_origem::smallint,
co_uf_nasc::smallint,
co_municipio_nasc::int,
co_pais_residencia::smallint,
co_uf_end::smallint,
co_municipio_end::int,
tp_zona_residencial::smallint,
tp_local_resid_diferenciada::smallint,
in_necessidade_especial::smallint,
in_baixa_visao::smallint,
in_cegueira::smallint,
in_def_auditiva::smallint,
in_def_fisica::smallint,
in_def_intelectual::smallint,
in_surdez::smallint,
in_surdocegueira::smallint,
null::smallint in_visao_monocular,
in_def_multipla::smallint,
in_autismo::smallint,
in_superdotacao::smallint,
co_entidade::int,
id_turma::int,
nu_duracao_turma::smallint,
tp_tipo_local_turma::smallint,
tp_unificada::smallint,
tp_etapa_ensino::smallint,
in_especial_exclusiva::smallint,
in_regular::smallint,
in_eja::smallint,
in_profissionalizante::smallint
from censo_esc_ce.tb_matricula_2022 tm2 
union 
--2023 -------------
select 
nu_ano_censo::smallint,
co_projeto::int,
co_evento::smallint,
co_pessoa_fisica,
id_matricula::bigint,
nu_dia::smallint,
nu_mes::smallint,
nu_ano::smallint,
nu_idade_referencia::smallint,
nu_idade::smallint,
tp_sexo::smallint,
tp_cor_raca::smallint,
tp_nacionalidade::smallint,
co_pais_origem::smallint,
co_uf_nasc::smallint,
co_municipio_nasc::int,
co_pais_residencia::smallint,
co_uf_end::smallint,
co_municipio_end::int,
tp_zona_residencial::smallint,
tp_local_resid_diferenciada::smallint,
in_necessidade_especial::smallint,
in_baixa_visao::smallint,
in_cegueira::smallint,
in_def_auditiva::smallint,
in_def_fisica::smallint,
in_def_intelectual::smallint,
in_surdez::smallint,
in_surdocegueira::smallint,
in_visao_monocular::smallint,
in_def_multipla::smallint,
in_autismo::smallint,
in_superdotacao::smallint,
co_entidade::int,
id_turma::int,
nu_duracao_turma::smallint,
tp_tipo_local_turma::smallint,
tp_unificada::smallint,
tp_etapa_ensino::smallint,
in_especial_exclusiva::smallint,
in_regular::smallint,
in_eja::smallint,
in_profissionalizante::smallint
from censo_esc_ce.tb_matricula_2023 tm2 
)

/*
--ULTIMA MATRÍCULA
DROP TABLE if exists base_identificada.tb_ultima_matricula;
CREATE TABLE base_identificada.tb_ultima_matricula_inicial as (
with pessoa as (
select 
co_pessoa_fisica,
max(nu_ano_censo) nu_ano_censo 
from censo_esc_ce.tb_matricula_censo_alinhado tmca 
where tp_etapa_ensino is not null
group by 1 
)
select 
nu_ano_censo, id_matricula ,co_pessoa_fisica,id_turma,tp_etapa_ensino,co_entidade 
from pessoa p   
join censo_esc_ce.tb_matricula_censo_alinhado tmca using(nu_ano_censo,co_pessoa_fisica)
where tp_etapa_ensino is not null
);
create index idx_co_pessoa_ano_inicial  on base_identificada.tb_ultima_matricula_inicial (co_pessoa_fisica,nu_ano_censo) ;
*/

/*
--ULTIMA SITUAÇÃO -----------
DROP TABLE if exists base_identificada.tb_ultima_situacao;
CREATE TABLE base_identificada.tb_ultima_situacao as (
with pessoa as (
select 
co_pessoa_fisica,
max(nu_ano_censo) nu_ano_censo 
from censo_esc_ce.tb_situacao_alinhado tmca 
group by 1 
)
select 
*
from pessoa p   
join censo_esc_ce.tb_situacao_alinhado tmca using(nu_ano_censo,co_pessoa_fisica)
where tp_etapa_ensino is not null
);
create index idx_co_pessoa_ano  on base_identificada.tb_ultima_situacao (co_pessoa_fisica,nu_ano_censo);
*/