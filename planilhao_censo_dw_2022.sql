with pessoa as (
select 
nu_ano_censo,
tm.co_entidade,
tm.co_pessoa_fisica,
tm.id_turma,
cd_cor_raca,
tc.ds_cor_raca,
tp_sexo cd_sexo,
case when tm.tp_sexo = 1 then 'Masculino' else 'Feminino' end ds_sexo,
in_transporte_publico fl_transporte,
in_necessidade_especial fl_especial,
tp_etapa_ensino,
in_regular fl_regular,
in_eja fl_eja,
tp_mediacao_didatico_pedago cd_mediacao,
in_profissionalizante fl_profissionalizante,
tp_tipo_local_turma
from censo_esc_ce.tb_matricula_2022 tm 
left join dw_censo.tb_dm_cor_raca tc on tc.cd_cor_raca = tp_cor_raca 
where tp_etapa_ensino is not null
and tp_dependencia in (2,3) ) select count(1) from pessoa where tp_etapa_ensino = 41
union 
select 
nu_ano_censo,
tm.co_entidade,
tm.co_pessoa_fisica,
tm.id_turma,
cd_cor_raca,
tc.ds_cor_raca,
tp_sexo cd_sexo,
case when tm.tp_sexo = 1 then 'Masculino' else 'Feminino' end ds_sexo,
in_transporte_publico fl_transporte,
in_necessidade_especial fl_especial,
tp_etapa_ensino,
in_regular fl_regular,
in_eja fl_eja,
tp_mediacao_didatico_pedago cd_mediacao,
in_profissionalizante fl_profissionalizante,
tp_tipo_local_turma
from censo_esc_ce.tb_matricula_2021 tm 
left join dw_censo.tb_dm_cor_raca tc on tc.cd_cor_raca = tp_cor_raca 
where tp_etapa_ensino is not null
and tp_dependencia in (2,3)
union 
select 
nu_ano_censo,
tm.co_entidade,
tm.co_pessoa_fisica,
tm.id_turma,
cd_cor_raca,
tc.ds_cor_raca,
tp_sexo cd_sexo,
case when tm.tp_sexo = 1 then 'Masculino' else 'Feminino' end ds_sexo,
in_transporte_publico fl_transporte,
in_necessidade_especial fl_especial,
tp_etapa_ensino,
in_regular fl_regular,
in_eja fl_eja,
tp_mediacao_didatico_pedago cd_mediacao,
in_profissionalizante fl_profissionalizante,
tp_tipo_local_turma
from censo_esc_ce.tb_matricula_2020 tm 
left join dw_censo.tb_dm_cor_raca tc on tc.cd_cor_raca = tp_cor_raca 
where tp_etapa_ensino is not null
and tp_dependencia in (2,3)
union 
select 
nu_ano_censo,
tm.co_entidade,
tm.co_pessoa_fisica,
tm.id_turma,
cd_cor_raca,
tc.ds_cor_raca,
tp_sexo cd_sexo,
case when tm.tp_sexo = 1 then 'Masculino' else 'Feminino' end ds_sexo,
in_transporte_publico fl_transporte,
in_necessidade_especial fl_especial,
tp_etapa_ensino,
in_regular fl_regular,
in_eja fl_eja,
tp_mediacao_didatico_pedago cd_mediacao,
in_profissionalizante fl_profissionalizante,
tp_tipo_local_turma
from censo_esc_ce.tb_matricula_2019 tm 
left join dw_censo.tb_dm_cor_raca tc on tc.cd_cor_raca = tp_cor_raca 
where tp_etapa_ensino is not null
and tp_dependencia in (2,3)
),
turno as (
select
nu_ano_censo,
id_turma,
case when tp_mediacao_didatico_pedago > 1 then 99 else 
case when nu_duracao_turma > 420 then 4 else
case when concat(t.tx_hr_inicial,':',t.tx_mi_inicial)::time < '11:30:00'::time 
       and t.tx_hr_inicial::int<>1 then 1
      when (concat(t.tx_hr_inicial,':',t.tx_mi_inicial)::time > '11:30:00'::time 
         and concat(t.tx_hr_inicial,':',t.tx_mi_inicial)::time < '17:30:00'::time) 
         or t.tx_hr_inicial::int = 1 then 2 
      when concat(t.tx_hr_inicial,':',t.tx_mi_inicial)::time > '17:30:00'::time then 3 
         end end end cd_turno
from  censo_esc_ce.tb_turma_2022 t
)
select 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
id_municipio,
nm_municipio,
cd_dependencia,
ds_dependencia,
cd_categoria_escola_sige,
ds_categoria_escola_sige,
id_escola_inep,
nm_escola,
cd_cor_raca,
ds_cor_raca,
cd_sexo,
ds_sexo,
cd_turno,
case when cd_turno =  1 then 'MANHÃ' 
	 when cd_turno =  2 then 'TARDE' 
	 when cd_turno =  3 then 'NOITE' 
	 when cd_turno =  4 then 'INTEGRAL' 
	 when cd_turno =  99 then 'FLEXÍVEL' else '--' end ds_turno,
