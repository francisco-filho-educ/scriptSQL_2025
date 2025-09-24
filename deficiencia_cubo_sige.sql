select
cd_crede_sefor,	
nm_crede_sefor,	
id_municipio,	
nm_municipio,	
id_escola_inep,
nm_escola,	
nm_categoria,
sum(fl_cegueira) mr_cegueira,
sum(fl_baixa_visao) baixa_visao,
sum(fl_surdez) mr_surdez,
sum(fl_deficiencia_auditiva) mr_def_auditiva,
sum(fl_surdocegueira) mr_surdo_cegueira,
sum(fl_deficiencia_fisica) mr_def_fisica,
sum(fl_deficiencia_intelectual) mr_def_intelect,
sum(fl_deficiencia_multipla) mr_def_multipla,
sum(fl_autismo) mr_autismo,
sum(fl_altas_habilidades_superdotacao) mr_altas_hab
from dw_sige.tb_cubo_aluno_junho_2024 c
where cd_nivel in (26,27,28)
group by 1,2,3,4,5,6,7

