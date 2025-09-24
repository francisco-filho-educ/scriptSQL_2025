
select 
m.nr_ano_censo,
e.id_crede_sefor,
e.nm_crede_sefor,
nm_municipio,
e.id_escola_inep,
e.nm_escola,
e.ds_dependencia,
t.id_turma,
t.ds_etapa_ensino,
case when fl_integral_turma = 1 then 'SIM'  else 'NÃO' end ds_integral,
sum(nr_matriculas) nr_matriculas 
from dw_censo.tb_ft_matricula_dinamico m
join dw_censo.tb_dm_turma_dinamico t using(id_dm_turma)
join dw_censo.tb_dm_escola_dinamico e on e.id_dm_escola = m.id_dm_escola 
join dw_censo.tb_dm_municipio mun using(id_municipio)
where 
t.cd_etapa = 2 
and t.fl_regular = 1
and e.cd_dependencia in (2,3)
group by 1,2,3,4,5,6,7,8,9,10
