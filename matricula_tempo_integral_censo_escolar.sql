select 
nu_ano_censo,
'aaa' nm_municipio,
tp_dependencia,
case when tp_dependencia = 1 then 'Federal'
     when tp_dependencia = 2 then 'Estadual'
     when tp_dependencia = 3 then 'Municipal'
     when tp_dependencia = 4 then 'Privada' end rede_ensino,
count(distinct tm.co_entidade) nr_escola_total,
count(distinct case when tm.nu_duracao_turma>=420 then co_entidade end ) nr_escola_integral,
count(1) nr_mat_total,
sum(case when tm.nu_duracao_turma>=420 then 1 else 0 end ) total_mat_integral
from censo_esc_ce.tb_matricula_2023 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio 
where 
cd_etapa in (1,2,3,4) --and tm.co_municipio = 2304400 --and nm_municipio = 'Maracanaú'
group by 1,2,3
union 
select 
nu_ano_censo,
'aaa' nm_municipio,
9 tp_dependencia,
'TOTAL' rede_ensino,
count(distinct tm.co_entidade) nr_escola_total,
count(distinct case when tm.nu_duracao_turma>=420 then co_entidade end ) nr_escola_integral,
count(1) nr_mat_total,
sum(case when tm.nu_duracao_turma>=420 then 1 else 0 end ) total_mat_integral
from censo_esc_ce.tb_matricula_2023 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio 
where 
cd_etapa in (1,2,3,4) --and tm.co_municipio = 2304400 --and nm_municipio = 'Maracanaú'
group by 1,2,3
---
union 
select 
nu_ano_censo,
nm_municipio,
tp_dependencia,
case when tp_dependencia = 1 then 'Federal'
     when tp_dependencia = 2 then 'Estadual'
     when tp_dependencia = 3 then 'Municipal'
     when tp_dependencia = 4 then 'Privada' end rede_ensino,
count(distinct tm.co_entidade) nr_escola_total,
count(distinct case when tm.nu_duracao_turma>=420 then co_entidade end ) nr_escola_integral,
count(1) nr_mat_total,
sum(case when tm.nu_duracao_turma>=420 then 1 else 0 end ) total_mat_integral
from censo_esc_ce.tb_matricula_2023 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio 
where 
cd_etapa in (1,2,3,4) --and tm.co_municipio = 2304400 --and nm_municipio = 'Maracanaú'
group by 1,2,3
union 
select 
nu_ano_censo,
nm_municipio,
9 tp_dependencia,
'TOTAL' rede_ensino,
count(distinct tm.co_entidade) nr_escola_total,
count(distinct case when tm.nu_duracao_turma>=420 then co_entidade end ) nr_escola_integral,
count(1) nr_mat_total,
sum(case when tm.nu_duracao_turma>=420 then 1 else 0 end ) total_mat_integral
from censo_esc_ce.tb_matricula_2023 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio 
where 
cd_etapa in (1,2,3,4) --and tm.co_municipio = 2304400 --and nm_municipio = 'Maracanaú'
group by 1,2,3
order by 1,2,3
/*
*ESCOLAS POR ETAPAS
*/
select 
nu_ano_censo,
nm_municipio,
case when tp_dependencia = 1 then 'Federal'
     when tp_dependencia = 2 then 'Estadual'
     when tp_dependencia = 3 then 'Municipal'
     when tp_dependencia = 4 then 'Privada' end rede_ensino,
