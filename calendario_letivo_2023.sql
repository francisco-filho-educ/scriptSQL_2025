with anoletivo as (
select 2023 as nr_anoletivo 
)
,periodo_1 as (
select 
nr_anoletivo, 
cd_unidade_trabalho,
dt_inicio dt_inicio_1,
dt_fim dt_fim_1
from academico.tb_periodounidadetrabalho tp 
join anoletivo using(nr_anoletivo)
where cd_periodo = 1
)
,periodo_2 as (
select 
nr_anoletivo, 
cd_unidade_trabalho,
dt_inicio dt_inicio_2,
dt_fim dt_fim_2
from academico.tb_periodounidadetrabalho tp 
join anoletivo using(nr_anoletivo)
where cd_periodo = 2
)
,periodo_3 as (
select 
nr_anoletivo, 
cd_unidade_trabalho,
dt_inicio dt_inicio_3,
dt_fim dt_fim_3
from academico.tb_periodounidadetrabalho tp 
join anoletivo using(nr_anoletivo)
where cd_periodo = 3
)
,periodo_4 as (
select 
nr_anoletivo, 
cd_unidade_trabalho,
dt_inicio dt_inicio_4,
dt_fim dt_fim_4
from academico.tb_periodounidadetrabalho tp 
join anoletivo using(nr_anoletivo)
where cd_periodo = 4
)
,periodos as(
select 
cd_unidade_trabalho,
to_char(dt_inicio_1, 'DD/MM/YYYY') dt_inicio_1,
to_char(dt_fim_1, 'DD/MM/YYYY') dt_fim_1,
to_char(dt_inicio_2, 'DD/MM/YYYY') dt_inicio_2,
to_char(dt_fim_2, 'DD/MM/YYYY') dt_fim_2,
to_char(dt_inicio_3, 'DD/MM/YYYY') dt_inicio_3,
to_char(dt_fim_3, 'DD/MM/YYYY') dt_fim_3,
to_char(dt_inicio_4, 'DD/MM/YYYY') dt_inicio_4,
to_char(dt_fim_4, 'DD/MM/YYYY') dt_fim_4
from periodo_1 
inner join periodo_2 using(cd_unidade_trabalho,nr_anoletivo)
inner join periodo_3 using(cd_unidade_trabalho,nr_anoletivo)
inner join periodo_4 using(cd_unidade_trabalho,nr_anoletivo)
)
SELECT 
2022 nr_ano_sige,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
case when tut.cd_categoria is null then 'Não se aplica'
           when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
	       when  tut.ci_unidade_trabalho = 47258 then 'CREAECE' else upper(tc.nm_categoria) end AS ds_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
p.*
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
left join periodos p on p.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 


