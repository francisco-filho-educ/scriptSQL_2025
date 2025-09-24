with alunos_m as (
select 
a.id_escola_sige,
cd_turno,
ds_turno,
case when cd_aluno_excluido is null then a.cd_aluno else taam.cd_aluno end cd_aluno
from public.tb_dm_etapa_aluno_2023_06_01 a
left join academico.tb_auditoria_aluno_mesclar taam on taam.cd_aluno_excluido  = a.cd_aluno 
where cd_etapa_aluno = 3
and a.cd_ano_serie between 10 and 13
group by 1,2,3,4
)/*
select 
nm_crede_sefor,
case when ta.fl_bolsaescola = 'S' then 'COM CADUNICO' else 'SEM CADUNICO' end fl_bolsa,
sum(case when tde.cd_categoria = 9 and cd_turno not in (9,8,5) then 1 else 0 end) emti_p,
sum(case when tde.cd_categoria = 9 and cd_turno in (9,8,5) then 1 else 0 end) emti_i,
--EEM
sum(case when tde.cd_categoria = 5 then 1 else 0 end) reg,
--EEEP
sum(case when tde.cd_categoria = 8 then 1 else 0 end) eeep,
--EFA
sum(case when tde.cd_categoria = 10 then 1 else 0 end) efa,
--INDÍGENA
sum(case when tde.cd_categoria = 7 then 1 else 0 end) ind, 
--MILITAR
sum(case when tde.cd_categoria = 11 then 1 else 0 end) mil, 
--QUILOMBOLA
sum(case when tde.cd_categoria = 13 then 1 else 0 end) qil, 
--INSTITUTO
sum(case when tde.cd_categoria = 14 then 1 else 0 end) inst, 
--DO CAMPO
sum(case when tde.cd_categoria = 12 then 1 else 0 end) cmp  
from alunos_m 
inner join public.tb_dm_escola tde using(id_escola_sige)
inner join academico.tb_aluno ta on ci_aluno = cd_aluno and id_crede_sefor >20
group by 1,2 
union 
select 
'TOTAL SEFOR' nm_crede_sefor,
case when ta.fl_bolsaescola = 'S' then 'COM CADUNICO' else 'SEM CADUNICO' end fl_bolsa,
sum(case when tde.cd_categoria = 9 and cd_turno not in (9,8,5) then 1 else 0 end) emti_p,
sum(case when tde.cd_categoria = 9 and cd_turno in (9,8,5) then 1 else 0 end) emti_i,
--EEM
sum(case when tde.cd_categoria = 5 then 1 else 0 end) reg,
--EEEP
sum(case when tde.cd_categoria = 8 then 1 else 0 end) eeep,
--EFA
sum(case when tde.cd_categoria = 10 then 1 else 0 end) efa,
--INDÍGENA
sum(case when tde.cd_categoria = 7 then 1 else 0 end) ind, 
--MILITAR
sum(case when tde.cd_categoria = 11 then 1 else 0 end) mil, 
--QUILOMBOLA
sum(case when tde.cd_categoria = 13 then 1 else 0 end) qil, 
--INSTITUTO
sum(case when tde.cd_categoria = 14 then 1 else 0 end) inst, 
--DO CAMPO
sum(case when tde.cd_categoria = 12 then 1 else 0 end) cmp  
from alunos_m 
inner join public.tb_dm_escola tde using(id_escola_sige)
inner join academico.tb_aluno ta on ci_aluno = cd_aluno and id_crede_sefor >20
group by 1,2 
order by 1
*/ 
--- BAIRROS DE FORTALEZA -------------------------------------------------------------------------------------------------------------------------





