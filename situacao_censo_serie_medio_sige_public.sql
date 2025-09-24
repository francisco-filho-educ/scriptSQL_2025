with turmas as ( 
select 
*
from academico.tb_turma tt 
where nr_anoletivo = 2022
and cd_prefeitura  = 0
and cd_nivel = 27
and cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.cd_dependencia_administrativa = 2 and tut.cd_unidade_trabalho_pai in (21,22,23))
)
,resultado as (
select
re.cd_aluno,
re.cd_turma,
case when re.cd_tiporesultado in (1,2,6) then 1 else cd_tiporesultado end cd_situacao,
case when re.cd_tiporesultado in (1,2,6) then 'Aprovado' else ds_tiporesultado end ds_situacao
from public.tb_aluno_resultado_atual re
join academico.tb_tiporesultado tr on tr.ci_tiporesultado = re.cd_tiporesultado  --group by 1,2
union 
select 
tasma.cd_aluno,
tasma.cd_turma,
5  cd_situacao,
'Abandono' ds_situacao
from public.tb_aluno_situacao_motivo_atual tasma 
join academico.tb_situacao ts on ts.ci_situacao = tasma.cd_situacao
join academico.tb_motivo tm on tm.ci_motivo = tasma.cd_motivo 
and ((cd_situacao = 1 AND cd_motivo = 1) OR (cd_situacao = 3 AND fl_motivo_cancelamento = 'DF'))
  and not exists(select 1 from public.tb_aluno_resultado_atual trs where trs.cd_aluno=tasma.cd_aluno)
) --select cd_situacao, ds_situacao from  resultado group by 1,2
,etapas as (
select 
cd_etapa,
cd_newetapa cd_etapa_serie,
ds_newetapa ds_etapa_serie
from academico.tb_etapa_etapamodalidade tee 
where cd_nivel =27
group by 1,2,3
 )
, resultado_final as ( 
select 
nr_anoletivo,
cd_unidade_trabalho,
count(1) nr_matricula,
sum(case when cd_situacao = 1 then 1 else 0 end) nr_aprovado,
sum(case when cd_situacao = 3 then 1 else 0 end) nr_reprovado,
sum(case when cd_situacao = 5 then 1 else 0 end) nr_abandono
from resultado tr 
join turmas t on ci_turma = cd_turma
group by 1,2
) 
select --*  from resultado_final--count(1) from notas
nr_anoletivo,
crede.ci_unidade_trabalho id_crede_sefor,
crede.nm_sigla nm_crede_sefor,
tmc.ci_municipio_censo id_municipio,
tmc.nm_municipio,
tut.nr_codigo_unid_trab id_inep_escola,
tut.nm_unidade_trabalho nm_escola,
-- total
nr_aprovado,
round(case when nr_matricula <1 then 0.0  else nr_aprovado / nr_matricula::numeric end,2) tx_aprovacao,
nr_reprovado,
round(case when nr_matricula <1 then 0.0  else nr_reprovado / nr_matricula::numeric end,2) tx_reprovacao,
nr_abandono,
round(case when nr_matricula <1 then 0.0  else nr_abandono / nr_matricula::numeric end,2) tx_abandono
from resultado_final t 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
left JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
left JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tlut.fl_sede = TRUE 
and tut.cd_dependencia_administrativa = 2
and tut.cd_tipo_unid_trab = 401 