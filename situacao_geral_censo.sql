select 
nr_ano_censo::int,
nm_crede_sefor,
'Santana do Acaraú' municipio,
ds_dependencia,/*
id_escola_inep,
nm_escola,
ds_localizacao,*/
ds_etapa_ensino,
cd_ano_serie,
sum(case when tp_situacao  =  5 then 1 else 0 end) nr_aprovado,
sum(case when tp_situacao  =  4 then 1 else 0 end) nr_reprovado,
sum(case when tp_situacao  =  2 then 1 else 0 end) nr_abandono,
sum(case when IN_TRANSFERIDO = 1 then 1 else 0 end) nr_tranf,
sum(case when co_evento = 55 then 1 else 0 end) nr_admitido
from censo_esc_ce.tb_situacao_2021 ts 
join dw_censo.tb_dm_etapa tde2 on ts.tp_etapa_ensino = tde2.cd_etapa_ensino 
join dw_censo.tb_dm_escola tde on tde.nr_ano_censo = nu_ano_censo and ts.co_entidade = tde.id_escola_inep and tde.id_municipio = 2312007
where 
nu_ano_censo = 2021
and tde.cd_dependencia = 3
and co_municipio = 2312007
group by 1,2,3,4,5,6
order by cd_ano_serie
