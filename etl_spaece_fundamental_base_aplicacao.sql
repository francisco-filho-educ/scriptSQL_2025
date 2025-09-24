with indigena as (
select 
co_entidade,
1 fl_indigena
from censo_esc_ce.tb_escola_2021_d ted 
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
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal bs 
 where in_baixa_visao::int = 1 
union
select  co_pessoa_fisica, 'Cegueira'   ds_deficiencia
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal bs 
 where in_cegueira::int = 1 
union
select  co_pessoa_fisica,  'Deficiência auditiva'   ds_deficiencia
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal bs 
 where in_def_auditiva::int = 1
union
select  co_pessoa_fisica, 'Deficiência física'   ds_deficiencia
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal bs 
 where in_def_fisica::int = 1 
union
select  co_pessoa_fisica, 'Surdez'   ds_deficiencia
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal bs 
 where in_surdez::int = 1 
union
select  co_pessoa_fisica, 'Surdocegueira'   ds_deficiencia
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal bs 
 where in_surdocegueira::int = 1 
union
select  co_pessoa_fisica, 'Deficiência intelectual'   ds_deficiencia
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal bs 
 where in_def_intelectual::int = 1 
union
select  co_pessoa_fisica, 'Deficiência multipla'   ds_deficiencia
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal bs 
 where in_def_multipla::int = 1 
union
select  co_pessoa_fisica, 'Autismo'   ds_deficiencia
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal bs 
 where in_autismo::int = 1 
union
select  co_pessoa_fisica, 'Superdotacao' ds_deficiencia
from censo_esc_ce.tb_matricula_2021_d -- COMPLEMENTO DA VARIAVEL QUE FALTOU NA BASE INEP
where in_superdotacao::int = 1 
)
,recurso as (
select co_pessoa_fisica,  'LEDOR'   ds_recurso from spaece_aplicacao_2022.tb_base_censo_escolar_municipal  where in_recurso_ledor = 1 union
select co_pessoa_fisica,  'TRANSCRICAO'   ds_recurso from spaece_aplicacao_2022.tb_base_censo_escolar_municipal  where in_recurso_transcricao = 1 union
select co_pessoa_fisica,  'INTERPRETE'   ds_recurso from spaece_aplicacao_2022.tb_base_censo_escolar_municipal  where in_recurso_interprete = 1 union
select co_pessoa_fisica,  'LIBRAS'   ds_recurso from spaece_aplicacao_2022.tb_base_censo_escolar_municipal  where in_recurso_libras = 1 union
select co_pessoa_fisica,  'LABIAL'   ds_recurso from spaece_aplicacao_2022.tb_base_censo_escolar_municipal  where in_recurso_labial = 1 union
select co_pessoa_fisica,  'AMPLIADA 18'   ds_recurso from spaece_aplicacao_2022.tb_base_censo_escolar_municipal  where in_recurso_ampliada_18 = 1 union
select co_pessoa_fisica,  'AMPLIADA 24'   ds_recurso from spaece_aplicacao_2022.tb_base_censo_escolar_municipal  where in_recurso_ampliada_24 = 1 union
select co_pessoa_fisica,  'CD AUDIO'   ds_recurso from spaece_aplicacao_2022.tb_base_censo_escolar_municipal  where in_recurso_cd_audio = 1 union
select co_pessoa_fisica,  'PROVA PORTUGUES'   ds_recurso from spaece_aplicacao_2022.tb_base_censo_escolar_municipal  where in_recurso_prova_portugues = 1 union
select co_pessoa_fisica,  'VIDEO LIBRAS'   ds_recurso from spaece_aplicacao_2022.tb_base_censo_escolar_municipal  where in_recurso_video_libras = 1 union
select co_pessoa_fisica,  'BRAILLE'   ds_recurso from spaece_aplicacao_2022.tb_base_censo_escolar_municipal  where in_recurso_braille = 1 union
select co_pessoa_fisica,  'NENHUM'   ds_recurso from spaece_aplicacao_2022.tb_base_censo_escolar_municipal  where in_recurso_nenhum = 1 
)
-- BASE MUNICIPAL
select 
bs.co_orgao_regional  "ORGAO_REGIONAL",
id_crede_sefor "ID_CREDE_SEFOR",
nm_crede_sefor "NM_CREDE_SEFOR",
upper(nm_municipio)  "NM_MUNICIPIO",
id_municipio "ID_MUNICIPIO",
case when tp_dependencia = 2 then 'ESTADUAL' else 'MUNICIPAL' end "DS_DEPENDENCIA",
case when tp_localizacao = 1 then 'URBANO' else 'RURAL' end "DS_LOCALIZACAO",
bs.co_entidade "ID_ESCOLA",
bs.no_entidade "NM_ESCOLA",
null  "CATEGORIA",
no_turma "NM_TURMA",
id_turma "ID_TURMA",
case when bs.tp_tipo_local_turma =  1 then 'Sala anexa'
     when bs.tp_tipo_local_turma  =  2 then 'Unidade de atendimento socioeducativo'
     when bs.tp_tipo_local_turma  =  3 then 'Unidade prisional' else '' end  "NM_EXTENSAO",
concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time "TX_HR_INICIAL",
concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time +  concat(bs.nu_duracao_turma::text,' minutes')::interval "TX_HR_FINAL",
case when bs.nu_duracao_turma < 420 then 'PARCIAL' else 'INTEGRAL' end "DS_TEMPO",
case when bs.nu_duracao_turma >= 420 then 4 else 
    case when concat(tx_hr_inicial,':',tx_mi_inicial)::time < '11:30:00'::time 
       and tx_hr_inicial::int<>1 then 1
      when (concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time > '11:30:00'::time 
         and concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time < '17:30:00'::time) 
         or bs.tx_hr_inicial::int = 1 then 2
      when concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time > '17:30:00'::time then 3
         end end "CD_TURNO",
case when bs.nu_duracao_turma >= 420 then 'INTEGRAL' else 
    case when concat(tx_hr_inicial,':',tx_mi_inicial)::time < '11:30:00'::time 
       and tx_hr_inicial::int<>1 then 'MANHÃ'
      when (concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time > '11:30:00'::time 
         and concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time < '17:30:00'::time) 
         or bs.tx_hr_inicial::int = 1 then 'TARDE'
      when concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time > '17:30:00'::time then 'NOITE' 
         end end"NM_TURNO",
tde_t.ds_etapa_ensino "DS_ETAPA_SERIE_TURMA",
tde_t.cd_etapa_ensino "TP_ETAPA_ENSINO_TURMA",
case when in_regular = 1 then 'REGULAR' else 'EJA' end "DS_MODALIDADE",
'' "NM_CURSO_PROFISSIONAL",
tde_m.ds_ano_serie "DS_ETAPA_SERIE",
tde_m.cd_etapa_ensino "TP_ETAPA_ENSINO",
null "CD_ALUNO_SIGE",
bs.co_pessoa_fisica "CO_PESSOA_FISICA",
bs.dt_nascimento "DT_NASCIMENTO",
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
bs.no_pessoa_fisica "NM_ALUNO",
bs.no_mae "NM_MAE",
bs.no_pai "NM_PAI",
string_agg(ds_recurso,', ') "DS_RECURSO_AVALIACAO"
from spaece_aplicacao_2022.tb_base_censo_escolar_municipal bs
join dw_censo.tb_dm_etapa tde_m on tde_m.cd_etapa_ensino = bs.tp_etapa_ensino_matricula 
join dw_censo.tb_dm_etapa tde_t on tde_t.cd_etapa_ensino = bs.tp_etapa_ensino_turma 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = bs.co_municipio 
left join credes using(co_orgao_regional)
left join deficiencias def on bs.co_pessoa_fisica = def.co_pessoa_fisica
left join recurso rec on bs.co_pessoa_fisica = rec.co_pessoa_fisica
where tde_m.cd_ano_serie in (2,5,9) 
group by  "ORGAO_REGIONAL","ID_CREDE_SEFOR","NM_CREDE_SEFOR","ID_MUNICIPIO","NM_MUNICIPIO","DS_DEPENDENCIA","DS_LOCALIZACAO","ID_ESCOLA","NM_ESCOLA","CATEGORIA","NM_TURMA","ID_TURMA","NM_EXTENSAO","TX_HR_INICIAL","TX_HR_FINAL","DS_TEMPO","CD_TURNO","NM_TURNO","DS_ETAPA_SERIE_TURMA","TP_ETAPA_ENSINO_TURMA","DS_MODALIDADE","NM_CURSO_PROFISSIONAL","DS_ETAPA_SERIE","TP_ETAPA_ENSINO","CD_ALUNO_SIGE","CO_PESSOA_FISICA","DT_NASCIMENTO","CD_SEXO","DS_SEXO","CD_COR_RACA","DS_COR_RACA","DS_POSSUI_DEFICIENCIA","NM_ALUNO","NM_MAE","NM_PAI"
---
--- BASE ESTADUAL --------------
UNION
select 
bs.co_orgao_regional  "ORGAO_REGIONAL",
id_crede_sefor "ID_CREDE_SEFOR",
nm_crede_sefor "NM_CREDE_SEFOR",
upper(nm_municipio)  "NM_MUNICIPIO",
id_municipio "ID_MUNICIPIO",
case when tp_dependencia = 2 then 'ESTADUAL' else 'MUNICIPAL' end "DS_DEPENDENCIA",
case when tp_localizacao = 1 then 'URBANO' else 'RURAL' end "DS_LOCALIZACAO",
bs.co_entidade "ID_ESCOLA",
bs.no_entidade "NM_ESCOLA",
null  "CATEGORIA",
no_turma "NM_TURMA",
id_turma "ID_TURMA",
case when bs.tp_tipo_local_turma =  1 then 'Sala anexa'
     when bs.tp_tipo_local_turma  =  2 then 'Unidade de atendimento socioeducativo'
     when bs.tp_tipo_local_turma  =  3 then 'Unidade prisional' else '' end  "NM_EXTENSAO",
concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time "TX_HR_INICIAL",
concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time +  concat(bs.nu_duracao_turma::text,' minutes')::interval "TX_HR_FINAL",
case when bs.nu_duracao_turma < 420 then 'PARCIAL' else 'INTEGRAL' end "DS_TEMPO",
case when bs.nu_duracao_turma >= 420 then 4 else 
    case when concat(tx_hr_inicial,':',tx_mi_inicial)::time < '11:30:00'::time 
       and tx_hr_inicial::int<>1 then 1
      when (concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time > '11:30:00'::time 
         and concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time < '17:30:00'::time) 
         or bs.tx_hr_inicial::int = 1 then 2
      when concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time > '17:30:00'::time then 3
         end end "CD_TURNO",
case when bs.nu_duracao_turma >= 420 then 'INTEGRAL' else 
    case when concat(tx_hr_inicial,':',tx_mi_inicial)::time < '11:30:00'::time 
       and tx_hr_inicial::int<>1 then 'MANHÃ'
      when (concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time > '11:30:00'::time 
         and concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time < '17:30:00'::time) 
         or bs.tx_hr_inicial::int = 1 then 'TARDE'
      when concat(bs.tx_hr_inicial,':',bs.tx_mi_inicial)::time > '17:30:00'::time then 'NOITE' 
         end end"NM_TURNO",
tde_t.ds_etapa_ensino "DS_ETAPA_SERIE_TURMA",
tde_t.cd_etapa_ensino "TP_ETAPA_ENSINO_TURMA",
case when in_regular = 1 then 'REGULAR' else 'EJA' end "DS_MODALIDADE",
'' "NM_CURSO_PROFISSIONAL",
tde_m.ds_ano_serie "DS_ETAPA_SERIE",
tde_m.cd_etapa_ensino "TP_ETAPA_ENSINO",
null "CD_ALUNO_SIGE",
bs.co_pessoa_fisica "CO_PESSOA_FISICA",
bs.dt_nascimento "DT_NASCIMENTO",
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
bs.no_pessoa_fisica "NM_ALUNO",
bs.no_mae "NM_MAE",
bs.no_pai "NM_PAI",
string_agg(ds_recurso,', ') "DS_RECURSO_AVALIACAO"
from spaece_aplicacao_2022.tb_base_censo_escolar_estadual bs
join dw_censo.tb_dm_etapa tde_m on tde_m.cd_etapa_ensino = bs.tp_etapa_ensino_matricula 
join dw_censo.tb_dm_etapa tde_t on tde_t.cd_etapa_ensino = bs.tp_etapa_ensino_turma 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = bs.co_municipio 
left join credes using(co_orgao_regional)
left join deficiencias def on bs.co_pessoa_fisica = def.co_pessoa_fisica
left join recurso rec on bs.co_pessoa_fisica = rec.co_pessoa_fisica
where tde_m.cd_ano_serie in (2,5,9) 
group by  "ORGAO_REGIONAL","ID_CREDE_SEFOR","NM_CREDE_SEFOR","ID_MUNICIPIO","NM_MUNICIPIO","DS_DEPENDENCIA","DS_LOCALIZACAO","ID_ESCOLA","NM_ESCOLA","CATEGORIA","NM_TURMA","ID_TURMA","NM_EXTENSAO","TX_HR_INICIAL","TX_HR_FINAL","DS_TEMPO","CD_TURNO","NM_TURNO","DS_ETAPA_SERIE_TURMA","TP_ETAPA_ENSINO_TURMA","DS_MODALIDADE","NM_CURSO_PROFISSIONAL","DS_ETAPA_SERIE","TP_ETAPA_ENSINO","CD_ALUNO_SIGE","CO_PESSOA_FISICA","DT_NASCIMENTO","CD_SEXO","DS_SEXO","CD_COR_RACA","DS_COR_RACA","DS_POSSUI_DEFICIENCIA","NM_ALUNO","NM_MAE","NM_PAI"
/*
 * OBS: apos a carga, é necessário fazer uma busca no sige para localizar o código do aluno sige
 */

