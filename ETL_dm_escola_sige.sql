drop table if exists dw_sige.tb_dm_escola;
create table dw_sige.tb_dm_escola  as (
with turma as (
select 
nr_anoletivo,
tt.cd_unidade_trabalho,
1 fl_matricula,
max(case when tt.cd_nivel = 28 then 1 else 0 end) fl_educacao_infantil,
max(case when tt.cd_nivel = 26 then 1 else 0 end) fl_ensino_fundamental,
max(case when tt.cd_nivel = 27 then 1 else 0 end) fl_ensino_medio,
max(case when tt.cd_nivel = 29 then 1 else 0 end) fl_ensino_aee,
max(case when tt.cd_nivel = 33 then 1 else 0 end) fl_ensino_creaece,
max(case when tt.cd_nivel = 32 then 1 else 0 end) fl_ensino_nape,
max(case when tt.cd_nivel = 15 then 1 else 0 end) fl_ensino_prevest
--select cd_nivel,ds_nivel
from academico.tb_turma tt 
inner join academico.tb_nivel on ci_nivel = tt.cd_nivel 
where nr_anoletivo  =2024
and cd_prefeitura = 0
group by 1,2,3 
), 
periodo_1 as (
select 
cd_unidade_trabalho,
tp.dt_inicio::text dt_inicio_periodo_1,
tp.dt_fim::text dt_fim_periodo_1
from academico.tb_periodounidadetrabalho tp 
where exists (select 1 from turma t where t.cd_unidade_trabalho =  tp.cd_unidade_trabalho and tp.nr_anoletivo = t.nr_anoletivo)
and tp.cd_periodo = 1
) --select * from periodo_1 order by 1
,periodo_2 as (
select
cd_unidade_trabalho,
tp.dt_inicio::text dt_inicio_periodo_2,
tp.dt_fim::text dt_fim_periodo_2
from academico.tb_periodounidadetrabalho tp 
where exists (select 1 from turma t where t.cd_unidade_trabalho =  tp.cd_unidade_trabalho and tp.nr_anoletivo = t.nr_anoletivo)
and tp.cd_periodo = 2
),
periodo_3 as (
select 
cd_unidade_trabalho,
tp.dt_inicio::text dt_inicio_periodo_3,
tp.dt_fim::text dt_fim_periodo_3
from academico.tb_periodounidadetrabalho tp 
where exists (select 1 from turma t where t.cd_unidade_trabalho =  tp.cd_unidade_trabalho and tp.nr_anoletivo = t.nr_anoletivo)
and tp.cd_periodo = 3
),
periodo_4 as (
select
cd_unidade_trabalho,
tp.dt_inicio::text dt_inicio_periodo_4,
tp.dt_fim::text dt_fim_periodo_4
from academico.tb_periodounidadetrabalho tp 
where exists (select 1 from turma t where t.cd_unidade_trabalho =  tp.cd_unidade_trabalho and tp.nr_anoletivo = t.nr_anoletivo)
and tp.cd_periodo = 4
) --select * from periodo_4
, periodo_5 as (
select
cd_unidade_trabalho,
tp.dt_inicio::text dt_inicio_recuperacao,
tp.dt_fim::text dt_fim_recuperacao
from academico.tb_periodounidadetrabalho tp 
where exists (select 1 from turma t where t.cd_unidade_trabalho =  tp.cd_unidade_trabalho and tp.nr_anoletivo = t.nr_anoletivo)
and tp.cd_periodo = 5
) --select * from periodo_5
select 
nr_anoletivo,
tut.cd_unidade_trabalho_pai id_crede_sefor,
crede.nm_sigla  nm_crede_sefor,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep,
tut.nm_unidade_trabalho nm_escola,
case when tut.cd_tipo_unid_trab = 402 then 402 else tut.cd_categoria end cd_categoria,
upper(case when tut.cd_tipo_unid_trab = 402 then 'CCI' else tc.nm_categoria end) ds_categoria,
tmc.ci_municipio_censo id_municipio,
upper(tmc.nm_municipio) nm_municipio,
tlf.cd_localizacao_zona cd_localizacao,
case when tlf.cd_localizacao_zona = 1 then 'URBANA' else 'RURAL' end ds_localizacao,
case when tlf.nr_latitude > 0 then tlf.nr_latitude * -1 else tlf.nr_latitude end nr_latitude,
case when tlf.nr_longitude > 0 then tlf.nr_longitude * -1 else tlf.nr_longitude end nr_longitude,
upper(tlf.nm_logradouro) nm_logradouro,
tlf.ds_numero,
upper(nm_bairro) nm_bairro,
lower(tut.ds_email_corporativo) ds_email_corporativo,
lower(tut.ds_email_alternativo) ds_email_alternativo,
tut.ds_telefone1 ds_telefone_1,
tut.ds_telefone2 ds_telefone_2,
tut.dt_inicio_atividades::text ,
tut.dt_fim_atividades::text,
coalesce(fl_matricula,0) fl_matricula,
dt_inicio_periodo_1::text,
dt_fim_periodo_1::text,
dt_inicio_periodo_2::text,
dt_fim_periodo_2::text,
dt_inicio_periodo_3::text,
dt_fim_periodo_3::text,
dt_inicio_periodo_4::text,
dt_fim_periodo_4::text,
dt_inicio_recuperacao::text,
dt_fim_recuperacao::text,
 coalesce (fl_educacao_infantil,0) fl_educacao_infantil,
 coalesce (fl_ensino_fundamental,0) fl_ensino_fundamental,
 coalesce (fl_ensino_medio,0) fl_ensino_medio,
 coalesce (fl_ensino_aee,0) fl_ensino_aee,
 coalesce (fl_ensino_creaece,0) fl_ensino_creaece,
 coalesce (fl_ensino_nape,0) fl_ensino_nape,
 coalesce (fl_ensino_prevest,0) fl_ensino_prevest,
tut.cd_situacao_funcionamento cd_funcionamento, 
sf.nm_situacao_funcionamento ds_funcionamento,
CURRENT_DATE::text dt_extracao
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
join rede_fisica.tb_situacao_funcionamento sf on sf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join turma t on t.cd_unidade_trabalho = tut.ci_unidade_trabalho 
left join periodo_1 p1 on p1.cd_unidade_trabalho = tut.ci_unidade_trabalho
left join periodo_2 p2 on p2.cd_unidade_trabalho = tut.ci_unidade_trabalho
left join periodo_3 p3 on p3.cd_unidade_trabalho = tut.ci_unidade_trabalho
left join periodo_4 p4 on p4.cd_unidade_trabalho = tut.ci_unidade_trabalho
left join periodo_5 p5 on p5.cd_unidade_trabalho = tut.ci_unidade_trabalho
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab in (402,401)
AND tlut.fl_sede = TRUE 
order by 3
)