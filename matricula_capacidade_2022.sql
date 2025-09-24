with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho,
cd_ambiente,
case when cd_turno in (8,9) then 'Integral' else ds_turno end ds_turno
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2022
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2 and tut.cd_unidade_trabalho_pai = 1)
) --select count(1), count(distinct ci_turma ) from turma 
,
turma_cap as (
select 
ci_turma,
sum(case when round(COALESCE(tda.nr_area::numeric,0) / 1.2,0) >= 45 then 45 else round(COALESCE(tda.nr_area::numeric,0) / 1.2,0) end)  capacidade
from turma tt
join rede_fisica.tb_ambiente tda on ci_ambiente = tt.cd_ambiente --and tt.cd_unidade_trabalho = 47757
group by 1
) --select count(1), count(distinct ci_turma ) from turma_cap
,
ult_ent as (
  select
  cd_turma,
  count(1) nr_mat
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2022
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  group by 1
  ),
mat as (
 select 
cd_unidade_trabalho,
sum(nr_mat) matricula,
sum(capacidade) capacidade
from  ult_ent tue
join turma tt on tt.ci_turma = tue.cd_turma
join turma_cap tp on tt.ci_turma = tp.ci_turma
group by 1
) SELECT 
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
matricula,
capacidade
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
--and tut.cd_categoria =9
ORDER BY 1,3,4,6;

