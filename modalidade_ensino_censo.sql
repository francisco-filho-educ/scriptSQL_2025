/*
select 
nu_ano_censo,
id_crede_sefor,
nm_crede_sefor,
tde.nm_municipio,
id_escola_inep,
nm_escola,
tde.ds_categoria,
sum(case when in_regular =  1 and (cd_ano_serie between 1 and 12) and nu_duracao_turma < 420 and in_educacao_indigena <> 1  then 1 else 0 end) qtd_regular,
sum(case when in_regular =  1 and (cd_ano_serie between 10 and 12) and nu_duracao_turma >= 420  and in_profissionalizante <> 1  and in_educacao_indigena <> 1  then 1 else 0 end) qtd_integral,
sum(case when in_regular =  1 and (cd_ano_serie between 10 and 12) and nu_duracao_turma >= 420  and in_profissionalizante = 1  and in_educacao_indigena <> 1  then 1 else 0  end) qtd_profis,
sum(case when in_educacao_indigena = 1 then 1 else 0  end) qtd_indigena,
sum(case when in_eja = 1 and in_educacao_indigena <> 1 then 1 else 0  end) eja
from censo_esc_d.tb_matricula_2023 tm 
join dw_sige.tb_dm_escola tde on tde.id_escola_inep::int = co_entidade 
join dw_censo.tb_dm_etapa te on te.cd_etapa_ensino = tm.tp_etapa_ensino 
where 
tm.tp_dependencia = 2 
and te.cd_etapa in (1,2,3)
group by 1,2,3,4,5,6,7
*/
select 
nu_ano_censo,
tde.nm_municipio,
ds_categoria,
sum(case when in_regular =  1 and (cd_ano_serie between 1 and 12) and nu_duracao_turma < 420 and in_educacao_indigena <> 1  then 1 else 0 end) qtd_regular,
sum(case when in_regular =  1 and (cd_ano_serie between 10 and 12) and nu_duracao_turma >= 420  and in_profissionalizante <> 1  and in_educacao_indigena <> 1  then 1 else 0 end) qtd_integral,
sum(case when in_regular =  1 and (cd_ano_serie between 10 and 12) and nu_duracao_turma >= 420  and in_profissionalizante = 1  and in_educacao_indigena <> 1  then 1 else 0  end) qtd_profis,
sum(case when in_educacao_indigena = 1 then 1 else 0  end) qtd_indigena,
sum(case when in_eja = 1 and in_educacao_indigena <> 1 then 1 else 0  end) eja
from censo_esc_d.tb_matricula_2023 tm 
join dw_sige.tb_dm_escola tde on tde.id_escola_inep::int = co_entidade 
join dw_censo.tb_dm_etapa te on te.cd_etapa_ensino = tm.tp_etapa_ensino 
where 
tm.tp_dependencia = 2 
and te.cd_etapa in (1,2,3)
group by 1,2,3
union 
select 
nu_ano_censo,
tde.nm_municipio,
'TOTAL' ds_categoria,
sum(case when in_regular =  1 and (cd_ano_serie between 1 and 12) and nu_duracao_turma < 420 and in_educacao_indigena <> 1  then 1 else 0 end) qtd_regular,
sum(case when in_regular =  1 and (cd_ano_serie between 10 and 12) and nu_duracao_turma >= 420  and in_profissionalizante <> 1  and in_educacao_indigena <> 1  then 1 else 0 end) qtd_integral,
sum(case when in_regular =  1 and (cd_ano_serie between 10 and 12) and nu_duracao_turma >= 420  and in_profissionalizante = 1  and in_educacao_indigena <> 1  then 1 else 0  end) qtd_profis,
sum(case when in_educacao_indigena = 1 then 1 else 0  end) qtd_indigena,
sum(case when in_eja = 1 and in_educacao_indigena <> 1 then 1 else 0  end) eja
from censo_esc_d.tb_matricula_2023 tm 
join dw_sige.tb_dm_escola tde on tde.id_escola_inep::int = co_entidade 
join dw_censo.tb_dm_etapa te on te.cd_etapa_ensino = tm.tp_etapa_ensino 
where 
tm.tp_dependencia = 2 
and te.cd_etapa in (1,2,3)
group by 1,2,3


select 
nu_ano_censo,
tde.id_crede_sefor,
tde.nm_crede_sefor,
tde.ds_categoria,
sum(case when in_regular =  1 and (cd_ano_serie between 1 and 12) and nu_duracao_turma < 420 and in_educacao_indigena <> 1  then 1 else 0 end) qtd_regular,
sum(case when in_regular =  1 and (cd_ano_serie between 10 and 12) and nu_duracao_turma >= 420  and in_profissionalizante <> 1  and in_educacao_indigena <> 1  then 1 else 0 end) qtd_integral,
sum(case when in_regular =  1 and (cd_ano_serie between 10 and 12) and nu_duracao_turma >= 420  and in_profissionalizante = 1  and in_educacao_indigena <> 1  then 1 else 0  end) qtd_profis,
sum(case when in_educacao_indigena = 1 then 1 else 0  end) qtd_indigena,
sum(case when in_eja = 1 and in_educacao_indigena <> 1 then 1 else 0  end) eja
from censo_esc_d.tb_matricula_2023 tm 
join dw_sige.tb_dm_escola tde on tde.id_escola_inep::int = co_entidade 
join dw_censo.tb_dm_etapa te on te.cd_etapa_ensino = tm.tp_etapa_ensino 
where 
tm.tp_dependencia = 2 
and te.cd_etapa in (1,2,3)
group by 1,2,3,4
union 
select 
nu_ano_censo,
id_crede_sefor,
tde.nm_crede_sefor,
'TOTAL'  ds_categoria,
sum(case when in_regular =  1 and (cd_ano_serie between 1 and 12) and nu_duracao_turma < 420 and in_educacao_indigena <> 1  then 1 else 0 end) qtd_regular,
sum(case when in_regular =  1 and (cd_ano_serie between 10 and 12) and nu_duracao_turma >= 420  and in_profissionalizante <> 1  and in_educacao_indigena <> 1  then 1 else 0 end) qtd_integral,
sum(case when in_regular =  1 and (cd_ano_serie between 10 and 12) and nu_duracao_turma >= 420  and in_profissionalizante = 1  and in_educacao_indigena <> 1  then 1 else 0  end) qtd_profis,
sum(case when in_educacao_indigena = 1 then 1 else 0  end) qtd_indigena,
sum(case when in_eja = 1 and in_educacao_indigena <> 1 then 1 else 0  end) eja
from censo_esc_d.tb_matricula_2023 tm 
join dw_sige.tb_dm_escola tde on tde.id_escola_inep::int = co_entidade 
join dw_censo.tb_dm_etapa te on te.cd_etapa_ensino = tm.tp_etapa_ensino 
where 
tm.tp_dependencia = 2 
and te.cd_etapa in (1,2,3)
group by 1,2,3,4