coalesce (count(distinct case when cd_etapa = 1 then co_entidade  end),0) esc_tot_inf,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 1 then co_entidade  end),0) esc_tot_inf_integ,
coalesce (count(distinct case when cd_etapa = 1 and cd_etapa_fase = 1 then co_entidade  end),0) esc_creche,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 1 and cd_etapa_fase = 1 then co_entidade  end),0) esc_creche_integ,
coalesce (count(distinct case when cd_etapa = 1 and cd_etapa_fase = 2 then co_entidade  end),0) esc_pre,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 1 and cd_etapa_fase = 2 then co_entidade  end),0) esc_pre_integ,
coalesce (count(distinct case when cd_etapa = 2  and in_regular = 1 then co_entidade  end),0) esc_tot_fund,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and in_regular = 1 then co_entidade  end),0) esc_tot_fund_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_etapa_fase = 3 then co_entidade  end),0) esc_fund_ai,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_etapa_fase = 3 then co_entidade  end),0) esc_fund_ai_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_etapa_fase = 4 then co_entidade  end),0) fund_af,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_etapa_fase = 4 then co_entidade  end),0) fund_af_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 1 then co_entidade  end),0) fund_1s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 1 then co_entidade  end),0) fund_1s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 2 then co_entidade  end),0) fund_2s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 2 then co_entidade  end),0) fund_2s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 3 then co_entidade  end),0) fund_3s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 3 then co_entidade  end),0) fund_3s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 4 then co_entidade  end),0) fund_4s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 4 then co_entidade  end),0) fund_4s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 5 then co_entidade  end),0) fund_5s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 5 then co_entidade  end),0) fund_5s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 6 then co_entidade  end),0) fund_6s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 6 then co_entidade  end),0) fund_6s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 7 then co_entidade  end),0) fund_7s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 7 then co_entidade  end),0) fund_7s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 8 then co_entidade  end),0) fund_8s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 8 then co_entidade  end),0) fund_8s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 9 then co_entidade  end),0) fund_9s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 9 then co_entidade  end),0) fund_9s_integ,
coalesce (count(distinct case when cd_etapa = 3  and in_regular = 1 then co_entidade  end),0) esc_tot_medio,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 3  and in_regular = 1 then co_entidade  end),0) esc_tot_medio_integ,
coalesce (count(distinct case when cd_etapa = 3  and cd_ano_serie = 10 then co_entidade  end),0) med_10s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 10 then co_entidade  end),0) med_10s_integ,
coalesce (count(distinct case when cd_etapa = 3  and cd_ano_serie = 11 then co_entidade  end),0) med_11s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 11 then co_entidade  end),0) med_11s_integ,
coalesce (count(distinct case when cd_etapa = 3  and cd_ano_serie = 12 then co_entidade  end),0) med_12s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 12 then co_entidade  end),0) med_12s_integ,
coalesce (count(distinct case when cd_etapa = 3  and cd_ano_serie = 13 then co_entidade  end),0) med_13s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 13 then co_entidade  end),0) med_13s_integ,
coalesce (count(distinct case when cd_etapa = 3  and cd_ano_serie = 14 then co_entidade  end),0) med_14s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 14 then co_entidade  end),0) med_14s_integ,
coalesce (count(distinct case when in_eja = 1 then co_entidade  end),0) eja_total,
coalesce (count(distinct case when nu_duracao_turma >= 420 and in_eja = 1 then co_entidade  end),0) eja_total_integ,
coalesce (count(distinct case when in_eja = 1 and cd_etapa = 2 then co_entidade  end),0) eja_fund,
coalesce (count(distinct case when nu_duracao_turma >= 420 and in_eja = 1 and cd_etapa = 2 then co_entidade  end),0) eja_fund_integ,
coalesce (count(distinct case when in_eja = 1 and cd_etapa = 3 then co_entidade  end),0) eja_medio,
coalesce (count(distinct case when nu_duracao_turma >= 420 and in_eja = 1 and cd_etapa = 3 then co_entidade  end),0) eja_medio_integ
from censo_esc_ce.tb_matricula_2023 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio 
where 
cd_etapa in (1,2,3,4) --and tm.co_municipio = 2304400 --and nm_municipio = 'Maracanaú'
group by 1,2,3
union 
select 
nu_ano_censo,
nm_municipio,
'TOTAL' rede_ensino,
coalesce (count(distinct case when cd_etapa = 1 then co_entidade  end),0) esc_tot_inf,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 1 then co_entidade  end),0) esc_tot_inf_integ,
coalesce (count(distinct case when cd_etapa = 1 and cd_etapa_fase = 1 then co_entidade  end),0) esc_creche,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 1 and cd_etapa_fase = 1 then co_entidade  end),0) esc_creche_integ,
coalesce (count(distinct case when cd_etapa = 1 and cd_etapa_fase = 2 then co_entidade  end),0) esc_pre,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 1 and cd_etapa_fase = 2 then co_entidade  end),0) esc_pre_integ,
coalesce (count(distinct case when cd_etapa = 2  and in_regular = 1 then co_entidade  end),0) esc_tot_fund,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and in_regular = 1 then co_entidade  end),0) esc_tot_fund_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_etapa_fase = 3 then co_entidade  end),0) esc_fund_ai,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_etapa_fase = 3 then co_entidade  end),0) esc_fund_ai_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_etapa_fase = 4 then co_entidade  end),0) fund_af,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_etapa_fase = 4 then co_entidade  end),0) fund_af_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 1 then co_entidade  end),0) fund_1s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 1 then co_entidade  end),0) fund_1s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 2 then co_entidade  end),0) fund_2s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 2 then co_entidade  end),0) fund_2s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 3 then co_entidade  end),0) fund_3s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 3 then co_entidade  end),0) fund_3s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 4 then co_entidade  end),0) fund_4s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 4 then co_entidade  end),0) fund_4s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 5 then co_entidade  end),0) fund_5s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 5 then co_entidade  end),0) fund_5s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 6 then co_entidade  end),0) fund_6s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 6 then co_entidade  end),0) fund_6s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 7 then co_entidade  end),0) fund_7s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 7 then co_entidade  end),0) fund_7s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 8 then co_entidade  end),0) fund_8s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 8 then co_entidade  end),0) fund_8s_integ,
coalesce (count(distinct case when cd_etapa = 2  and cd_ano_serie = 9 then co_entidade  end),0) fund_9s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 9 then co_entidade  end),0) fund_9s_integ,
coalesce (count(distinct case when cd_etapa = 3  and in_regular = 1 then co_entidade  end),0) esc_tot_medio,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 3  and in_regular = 1 then co_entidade  end),0) esc_tot_medio_integ,
coalesce (count(distinct case when cd_etapa = 3  and cd_ano_serie = 10 then co_entidade  end),0) med_10s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 10 then co_entidade  end),0) med_10s_integ,
coalesce (count(distinct case when cd_etapa = 3  and cd_ano_serie = 11 then co_entidade  end),0) med_11s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 11 then co_entidade  end),0) med_11s_integ,
coalesce (count(distinct case when cd_etapa = 3  and cd_ano_serie = 12 then co_entidade  end),0) med_12s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 12 then co_entidade  end),0) med_12s_integ,
coalesce (count(distinct case when cd_etapa = 3  and cd_ano_serie = 13 then co_entidade  end),0) med_13s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 13 then co_entidade  end),0) med_13s_integ,
coalesce (count(distinct case when cd_etapa = 3  and cd_ano_serie = 14 then co_entidade  end),0) med_14s,
coalesce (count(distinct case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 14 then co_entidade  end),0) med_14s_integ,
coalesce (count(distinct case when in_eja = 1 then co_entidade  end),0) eja_total,
coalesce (count(distinct case when nu_duracao_turma >= 420 and in_eja = 1 then co_entidade  end),0) eja_total_integ,
coalesce (count(distinct case when in_eja = 1 and cd_etapa = 2 then co_entidade  end),0) eja_fund,
coalesce (count(distinct case when nu_duracao_turma >= 420 and in_eja = 1 and cd_etapa = 2 then co_entidade  end),0) eja_fund_integ,
coalesce (count(distinct case when in_eja = 1 and cd_etapa = 3 then co_entidade  end),0) eja_medio,
coalesce (count(distinct case when nu_duracao_turma >= 420 and in_eja = 1 and cd_etapa = 3 then co_entidade  end),0) eja_medio_integ
from censo_esc_ce.tb_matricula_2023 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio 
where 
cd_etapa in (1,2,3,4) --and tm.co_municipio = 2304400 --and nm_municipio = 'Maracanaú'
group by 1,2,3
order by 2,3
/*
*MATRICULAS POR ETAPAS
*/


