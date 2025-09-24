drop table if exists tmp.ult_ent; 
create table tmp.ult_ent as (
with max_enturm as (
  select --count(1)
  cd_aluno,
  max(ci_enturmacao) ci_enturmacao
  from academico.tb_ultimaenturmacao tu 
  join academico.tb_turma t on ci_turma =  cd_turma and t.nr_anoletivo = tu.nr_anoletivo
  where tu.nr_anoletivo = 2025
  and tu.fl_tipo_atividade <> 'AC'
  and t.cd_prefeitura  = 0 
  group by 1
)
  select
  cd_aluno,cd_turma,tu.dt_enturmacao
  from academico.tb_ultimaenturmacao tu
  join max_enturm using (cd_aluno,ci_enturmacao)
  where tu.nr_anoletivo = 2025 --select count(1) from ult_ent 
);
--drop table if exists dw_sige.tb_cubo_aluno_mes_2025; 
--create table dw_sige.tb_cubo_aluno_mes_2025 as (
--drop table if exists dw_sige.tb_cubo_aluno_junho_2025; 
--create table dw_sige.tb_cubo_aluno_junho_2025 as (
with turma as (
select
nr_anoletivo,
ci_turma cd_turma,
ds_turma,
cd_curso,
nm_curso,
case when fl_possui_estagio = 'S' then 1 else 0 end fl_estagio_curso,
cd_ambiente,
cd_unidade_trabalho,
cd_ofertaitem,
ds_ofertaitem,
tn.ds_turno,
cd_nivel,
cd_etapa,
ds_etapa,
cd_modalidade,
ds_modalidade,
case when cd_etapa = 213 then 1
     when cd_etapa = 214 then 2 else cd_anofinaleja end cd_ano_final_eja,
case when ci_turma in (select distinct cd_turma from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (6404,101519,102499) ) then 1 else 0 end  fl_ppdt
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
join academico.tb_etapa et on et.ci_etapa = cd_etapa 
left join academico.tb_curso tc on tc.ci_curso = cd_curso
left join academico.tb_modalidade tm on ci_modalidade=  cd_modalidade
where
tt.nr_anoletivo = 2025
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tt.fl_ativo = 'S' 
)
--select count(1), count(distinct cd_turma)  from turma 
,local_funcionamento as ( 
select
cd_turma,
tlf.nm_local_funcionamento,
ttl.nm_tipo_local,
tlf.cd_tipo_local,
case when fl_sede then 1 else 0 end fl_sede
from rede_fisica.tb_ambiente ta 
join turma t on ta.ci_ambiente = t.cd_ambiente --and t.cd_turma = 1035494
join rede_fisica.tb_local_funcionamento tlf on  tlf.ci_local_funcionamento = ta.cd_local_funcionamento 
join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = tlf.ci_local_funcionamento and lut.cd_unidade_trabalho =  t.cd_unidade_trabalho
join rede_fisica.tb_tipo_local ttl on ttl.ci_tipo_local = tlf.cd_tipo_local 
--group by 1,2,3,4,5
) --select count(distinct cd_turma) cont, count(1) from local_funcionamento 
--select * from  local_funcionamento 
,mult  as(
select
tm.cd_turma,
ds_turma,
ti.cd_nivel,
ti.cd_etapa ,
dt_enturmacao,
tm.cd_aluno,
ti.cd_modalidade,
ds_turno
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
join tmp.ult_ent using(cd_turma,cd_aluno)
join turma t on t.cd_turma = tm.cd_turma 
where 
tm.nr_anoletivo = 2025
and ti.cd_prefeitura = 0
)
, outras as (
select
cd_turma,
ds_turma,
cd_nivel,
cd_etapa,
dt_enturmacao,
cd_aluno,
cd_modalidade,
ds_turno
from tmp.ult_ent tu
join turma tt using(cd_turma)
where 
not exists (select 1 from mult where tu.cd_aluno = mult.cd_aluno)
),
aluno_etapa as(
select * from mult
union
select * from outras
) --select * from aluno_etapa
--select count(distinct cd_aluno) cont, count(1) linhas from aluno_etapa
, etapas_padronizadas as(
select
cd_aluno,
cd_turma,
case when cd_etapa in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
                                                               then 0
       when cd_etapa in (213,214,195,194,175,196,174,176,173) or cd_modalidade = 38  then 1 else 99 end fl_eja ,
ae.cd_nivel,
tn.ds_nivel,
case when cd_newetapa is null  then cd_etapa else cd_newetapa end cd_etapa_aluno,
case when cd_newetapa is null  then ds_etapa else ds_newetapa end ds_etapa_aluno
from aluno_etapa ae
join academico.tb_nivel tn on ci_nivel = cd_nivel 
join academico.tb_etapa on ci_etapa = ae.cd_etapa
left join academico.tb_etapa_etapamodalidade tee using(cd_etapa,cd_modalidade,cd_nivel)
)
--select count(distinct cd_aluno) cont, count(1) linhas from etapas_padronizadas
--select ds_etapa, cd_etapa,ds_nivel, fl_eja,  count(1) from etapas_padronizadas group by 1,2,3,4 order by 1
,deficiencias as (
select
cd_aluno,
1 fl_possui_deficiencia,
max(case when cd_deficiencia in (1,2,25,3,4,5,6,7,8,9,10,11,12,13,24) then 1 else 0 end) fl_deficiencia_censo,
max(case when cd_deficiencia =  1 Then 1 else 0 end)  fl_cegueira,
max(case when cd_deficiencia =  2 Then 1 else 0 end)  fl_baixa_visao,
max(case when cd_deficiencia =  25  Then 1 else 0 end)  fl_visao_monocular,
max(case when cd_deficiencia =  3 Then 1 else 0 end)  fl_surdez,
max(case when cd_deficiencia =  4 Then 1 else 0 end)  fl_deficiencia_auditiva,
max(case when cd_deficiencia =  5 Then 1 else 0 end)  fl_surdocegueira,
max(case when cd_deficiencia =  6 Then 1 else 0 end)  fl_deficiencia_fisica,
max(case when cd_deficiencia =  7 Then 1 else 0 end)  fl_deficiencia_intelectual,
max(case when cd_deficiencia =  8 Then 1 else 0 end)  fl_deficiencia_multipla,
max(case when cd_deficiencia in (9,10,11,12,24) Then 1 else 0 end)  fl_autismo,
max(case when cd_deficiencia =  13  Then 1 else 0 end)  fl_altas_habilidades_superdotacao,
---- nao conta como deficiencia para o censo
max(case when cd_deficiencia =  14  Then 1 else 0 end)  fl_depressao,
max(case when cd_deficiencia =  15  Then 1 else 0 end)  fl_discalculia,
max(case when cd_deficiencia =  16  Then 1 else 0 end)  fl_dislalia,
max(case when cd_deficiencia =  17  Then 1 else 0 end)  fl_dislexia,
max(case when cd_deficiencia =  18  Then 1 else 0 end)  fl_epilepsia,
max(case when cd_deficiencia =  19  Then 1 else 0 end)  fl_esquizofrenia,
max(case when cd_deficiencia =  20  Then 1 else 0 end)  fl_sindrome_de_down,
max(case when cd_deficiencia =  21  Then 1 else 0 end)  fl_sindrome_do_panico,
max(case when cd_deficiencia =  22  Then 1 else 0 end)  fl_transtorno_opositor_desafiador,
max(case when cd_deficiencia =  23  Then 1 else 0 end)  fl_tdah
from academico.tb_aluno_deficiencia tad
group by 1,2
)
,aluno as ( 
select
ci_aluno,
nm_aluno,
ta.nm_social,
to_char(dt_nascimento,'dd/mm/yyyy')dt_nascimento,
coalesce(ds_raca, 'Não Declarada') ds_raca,
tei.nm_etnia_indigena,
case when ta.fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo, -- 1: masculino | 2: feminino 
extract(year from AGE('2025-05-31'::date,ta.dt_nascimento)) nr_idade,
case when fl_possui_cpf then 1 else 0 end fl_possui_cpf,
case when ta.fl_bolsaescola = 'S' then 1 else 0 end fl_possui_bolsa_escola,
case when ta.nr_identificacao_social is not null then 1 else 0 end fl_possui_nis,
ta.nr_cpf,
ta.nr_identificacao_social,
case when ta.fl_transporte = 'S' then 1 else 0 end fl_transporte,
coalesce( fl_possui_deficiencia,0) fl_possui_deficiencia,
coalesce(fl_deficiencia_censo,0) fl_deficiencia_censo,
coalesce( fl_cegueira ,0) fl_cegueira,
coalesce( fl_baixa_visao  ,0) fl_baixa_visao,
coalesce( fl_surdez ,0) fl_surdez,
coalesce( fl_deficiencia_auditiva ,0) fl_deficiencia_auditiva,
coalesce( fl_surdocegueira  ,0) fl_surdocegueira,
coalesce( fl_deficiencia_fisica ,0) fl_deficiencia_fisica,
coalesce( fl_deficiencia_intelectual  ,0) fl_deficiencia_intelectual,
coalesce( fl_deficiencia_multipla ,0) fl_deficiencia_multipla,
coalesce( fl_autismo  ,0) fl_autismo,
coalesce( fl_altas_habilidades_superdotacao ,0) fl_altas_habilidades_superdotacao,
coalesce( fl_depressao  ,0) fl_depressao,
coalesce( fl_discalculia  ,0) fl_discalculia,
coalesce( fl_dislalia ,0) fl_dislalia,
coalesce( fl_dislexia ,0) fl_dislexia,
coalesce( fl_epilepsia  ,0) fl_epilepsia,
coalesce( fl_esquizofrenia  ,0) fl_esquizofrenia,
coalesce( fl_sindrome_de_down ,0) fl_sindrome_de_down,
coalesce( fl_sindrome_do_panico ,0) fl_sindrome_do_panico,
coalesce( fl_transtorno_opositor_desafiador ,0) fl_transtorno_opositor_desafiador,
coalesce( fl_tdah ,0) fl_tdah,
coalesce( fl_visao_monocular  ,0) fl_visao_monocular,
ds_localizacao_residencia 
from academico.tb_aluno ta
join tmp.ult_ent et on et.cd_aluno = ci_aluno
left join academico.tb_raca tr on tr.ci_raca = ta.cd_raca
left join academico.tb_etnia_indigena tei on tei.ci_etnia_indigena = ta.cd_etnia_indigena 
left join deficiencias  d on ci_aluno =  d.cd_aluno
)
--select count(distinct ci_aluno) cont, count(1) from aluno 
,relatorio as (
select
t.nr_anoletivo,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor,
upper(nm_macrorregiao) nm_macrorregiao,
cd_macrorregiao,
tmc.id_municipio,
upper(tmc.nm_municipio) AS nm_municipio,
case 
when  tut.cd_tipo_unid_trab = 402 then 402 
when  tut.ci_unidade_trabalho in (47258,50410) then 401 
--when tut.nr_codigo_unid_trab in ('') then 'TEMPO INTEGRAL'
when tut.cd_categoria is null then 999
else tut.cd_categoria end AS cd_categoria,
case 
when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
when  tut.ci_unidade_trabalho in (47258,50410) then 'CREAECE' 
--when tut.nr_codigo_unid_trab in ('') then 'TEMPO INTEGRAL'
when tut.cd_categoria is null then 'Não se aplica'
else upper(tc.nm_categoria) end AS nm_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
t.ds_turma,
t.cd_curso,
t.nm_curso,
t.fl_estagio_curso,
t.ds_ofertaitem,
t.ds_turno,
cd_ano_final_eja,
t.cd_etapa cd_etapa_oferta,
t.ds_etapa ds_etapa_oferta,
fl_ppdt,
et.*,
lf.nm_local_funcionamento,
lf.nm_tipo_local,
lf.cd_tipo_local,
lf.fl_sede,
a.*
from etapas_padronizadas et 
inner join aluno a on ci_aluno = cd_aluno
inner join turma t using(cd_turma)
inner join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN public.tb_dm_macroregioes tmc ON tmc.id_municipio = tlf.cd_municipio_censo
left join local_funcionamento lf using (cd_turma)
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
ORDER BY 1
) 
select
	nr_anoletivo,
	cd_crede_sefor,
	nm_crede_sefor,
	cd_macrorregiao,
	nm_macrorregiao,
	id_municipio,
	nm_municipio,
	nm_categoria,
	cd_categoria,
	id_escola_inep,
	nm_escola,
	nm_localizacao_zona,
	fl_sede,
	nm_local_funcionamento,
	cd_tipo_local,
	nm_tipo_local,
	cd_turma,
	ds_turma,
	cd_curso,
	nm_curso,
	fl_estagio_curso,
	ds_ofertaitem,
	ds_turno,
	cd_etapa_oferta,
	ds_etapa_oferta,
	fl_eja,
	cd_ano_final_eja,
	cd_nivel,
	ds_nivel,
	cd_etapa_aluno,
	ds_etapa_aluno,
	cd_aluno,
	nm_aluno,
	nm_social,
	dt_nascimento,
	ds_raca,
	nm_etnia_indigena ,
	ds_sexo,
	nr_idade,
	fl_possui_cpf,
	fl_possui_bolsa_escola,
	fl_possui_nis,
	nr_cpf ,
	nr_identificacao_social ,
	ds_localizacao_residencia,
	fl_transporte,
	fl_possui_deficiencia,
	fl_deficiencia_censo,
	fl_cegueira,
	fl_baixa_visao,
	fl_surdez,
	fl_deficiencia_auditiva,
	fl_surdocegueira,
	fl_deficiencia_fisica,
	fl_deficiencia_intelectual,
	fl_deficiencia_multipla,
	fl_autismo,
	fl_altas_habilidades_superdotacao,
	fl_depressao,
	fl_discalculia,
	fl_dislalia,
	fl_dislexia,
	fl_epilepsia,
	fl_esquizofrenia,
	fl_sindrome_de_down,
	fl_sindrome_do_panico,
	fl_transtorno_opositor_desafiador,
	fl_tdah,
	fl_visao_monocular,
	fl_ppdt,
	to_char(current_timestamp,'dd/mm/yyyy') data_extracao
from relatorio 
);

/*
select 
data_extracao, 
cd_categoria,  
nm_categoria, 
ds_nivel,
count(1) qtd,
count(distinct cd_aluno ) qtd_d
from dw_sige.tb_cubo_aluno_mes_2025 tcam
group by 1,2,3,4;


select
data_extracao,
count(distinct id_escola_inep) qtd_escola,
count(distinct cd_turma ) qtd_turma,
count(distinct cd_aluno ) qtd_aluno,
count(1) qtd_linhas
from dw_sige.tb_cubo_aluno_mes_2025 tcam
group by 1

*/
select data_extracao, count(1) from dw_sige.tb_cubo_mes_acumulado  tcam group by 1