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
tt.nr_anoletivo = 2022 
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
)
,
ult_ent as (
  select
  cd_aluno,cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2022
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ),
  mat as (
 select 
0 cd_unidade_trabalho,
count(1) total,
sum(case when cd_nivel = 28 then 1 else 0 end) total_infantil,
sum(case when cd_etapa = 180 then 1 else 0 end) creche,
sum(case when cd_etapa = 181 then 1 else 0 end) pre_escola,
sum(case when cd_etapa = 177 and cd_nivel = 28 then 1 else 0 end) mult_infantil,
sum(case when cd_etapa in (121,122,123,124,125,126,127,128,129,183) then 1 else 0 end) total_fund,
sum(case when cd_etapa in (121,122,123,124,125) then 1 else 0 end) fund_ai,
sum(case when cd_etapa in (126,127,128,129) then 1 else 0 end) fund_af,
sum(case when cd_etapa = 183 then 1 else 0 end ) mult_fund,
sum(case when cd_etapa = 121 then 1 else 0 end ) a1_fund,
sum(case when cd_etapa = 122 then 1 else 0 end ) a2_fund,
sum(case when cd_etapa = 123 then 1 else 0 end ) a3_fund,
sum(case when cd_etapa = 124 then 1 else 0 end ) a4_fund,
sum(case when cd_etapa = 125 then 1 else 0 end ) a5_fund,
sum(case when cd_etapa = 126 then 1 else 0 end ) a6_fund,
sum(case when cd_etapa = 127 then 1 else 0 end ) a7_fund,
sum(case when cd_etapa = 128 then 1 else 0 end ) a8_fund,
sum(case when cd_etapa = 129 then 1 else 0 end ) a9_fund,
sum(case when cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) then 1 else 0 end) medio_total_r,
sum(case when cd_etapa in(162,184,188) then 1 else 0 end) nr_1_serie,
sum(case when cd_etapa in(163,185,189) then 1 else 0 end) nr_2_serie,
sum(case when cd_etapa in(164,186,190) then 1 else 0 end) nr_3_serie,
sum(case when cd_etapa in(165,187,191) then 1 else 0 end) nr_4_serie,
sum(case when cd_etapa in (213,214,195,194,175,196,174,173)then 1 else 0 end)  Total_ejas,
sum(case when cd_etapa in (194,195,175,196,213,214) then 1 else 0 end) eja_escola_total,
sum(case when cd_etapa in (194,195,175) then 1 else 0 end) eja_escola_fund,
sum(case when cd_etapa in(196,213,214) then 1 else 0 end) eja_escola_medio,
--considera como ceja somente as turmas semipresenciais das escolas
sum(case when cd_etapa in (173,174) then 1 else 0 end) total_ceja,
sum(case when cd_etapa = 174 then 1 else 0 end) ceja_fund,
sum(case when cd_etapa = 173 then 1 else 0 end) ceja_medio
--considera como ceja a categoria das escolas
--sum(case when cd_etapa in (194,195,175,174)  and cd_categoria = 6 then 1 else 0 end) total_ceja,
--sum(case when cd_etapa in (194,195,175,174)  and cd_categoria = 6 then 1 else 0 end) ceja_fund,
--sum(case when cd_etapa in (196,213,214,173)  and cd_categoria = 6  then 1 else 0 end) ceja_medio
from  turma tt
join ult_ent tue on tt.ci_turma = tue.cd_turma
group by 1
) SELECT --* from mat
--
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
coalesce(	total	,	0)	total	,
coalesce(	total_infantil	,	0)	total_infantil	,
coalesce(	creche	,	0)	creche	,
coalesce(	pre_escola	,	0)	pre_escola	,
coalesce(	mult_infantil	,	0)	mult_infantil	,
coalesce(	total_fund	,	0)	total_fund	,
coalesce(	fund_ai	,	0)	fund_ai	,
coalesce(	fund_af	,	0)	fund_af	,
coalesce(	mult_fund	,	0)	mult_fund	,
coalesce(	a1_fund	,	0)	a1_fund	,
coalesce(	a2_fund	,	0)	a2_fund	,
coalesce(	a3_fund	,	0)	a3_fund	,
coalesce(	a4_fund	,	0)	a4_fund	,
coalesce(	a5_fund	,	0)	a5_fund	,
coalesce(	a6_fund	,	0)	a6_fund	,
coalesce(	a7_fund	,	0)	a7_fund	,
coalesce(	a8_fund	,	0)	a8_fund	,
coalesce(	a9_fund	,	0)	a9_fund	,
coalesce(	medio_total_r	,	0)	medio_total_r	,
coalesce(	nr_1_serie	,	0)	nr_1_serie	,
coalesce(	nr_2_serie	,	0)	nr_2_serie	,
coalesce(	nr_3_serie	,	0)	nr_3_serie	,
coalesce(	nr_4_serie	,	0)	nr_4_serie	,
coalesce(	total_ejas	,	0)	total_ejas	,
coalesce(	eja_escola_total,0) eja_escola_total, 
coalesce(   eja_escola_fund,	0)	eja_escola_fund	,
coalesce(	eja_escola_medio,	0)	eja_escoal_medio	,
coalesce(	total_ceja	,	0)	total_ceja	,
coalesce(	ceja_fund	,	0)	ceja_funda	,
coalesce(	ceja_medio	,	0)	ceja_medio	
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
and tut.ci_unidade_trabalho in (select distinct cd_unidade_trabalho from turma)
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
--ORDER BY 1,3,4,6;

-- cci
select 
--nm_unidade_trabalho,
--nm_sigla,
count(distinct tut.ci_unidade_trabalho ) nr_escolas,
count(1) nr_matriculas
from util.tb_unidade_trabalho tut 
left join sigecci.tb_enturmacao te on tut.ci_unidade_trabalho = te.cd_cci_indicado 
where
te.nr_anoletivo = 2022
and te.fl_apto 
and te .fl_ultima_enturmacao 
and te.fl_enturmado
and te.dt_enturmacao::date <= '2022-09-01'::date
and (te.dt_desenturmacao::date > '2022-09-01'::date or te.dt_desenturmacao is null)
group by 1
