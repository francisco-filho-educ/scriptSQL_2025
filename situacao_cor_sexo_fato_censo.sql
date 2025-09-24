with sit as (
select 
nr_ano_censo,
cd_etapa,
ds_etapa,
cd_cor_raca,
sum(nr_matricula_situacao) nr_matricula_situacao,
sum(nr_aprovados) nr_aprovados,
sum(nr_abandono) nr_abandono,
sum(nr_reprovados) nr_reprovados,
--matricula
sum(case when cd_sexo = 1 then nr_matricula_situacao else 0 end) nr_matricula_m,
sum(case when cd_sexo = 2 then nr_matricula_situacao else 0 end) nr_matricula_f,
--aprovado
sum(case when cd_sexo = 1 then nr_aprovados else 0 end) nr_aprovados_m,
sum(case when cd_sexo = 2 then nr_aprovados else 0 end) nr_aprovados_f,
--nr_reprovados,
sum(case when cd_sexo = 1 then nr_reprovados else 0 end) nr_reprovados_m,
sum(case when cd_sexo = 2 then nr_reprovados else 0 end) nr_reprovados_f,
--nr_abandono 
sum(case when cd_sexo = 1 then nr_abandono else 0 end) nr_abandono_m,
sum(case when cd_sexo = 2 then nr_abandono else 0 end) nr_abandono_f
from dw_censo.tb_ft_situacao tfs 
join dw_censo.tb_dm_escola tde using(id_dm_escola,nr_ano_censo)
join dw_censo.tb_dm_etapa tde2 using(cd_etapa_ensino,cd_etapa)
where nr_ano_censo = 2022
and fl_regular = 1
and tde.cd_dependencia = 2
and tfs.cd_etapa in (2,3)
group by 1,2,3,4
)/*
select 
nr_ano_censo,
ds_etapa,
'TOTAL' ds_cor_raca,
sum(nr_aprovados) nr_aprovados,
case when sum(nr_matricula_situacao) <1 then 0.0 else  sum(nr_aprovados::numeric) / sum(nr_matricula_situacao::numeric) end tx_aprovacao,
sum(nr_reprovados)nr_reprovados,
case when sum(nr_matricula_situacao) <1 then 0.0 else  sum(nr_reprovados::numeric) / sum(nr_matricula_situacao::numeric)end  tx_reprovacao,
sum(nr_abandono) nr_abandono,
case when sum(nr_matricula_situacao) <1 then 0.0 else  sum(nr_abandono::numeric) / sum(nr_matricula_situacao::numeric)  end  tx_abandono,
--masculino
sum(nr_aprovados_m) nr_aprovados_m,
case when sum(nr_matricula_m) <1 then 0.0 else  sum(nr_aprovados_m::numeric) / sum(nr_matricula_m::numeric) end tx_aprovacao_m,
sum(nr_reprovados_m)nr_reprovados_m,
case when sum(nr_matricula_m) <1 then 0.0 else  sum(nr_reprovados_m::numeric) / sum(nr_matricula_m::numeric)end  tx_reprovacao_m,
sum(nr_abandono_m) nr_abandono_m,
case when sum(nr_matricula_m) <1 then 0.0 else  sum(nr_abandono_m::numeric) / sum(nr_matricula_m::numeric)  end  tx_abandono_m,
--feminino
sum(nr_aprovados_f) nr_aprovados_f,
case when sum(nr_matricula_f) <1 then 0.0 else  sum(nr_aprovados_f::numeric) / sum(nr_matricula_f::numeric) end tx_aprovacao_f,
sum(nr_reprovados_f)nr_reprovados_f,
case when sum(nr_matricula_f) <1 then 0.0 else  sum(nr_reprovados_f::numeric) / sum(nr_matricula_f::numeric)end  tx_reprovacao_f,
sum(nr_abandono_f) nr_abandono_f,
case when sum(nr_matricula_f) <1 then 0.0 else  sum(nr_abandono_f::numeric) / sum(nr_matricula_f::numeric)  end  tx_abandono_f
from sit tfs 
join dw_censo.tb_dm_cor_raca tdcr using(cd_cor_raca)
where cd_etapa = 3
group by 1,2,3
union 
select 
nr_ano_censo,
ds_etapa,
ds_cor_raca,
sum(nr_aprovados) nr_aprovados,
case when sum(nr_matricula_situacao) <1 then 0.0 else  sum(nr_aprovados::numeric) / sum(nr_matricula_situacao::numeric) end tx_aprovacao,
sum(nr_reprovados)nr_reprovados,
case when sum(nr_matricula_situacao) <1 then 0.0 else  sum(nr_reprovados::numeric) / sum(nr_matricula_situacao::numeric)end  tx_reprovacao,
sum(nr_abandono) nr_abandono,
case when sum(nr_matricula_situacao) <1 then 0.0 else  sum(nr_abandono::numeric) / sum(nr_matricula_situacao::numeric)  end  tx_abandono,
--masculino
sum(nr_aprovados_m) nr_aprovados_m,
case when sum(nr_matricula_m) <1 then 0.0 else  sum(nr_aprovados_m::numeric) / sum(nr_matricula_m::numeric) end tx_aprovacao_m,
sum(nr_reprovados_m)nr_reprovados_m,
case when sum(nr_matricula_m) <1 then 0.0 else  sum(nr_reprovados_m::numeric) / sum(nr_matricula_m::numeric)end  tx_reprovacao_m,
sum(nr_abandono_m) nr_abandono_m,
case when sum(nr_matricula_m) <1 then 0.0 else  sum(nr_abandono_m::numeric) / sum(nr_matricula_m::numeric)  end  tx_abandono_m,
--feminino
sum(nr_aprovados_f) nr_aprovados_f,
case when sum(nr_matricula_f) <1 then 0.0 else  sum(nr_aprovados_f::numeric) / sum(nr_matricula_f::numeric) end tx_aprovacao_f,
sum(nr_reprovados_f)nr_reprovados_f,
case when sum(nr_matricula_f) <1 then 0.0 else  sum(nr_reprovados_f::numeric) / sum(nr_matricula_f::numeric)end  tx_reprovacao_f,
sum(nr_abandono_f) nr_abandono_f,
case when sum(nr_matricula_f) <1 then 0.0 else  sum(nr_abandono_f::numeric) / sum(nr_matricula_f::numeric)  end  tx_abandono_f
from sit tfs 
join dw_censo.tb_dm_cor_raca tdcr using(cd_cor_raca)
where cd_etapa = 3
group by 1,2,3
order by 3
*/
--------------------------
select 
nr_ano_censo,
'TOTAL' ds_etapa,
ds_cor_raca,
sum(nr_aprovados) nr_aprovados,
case when sum(nr_matricula_situacao) <1 then 0.0 else  sum(nr_aprovados::numeric) / sum(nr_matricula_situacao::numeric) end tx_aprovacao,
sum(nr_reprovados)nr_reprovados,
case when sum(nr_matricula_situacao) <1 then 0.0 else  sum(nr_reprovados::numeric) / sum(nr_matricula_situacao::numeric)end  tx_reprovacao,
sum(nr_abandono) nr_abandono,
case when sum(nr_matricula_situacao) <1 then 0.0 else  sum(nr_abandono::numeric) / sum(nr_matricula_situacao::numeric)  end  tx_abandono,
--masculino
sum(nr_aprovados_m) nr_aprovados_m,
case when sum(nr_matricula_m) <1 then 0.0 else  sum(nr_aprovados_m::numeric) / sum(nr_matricula_m::numeric) end tx_aprovacao_m,
sum(nr_reprovados_m)nr_reprovados_m,
case when sum(nr_matricula_m) <1 then 0.0 else  sum(nr_reprovados_m::numeric) / sum(nr_matricula_m::numeric)end  tx_reprovacao_m,
sum(nr_abandono_m) nr_abandono_m,
case when sum(nr_matricula_m) <1 then 0.0 else  sum(nr_abandono_m::numeric) / sum(nr_matricula_m::numeric)  end  tx_abandono_m,
--feminino
sum(nr_aprovados_f) nr_aprovados_f,
case when sum(nr_matricula_f) <1 then 0.0 else  sum(nr_aprovados_f::numeric) / sum(nr_matricula_f::numeric) end tx_aprovacao_f,
sum(nr_reprovados_f)nr_reprovados_f,
case when sum(nr_matricula_f) <1 then 0.0 else  sum(nr_reprovados_f::numeric) / sum(nr_matricula_f::numeric)end  tx_reprovacao_f,
sum(nr_abandono_f) nr_abandono_f,
case when sum(nr_matricula_f) <1 then 0.0 else  sum(nr_abandono_f::numeric) / sum(nr_matricula_f::numeric)  end  tx_abandono_f
from sit tfs 
join dw_censo.tb_dm_cor_raca tdcr using(cd_cor_raca)
where cd_etapa in (2,3)
group by 1,2,3
union 
select 
nr_ano_censo,
'TOTAL' ds_etapa,
'TOTAL' ds_cor_raca,
sum(nr_aprovados) nr_aprovados,
case when sum(nr_matricula_situacao) <1 then 0.0 else  sum(nr_aprovados::numeric) / sum(nr_matricula_situacao::numeric) end tx_aprovacao,
sum(nr_reprovados)nr_reprovados,
case when sum(nr_matricula_situacao) <1 then 0.0 else  sum(nr_reprovados::numeric) / sum(nr_matricula_situacao::numeric)end  tx_reprovacao,
sum(nr_abandono) nr_abandono,
case when sum(nr_matricula_situacao) <1 then 0.0 else  sum(nr_abandono::numeric) / sum(nr_matricula_situacao::numeric)  end  tx_abandono,
--masculino
sum(nr_aprovados_m) nr_aprovados_m,
case when sum(nr_matricula_m) <1 then 0.0 else  sum(nr_aprovados_m::numeric) / sum(nr_matricula_m::numeric) end tx_aprovacao_m,
sum(nr_reprovados_m)nr_reprovados_m,
case when sum(nr_matricula_m) <1 then 0.0 else  sum(nr_reprovados_m::numeric) / sum(nr_matricula_m::numeric)end  tx_reprovacao_m,
sum(nr_abandono_m) nr_abandono_m,
case when sum(nr_matricula_m) <1 then 0.0 else  sum(nr_abandono_m::numeric) / sum(nr_matricula_m::numeric)  end  tx_abandono_m,
--feminino
sum(nr_aprovados_f) nr_aprovados_f,
case when sum(nr_matricula_f) <1 then 0.0 else  sum(nr_aprovados_f::numeric) / sum(nr_matricula_f::numeric) end tx_aprovacao_f,
sum(nr_reprovados_f)nr_reprovados_f,
case when sum(nr_matricula_f) <1 then 0.0 else  sum(nr_reprovados_f::numeric) / sum(nr_matricula_f::numeric)end  tx_reprovacao_f,
sum(nr_abandono_f) nr_abandono_f,
case when sum(nr_matricula_f) <1 then 0.0 else  sum(nr_abandono_f::numeric) / sum(nr_matricula_f::numeric)  end  tx_abandono_f
from sit tfs 
join dw_censo.tb_dm_cor_raca tdcr using(cd_cor_raca)
where cd_etapa in (2,3)
group by 1,2,3
order by 3



