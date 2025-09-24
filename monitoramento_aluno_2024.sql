with turma as (
select *
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2024
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tt.fl_ativo = 'S' 
and cd_etapa <> 137
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
            and tut.cd_dependencia_administrativa = 2)
)
,ult_ent as (
  select
  cd_aluno,
  --max(cd_turma) 
  cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2024
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma) --group by 1
  ) --select count(1) from ult_ent  
 ,mult  as(
select
tm.cd_turma,
ti.cd_nivel,
ti.cd_etapa,
tm.cd_aluno,
ti.cd_modalidade
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
join ult_ent using(cd_turma,cd_aluno)
where 
tm.nr_anoletivo = 2024
and ti.cd_prefeitura = 0

) --select * from mult
, outras as (
select
cd_turma,
cd_nivel,
cd_etapa,
--dt_enturmacao,
cd_aluno,
cd_modalidade
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
    when cd_etapa in (213,214,195,194,175,196,174,173)  then 'EJA' else 'OUTRO' end fl_eja,
case when cd_nivel = 28 then 'Educação Infantil'
     when cd_nivel = 26 then 'Ensino Fundamental'
     when cd_nivel = 27 then 'Ensino Médio' end ds_nivel,
case when cd_newetapa is null  then cd_etapa else cd_newetapa end cd_etapa,
case when cd_newetapa is null  then ds_etapa else ds_newetapa end ds_etapa
from aluno_etapa ae
join academico.tb_etapa on ci_etapa = ae.cd_etapa
left join academico.tb_etapa_etapamodalidade tee using(cd_etapa,cd_modalidade,cd_nivel)
)
--select ds_etapa, cd_etapa,  count(1) from etapas_padronizadas group by 1,2
--select count(1) cont, count(distinct cd_aluno) qtd from etapas_padronizadas
,
aluno as ( 
select 
ci_aluno,
nm_aluno,
to_char(dt_nascimento,'dd/mm/yyyy')dt_nascimento,
coalesce(ds_raca, 'Não Declarado') ds_raca,
case when ta.fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo -- 1: masculino | 2: feminino 
from academico.tb_aluno ta
join ult_ent et on et.cd_aluno = ci_aluno
left join academico.tb_raca tr on tr.ci_raca = ta.cd_raca
group by 1,2,3,4,5
)
--select count(1) cont, count(distinct ci_aluno) qtd from aluno  --join etapas_padronizadas et on ci_aluno = cd_aluno
,relatorio as (
select 
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
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
) 
--select count(1) cont, count(distinct ci_aluno)  from relatorio
select * from relatorio