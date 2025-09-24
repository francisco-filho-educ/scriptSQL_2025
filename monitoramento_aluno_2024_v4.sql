drop table if exists dw_sige.tb_cubo_aluno_junho; 
create table dw_sige.tb_cubo_aluno_junho as (
--- USANDO A TABELA ETAPAMODALIDADE:
with turma as (
select tt.*,
tn.ds_turno,
ds_etapa ds_etapa_oferta
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
join academico.tb_etapa et on et.ci_etapa = cd_etapa 
where
tt.nr_anoletivo = 2024
and tt.cd_prefeitura = 0
--and tt.cd_nivel in (26,27,28)
and tt.fl_ativo = 'S' 
--and cd_etapa <> 137
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
                              and tut.cd_dependencia_administrativa = 2)
)
--select * from turma 
,anexo_prisional as ( 
select
ci_turma,
ttl.nm_tipo_local ds_prisional,
tlf.cd_tipo_local cd_prisional
from rede_fisica.tb_ambiente ta 
join turma t on ta.ci_ambiente = t.cd_ambiente
join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
join rede_fisica.tb_local_funcionamento tlf on  tlf.ci_local_funcionamento = lut.cd_local_funcionamento 
join rede_fisica.tb_tipo_local ttl on ttl.ci_tipo_local = tlf.cd_tipo_local 
where 
tlf.cd_tipo_local in (3,4)
group by 1,2,3
)

