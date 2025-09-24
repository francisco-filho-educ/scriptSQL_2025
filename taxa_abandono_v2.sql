 --- dados ceará --------------
with sit as (
select
nu_ano_censo,
co_entidade,
tp_dependencia,
sum(case when cd_etapa = 2  then 1 else 0 end)::numeric nr_fund_tot,
sum(case when tp_situacao = 2 and  cd_etapa = 2  then 1 else 0 end)::numeric aba_fund_tot,
sum(case when cd_etapa = 2  and cd_etapa_fase = 3  then 1 else 0 end)::numeric  nr_fund_ai,
sum(case when tp_situacao = 2 and  cd_etapa = 2  and cd_etapa_fase = 3  then 1 else 0 end)::numeric  aba_fund_ai,
sum(case when cd_etapa = 2  and cd_etapa_fase = 4  then 1 else 0 end)::numeric  nr_fund_af,
sum(case when tp_situacao = 2 and  cd_etapa = 2  and cd_etapa_fase = 4  then 1 else 0 end)::numeric  aba_fund_af,
sum(case when cd_etapa = 3  then 1 else 0 end)::numeric nr_medio,
sum(case when tp_situacao = 2 and  cd_etapa = 3  then 1 else 0 end)::numeric aba_medio
from censo_esc_ce.tb_situacao_2019 s
join bi_ce.tb_censo_dm_etapa on tp_etapa_ensino_censo = tp_etapa_ensino::int 
where 
nu_ano_censo = 2019
and tp_etapa_ensino::int is not null
and cd_etapa in (2,3)
and in_regular::int =1
and tp_situacao::int in (2,4,5)
and in_especial_exclusiva<>1
--and co_municipio = 2304400
group by 1,2,3
union 
select
nu_ano_censo,
co_entidade,
tp_dependencia,
sum(case when cd_etapa = 2  then 1 else 0 end)::numeric nr_fund_tot,
sum(case when tp_situacao = 2 and  cd_etapa = 2  then 1 else 0 end)::numeric aba_fund_tot,
sum(case when cd_etapa = 2  and cd_etapa_fase = 3  then 1 else 0 end)::numeric  nr_fund_ai,
sum(case when tp_situacao = 2 and  cd_etapa = 2  and cd_etapa_fase = 3  then 1 else 0 end)::numeric  aba_fund_ai,
sum(case when cd_etapa = 2  and cd_etapa_fase = 4  then 1 else 0 end)::numeric  nr_fund_af,
sum(case when tp_situacao = 2 and  cd_etapa = 2  and cd_etapa_fase = 4  then 1 else 0 end)::numeric  aba_fund_af,
sum(case when cd_etapa = 3  then 1 else 0 end)::numeric nr_medio,
sum(case when tp_situacao = 2 and  cd_etapa = 3  then 1 else 0 end)::numeric aba_medio
from censo_esc_ce.tb_situacao_2020 s
join bi_ce.tb_censo_dm_etapa on tp_etapa_ensino_censo = tp_etapa_ensino::int 
where 
nu_ano_censo = 2020
and tp_etapa_ensino::int is not null
and cd_etapa in (2,3)
and in_regular::int =1
and tp_situacao::int in (2,4,5)
and in_especial_exclusiva<>1
--and co_municipio = 2304400
group by 1,2,3
) /*
 select
1 ord,
'CEARÁ' uf,
0 co_municipio,
'TOTAL' nm_municipio,
tp_dependencia::int,
case when tp_dependencia::int = 1  then 'Federal'
     when tp_dependencia::int = 2 then 'Estadual'
     when tp_dependencia::int = 3 then 'Municipal'
     when tp_dependencia::int = 4 then 'Privada' end ds_dependencia,
case when sum(nr_fund_tot) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_fund_tot)/sum(nr_fund_tot)*100,1)end tx_aba_fund_2019,
case when sum(nr_fund_tot) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_fund_tot)/sum(nr_fund_tot)*100,1)end tx_aba_fund_2020,
case when sum(nr_fund_ai) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_fund_ai)/sum(nr_fund_ai)*100,1)end tx_aba_fund_ai_2019,
case when sum(nr_fund_ai) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_fund_ai)/sum(nr_fund_ai)*100,1)end tx_aba_fund_ai_2020,
case when sum(nr_fund_af) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_fund_af)/sum(nr_fund_af)*100,1)end tx_aba_af_2019,
case when sum(nr_fund_af) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_fund_af)/sum(nr_fund_af)*100,1)end tx_aba_af_2020,
case when sum(nr_medio) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_medio)/sum(nr_medio )*100,1)end tx_aba_medio_2019,
case when sum(nr_medio) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_medio)/sum(nr_medio )*100,1)end tx_aba_medio_2020
from sit s
join censo_esc_ce.tb_escola_2019_2020 e using(nu_ano_censo,co_entidade)
join bi_ce.tb_censo_dm_municipio on co_municipio::bigint = id_municipio
group by 1,2,3,4,5,6
union 
select
1 ord,
'CEARÁ' uf,
0 co_municipio,
'TOTAL' nm_municipio,
99 tp_dependencia,
'TOTAL' ds_dependencia,
case when sum(nr_fund_tot) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_fund_tot)/sum(nr_fund_tot)*100,1)end tx_aba_fund_2019,
case when sum(nr_fund_tot) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_fund_tot)/sum(nr_fund_tot)*100,1)end tx_aba_fund_2020,
case when sum(nr_fund_ai) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_fund_ai)/sum(nr_fund_ai)*100,1)end tx_aba_fund_ai_2019,
case when sum(nr_fund_ai) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_fund_ai)/sum(nr_fund_ai)*100,1)end tx_aba_fund_ai_2020,
case when sum(nr_fund_af) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_fund_af)/sum(nr_fund_af)*100,1)end tx_aba_af_2019,
case when sum(nr_fund_af) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_fund_af)/sum(nr_fund_af)*100,1)end tx_aba_af_2020,
case when sum(nr_medio) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_medio)/sum(nr_medio )*100,1)end tx_aba_medio_2019,
case when sum(nr_medio) =0.0  and nu_ano_censo =  then 0 else round(sum(aba_medio)/sum(nr_medio )*100,1)end tx_aba_medio_2020
from sit s
join censo_esc_ce.tb_escola_2019_2020 e using(nu_ano_censo,co_entidade)
join bi_ce.tb_censo_dm_municipio on co_municipio::bigint = id_municipio
group by 1,2,3,4,5,6
order by tp_dependencia */
---- dados municipio -------
--union
select
2 ord,
'CEARÁ' uf,
co_municipio,
nm_municipio,
e.tp_dependencia,
case when e.tp_dependencia::int = 1  then 'Federal'
     when e.tp_dependencia::int = 2 then 'Estadual'
     when e.tp_dependencia::int = 3 then 'Municipal'
     when e.tp_dependencia::int = 4 then 'Privada' end ds_dependencia,
