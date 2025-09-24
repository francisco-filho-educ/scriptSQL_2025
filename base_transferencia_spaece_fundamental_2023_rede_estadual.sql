with
set_etapa as (
select 
--122 cd_etapa_sige, 2 cd_ano_serie , 26 cd_nivel
--125 cd_etapa_sige, 5 cd_ano_serie , 26 cd_nivel
--129 cd_etapa_sige, 9 cd_ano_serie , 26 cd_nivel
164 cd_etapa_sige, 12 cd_ano_serie , 27 cd_nivel union select 186 cd_etapa_sige, 12 cd_ano_serie , 26 cd_nivel union select 190 cd_etapa_sige, 12 cd_ano_serie , 26 cd_nivel
),
ult_ent_origem as (
  select
  case when cd_aluno_excluido is null then tdap.cd_aluno else taam.cd_aluno end cd_aluno,
  nm_aluno,
  to_char(dt_nascimento::timestamp,'dd/mm/yyyy') dt_nascimento,
  tdap.id_turma_sige cd_turma,
  tdap.id_escola_sige,
  cd_ano_serie 
  from public.tb_dm_etapa_aluno_2023_06_01 tdap 
  left join academico.tb_auditoria_aluno_mesclar taam on taam.cd_aluno_excluido  = tdap.cd_aluno 
  join public.tb_dm_aluno_pessoa_2023_06_01 p on p.cd_aluno = tdap.cd_aluno 
  where cd_ano_serie in (select cd_ano_serie from set_etapa)
  ),