,ult_ent as (
  select
  cd_aluno,cd_turma,tu.dt_enturmacao
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2024
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ) --select count(1) from ult_ent 
,mult  as(
select
tm.cd_turma,
ds_turma,
ti.cd_nivel,
ti.cd_etapa,
dt_enturmacao,
tm.cd_aluno,
ti.cd_modalidade,
ds_etapa_oferta,
ds_turno
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
join ult_ent using(cd_turma,cd_aluno)
join turma t on ci_turma = tm.cd_turma 
where 
tm.nr_anoletivo = 2024
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
ds_etapa_oferta,
ds_turno
from ult_ent tu
join turma tt on tu.cd_turma = ci_turma
where 
not exists (select 1 from mult where tu.cd_aluno = mult.cd_aluno)
),
aluno_etapa as(
select * from mult
union
select * from outras
) --select * from aluno_etapa
, etapas_padronizadas as(
select
cd_aluno,
cd_turma,
case when cd_etapa in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
                                                               then 'Regular'
       when cd_etapa in (213,214,195,194,175,196,174,173) or cd_modalidade = 38  then 1 else 0 end fl_eja,
ae.cd_nivel,
tn.ds_nivel,
case when cd_newetapa is null  then cd_etapa else cd_newetapa end cd_etapa,
case when cd_newetapa is null  then ds_etapa else ds_newetapa end ds_etapa,
ds_etapa_oferta
from aluno_etapa ae
join academico.tb_nivel tn on ci_nivel = cd_nivel 
join academico.tb_etapa on ci_etapa = ae.cd_etapa
left join academico.tb_etapa_etapamodalidade tee using(cd_etapa,cd_modalidade,cd_nivel)
)
--select ds_etapa, cd_etapa,ds_nivel, fl_eja,  count(1) from etapas_padronizadas group by 1,2,3,4 order by 1
,deficiencias as (
select 
cd_aluno,
max(case when cd_deficiencia =  1 Then 1 else 0 end)  fl_cegueira,
max(case when cd_deficiencia =  2 Then 1 else 0 end)  fl_baixa_visao,
max(case when cd_deficiencia =  3 Then 1 else 0 end)  fl_surdez,
max(case when cd_deficiencia =  4 Then 1 else 0 end)  fl_deficiencia_auditiva,
max(case when cd_deficiencia =  5 Then 1 else 0 end)  fl_surdocegueira,
max(case when cd_deficiencia =  6 Then 1 else 0 end)  fl_deficiencia_fisica,
max(case when cd_deficiencia =  7 Then 1 else 0 end)  fl_deficiencia_intelectual,
max(case when cd_deficiencia =  8 Then 1 else 0 end)  fl_deficiencia_multipla,
max(case when cd_deficiencia in (9,10,11,12,24) Then 1 else 0 end)  fl_autismo,
max(case when cd_deficiencia =  13  Then 1 else 0 end)  fl_altas_habilidades_superdotacao,
max(case when cd_deficiencia =  14  Then 1 else 0 end)  fl_depressao,
max(case when cd_deficiencia =  15  Then 1 else 0 end)  fl_discalculia,
max(case when cd_deficiencia =  16  Then 1 else 0 end)  fl_dislalia,
max(case when cd_deficiencia =  17  Then 1 else 0 end)  fl_dislexia,
max(case when cd_deficiencia =  18  Then 1 else 0 end)  fl_epilepsia,
max(case when cd_deficiencia =  19  Then 1 else 0 end)  fl_esquizofrenia,
max(case when cd_deficiencia =  20  Then 1 else 0 end)  fl_síndrome_de_down,
max(case when cd_deficiencia =  21  Then 1 else 0 end)  fl_síndrome_do_panico,
max(case when cd_deficiencia =  22  Then 1 else 0 end)  fl_transtorno_opositor_desafiador,
max(case when cd_deficiencia =  23  Then 1 else 0 end)  fl_tdah,
max(case when cd_deficiencia =  25  Then 1 else 0 end)  fl_visao_monocular
from academico.tb_aluno_deficiencia tad 
group by 1
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
extract(year from AGE('2024-05-31'::date,ta.dt_nascimento)) nr_idade,
case when fl_possui_cpf then 1 else 0 end fl_possui_cpf,
case when ta.fl_bolsaescola = 'S' then 1 else 0 end fl_possui_bolsa_escola,
case when ta.nr_identificacao_social is not null then 1 else 0 end fl_possui_nis,
ta.nr_cpf,
ta.nr_identificacao_social,
case when ta.fl_transporte = 'S' then 1 else 0 end ds_transporte,
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
coalesce( fl_síndrome_de_down ,0) fl_síndrome_de_down,
coalesce( fl_síndrome_do_panico ,0) fl_síndrome_do_panico,
coalesce( fl_transtorno_opositor_desafiador ,0) fl_transtorno_opositor_desafiador,
coalesce( fl_tdah ,0) fl_tdah,
coalesce( fl_visao_monocular  ,0) fl_visao_monocular
from academico.tb_aluno ta
join ult_ent et on et.cd_aluno = ci_aluno
left join academico.tb_raca tr on tr.ci_raca = ta.cd_raca
left join academico.tb_etnia_indigena tei on tei.ci_etnia_indigena = ta.cd_etnia_indigena 
left join deficiencias  d on ci_aluno =  d.cd_aluno
)
--,relatorio as (
select 
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
tmc.ci_municipio_censo id_municipio,
upper(tmc.nm_municipio) AS nm_municipio,
case 
when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
when  tut.ci_unidade_trabalho = 47258 then 'CREAECE' 
when tut.nr_codigo_unid_trab in (
'23046490',
'23234580',
'23236574',
'23237775',
'23015705',
'23024291',
'23022248',
'23017368',
'23050764',
'23051930',
'23277890',
'23127430',
'23135425',
'23221348',
'23093935',
'23245026',
'23246634',
'23144793',
'23156210',
'23074701',
'23072237',
'23072865',
'23069619',
'23225416',
'23069988',
'23065214') then 'TEMPO INTEGRAL'
when tut.cd_categoria is null then 'Não se aplica'
else upper(tc.nm_categoria) end AS nm_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
et.*,
ds_turno,
a.*
from etapas_padronizadas et 
inner join aluno a on ci_aluno = cd_aluno
inner join turma t on et.cd_turma = t.ci_turma
inner join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
ORDER BY 1
) ;

select ds_nivel, ds_etapa, ds_etapa_oferta , count(1) from dw_sige.tb_cubo_aluno_junho group by 1,2,3
