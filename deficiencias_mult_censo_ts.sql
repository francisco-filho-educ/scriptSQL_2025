with mat as (
select 
nu_ano_censo,
id_turma,
co_entidade,
co_pessoa_fisica,
tp_etapa_ensino,
coalesce(in_necessidade_especial,0) in_necessidade_especial,
coalesce(in_baixa_visao, 0) in_baixa_visao,
coalesce(in_cegueira, 0) in_cegueira,
coalesce(in_def_auditiva, 0) in_def_auditiva,
coalesce(in_def_fisica, 0) in_def_fisica,
coalesce(in_def_intelectual, 0) in_def_intelectual,
coalesce(in_surdez, 0) in_surdez,
coalesce(in_surdocegueira, 0) in_surdocegueira,
coalesce(in_autismo, 0) in_autismo,
coalesce(in_superdotacao, 0) in_superdotacao,
coalesce(in_def_multipla, 0) in_def_multipla
from censo_esc_ce.tb_matricula_2019 tm 
where 
tp_dependencia = 2
and tp_etapa_ensino is not null
and TP_MEDIACAO_DIDATICO_PEDAGO = 1
union 
select 
nu_ano_censo,
id_turma,
co_entidade,
co_pessoa_fisica,
tp_etapa_ensino,
coalesce(in_necessidade_especial,0) in_necessidade_especial,
coalesce(in_baixa_visao, 0) in_baixa_visao,
coalesce(in_cegueira, 0) in_cegueira,
coalesce(in_def_auditiva, 0) in_def_auditiva,
coalesce(in_def_fisica, 0) in_def_fisica,
coalesce(in_def_intelectual, 0) in_def_intelectual,
coalesce(in_surdez, 0) in_surdez,
coalesce(in_surdocegueira, 0) in_surdocegueira,
coalesce(in_autismo, 0) in_autismo,
coalesce(in_superdotacao, 0) in_superdotacao,
coalesce(in_def_multipla, 0) in_def_multipla
from censo_esc_ce.tb_matricula_2020 tm 
where 
tp_dependencia = 2
and tp_etapa_ensino is not null
and TP_MEDIACAO_DIDATICO_PEDAGO = 1
union 
select 
nu_ano_censo,
id_turma,
co_entidade,
co_pessoa_fisica,
tp_etapa_ensino,
coalesce(in_necessidade_especial,0) in_necessidade_especial,
coalesce(in_baixa_visao, 0) in_baixa_visao,
coalesce(in_cegueira, 0) in_cegueira,
coalesce(in_def_auditiva, 0) in_def_auditiva,
coalesce(in_def_fisica, 0) in_def_fisica,
coalesce(in_def_intelectual, 0) in_def_intelectual,
coalesce(in_surdez, 0) in_surdez,
coalesce(in_surdocegueira, 0) in_surdocegueira,
coalesce(in_autismo, 0) in_autismo,
coalesce(in_superdotacao, 0) in_superdotacao,
coalesce(in_def_multipla, 0) in_def_multipla
from censo_esc_ce.tb_matricula_2021 tm 
where 
tp_dependencia = 2
and tp_etapa_ensino is not null
and TP_MEDIACAO_DIDATICO_PEDAGO = 1
union 
select 
nu_ano_censo,
id_turma,
co_entidade,
co_pessoa_fisica,
tp_etapa_ensino,
coalesce(in_necessidade_especial,0) in_necessidade_especial,
coalesce(in_baixa_visao, 0) in_baixa_visao,
coalesce(in_cegueira, 0) in_cegueira,
coalesce(in_def_auditiva, 0) in_def_auditiva,
coalesce(in_def_fisica, 0) in_def_fisica,
coalesce(in_def_intelectual, 0) in_def_intelectual,
coalesce(in_surdez, 0) in_surdez,
coalesce(in_surdocegueira, 0) in_surdocegueira,
coalesce(in_autismo, 0) in_autismo,
coalesce(in_superdotacao, 0) in_superdotacao,
coalesce(in_def_multipla, 0) in_def_multipla
from censo_esc_d.tb_matricula tm 
where 
tp_dependencia = 2
and tp_etapa_ensino is not null
and TP_MEDIACAO_DIDATICO_PEDAGO = 1
)
,def as (
select 
nu_ano_censo,
id_turma,
co_entidade,
co_pessoa_fisica,
tp_etapa_ensino,
in_necessidade_especial,
0 in_baixa_visao,
0 in_cegueira,
0 in_def_auditiva,
0 in_def_fisica,
0 in_def_intelectual,
0 in_surdez,
0 in_surdocegueira,
0 in_autismo,
0 in_superdotacao,
1 in_def_multipla
from mat 
where  (IN_BAIXA_VISAO+IN_CEGUEIRA+IN_DEF_AUDITIVA+IN_DEF_FISICA+IN_DEF_INTELECTUAL+IN_SURDEZ+IN_SURDOCEGUEIRA+IN_AUTISMO+IN_SUPERDOTACAO)>1
union 
select 
nu_ano_censo,
id_turma,
co_entidade,
co_pessoa_fisica,
tp_etapa_ensino,
in_necessidade_especial,
in_baixa_visao,
in_cegueira,
in_def_auditiva,
in_def_fisica,
in_def_intelectual,
in_surdez,
in_surdocegueira,
in_autismo,
in_superdotacao,
0 in_def_multipla
from mat
where  (IN_BAIXA_VISAO+IN_CEGUEIRA+IN_DEF_AUDITIVA+IN_DEF_FISICA+IN_DEF_INTELECTUAL+IN_SURDEZ+IN_SURDOCEGUEIRA+IN_AUTISMO+IN_SUPERDOTACAO) = 1
),
mat_def_final as (
select
*
from mat m 
where not exists(select 1 from def d where d.co_pessoa_fisica = m.co_pessoa_fisica and d.nu_ano_censo = m.nu_ano_censo and d.id_turma = m.id_turma )
union  
select 
* 
from def
),
mat_aee as (
select 
nu_ano_censo,
co_pessoa_fisica,
1 fl_aee
from censo_esc_ce.tb_matricula_2019 tm 
where 
exists (select 1 from censo_esc_ce.tb_turma_2019 tt where tt.id_turma = tm.id_turma and tt.tp_tipo_atendimento_turma = 4 )
group by 1,2
union 
select 
nu_ano_censo,
co_pessoa_fisica,
1 fl_aee
from censo_esc_ce.tb_matricula_2020 tm 
where 
exists (select 1 from censo_esc_ce.tb_turma_2020 tt where tt.id_turma = tm.id_turma and tt.tp_tipo_atendimento_turma = 4 )
group by 1,2
union 
select 
nu_ano_censo,
co_pessoa_fisica,
1 fl_aee
from censo_esc_ce.tb_matricula_2021 tm 
where 
exists (select 1 from censo_esc_ce.tb_turma_2021_d tt where tt.id_turma = tm.id_turma and tt.tp_tipo_atendimento_turma = 4 )
group by 1,2
union 
select 
nu_ano_censo,
co_pessoa_fisica,
1 fl_aee
from censo_esc_d.tb_matricula tm 
where 
exists (select 1 from censo_esc_ce.tb_turma_2021_d tt where tt.id_turma = tm.id_turma and tt.tp_tipo_atendimento_turma = 4 )
group by 1,2
)
,mat_final as (
select
m.nu_ano_censo,
m.co_entidade,
--	Matrícula Educação Infantil
sum(case when cd_etapa = 1 then 1 else 0 end) nr_mat_inf,
--	Matrícula Ensino Fundamental (Anos Iniciais)
sum(case when cd_etapa_fase = 3 then 1 else 0 end) nr_mat_ai,
--	Matrícula Ensino Fundamental (Anos Finais)
sum(case when cd_etapa_fase = 4 then 1 else 0 end) nr_mat_af,
--	Matrícula Ensino Médio
sum(case when cd_etapa = 3 then 1 else 0 end) nr_mat_m,

--INFANTIL DEFICIENCIA
sum(case when cd_etapa = 1 then in_def_multipla else 0 end) nr_mat_inf_d_mult,
--Def. Física
sum(case when cd_etapa = 1 then in_def_fisica else 0 end) nr_mat_inf_d_fis,
--Def. Intelectual
sum(case when cd_etapa = 1 then in_def_intelectual else 0 end) nr_mat_inf_d_int,
--Def. Auditiva
sum(case when cd_etapa = 1 then in_def_auditiva else 0 end) nr_mat_inf_d_aud,
--Baixa Visão
sum(case when cd_etapa = 1 then in_baixa_visao else 0 end) nr_mat_inf_d_baix,
--Cegueira
sum(case when cd_etapa = 1 then in_cegueira else 0 end) nr_mat_inf_d_ceg,
--Surdez
sum(case when cd_etapa = 1 then in_surdez else 0 end) nr_mat_inf_d_sur,
--Surdocegueira
sum(case when cd_etapa = 1 then in_surdocegueira else 0 end) nr_mat_inf_d_suce,
--Autismo
sum(case when cd_etapa = 1 then in_autismo else 0 end) nr_mat_inf_d_aut,
--Superdotação
sum(case when cd_etapa = 1 then in_surdez else 0 end) nr_mat_inf_d_supd,

-- ANOS INICIAIS
sum(case when cd_etapa_fase = 3 then in_def_multipla else 0 end) nr_mat_ai_d_mult,
--Def. Física
sum(case when cd_etapa_fase = 3 then in_def_fisica else 0 end) nr_mat_ai_d_fis,
--Def. Intelectual
sum(case when cd_etapa_fase = 3 then in_def_intelectual else 0 end) nr_mat_ai_d_int,
--Def. Auditiva
sum(case when cd_etapa_fase = 3 then in_def_auditiva else 0 end) nr_mat_ai_d_aud,
--Baixa Visão
sum(case when cd_etapa_fase = 3 then in_baixa_visao else 0 end) nr_mat_ai_d_baix,
--Cegueira
sum(case when cd_etapa_fase = 3 then in_cegueira else 0 end) nr_mat_ai_d_ceg,
--Surdez
sum(case when cd_etapa_fase = 3 then in_surdez else 0 end) nr_mat_ai_d_sur,
--Surdocegueira
sum(case when cd_etapa_fase = 3 then in_surdocegueira else 0 end) nr_mat_ai_d_suce,
--Autismo
sum(case when cd_etapa_fase = 3 then in_autismo else 0 end) nr_mat_ai_d_aut,
--Superdotação
sum(case when cd_etapa_fase = 3 then in_surdez else 0 end) nr_mat_ai_d_supd,

--ANOS FINAIS
sum(case when cd_etapa_fase = 4 then in_def_multipla else 0 end) nr_mat_af_d_mult,
--Def. Física
sum(case when cd_etapa_fase = 4 then in_def_fisica else 0 end) nr_mat_af_d_fis,
--Def. Intelectual
sum(case when cd_etapa_fase = 4 then in_def_intelectual else 0 end) nr_mat_af_d_int,
--Def. Auditiva
sum(case when cd_etapa_fase = 4 then in_def_auditiva else 0 end) nr_mat_af_d_aud,
--Baixa Visão
sum(case when cd_etapa_fase = 4 then in_baixa_visao else 0 end) nr_mat_af_d_baix,
--Cegueira
sum(case when cd_etapa_fase = 4 then in_cegueira else 0 end) nr_mat_af_d_ceg,
--Surdez
sum(case when cd_etapa_fase = 4 then in_surdez else 0 end) nr_mat_af_d_sur,
--Surdocegueira
sum(case when cd_etapa_fase = 4 then in_surdocegueira else 0 end) nr_mat_af_d_suce,
--Autismo
sum(case when cd_etapa_fase = 4 then in_autismo else 0 end) nr_mat_af_d_aut,
--Superdotação
sum(case when cd_etapa_fase = 4 then in_surdez else 0 end) nr_mat_af_d_supd,

--ENSINO MEDIO
sum(case when cd_etapa = 3 then in_def_multipla else 0 end) nr_mat_med_d_mult,
--Def. Física
sum(case when cd_etapa = 3 then in_def_fisica else 0 end) nr_mat_med_d_fis,
--Def. Intelectual
sum(case when cd_etapa = 3 then in_def_intelectual else 0 end) nr_mat_med_d_int,
--Def. Auditiva
sum(case when cd_etapa = 3 then in_def_auditiva else 0 end) nr_mat_med_d_aud,
--Baixa Visão
sum(case when cd_etapa = 3 then in_baixa_visao else 0 end) nr_mat_med_d_baix,
--Cegueira
sum(case when cd_etapa = 3 then in_cegueira else 0 end) nr_mat_med_d_ceg,
--Surdez
sum(case when cd_etapa = 3 then in_surdez else 0 end) nr_mat_med_d_sur,
--Surdocegueira
sum(case when cd_etapa = 3 then in_surdocegueira else 0 end) nr_mat_med_d_suce,
--Autismo
sum(case when cd_etapa = 3 then in_autismo else 0 end) nr_mat_med_d_aut,
--Superdotação
sum(case when cd_etapa = 3 then in_surdez else 0 end) nr_mat_med_d_supd,
--aee	Matrícula AEE Educação Infantil
sum(case when cd_etapa = 1 then fl_aee else 0 end) nr_aee_inf,
--aee	Matrícula AEE Ensino Fundamental (Anos Iniciais)
sum(case when cd_etapa_fase = 3 then fl_aee else 0 end) nr_aee_ai,
--aee	Matrícula AEE Ensino Fundamental (Anos Finais)
sum(case when cd_etapa_fase = 4 then fl_aee else 0 end) nr_aee_af,
--aee	Matrícula AEE Ensino Médio
sum(case when cd_etapa = 3 then fl_aee else 0 end) nr_aee_m
from  mat_def_final m
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = m.tp_etapa_ensino
left join mat_aee me on me.co_pessoa_fisica = m.co_pessoa_fisica and m.nu_ano_censo = me.nu_ano_censo
group by 1,2 
) --select distinct nu_ano_censo from mat_final
--- SITUACAO  E RENDIMENTO 
,sit as (
select 
nu_ano_censo,
co_entidade,
--anos iniciais
sum(case when                     cd_etapa_fase = 3 then 1 else 0 end) nr_mat_ai,
sum(case when tp_situacao = 5 and cd_etapa_fase = 3 then 1 else 0 end) nr_ap_ai,
sum(case when tp_situacao = 4 and cd_etapa_fase = 3  then 1 else 0 end) nr_re_ai,
sum(case when tp_situacao = 2 and cd_etapa_fase = 3  then 1 else 0 end) nr_ab_ai,
-- anos finais
sum(case when                     cd_etapa_fase = 4 then 1 else 0 end) nr_mat_af,
sum(case when tp_situacao = 5 and cd_etapa_fase = 4 then 1 else 0 end) nr_ap_af,
sum(case when tp_situacao = 4 and cd_etapa_fase = 4  then 1 else 0 end) nr_re_af,
sum(case when tp_situacao = 2 and cd_etapa_fase = 4  then 1 else 0 end) nr_ab_af,
-- medio
sum(case when                     cd_etapa = 3 then 1 else 0 end) nr_mat_m,
sum(case when tp_situacao = 5 and cd_etapa = 3 then 1 else 0 end) nr_ap_m,
sum(case when tp_situacao = 4 and cd_etapa = 3  then 1 else 0 end) nr_re_m,
sum(case when tp_situacao = 2 and cd_etapa = 3  then 1 else 0 end) nr_ab_m
--select tde.cd_etapa_fase, ds_etapa_fASE,DS_ANO_SERIE
from censo_esc_ce.tb_situacao_2019 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino
where 
tp_dependencia = 2
and tp_situacao in (5,4,2)
and in_regular = 1
group by 1,2 
union
select 
nu_ano_censo,
co_entidade,
--anos iniciais
sum(case when                     cd_etapa_fase = 3 then 1 else 0 end) nr_mat_ai,
sum(case when tp_situacao = 5 and cd_etapa_fase = 3 then 1 else 0 end) nr_ap_ai,
sum(case when tp_situacao = 4 and cd_etapa_fase = 3  then 1 else 0 end) nr_re_ai,
sum(case when tp_situacao = 2 and cd_etapa_fase = 3  then 1 else 0 end) nr_ab_ai,
-- anos finais
sum(case when                     cd_etapa_fase = 4 then 1 else 0 end) nr_mat_af,
sum(case when tp_situacao = 5 and cd_etapa_fase = 4 then 1 else 0 end) nr_ap_af,
sum(case when tp_situacao = 4 and cd_etapa_fase = 4  then 1 else 0 end) nr_re_af,
sum(case when tp_situacao = 2 and cd_etapa_fase = 4  then 1 else 0 end) nr_ab_af,
-- medio
sum(case when                                cd_etapa = 3 then 1 else 0 end) nr_mat_m,
sum(case when tp_situacao = 5 and cd_etapa = 3 then 1 else 0 end) nr_ap_m,
sum(case when tp_situacao = 4 and cd_etapa = 3  then 1 else 0 end) nr_re_m,
sum(case when tp_situacao = 2 and cd_etapa = 3  then 1 else 0 end) nr_ab_m
from censo_esc_ce.tb_situacao_2020 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino
where 
tp_dependencia = 2
and tp_situacao in (5,4,2)
and in_regular = 1
group by 1,2
union 
select 
nu_ano_censo,
co_entidade,
--anos iniciais
sum(case when                     cd_etapa_fase = 3 then 1 else 0 end) nr_mat_ai,
sum(case when tp_situacao = 5 and cd_etapa_fase = 3 then 1 else 0 end) nr_ap_ai,
sum(case when tp_situacao = 4 and cd_etapa_fase = 3  then 1 else 0 end) nr_re_ai,
sum(case when tp_situacao = 2 and cd_etapa_fase = 3  then 1 else 0 end) nr_ab_ai,
-- anos finais
sum(case when                     cd_etapa_fase = 4 then 1 else 0 end) nr_mat_af,
sum(case when tp_situacao = 5 and cd_etapa_fase = 4 then 1 else 0 end) nr_ap_af,
sum(case when tp_situacao = 4 and cd_etapa_fase = 4  then 1 else 0 end) nr_re_af,
sum(case when tp_situacao = 2 and cd_etapa_fase = 4  then 1 else 0 end) nr_ab_af,
-- medio
sum(case when                     cd_etapa = 3 then 1 else 0 end) nr_mat_m,
sum(case when tp_situacao = 5 and cd_etapa = 3 then 1 else 0 end) nr_ap_m,
sum(case when tp_situacao = 4 and cd_etapa = 3  then 1 else 0 end) nr_re_m,
sum(case when tp_situacao = 2 and cd_etapa = 3  then 1 else 0 end) nr_ab_m
from censo_esc_ce.tb_situacao_2021 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tp_etapa_ensino
where 
tp_dependencia = 2
and tp_situacao in (5,4,2)
and in_regular = 1
group by 1,2
),
sit_final as (
select 
nu_ano_censo,
co_entidade,
--ai
case when nr_mat_ai = 0 then 0.0 else nr_ap_ai/nr_mat_ai::numeric end p_ap_ai,
case when nr_mat_ai = 0 then 0.0 else nr_re_ai/nr_mat_ai::numeric end p_re_ai,
case when nr_mat_ai = 0 then 0.0 else nr_ab_ai/nr_mat_ai::numeric end p_ab_ai,
--af 
case when nr_mat_af = 0 then 0.0 else nr_ap_af/nr_mat_af::numeric end p_ap_af,
case when nr_mat_af = 0 then 0.0 else nr_re_af/nr_mat_af::numeric end p_re_af,
case when nr_mat_af = 0 then 0.0 else nr_ab_af/nr_mat_af::numeric end p_ab_af,
--medio 
case when nr_mat_m = 0 then 0.0 else nr_ap_m/nr_mat_m::numeric end p_ap_m,
case when nr_mat_m = 0 then 0.0 else nr_re_m/nr_mat_m::numeric end p_re_m,
case when nr_mat_m = 0 then 0.0 else nr_ab_m/nr_mat_m::numeric end p_ab_m
from sit 
)
--*select  * from sit_final limit 10
-- ESCOLAS
,estrutura as (
select 
nu_ano_censo,
co_entidade,
te.in_laboratorio_informatica,
te.in_laboratorio_ciencias,
te.in_quadra_esportes_coberta,
te.in_quadra_esportes_descoberta
from censo_esc_ce.tb_escola_2019 te 
where te.tp_dependencia = 2
and te.tp_situacao_funcionamento = 1
union 
select 
nu_ano_censo,
co_entidade,
te.in_laboratorio_informatica,
te.in_laboratorio_ciencias,
te.in_quadra_esportes_coberta,
te.in_quadra_esportes_descoberta
from censo_esc_ce.tb_escola_2020 te 
where te.tp_dependencia = 2
and te.tp_situacao_funcionamento = 1
union 
select 
nu_ano_censo,
co_entidade,
te.in_laboratorio_informatica,
te.in_laboratorio_ciencias,
te.in_quadra_esportes_coberta,
te.in_quadra_esportes_descoberta
from censo_esc_ce.tb_escola_2021_d te 
where te.tp_dependencia = 2
and te.tp_situacao_funcionamento = 1
union 
select 
nu_ano_censo,
co_entidade,
te.in_laboratorio_informatica,
te.in_laboratorio_ciencias,
te.in_quadra_esportes_coberta,
te.in_quadra_esportes_descoberta
from censo_esc_d.tb_escola te 
where te.tp_dependencia = 2
and te.tp_situacao_funcionamento = 1
)
,escola_final as(
select 
ted.nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
ted.ds_categoria_escola_sige ds_categoria,
nm_municipio,
id_escola_inep,
nm_escola,
ted.ds_localizacao,
in_laboratorio_informatica,
in_laboratorio_ciencias,
in_quadra_esportes_coberta,
in_quadra_esportes_descoberta
from dw_censo.tb_dm_escola ted 
join dw_censo.tb_dm_municipio tdm using(id_municipio)
join estrutura on nu_ano_censo = nr_ano_censo and id_escola_inep = co_entidade 
where ted.cd_dependencia = 2
union 
select 
ted.nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
ted.ds_categoria_escola_sige ds_categoria,
nm_municipio,
id_escola_inep,
nm_escola,
ted.ds_localizacao,
in_laboratorio_informatica,
in_laboratorio_ciencias,
in_quadra_esportes_coberta,
in_quadra_esportes_descoberta
from dw_censo.tb_dm_escola_dinamico ted 
join dw_censo.tb_dm_municipio tdm using(id_municipio)
join estrutura on nu_ano_censo = nr_ano_censo and id_escola_inep = co_entidade 
where ted.cd_dependencia = 2
)
select --distinct nr_ano_censo from escola_final
m.nu_ano_censo ,		
id_crede_sefor,		
nm_crede_sefor,		
ds_categoria,		
nm_municipio,		
id_escola_inep,		
nm_escola,		
ds_localizacao,		
coalesce(	nr_mat_inf,0)	nr_mat_inf,
coalesce(	nr_mat_ai,0)	nr_mat_ai,
coalesce(	nr_mat_af,0)	nr_mat_af,
coalesce(	nr_mat_m,0)	nr_mat_m,
coalesce(	p_ap_ai,0)	p_ap_ai,
coalesce(	p_re_ai,0)	p_re_ai,
coalesce(	p_ab_ai,0) 	p_ab_ai, 
coalesce(	p_ap_af,0)	p_ap_af,
coalesce(	p_re_af,0)	p_re_af,
coalesce(	p_ab_af,0)	p_ab_af,
coalesce(	p_ap_m,0)	p_ap_m,
coalesce(	p_re_m,0)	p_re_m,
coalesce(	p_ab_m,0)	p_ab_m,
coalesce(	nr_mat_inf_d_mult,0)	nr_mat_inf_d_mult,
coalesce(	nr_mat_inf_d_fis,0)	nr_mat_inf_d_fis,
coalesce(	nr_mat_inf_d_int,0)	nr_mat_inf_d_int,
coalesce(	nr_mat_inf_d_aud,0)	nr_mat_inf_d_aud,
coalesce(	nr_mat_inf_d_baix,0)	nr_mat_inf_d_baix,
coalesce(	nr_mat_inf_d_ceg,0)	nr_mat_inf_d_ceg,
coalesce(	nr_mat_inf_d_sur,0)	nr_mat_inf_d_sur,
coalesce(	nr_mat_inf_d_suce,0)	nr_mat_inf_d_suce,
coalesce(	nr_mat_inf_d_aut,0)	nr_mat_inf_d_aut,
coalesce(	nr_mat_inf_d_supd,0)	nr_mat_inf_d_supd,
coalesce(	nr_mat_ai_d_mult,0)	nr_mat_ai_d_mult,
coalesce(	nr_mat_ai_d_fis,0)	nr_mat_ai_d_fis,
coalesce(	nr_mat_ai_d_int,0)	nr_mat_ai_d_int,
coalesce(	nr_mat_ai_d_aud,0)	nr_mat_ai_d_aud,
coalesce(	nr_mat_ai_d_baix,0)	nr_mat_ai_d_baix,
coalesce(	nr_mat_ai_d_ceg,0)	nr_mat_ai_d_ceg,
coalesce(	nr_mat_ai_d_sur,0)	nr_mat_ai_d_sur,
coalesce(	nr_mat_ai_d_suce,0)	nr_mat_ai_d_suce,
coalesce(	nr_mat_ai_d_aut,0)	nr_mat_ai_d_aut,
coalesce(	nr_mat_ai_d_supd,0)	nr_mat_ai_d_supd,
coalesce(	nr_mat_af_d_mult,0)	nr_mat_af_d_mult,
coalesce(	nr_mat_af_d_fis,0)	nr_mat_af_d_fis,
coalesce(	nr_mat_af_d_int,0)	nr_mat_af_d_int,
coalesce(	nr_mat_af_d_aud,0)	nr_mat_af_d_aud,
coalesce(	nr_mat_af_d_baix,0)	nr_mat_af_d_baix,
coalesce(	nr_mat_af_d_ceg,0)	nr_mat_af_d_ceg,
coalesce(	nr_mat_af_d_sur,0)	nr_mat_af_d_sur,
coalesce(	nr_mat_af_d_suce,0)	nr_mat_af_d_suce,
coalesce(	nr_mat_af_d_aut,0)	nr_mat_af_d_aut,
coalesce(	nr_mat_af_d_supd,0)	nr_mat_af_d_supd,
coalesce(	nr_mat_med_d_mult,0)	nr_mat_med_d_mult,
coalesce(	nr_mat_med_d_fis,0)	nr_mat_med_d_fis,
coalesce(	nr_mat_med_d_int,0)	nr_mat_med_d_int,
coalesce(	nr_mat_med_d_aud,0)	nr_mat_med_d_aud,
coalesce(	nr_mat_med_d_baix,0)	nr_mat_med_d_baix,
coalesce(	nr_mat_med_d_ceg,0)	nr_mat_med_d_ceg,
coalesce(	nr_mat_med_d_sur,0)	nr_mat_med_d_sur,
coalesce(	nr_mat_med_d_suce,0)	nr_mat_med_d_suce,
coalesce(	nr_mat_med_d_aut,0)	nr_mat_med_d_aut,
coalesce(	nr_mat_med_d_supd,0)	nr_mat_med_d_supd,
coalesce(	nr_aee_inf,0)	nr_aee_inf,
coalesce(	nr_aee_ai,0)	nr_aee_ai,
coalesce(	nr_aee_af,0)	nr_aee_af,
coalesce(	nr_aee_m,0)	nr_aee_m,
coalesce(	in_laboratorio_informatica,0)	in_laboratorio_informatica,
coalesce(	in_laboratorio_ciencias,0)	in_laboratorio_ciencias,
coalesce(	in_quadra_esportes_coberta,0)	in_quadra_esportes_coberta,
coalesce(	in_quadra_esportes_descoberta,0)	in_quadra_esportes_descoberta
from escola_final e
join mat_final m on m.co_entidade = e.id_escola_inep and m.nu_ano_censo = e.nr_ano_censo
left join sit_final s on s.co_entidade =  e.id_escola_inep and e.nr_ano_censo =  s.nu_ano_censo 