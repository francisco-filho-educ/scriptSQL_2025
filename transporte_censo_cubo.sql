select 
nr_ano_censo,
case when id_crede_sefor <21 then id_crede_sefor else 99 end  id_crede_sefor,
case when id_crede_sefor <21 then nm_crede_sefor else 'SEFOR' end  nm_crede_sefor,
nm_municipio,
cd_localizacao,
ds_localizacao,
sum(nr_transporte) nr_total,
sum(case when fl_integral_turma = 1 then nr_transporte else 0 end) tempo_integral,
sum(case when fl_integral_turma = 0 then nr_transporte else 0 end) tempo_parcial
from dw_censo.tb_cubo_matricula_dinamico 
where 
cd_dependencia = 2 
group by 1,2,3,4,5,6
union 
select 
nr_ano_censo,
case when id_crede_sefor <21 then id_crede_sefor else 99 end  id_crede_sefor,
case when id_crede_sefor <21 then nm_crede_sefor else 'SEFOR' end  nm_crede_sefor,
nm_municipio,
99 cd_localizacao,
'TOTAL' as ds_localizacao,
sum(nr_transporte) nr_total,
sum(case when fl_integral_turma = 1 then nr_transporte else 0 end) tempo_integral,
sum(case when fl_integral_turma = 0 then nr_transporte else 0 end) tempo_parcial
from dw_censo.tb_cubo_matricula_dinamico 
where 
cd_dependencia = 2
and cd_etapa in (1,2,3)
group by 1,2,3,4,5
order by 2,4,5

--CREDE_SEFOR
select 
nr_ano_censo,
case when id_crede_sefor <21 then id_crede_sefor else 99 end  id_crede_sefor,
case when id_crede_sefor <21 then nm_crede_sefor else 'SEFOR' end  nm_crede_sefor,
cd_localizacao,
ds_localizacao,
sum(nr_transporte) nr_total,
sum(case when fl_integral_turma = 1 then nr_transporte else 0 end) tempo_integral,
sum(case when fl_integral_turma = 0 then nr_transporte else 0 end) tempo_parcial
from dw_censo.tb_cubo_matricula_dinamico 
where 
cd_dependencia = 2 
group by 1,2,3,4,5
union 
select 
nr_ano_censo,
case when id_crede_sefor <21 then id_crede_sefor else 99 end  id_crede_sefor,
case when id_crede_sefor <21 then nm_crede_sefor else 'SEFOR' end  nm_crede_sefor,
99 cd_localizacao,
'TOTAL' as ds_localizacao,
sum(nr_transporte) nr_total,
sum(case when fl_integral_turma = 1 then nr_transporte else 0 end) tempo_integral,
sum(case when fl_integral_turma = 0 then nr_transporte else 0 end) tempo_parcial
from dw_censo.tb_cubo_matricula_dinamico 
where 
cd_dependencia = 2
and cd_etapa in (1,2,3)
group by 1,2,3,4,5
order by 2,4

select 
nr_ano_censo,
cd_localizacao,
ds_localizacao,
sum(nr_transporte) nr_total,
sum(case when fl_integral_turma = 1 then nr_transporte else 0 end) tempo_integral,
sum(case when fl_integral_turma = 0 then nr_transporte else 0 end) tempo_parcial
from dw_censo.tb_cubo_matricula_dinamico 
where 
cd_dependencia = 2 
group by 1,2,3
union 
select 
nr_ano_censo,
99 cd_localizacao,
'TOTAL' as ds_localizacao,
sum(nr_transporte) nr_total,
sum(case when fl_integral_turma = 1 then nr_transporte else 0 end) tempo_integral,
sum(case when fl_integral_turma = 0 then nr_transporte else 0 end) tempo_parcial
from dw_censo.tb_cubo_matricula_dinamico 
where 
cd_dependencia = 2
and cd_etapa in (1,2,3)
group by 1,2,3
order by 2

