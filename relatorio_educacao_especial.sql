--MATRICULAS DE ESCOLARIZAÇÃO
select
0 orde,
nu_ano_censo nr_ano_censo,
nm_municipio,
case when tp_dependencia = 1 then 'Federal'
     when tp_dependencia = 2 then 'Estadual'
     when tp_dependencia = 3 then 'Municipal'
     when tp_dependencia = 4 then 'Privada' end ds_dependencia,
count(distinct tm.co_entidade) qtd_escola,
count(distinct case when in_necessidade_especial=1 then co_pessoa_fisica end) nr_def,
count(distinct case when in_necessidade_especial=1 and in_especial_exclusiva <>1  then co_pessoa_fisica end) nr_def_C,
count(distinct case when in_necessidade_especial=1 and in_especial_exclusiva = 1 then co_pessoa_fisica end) nr_def_ex,
count(distinct case when in_baixa_visao=1  then co_pessoa_fisica end) nr_bv,
count(distinct case when in_baixa_visao=1   and in_especial_exclusiva <> 1 then co_pessoa_fisica end) nr_bv_c,
count(distinct case when in_baixa_visao=1   and in_especial_exclusiva = 1 then co_pessoa_fisica end) nr_bv_ex,
count(distinct case when in_cegueira=1  then co_pessoa_fisica end) nr_ceg,
count(distinct case when in_cegueira=1    and in_especial_exclusiva <> 1  then co_pessoa_fisica end) nr_ceg_c,
count(distinct case when in_cegueira=1    and in_especial_exclusiva = 1  then co_pessoa_fisica end) nr_ceg_ex,
count(distinct case when in_def_auditiva=1  then co_pessoa_fisica end) nr_def_aud,
count(distinct case when in_def_auditiva=1  and in_especial_exclusiva <> 1  then co_pessoa_fisica end) nr_def_aud_c,
count(distinct case when in_def_auditiva=1  and in_especial_exclusiva = 1  then co_pessoa_fisica end) nr_def_aud_ex,
count(distinct case when in_def_fisica=1  then co_pessoa_fisica end) nr_def_fis,
count(distinct case when in_def_fisica=1  and in_especial_exclusiva <> 1  then co_pessoa_fisica end) nr_def_fis_c,
count(distinct case when in_def_fisica=1  and in_especial_exclusiva = 1  then co_pessoa_fisica end) nr_def_fis_ex,
count(distinct case when in_def_intelectual=1  then co_pessoa_fisica end) nr_def_int,
count(distinct case when in_def_intelectual=1  and in_especial_exclusiva <> 1  then co_pessoa_fisica end) nr_def_int_c,
count(distinct case when in_def_intelectual=1  and in_especial_exclusiva = 1  then co_pessoa_fisica end) nr_def_int_ex,
count(distinct case when in_surdez=1  then co_pessoa_fisica end) nr_surd,
count(distinct case when in_surdez=1  and in_especial_exclusiva <> 1  then co_pessoa_fisica end) nr_surd_c,
count(distinct case when in_surdez=1  and in_especial_exclusiva = 1  then co_pessoa_fisica end) nr_surd_ex,
count(distinct case when in_surdocegueira=1  then co_pessoa_fisica end)nr_surdo_ceg,
count(distinct case when in_surdocegueira=1  and in_especial_exclusiva <> 1  then co_pessoa_fisica end)nr_surdo_ceg_c,
count(distinct case when in_surdocegueira=1  and in_especial_exclusiva = 1  then co_pessoa_fisica end)nr_surdo_ceg_ex,
count(distinct case when in_def_multipla=1  then co_pessoa_fisica end) nr_def_mult,
count(distinct case when in_def_multipla=1  and in_especial_exclusiva <> 1  then co_pessoa_fisica end) nr_def_mult_c,
count(distinct case when in_def_multipla=1  and in_especial_exclusiva = 1  then co_pessoa_fisica end) nr_def_mult_ex,
count(distinct case when in_autismo=1 or IN_SINDROME_ASPERGER = 1 or IN_SINDROME_RETT = 1 or IN_TRANSTORNO_DI = 1 then co_pessoa_fisica end) nr_aut,
count(distinct case when (in_autismo=1 or IN_SINDROME_ASPERGER = 1 or IN_SINDROME_RETT = 1 or IN_TRANSTORNO_DI = 1)  and in_especial_exclusiva <> 1 then co_pessoa_fisica end) nr_aut_c,
count(distinct case when (in_autismo=1 or IN_SINDROME_ASPERGER = 1 or IN_SINDROME_RETT = 1 or IN_TRANSTORNO_DI = 1)  and in_especial_exclusiva = 1 then co_pessoa_fisica end) nr_aut_ex,
count(distinct case when in_superdotacao=1  then co_pessoa_fisica end) nr_super,
count(distinct case when in_superdotacao=1   and in_especial_exclusiva <> 1 then co_pessoa_fisica end) nr_super_c,
count(distinct case when in_superdotacao=1   and in_especial_exclusiva = 1 then co_pessoa_fisica end) nr_super_ex
from censo_esc_ce.tb_matricula_2022 tm 
join dw_censo.tb_dm_municipio tdm on id_municipio = co_municipio 
where tp_etapa_ensino is not null
group by 1,2,3,4
union 
select
1 orde,
nu_ano_censo nr_ano_censo,
nm_municipio,
'TOTAL' ds_dependencia,
count(distinct tm.co_entidade) qtd_escola,
count(distinct case when in_necessidade_especial=1 then co_pessoa_fisica end) nr_def,
count(distinct case when in_necessidade_especial=1 and in_especial_exclusiva <>1  then co_pessoa_fisica end) nr_def_C,
count(distinct case when in_necessidade_especial=1 and in_especial_exclusiva = 1 then co_pessoa_fisica end) nr_def_ex,
count(distinct case when in_baixa_visao=1  then co_pessoa_fisica end) nr_bv,
count(distinct case when in_baixa_visao=1   and in_especial_exclusiva <> 1 then co_pessoa_fisica end) nr_bv_c,
count(distinct case when in_baixa_visao=1   and in_especial_exclusiva = 1 then co_pessoa_fisica end) nr_bv_ex,
count(distinct case when in_cegueira=1  then co_pessoa_fisica end) nr_ceg,
count(distinct case when in_cegueira=1    and in_especial_exclusiva <> 1  then co_pessoa_fisica end) nr_ceg_c,
count(distinct case when in_cegueira=1    and in_especial_exclusiva = 1  then co_pessoa_fisica end) nr_ceg_ex,
count(distinct case when in_def_auditiva=1  then co_pessoa_fisica end) nr_def_aud,
count(distinct case when in_def_auditiva=1  and in_especial_exclusiva <> 1  then co_pessoa_fisica end) nr_def_aud_c,
count(distinct case when in_def_auditiva=1  and in_especial_exclusiva = 1  then co_pessoa_fisica end) nr_def_aud_ex,
count(distinct case when in_def_fisica=1  then co_pessoa_fisica end) nr_def_fis,
count(distinct case when in_def_fisica=1  and in_especial_exclusiva <> 1  then co_pessoa_fisica end) nr_def_fis_c,
count(distinct case when in_def_fisica=1  and in_especial_exclusiva = 1  then co_pessoa_fisica end) nr_def_fis_ex,
count(distinct case when in_def_intelectual=1  then co_pessoa_fisica end) nr_def_int,
count(distinct case when in_def_intelectual=1  and in_especial_exclusiva <> 1  then co_pessoa_fisica end) nr_def_int_c,
count(distinct case when in_def_intelectual=1  and in_especial_exclusiva = 1  then co_pessoa_fisica end) nr_def_int_ex,
count(distinct case when in_surdez=1  then co_pessoa_fisica end) nr_surd,
count(distinct case when in_surdez=1  and in_especial_exclusiva <> 1  then co_pessoa_fisica end) nr_surd_c,
count(distinct case when in_surdez=1  and in_especial_exclusiva = 1  then co_pessoa_fisica end) nr_surd_ex,
count(distinct case when in_surdocegueira=1  then co_pessoa_fisica end)nr_surdo_ceg,
count(distinct case when in_surdocegueira=1  and in_especial_exclusiva <> 1  then co_pessoa_fisica end)nr_surdo_ceg_c,
count(distinct case when in_surdocegueira=1  and in_especial_exclusiva = 1  then co_pessoa_fisica end)nr_surdo_ceg_ex,
count(distinct case when in_def_multipla=1  then co_pessoa_fisica end) nr_def_mult,
count(distinct case when in_def_multipla=1  and in_especial_exclusiva <> 1  then co_pessoa_fisica end) nr_def_mult_c,
count(distinct case when in_def_multipla=1  and in_especial_exclusiva = 1  then co_pessoa_fisica end) nr_def_mult_ex,
count(distinct case when in_autismo=1 or IN_SINDROME_ASPERGER = 1 or IN_SINDROME_RETT = 1 or IN_TRANSTORNO_DI = 1 then co_pessoa_fisica end) nr_aut,
count(distinct case when (in_autismo=1 or IN_SINDROME_ASPERGER = 1 or IN_SINDROME_RETT = 1 or IN_TRANSTORNO_DI = 1)  and in_especial_exclusiva <> 1 then co_pessoa_fisica end) nr_aut_c,
count(distinct case when (in_autismo=1 or IN_SINDROME_ASPERGER = 1 or IN_SINDROME_RETT = 1 or IN_TRANSTORNO_DI = 1)  and in_especial_exclusiva = 1 then co_pessoa_fisica end) nr_aut_ex,
count(distinct case when in_superdotacao=1  then co_pessoa_fisica end) nr_super,
count(distinct case when in_superdotacao=1   and in_especial_exclusiva <> 1 then co_pessoa_fisica end) nr_super_c,
count(distinct case when in_superdotacao=1   and in_especial_exclusiva = 1 then co_pessoa_fisica end) nr_super_ex
from censo_esc_ce.tb_matricula_2022 tm 
join dw_censo.tb_dm_municipio tdm on id_municipio = co_municipio 
where tp_etapa_ensino is not null
group by 1,2,3,4
order by 3,4,1

