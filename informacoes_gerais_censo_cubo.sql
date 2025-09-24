select 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
sum(nr_matriculas) total,
sum(case when f.cd_etapa = 1 then nr_matriculas else 0 end) nr_infantil,
sum(case when f.cd_etapa = 2 and tdt.fl_regular = 1 then nr_matriculas else 0 end) nr_fund_r,
sum(case when f.cd_etapa = 2 and tdt.fl_regular = 1 and f.cd_etapa_fase = 3 then nr_matriculas else 0 end) nr_ai,
sum(case when f.cd_etapa = 2 and tdt.fl_regular = 1 and f.cd_etapa_fase = 4 then nr_matriculas else 0 end) nr_af,
sum(case when f.cd_etapa = 3 and tdt.fl_regular = 1 then nr_matriculas else 0 end) nr_medio_total,
sum(case when f.cd_etapa = 3 and tdt.fl_regular = 1 and f.cd_ano_serie = 10 then nr_matriculas else 0 end) nr_medio_1,
sum(case when f.cd_etapa = 3 and tdt.fl_regular = 1 and f.cd_ano_serie = 11  then nr_matriculas else 0 end) nr_medio_2,
sum(case when f.cd_etapa = 3 and tdt.fl_regular = 1 and f.cd_ano_serie = 12  then nr_matriculas else 0 end) nr_medio_3,
sum(case when f.cd_etapa = 3 and tdt.fl_regular = 1 and f.cd_ano_serie = 13  then nr_matriculas else 0 end) nr_medio_4,
sum(case when tdt.fl_eja = 1 then nr_matriculas else 0 end) nr_eja,
sum(case when tdt.fl_eja = 1 and f.cd_etapa = 2 then nr_matriculas else 0 end) nr_eja_fund,
sum(case when tdt.fl_eja = 1 and f.cd_etapa = 3 then nr_matriculas else 0 end) nr_eja_medio,
sum(case when tdt.cd_local_turma in (2,3) then nr_matriculas else 0 end) nr_prisional,
sum(case when tdt.cd_local_turma in (2,3) and f.cd_etapa = 2 then nr_matriculas else 0 end) nr_prisional_fund,
sum(case when tdt.cd_local_turma in (2,3) and f.cd_etapa = 3 then nr_matriculas else 0 end) nr_prisional_medio
from dw_censo.tb_ft_matricula_dinamico f
join dw_censo.tb_dm_turma_dinamico tdt using(id_dm_turma,nr_ano_censo,id_dm_escola)
join dw_censo.tb_dm_escola_dinamico e using(nr_ano_censo,id_dm_escola)
where 
f.cd_etapa in (1,2,3)
and e.cd_dependencia = 2 and id_crede_sefor <> 99 and tdt.cd_local_turma in (2,3)
group by 1,2,3
order by 2
