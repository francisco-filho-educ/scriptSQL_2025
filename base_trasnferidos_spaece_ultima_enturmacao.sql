with
ent_origem as (
	select
	cd_aluno,max(ci_enturmacao) ci_enturmacao
	from academico.tb_enturmacao e
	join academico.tb_turma t on ci_turma=cd_turma and fl_tipo_seriacao!='AC' and cd_prefeitura=0
	where t.nr_anoletivo=2019 and dt_enturmacao::date<='2019-05-29' and (dt_desenturmacao::date>'2019-05-29' or dt_desenturmacao is null)
	group by 1
),
ult_ent_origem as (
  select
  e1.cd_aluno,cd_turma
  from academico.tb_enturmacao e1
  join ent_origem e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join academico.tb_turma t on cd_turma=ci_turma and cd_nivel=27 and cd_tpensino=1 and (cd_etapa in (164,186,190,214) or cd_anofinaleja=2)

  ),
ent_destino as (
	select
	cd_aluno,max(ci_enturmacao) ci_enturmacao
	from academico.tb_enturmacao e2
	join academico.tb_turma t on ci_turma=cd_turma and fl_tipo_seriacao!='AC' 
	        and cd_prefeitura=0
	where t.nr_anoletivo=2019 and dt_enturmacao::date<='2019-10-17' 
	and (dt_desenturmacao::date>'2019-10-17' or dt_desenturmacao is null)
	group by 1
),

ult_ent_destino as (
  select
  e2.cd_aluno,cd_turma
  from academico.tb_enturmacao e3
  join ent_destino e2 on e3.ci_enturmacao=e2.ci_enturmacao  
  join academico.tb_turma t on cd_turma=ci_turma and cd_nivel=27 and cd_tpensino=1 and (cd_etapa in (164,186,190,214) or cd_anofinaleja=2)

  ),
data_transf as (
	select
	cd_aluno,e3.dt_enturmacao
	from academico.tb_enturmacao e3
	join ent_destino using(ci_enturmacao,cd_aluno)
)
 select
case 
  when utor.cd_unidade_trabalho_pai<=20 then lpad(utor.cd_unidade_trabalho_pai::text,5,'0')
  else concat('021R',utor.cd_regiao::text) end "DS_ORGAO_REGIONAL_ORIGEM",
case when utor.cd_unidade_trabalho_pai<=20 then concat('CREDE ',utor.cd_unidade_trabalho_pai::text) else concat('SEFOR',substring(utor.cd_unidade_trabalho_pai::text,2,2)) end "NM_CREDE_SEFOR_ORIGEM",
lor.cd_inep::int "ID_MUNICIPIO_ORIGEM",
lor.ds_localidade "NM_MUNICIPIO_ORIGEM",
utor.nr_codigo_unid_trab "ID_ESCOLA_ORIGEM",
utor.nm_unidade_trabalho "NM_ESCOLA_ORIGEM",
tor.ci_turma "CD_TURMA_ORIGEM",
tor.ds_turma "NM_TURMA_ORIGEM",
 case 
    when tor.cd_etapa=164 then 27
    when tor.cd_etapa=186 then 32
    when tor.cd_etapa=190 then 37
    when tor.cd_etapa=214 then 67
    when tor.cd_anofinaleja=2 then 71 end "TP_ETAPA_ENSINO_ORIGEM",
 case 
    when tor.cd_etapa=164 then 27
    when tor.cd_etapa=186 then 32
    when tor.cd_etapa=190 then 37
    when tor.cd_etapa=214 then 67
    when tor.cd_anofinaleja=2 then 71 end "TP_ETAPA_ENSINO_TURMA_ORIGEM",
case 
  when utde.cd_unidade_trabalho_pai<=20 then lpad(utde.cd_unidade_trabalho_pai::text,5,'0')
  else concat('021R',utde.cd_regiao::text) end"DS_ORGAO_REGIONAL_DESTINO",
case when utde.cd_unidade_trabalho_pai<=20 then concat('CREDE ',utde.cd_unidade_trabalho_pai::text) else concat('SEFOR',substring(utde.cd_unidade_trabalho_pai::text,2,2)) end "NM_CREDE_SEFOR_DESTINO",
lde.cd_inep::int "ID_MUNICIPIO_DESTINO",
lde.ds_localidade "NM_MUNICIPIO_DESTINO",
utde.nr_codigo_unid_trab "ID_ESCOLA_DESTINO",
utde.nm_unidade_trabalho "NM_ESCOLA_DESTINO",
tde.ci_turma "ID_TURMA_DESTINO",
tde.ds_turma "NM_TURMA_DESTINO",
 case 
    when tde.cd_etapa=164 then 27
    when tde.cd_etapa=186 then 32
    when tde.cd_etapa=190 then 37
    when tde.cd_etapa=214 then 67
    when tde.cd_anofinaleja=2 then 71 end "TP_ETAPA_ENSINO_DESTINO",
 case 
    when tde.cd_etapa=164 then 27
    when tde.cd_etapa=186 then 32
    when tde.cd_etapa=190 then 37
    when tde.cd_etapa=214 then 67
    when tde.cd_anofinaleja=2 then 71 end "TP_ETAPA_ENSINO_TURMA_DESTINO",
dt.dt_enturmacao "DT_TRANSFERENCIA"
 from ult_ent_origem eo
 left join ult_ent_destino ed using (cd_aluno)
 join data_transf dt using(cd_aluno)
 join academico.tb_turma tor on tor.ci_turma = eo.cd_turma and tor.nr_anoletivo = 2019
 join academico.tb_turma tde on tde.ci_turma = tde.ci_turma and tde.nr_anoletivo = 2019
 join util.tb_unidade_trabalho utor on utor.ci_unidade_trabalho=tor.cd_unidade_trabalho and utor.cd_dependencia_administrativa=2 and utor.fl_ceja!='S' and utor.nr_codigo_unid_trab!='23243864'
 join util.tb_localidades lor on lor.ci_localidade=utor.cd_municipio
 join util.tb_unidade_trabalho utde on utde.ci_unidade_trabalho=tde.cd_unidade_trabalho and utde.cd_dependencia_administrativa=2 and utde.fl_ceja!='S' and utde.nr_codigo_unid_trab!='23243864'
 join util.tb_localidades lde on lde.ci_localidade=utde.cd_municipio