select
tdea.nr_anoletivo,
tde.id_crede_sefor,
nm_crede_sefor,
nm_municipio,
tde.id_escola_inep,
nm_escola,
ds_categoria,
ds_localizacao,
count(tdea.cd_aluno) nr_matricula,
--NR_DEF
sum(tdap.fl_especial) qtd_deficiente,
--NR_BV
sum(tdap.fl_baixa_visao) baixa_visao,
--NR_CEG
sum(tdap.fl_cegueira) cegueira,
--NR_DEF_AUD
sum(tdap.fl_def_auditiva) def_auditiva,
--NR_SURD
sum(tdap.fl_surdez) surdez,
--NR_SURDO_CEG
sum(tdap.fl_surdocegueira) surdecegueira,
--NR_DEF_FIS
sum(tdap.fl_def_fisica) def_fisica,
--NR_DEF_INT
sum(tdap.fl_def_intelectual) def_intelectual,
--NR_DEF_MULT
sum(tdap.fl_def_multipla) def_multipla,
--NR_AUT
sum(tdap.fl_autismo) autismo,
--NR_SUPER
sum(tdap.fl_def_superdotacao) superdotacao
from public.tb_dm_etapa_aluno_2023_03_21 tdea 
join public.tb_dm_aluno_pessoa_2023_03_21 tdap using(cd_aluno)
join public.tb_dm_escola tde on tde.id_escola_sige = tdea.id_escola_sige 
where tde.cd_categoria = 8
group by 1,2,3,4,5,6,7,8