turmas as (
select *, 
case when cd_turno = 4 then 1
when cd_turno = 1 then 2
when cd_turno = 2 then 3
when cd_turno = 5 then 4 end cd_turno_c
from academico.tb_turma tt
join (select ci_turno, ds_turno from academico.tb_turno) as tn on tn.ci_turno = tt.cd_turno 
where nr_anoletivo = 2023
and cd_nivel in (select distinct cd_nivel from set_etapa)
and cd_prefeitura= 0 
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
cd_etapa,
tu.dt_enturmacao
from academico.tb_ultimaenturmacao tu 
join (select ci_turma, cd_etapa from turmas) as t on  ci_turma = cd_turma
and tu.fl_tipo_atividade <> 'AC'
)
 ,mult  as(
select
tm.cd_turma,
tm.cd_aluno,
ti.cd_etapa,
ut.dt_enturmacao
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
join enturmacao_i ut using(cd_turma,cd_aluno)
where 
tm.nr_anoletivo = 2023
and ti.cd_prefeitura = 0
--and ti.cd_etapa  in (select cd_etapa_sige from set_etapa) -- ETAPA ANO SERIE
)
--select count(1) from mult
,ult_ent_destino as (
select 
cd_aluno,
cd_turma,
cd_etapa,
dt_enturmacao
from enturmacao_i eti 
--where eti.cd_etapa  in (select cd_etapa_sige from set_etapa)  -- ETAPA ANO SERIE
union  
select 
cd_aluno,
cd_turma,
cd_etapa,
dt_enturmacao
from mult 
) 
,relatorio as (
 select
 eo.cd_aluno::int "CD_INSTITUCIONAL_ALUNO",
 eo.nm_aluno "NM_ALUNO",
 eo.dT_nascimento "DT_NASCIMENTO",
case 
  when utor.cd_unidade_trabalho_pai<=20 then lpad(utor.cd_unidade_trabalho_pai::text,5,'0')
  else concat('021R',utor.cd_regiao::text) end "DS_ORGAO_REGIONAL_ORIGEM",
case when utor.cd_unidade_trabalho_pai<=20 then concat('CREDE ',utor.cd_unidade_trabalho_pai::text) else concat('SEFOR ',substring(utor.cd_unidade_trabalho_pai::text,2,2)) end "NM_CREDE_SEFOR_ORIGEM",
lor.cd_inep::int "CD_MUNICIPIO_ORIGEM",
lor.ds_localidade "NM_MUNICIPIO_ORIGEM",
utor.nr_codigo_unid_trab "CD_ESCOLA_ORIGEM",
utor.nm_unidade_trabalho "NM_ESCOLA_ORIGEM",
tor.ci_turma "CD_TURMA_ORIGEM",
tor.ds_turma "NM_TURMA_ORIGEM",
 case when cd_ano_serie = 9 then 41 
      when cd_ano_serie = 5 then  18
      when cd_ano_serie = 2 then 15 end "CD_ETAPA_ENSINO_ORIGEM", 
concat('Ensino Fundamental de 9 anos - ',(eo.cd_ano_serie),'º Ano') "DC_ETAPA_SERIE_ORIGEM",        
case when tor.cd_modalidade in (36,40) then 1
      when tor.cd_modalidade = 37 then 2
      when tor.cd_modalidade = 38 then  3 end "CD_MODALIDADE_ORIGEM",
case when tor.cd_modalidade in (36,40) then 'Regular'
      when tor.cd_modalidade = 37 then 'Especial'
      when tor.cd_modalidade = 38 then 'EJA' end "DS_MODALIDADE_ORIGEM",
 -- DESTINO
case 
  when utde.cd_unidade_trabalho_pai<=20 then lpad(utde.cd_unidade_trabalho_pai::text,5,'0')
  else concat('021R',utde.cd_regiao::text) end"DS_ORGAO_REGIONAL_DESTINO",
case when utde.cd_unidade_trabalho_pai<=20 then concat('CREDE ',utde.cd_unidade_trabalho_pai::text) else concat('SEFOR ',substring(utde.cd_unidade_trabalho_pai::text,2,2)) end "NM_CREDE_SEFOR_DESTINO",
lde.cd_inep::int "CD_MUNICIPIO_DESTINO",
lde.ds_localidade "NM_MUNICIPIO_DESTINO",
utde.nr_codigo_unid_trab "CD_ESCOLA_DESTINO",
utde.nm_unidade_trabalho "NM_ESCOLA_DESTINO",
tde.ci_turma "CD_TURMA_DESTINO",
tde.ds_turma "NM_TURMA_DESTINO",
 case when ed.cd_etapa between 121 and 129 then  concat('Ensino Fundamental de 9 anos - ',(ed.cd_etapa -120),'º Ano')
       else 'EJA - FUNDAMENTAL' end "DS_ETAPA_SERIE_DESTINO", 
 case when ed.cd_etapa = 122 then 15
      when ed.cd_etapa = 125 then 18 
      when ed.cd_etapa = 129 then 41 else 70 end  "CD_ETAPA_ENSINO_DESTINO",       
case when tde.cd_modalidade in (36,40) then 1
      when tde.cd_modalidade = 37 then 2
      when tde.cd_modalidade = 38 then  3 end "CD_MODALIDADE_DESTINO",
case when tde.cd_modalidade in (36,40) then 'Regular'
      when tde.cd_modalidade = 37 then 'Especial'
      when tde.cd_modalidade = 38 then 'EJA' end "DS_MODALIDADE_DESTINO",     
 to_char(dt_enturmacao,'dd/mm/yyyy')"DT_TRANSFERENCIA"
 from ult_ent_origem eo
 left join ult_ent_destino ed on eo.cd_aluno = ed.cd_aluno
 join academico.tb_turma tor on tor.ci_turma = eo.cd_turma and tor.nr_anoletivo = 2023
 left join academico.tb_turma tde on tde.ci_turma = ed.cd_turma and tde.nr_anoletivo = 2023
 left join academico.tb_etapa te on te.ci_etapa = tde.cd_etapa 
 join util.tb_unidade_trabalho utor on utor.ci_unidade_trabalho=tor.cd_unidade_trabalho and utor.cd_dependencia_administrativa=2
 join util.tb_localidades lor on lor.ci_localidade=utor.cd_municipio
 left join util.tb_unidade_trabalho utde on utde.ci_unidade_trabalho=tde.cd_unidade_trabalho and utde.cd_dependencia_administrativa=2 
 left join util.tb_localidades lde on lde.ci_localidade=utde.cd_municipio
 )
 select count(1)
 from relatorio 
where "CD_ESCOLA_ORIGEM" <> "CD_ESCOLA_DESTINO"