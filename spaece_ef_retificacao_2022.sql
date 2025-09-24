
with indigena as (
select 
co_entidade,
1 fl_indigena
from censo_esc_d.tb_escola te  
where tp_situacao_funcionamento = 1
and in_educacao_indigena = 1 and tp_dependencia = 3
group by 1,2
),
credes as (
select 
tde.ds_orgao_regional co_orgao_regional,
id_crede_sefor,
nm_crede_sefor
from dw_censo.tb_dm_escola tde 
where tde.nr_ano_censo = 2020 and tde.nm_crede_sefor is not null
group by 1,2,3
),
deficiencias as(
select  co_pessoa_fisica, 'Baixa visão' ds_deficiencia 
from censo_esc_d.tb_matricula bs 
 where in_baixa_visao::int = 1 
union
select  co_pessoa_fisica, 'Cegueira'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_cegueira::int = 1 
union
select  co_pessoa_fisica,  'Deficiência auditiva'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_def_auditiva::int = 1
union
select  co_pessoa_fisica, 'Deficiência física'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_def_fisica::int = 1 
union
select  co_pessoa_fisica, 'Surdez'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_surdez::int = 1 
union
select  co_pessoa_fisica, 'Surdocegueira'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_surdocegueira::int = 1 
union
select  co_pessoa_fisica, 'Deficiência intelectual'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_def_intelectual::int = 1 
union
select  co_pessoa_fisica, 'Deficiência multipla'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_def_multipla::int = 1 
union
select  co_pessoa_fisica, 'Autismo'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_autismo::int = 1 
union
select  co_pessoa_fisica, 'Superdotacao' ds_deficiencia
from censo_esc_d.tb_matricula -- COMPLEMENTO DA VARIAVEL QUE FALTOU NA BASE INEP
where in_superdotacao::int = 1 
)
,recurso as (
select co_pessoa_fisica,  'LEDOR'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_ledor = 1 union
select co_pessoa_fisica,  'TRANSCRICAO'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_transcricao = 1 union
select co_pessoa_fisica,  'INTERPRETE'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_interprete = 1 union
select co_pessoa_fisica,  'LIBRAS'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_libras = 1 union
select co_pessoa_fisica,  'LABIAL'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_labial = 1 union
select co_pessoa_fisica,  'AMPLIADA 18'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_ampliada_18 = 1 union
select co_pessoa_fisica,  'AMPLIADA 24'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_ampliada_24 = 1 union
select co_pessoa_fisica,  'CD AUDIO'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_cd_audio = 1 union
select co_pessoa_fisica,  'PROVA PORTUGUES'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_prova_portugues = 1 union
select co_pessoa_fisica,  'VIDEO LIBRAS'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_video_libras = 1 union
select co_pessoa_fisica,  'BRAILLE'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_braille = 1 union
select co_pessoa_fisica,  'NENHUM'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_nenhum = 1 
),
pessoa as (
select 
tb.co_pessoa_fisica,
tb.dt_nascimento,
tb.no_pessoa_fisica,
tb.no_mae,
tb.no_pai
from spaece_aplicacao_2022.tb_base_censo_escolar_estadual tb
group by 1,2,3,4,5
union 
select 
tb.co_pessoa_fisica,
tb.dt_nascimento,
tb.no_pessoa_fisica,
tb.no_mae,
tb.no_pai
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal tb
group by 1,2,3,4,5
)
-- BASE MUNICIPAL
select
co_orgao_regional  "ORGAO_REGIONAL",
id_crede_sefor "ID_CREDE_SEFOR",
nm_crede_sefor "NM_CREDE_SEFOR",
upper(nm_municipio)  "NM_MUNICIPIO",
id_municipio "ID_MUNICIPIO",
case when tec.tp_dependencia = 2 then 'ESTADUAL' else 'MUNICIPAL' end "DS_DEPENDENCIA",
case when tec.tp_localizacao = 1 then 'URBANO' else 'RURAL' end "DS_LOCALIZACAO",
tec.co_entidade "ID_ESCOLA",
tec.no_entidade "NM_ESCOLA",
null  "CATEGORIA",
no_turma "NM_TURMA",
tt.id_turma "ID_TURMA",
case when tt.tp_tipo_local_turma =  1 then 'Sala anexa'
     when tt.tp_tipo_local_turma  =  2 then 'Unidade de atendimento socioeducativo'
     when tt.tp_tipo_local_turma  =  3 then 'Unidade prisional' else '' end  "NM_EXTENSAO",