case when nu_ano_censo = 2019 and sum(nr_fund_tot) =0.0   then 0 else round(sum(aba_fund_tot)/sum(nr_fund_tot)*100,1)end tx_aba_fund_2019,
case when nu_ano_censo = 2019 and  sum(nr_fund_tot) =0.0   then 0 else round(sum(aba_fund_tot)/sum(nr_fund_tot)*100,1)end tx_aba_fund_2020,
case when nu_ano_censo = 2019 and  sum(nr_fund_ai) =0.0    then 0 else round(sum(aba_fund_ai)/sum(nr_fund_ai)*100,1)end tx_aba_fund_ai_2019,
case when nu_ano_censo = 2019 and  sum(nr_fund_ai) =0.0    then 0 else round(sum(aba_fund_ai)/sum(nr_fund_ai)*100,1)end tx_aba_fund_ai_2020,
case when nu_ano_censo = 2019 and  sum(nr_fund_af) =0.0    then 0 else round(sum(aba_fund_af)/sum(nr_fund_af)*100,1)end tx_aba_af_2019,
case when nu_ano_censo = 2019 and  sum(nr_fund_af) =0.0    then 0 else round(sum(aba_fund_af)/sum(nr_fund_af)*100,1)end tx_aba_af_2020,
case when nu_ano_censo = 2019 and  sum(nr_medio) =0.0    then 0 else round(sum(aba_medio)/sum(nr_medio )*100,1)end tx_aba_medio_2019,
case when nu_ano_censo = 2019 and  sum(nr_medio) =0.0    then 0 else round(sum(aba_medio)/sum(nr_medio )*100,1)end tx_aba_medio_2020
from sit s
join censo_esc_ce.tb_escola_2019_2020 e using(nu_ano_censo,co_entidade)
join bi_ce.tb_censo_dm_municipio on co_municipio::bigint = id_municipio
group by 1,2,3,4,5
union 
select
2 ord,
'CEARÁ' uf,
co_municipio,
nm_municipio,
99 tp_dependencia,
'TOTAL' ds_dependencia,
case when sum(nr_fund_tot) =0.0   then 0 else round(sum(aba_fund_tot)/sum(nr_fund_tot)*100,1)end tx_aba_fund_2019,
case when sum(nr_fund_tot) =0.0    then 0 else round(sum(aba_fund_tot)/sum(nr_fund_tot)*100,1)end tx_aba_fund_2020,
case when sum(nr_fund_ai) =0.0    then 0 else round(sum(aba_fund_ai)/sum(nr_fund_ai)*100,1)end tx_aba_fund_ai_2019,
case when sum(nr_fund_ai) =0.0    then 0 else round(sum(aba_fund_ai)/sum(nr_fund_ai)*100,1)end tx_aba_fund_ai_2020,
case when sum(nr_fund_af) =0.0    then 0 else round(sum(aba_fund_af)/sum(nr_fund_af)*100,1)end tx_aba_af_2019,
case when sum(nr_fund_af) =0.0    then 0 else round(sum(aba_fund_af)/sum(nr_fund_af)*100,1)end tx_aba_af_2020,
case when sum(nr_medio) =0.0    then 0 else round(sum(aba_medio)/sum(nr_medio )*100,1)end tx_aba_medio_2019,
case when sum(nr_medio) =0.0    then 0 else round(sum(aba_medio)/sum(nr_medio )*100,1)end tx_aba_medio_2020
from sit s
join censo_esc_ce.tb_escola_2019_2020 e using(nu_ano_censo,co_entidade)
join bi_ce.tb_censo_dm_municipio on co_municipio::bigint = id_municipio
group by 1,2,3,4,5
order by nm_municipio,tp_dependencia 