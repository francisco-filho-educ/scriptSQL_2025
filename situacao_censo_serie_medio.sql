with sit as( 
select
nu_ano_censo nr_ano_censo,
co_entidade id_escola_inep,
count(1) nr_matriculas,
sum(case when tp_situacao = 5 then 1 else 0 end)::numeric  nr_aprovados,	
sum(case when tp_situacao = 4 then 1 else 0 end)::numeric  nr_reprovados,	
sum(case when tp_situacao = 2 then 1 else 0 end)::numeric  nr_abandono,
count(1)::numeric nr_matricula_situacao
from censo_esc_ce.tb_situacao_2007_2018 tm 
join bi_ce.tb_censo_dm_etapa on tp_etapa_ensino_censo = tp_etapa_ensino
where nu_ano_censo = 2018-- = 2018 and co_municipio = 2304400
and cd_etapa = 3
and in_regular = 1
and tp_situacao in (2,4,5)
and tm.tp_dependencia =2
group by 1,2
union 
select
nu_ano_censo nr_ano_censo,
co_entidade id_escola_inep,
count(1) nr_matriculas,
sum(case when tp_situacao = 5 then 1 else 0 end)::numeric  nr_aprovados,	
sum(case when tp_situacao = 4 then 1 else 0 end)::numeric  nr_reprovados,	
sum(case when tp_situacao = 2 then 1 else 0 end)::numeric  nr_abandono,
count(1)::numeric nr_matricula_situacao
from censo_esc_ce.tb_situacao_2019 tm 
join bi_ce.tb_censo_dm_etapa on tp_etapa_ensino_censo = tp_etapa_ensino
where nu_ano_censo = 2019-- = 2018 and co_municipio = 2304400
and cd_etapa = 3
and in_regular = 1
and tp_situacao in (2,4,5)
and tm.tp_dependencia =2
group by 1,2
union 
select
nu_ano_censo nr_ano_censo,
co_entidade id_escola_inep,
count(1) nr_matriculas,
sum(case when tp_situacao = 5 then 1 else 0 end)::numeric  nr_aprovados,	
sum(case when tp_situacao = 4 then 1 else 0 end)::numeric  nr_reprovados,	
sum(case when tp_situacao = 2 then 1 else 0 end)::numeric  nr_abandono,
count(1)::numeric nr_matricula_situacao
from censo_esc_ce.tb_situacao_2020 tm 
join bi_ce.tb_censo_dm_etapa on tp_etapa_ensino_censo = tp_etapa_ensino
where nu_ano_censo = 2020-- = 2018 and co_municipio = 2304400
and cd_etapa = 3
and in_regular = 1
and tp_situacao in (2,4,5)
and tm.tp_dependencia =2
group by 1,2
union 
select
nu_ano_censo nr_ano_censo,
co_entidade id_escola_inep,
count(1) nr_matriculas,
sum(case when tp_situacao = 5 then 1 else 0 end)::numeric  nr_aprovados,	
sum(case when tp_situacao = 4 then 1 else 0 end)::numeric  nr_reprovados,	
sum(case when tp_situacao = 2 then 1 else 0 end)::numeric  nr_abandono,
count(1)::numeric nr_matricula_situacao
from censo_esc_ce.tb_situacao_2021 tm 
join bi_ce.tb_censo_dm_etapa on tp_etapa_ensino_censo = tp_etapa_ensino
where nu_ano_censo = 2021-- = 2018 and co_municipio = 2304400
and cd_etapa = 3
and in_regular = 1
and tp_situacao in (2,4,5)
and tm.tp_dependencia =2
group by 1,2
)
select
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
nr_aprovados,
round(case when nr_aprovados <1 then 0.0 else nr_aprovados/nr_matriculas*100 end,1) tx_aprovacao,
nr_reprovados,
round(case when nr_reprovados <1 then 0.0 else nr_reprovados/nr_matriculas*100 end,1) tx_reprovacao,
nr_abandono,
round(case when nr_abandono <1 then 0.0 else nr_abandono/nr_matriculas*100 end,1) tx_abandono
from sit 
join dw_censo.tb_dm_escola tde using(nr_ano_censo,id_escola_inep)
join dw_censo.tb_dm_municipio tdm using(id_municipio)
order by 1