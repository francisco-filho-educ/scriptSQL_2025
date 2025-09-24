with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2021 
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
),
ult_ent as (
  select
  cd_aluno,cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2021 
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
), mat as (
 select 
cd_unidade_trabalho,
count(1) total,
sum(case when cd_etapa in (126,127,128,129) then 1 else 0 end) fund_af,
sum(case when cd_etapa = 126 then 1 else 0 end ) a6_fund,
sum(case when cd_etapa = 127 then 1 else 0 end ) a7_fund,
sum(case when cd_etapa = 128 then 1 else 0 end ) a8_fund,
sum(case when cd_etapa = 129 then 1 else 0 end ) a9_fund,
sum(case when cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) then 1 else 0 end) medio_total_r,
sum(case when cd_etapa in(162,184,188) then 1 else 0 end) nr_1_serie,
sum(case when cd_etapa in(163,185,189) then 1 else 0 end) nr_2_serie,
sum(case when cd_etapa in(164,186,190) then 1 else 0 end) nr_3_serie,
sum(case when cd_etapa in (194,195,175,196,213,214) then 1 else 0 end) total_eja_pres,
sum(case when cd_etapa in (173,174) then 1 else 0 end) eja_semi_total
--cd_nivel, cd_etapa, ds_etapa, count(1)
from  ult_ent tue
join turma tt on tt.ci_turma = tue.cd_turma
group by 1
) SELECT 
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
sum(a6_fund) a6_fund,
sum(a7_fund) a7_fund,
sum(a8_fund) a8_fund,
sum(a9_fund) a9_fund,
sum(nr_1_serie) nr_1_serie,
sum(nr_2_serie) nr_2_serie,
sum(nr_3_serie) nr_3_serie,
sum(total_eja_pres) total_eja_pres,
sum(eja_semi_total) eja_semi_total
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
group by 1,2
ORDER BY 1,2
