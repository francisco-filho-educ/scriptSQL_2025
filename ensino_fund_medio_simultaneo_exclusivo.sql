with fund as (
select 
nr_anoletivo,
cd_unidade_trabalho,
cd_etapa
from academico.tb_turma tt 
join academico.tb_etapa et on ci_etapa = tt.cd_etapa
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
where tt.nr_anoletivo = 2022
and cd_prefeitura = 0
and cd_nivel = 26
and tt.fl_tipo_seriacao =  'RG'
and tut.cd_dependencia_administrativa = 2
--and cd_etapa in (126,127,128,129) -- SOMENTE ANOS FINAIS
group by 1,2,3
)
, medio as (
select 
nr_anoletivo,
cd_unidade_trabalho
from academico.tb_turma tt 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
where tt.nr_anoletivo = 2022
and cd_prefeitura = 0
and cd_nivel = 27
and tt.fl_tipo_seriacao =  'RG'
and tut.cd_dependencia_administrativa = 2
group by 1,2
), exclusivo_fund as (
select
nr_anoletivo, cd_unidade_trabalho, 1 fl_fund_exc
from fund f
where not exists (select 1 from medio m where m.cd_unidade_trabalho = f.cd_unidade_trabalho)
group by 1,2
),exc_medio as(
select 
nr_anoletivo, cd_unidade_trabalho , 1 fl_medio_exc
from medio f
where not exists (select 1 from fund m where m.cd_unidade_trabalho = f.cd_unidade_trabalho)
group by 1,2
), fund_e_medio as (
select
nr_anoletivo, cd_unidade_trabalho
from fund 
union 
select
nr_anoletivo, cd_unidade_trabalho
from medio 
), fund_medio_o as(
select 
nr_anoletivo, cd_unidade_trabalho, 1 FL_FUND_MEDIO
from fund_e_medio f
where 1=1 
--and exists (select 1 from medio m where m.cd_unidade_trabalho = f.cd_unidade_trabalho)
and not exists (select 1 from exclusivo_fund m where m.cd_unidade_trabalho = f.cd_unidade_trabalho)
and not exists (select 1 from exc_medio m where m.cd_unidade_trabalho = f.cd_unidade_trabalho)
group by 1,2
), fund_AI as(
select 
nr_anoletivo, cd_unidade_trabalho
from fund f
where 1=1 
and  exists (select 1 from exclusivo_fund m where m.cd_unidade_trabalho = f.cd_unidade_trabalho)
and not exists (select 1 from exc_medio m where m.cd_unidade_trabalho = f.cd_unidade_trabalho)
and cd_etapa in (126,127,128,129)
group by 1,2
),
mun_mf as (
SELECT -- lista as escolas ensino medio puro
tmc.ci_municipio_censo,
count(distinct m.cd_unidade_trabalho) nr_mf
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
inner join fund_medio_o m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho -- FUNDAMENTAL E MEDIO SIMULTANEO
--left join exclusivo_fund  m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho -- FUNDAMENTAL EXCLUSIVO
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
and tut.cd_categoria <> 6
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
group by 1
), anos_finais as (
SELECT -- lista as escolas ensino medio puro
tmc.ci_municipio_censo,
count(distinct m.cd_unidade_trabalho) nr_ai
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
--inner join fund_medio_o m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho -- FUNDAMENTAL E MEDIO SIMULTANEO
left join fund_AI  m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho -- FUNDAMENTAL EXCLUSIVO
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
and tut.cd_categoria <> 6
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
group by 1
),relatorio as (
SELECT -- lista as escolas ensino medio puro
tmc.ci_municipio_censo,
tmc.nm_municipio,
coalesce(nr_mf,0) nr_medio,
count(distinct m.cd_unidade_trabalho) n_f,
coalesce(nr_ai,0) nr_ai
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
--inner join fund_medio_o m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho -- FUNDAMENTAL E MEDIO SIMULTANEO
left join exclusivo_fund  m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho -- FUNDAMENTAL EXCLUSIVO
left join mun_mf mf on mf.ci_municipio_censo = tmc.ci_municipio_censo
left join anos_finais ai on ai.ci_municipio_censo = tmc.ci_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
and tut.cd_categoria <> 6
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
group by 1,2,3,5
) select  * from relatorio where nr_medio + n_f + nr_ai >0

