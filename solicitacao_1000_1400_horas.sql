with turma as (
select
cd_unidade_trabalho,
case when ((dt_horafim::time - dt_horainicio::time) * 200)::interval = '1000:00:00'::interval  then 1 else 0 end  fl_1000h,
case when ((dt_horafim::time - dt_horainicio::time) * 200)::interval >= '1400:00:00'::interval  then 1 else 0 end  fl_1400h
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2021 
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
--and tt.cd_etapa not in (173,172,174)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
and tt.cd_modalidade <> 38
group by 1,2,3
) ,nao__1000 as (
select distinct cd_unidade_trabalho from turma where fl_1000h = 0
), sim_1000 as (
select 
cd_unidade_trabalho,  
1 fl_sim
from turma t where fl_1000h = 1
 and  not exists (select 1 from nao__1000 n where t.cd_unidade_trabalho = n.cd_unidade_trabalho)
 group by 1,2
) ,nao__1400 as (
select distinct cd_unidade_trabalho from turma where fl_1400h = 0
), sim_1400 as (
select 
cd_unidade_trabalho,  
1 fl_sim
from turma t where fl_1400h = 1
 and  not exists (select 1 from nao__1400 n where t.cd_unidade_trabalho = n.cd_unidade_trabalho)
 group by 1,2
)/*
select  
sum ( fl_sim)::numeric / count(distinct cd_unidade_trabalho) p_sim
from turma t
left join sim_1000 using(cd_unidade_trabalho) -- 0.02439024390243902439
*/
select  
sum ( fl_sim)::numeric / count(distinct cd_unidade_trabalho) p_sim
from turma t
left join sim_1400 using(cd_unidade_trabalho) --0.31563845050215208034


