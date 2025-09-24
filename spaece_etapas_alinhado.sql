with esc as (
select 
nr_ano_censo,
id_escola_inep
from dw_censo.tb_dm_escola tde 
where
tde.nr_ano_censo >2014
and tde.cd_dependencia = 2
union 
select 
nu_ano_censo nr_ano_censo,
co_entidade id_escola_inep
from censo_esc_d.tb_escola te 
where te.tp_dependencia = 2
) select distinct nr_ano_censo from esc
select /*
nr_ano,
id_escola_inep,
tsa.nu_sequencial,
tsa.cd_etapa_ceipe,
case when cd_etapa_aplicacao_turma::int =	15	then	2
     when cd_etapa_aplicacao_turma::int = 	5	then	5
     when cd_etapa_aplicacao_turma::int =	18	then	5
     when cd_etapa_aplicacao_turma::int =	9	then	9
     when cd_etapa_aplicacao_turma::int =	41	then	9
     when cd_etapa_aplicacao_turma::int =	22	then	9
     when cd_etapa_aplicacao_turma::int =	10	then	10
     when cd_etapa_aplicacao_turma::int =	101	then	10
     when cd_etapa_aplicacao_turma::int =	12	then	12
     when cd_etapa_aplicacao_turma::int =	32	then	12
     when cd_etapa_aplicacao_turma::int =	27	then	12
     when cd_etapa_aplicacao_turma::int =	37	then	12
     when cd_etapa_aplicacao_turma::int =	74	then	99
     when cd_etapa_aplicacao_turma::int =	27	then	99
     when cd_etapa_aplicacao_turma::int =	71	then	99
     when cd_etapa_aplicacao_turma::int =	90	then	99
     when cd_etapa_aplicacao_turma::int =	100	then	99 end cd_ano_serie,
prof_lp,
prof_lp_erro,
prof_mt,
prof_mt_erro*/
distinct nr_ano
from base_identificada.tb_spaece_alinhado tsa 
inner join esc on nr_ano_censo = tsa.nr_ano and tsa.cd_escola::int =  id_escola_inep 
where
tsa.fl_avaliado = 1
and nr_ano::int between 2014 and 2019