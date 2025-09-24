select 
1 ordem,
tcm.nr_ano_censo,
te.ds_dependencia,
cd_cor_raca,
ds_cor_raca,
cd_sexo,
case when cd_sexo = 1 then 'Masculino' else 'Feminino' end 
ds_sexo,
case when fl_especial = 1 then 'SIM' else 'NÃO' end 
ds_especial,
case when fl_transporte = 1 then 'SIM' else 'NÃO' end 
ds_transporte,
tcm.cd_zona_residencial,
case when tcm.cd_zona_residencial = 1 then 'Urbana' else 'Rural' end ds_zona_residencial,
te.ds_localizacao,
sum(nr_matriculas) nr_total,
sum(	case when dt.fl_regular = 1  then nr_matriculas else 0  end )	nr_regular,
sum(	case when tcm.cd_etapa =  1 then nr_matriculas else 0  end ) nr_infantil,
sum(	case when tcm.cd_etapa =  2 and dt.fl_regular = 1 then nr_matriculas else 0  end ) nr_fundamental_rg,
sum(	case when tcm.cd_etapa =  2 and dt.fl_regular = 1 and tcm.cd_etapa_fase = 3 then nr_matriculas else 0  end ) nr_fund_rg_ai,
sum(	case when tcm.cd_etapa =  2 and dt.fl_regular = 1 and tcm.cd_etapa_fase = 4 then nr_matriculas else 0  end ) nr_fund_rg_af,
sum(	case when tcm.cd_etapa =  3 and dt.fl_regular = 1 then nr_matriculas else 0  end ) nr_medio_rg,
sum(	case when tcm.cd_etapa =  3 and dt.fl_regular = 1 and dt.fl_integral_turma = 0 then nr_matriculas else 0  end ) nr_medio_rg_parcial,
sum(	case when tcm.cd_etapa =  3 and dt.fl_regular = 1 and dt.fl_integral_turma = 0 then nr_matriculas else 0  end ) nr_medio_rg_integral,
sum(	case when tcm.cd_etapa =  3 and dt.fl_regular = 1 and dt.fl_profissionalizante = 0 then nr_matriculas else 0  end ) nr_medio_rg_proped,
sum(	case when tcm.cd_etapa =  3 and dt.fl_regular = 1 and dt.fl_profissionalizante = 1 then nr_matriculas else 0  end ) nr_medio_rg_profiss,
sum(	case when tcm.fl_eja = 1  then nr_matriculas else 0  end ) nr_eja,
sum(	case when tcm.fl_eja = 1  and cd_mediacao = 1 then nr_matriculas else 0  end ) nr_eja_pres,
sum(	case when tcm.fl_eja = 1  and cd_mediacao = 2 then nr_matriculas else 0  end ) nr_eja_semi
from dw_censo.tb_ft_matricula_dinamico tcm
join dw_censo.tb_dm_turma_dinamico dt using (id_dm_turma)
join dw_censo.tb_dm_escola_dinamico te on te.id_dm_escola = dt.id_dm_escola
left join dw_censo.tb_dm_cor_raca using(cd_cor_raca)
where cd_dependencia =2
and tcm.cd_etapa in (1,2,3) --and tcm.f
group by 1,2,3,4,5,6,7,8,9,10,11,12
union 
select 
0 ordem,
tcm.nr_ano_censo,
te.ds_dependencia,
0 cd_cor_raca,
'Total' ds_cor_raca,
0 cd_sexo,
--case when cd_sexo = 1 then 'Masculino' else 'Feminino' end 
'Total'  ds_sexo,
--case when fl_especial = 1 then 'SIM' else 'NÃO' end 
'Total'  ds_especial,
--case when fl_transporte = 1 then 'SIM' else 'NÃO' end 
'Total'  ds_transporte,
0 cd_zona_residencial,
--case when tcm.cd_zona_residencial = 1 then 'Urbana' else 'Rural' end 
'Total' ds_zona_residencial,
'Total' ds_localizacao,
sum(nr_matriculas) nr_total,
sum(	case when dt.fl_regular = 1  then nr_matriculas else 0  end )	nr_regular,
sum(	case when tcm.cd_etapa =  1 then nr_matriculas else 0  end ) nr_infantil,
sum(	case when tcm.cd_etapa =  2 and dt.fl_regular = 1 then nr_matriculas else 0  end ) nr_fundamental_rg,
sum(	case when tcm.cd_etapa =  2 and dt.fl_regular = 1 and tcm.cd_etapa_fase = 3 then nr_matriculas else 0  end ) nr_fund_rg_ai,
sum(	case when tcm.cd_etapa =  2 and dt.fl_regular = 1 and tcm.cd_etapa_fase = 4 then nr_matriculas else 0  end ) nr_fund_rg_af,
sum(	case when tcm.cd_etapa =  3 and dt.fl_regular = 1 then nr_matriculas else 0  end ) nr_medio_rg,
sum(	case when tcm.cd_etapa =  3 and dt.fl_regular = 1 and dt.fl_integral_turma = 0 then nr_matriculas else 0  end ) nr_medio_rg_parcial,
sum(	case when tcm.cd_etapa =  3 and dt.fl_regular = 1 and dt.fl_integral_turma = 0 then nr_matriculas else 0  end ) nr_medio_rg_integral,
sum(	case when tcm.cd_etapa =  3 and dt.fl_regular = 1 and dt.fl_profissionalizante = 0 then nr_matriculas else 0  end ) nr_medio_rg_proped,
sum(	case when tcm.cd_etapa =  3 and dt.fl_regular = 1 and dt.fl_profissionalizante = 1 then nr_matriculas else 0  end ) nr_medio_rg_profiss,
sum(	case when tcm.fl_eja = 1  then nr_matriculas else 0  end ) nr_eja,
sum(	case when tcm.fl_eja = 1  and cd_mediacao = 1 then nr_matriculas else 0  end ) nr_eja_pres,
sum(	case when tcm.fl_eja = 1  and cd_mediacao = 2 then nr_matriculas else 0  end ) nr_eja_semi
from dw_censo.tb_ft_matricula_dinamico tcm
join dw_censo.tb_dm_turma_dinamico dt using (id_dm_turma)
join dw_censo.tb_dm_escola_dinamico te on te.id_dm_escola = dt.id_dm_escola
left join dw_censo.tb_dm_cor_raca using(cd_cor_raca)
where cd_dependencia =2
and tcm.cd_etapa in (1,2,3) --and tcm.f
group by 1,2,3,4,5,6,7,8,9,10,11,12
order by 1,2