select 
nu_ano_censo,
nm_municipio,
case when tp_dependencia = 1 then 'Federal'
     when tp_dependencia = 2 then 'Estadual'
     when tp_dependencia = 3 then 'Municipal'
     when tp_dependencia = 4 then 'Privada' end rede_ensino,
coalesce (count( case when cd_etapa = 1 then id_matricula  end),0) esc_tot_inf,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 1 then id_matricula  end),0) esc_tot_inf_integ,
coalesce (count( case when cd_etapa = 1 and cd_etapa_fase = 1 then id_matricula  end),0) esc_creche,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 1 and cd_etapa_fase = 1 then id_matricula  end),0) esc_creche_integ,
coalesce (count( case when cd_etapa = 1 and cd_etapa_fase = 2 then id_matricula  end),0) esc_pre,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 1 and cd_etapa_fase = 2 then id_matricula  end),0) esc_pre_integ,
coalesce (count( case when cd_etapa = 2  and in_regular = 1 then id_matricula  end),0) esc_tot_fund,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and in_regular = 1 then id_matricula  end),0) esc_tot_fund_integ,
coalesce (count( case when cd_etapa = 2  and cd_etapa_fase = 3 then id_matricula  end),0) esc_fund_ai,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_etapa_fase = 3 then id_matricula  end),0) esc_fund_ai_integ,
coalesce (count( case when cd_etapa = 2  and cd_etapa_fase = 4 then id_matricula  end),0) fund_af,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_etapa_fase = 4 then id_matricula  end),0) fund_af_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 1 then id_matricula  end),0) fund_1s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 1 then id_matricula  end),0) fund_1s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 2 then id_matricula  end),0) fund_2s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 2 then id_matricula  end),0) fund_2s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 3 then id_matricula  end),0) fund_3s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 3 then id_matricula  end),0) fund_3s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 4 then id_matricula  end),0) fund_4s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 4 then id_matricula  end),0) fund_4s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 5 then id_matricula  end),0) fund_5s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 5 then id_matricula  end),0) fund_5s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 6 then id_matricula  end),0) fund_6s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 6 then id_matricula  end),0) fund_6s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 7 then id_matricula  end),0) fund_7s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 7 then id_matricula  end),0) fund_7s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 8 then id_matricula  end),0) fund_8s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 8 then id_matricula  end),0) fund_8s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 9 then id_matricula  end),0) fund_9s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 9 then id_matricula  end),0) fund_9s_integ,
coalesce (count( case when cd_etapa = 3  and in_regular = 1 then id_matricula  end),0) esc_tot_medio,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 3  and in_regular = 1 then id_matricula  end),0) esc_tot_medio_integ,
coalesce (count( case when cd_etapa = 3  and cd_ano_serie = 10 then id_matricula  end),0) med_10s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 10 then id_matricula  end),0) med_10s_integ,
coalesce (count( case when cd_etapa = 3  and cd_ano_serie = 11 then id_matricula  end),0) med_11s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 11 then id_matricula  end),0) med_11s_integ,
coalesce (count( case when cd_etapa = 3  and cd_ano_serie = 12 then id_matricula  end),0) med_12s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 12 then id_matricula  end),0) med_12s_integ,
coalesce (count( case when cd_etapa = 3  and cd_ano_serie = 13 then id_matricula  end),0) med_13s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 13 then id_matricula  end),0) med_13s_integ,
coalesce (count( case when cd_etapa = 3  and cd_ano_serie = 14 then id_matricula  end),0) med_14s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 14 then id_matricula  end),0) med_14s_integ,
coalesce (count( case when in_eja = 1 then id_matricula  end),0) eja_total,
coalesce (count( case when nu_duracao_turma >= 420 and in_eja = 1 then id_matricula  end),0) eja_total_integ,
coalesce (count( case when in_eja = 1 and cd_etapa = 2 then id_matricula  end),0) eja_fund,
coalesce (count( case when nu_duracao_turma >= 420 and in_eja = 1 and cd_etapa = 2 then id_matricula  end),0) eja_fund_integ,
coalesce (count( case when in_eja = 1 and cd_etapa = 3 then id_matricula  end),0) eja_medio,
coalesce (count( case when nu_duracao_turma >= 420 and in_eja = 1 and cd_etapa = 3 then id_matricula  end),0) eja_medio_integ
from censo_esc_ce.tb_matricula_2023 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio 
where 
cd_etapa in (1,2,3,4) --and tm.co_municipio = 2304400 --and nm_municipio = 'Maracanaú'
group by 1,2,3
union 
select 
nu_ano_censo,
nm_municipio,
'TOTAL' rede_ensino,
coalesce (count( case when cd_etapa = 1 then id_matricula  end),0) esc_tot_inf,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 1 then id_matricula  end),0) esc_tot_inf_integ,
coalesce (count( case when cd_etapa = 1 and cd_etapa_fase = 1 then id_matricula  end),0) esc_creche,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 1 and cd_etapa_fase = 1 then id_matricula  end),0) esc_creche_integ,
coalesce (count( case when cd_etapa = 1 and cd_etapa_fase = 2 then id_matricula  end),0) esc_pre,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 1 and cd_etapa_fase = 2 then id_matricula  end),0) esc_pre_integ,
coalesce (count( case when cd_etapa = 2  and in_regular = 1 then id_matricula  end),0) esc_tot_fund,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and in_regular = 1 then id_matricula  end),0) esc_tot_fund_integ,
coalesce (count( case when cd_etapa = 2  and cd_etapa_fase = 3 then id_matricula  end),0) esc_fund_ai,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_etapa_fase = 3 then id_matricula  end),0) esc_fund_ai_integ,
coalesce (count( case when cd_etapa = 2  and cd_etapa_fase = 4 then id_matricula  end),0) fund_af,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_etapa_fase = 4 then id_matricula  end),0) fund_af_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 1 then id_matricula  end),0) fund_1s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 1 then id_matricula  end),0) fund_1s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 2 then id_matricula  end),0) fund_2s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 2 then id_matricula  end),0) fund_2s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 3 then id_matricula  end),0) fund_3s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 3 then id_matricula  end),0) fund_3s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 4 then id_matricula  end),0) fund_4s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 4 then id_matricula  end),0) fund_4s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 5 then id_matricula  end),0) fund_5s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 5 then id_matricula  end),0) fund_5s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 6 then id_matricula  end),0) fund_6s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 6 then id_matricula  end),0) fund_6s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 7 then id_matricula  end),0) fund_7s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 7 then id_matricula  end),0) fund_7s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 8 then id_matricula  end),0) fund_8s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 8 then id_matricula  end),0) fund_8s_integ,
coalesce (count( case when cd_etapa = 2  and cd_ano_serie = 9 then id_matricula  end),0) fund_9s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 2  and cd_ano_serie = 9 then id_matricula  end),0) fund_9s_integ,
coalesce (count( case when cd_etapa = 3  and in_regular = 1 then id_matricula  end),0) esc_tot_medio,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 3  and in_regular = 1 then id_matricula  end),0) esc_tot_medio_integ,
coalesce (count( case when cd_etapa = 3  and cd_ano_serie = 10 then id_matricula  end),0) med_10s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 10 then id_matricula  end),0) med_10s_integ,
coalesce (count( case when cd_etapa = 3  and cd_ano_serie = 11 then id_matricula  end),0) med_11s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 11 then id_matricula  end),0) med_11s_integ,
coalesce (count( case when cd_etapa = 3  and cd_ano_serie = 12 then id_matricula  end),0) med_12s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 12 then id_matricula  end),0) med_12s_integ,
coalesce (count( case when cd_etapa = 3  and cd_ano_serie = 13 then id_matricula  end),0) med_13s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 13 then id_matricula  end),0) med_13s_integ,
coalesce (count( case when cd_etapa = 3  and cd_ano_serie = 14 then id_matricula  end),0) med_14s,
coalesce (count( case when nu_duracao_turma >= 420 and cd_etapa = 3  and cd_ano_serie = 14 then id_matricula  end),0) med_14s_integ,
coalesce (count( case when in_eja = 1 then id_matricula  end),0) eja_total,
coalesce (count( case when nu_duracao_turma >= 420 and in_eja = 1 then id_matricula  end),0) eja_total_integ,
coalesce (count( case when in_eja = 1 and cd_etapa = 2 then id_matricula  end),0) eja_fund,
coalesce (count( case when nu_duracao_turma >= 420 and in_eja = 1 and cd_etapa = 2 then id_matricula  end),0) eja_fund_integ,
coalesce (count( case when in_eja = 1 and cd_etapa = 3 then id_matricula  end),0) eja_medio,
coalesce (count( case when nu_duracao_turma >= 420 and in_eja = 1 and cd_etapa = 3 then id_matricula  end),0) eja_medio_integ
from censo_esc_ce.tb_matricula_2023 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio 
where 
cd_etapa in (1,2,3,4) --and tm.co_municipio = 2304400 --and nm_municipio = 'Maracanaú'
group by 1,2,3
order by 2,3

