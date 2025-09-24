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
)
select 
case when ta.fl_bolsaescola = 'S' then 0 else 1 end fl_bolas,
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
inner join academico.tb_aluno ta on ci_aluno = cd_aluno
group by 1

---------------------------- relatorios por sefor e bairros ---------------------------------------------------------
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
inner join public.tb_dm_escola tde using(id_escola_sige) and id_crede_sefor >20
inner join academico.tb_aluno ta on ci_aluno = cd_aluno 
group by 1,2 
order by 1
*/ 
--- BAIRROS DE FORTALEZA -------------------------------------------------------------------------------------------------------------------------
select
2023 nr_anoletivo,
--tut.nm_unidade_trabalho,
upper(tmc.nm_municipio) AS nm_municipio,
--tlf.nm_bairro,
upper(case when  nm_bairro ilike 'barra do c%' then 'BARRA DO CEARA' 
     when  nm_bairro ilike 'CONJ%CEA%' then 'CONJUNTO CEARA'
     when  nm_bairro ilike 'J_QUEI CLUBE' then 'JOQUEI CLUBE'
     else nm_bairro end) nm_bairro,
case when ta.fl_bolsaescola = 'S' then 'COM CADUNICO' else 'SEM CADUNICO' end fl_bolsa,
sum(case when tut.cd_categoria = 9 and cd_turno not in (9,8,5) then 1 else 0 end) emti_p,
sum(case when tut.cd_categoria = 9 and cd_turno in (9,8,5) then 1 else 0 end) emti_i,
--EEM
sum(case when tut.cd_categoria = 5 then 1 else 0 end) reg,
--EEEP
sum(case when tut.cd_categoria = 8 then 1 else 0 end) eeep,
--EFA
sum(case when tut.cd_categoria = 10 then 1 else 0 end) efa,
--INDÍGENA
sum(case when tut.cd_categoria = 7 then 1 else 0 end) ind, 
--MILITAR
sum(case when tut.cd_categoria = 11 then 1 else 0 end) mil, 
--QUILOMBOLA
sum(case when tut.cd_categoria = 13 then 1 else 0 end) qil, 
--INSTITUTO
sum(case when tut.cd_categoria = 14 then 1 else 0 end) inst, 
--DO CAMPO
sum(case when tut.cd_categoria = 12 then 1 else 0 end) cmp,
COUNT(1) TOTAL
from alunos_m a 
join rede_fisica.tb_unidade_trabalho tut on a.id_escola_sige  = tut.ci_unidade_trabalho 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo and tlf.cd_municipio_censo = 2304400
inner join academico.tb_aluno ta on ci_aluno = a.cd_aluno 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = true-- and nm_bairro = 'CONJUNO CEARA'
group by 1,2,3,4
order by 3