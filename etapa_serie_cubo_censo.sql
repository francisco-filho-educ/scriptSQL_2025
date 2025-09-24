with relatorio as (
select
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
ds_dependencia,
id_escola_inep,
nm_escola,
ds_localizacao,
coalesce (sum(nr_matriculas),0) mat_total_geral,
coalesce (sum(case when cd_etapa = 1 then nr_matriculas end),0) mat_tot_inf,
coalesce (sum(case when cd_etapa = 1 and cd_etapa_fase = 1 then nr_matriculas end),0) mat_creche,
coalesce (sum(case when cd_etapa = 1 and cd_etapa_fase = 2 then nr_matriculas end),0) mat_pre,
coalesce (sum(case when cd_etapa = 2 and cd_classe = 1 and fl_regular = 1 then nr_matriculas end),0) mat_tot_fund,
coalesce (sum(case when cd_etapa = 2 and cd_classe = 1 and cd_etapa_fase = 3 then nr_matriculas end),0) mat_fund_ai,
coalesce (sum(case when cd_etapa = 2 and cd_classe = 1 and cd_etapa_fase = 4 then nr_matriculas end),0) fund_af,
coalesce (sum(case when cd_etapa = 2 and cd_classe = 1 and cd_ano_serie = 1 then nr_matriculas end),0) fund_1s,
coalesce (sum(case when cd_etapa = 2 and cd_classe = 1 and cd_ano_serie = 2 then nr_matriculas end),0) fund_2s,
coalesce (sum(case when cd_etapa = 2 and cd_classe = 1 and cd_ano_serie = 3 then nr_matriculas end),0) fund_3s,
coalesce (sum(case when cd_etapa = 2 and cd_classe = 1 and cd_ano_serie = 4 then nr_matriculas end),0) fund_4s,
coalesce (sum(case when cd_etapa = 2 and cd_classe = 1 and cd_ano_serie = 5 then nr_matriculas end),0) fund_5s,
coalesce (sum(case when cd_etapa = 2 and cd_classe = 1 and cd_ano_serie = 6 then nr_matriculas end),0) fund_6s,
coalesce (sum(case when cd_etapa = 2 and cd_classe = 1 and cd_ano_serie = 7 then nr_matriculas end),0) fund_7s,
coalesce (sum(case when cd_etapa = 2 and cd_classe = 1 and cd_ano_serie = 8 then nr_matriculas end),0) fund_8s,
coalesce (sum(case when cd_etapa = 2 and cd_classe = 1 and cd_ano_serie = 9 then nr_matriculas end),0) fund_9s,
coalesce (sum(case when cd_etapa = 3 and cd_classe = 1 and fl_regular = 1 then nr_matriculas end),0) mat_tot_medio,
coalesce (sum(case when cd_etapa = 3 and cd_classe = 1 and cd_ano_serie = 10 then nr_matriculas end),0) med_10s,
coalesce (sum(case when cd_etapa = 3 and cd_classe = 1 and cd_ano_serie = 11 then nr_matriculas end),0) med_11s,
coalesce (sum(case when cd_etapa = 3 and cd_classe = 1 and cd_ano_serie = 12 then nr_matriculas end),0) med_12s,
coalesce (sum(case when fl_eja = 1 then nr_matriculas end),0) eja_total,
coalesce (sum(case when fl_eja = 1 and cd_etapa = 2 then nr_matriculas end),0) eja_fund,
coalesce (sum(case when fl_eja = 1 and cd_etapa = 3 then nr_matriculas end),0) eja_fund
from dw_censo.tb_cubo_matricula tcm 
where nr_ano_censo between 2012 and 2022
and fl_indigena = 1 
and cd_etapa in (1,2,3,4)
group by 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
ds_dependencia,
id_escola_inep,
nm_escola,
ds_localizacao
)
select 
*
from relatorio