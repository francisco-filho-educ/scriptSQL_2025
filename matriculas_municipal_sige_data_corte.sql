with turma as (
select *
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2024
and tt.cd_nivel in (26,27,28)
and tt.fl_ativo = 'S' 
and cd_etapa <> 137
and cd_prefeitura = 0 
)
--select sum(qtdenturmados) from turma 
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
),
ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turma t on ci_turma=cd_turma 
  where t.nr_anoletivo=2024 --- ANO LETIVO
        and dt_enturmacao::date<='2024-06-03'  -- DATA DA ENTURMAÇAO > DATA DA DESENTURMAÇAO OU ESTA DEVE SER NULA
        and (dt_desenturmacao::date>'2024-06-03' or dt_desenturmacao is null)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,cd_turma
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join academico.tb_turma t 
  	on cd_turma=ci_turma 
  	--and cd_nivel=27  -- SEELECIONA A ETAPA DE ENSINO
  	--and (cd_etapa in (164,186,190,214) or cd_anofinaleja=2) ---- SELECIONA AS SÉRIES
)
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
and ti.cd_prefeitura = 0 --and cd_turma = 965911

) -- select * from mult
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
cd_turma,
case when cd_etapa in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
                                     then 'Regular'
    when cd_etapa in (213,214,195,194,175,196,174,173) or cd_modalidade = 38 then 'EJA' else 'OUTRO' end fl_eja,
case when cd_nivel = 28 then 'Educação Infantil'
     when cd_nivel = 26 then 'Ensino Fundamental'
     when cd_nivel = 27 then 'Ensino Médio' end ds_nivel,
case when cd_newetapa is null  then cd_etapa else cd_newetapa end cd_etapa,
case when cd_newetapa is null  then ds_etapa else ds_newetapa end ds_etapa,
count(1) qtd_alunos
from aluno_etapa ae
join academico.tb_etapa on ci_etapa = ae.cd_etapa
left join academico.tb_etapa_etapamodalidade tee using(cd_etapa,cd_modalidade,cd_nivel)
group by 1,2,3,4,5
)
--select  sum(qtd_alunos) from etapas_padronizadas
,relatorio as (
select 
tlf.cd_municipio_censo,
upper(tmc.nm_municipio) AS nm_municipio,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
et.*,
ds_turma,
ds_turno,
coalesce(cd_prisional,0) cd_prisional,
coalesce(ds_prisional,'--') ds_prisional,
qtd_alunos
from etapas_padronizadas et 
inner join turma t on et.cd_turma = t.ci_turma
inner join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join anexo_prisional ap on t.ci_turma = ap.ci_turma 
where
tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
ORDER BY 1
) 
select * from relatorio