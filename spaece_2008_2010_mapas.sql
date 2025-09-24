-- 5 ano matemática
with spaece as (
select 
2010  ds_edicao,
upper(dc_rede) ds_rede,
cd_rede::int cd_rede,
cd_municipio::numeric id_municipio,
'Matemática' ds_disciplina,
2 cd_disciplina,
cd_etapa::int cd_ano_serie,
dc_etapa ds_ano_serie,
avg(replace(vl_prf_aln_10,',','.' )::numeric) vl_proficiencia
select dc_rede 
from spaece.tb_spaece_2010_mt_em_ef tslee 
where 
cd_etapa::int = 5 
--and cd_municipio::int =2312502
and fl_avaliado::int = 1
group by 1,2,3,4,5,6,7,8
union 
select 
2009  ds_edicao,
upper(dc_rede) ds_rede,
cd_rede::int cd_rede,
cd_municipio::numeric id_municipio,
'Matemática' ds_disciplina,
2 cd_disciplina,
cd_etapa::int cd_ano_serie,
'5º ANO' ds_ano_serie,
avg(replace(mtt.vl_prf_aln_09,',','.' )::numeric) vl_proficiencia
from spaece.tb_spaece_2009_mt_ef_em mtt
where 
cd_etapa::int = 5
--and cd_municipio::int =2312502
and fl_avaliado::int = 1
group by 1,2,3,4,5,6,7,8
union 
select 
2008  ds_edicao,
upper(dc_rede) ds_rede,
cd_rede cd_rede,
cd_municipio::numeric id_municipio,
'Matemática' ds_disciplina,
2 cd_disciplina,
cd_etapa cd_ano_serie,
'5º ANO' ds_ano_serie,
avg(mt.vl_prf_aln_08) vl_proficiencia
from spaece.tb_spaece_2008_5_ano_ef_mt mt
where 
cd_etapa::int = 5 --and cd_rede::int = 2
--and cd_municipio::int =2312502
and fl_avaliado::int = 1
group by 1,2,3,4,5,6,7,8
)
select 
s.*,
CASE
WHEN vl_proficiencia::numeric <= 150 THEN 'Muito Crítico'
WHEN vl_proficiencia::numeric > 150 AND vl_proficiencia::numeric <= 200 THEN 'Crítico'
WHEN vl_proficiencia::numeric > 200 AND vl_proficiencia::numeric <= 250 THEN 'Intermediário'
WHEN vl_proficiencia::numeric > 250 THEN 'Adequado'
END ds_padrao
from spaece s
-- 
--
-- 5 ano Língua Portuguesa
with spaece as (
select 
2010  ds_edicao,
upper(dc_rede) ds_rede,
cd_rede::int cd_rede,
cd_municipio::numeric id_municipio,
'Língua Portuguesa' ds_disciplina,
1 cd_disciplina,
cd_etapa::int cd_ano_serie,
dc_etapa ds_ano_serie,
avg(replace(vl_prf_aln_10,',','.' )::numeric) vl_proficiencia
from spaece.tb_spaece_2010_lp_em_ef tslee 
where 
cd_etapa::int = 5 and cd_rede::int = 2
--and cd_municipio::int =2312502
and fl_avaliado::int = 1
group by 1,2,3,4,5,6,7,8
union 
select 
2009  ds_edicao,
upper(dc_rede) ds_rede,
cd_rede::int cd_rede,
cd_municipio::numeric id_municipio,
'Língua Portuguesa' ds_disciplina,
1 cd_disciplina,
cd_etapa::int cd_ano_serie,
'5º ANO' ds_ano_serie,
avg(replace(mtt.vl_prf_aln_09,',','.' )::numeric) vl_proficiencia
from spaece.tb_spaece_2009_lp_ef_em mtt
where 
cd_etapa::int = 5
--and cd_municipio::int =2312502
and fl_avaliado::int = 1
group by 1,2,3,4,5,6,7,8
union 
select 
2008  ds_edicao,
upper(dc_rede) ds_rede,
cd_rede cd_rede,
cd_municipio::numeric id_municipio,
'Língua Portuguesa' ds_disciplina,
1 cd_disciplina,
cd_etapa cd_ano_serie,
'5º ANO' ds_ano_serie,
avg(mt.vl_prf_aln_08) vl_proficiencia
from spaece.tb_spaece_2008_5_ano_ef_lp mt
where 
cd_etapa::int = 5 and cd_rede::int = 2
--and cd_municipio::int =2312502
and fl_avaliado::int = 1
group by 1,2,3,4,5,6,7,8
)
select 
s.*,
CASE
WHEN vl_proficiencia::numeric <= 150 THEN 'Muito Crítico'
WHEN vl_proficiencia::numeric > 150 AND vl_proficiencia::numeric <= 200 THEN 'Crítico'
WHEN vl_proficiencia::numeric > 200 AND vl_proficiencia::numeric <= 250 THEN 'Intermediário'
WHEN vl_proficiencia::numeric > 250 THEN 'Adequado'
END ds_padrao
from spaece s



select 
count(distinct cd_municipio)
from spaece.tb_spaece_2008_5_ano_ef_mt mt
where 
cd_etapa::int = 5 --and cd_rede::int = 2
--and cd_municipio::int =2312502
and fl_avaliado::int = 1


select 
count(distinct cd_municipio)
from spaece.tb_spaece_2008_5_ano_ef_lp mt
where 
cd_etapa::int = 5 --and cd_rede::int = 2
--and cd_municipio::int =2312502
and fl_avaliado::int = 1