count(1) total,
sum(case when cd_etapa = 1 then 1 else 0 end) total_infantil,
sum(case when cd_etapa = 1 and cd_etapa_fase = 1 then 1 else 0 end) creche,
sum(case when cd_etapa = 1 and cd_etapa_fase = 2 then 1 else 0 end) pre_escola,
sum(case when cd_etapa = 2 and fl_regular = 1 then 1 else 0 end) total_fund,
sum(case when fl_regular = 1 and cd_etapa_fase = 3 then 1 else 0 end) fund_ai,
sum(case when fl_regular = 1 and cd_etapa_fase = 4 then 1 else 0 end) fund_af,
sum(case when cd_ano_serie = 1 then 1 else 0 end ) a1_fund,
sum(case when cd_ano_serie = 2 then 1 else 0 end ) a2_fund,
sum(case when cd_ano_serie = 3 then 1 else 0 end ) a3_fund,
sum(case when cd_ano_serie = 4 then 1 else 0 end ) a4_fund,
sum(case when cd_ano_serie = 5 then 1 else 0 end ) a5_fund,
sum(case when cd_ano_serie = 6 then 1 else 0 end ) a6_fund,
sum(case when cd_ano_serie = 7 then 1 else 0 end ) a7_fund,
sum(case when cd_ano_serie = 8 then 1 else 0 end ) a8_fund,
sum(case when cd_ano_serie = 9 then 1 else 0 end ) a9_fund,
sum(case when cd_etapa = 3 and fl_regular = 1 then 1 else 0 end) medio_total_r,
sum(case when cd_ano_serie = 10 then 1 else 0 end) medio_1_serie,
sum(case when cd_ano_serie = 11 then 1 else 0 end) medio_2_serie,
sum(case when cd_ano_serie = 12 then 1 else 0 end) medio_3_serie,
sum(case when cd_ano_serie = 13 then 1 else 0 end) medio_4_serie,
sum(case when cd_ano_serie = 99 and cd_etapa = 3 and fl_regular = 1 then 1 else 0 end) nao_seriadA,
sum(case when fl_eja =1 then 1 else 0 end)  Total_ejas,
sum(case when fl_eja =1 and  cd_mediacao = 1 then 1 else 0 end) total_eja_pres,
sum(case when fl_eja =1 and  cd_mediacao = 1 and cd_etapa = 2 then 1 else 0 end) eja_fund_p,
sum(case when fl_eja =1 and  cd_mediacao = 1 and cd_etapa = 3 then 1 else 0 end) eja_medio_p,
sum(case when fl_eja =1 and fl_profissionalizante = 1 then 1 else 0 end) eja_qualifica,
sum(case when fl_eja =1 and  cd_mediacao in (2,3) then 2 else 0 end)  eja_semi_total,
sum(case when fl_eja =1 and  cd_mediacao in (2,3) and cd_etapa = 2 then 1 else 0 end) eja_semi_funda,
sum(case when fl_eja =1 and  cd_mediacao in (2,3) and cd_etapa = 3  then 1 else 0 end) eja_semi_medio,
sum(case when tp_tipo_local_turma in (2,3) then 1 else 0 end) qtd_aluno_ppl,
sum(fl_especial) qtd_aluno_especial,
sum(fl_transporte) qdt_transporte
from pessoa
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino =  tp_etapa_ensino and  cd_etapa in (1,2,3)
join dw_censo.tb_dm_escola on id_escola_inep = co_entidade and nr_ano_censo = nu_ano_censo
join dw_censo.tb_dm_municipio tdm using(id_municipio)
left join turno using(nu_ano_censo,id_turma)
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17


--1752892