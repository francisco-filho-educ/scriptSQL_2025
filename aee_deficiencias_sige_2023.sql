with altas as (
select 
cd_aluno, 1 fl_Altas_habilidades_Superdotacao
from academico.tb_aluno_deficiencia tad 
where tad.cd_deficiencia = 13
group by 1,2
),
aluno_aee as (
select
cd_aluno , 
1 fl_aee
from public.tb_dm_turmas_sem_escolarizacao_2023_03_21 tse
where  tse.cd_nivel = 29
group by 1,2
)
select 
te.nr_anoletivo nr_ano_censo,
case when id_crede_sefor >20 then 21 else id_crede_sefor end id_crede_sefor,
case when id_crede_sefor >20 then 'SEFOR' else nm_crede_sefor end nm_crede_sefor,
id_municipio,
nm_municipio,
sum(coalesce(fl_aee,0) ) nr_aee,
sum(tp.fl_especial)	nr_def	,
sum(tp.fl_baixa_visao 	)	nr_bv	,
sum(tp.fl_cegueira 	)	nr_ceg	,
sum(tp.fl_def_auditiva 	)	nr_def_aud	,
sum(tp.fl_def_fisica 	)	nr_def_fis	,
sum(tp.fl_def_intelectual 	)	nr_def_int	,
sum(tp.fl_surdez)	nr_surd	,
sum(tp.fl_surdocegueira 	)	nr_surdo_ceg	,
sum(tp.fl_def_multipla 	)	nr_def_mult	,
sum(tp.fl_autismo)		nr_aut,
sum(coalesce(fl_Altas_habilidades_Superdotacao,0))	nr_super 
from public.tb_dm_aluno_pessoa_2023_03_21 tp
join public.tb_dm_etapa_aluno_2023_03_21 te on te.cd_aluno = tp.cd_aluno 
join public.tb_dm_escola tde using(id_escola_sige) 
left join altas on altas.cd_aluno = tp.cd_aluno
left join aluno_aee tse on tse.cd_aluno = tp.cd_aluno cd_aluno 
group by 1,2,3,4,5

