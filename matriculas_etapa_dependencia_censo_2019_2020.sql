with mat as (
select *
from censo_esc_ce.tb_matricula_2020 tm
union 
select *
from censo_esc_ce.tb_matricula_2019 tm
)
select
tp_dependencia,
'CE' uf,
0 co_municipio,
'CEARÁ' nm_municipio,
case when tp_dependencia  = 1 then 'Federal'
     when tp_dependencia  = 2 then 'Estadual'
     when tp_dependencia  = 3 then 'Municipal'
     when tp_dependencia  = 4 then 'Privada' end ds_dependencia,
--total
sum(case when nu_ano_censo  = 2019 then 1 else 0 end) total_2019,
sum(case when nu_ano_censo  = 2020 then 1 else 0 end) total_2020,
--nr_regular_tot
sum(case when nu_ano_censo  = 2019 and in_regular = 1 then 1 else 0 end) nr_regular_tot_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  then 1 else 0 end) nr_regular_tot_2020,
--nr_inf
sum(case when nu_ano_censo  = 2019 and cd_etapa = 1 then 1 else 0 end) total_infantil_2019,
sum(case when nu_ano_censo  = 2020 and cd_etapa = 1  then 1 else 0 end) total_intantil_2020,
--nr_inf_pre
sum(case when nu_ano_censo  = 2019 and cd_etapa_fase = 1 then 1 else 0 end) creche_2019,
sum(case when nu_ano_censo  = 2020 and cd_etapa_fase = 1  then 1 else 0 end) creche_2020,
--nr_inf_creche
sum(case when nu_ano_censo  = 2019 and cd_etapa_fase = 2 then 1 else 0 end) pre_2019,
sum(case when nu_ano_censo  = 2020 and cd_etapa_fase = 2  then 1 else 0 end) pre_2020,
--nr_fund_tot
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 2 then 1 else 0 end) fund_tot_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 2 then 1 else 0 end) fund_tot_2020,
--nr_fund_ai
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 2 and cd_etapa_fase = 3 then 1 else 0 end) fund_ai_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 2 and cd_etapa_fase = 3 then 1 else 0 end) fund_ai_2020,
--nr_fund_af
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 2 and cd_etapa_fase = 4 then 1 else 0 end) fund_af_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 2 and cd_etapa_fase = 4 then 1 else 0 end) fund_af_2020,
--nr_medio
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 3 then 1 else 0 end) medio_tot_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 3 then 1 else 0 end) medio_tot_2020,
--nr_medio_n_prof
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 3 and tp_etapa_ensino not in (30,31,32,33,34,39,40) then 1 else 0 end) medio_n_prof_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 3 and tp_etapa_ensino not in (30,31,32,33,34,39,40)  then 1 else 0 end) medio_n_prof_2020,
--nr_medio_prof_int
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 3 and tp_etapa_ensino in (30,31,32,33,34,39,40) then 1 else 0 end) medio_prof_int_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 3 and tp_etapa_ensino in (30,31,32,33,34,39,40) then 1 else 0 end) medio_prof_int_2020,
--nr_medio_normal
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 3 and tp_etapa_ensino in (30,31,32,33,34,39,40) then 1 else 0 end) medio_prof_int_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 3 and tp_etapa_ensino in (30,31,32,33,34,39,40) then 1 else 0 end) medio_prof_int_2020,
--nr_incluidos
sum(case when nu_ano_censo  = 2019 and tp_etapa_ensino  is not null and  in_necessidade_especial = 1 and in_especial_exclusiva <> 1 then 1 else 0 end) incluidos_2019,
sum(case when nu_ano_censo  = 2019 and tp_etapa_ensino  is not null and  in_necessidade_especial = 1 and in_especial_exclusiva <> 1 then 1 else 0 end) incluidos_2020,
--nr_turmas_especiais
sum(case when nu_ano_censo  = 2019 and tp_etapa_ensino  is not null and  in_necessidade_especial = 1 and in_especial_exclusiva = 1 then 1 else 0 end) turmas_especiais_2019,
sum(case when nu_ano_censo  = 2019 and tp_etapa_ensino  is not null and  in_necessidade_especial = 1 and in_especial_exclusiva = 1 then 1 else 0 end) turmas_especiais_2020,
--nr_total_eja
sum(case when nu_ano_censo  = 2019 and in_eja = 1 then 1 else 0 end) total_eja_2019,
sum(case when nu_ano_censo  = 2020 and in_eja = 1 then 1 else 0 end) total_eja_2020,
--nr_funda_eja
sum(case when nu_ano_censo  = 2019 and in_eja = 1 and cd_etapa = 2 then 1 else 0 end) fund_eja_2019,
sum(case when nu_ano_censo  = 2020 and in_eja = 1 and cd_etapa = 2 then 1 else 0 end) fund_eja_2020,
--nr_medio_eja
sum(case when nu_ano_censo  = 2019 and in_eja = 1 and cd_etapa = 3 then 1 else 0 end) medio_eja_2019,
sum(case when nu_ano_censo  = 2020 and in_eja = 1 and cd_etapa = 3 then 1 else 0 end) medio_eja_2020,
--nr_tec_total
sum(case when nu_ano_censo  = 2019 and cd_etapa = 4 then 1 else 0 end) tec_total_2019,
sum(case when nu_ano_censo  = 2020 and cd_etapa = 4 then 1 else 0 end) tec_total_2020,
--nr_tec_conc_subse
sum(case when nu_ano_censo  = 2019 and tp_etapa_ensino  in (39,40) then 1 else 0 end) tec_conc_subse_2019,
sum(case when nu_ano_censo  = 2020 and tp_etapa_ensino  in (39,40) then 1 else 0 end) tec_conc_subse_2020,
--nr_fic
sum(case when nu_ano_censo  = 2019 and tp_etapa_ensino in (68,73,74) then 1 else 0 end) tec_fic_2019,
sum(case when nu_ano_censo  = 2020 and tp_etapa_ensino in (68,73,74) then 1 else 0 end) tec_fic_2020
from dw_censo.tb_dm_municipio
left join mat on id_municipio = co_municipio 
left join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino =  tp_etapa_ensino 
where cd_etapa in (1,2,3,4)
group by 1,2,3,4,5
union 
select
99 tp_dependencia,
'CE' uf,
0 co_municipio,
'CEARÁ' nm_municipio,
'TOTAL' ds_dependencia,
--total
sum(case when nu_ano_censo  = 2019 then 1 else 0 end) total_2019,
sum(case when nu_ano_censo  = 2020 then 1 else 0 end) total_2020,
--nr_regular_tot
sum(case when nu_ano_censo  = 2019 and in_regular = 1 then 1 else 0 end) nr_regular_tot_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  then 1 else 0 end) nr_regular_tot_2020,
--nr_inf
sum(case when nu_ano_censo  = 2019 and cd_etapa = 1 then 1 else 0 end) total_infantil_2019,
sum(case when nu_ano_censo  = 2020 and cd_etapa = 1  then 1 else 0 end) total_intantil_2020,
--nr_inf_pre
sum(case when nu_ano_censo  = 2019 and cd_etapa_fase = 1 then 1 else 0 end) creche_2019,
sum(case when nu_ano_censo  = 2020 and cd_etapa_fase = 1  then 1 else 0 end) creche_2020,
--nr_inf_creche
sum(case when nu_ano_censo  = 2019 and cd_etapa_fase = 2 then 1 else 0 end) pre_2019,
sum(case when nu_ano_censo  = 2020 and cd_etapa_fase = 2  then 1 else 0 end) pre_2020,
--nr_fund_tot
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 2 then 1 else 0 end) fund_tot_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 2 then 1 else 0 end) fund_tot_2020,
--nr_fund_ai
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 2 and cd_etapa_fase = 3 then 1 else 0 end) fund_ai_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 2 and cd_etapa_fase = 3 then 1 else 0 end) fund_ai_2020,
--nr_fund_af
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 2 and cd_etapa_fase = 4 then 1 else 0 end) fund_af_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 2 and cd_etapa_fase = 4 then 1 else 0 end) fund_af_2020,
--nr_medio
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 3 then 1 else 0 end) medio_tot_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 3 then 1 else 0 end) medio_tot_2020,
--nr_medio_n_prof
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 3 and tp_etapa_ensino not in (30,31,32,33,34,39,40) then 1 else 0 end) medio_n_prof_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 3 and tp_etapa_ensino not in (30,31,32,33,34,39,40)  then 1 else 0 end) medio_n_prof_2020,
--nr_medio_prof_int
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 3 and tp_etapa_ensino in (30,31,32,33,34,39,40) then 1 else 0 end) medio_prof_int_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 3 and tp_etapa_ensino in (30,31,32,33,34,39,40) then 1 else 0 end) medio_prof_int_2020,
--nr_medio_normal
sum(case when nu_ano_censo  = 2019 and in_regular = 1  and cd_etapa = 3 and tp_etapa_ensino in (30,31,32,33,34,39,40) then 1 else 0 end) medio_prof_int_2019,
sum(case when nu_ano_censo  = 2020 and in_regular = 1  and cd_etapa = 3 and tp_etapa_ensino in (30,31,32,33,34,39,40) then 1 else 0 end) medio_prof_int_2020,
--nr_incluidos
sum(case when nu_ano_censo  = 2019 and tp_etapa_ensino  is not null and  in_necessidade_especial = 1 and in_especial_exclusiva <> 1 then 1 else 0 end) incluidos_2019,
sum(case when nu_ano_censo  = 2019 and tp_etapa_ensino  is not null and  in_necessidade_especial = 1 and in_especial_exclusiva <> 1 then 1 else 0 end) incluidos_2020,
--nr_turmas_especiais
sum(case when nu_ano_censo  = 2019 and tp_etapa_ensino  is not null and  in_necessidade_especial = 1 and in_especial_exclusiva = 1 then 1 else 0 end) turmas_especiais_2019,
sum(case when nu_ano_censo  = 2019 and tp_etapa_ensino  is not null and  in_necessidade_especial = 1 and in_especial_exclusiva = 1 then 1 else 0 end) turmas_especiais_2020,
--nr_total_eja
sum(case when nu_ano_censo  = 2019 and in_eja = 1 then 1 else 0 end) total_eja_2019,
sum(case when nu_ano_censo  = 2020 and in_eja = 1 then 1 else 0 end) total_eja_2020,
--nr_funda_eja
sum(case when nu_ano_censo  = 2019 and in_eja = 1 and cd_etapa = 2 then 1 else 0 end) fund_eja_2019,
sum(case when nu_ano_censo  = 2020 and in_eja = 1 and cd_etapa = 2 then 1 else 0 end) fund_eja_2020,
--nr_medio_eja
sum(case when nu_ano_censo  = 2019 and in_eja = 1 and cd_etapa = 3 then 1 else 0 end) medio_eja_2019,
sum(case when nu_ano_censo  = 2020 and in_eja = 1 and cd_etapa = 3 then 1 else 0 end) medio_eja_2020,
--nr_tec_total
sum(case when nu_ano_censo  = 2019 and cd_etapa = 4 then 1 else 0 end) tec_total_2019,
sum(case when nu_ano_censo  = 2020 and cd_etapa = 4 then 1 else 0 end) tec_total_2020,
--nr_tec_conc_subse
sum(case when nu_ano_censo  = 2019 and tp_etapa_ensino  in (39,40) then 1 else 0 end) tec_conc_subse_2019,
sum(case when nu_ano_censo  = 2020 and tp_etapa_ensino  in (39,40) then 1 else 0 end) tec_conc_subse_2020,
--nr_fic
sum(case when nu_ano_censo  = 2019 and tp_etapa_ensino in (68,73,74) then 1 else 0 end) tec_fic_2019,
sum(case when nu_ano_censo  = 2020 and tp_etapa_ensino in (68,73,74) then 1 else 0 end) tec_fic_2020
from dw_censo.tb_dm_municipio
left join mat on id_municipio = co_municipio 
left join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino =  tp_etapa_ensino 
where cd_etapa in (1,2,3,4)
group by 1,2,3,4,5
order by 4,1
