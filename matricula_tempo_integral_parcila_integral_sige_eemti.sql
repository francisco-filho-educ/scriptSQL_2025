with turma as (
select
tt.nr_anoletivo,
ci_turma cd_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_turno,
ds_turno,
cd_unidade_trabalho,
tut.nr_codigo_unid_trab
from academico.tb_turma tt 
join academico.tb_turno t on ci_turno = cd_turno
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho
where
nr_anoletivo = 2024
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27 
and tut.cd_dependencia_administrativa = 2 and cd_categoria = 9
and  cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) 
) --
--select --count(distinct tt.cd_unidade_trabalho)  
--cd_turno,
--ds_turno, count(1) from turma join academico.tb_etapa te on ci_etapa = cd_etapa group by 1,2
,ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turma t 
        on t.cd_turma=e.cd_turma 
  where e.nr_anoletivo=2024 --- ANO LETIVO
        and dt_enturmacao::date<='2024-12-30'  -- DATA DA ENTURMAÇAO > DATA DA DESENTURMAÇAO OU ESTA DEVE SER NULA
        and (dt_desenturmacao::date>'2024-12-30' or dt_desenturmacao is null)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,cd_turma
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join academico.tb_turma t 
  	on cd_turma=ci_turma 
  	--and cd_nivel=27  -- SEELECIONA A ETAPA DE ENSINO
  	--and (cd_etapa in (164,186,190,214) or cd_anofinaleja=2) ---- SELECIONA AS SÉRIES
)
,mat as (
select * from turma 
		 join ult_ent using(cd_turma)
)
select -- count(distinct cd_unidade_trabalho) 
/*
id_crede_sefor,
nm_crede_sefor,
id_municipio,
nm_municipio,
id_escola_inep,
nm_escola,*/
--1 serie
sum(case when cd_turno in (5,8,9,10) and cd_etapa in(162,184,188) then 1 else 0 end) nr_integral_1,
sum(case when cd_turno in (1,2,4)    and cd_etapa in(162,184,188) then 1 else 0 end ) nr_parcial_1,	
--2 serie
sum(case when cd_turno in (5,8,9,10) and cd_etapa in(163,185,189) then 1 else 0 end) nr_integral_2,
sum(case when cd_turno in (1,2,4)    and cd_etapa in(163,185,189) then 1 else 0 end ) nr_parcial_2,	
--3 serie
sum(case when cd_turno in (5,8,9,10) and cd_etapa in(164,186,190)  then 1 else 0 end) nr_integral_3,
sum(case when cd_turno in (1,2,4)    and cd_etapa in(164,186,190)  then 1 else 0 end ) nr_parcial_3,
--sum(case when cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191)   then 1 else 0 end ) nr_total_regular,
--sum(case when cd_etapa in (213,214,195,194,175,196,174,173,176) then 1 else 0 end ) nr_eja,
count(1) nr_total
/*
e.*,
sum(case when cd_turno in (5,8,9,10) then 1 else 0 end) nr_integral,
sum(case when cd_turno in (1,2,4) then 1 else 0 end ) nr_parcial,	
count(1) nr_total
FROM tmp.tb_eemti e
*/
from dw_sige.tb_dm_escola tde 
join mat on mat.nr_codigo_unid_trab::int = id_escola_inep::int 
---where tde.ds_categoria ilike 'TEMPO INTEGRAL'
group by 1,2,3,4,5,6
order by 2,4,6