concat(tx_hr_inicial,':',tx_mi_inicial)::time "TX_HR_INICIAL",
concat(tx_hr_inicial,':',tx_mi_inicial)::time +  concat(bs.nu_duracao_turma::text,' minutes')::interval "TX_HR_FINAL",
case when bs.nu_duracao_turma < 420 then 'PARCIAL' else 'INTEGRAL' end "DS_TEMPO",
case when bs.nu_duracao_turma >= 420 then 4 else 
    case when concat(tx_hr_inicial,':',tx_mi_inicial)::time < '11:30:00'::time 
       and tx_hr_inicial::int<>1 then 1
      when (concat(tx_hr_inicial,':',tx_mi_inicial)::time > '11:30:00'::time 
         and concat(tx_hr_inicial,':',tx_mi_inicial)::time < '17:30:00'::time) 
         or tx_hr_inicial::int = 1 then 2
      when concat(tx_hr_inicial,':',tx_mi_inicial)::time > '17:30:00'::time then 3
         end end "CD_TURNO",
case when bs.nu_duracao_turma >= 420 then 'INTEGRAL' else 
    case when concat(tx_hr_inicial,':',tx_mi_inicial)::time < '11:30:00'::time 
       and tx_hr_inicial::int<>1 then 'MANHÃ'
      when (concat(tx_hr_inicial,':',tx_mi_inicial)::time > '11:30:00'::time 
         and concat(tx_hr_inicial,':',tx_mi_inicial)::time < '17:30:00'::time) 
         or tx_hr_inicial::int = 1 then 'TARDE'
      when concat(tx_hr_inicial,':',tx_mi_inicial)::time > '17:30:00'::time then 'NOITE' 
         end end"NM_TURNO",
tde_t.ds_etapa_ensino "DS_ETAPA_SERIE_TURMA",
tde_t.cd_etapa_ensino "TP_ETAPA_ENSINO_TURMA",
case when tt.in_regular = 1 then 'REGULAR' else 'EJA' end "DS_MODALIDADE",
'' "NM_CURSO_PROFISSIONAL",
tde_m.ds_ano_serie "DS_ETAPA_SERIE",
tde_m.cd_etapa_ensino "TP_ETAPA_ENSINO",
null "CD_ALUNO_SIGE",
bs.co_pessoa_fisica "CO_PESSOA_FISICA",
dt_nascimento "DT_NASCIMENTO",
bs.tp_sexo "CD_SEXO",
case when tp_sexo = 1 then 'MASCULINO' else 'FEMININO' end "DS_SEXO",
bs.tp_cor_raca "CD_COR_RACA",
case when tp_cor_raca = 0 then 'NÃO DECLARADA'
     when tp_cor_raca = 1 then 'BRANCA'
     when tp_cor_raca = 2 then 'PRETA'
     when tp_cor_raca = 3 then 'PARDA'
     when tp_cor_raca = 4 then 'AMARELA'
     when tp_cor_raca = 5 then 'INDÍGENA' end "DS_COR_RACA",
case when bs.in_necessidade_especial = 1 then 'SIM' else 'NÃO' end "DS_POSSUI_DEFICIENCIA",
string_agg(ds_deficiencia,', ')  "NM_DEFICIENCIA",
ps.no_pessoa_fisica "NM_ALUNO",
ps.no_mae "NM_MAE",
ps.no_pai "NM_PAI",
string_agg(ds_recurso,', ') "DS_RECURSO_AVALIACAO"
from censo_esc_d.tb_matricula bs
join pessoa ps on ps.co_pessoa_fisica = bs.co_pessoa_fisica 
join censo_esc_d.tb_turma tt on tt.id_turma = bs.id_turma 
join censo_esc_d.tb_escola tec on tec.co_entidade = bs.co_entidade 
join dw_censo.tb_dm_etapa tde_m on tde_m.cd_etapa_ensino = bs.tp_etapa_ensino 
join dw_censo.tb_dm_etapa tde_t on tde_t.cd_etapa_ensino = tt.tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = bs.co_municipio 
left join credes using(co_orgao_regional)
left join deficiencias def on bs.co_pessoa_fisica = def.co_pessoa_fisica
left join recurso rec on bs.co_pessoa_fisica = rec.co_pessoa_fisica
where tde_m.cd_ano_serie in (2,5,9) 
and bs.tp_dependencia in (2,3) --321558
group by  "ORGAO_REGIONAL","ID_CREDE_SEFOR","NM_CREDE_SEFOR","ID_MUNICIPIO","NM_MUNICIPIO","DS_DEPENDENCIA","DS_LOCALIZACAO","ID_ESCOLA","NM_ESCOLA","CATEGORIA","NM_TURMA","ID_TURMA","NM_EXTENSAO","TX_HR_INICIAL","TX_HR_FINAL","DS_TEMPO","CD_TURNO","NM_TURNO","DS_ETAPA_SERIE_TURMA","TP_ETAPA_ENSINO_TURMA","DS_MODALIDADE","NM_CURSO_PROFISSIONAL","DS_ETAPA_SERIE","TP_ETAPA_ENSINO","CD_ALUNO_SIGE","CO_PESSOA_FISICA","DT_NASCIMENTO","CD_SEXO","DS_SEXO","CD_COR_RACA","DS_COR_RACA","DS_POSSUI_DEFICIENCIA","NM_ALUNO","NM_MAE","NM_PAI"
--315601

