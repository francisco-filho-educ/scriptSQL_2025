select 
nu_ano_censo,
id_municipio,
nm_municipio,
count(1) total_situacao,
sum(case when cd_etapa = 2 then 1 else 0 end) total_fundamental,
sum(case when cd_etapa = 2 and tp_situacao  =  5 then 1 else 0 end) nr_aprovado_fundamental,
sum(case when cd_etapa = 2 and tp_situacao  =  4 then 1 else 0 end) nr_reprovado_fundamental,
sum(case when cd_etapa = 2 and tp_situacao  =  2 then 1 else 0 end) nr_abandono_fundamantal,
sum(case when cd_etapa = 3 then 1 else 0 end) total_medio,
sum(case when cd_etapa = 3 and tp_situacao  =  5 then 1 else 0 end) nr_aprovado_medio,
sum(case when cd_etapa = 3 and tp_situacao  =  4 then 1 else 0 end) nr_reprovado_medio,
sum(case when cd_etapa = 3 and tp_situacao  =  2 then 1 else 0 end) nr_abandono_medio,
sum(case when in_educacao_indigena = 1 then 1 else 0 end) total_situacao_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 2 then 1 else 0 end) total_fundamental,
sum(case when in_educacao_indigena = 1 and cd_etapa = 2 and tp_situacao  =  5 then 1 else 0 end) nr_aprovado_fundamental_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 2 and tp_situacao  =  4 then 1 else 0 end) nr_reprovado_fundamental_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 2 and tp_situacao  =  2 then 1 else 0 end) nr_abandono_fundamantal_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 3 then 1 else 0 end) total_medio_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 3 and tp_situacao  =  5 then 1 else 0 end) nr_aprovado_medio_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 3 and tp_situacao  =  4 then 1 else 0 end) nr_reprovado_medio_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 3 and tp_situacao  =  2 then 1 else 0 end) nr_abandono_medio_indigena
from censo_esc_ce.tb_situacao_2019 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = ts.tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on id_municipio = co_municipio
where 
--ts.in_educacao_indigena = 1
ts.tp_situacao in(4,5,2)
and ts.tp_dependencia in (2,3)
and ts.in_regular = 1
group by 1,2,3
union 
select 
nu_ano_censo,
0 id_municipio,
'zTOTAL DO ESTADO' nm_municipio,
count(1) total_situacao,
sum(case when cd_etapa = 2 then 1 else 0 end) total_fundamental,
sum(case when cd_etapa = 2 and tp_situacao  =  5 then 1 else 0 end) nr_aprovado_fundamental,
sum(case when cd_etapa = 2 and tp_situacao  =  4 then 1 else 0 end) nr_reprovado_fundamental,
sum(case when cd_etapa = 2 and tp_situacao  =  2 then 1 else 0 end) nr_abandono_fundamantal,
sum(case when cd_etapa = 3 then 1 else 0 end) total_medio,
sum(case when cd_etapa = 3 and tp_situacao  =  5 then 1 else 0 end) nr_aprovado_medio,
sum(case when cd_etapa = 3 and tp_situacao  =  4 then 1 else 0 end) nr_reprovado_medio,
sum(case when cd_etapa = 3 and tp_situacao  =  2 then 1 else 0 end) nr_abandono_medio,
sum(case when in_educacao_indigena = 1 then 1 else 0 end) total_situacao_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 2 then 1 else 0 end) total_fundamental,
sum(case when in_educacao_indigena = 1 and cd_etapa = 2 and tp_situacao  =  5 then 1 else 0 end) nr_aprovado_fundamental_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 2 and tp_situacao  =  4 then 1 else 0 end) nr_reprovado_fundamental_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 2 and tp_situacao  =  2 then 1 else 0 end) nr_abandono_fundamantal_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 3 then 1 else 0 end) total_medio_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 3 and tp_situacao  =  5 then 1 else 0 end) nr_aprovado_medio_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 3 and tp_situacao  =  4 then 1 else 0 end) nr_reprovado_medio_indigena,
sum(case when in_educacao_indigena = 1 and cd_etapa = 3 and tp_situacao  =  2 then 1 else 0 end) nr_abandono_medio_indigena
from censo_esc_ce.tb_situacao_2019 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = ts.tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on id_municipio = co_municipio
where 
ts.tp_situacao in(4,5,2)
and ts.tp_dependencia in (2,3)
and ts.in_regular = 1
group by 1,2,3
order by 3

