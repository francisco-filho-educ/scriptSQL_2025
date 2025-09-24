with evento  as (
select  
tut.ci_unidade_trabalho,
tt.ds_tpcalendarioevento,
upper(tc.ds_calendarioletivo) ds_calendarioletivo 
FROM academico.tb_calendarioletivo tc
JOIN academico.tb_modalidade tm on tc.cd_modalidade = tm.ci_modalidade
JOIN rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tc.cd_unidade_trabalho
JOIN rede_fisica.tb_dependencia_administrativa tda ON tda.ci_dependencia_administrativa = tut.cd_dependencia_administrativa 
JOIN rede_fisica.tb_tipo_unid_trab ttut ON ttut.ci_tipo_unid_trab = tut.cd_tipo_unid_trab
JOIN util.tb_usuario tu on tu.ci_usuario = tc.cd_usuario
JOIN academico.tb_tpcalendarioevento tt on tc.cd_tpeventocalendario = tt.ci_tpcalendarioevento 
WHERE dt_calendarioletivo = '2024-03-18'
AND nr_anoletivo = 2024
and (tt.ds_tpcalendarioevento ilike 'Greve' or tt.ds_tpcalendarioevento ilike 'Recesso Escolar')
group by 1,2,3
)
SELECT 
2024 nr_anoletivo,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(nm_municipio) AS nm_municipio,
tut.nr_codigo_unid_trab,
tut.nm_unidade_trabalho,
nm_categoria,
string_agg(ds_tpcalendarioevento,', ') ds_tipo_evento,
string_agg(ds_calendarioletivo,', ') ds_descricao
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
inner join public.tb_dm_macroregioes tdm on tdm.id_municipio = tlf.cd_municipio_censo
join evento ev on ev.ci_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_tipo_unid_trab in (402,401)
and tut.cd_situacao_funcionamento = 1
AND tlut.fl_sede = true
group by 1,2,3,4,5,6,7
order by 2,4,5,8

/* CALENDARIO E FERIAS
with anoletivo as (
select 2024 as nr_anoletivo 
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
,periodo_5 as (
select 
nr_anoletivo, 
cd_unidade_trabalho,
dt_inicio dt_inicio_5,
dt_fim dt_fim_5
from academico.tb_periodounidadetrabalho tp 
join anoletivo using(nr_anoletivo)
where cd_periodo = 5
)
,periodos as(
select 
p.nr_anoletivo,
cd_unidade_trabalho,
to_char(dt_inicio_1, 'DD/MM/YYYY') dt_inicio_ano_letivo,
to_char(dt_fim_2, 'DD/MM/YYYY') dt_fim_1_sem, 
to_char(
        dt_fim_2 + INTERVAL '1 day', 
        'DD/MM/YYYY'
    ) AS  dt_inicio_ferias,
to_char(dt_inicio_3 - INTERVAL '1 day', 'DD/MM/YYYY') dt_final_ferias,
to_char(dt_inicio_3 , 'DD/MM/YYYY') dt_inicio_2_bim,
to_char(dt_fim_4, 'DD/MM/YYYY') dt_final_ano_letivo,
to_char(dt_inicio_5, 'DD/MM/YYYY') dt_inicio_recup,
to_char(dt_fim_5, 'DD/MM/YYYY') dt_fim_recup
from periodo_1 p
inner join periodo_2 using(cd_unidade_trabalho,nr_anoletivo)
inner join periodo_3 using(cd_unidade_trabalho,nr_anoletivo)
inner join periodo_4 using(cd_unidade_trabalho,nr_anoletivo)
inner join periodo_5 using(cd_unidade_trabalho,nr_anoletivo)
)
SELECT 
nr_anoletivo,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
case when tut.cd_categoria is null then 'Não se aplica'
           when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
	       when  tut.ci_unidade_trabalho = 47258 then 'CREAECE' else upper(tc.nm_categoria) end AS ds_categoria,
--tut.ci_unidade_trabalho id_escola_sige,
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
and tmc.ci_municipio_censo = 2304400

*/