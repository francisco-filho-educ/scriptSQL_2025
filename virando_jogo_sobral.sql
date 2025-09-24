drop table if exists tmp.tb_nao_matriculados_sobral;

create table tmp.tb_nao_matriculados_sobral as (
with ultima as (
select 
co_pessoa_fisica,
max(nu_ano_censo) nu_ano_censo
from censo_esc_ce.tb_situacao_alinhado ts
where tp_etapa_ensino not in (39,40)
group by 1
)
--select --* from ultima where co_pessoa_fisica = 130419919340
,situacao as (
select
*
from censo_esc_ce.tb_situacao_alinhado ts
join ultima using(co_pessoa_fisica, nu_ano_censo)
where EXTRACT (YEAR FROM AGE(CURRENT_DATE, dt_nascimento)) between 15 and 19
and not exists (select 1 from spaece_aplicacao_2022.tb_base_censo_escolar_estadual sp where sp.co_pessoa_fisica =ts.co_pessoa_fisica)
and not exists (select 1 from spaece_aplicacao_2022.tb_base_censo_escolar_municipal sp where sp.co_pessoa_fisica =ts.co_pessoa_fisica)
and tp_etapa_ensino not in (39,40)
),
escolas as (
select 
nu_ano_censo,
co_orgao_regional,
nm_municipio,
co_entidade,
te.no_entidade,
case when tp_dependencia = 1 then 'FEDERAL'
	 when tp_dependencia = 2 then 'ESTADUAL'
	 when tp_dependencia = 3 then 'MUNICIPAL'
	 when tp_dependencia= 4 then 'PRIVADA' end ds_dependencia
from censo_esc_ce.tb_escola_2007_2018 te 
join dw_censo.tb_dm_municipio tdm on id_municipio = te.co_municipio 
where nu_ano_censo >2016
and co_municipio = 2312908
union 
select 
nu_ano_censo,
co_orgao_regional,
nm_municipio,
co_entidade,
te.no_entidade,
case when tp_dependencia = 1 then 'FEDERAL'
	 when tp_dependencia = 2 then 'ESTADUAL'
	 when tp_dependencia = 3 then 'MUNICIPAL'
	 when tp_dependencia = 4 then 'PRIVADA' end ds_dependencia
from censo_esc_ce.tb_escola_2019_2020 te 
join dw_censo.tb_dm_municipio tdm on id_municipio = te.co_municipio 
where co_municipio = 2312908
union 
select 
nu_ano_censo,
co_orgao_regional,
nm_municipio,
co_entidade,
te.no_entidade,
case when tp_dependencia = 1 then 'FEDERAL'
	 when tp_dependencia = 2 then 'ESTADUAL'
	 when tp_dependencia = 3 then 'MUNICIPAL'
	 when tp_dependencia = 4 then 'PRIVADA' end ds_dependencia
from censo_esc_ce.tb_escola_2021_d te 
join dw_censo.tb_dm_municipio tdm on id_municipio = te.co_municipio 
where co_municipio = 2312908
)
select  --* from situacao where co_pessoa_fisica =  116617155598
-- Nome completo do aluno;
tpc.no_pessoa_fisica,
-- Data de nascimento;
--to_char( S.dt_nascimento,'dd/mm/yyyy') dt_nascimento,
 s.dt_nascimento,
-- Nome da mãe;
upper(no_mae)no_mae,
-- ID da educação;
S.co_pessoa_fisica,
-- Último ano escolar concluído (não o ano que parou e sim o último ano que concluiu);
S.nu_ano_censo,
case when s.in_concluinte = 1 and cd_etapa = 3 and tp_situacao  = 5 then 'SIM' else 'NÃO' end fl_concluinte,
-- Escola do último ano cursado por completo
e.co_entidade,
upper(e.no_entidade) nm_escola,
ds_dependencia,
upper(tce.no_bairro) bairro_escola,
ds_etapa_ensino
-- Telefone de contato (quando houver)
from situacao s 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = s.tp_etapa_ensino
join escolas e on e.co_entidade = s.co_entidade and e.nu_ano_censo = s.nu_ano_censo 
left join base_identificada.tb_pessoa_censo tpc on tpc.nu_ano_censo = s.nu_ano_censo and s.co_pessoa_fisica =  tpc.co_pessoa_fisica 
left join censo_esc_ce.tb_catalogo_escolas_2021 tce on tce.co_entidade::int = s.co_entidade
where 
s.co_municipio =  2312908
);

/*
,
case when ts.in_concluinte = 1 and cd_etapa = 3 and ts.tp_situacao  = 5 then 1 else 0 end fl_concluinte
-- Nome completo do aluno;
tpc.no_pessoa_fisica,
-- Data de nascimento;
a.dt_nascimemto,
-- Nome da mãe;
no_mae,
-- ID da educação;
a.co_pessoa_fisica,
-- Último ano escolar concluído (não o ano que parou e sim o último ano que concluiu);
-- Escola do último ano cursado por completo
-- Telefone de contato (quando houver)
from alunos a
left join base_identificada.tb_pessoa_censo tpc on tpc.nu_ano_censo = a.nu_ano_censo and tpc.co_pessoa_fisica = a.co_pessoa_fisica
where not exists (select 1 from spaece_aplicacao_2022.tb_base_censo_escolar_municipal em where  em.co_pessoa_fisica = a.co_pessoa_fisica)
*/
/*
* comparativo censo / sige
*/
with relatorio as (
select
tm.*,
tds.ci_aluno,
tds.nm_aluno,
tds.nm_mae,
tds.cd_municipio,
tb.ci_bairro,
tb.ds_bairro,
ds_localidade,
tds.ds_logradouro,
tds.ds_numero,
concat( ca.nr_ddd_celular::text,'-',ca.nr_fone_celular) celular,
concat(ca.nr_ddd_residencia::text,'-',ca.nr_fone_residencia) fone_residencial
from tmp.tb_nao_matriculados_sobral tm 
left join dl_sige.academico_tb_aluno tds on tds.cd_inep_aluno = tm.co_pessoa_fisica and tm.dt_nascimento::date = tds.dt_nascimento::date
left join dl_sige.tb_bairros tb on tb.ci_bairro = tds.cd_bairro 
left join tmp.tb_contato_aluno ca on ca.ci_aluno = tds.ci_aluno and cd_inep_aluno is not null
left join dl_sige.tb_localidades tl on tl.ci_localidade = cd_municipio
)
select  --count(1) from relatorio where ci_aluno is null --5137
case when no_pessoa_fisica is null then nm_aluno else no_pessoa_fisica end nm_aluno ,
to_char(dt_nascimento,'dd/mm/yyyy') dt_nascimento,
case when no_mae is null or no_mae = '' then nm_mae else no_mae end nm_mae ,
co_pessoa_fisica::bigint,
ci_aluno::bigint,
upper(ds_bairro) bairro_aluno,
upper(ds_localidade)ds_localidade,
upper(ds_logradouro)ds_logradouro,
ds_numero,
celular,
fone_residencial,
nu_ano_censo,
fl_concluinte,
co_entidade::bigint,
nm_escola,
ds_dependencia,
bairro_escola,
ds_etapa_ensino
from relatorio
where not exists(select 1 from sige_2022.academico_tb_ultimaenturmacao atu where ci_aluno =  cd_aluno)
and ci_bairro in (40504,42142,39032,59640,60654)