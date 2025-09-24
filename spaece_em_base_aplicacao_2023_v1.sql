with 
turmas as (
select *, 
case when cd_turno = 4 then 1
when cd_turno = 1 then 2
when cd_turno = 2 then 3
when cd_turno = 5 then 4 end cd_turno_c
from academico.tb_turma tt
join (select ci_turno, ds_turno from academico.tb_turno) as tn on tn.ci_turno = tt.cd_turno 
where nr_anoletivo = 2023
and cd_nivel = 27 --and tt.dt_horainicio 
and cd_prefeitura= 0 
and cd_etapa not in (173,174) --retirar turmas semi-presenciais
and ((tt.cd_etapa=214 or tt.cd_anofinaleja=2) or cd_etapa in (164,190,186)) --and ci_turma =822564
) --select cd_etapa, count(1) from turmas group by 1
,extensao as (
select
     tt.ci_turma, 
     tlf.nm_local_funcionamento,
     tlf.ci_local_funcionamento,
     cd_tipo_local,
     1 fl_anexo
     from turmas tt
     join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
     join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
     join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = lut.cd_local_funcionamento 
     where tt.nr_anoletivo = 2023
     and lut.fl_sede = false
     and cd_nivel =27
     and tt.cd_prefeitura = 0
     --and tlf.cd_tipo_local not in (4,3) -- retira os anexo em sistemas prisionais
     group by 1,2,3,4
),
 credes as (
SELECT 
tut.ci_unidade_trabalho id_crede_sefor, 
upper(tut.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio_crede
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.ci_unidade_trabalho between 1 and 23
AND tlut.fl_sede = TRUE 
)
,escolas as (
SELECT
id_crede_sefor, 
nm_crede_sefor, 
tmc.ci_municipio_censo,
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria)  AS ds_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao
FROM rede_fisica.tb_unidade_trabalho tut
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join credes c on tut.cd_unidade_trabalho_pai  = id_crede_sefor
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = TRUE 
and tut.cd_categoria <> 6
--and tut.categoria not in (13,7) -- escolas regulares
--and tut.categoria = 7  -- escolas indigenas
--and tut.cd_categoria = 13-- escolas quilombolas
) --select * from escolas --754
,enturmacao as (
select 
cd_aluno,cd_turma
from academico.tb_ultimaenturmacao tu 
where exists (select 1 from turmas t where ci_turma = cd_turma)
and tu.fl_tipo_atividade <> 'AC'
)
,alunos as (
select 
-- variaveis CAED
ci_aluno,
nm_aluno,
ta2.cd_inep_aluno,
ta2.dt_nascimento,
case when fl_sexo = 'M' then 1 else 2 end cd_sexo,
case when fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo,
nm_mae,
nm_pai,
ta2.cd_raca,
tr.ds_raca,
case when def.cd_deficiencia is null then 'Não' else 'Sim' end ds_possui_deficiencia,
string_agg(d.nm_deficiencia ,', ' ) nm_deficiencia ,
--ar.cd_recurso_avaliacao,
string_agg(
case 
    when ar.cd_recurso_avaliacao = 1 then 'Auxílio ledor'
      when ar.cd_recurso_avaliacao = 2 then 'Auxílio transcrição'
      when ar.cd_recurso_avaliacao = 3 then 'Guia-Intérprete'
      when ar.cd_recurso_avaliacao = 4 then 'Intérprete de Libras'
      when ar.cd_recurso_avaliacao = 5 then 'Leitura Labial'
      when ar.cd_recurso_avaliacao = 6 then 'Prova Ampliada (fonte 16)'
      when ar.cd_recurso_avaliacao = 7 then 'Prova Ampliada (fonte 20)'
      when ar.cd_recurso_avaliacao = 8 then 'Prova Ampliada (fonte 24)'
      when ar.cd_recurso_avaliacao = 9 then 'Prova em braile' end, ', ') ds_recurso_avaliacao
from academico.tb_aluno ta2 
left join academico.tb_raca tr on tr.ci_raca = ta2.cd_raca
left join academico.tb_aluno_deficiencia def on def.cd_aluno = ci_aluno 
left join academico.tb_deficiencia d on def.cd_deficiencia = ci_deficiencia
left join academico.tb_aluno_recurso_espec_aval ar on ar.cd_aluno = ta2.ci_aluno 
where exists (select 1 from enturmacao e where ci_aluno = e.cd_aluno ) --and cd_deficiencia is not null
group by 1,2,3,4,5,6,7,8,9,10,11
) --select count(1) nr_linha, count(distinct ci_aluno) from alunos
select  --1 /*
'Ceará' "NM_UF",
id_crede_sefor as "CD_REGIONAL",
nm_crede_sefor "NM_REGIONAL",
ci_municipio_censo "CD_MUNICIPIO",
nm_municipio"NM_MUNICIPIO",
id_escola_inep "CD_ESCOLA",
nm_escola "NM_ESCOLA",
'Estadual' "DC_REDE_ENSINO",
ds_localizacao as "DC_LOCALIZACAO",
t.ci_turma "CD_TURMA",
ds_turma "NM_TURMA",
case when (t.cd_etapa=214 or t.cd_anofinaleja=2) then 'EJA Ensino Médio ano II'
      when cd_etapa in (164,190,186) then '3ª SÉRIE EM' end "DC_ETAPA",
case when (t.cd_etapa=214 or t.cd_anofinaleja=2) then 'EJA'
      when cd_etapa in (164,190,186) then 'Regular' end "DC_TIPO_ENSINO",
ds_turno "DC_TURNO",
'--' "NM_PROFESSOR",
0 "FL_MULTISSERIADA",
coalesce(fl_anexo,0) "FL_ANEXO",
nm_local_funcionamento "NM_ANEXO",
ci_aluno "CD_INSTITUCIONAL_ALUNO",
cd_inep_aluno  "CD_INEP_ALUNO",
nm_aluno "NM_ALUNO",
dt_nascimento  "DT_NASCIMENTO",
ds_sexo  "DC_SEXO",
nm_deficiencia "TP_DEFICIENCIA",
nm_mae "NM_MAE_ALUNO",
-- variaveis propostas COADE 
cd_raca as "CD_COR_RACA",
ds_raca as "DS_COR_RACA",
nm_pai as "NM_PAI_ALUNO",
ds_recurso_avaliacao as "DS_RECURSO_AVALIACAO"
from enturmacao et
inner join turmas t on et.cd_turma = t.ci_turma
inner join alunos a on a.ci_aluno = et.cd_aluno
inner join escolas e on e.id_escola_sige = t.cd_unidade_trabalho
left join extensao ex on  t.ci_turma = ex.ci_turma
where 
not exists (select 1 from extensao ex2 where ex2.ci_turma = t.ci_turma and cd_tipo_local in (3,4) ) -- retira os anexo em sistemas prisionais