drop table if exists public.tb_infrequencia_escola;
create table public.tb_infrequencia_escola  as (
with 
turmas as (
   select * from academico.tb_turma tt
   where
tt.nr_anoletivo = 2022
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
                  and tut.cd_dependencia_administrativa = 2
                  )
                  
),
enturmados as (
select 
cd_aluno, cd_turma
from academico.tb_ultimaenturmacao tu 
where 
nr_anoletivo = 2022
and fl_tipo_atividade <> 'AC'
and exists (select 1 from turmas where cd_turma = ci_turma)
)

,disciplinas as (
select 
td.ci_disciplina,td.cd_grupodisciplina
from academico.tb_disciplinas td 
where td.fl_possui_avaliacao  ilike 'S'
and td.cd_prefeitura = 0
and td.cd_grupodisciplina between 1 and 14
)
,aulas as (
   select 
   cd_turma,
   af.nr_mes,
   af.cd_disciplina, 
   sum(coalesce(nr_aulas,0)) nr_aulas 
   from academico.tb_alunofrequencia_total_aulas_mes af
   where exists(select 1 from disciplinas where ci_disciplina = cd_disciplina  )
   and exists(select 1 from turmas where cd_turma = ci_turma  )
   group by 1,2,3
) 
,
faltas as (
   select cd_aluno, cd_turma, nr_mes,af.cd_disciplina , max(nr_faltas) nr_faltas
   from academico.tb_alunofrequencia af
   where exists(select 1 from enturmados  t where t.cd_turma=af.cd_turma and t.cd_aluno = af.cd_aluno)
   and exists(select 1 from disciplinas where ci_disciplina = cd_disciplina  )
   group by 1,2,3,4
)
select
et.cd_turma,
et.cd_aluno,
a.nr_mes,
a.cd_disciplina,
cd_grupodisciplina,
sum(nr_aulas) nr_aulas,
sum(nr_faltas) nr_faltas
from enturmados et
join aulas a on a.cd_turma = et.cd_turma
join disciplinas td2 on ci_disciplina = a.cd_disciplina
left join faltas f on et.cd_turma=f.cd_turma and f.cd_disciplina = a.cd_disciplina and a.nr_mes = f.nr_mes and f.cd_aluno = et.cd_aluno
group by 1,2,3,4,5
);


drop table if exists public.tb_infrequencia_escola_sum;
create table public.tb_infrequencia_escola_sum  as (
select
cd_turma,
cd_aluno,
nr_mes,
cd_grupodisciplina,
sum(nr_aulas) nr_aulas,
sum(nr_faltas) nr_faltas
from  public.tb_infrequencia_escola
group by 1,2,3,4
);



with 
mat as (
   select 
nr_anoletivo,
cd_unidade_trabalho,
ci_turma cd_turma,
ds_turma,
cd_etapa,
ds_etapa,
cd_turno,
ds_turno,
cd_grupodisciplina,
ds_grupodisciplina,
cd_aluno,
nr_aulas,
nr_faltas
   from academico.tb_turma tt
   join public.tb_infrequencia_escola_sum fm on fm.cd_turma = tt.ci_turma
   join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina = fm.cd_grupodisciplina
   join academico.tb_turno tt2 on ci_turno = cd_turno 
   join academico.tb_etapa te on te.ci_etapa = cd_etapa
   where
tt.nr_anoletivo = 2022
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
                  and tut.cd_dependencia_administrativa = 2
                  )
                  
)
SELECT 
2022 nr_ano_sige,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
tmc.ci_municipio_censo id_municipio,
upper(tmc.nm_municipio) AS nm_municipio,
case when tut.cd_categoria is not null then upper(tc.nm_categoria) 
           else upper(nm_tipo_unid_trab) end AS ds_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
cd_turma,
ds_turma,
cd_etapa,
ds_etapa,
cd_turno,
ds_turno,
cd_aluno,
cd_grupodisciplina,
ds_grupodisciplina,
nr_aulas,
nr_faltas
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
left JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
left JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
left join rede_fisica.tb_tipo_unid_trab ttut on ttut.ci_tipo_unid_trab = tut.cd_tipo_unid_trab 
left join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tlut.fl_sede = TRUE 
and tut.cd_dependencia_administrativa = 2