#matriculas e distorcao
with fator as (
select 
id_matricula,
case when nu_idade_referencia - cd_ano_serie > 7 then 1 else 0 end fl_distorcao
from censo_esc_ce.tb_matricula_2019 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = ts.tp_etapa_ensino 
where 
cd_ano_serie between 1 and 13
and cd_ano_serie between 1 and 13
)
select 
nu_ano_censo,
id_municipio,
nm_municipio,
count(1) matricula_total,
sum(case when in_regular = 1  then 1 else 0 end) matricula_regular_total,
sum(case when cd_ano_serie between 1 and 13 then 1 else 0 end) matricula_regular_seriado,
sum(case when cd_ano_serie between 1 and 13 and fl_distorcao = 1 then 1 else 0 end) matricula_regular_distorcao,
sum(case when cd_ano_serie between 1 and 13 and cd_etapa = 2 then 1 else 0 end) matricula_regular_fund_seriado,
sum(case when cd_ano_serie between 1 and 13 and cd_etapa = 2 and fl_distorcao = 1 then 1 else 0 end) matricula_fund_distorcao,
sum(case when cd_ano_serie between 1 and 13 and cd_etapa = 3 then 1 else 0 end) matricula_regular_medio_seriado,
sum(case when cd_ano_serie between 1 and 13 and cd_etapa = 3 and fl_distorcao = 1 then 1 else 0 end) matricula_medio_distorcao,
--sem distrocao
sum(case when cd_etapa = 1  then 1 else 0 end) matricula_infantil,
sum(case when in_eja = 1 and cd_etapa = 2 then 1 else 0 end) matricula_eja_fund,
sum(case when in_eja = 1 and cd_etapa = 3 then 1 else 0 end) matricula_eja_medio,
--indigena
sum(case when in_educacao_indigena = 1 then 1 else 0 end) total_indigena,
sum(case when in_educacao_indigena = 1 and cd_ano_serie between 1 and 13 then 1 else 0 end) matricula_regular_total_indig,
sum(case when in_educacao_indigena = 1 and cd_ano_serie between 1 and 13 and fl_distorcao = 1 then 1 else 0 end) matricula_regular_distorcao_indig,
sum(case when in_educacao_indigena = 1 and cd_ano_serie between 1 and 13 and cd_etapa = 2 then 1 else 0 end) matricula_regular_fund_seriado_indig,
sum(case when in_educacao_indigena = 1 and cd_ano_serie between 1 and 13 and cd_etapa = 2 and fl_distorcao = 1 then 1 else 0 end) matricula_fund_distorcao_indig,
sum(case when in_educacao_indigena = 1 and cd_ano_serie between 1 and 13 and cd_etapa = 3 then 1 else 0 end) matricula_regular_medio_seriado_indig,
sum(case when in_educacao_indigena = 1 and cd_ano_serie between 1 and 13 and cd_etapa = 3 and fl_distorcao = 1 then 1 else 0 end) matricula_medio_distorcao_indig,
-- Sem distorção
sum(case when in_educacao_indigena = 1 and  cd_etapa = 1  then 1 else 0 end) matricula_infantil_indig,
sum(case when in_educacao_indigena = 1 and in_eja = 1 and cd_etapa = 2 then 1 else 0 end) matricula_eja_fund_indig,
sum(case when in_educacao_indigena = 1 and in_eja = 1 and cd_etapa = 3 then 1 else 0 end) matricula_eja_medio_indig
from censo_esc_ce.tb_matricula_2019 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = ts.tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on id_municipio = co_municipio
left join fator using(id_matricula)
where 
ts.tp_dependencia in (2,3)
and cd_etapa in (1,2,3)
group by 1,2,3
union 
select 
nu_ano_censo,
0 id_municipio,
'zzTOTAL DO ESTADO' nm_municipio,
count(1) matricula_total,
sum(case when in_regular = 1  then 1 else 0 end) matricula_regular_total,
sum(case when cd_ano_serie between 1 and 13 then 1 else 0 end) matricula_regular_seriado,
sum(case when cd_ano_serie between 1 and 13 and fl_distorcao = 1 then 1 else 0 end) matricula_regular_distorcao,
sum(case when cd_ano_serie between 1 and 13 and cd_etapa = 2 then 1 else 0 end) matricula_regular_fund_seriado,
sum(case when cd_ano_serie between 1 and 13 and cd_etapa = 2 and fl_distorcao = 1 then 1 else 0 end) matricula_fund_distorcao,
sum(case when cd_ano_serie between 1 and 13 and cd_etapa = 3 then 1 else 0 end) matricula_regular_medio_seriado,
sum(case when cd_ano_serie between 1 and 13 and cd_etapa = 3 and fl_distorcao = 1 then 1 else 0 end) matricula_medio_distorcao,
--sem distrocao
sum(case when cd_etapa = 1  then 1 else 0 end) matricula_infantil,
sum(case when in_eja = 1 and cd_etapa = 2 then 1 else 0 end) matricula_eja_fund,
sum(case when in_eja = 1 and cd_etapa = 3 then 1 else 0 end) matricula_eja_medio,
--indigena
sum(case when in_educacao_indigena = 1 then 1 else 0 end) total_indigena,
sum(case when in_educacao_indigena = 1 and cd_ano_serie between 1 and 13 then 1 else 0 end) matricula_regular_total_indig,
sum(case when in_educacao_indigena = 1 and cd_ano_serie between 1 and 13 and fl_distorcao = 1 then 1 else 0 end) matricula_regular_distorcao_indig,
sum(case when in_educacao_indigena = 1 and cd_ano_serie between 1 and 13 and cd_etapa = 2 then 1 else 0 end) matricula_regular_fund_seriado_indig,
sum(case when in_educacao_indigena = 1 and cd_ano_serie between 1 and 13 and cd_etapa = 2 and fl_distorcao = 1 then 1 else 0 end) matricula_fund_distorcao_indig,
sum(case when in_educacao_indigena = 1 and cd_ano_serie between 1 and 13 and cd_etapa = 3 then 1 else 0 end) matricula_regular_medio_seriado_indig,
sum(case when in_educacao_indigena = 1 and cd_ano_serie between 1 and 13 and cd_etapa = 3 and fl_distorcao = 1 then 1 else 0 end) matricula_medio_distorcao_indig,
-- Sem distorção
sum(case when in_educacao_indigena = 1 and  cd_etapa = 1  then 1 else 0 end) matricula_infantil_indig,
sum(case when in_educacao_indigena = 1 and in_eja = 1 and cd_etapa = 2 then 1 else 0 end) matricula_eja_fund_indig,
sum(case when in_educacao_indigena = 1 and in_eja = 1 and cd_etapa = 3 then 1 else 0 end) matricula_eja_medio_indig
from censo_esc_ce.tb_matricula_2019 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = ts.tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on id_municipio = co_municipio
left join fator using(id_matricula)
where 
ts.tp_dependencia in (2,3)
and cd_etapa in (1,2,3)
group by 1,2,3
