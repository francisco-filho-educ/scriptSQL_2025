select 
tfm.nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
ds_categoria_escola_sige,
tde.id_escola_inep,
tde.nm_escola,
sum(nr_matriculas) total,
sum(case when tdt.fl_regular = 1 and et.cd_etapa = 2 then nr_matriculas else 0 end ) nr_fund,
sum(case when tdt.fl_regular = 1 and et.cd_etapa_fase = 3 then nr_matriculas else 0   end ) nr_ai,
sum(case when tdt.fl_regular = 1 and et.cd_etapa_fase = 4 then nr_matriculas else 0   end ) nr_af,
sum(case when tdt.fl_regular = 1 and et.cd_etapa = 3 then nr_matriculas else 0    end ) nr_medio,
sum(case when et.cd_ano_serie  = 10 then nr_matriculas else 0 end) nr_1_serie,
sum(case when et.cd_ano_serie  = 11 then nr_matriculas else 0 end) nr_2_serie,
sum(case when et.cd_ano_serie  = 12 then nr_matriculas else 0 end) nr_3_serie,
sum(case when et.cd_ano_serie  = 13 then nr_matriculas else 0 end) nr_4_serie,
sum(case when fl_eja = 1 then nr_matriculas end) nr_eja,
sum(case when et.cd_etapa = 4 then nr_matriculas else 0    end ) concSb
--select distinct et.ds_etapa_ensino, et.cd_etapa_ensino 
from dw_censo.tb_ft_matricula tfm 
join dw_censo.tb_dm_turma tdt using(id_dm_turma)
join dw_censo.tb_dm_escola tde using(id_dm_escola)
join dw_censo.tb_dm_etapa et on et.cd_etapa_ensino = tfm.cd_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tde.id_municipio 
where 
tfm.nr_ano_censo >2014
and tde.cd_dependencia  =2
group by 1,2,3,4,5,6,7

---------
select 
2021 nr_ano_censo,
nm_municipio,
tde.co_entidade id_escola_inep,
tde.no_entidade nm_escola,
count(1) total,
sum(case when tde.in_regular = 1 and et.cd_etapa = 2 then 1 else 0 end ) nr_fund,
sum(case when tde.in_regular = 1 and et.cd_etapa_fase = 3 then 1 else 0   end ) nr_ai,
sum(case when tde.in_regular = 1 and et.cd_etapa_fase = 4 then 1 else 0   end ) nr_af,
sum(case when tde.in_regular = 1 and et.cd_etapa = 3 then 1 else 0    end ) nr_medio,
sum(case when et.cd_ano_serie  = 10 then 1 else 0 end) nr_1_serie,
sum(case when et.cd_ano_serie  = 11 then 1 else 0 end) nr_2_serie,
sum(case when et.cd_ano_serie  = 12 then 1 else 0 end) nr_3_serie,
sum(case when et.cd_ano_serie  = 13 then 1 else 0 end) nr_4_serie,
sum(case when tde.in_eja = 1 then 1 else 0 end) nr_eja,
sum(case when et.cd_etapa = 4 then 1 else 0    end ) concSb
--select distinct et.ds_etapa_ensino, et.cd_etapa_ensino 
from censo_esc_d.tb_matricula tfm 
join censo_esc_d.tb_escola tde using(co_entidade)
join dw_censo.tb_dm_etapa et on et.cd_etapa_ensino = tfm.tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tde.co_municipio 
where 
tfm.nu_ano_censo = 2021
and tde.tp_dependencia = 2
group by 1,2,3,4