# ACRESCIMO EM 18/11/2022 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

create table spaece_aplicacao_2022.tb_base_aplicacao_fundamental_retificada_acrescimo_1 as (
with indigena as (
select 
co_entidade,
1 fl_indigena
from censo_esc_d.tb_escola te  
where tp_situacao_funcionamento = 1
and in_educacao_indigena = 1 and tp_dependencia = 3
group by 1,2
),
credes as (
select 
tde.ds_orgao_regional co_orgao_regional,
id_crede_sefor,
nm_crede_sefor
from dw_censo.tb_dm_escola tde 
where tde.nr_ano_censo = 2020 and tde.nm_crede_sefor is not null
group by 1,2,3
),
deficiencias as(
select  co_pessoa_fisica, 'Baixa visão' ds_deficiencia 
from censo_esc_d.tb_matricula bs 
 where in_baixa_visao::int = 1 
union
select  co_pessoa_fisica, 'Cegueira'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_cegueira::int = 1 
union
select  co_pessoa_fisica,  'Deficiência auditiva'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_def_auditiva::int = 1
union
select  co_pessoa_fisica, 'Deficiência física'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_def_fisica::int = 1 
union
select  co_pessoa_fisica, 'Surdez'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_surdez::int = 1 
union
select  co_pessoa_fisica, 'Surdocegueira'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_surdocegueira::int = 1 
union
select  co_pessoa_fisica, 'Deficiência intelectual'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_def_intelectual::int = 1 
union
select  co_pessoa_fisica, 'Deficiência multipla'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_def_multipla::int = 1 
union
select  co_pessoa_fisica, 'Autismo'   ds_deficiencia
from censo_esc_d.tb_matricula bs 
 where in_autismo::int = 1 
union
select  co_pessoa_fisica, 'Superdotacao' ds_deficiencia
from censo_esc_d.tb_matricula -- COMPLEMENTO DA VARIAVEL QUE FALTOU NA BASE INEP
where in_superdotacao::int = 1 
)
,recurso as (
select co_pessoa_fisica,  'LEDOR'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_ledor = 1 union
select co_pessoa_fisica,  'TRANSCRICAO'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_transcricao = 1 union
select co_pessoa_fisica,  'INTERPRETE'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_interprete = 1 union
select co_pessoa_fisica,  'LIBRAS'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_libras = 1 union
select co_pessoa_fisica,  'LABIAL'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_labial = 1 union
select co_pessoa_fisica,  'AMPLIADA 18'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_ampliada_18 = 1 union
select co_pessoa_fisica,  'AMPLIADA 24'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_ampliada_24 = 1 union
select co_pessoa_fisica,  'CD AUDIO'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_cd_audio = 1 union
select co_pessoa_fisica,  'PROVA PORTUGUES'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_prova_portugues = 1 union
select co_pessoa_fisica,  'VIDEO LIBRAS'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_video_libras = 1 union
select co_pessoa_fisica,  'BRAILLE'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_braille = 1 union
select co_pessoa_fisica,  'NENHUM'   ds_recurso from censo_esc_d.tb_matricula  where in_recurso_nenhum = 1 
),

alvo as (
select co_pessoa_fisica, co_entidade,
to_char(concat(nu_ano,'-',nu_mes,'-',nu_dia)::date,'dd/mm/yyyy') dt_nascimento
from censo_esc_d.tb_matricula bs
join dw_censo.tb_dm_etapa tde_m on tde_m.cd_etapa_ensino = bs.tp_etapa_ensino 
where tde_m.cd_ano_serie in (2,5,9) 
and bs.tp_dependencia in (2,3) -- and bs.co_pessoa_fisica = 150040803480
and not exists (select 1 from spaece_aplicacao_2022.tb_base_aplicacao_fundamental_retificada s where s."CO_PESSOA_FISICA"  = bs.co_pessoa_fisica)
)
,pessoa_1 as (
select --682 --495
bs.co_pessoa_fisica,
bs.dt_nascimento,
bs.no_pessoa_fisica,
bs.no_filiacao_1 no_mae,
bs.no_filiacao_2 no_pai
from censo_esc_ce.tb_pessoa_fisica_2021_d bs 
join alvo a on a.co_pessoa_fisica = bs.co_pessoa_fisica 
)
,pessoa_2 as (
select --682 --495
bs.co_pessoa_fisica,
bs.dt_nascimento,
bs.no_pessoa_fisica,
no_mae,
no_pai
from censo_esc_ce.tb_pessoa_fisica_d bs 
join alvo a on a.co_pessoa_fisica = bs.co_pessoa_fisica 
and not exists (select 1 from  pessoa_1 d where d.co_pessoa_fisica = bs.co_pessoa_fisica)
)
,pessoa_3 as (
select --682 --495
bs.co_pessoa_fisica,
dt_nascimento,
bs.no_pessoa_fisica,
no_mae,
no_pai
from censo_esc_ce.tb_pessoa_fisica_2019 bs 
join alvo a on a.co_pessoa_fisica = bs.co_pessoa_fisica 
where not exists (select 1 from  pessoa_1 d where d.co_pessoa_fisica = bs.co_pessoa_fisica)
and not exists (select 1 from  pessoa_2 d2 where d2.co_pessoa_fisica = bs.co_pessoa_fisica)
)
,pessoa as (
select * from pessoa_1
union 
select * from pessoa_2
union 
select * from pessoa_3
union
select --682 --495
co_pessoa_fisica,
dt_nascimento,
sp.nm_aluno no_pessoa_fisica,
null no_mae,
null no_pai
from spaece.tb_spaece_2022_lp_mt_diagnostica sp 
join alvo a on  a.co_pessoa_fisica::text = sp.cd_aluno_publicacao --and   a.co_entidade = sp.cd_escola 
where not exists (select 1 from  pessoa_1 d where d.co_pessoa_fisica::text = sp.cd_aluno_publicacao )
and not exists (select 1 from  pessoa_2 d2 where d2.co_pessoa_fisica::text = sp.cd_aluno_publicacao )
and not exists (select 1 from  pessoa_3 d3 where d3.co_pessoa_fisica::text = sp.cd_aluno_publicacao )
group by 1,2,3,4
) 
-- BASE MUNICIPAL
select 
co_orgao_regional  "ORGAO_REGIONAL",
id_crede_sefor "ID_CREDE_SEFOR",
nm_crede_sefor "NM_CREDE_SEFOR",
upper(nm_municipio)  "NM_MUNICIPIO",
id_municipio "ID_MUNICIPIO",
case when tec.tp_dependencia = 2 then 'ESTADUAL' else 'MUNICIPAL' end "DS_DEPENDENCIA",
case when tec.tp_localizacao = 1 then 'URBANO' else 'RURAL' end "DS_LOCALIZACAO",
tec.co_entidade "ID_ESCOLA",
tec.no_entidade "NM_ESCOLA",
null  "CATEGORIA",
no_turma "NM_TURMA",
tt.id_turma "ID_TURMA",
case when tt.tp_tipo_local_turma =  1 then 'Sala anexa'
     when tt.tp_tipo_local_turma  =  2 then 'Unidade de atendimento socioeducativo'
     when tt.tp_tipo_local_turma  =  3 then 'Unidade prisional' else '' end  "NM_EXTENSAO",
concat(tx_hr_inicial,':',tx_mi_inicial)::time "TX_HR_INICIAL",
concat(tx_hr_inicial,':',tx_mi_inicial)::time +  concat(bs.nu_duracao_turma::text,' minutes')::interval "TX_HR_FINAL",
case when bs.nu_duracao_turma < 420 then 'PARCIAL' else 'INTEGRAL' end "DS_TEMPO",
case when bs.nu_duracao_turma >= 420 then 4 else 
    case when concat(tx_hr_inicial,':',tx_mi_inicial)::time < '11:30:00'::time 
       and tx_hr_inicial::int<>1 then 1
      when (concat(tx_hr_inicial,':',tx_mi_inicial)::time > '11:30:00'::time 
         and concat(tx_hr_inicial,':',tx_mi_inicial)::time < '17:30:00'::time) 
         or tx_hr_inicial::int = 1 then 2
      when concat(tx_hr_inicial,':',tx_mi_inicial)::time > '17:30:00'::time then 3
         end end "CD_TURNO",
case when bs.nu_duracao_turma >= 420 then 'INTEGRAL' else 
    case when concat(tx_hr_inicial,':',tx_mi_inicial)::time < '11:30:00'::time 
       and tx_hr_inicial::int<>1 then 'MANHÃ'
      when (concat(tx_hr_inicial,':',tx_mi_inicial)::time > '11:30:00'::time 
         and concat(tx_hr_inicial,':',tx_mi_inicial)::time < '17:30:00'::time) 
         or tx_hr_inicial::int = 1 then 'TARDE'
      when concat(tx_hr_inicial,':',tx_mi_inicial)::time > '17:30:00'::time then 'NOITE' 
         end end"NM_TURNO",
tde_t.ds_etapa_ensino "DS_ETAPA_SERIE_TURMA",
tde_t.cd_etapa_ensino "TP_ETAPA_ENSINO_TURMA",
case when tt.in_regular = 1 then 'REGULAR' else 'EJA' end "DS_MODALIDADE",
'' "NM_CURSO_PROFISSIONAL",
tde_m.ds_ano_serie "DS_ETAPA_SERIE",
tde_m.cd_etapa_ensino "TP_ETAPA_ENSINO",
null "CD_ALUNO_SIGE",
bs.co_pessoa_fisica "CO_PESSOA_FISICA",
to_char(concat(nu_ano,'-',nu_mes,'-',nu_dia)::date,'dd/mm/yyyy') "DT_NASCIMENTO",
bs.tp_sexo "CD_SEXO",
case when tp_sexo = 1 then 'MASCULINO' else 'FEMININO' end "DS_SEXO",
bs.tp_cor_raca "CD_COR_RACA",
case when tp_cor_raca = 0 then 'NÃO DECLARADA'
     when tp_cor_raca = 1 then 'BRANCA'
     when tp_cor_raca = 2 then 'PRETA'
     when tp_cor_raca = 3 then 'PARDA'
     when tp_cor_raca = 4 then 'AMARELA'
     when tp_cor_raca = 5 then 'INDÍGENA' end "DS_COR_RACA",
case when bs.in_necessidade_especial = 1 then 'SIM' else 'NÃO' end "DS_POSSUI_DEFICIENCIA",
string_agg(ds_deficiencia,', ')  "NM_DEFICIENCIA",
ps.no_pessoa_fisica "NM_ALUNO",
ps.no_mae "NM_MAE",
ps.no_pai "NM_PAI",
string_agg(ds_recurso,', ') "DS_RECURSO_AVALIACAO" 
from censo_esc_d.tb_matricula bs
left join pessoa ps on ps.co_pessoa_fisica = bs.co_pessoa_fisica 
join censo_esc_d.tb_turma tt on tt.id_turma = bs.id_turma 
join censo_esc_d.tb_escola tec on tec.co_entidade = bs.co_entidade 
join dw_censo.tb_dm_etapa tde_m on tde_m.cd_etapa_ensino = bs.tp_etapa_ensino 
join dw_censo.tb_dm_etapa tde_t on tde_t.cd_etapa_ensino = tt.tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = bs.co_municipio 
left join credes using(co_orgao_regional)
left join deficiencias def on bs.co_pessoa_fisica = def.co_pessoa_fisica
left join recurso rec on bs.co_pessoa_fisica = rec.co_pessoa_fisica
where tde_m.cd_ano_serie in (2,5,9) 
and bs.tp_dependencia in (2,3) --321558
and not exists (select 1 from spaece_aplicacao_2022.tb_base_aplicacao_fundamental_retificada s where s."CO_PESSOA_FISICA"  = bs.co_pessoa_fisica)
group by  "ORGAO_REGIONAL","ID_CREDE_SEFOR","NM_CREDE_SEFOR","ID_MUNICIPIO","NM_MUNICIPIO","DS_DEPENDENCIA","DS_LOCALIZACAO","ID_ESCOLA","NM_ESCOLA","CATEGORIA",
"NM_TURMA","ID_TURMA","NM_EXTENSAO","TX_HR_INICIAL","TX_HR_FINAL","DS_TEMPO","CD_TURNO","NM_TURNO","DS_ETAPA_SERIE_TURMA","TP_ETAPA_ENSINO_TURMA","DS_MODALIDADE",
"NM_CURSO_PROFISSIONAL","DS_ETAPA_SERIE","TP_ETAPA_ENSINO","CD_ALUNO_SIGE","CO_PESSOA_FISICA","DT_NASCIMENTO","CD_SEXO","DS_SEXO","CD_COR_RACA","DS_COR_RACA",
"DS_POSSUI_DEFICIENCIA","NM_ALUNO","NM_MAE","NM_PAI"
)