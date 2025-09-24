with integral as (
select 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
ds_ano_serie,
cd_ano_serie,
count(distinct id_turma) nr_turmas,
sum(nr_matriculas) nr_matriculas,
'SIM' ds_integral
from dw_censo.tb_cubo_matricula_dinamico tcmd 
where cd_ano_serie in (6,7,8)
and fl_integral_turma = 1
group by 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
ds_ano_serie,
cd_ano_serie,
ds_integral
),
nao_integral as (
select 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
ds_ano_serie,
cd_ano_serie,
count(distinct id_turma) nr_turmas,
sum(nr_matriculas) nr_matriculas,
'SIM' ds_integral
from dw_censo.tb_cubo_matricula_dinamico ni 
where cd_ano_serie in (6,7,8)
and not exists (select 1 from integral i where i.id_escola_inep = ni.id_escola_inep )
group by 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
ds_ano_serie,
cd_ano_serie,
ds_integral
)
select * from integral  
union 
select * from nao_integral 
order by 2,4,8


----------
select 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
ds_dependencia,
tde.ds_ano_serie,
id_turma,
case when fl_integral_turma = 1 then 'SIM' else 'NÃO' end ds_integral,
sum(nr_matriculas) nr_matriculas
from dw_censo.tb_cubo_matricula_dinamico tc 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tc.cd_etapa_ensino_turma 
where 
tde.cd_ano_serie between 1 and 9
and cd_dependencia in (2,3)
group by 1,2,3,4,5,6,7,8,9,10