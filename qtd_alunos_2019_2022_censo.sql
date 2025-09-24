select 
'2019 - 2020' nr_ano,
sum(case when exists(
select 1
from censo_esc_ce.tb_matricula_2019 eja 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = eja.tp_etapa_ensino 
where 
cd_etapa = 2
and cd_ano_serie = 9
--and in_eja = 1
and tp_dependencia = 4
and eja.co_pessoa_fisica = tm2.co_pessoa_fisica 
) then 1 else 0 end) ano_2019_2020
from censo_esc_ce.tb_matricula_2020 tm2 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm2.tp_etapa_ensino 
where cd_ano_serie = 10
and tp_dependencia = 2
group by 1
union ----------------
select 
'2020 - 2021' nr_ano,
sum(case when exists(
select 1
from censo_esc_ce.tb_matricula_2020 eja 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = eja.tp_etapa_ensino 
where 
cd_etapa = 2
and cd_ano_serie = 9
--and in_eja = 1
and tp_dependencia = 4
and eja.co_pessoa_fisica = tm2.co_pessoa_fisica 
) then 1 else 0 end) ano_2019_2020
from censo_esc_ce.tb_matricula_2021 tm2 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm2.tp_etapa_ensino 
where cd_ano_serie = 10
and tp_dependencia = 2
group by 1
union ----------------
select 
id_turma, co_pessoa_fisica 
from censo_esc_ce.tb_matricula_2022 tm2 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm2.tp_etapa_ensino 
where cd_ano_serie = 10
and tp_dependencia = 2
group by 1,2



select 
co_pessoa_fisica 
from censo_esc_ce.tb_matricula_2021 eja 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = eja.tp_etapa_ensino 
where 
cd_etapa = 2
and cd_ano_serie = 9
--and in_eja = 1
and tp_dependencia = 4





select 
nr_ano_censo,
sum(case when cd_ano_serie = 9 and cd_dependencia in (2,3) then nr_reprovados else 0 end ) reprovado_9_ano,
sum(case when cd_ano_serie = 9 and cd_dependencia in (2,3) then nr_abandono else 0 end ) nr_abandono_9_ano,
sum(case when cd_ano_serie = 10 and cd_dependencia in (2,3) then nr_reprovados else 0 end ) reprovado_1_serie,
sum(case when cd_ano_serie = 10 and cd_dependencia in (2,3) then nr_abandono else 0 end ) nr_abandono_1_serie
from dw_censo.tb_ft_situacao tfm
join dw_censo.tb_dm_escola tde using(id_escola_inep,nr_ano_censo)
where nr_ano_censo > 2018
and cd_dependencia in (2,3)
group by 1


