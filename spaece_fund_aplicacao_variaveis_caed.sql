--- LISTA DE ACORDO COM AS VARIAVEIS DO CAED
with turmas as (
select *, 
case when cd_turno = 4 then 1
when cd_turno = 1 then 2
when cd_turno = 2 then 3
when cd_turno = 5 then 4 end cd_turno_c
from academico.tb_turma tt
join (select ci_turno, ds_turno from academico.tb_turno) as tn on tn.ci_turno = tt.cd_turno 
where nr_anoletivo = 2023
and cd_nivel = 26 --and tt.dt_horainicio 
and cd_prefeitura= 0 
and tt.cd_modalidade <> 37
) 
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
     --and tlf.cd_tipo_local not in (4,3) -- retira os anexo em sistemas prisionais
     group by 1,2,3,4
)
,enturmacao_i as (
select 
cd_aluno,
cd_turma,
cd_etapa
from academico.tb_ultimaenturmacao tu 
join (select ci_turma, cd_etapa from turmas) as t on  ci_turma = cd_turma
and tu.fl_tipo_atividade <> 'AC'
)
 ,mult  as(
select
tm.cd_turma,
tm.cd_aluno,
ti.cd_etapa
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
join enturmacao_i ut using(cd_turma,cd_aluno)
where 
tm.nr_anoletivo = 2023
and ti.cd_prefeitura = 0
and ti.cd_etapa in (select * from etapa_alvo)
)
--select count(1) from mult
,enturmacao as (
select 
cd_aluno,
cd_turma,
cd_etapa
from enturmacao_i eti 
where eti.cd_etapa in (select * from etapa_alvo)
union  
select 
cd_aluno,
cd_turma,
cd_etapa
from mult 
) 
/*
select 
count(1)
from enturmacao  a
where a.cd_aluno not in (select cd_aluno  from public.tb_dm_etapa_aluno_2023_06_01 s )
*/
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
where exists (select 1 from enturmacao e where ci_aluno = e.cd_aluno ) ---and cd_deficiencia is not null
group by 1,2,3,4,5,6,7,8,9,10,11
) --
,inep_base as (
select 
s.cd_inep_aluno, 
cd_institucional_aluno
from public.tb_spaece_ef_aplicacao_2023 s 
where dc_rede_ensino = 'Estadual' 
)
,distritos as (
SELECT 
tut.ci_unidade_trabalho, 
cd_regiao+ 20 cd_distrito,
'021R'||tut.cd_regiao nm_distrito
FROM util.tb_unidade_trabalho tut 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_unidade_trabalho_pai >20
and tut.cd_tpunidade_trabalho = 1
and tut.cd_regiao is not null 
union  
SELECT 
tut.ci_unidade_trabalho, 
tut.cd_unidade_trabalho_pai cd_distrito,
'CREDE '|| tl.ds_localidade nm_distrito
FROM util.tb_unidade_trabalho tut 
join util.tb_localidades tl on tl.ci_localidade = tut.cd_municipio 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_unidade_trabalho_pai <20
and tut.cd_tpunidade_trabalho = 1
)
,escolas as (
SELECT
cd_distrito,
nm_distrito,
crede.ci_unidade_trabalho cd_regional,
crede.nm_sigla nm_regional,
tmc.ci_municipio_censo,
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria)  AS ds_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao
FROM rede_fisica.tb_unidade_trabalho tut
join rede_fisica.tb_unidade_trabalho crede on crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
join distritos d on tut.ci_unidade_trabalho = d.ci_unidade_trabalho
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = TRUE 
and tut.cd_categoria <> 6
--and tut.categoria not in (13,7) -- escolas regulares
--and tut.categoria = 7  -- escolas indigenas
--and tut.cd_categoria = 13-- escolas quilombolas
) --select * from escolas --754

/*
select  --1 /*
'Ceará' "NM_UF",
cd_distrito "CD_DISTRITO",
nm_distrito "NM_DISTRITO",
cd_regional as "CD_REGIONAL",
nm_regional "NM_REGIONAL",
ci_municipio_censo "CD_MUNICIPIO",
nm_municipio"NM_MUNICIPIO",
id_escola_inep "CD_ESCOLA",
nm_escola "NM_ESCOLA",
'Estadual' "DC_REDE_ENSINO",
ds_localizacao as "DC_LOCALIZACAO",
t.ci_turma "CD_TURMA",
ds_turma "NM_TURMA",
'Ensino Fundamental de 9 anos - '|| et.cd_etapa -120 ||'º Ano'  "DC_ETAPA",
'Regular' "DC_TIPO_ENSINO",
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
--join academico.tb_etapa te on te.ci_etapa = et.cd_etapa
inner join turmas t on et.cd_turma = t.ci_turma
inner join alunos a on a.ci_aluno = et.cd_aluno and cd_inep_aluno is null
inner join escolas e on e.id_escola_sige = t.cd_unidade_trabalho
left join ( )
left join extensao ex on  t.ci_turma = ex.ci_turma
where 
not exists (select 1 from extensao ex2 where ex2.ci_turma = t.ci_turma and cd_tipo_local in (3,4) ) -- retira as turmas do sistema prisional

