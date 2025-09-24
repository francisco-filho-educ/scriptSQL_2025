with escola_serie as (
SELECT
nu_ano_censo::int,
id_crede_sefor::int,
nm_crede_sefor,
nm_municipio,
id_escola_inep::bigint,
nm_escola,
'ESTADUAL' ds_dependencia,
tes.nm_categoria,
tes.nm_localizacao_zona,
cd_etapa,
ds_etapa,
cd_ano_serie,
case when in_eja = 1 then 'EJA' else ds_ano_serie end ds_ano_serie,
count(1) total,
--count( case when IN_NECESSIDADE_ESPECIAL   = 1 then 1 end) IN_NECESSIDADE_ESPECIAL,
sum( case when IN_CEGUEIRA   = 1 then 1 else 0 end) IN_CEGUEIRA,
sum( case when IN_BAIXA_VISAO   = 1 then 1 else 0 end) IN_BAIXA_VISAO,
sum( case when IN_SURDEZ   = 1 then 1 else 0 end) IN_SURDEZ,
sum( case when IN_DEF_AUDITIVA   = 1 then 1 else 0 end) IN_DEF_AUDITIVA,
sum( case when IN_SURDOCEGUEIRA   = 1 then 1 else 0 end) IN_SURDOCEGUEIRA,
sum( case when IN_DEF_FISICA   = 1 then 1 else 0 end) IN_DEF_FISICA,
sum( case when IN_DEF_INTELECTUAL   = 1 then 1 else 0 end) IN_DEF_INTELECTUAL,
sum( case when IN_DEF_MULTIPLA   = 1 then 1 else 0 end) IN_DEF_MULTIPLA,
sum( case when IN_AUTISMO   = 1 then 1 else 0 end) IN_AUTISMO,
sum( case when IN_SUPERDOTACAO   = 1 then 1 else 0 end) IN_SUPERDOTACAO
--select COUNT(1)
FROM censo_esc_d.tb_matricula mat
join dw_censo.tb_dm_etapa tde on cd_etapa_ensino = tp_etapa_ensino 
join public.tb_escolas_sige_2021_22 tes on tes.id_escola_inep = co_entidade 
where nu_ano_censo  =2021 -- and co_entidade = 23286610
and IN_NECESSIDADE_ESPECIAL = 1
and mat.tp_dependencia = 2
group by 1,2,3,4,5,6,7,8,9,10,11,12,13
) 
, escola_total as (
select 
nu_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
ds_dependencia,
nm_categoria,
nm_localizacao_zona,
999 cd_etapa,
'TOTAL' ds_etapa,
999 cd_ano_serie,
'Total' ds_ano_serie,
sum(total) total,
sum(in_cegueira) in_cegueira,
sum(in_baixa_visao) in_baixa_visao,
sum(in_surdez) in_surdez,
sum(in_def_auditiva) in_def_auditiva,
sum(in_surdocegueira) in_surdocegueira,
sum(in_def_fisica) in_def_fisica,
sum(in_def_intelectual) in_def_intelectual,
sum(in_def_multipla) in_def_multipla,
sum(in_autismo) in_autismo,
sum(in_superdotacao) in_superdotacao
from escola_serie
group by 1,2,3,4,5,6,7,8,9,10,11,12,13
)
,crede_serie as(
select 
nu_ano_censo,
id_crede_sefor,
nm_crede_sefor,
cd_etapa,
ds_etapa,
cd_ano_serie,
ds_ano_serie,
sum(total) total,
sum(in_cegueira) in_cegueira,
sum(in_baixa_visao) in_baixa_visao,
sum(in_surdez) in_surdez,
sum(in_def_auditiva) in_def_auditiva,
sum(in_surdocegueira) in_surdocegueira,
sum(in_def_fisica) in_def_fisica,
sum(in_def_intelectual) in_def_intelectual,
sum(in_def_multipla) in_def_multipla,
sum(in_autismo) in_autismo,
sum(in_superdotacao) in_superdotacao
from escola_serie
group by 1,2,3,4,5,6,7
)-- select * from crede_serie
,crede_total as(
select 
nu_ano_censo,
id_crede_sefor,
nm_crede_sefor,
999 cd_etapa,
'TOTAL' ds_etapa,
999 cd_ano_serie,
'Total' ds_ano_serie,
sum(total) total,
sum(in_cegueira) in_cegueira,
sum(in_baixa_visao) in_baixa_visao,
sum(in_surdez) in_surdez,
sum(in_def_auditiva) in_def_auditiva,
sum(in_surdocegueira) in_surdocegueira,
sum(in_def_fisica) in_def_fisica,
sum(in_def_intelectual) in_def_intelectual,
sum(in_def_multipla) in_def_multipla,
sum(in_autismo) in_autismo,
sum(in_superdotacao) in_superdotacao
from escola_serie
group by 1,2,3,4,5,6,7
)-- select * from crede_total
,relatorio_crede as (
select * from crede_serie
union 
select * from crede_total
order by id_crede_sefor,cd_etapa,cd_ano_serie
) -- select * from relatorio_crede
,relatorio_escola as (
select * from escola_serie
union
select * from escola_total
order by id_crede_sefor,nm_municipio,nm_escola,cd_etapa,cd_ano_serie
) 
select 
row_number() over (ORDER BY nu_ano_censo) as id,
r.*
--from  relatorio_escola r
from  relatorio_crede r




