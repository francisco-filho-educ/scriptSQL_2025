select
c.nr_anoletivo,
cd_crede_sefor,
nm_crede_sefor,
id_municipio,
nm_municipio,
id_escola_inep,
nm_escola,
nm_categoria,
c.cd_turma,
c.ds_turma, 
ds_etapa_aluno ds_serie_etapa,
count(1) total,
sum(c.fl_possui_deficiencia) total_deficientes,
--IN_BAIXA_VISAO
sum(c.fl_baixa_visao) nr_baixa_visao,
--IN_CEGUEIRA
sum(c.fl_cegueira) nr_cegueira,
--IN_DEF_AUDITIVA
sum(c.fl_deficiencia_auditiva) nr_deficiencia_auditiva,
--IN_DEF_FISICA
sum(c.fl_deficiencia_fisica) nr_deficiencia_fisica,
--IN_DEF_INTELECTUAL
sum(c.fl_deficiencia_intelectual) nr_deficiencia_intelectual,
--IN_SURDEZ
sum(c.fl_surdez) nr_surdez,
--IN_SURDOCEGUEIRA
sum(c.fl_surdocegueira) nr_surdocegueira,
--IN_VISAO_MONOCULAR
sum(c.fl_visao_monocular) nr_visao_monocular,
--IN_DEF_MULTIPLA
sum(c.fl_deficiencia_multipla) nr_deficiencia_multipla,
--IN_AUTISMO
sum(c.fl_autismo) nr_autismo,
--IN_SUPERDOTACAO
sum(fl_altas_habilidades_superdotacao) nr_superdotacao
from dw_sige.tb_cubo_aluno_junho_2024 c
where 
c.cd_nivel = 27
--and cd_etapa_aluno in (196,197)
group by 1,2,3,4,5,6,7,8,9,10,11
--116738	111938	98762	43

/*
select
tm.nu_ano_censo::int,
id_crede_sefor,
nm_crede_sefor,
id_municipio,
nm_municipio,
id_escola_inep,
nm_escola,
te.ds_dependencia,
te.ds_categoria_escola_sige,
tm.id_turma cd_turma,
tt.no_turma ds_turma, 
tde.ds_etapa_ensino etapa_ensino_aluno,
tdet.ds_etapa_ensino etapa_ensino_turma,
count(1) total,
sum(coalesce(tm.IN_NECESSIDADE_ESPECIAL,0)) total_deficientes,
--IN_BAIXA_VISAO
sum(coalesce(tm.IN_BAIXA_VISAO,0)) nr_baixa_visao,
--IN_CEGUEIRA
sum(coalesce(tm.IN_CEGUEIRA,0)) nr_cegueira,
--IN_DEF_AUDITIVA
sum(coalesce(tm.IN_DEF_AUDITIVA,0)) nr_deficiencia_auditiva,
--IN_DEF_FISICA
sum(coalesce(tm.IN_DEF_FISICA,0)) nr_deficiencia_fisica,
--IN_DEF_INTELECTUAL
sum(coalesce(tm.IN_DEF_INTELECTUAL,0)) nr_deficiencia_intelectual,
--IN_SURDEZ
sum(coalesce(tm.IN_SURDEZ,0)) nr_surdez,
--IN_SURDOCEGUEIRA
sum(coalesce(tm.in_surdocegueira,0)) nr_surdocegueira,
--IN_VISAO_MONOCULAR
sum(coalesce(tm.IN_VISAO_MONOCULAR,0)) nr_visao_monocular,
--IN_DEF_MULTIPLA
sum(coalesce(tm.deficiencia_multipla,0)) nr_deficiencia_multipla,
--IN_AUTISMO
sum(coalesce(tm.IN_AUTISMO,0)) nr_autismo,
--IN_SUPERDOTACAO
sum(coalesce(IN_SUPERDOTACAO,0)) nr_superdotacao
from censo_esc_ce.tb_matricula_2023 tm 
join censo_esc_ce.tb_turma_2023 tt using(id_turma)
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
join dw_censo.tb_dm_etapa tdet on tdet.cd_etapa_ensino = tt.tp_etapa_ensino 
join dw_censo.tb_dm_escola te on te.id_escola_inep = tm.co_entidade and te.nr_ano_censo = 2023
join dw_censo.tb_dm_municipio tdm using(id_municipio)
where 
tm.nu_ano_censo = 2023 
and tde.cd_ano_serie between 1 and 9
and tm.tp_dependencia  in (1,2,3)
group by 1,2 ,3,4,5,6,7,8,9,10,11,12,13
--676
*/

/*
select
tm.nu_ano_censo::int,
id_municipio,
nm_municipio,
id_escola_inep,
nm_escola,
ds_dependencia,
count(1) total,
sum(coalesce(tm.IN_NECESSIDADE_ESPECIAL,0)) total_deficientes,
--IN_BAIXA_VISAO
sum(coalesce(tm.IN_BAIXA_VISAO,0)) nr_baixa_visao,
--IN_CEGUEIRA
sum(coalesce(tm.IN_CEGUEIRA,0)) nr_cegueira,
--IN_DEF_AUDITIVA
sum(coalesce(tm.IN_DEF_AUDITIVA,0)) nr_deficiencia_auditiva,
--IN_DEF_FISICA
sum(coalesce(tm.IN_DEF_FISICA,0)) nr_deficiencia_fisica,
--IN_DEF_INTELECTUAL
sum(coalesce(tm.IN_DEF_INTELECTUAL,0)) nr_deficiencia_intelectual,
--IN_SURDEZ
sum(coalesce(tm.IN_SURDEZ,0)) nr_surdez,
--IN_SURDOCEGUEIRA
sum(coalesce(tm.in_surdocegueira,0)) nr_surdocegueira,
--IN_VISAO_MONOCULAR
--NULL nr_visao_monocular,
sum(coalesce(tm.IN_VISAO_MONOCULAR,0)) nr_visao_monocular,
--IN_DEF_MULTIPLA
sum(coalesce(tm.in_def_multipla ,0)) nr_deficiencia_multipla,
--IN_AUTISMO
sum(coalesce(tm.IN_AUTISMO,0)) nr_autismo,
--IN_SUPERDOTACAO
sum(coalesce(IN_SUPERDOTACAO,0)) nr_superdotacao
from censo_esc_ce.tb_matricula_2023 tm 
join dw_censo.tb_dm_escola te on te.id_escola_inep = tm.co_entidade and te.nr_ano_censo = tm.nu_ano_censo
join dw_censo.tb_dm_municipio tdm using(id_municipio)
where 
tm.nu_ano_censo = 2023 
and te.id_municipio = 2301109
and tm.tp_dependencia >2
group by 1,2 ,3,4,5,6

*/