-- SALAS DE ANTENDIMENTO 
select
0 orde,
nu_ano_censo nr_ano_censo,
nm_municipio,
case when tp_dependencia = 1 then 'Federal'
     when tp_dependencia = 2 then 'Estadual'
     when tp_dependencia = 3 then 'Municipal'
     when tp_dependencia = 4 then 'Privada' end ds_dependencia,
count(distinct tm.co_entidade) qtd_escola,
count(distinct tm.id_turma) qtd_turmas,
count(distinct tm.co_pessoa_fisica) qtd_matriculas
from censo_esc_ce.tb_matricula_2022 tm 
join dw_censo.tb_dm_municipio tdm on id_municipio = co_municipio 
where tp_tipo_atendimento_turma = 4
group by 1,2,3,4
union 
select
1 orde,
nu_ano_censo nr_ano_censo,
nm_municipio,
'TOTAL' ds_dependencia,
count(distinct tm.co_entidade) qtd_escola,
count(distinct tm.id_turma) qtd_turmas,
count(distinct tm.co_pessoa_fisica) qtd_matriculas
from censo_esc_ce.tb_matricula_2022 tm 
join dw_censo.tb_dm_municipio tdm on id_municipio = co_municipio 
where tp_tipo_atendimento_turma = 4
group by 1,2,3,4
order by 3,4,1
 
-- QUANTITATIVO DE ESCOLAS E 

