with sit as (
select 
tde.ds_ano_serie,
tde.cd_ano_serie,
ts.tp_situacao ,
case when nu_duracao_turma >= 420 then 4 else 
    case when concat(tx_hr_inicial,':',tx_mi_inicial)::time < '11:30:00'::time 
       and tx_hr_inicial::int<>1 then 1
      when (concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time > '11:30:00'::time 
         and concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time < '17:30:00'::time) 
         or bs.tx_hr_inicial::int = 1 then 2
      when concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time > '17:30:00'::time then 3
         end end CD_TURNO,
co_pessoa_fisica
from censo_esc_ce.tb_situacao_2021 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = ts.tp_etapa_ensino 
join censo_esc_ce.tb_turma_2021_d bs using(id_turma)
where 
ts.tp_dependencia = 2
and tde.cd_ano_serie between 1 and 13
and tp_situacao in (2,5,4)
) 
,qtd_turnos as(
select 
cd_ano_serie,
ds_ano_serie,
sum(case when cd_turno = 1  then 1 else 0 end)::numeric qtd_m,
sum(case when cd_turno = 2  then 1 else 0 end)::numeric qtd_t,
sum(case when cd_turno = 3  then 1 else 0 end)::numeric qtd_n,
sum(case when cd_turno = 4  then 1 else 0 end)::numeric qtd_i,
sum(case when cd_turno = 1 and tp_situacao = 5 then 1 else 0 end)::numeric qtd_apr_m,
sum(case when cd_turno = 1 and tp_situacao = 4 then 1 else 0 end)::numeric qtd_rep_m,
sum(case when cd_turno = 1 and tp_situacao = 2 then 1 else 0 end)::numeric qtd_aba_m,
sum(case when cd_turno = 2 and tp_situacao = 5 then 1 else 0 end)::numeric qtd_apr_t,
sum(case when cd_turno = 2 and tp_situacao = 4 then 1 else 0 end)::numeric qtd_rep_t,
sum(case when cd_turno = 2 and tp_situacao = 2 then 1 else 0 end)::numeric qtd_aba_t,
sum(case when cd_turno = 3 and tp_situacao = 5 then 1 else 0 end)::numeric qtd_apr_n,
sum(case when cd_turno = 3 and tp_situacao = 4 then 1 else 0 end)::numeric qtd_rep_n,
sum(case when cd_turno = 3 and tp_situacao = 2 then 1 else 0 end)::numeric qtd_aba_n,
sum(case when cd_turno = 4 and tp_situacao = 5 then 1 else 0 end)::numeric qtd_apr_i,
sum(case when cd_turno = 4 and tp_situacao = 4 then 1 else 0 end)::numeric qtd_rep_i,
sum(case when cd_turno = 4 and tp_situacao = 2 then 1 else 0 end)::numeric qtd_aba_i
from sit
group by 1,2
) 
select
cd_ano_serie,
ds_ano_serie,
case when qtd_m = 0 then 0 else  qtd_apr_m/qtd_m end tx_apr_m,
case when qtd_m = 0 then 0 else  qtd_rep_m/qtd_m end tx_rep_m,
case when qtd_m = 0 then 0 else  qtd_aba_m/qtd_m end tx_aba_m,
case when qtd_t = 0 then 0 else  qtd_apr_t/qtd_t end tx_apr_t,
case when qtd_t = 0 then 0 else  qtd_rep_t/qtd_t end tx_rep_t,
case when qtd_t = 0 then 0 else  qtd_aba_t/qtd_t end tx_aba_t,
case when qtd_n = 0 then 0 else  qtd_apr_n/qtd_n end tx_apr_n,
case when qtd_n = 0 then 0 else  qtd_rep_n/qtd_n end tx_rep_n,
case when qtd_n = 0 then 0 else  qtd_aba_n/qtd_n end tx_aba_n,
case when qtd_i = 0 then 0 else  qtd_apr_i/qtd_i end tx_apr_i,
case when qtd_i = 0 then 0 else  qtd_rep_i/qtd_i end tx_rep_i,
case when qtd_i = 0 then 0 else  qtd_aba_i/qtd_i end tx_aba_i
from qtd_turnos 
order by 1


