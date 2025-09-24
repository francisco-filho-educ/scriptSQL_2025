with
ult_ent_origem as (
  select s.*,
  case when dc_turno ilike 'Manh_' then 1
       when dc_turno ilike 'Tarde' then 2
       when dc_turno ilike 'Noite' then 3
       when dc_turno ilike 'Integral' then 4  else 5 end cd_turno,
  case when cd_aluno_excluido is null then s.cd_institucional_aluno else taam.cd_aluno end cd_aluno
  from public.tb_spaece_ensino_medio_2_3_serie_2024 s
  left join academico.tb_auditoria_aluno_mesclar taam on taam.cd_aluno_excluido = s.cd_institucional_aluno  
  where cd_etapa in (27,71) -- 3º SERIE E EJA MÉDIO
  --where cd_etapa = 26-- 2º SERIE
  ) --select dc_turno, cd_turno, count(1) from ult_ent_origem group by 1,2 --103938
,max_enturmacao as (
select
 cd_aluno,
 max(ci_enturmacao) ci_enturmacao
 from academico.tb_ultimaenturmacao tu 
 where exists (select 1 from ult_ent_origem eo where eo.cd_institucional_aluno = tu.cd_aluno )
 and fl_tipo_atividade <> 'AC'
 and tu.nr_anoletivo = 2024
 group by 1
)    
,ult_ent_destino as (
 select *
 from academico.tb_ultimaenturmacao tu 
 join max_enturmacao using(ci_enturmacao,cd_aluno)
  )
,credes as (
select 
  tut.ci_unidade_trabalho id_crede_sefor, 
  upper(tut.nm_sigla) nm_crede_sefor, 
  upper(tmc.nm_municipio) AS nm_municipio_crede
from rede_fisica.tb_unidade_trabalho tut 
join rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
join rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
join util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
where tut.cd_dependencia_administrativa = 2
  --and tut.cd_situacao_funcionamento = 1
  and tut.ci_unidade_trabalho between 1 and 23
  and tlut.fl_sede = TRUE 
)
  ,relatorio as (
 select
 eo.cd_aluno::int "CD_INSTITUCIONAL_ALUNO",
 eo.nm_aluno "NM_ALUNO",
 eo.dt_nascimento "DT_NASCIMENTO",
 eo.cd_regional::int  "CD_REGIONAL_ORIGEM",
 eo.nm_regional  "NM_REGIONAL_ORIGEM",
 eo.cd_municipio::int "CD_MUNICIPIO_ORIGEM",
 eo.nm_municipio "NM_MUNICIPIO_ORIGEM",
 eo.cd_escola::int "CD_ESCOLA_ORIGEM",
eo.nm_escola "NM_ESCOLA_ORIGEM",
eo.cd_turma::int "CD_TURMA_ORIGEM",
eo.nm_turma "NM_TURMA_ORIGEM",
eo.cd_etapa::int "CD_ETAPA_ENSINO_ORIGEM", 
eo.dc_etapa "DS_ETAPA_ENSINO_ORIGEM",  
eo.cd_turno "CD_TURNO_ORIGEM", -- VERIFICAR 
eo.dc_turno "DC_TURNO_ORIGEM",
cd_tipo_ensino::int "CD_TIPO_ENSINO_ORIGEM",
DC_tipo_ensino "DS_TIPO_ENSINO_ORIGEM",
 -- DESTINO
id_crede_sefor::int "CD_REGIONAL_DESTINO",
case when id_crede_sefor > 20 then nm_crede_sefor else nm_municipio_crede end "NM_REGIONAL_DESTINO",
lde.cd_inep::int "CD_MUNICIPIO_DESTINO",
lde.ds_localidade "NM_MUNICIPIO_DESTINO",
utde.nr_codigo_unid_trab "CD_ESCOLA_DESTINO",
utde.nm_unidade_trabalho "NM_ESCOLA_DESTINO",
tde.ci_turma::int "CD_TURMA_DESTINO",
tde.ds_turma "NM_TURMA_DESTINO",
case  
    when tde.cd_etapa in (162,184,188) then 25 
      when tde.cd_etapa in (163,189,185) then 26 
      when tde.cd_etapa in (164,190,186) then 27
      when tde.cd_etapa in (213,214,196) then 71 --eja medio 
      else tde.cd_etapa
      end "CD_ETAPA_DESTINO", -- Código do Censo Escolar
case when tde.cd_etapa in (162,184,188) then 'ENSINO MÉDIO - 1ª SÉRIE'
    when tde.cd_etapa in (163,189,185) then 'ENSINO MÉDIO - 2ª SÉRIE'
    when tde.cd_etapa in (164,190,186) then 'ENSINO MÉDIO - 3ª SÉRIE'
    when tde.cd_etapa in (213,214,196) then 'EJA - ENSINO MÉDIO' 
    else ds_etapa
    end "DC_ETAPA_DESTINO",  
case 
  when tde.cd_turno = 4 then 1
  when tde.cd_turno = 1 then 2
  when tde.cd_turno = 2 then 3 
  when tde.cd_turno in (5,8,9,10) then 4 else 5 end "CD_TURNO_DESTINO",
case 
  when tde.cd_turno = 4 then 'Manhã'
  when tde.cd_turno = 1 then 'Tarde'
  when tde.cd_turno = 2 then 'Noite'
  when tde.cd_turno in (5,8,9,10) then 'Integral' else ds_turno end "DC_TURNO_DESTINO",
  case when tde.cd_etapa in (213,214,195,194,175,196,174,173,176) then 2 else 1 end  "CD_TIPO_ENSINO_DESTINO",       
  case when tde.cd_etapa in (213,214,195,194,175,196,174,173,176) then 'EJA' else 'Regular' end "DC_TIPO_ENSINO_DESTINO",
 dt_enturmacao "DT_TRANSFERENCIA"
 --,case when tde.cd_etapa in (213,214,195,194,175,196,174,173,176) then 2 else 1 end  "CD_TIPO_ENSINO_DESTINO"
 from ult_ent_origem eo
 left join ult_ent_destino ed using(cd_aluno)
 left join academico.tb_turma tde on tde.ci_turma = ed.cd_turma and tde.nr_anoletivo = 2024
 left join academico.tb_etapa te on te.ci_etapa = tde.cd_etapa 
 left join academico.tb_turno tn on tn.ci_turno = tde.cd_turno
 left join util.tb_unidade_trabalho utde on utde.ci_unidade_trabalho=tde.cd_unidade_trabalho and utde.cd_dependencia_administrativa=2 
 left join credes on id_crede_sefor = utde.cd_unidade_trabalho_pai
 left join util.tb_localidades lde on lde.ci_localidade=utde.cd_municipio
 order by 4,7
 )
 select -- count(1)
 *
 from relatorio
 where "CD_ESCOLA_ORIGEM"::int <> "CD_ESCOLA_DESTINO"::int 