/*
--SOMENTE ANOS INICIAIS
--676
/*
with quantidades as (
select 
id_municipio,
nm_municipio,
count(1) total,
sum(case when nu_duracao_turma>=420 then 1 else 0 end) qtd_integral,
sum(case when cd_ano_serie = 1  then 1 else 0 end) qtd_1_serie,
sum(case when cd_ano_serie = 1  and nu_duracao_turma>=420 then 1 else 0 end) qtd_1_serie_integral,
sum(case when cd_ano_serie = 2  then 1 else 0 end) qtd_2_serie,
sum(case when cd_ano_serie = 2  and nu_duracao_turma>=420 then 1 else 0 end) qtd_2_serie_integral,
sum(case when cd_ano_serie = 3  then 1 else 0 end) qtd_3_serie,
sum(case when cd_ano_serie = 3  and nu_duracao_turma>=420 then 1 else 0 end) qtd_3_serie_integral,
sum(case when cd_ano_serie = 4  then 1 else 0 end) qtd_4_serie,
sum(case when cd_ano_serie = 4  and nu_duracao_turma>=420 then 1 else 0 end) qtd_4_serie_integral,
sum(case when cd_ano_serie = 5  then 1 else 0 end) qtd_5_serie,
sum(case when cd_ano_serie = 5  and nu_duracao_turma>=420 then 1 else 0 end) qtd_5_serie_integral
from censo_esc_ce.tb_matricula_2023 tm 
join dw_censo.tb_dm_municipio tdm on id_municipio = co_municipio
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where 
cd_ano_serie in (1,2,3,4,5)
and tp_dependencia =3
group by 1,2
)
select   
2023 nu_ano_censo,
id_municipio,
nm_municipio,
total,
qtd_integral,
round(qtd_integral/total::numeric*100,2) perc_integral_total,
qtd_1_serie,
qtd_1_serie_integral,
round(qtd_1_serie_integral/qtd_1_serie::numeric*100,2) perc_1_serie_integral,
qtd_2_serie,
qtd_2_serie_integral,
round(qtd_2_serie_integral/qtd_2_serie::numeric*100,2) perc_2_serie_integral,
qtd_3_serie,
qtd_3_serie_integral,
round(qtd_3_serie_integral/qtd_3_serie::numeric*100,2) perc_3_serie_integral,
qtd_4_serie,
qtd_4_serie_integral,
round(qtd_4_serie_integral/qtd_4_serie::numeric*100,2) perc_4_serie_integral,
qtd_5_serie,
qtd_5_serie_integral,
round(qtd_5_serie_integral/qtd_5_serie::numeric*100,2) perc_5_serie_integral
from quantidades 
-----

*/