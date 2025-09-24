with codigo as ( 
select 
distinct cd_aluno_inep
from base_identificada.tb_base_spaece_censo tbsc 
where cd_ano_serie_ceipe = 12
and nr_ano =2018
and cd_aluno_inep is not null 
)
,rep as (
select 
ts.co_pessoa_fisica,
count(1) nr_reprov
from censo_esc_ce.tb_situacao_2007_2018 ts 
join codigo c on c.cd_aluno_inep = co_pessoa_fisica
where 
ts.tp_situacao = 4
and nu_ano_censo<2016
group by 1
)
select count(1)
from base_identificada.tb_base_spaece_censo tbsc 
join rep on cd_aluno_inep = co_pessoa_fisica
where cd_ano_serie_ceipe = 12
and nr_ano =2018
and cd_aluno_inep is not null 
and vl_perc_acertos_lp is not null
and vl_perc_acertos_mt is not null
and prof_lp is not null
and prof_lp_erro is not null
and prof_mt is not null
and prof_mt_erro is not null
and fl_avaliado = 1
--order by nr_reprov desc