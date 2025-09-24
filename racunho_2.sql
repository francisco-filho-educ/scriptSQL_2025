select 
nr_ano_censo,
--escolas
count(distinct case when cd_dependencia = 2 then id_escola_inep end) qtd_escolas_est,
count(distinct case when cd_dependencia = 4 then id_escola_inep end) qtd_escolas_part,
--turmas
count(distinct case when cd_dependencia = 2 then id_turma end) qtd_turma_est,
count(distinct case when cd_dependencia = 4 then id_turma end) qtd_turma_part,
--matricula
sum(case when cd_dependencia = 2 then nr_matriculas else 0 end) qtd_matricula_est,
sum(case when cd_dependencia = 4 then nr_matriculas else 0 end) qtd_matricula_part
from dw_censo.tb_cubo_matricula tcm 
where
nr_ano_censo > 2011
and cd_etapa = 3
and cd_dependencia in (2,4)
group by 1


select 
0 ds_etapa_ensino,
count(distinct co_entidade)
from censo_esc_ce.tb_matricula_2022 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where tp_dependencia  = 4
and tp_etapa_ensino is not null 
and cd_etapa in (1,2,3)
group by 1