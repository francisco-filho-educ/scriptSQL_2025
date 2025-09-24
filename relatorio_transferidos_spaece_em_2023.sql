with
ult_ent_origem as (
  select *
  from public.tb_base_aplicacao_spaece_medio_15_08_2023 s
  
  ),
ult_ent_destino as (
 select 
*
 from academico.tb_ultimaenturmacao tu 
 where exists (select 1 from ult_ent_origem eo where eo.cd_institucional_aluno = tu.cd_aluno )
 and fl_tipo_atividade <> 'AC'
 and tu.nr_anoletivo = 2023
  )
  ,relatorio as (
 select
 eo.cd_institucional_aluno::int "CD_INSTITUCIONAL_ALUNO",
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
case when (tor.cd_etapa=214 or tor.cd_anofinaleja=2) then 'EJA Ensino Médio ano II'
      when tor.cd_etapa in (164,190) then 'Ensino Medio 3ª Série'
      when tor.cd_etapa = 186 then 'Ensino Médio - Integrado 3ª Serie' end "DS_ETAPA_SERIE_ORIGEM",  
case when (tor.cd_etapa=214 or tor.cd_anofinaleja=2) then 72 
      when tor.cd_etapa in (164,190) then 27
      when tor.cd_etapa = 186 then 32 end "CD_ETAPA_ENSINO_ORIGEM", 
      
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
      case when (tde.cd_etapa=214 or tde.cd_anofinaleja=2) then 'EJA Ensino Médio ano II'
      when tde.cd_etapa in (164,190) then 'Ensino Medio 3ª Série'
      when tde.cd_etapa = 186 then 'Ensino Médio - Integrado 3ª Serie' 
      when tde.cd_etapa = 213 or tde.cd_anofinaleja = 1  then 'EJA Ensino Médio ano I'
      when tde.cd_etapa in (173,174) then 'EJA Ensino Médio Semipresencial'
      end "DS_ETAPA_SERIE_DESTINO",  
      
case when (tde.cd_etapa=214 or tde.cd_anofinaleja=2) then 72 
      when tde.cd_etapa in (164,190) then 27
      when tde.cd_etapa = 186 then 32 
      when tde.cd_etapa = 213 or tde.cd_anofinaleja = 1  then 71
      when tde.cd_etapa in (173,174) then 74
      end "CD_ETAPA_ENSINO_DESTINO", 
      
case when tde.cd_modalidade in (36,40) then 1
      when tde.cd_modalidade = 37 then 2
      when tde.cd_modalidade = 38 then  3 end "CD_MODALIDADE_DESTINO",
case when tde.cd_modalidade in (36,40) then 'Regular'
      when tde.cd_modalidade = 37 then 'Especial'
      when tde.cd_modalidade = 38 then 'EJA' end "DS_MODALIDADE_DESTINO",     
 dt_enturmacao "DT_TRANSFERENCIA"
 from ult_ent_origem eo
 left join ult_ent_destino ed on eo.cd_institucional_aluno = ed.cd_aluno
 join academico.tb_turma tor on tor.ci_turma = eo.cd_turma and tor.nr_anoletivo = 2023
 left join academico.tb_turma tde on tde.ci_turma = ed.cd_turma and tde.nr_anoletivo = 2023
 left join academico.tb_etapa te on te.ci_etapa = tde.cd_etapa 
 join util.tb_unidade_trabalho utor on utor.ci_unidade_trabalho=tor.cd_unidade_trabalho and utor.cd_dependencia_administrativa=2
 join util.tb_localidades lor on lor.ci_localidade=utor.cd_municipio
 left join util.tb_unidade_trabalho utde on utde.ci_unidade_trabalho=tde.cd_unidade_trabalho and utde.cd_dependencia_administrativa=2 
 left join util.tb_localidades lde on lde.ci_localidade=utde.cd_municipio
 )
 select *
 from relatorio 
 where "CD_ESCOLA_ORIGEM" <> "CD_ESCOLA_DESTINO"