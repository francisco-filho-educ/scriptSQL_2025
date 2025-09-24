with mat as (
select 
'ESTADUAL' ds_dependencia,
co_orgao_regional,
co_municipio,
co_entidade,
no_entidade,
cd_etapa,
cd_ano_serie,
cd_etapa_fase,
in_eja fl_eja,
in_regular fl_regular,
concat('2013-04-17 ',tx_hr_inicial,':',tx_mi_inicial)::timestamp inicio,
count(1 ) nr_matriculas
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal ts
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = ts.tp_etapa_ensino_matricula  
where co_municipio = 2300200 and  in_eja = 1 and cd_etapa_fase = 4
group by 1,2,3,4,5,6,7,8,9,10,11
union 
select 
'MUNICIPAL' ds_dependencia,
co_orgao_regional,
co_municipio,
co_entidade,
no_entidade,
cd_etapa,
cd_ano_serie,
cd_etapa_fase,
in_eja fl_eja,
in_regular fl_regular,
concat('2013-04-17 ',tx_hr_inicial,':',tx_mi_inicial)::timestamp inicio,
count(1 ) nr_matriculas
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal ts
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = ts.tp_etapa_ensino_matricula 
group by 1,2,3,4,5,6,7,8,9,10,11
)
select
co_orgao_regional,
nm_municipio,
ds_dependencia,
co_entidade,
no_entidade,
coalesce (sum(nr_matriculas),0) mat_total_geral,
coalesce (sum(case when cd_etapa = 2 and  fl_regular = 1 then nr_matriculas end),0) tot_fund,
coalesce (sum(case when cd_etapa = 2 and  cd_etapa_fase = 3 then nr_matriculas end),0) fund_ai,
coalesce (sum(case when cd_etapa = 2 and  cd_etapa_fase = 4 then nr_matriculas end),0) fund_af,
coalesce (sum(case when cd_etapa = 2 and  cd_ano_serie = 	1	then nr_matriculas end),0) serie_1	,
coalesce (sum(case when cd_etapa = 2 and  cd_ano_serie = 	2	then nr_matriculas end),0) serie_2	,
coalesce (sum(case when cd_etapa = 2 and  cd_ano_serie = 	3	then nr_matriculas end),0) serie_3	,
coalesce (sum(case when cd_etapa = 2 and  cd_ano_serie = 	4	then nr_matriculas end),0) serie_4	,
coalesce (sum(case when cd_etapa = 2 and  cd_ano_serie = 	5	then nr_matriculas end),0) serie_5	,
coalesce (sum(case when cd_etapa = 2 and  cd_ano_serie = 	6	then nr_matriculas end),0) serie_6	,
coalesce (sum(case when cd_etapa = 2 and  cd_ano_serie = 	7	then nr_matriculas end),0) serie_7	,
coalesce (sum(case when cd_etapa = 2 and  cd_ano_serie = 	8	then nr_matriculas end),0) serie_8	,
coalesce (sum(case when cd_etapa = 2 and  cd_ano_serie = 	9	then nr_matriculas end),0) serie_9	,
coalesce (sum(case when cd_etapa = 3 and  fl_regular = 1 then nr_matriculas end),0) tot_medio,
coalesce (sum(case when cd_etapa = 3 and  cd_ano_serie = 	10	then nr_matriculas end),0) serie_10,
coalesce (sum(case when cd_etapa = 3 and  cd_ano_serie = 	11	then nr_matriculas end),0) serie_11,
coalesce (sum(case when cd_etapa = 3 and  cd_ano_serie = 	12	then nr_matriculas end),0) serie_12,
coalesce (sum(case when cd_etapa = 3 and  cd_ano_serie = 	13	then nr_matriculas end),0) serie_13,
coalesce (sum(case when cd_etapa = 3 and  cd_ano_serie = 	14	then nr_matriculas end),0) serie_14,
coalesce (sum(case when fl_eja = 1 then nr_matriculas end),0) tot_eja,
coalesce (sum(case when cd_etapa = 2 and fl_eja = 1 then nr_matriculas end),0) tot_fund_eja,
coalesce (sum(case when cd_etapa = 2 and cd_etapa_fase = 1 and fl_eja = 3 then nr_matriculas end),0) eja_ai,
coalesce (sum(case when cd_etapa = 2 and cd_etapa_fase = 1 and fl_eja = 4 then nr_matriculas end),0) eja_af,
coalesce (sum(case when cd_etapa = 3 and fl_eja = 1 then nr_matriculas end),0) tot_medio_eja
from mat 
join dw_censo.tb_dm_municipio tdm on co_municipio = id_municipio
where co_municipio in (2300200,2300309,2301109,2302107,2302404,2302602,2302800,2303709,2303808,2304103,2304202,2304400,2305100,2305233,2305506,2306405,2306900,2307007,2307304,2307601,2307650,2307700,2308500,2308708,2310209,2311306,2312403,2312908,2313104,2313302,2313401,2313609,2313757)
and  inicio > '2013-04-17 17:30:00'::timestamp
group by 1,2,3,4,5

-- escolas categorias

select 
2022 nr_ano_sige,
crede.ci_unidade_trabalho cd_crede, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
case when tut.cd_categoria is null then 'Não se aplica'
           when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
	       when  tut.ci_unidade_trabalho = 47258 then 'CREAECE' else upper(tc.nm_categoria) end AS ds_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab in (402,401)
and tmc.ci_municipio_censo in (2300200,2300309,2301109,2302107,2302404,2302602,2302800,2303709,2303808,2304103,2304202,2304400,2305100,2305233,2305506,2306405,2306900,2307007,2307304,2307601,2307650,2307700,2308500,2308708,2310209,2311306,2312403,2312908,2313104,2313302,2313401,2313609,2313757)
AND tlut.fl_sede = TRUE 
and tut.ci_unidade_trabalho in (select distinct t.cd_unidade_trabalho from academico.tb_turma t where t.nr_anoletivo = 2022 and t.cd_prefeitura= 0)
order by 2,4,5,7


