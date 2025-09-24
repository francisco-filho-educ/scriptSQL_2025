--- LISTA DE ACORDO COM AS VARIAVEIS DO CAED
-- ENSINO FUNDAMENTAL -----------
with turmas as (
select *, 
case when cd_turno = 4 then 1
when cd_turno = 1 then 2
when cd_turno = 2 then 3
when cd_turno = 5 then 4 end cd_turno_c
from academico.tb_turma tt
join academico.tb_etapa et on ci_etapa =  cd_etapa
join (select ci_turno, ds_turno from academico.tb_turno) as tn on tn.ci_turno = tt.cd_turno 
where nr_anoletivo = extract(year from current_date)
and cd_nivel = 26 --and tt.dt_horainicio 
and cd_unidade_trabalho = 32 -- FILTRO ESCOLA
--and cd_prefeitura = 0  
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
     where tt.nr_anoletivo = extract(year from current_date)
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
--select count(1) from enturmacao_i --24318
 ,mult  as(
select
tm.cd_turma,
tm.cd_aluno,
ti.cd_etapa,
1 fl_mult
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
join enturmacao_i ut using(cd_turma,cd_aluno)
where 
tm.nr_anoletivo = extract(year from current_date)
)
--select count(1) from mult
,enturmacao as (
select 
cd_aluno,
cd_turma,
cd_etapa,
0 fl_mult
from enturmacao_i eti 
where eti.cd_turma not in (select distinct cd_turma from mult)
union  
select 
cd_aluno,
cd_turma,
cd_etapa,
fl_mult
from mult 
) 
--select count(1) from enturmacao
, aluno_deficiencia_lista as (
select 
cd_aluno,
case 
when cd_deficiencia  = 1 then 'Cegueira'
when cd_deficiencia  = 3 then 'Surdez'
when cd_deficiencia  = 4 then 'Deficiência auditiva'
when cd_deficiencia  = 5 then 'Surdocegueira'
when cd_deficiencia  in (2,25) then 'Baixa visão'
when cd_deficiencia  = 6    then 'Deficiência física'
when cd_deficiencia  in (7,20)  then 'Deficiência intelectual'
when cd_deficiencia  in (9,10,11,12,24) then 'Autismo'
when cd_deficiencia  = 13   then 'Altas habilidades/Superdotação'
when cd_deficiencia  = 8    then 'Deficiência múltipla' end nm_deficiencia
from academico.tb_aluno_deficiencia def 
where exists (select 1 from enturmacao e where def.cd_aluno = e.cd_aluno )
and cd_deficiencia in (1,3,4,5,2,25,6,7,20,9,10,11,12,24,13,8)
group by 1,2
)
, aluno_deficiencia as (
select 
cd_aluno,
1 fl_deficiencia,
string_agg(nm_deficiencia ,', ' ) nm_deficiencia 
from aluno_deficiencia_lista 
group by 1,2
)
,aluno_recurso as ( 
select
ar.cd_aluno,
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
from  academico.tb_aluno_recurso_espec_aval ar 
join enturmacao ta2 on ar.cd_aluno = ta2.cd_aluno 
group by 1
)
,alunos as (
select 
ci_aluno,
nm_aluno,
ta2.cd_inep_aluno,
ta2.dt_nascimento::text,
case when fl_sexo = 'M' then 1 else 2 end cd_sexo,
case when fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo,
nm_mae,
nm_pai,
ta2.cd_raca,
tr.ds_raca,
case when fl_deficiencia is null then 'Não' else 'Sim' end ds_possui_deficiencia,
nm_deficiencia,
ds_recurso_avaliacao
from academico.tb_aluno ta2 
left join academico.tb_raca tr on tr.ci_raca = ta2.cd_raca
left join aluno_deficiencia def on def.cd_aluno = ci_aluno 
left join aluno_recurso ar on ar.cd_aluno = ta2.ci_aluno 
where exists (select 1 from enturmacao e where ci_aluno = e.cd_aluno ) ---and cd_deficiencia is not null
) 
,escolas as (
select --count(1)
tut.ci_unidade_trabalho id_escola_sige,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
cd_municipio_censo id_municipio,
upper(nm_municipio) AS nm_municipio,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
tut.cd_dependencia_administrativa,
tda.nm_dependencia_administrativa
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
join rede_fisica.tb_dependencia_administrativa tda on tda.ci_dependencia_administrativa = tut.cd_dependencia_administrativa
WHERE tut.cd_dependencia_administrativa in (2,3)
AND tut.cd_tipo_unid_trab = 401
and tut.cd_situacao_funcionamento = 1
AND tlut.fl_sede = true
and tut.ci_unidade_trabalho = 32 -- FILTRO ESCOLA
)
,credes as (
select 
tut.ci_unidade_trabalho id_crede_sefor,
--tut.nm_sigla nm_crede_sefor,
tl.ds_localidade nm_municipio_crede
from util.tb_unidade_trabalho tut 
join util.tb_localidades tl on tl.ci_localidade = tut.cd_municipio 
where tut.ci_unidade_trabalho 
between 1 and 23
order by 1
)
,credes_municipio as (
select 
tde.id_municipio,
tde.nm_municipio ,
id_crede_sefor,
nm_crede_sefor,
nm_municipio_crede
from escolas tde 
join credes using (id_crede_sefor)
where id_crede_sefor between 1 and 20
group by 1,2,3,4,5
union  
select 
2304400 id_municipio,
'FORTALEZA' nm_municipio ,
21 id_crede_sefor,
'SEFOR' nm_crede_sefor,
'FORTALEZA' nm_municipio_crede
)
select
'CE' "NM_UF",
cr.id_crede_sefor "CD_REGIONAL",
cr.nm_crede_sefor  "NM_REGIONAL",
cr.id_municipio "CD_MUNICIPIO",
 cr.nm_municipio "NM_MUNICIPIO",
 id_escola_inep "CD_ESCOLA",
 nm_escola "NM_ESCOLA",
nm_dependencia_administrativa  "DC_REDE_ENSINO",
 ds_localizacao "DC_LOCALIZACAO",
 cd_turma "CD_TURMA",
 ds_turma "NM_TURMA",
 'Ensino Fundamental' "DC_ENSINO",
 te.ds_etapa "DC_ETAPA",
 t.ds_etapa "DC_ETAPA_TURMA",
 'Regular' "DC_TIPO_ENSINO",
  ds_turno "DC_TURNO",
 '--' "NM_PROFESSOR",
 fl_mult "FL_MULTISSERIADA",
 coalesce(fl_anexo,0)  "FL_ANEXO",
 coalesce(nm_local_funcionamento,'--') "NM_ANEXO",
 cd_aluno "CD_INSTITUCIONAL_ALUNO",
 cd_inep_aluno "CD_INEP_ALUNO",
 nm_aluno "NM_ALUNO",
 dt_nascimento "DT_NASCIMENTO",
 ds_sexo "DC_SEXO",
 nm_deficiencia "TP_DEFICIENCIA",
 nm_mae "NM_FILIACAO_01",
 nm_pai "NM_FILIACAO_02"
from enturmacao et 
join academico.tb_etapa te on te.ci_etapa = et.cd_etapa
inner join turmas t on et.cd_turma = t.ci_turma
inner join alunos a on a.ci_aluno = et.cd_aluno
inner join escolas e on e.id_escola_sige = t.cd_unidade_trabalho
inner join credes_municipio cr using(id_municipio)
left join extensao ex on  t.ci_turma = ex.ci_turma
where 
--et.cd_etapa between 121 and 129
et.cd_etapa in(122,124,125,128,129)
and not exists (select 1 from extensao ex2 where ex2.ci_turma = t.ci_turma and cd_tipo_local in (3,4) ) -- retira as turmas do sistema prisional
--order by 1



----------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------
--- LISTA DE ACORDO COM AS VARIAVEIS DO CAED
-- ENSINO MÉDIO -----------
with turmas as (
select *, 
case when cd_turno = 4 then 1
when cd_turno = 1 then 2
when cd_turno = 2 then 3
when cd_turno = 5 then 4 end cd_turno_c
from academico.tb_turma tt
join academico.tb_etapa et on ci_etapa =  cd_etapa
join (select ci_turno, ds_turno from academico.tb_turno) as tn on tn.ci_turno = tt.cd_turno 
join academico.tb_etapa_etapamodalidade tee using(cd_etapa,cd_modalidade,cd_nivel)
where nr_anoletivo = extract(year from current_date)
and cd_nivel = 27 --and tt.dt_horainicio 
and cd_etapa in (164,186,190)
and cd_unidade_trabalho = 31
and cd_prefeitura = 0  
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
     where tt.nr_anoletivo = extract(year from current_date)
     and lut.fl_sede = false
     --and tlf.cd_tipo_local not in (4,3) -- retira os anexo em sistemas prisionais
     group by 1,2,3,4
)
,enturmacao as (
select 
cd_aluno,
cd_turma,
cd_etapa,
0 fl_mult
from academico.tb_ultimaenturmacao tu 
join (select ci_turma, cd_etapa from turmas) as t on  ci_turma = cd_turma
and tu.fl_tipo_atividade <> 'AC'
)
--select count(1) from enturmacao
, aluno_deficiencia_lista as (
select 
cd_aluno,
case 
when cd_deficiencia  = 1 then 'Cegueira'
when cd_deficiencia  = 3 then 'Surdez'
when cd_deficiencia  = 4 then 'Deficiência auditiva'
when cd_deficiencia  = 5 then 'Surdocegueira'
when cd_deficiencia  in (2,25) then 'Baixa visão'
when cd_deficiencia  = 6    then 'Deficiência física'
when cd_deficiencia  in (7,20)  then 'Deficiência intelectual'
when cd_deficiencia  in (9,10,11,12,24) then 'Autismo'
when cd_deficiencia  = 13   then 'Altas habilidades/Superdotação'
when cd_deficiencia  = 8    then 'Deficiência múltipla' end nm_deficiencia
from academico.tb_aluno_deficiencia def 
where exists (select 1 from enturmacao e where def.cd_aluno = e.cd_aluno )
and cd_deficiencia in (1,3,4,5,2,25,6,7,20,9,10,11,12,24,13,8)
group by 1,2
)
, aluno_deficiencia as (
select 
cd_aluno,
1 fl_deficiencia,
string_agg(nm_deficiencia ,', ' ) nm_deficiencia 
from aluno_deficiencia_lista 
group by 1,2
)
,aluno_recurso as ( 
select
ar.cd_aluno,
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
from  academico.tb_aluno_recurso_espec_aval ar 
join enturmacao ta2 on ar.cd_aluno = ta2.cd_aluno 
group by 1
)
,alunos as (
select 
ci_aluno,
nm_aluno,
ta2.cd_inep_aluno,
ta2.dt_nascimento::text,
case when fl_sexo = 'M' then 1 else 2 end cd_sexo,
case when fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo,
nm_mae,
nm_pai,
ta2.cd_raca,
tr.ds_raca,
case when fl_deficiencia is null then 'Não' else 'Sim' end ds_possui_deficiencia,
nm_deficiencia,
ds_recurso_avaliacao
from academico.tb_aluno ta2 
left join academico.tb_raca tr on tr.ci_raca = ta2.cd_raca
left join aluno_deficiencia def on def.cd_aluno = ci_aluno 
left join aluno_recurso ar on ar.cd_aluno = ta2.ci_aluno 
where exists (select 1 from enturmacao e where ci_aluno = e.cd_aluno ) ---and cd_deficiencia is not null
) 
,escolas as (
select --count(1)
tut.ci_unidade_trabalho id_escola_sige,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
cd_municipio_censo id_municipio,
upper(nm_municipio) AS nm_municipio,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
tut.cd_dependencia_administrativa,
tda.nm_dependencia_administrativa
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
join rede_fisica.tb_dependencia_administrativa tda on tda.ci_dependencia_administrativa = tut.cd_dependencia_administrativa
WHERE tut.cd_dependencia_administrativa in (2,3)
AND tut.cd_tipo_unid_trab = 401
and tut.cd_situacao_funcionamento = 1
AND tlut.fl_sede = true
)
,credes as (
select 
tut.ci_unidade_trabalho id_crede_sefor,
--tut.nm_sigla nm_crede_sefor,
tl.ds_localidade nm_municipio_crede
from util.tb_unidade_trabalho tut 
join util.tb_localidades tl on tl.ci_localidade = tut.cd_municipio 
where tut.ci_unidade_trabalho 
between 1 and 23
order by 1
)
,credes_municipio as (
select 
tde.id_municipio,
tde.nm_municipio ,
id_crede_sefor,
nm_crede_sefor,
nm_municipio_crede
from escolas tde 
join credes using (id_crede_sefor)
where id_crede_sefor between 1 and 20
group by 1,2,3,4,5
union  
select 
2304400 id_municipio,
'FORTALEZA' nm_municipio ,
21 id_crede_sefor,
'SEFOR' nm_crede_sefor,
'FORTALEZA' nm_municipio_crede
)
select
'CE' "NM_UF",
cr.id_crede_sefor "CD_REGIONAL",
cr.nm_crede_sefor  "NM_REGIONAL",
cr.id_municipio "CD_MUNICIPIO",
 cr.nm_municipio "NM_MUNICIPIO",
 id_escola_inep "CD_ESCOLA",
 nm_escola "NM_ESCOLA",
nm_dependencia_administrativa  "DC_REDE_ENSINO",
 ds_localizacao "DC_LOCALIZACAO",
 cd_turma "CD_TURMA",
 ds_turma "NM_TURMA",
 t.ds_nivel "DC_ENSINO",
 t.ds_newetapa "DC_ETAPA",
 t.ds_etapa "DC_ETAPA_TURMA",
 'Regular' "DC_TIPO_ENSINO",
  ds_turno "DC_TURNO",
 '--' "NM_PROFESSOR",
 fl_mult "FL_MULTISSERIADA",
 coalesce(fl_anexo,0)  "FL_ANEXO",
 coalesce(nm_local_funcionamento,'--') "NM_ANEXO",
 cd_aluno "CD_INSTITUCIONAL_ALUNO",
 cd_inep_aluno "CD_INEP_ALUNO",
 nm_aluno "NM_ALUNO",
 dt_nascimento "DT_NASCIMENTO",
 ds_sexo "DC_SEXO",
 nm_deficiencia "TP_DEFICIENCIA",
 nm_mae "NM_FILIACAO_01",
 nm_pai "NM_FILIACAO_02"
from enturmacao et 
join academico.tb_etapa te on te.ci_etapa = et.cd_etapa
inner join turmas t on et.cd_turma = t.ci_turma
inner join alunos a on a.ci_aluno = et.cd_aluno
inner join escolas e on e.id_escola_sige = t.cd_unidade_trabalho
inner join credes_municipio cr using(id_municipio)
left join extensao ex on  t.ci_turma = ex.ci_turma
where 
not exists (select 1 from extensao ex2 where ex2.ci_turma = t.ci_turma and cd_tipo_local in (3,4) ) -- retira as turmas do sistema prisional
--order by 1