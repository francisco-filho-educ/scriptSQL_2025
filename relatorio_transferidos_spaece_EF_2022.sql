with turma as (
-- turma destino
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho,
case when cd_turno =  4 then 1 
     when cd_turno =  1 then 2  
     when cd_turno =  2 then 3  
     when cd_turno in (8,9) then 4 end cd_turno,
case when cd_turno in (8,9) then 'Integral' else ds_turno end ds_turno
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2022 
and tt.cd_prefeitura = 0
and tt.cd_nivel = 26
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
),
--- 2 ANO -------------------------
/*
ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turma on cd_turma = ci_turma
  where 
        e.nr_anoletivo = 2022
        and dt_enturmacao::date<='2022-11-28'  -- DATA DA ENTURMAÇAO > DATA DA DESENTURMAÇAO OU ESTA DEVE SER NULA
        and (dt_desenturmacao::date>'2022-11-28' or dt_desenturmacao is null)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,cd_turma, e1.dt_enturmacao
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join academico.tb_turma t on cd_turma=ci_turma 
),
mult as(
select
tm.cd_turma,
ti.cd_etapa cd_etapa_aluno,
tm.cd_aluno,
dt_enturmacao
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on cd_item=ci_item and ti.cd_etapa = 122 -- 2 ano
join ult_ent te on te.cd_turma = tm.cd_turma and te.cd_aluno = tm.cd_aluno
where 
tm.nr_anoletivo = 2022
),
uni_serie as (
select 
et.cd_turma,
cd_etapa cd_etapa_aluno,
cd_aluno,
dt_enturmacao
from ult_ent et
join turma t on ci_turma = et.cd_turma and t.cd_etapa = 122
where not exists (select  1 from mult m where m.cd_aluno = et.cd_aluno and et.cd_turma = m.cd_turma )
),
ult_ent_origem as (
  select 
  adt.cd_aluno,
  adt.cd_etapa_sige cd_etapa_aluno,
  nm_aluno,
  dt_nascimento,
  ta.cd_inep_aluno,
  adt.id_turma_sige cd_turma
  from public.tb_aluno_etapa_data_corte adt 
  join academico.tb_aluno ta on ta.ci_aluno = adt.cd_aluno 
  where adt.cd_nivel_sige = 26
  and adt.cd_etapa_sige = 122
-- Fim 2ano
*/  
--- 5 ANO ---
/*
ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turma on cd_turma = ci_turma
  where 
        e.nr_anoletivo = 2022
        and dt_enturmacao::date<='2022-11-29'  -- DATA DA ENTURMAÇAO > DATA DA DESENTURMAÇAO OU ESTA DEVE SER NULA
        and (dt_desenturmacao::date>'2022-11-29' or dt_desenturmacao is null)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,cd_turma, e1.dt_enturmacao
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join academico.tb_turma t on cd_turma=ci_turma 
),
mult as(
select
tm.cd_turma,
ti.cd_etapa cd_etapa_aluno,
tm.cd_aluno,
dt_enturmacao
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on cd_item=ci_item and ti.cd_etapa = 125 -- 5 ano
join ult_ent te on te.cd_turma = tm.cd_turma and te.cd_aluno = tm.cd_aluno
where 
tm.nr_anoletivo = 2022
),
uni_serie as (
select 
et.cd_turma,
cd_etapa cd_etapa_aluno,
cd_aluno,
dt_enturmacao
from ult_ent et
join turma t on ci_turma = et.cd_turma and t.cd_etapa = 125
where not exists (select  1 from mult m where m.cd_aluno = et.cd_aluno and et.cd_turma = m.cd_turma )
),
ult_ent_origem as (
  select 
  adt.cd_aluno,
  adt.cd_etapa_sige cd_etapa_aluno,
  nm_aluno,
  dt_nascimento,
  ta.cd_inep_aluno,
  adt.id_turma_sige cd_turma
  from public.tb_aluno_etapa_data_corte adt 
  join academico.tb_aluno ta on ta.ci_aluno = adt.cd_aluno 
  where adt.cd_nivel_sige = 26
  and adt.cd_etapa_sige = 125
-- Fim 5 ano
*/

ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turma on cd_turma = ci_turma
  where 
        e.nr_anoletivo = 2022
        and dt_enturmacao::date<='2022-11-30'  -- DATA DA ENTURMAÇAO > DATA DA DESENTURMAÇAO OU ESTA DEVE SER NULA
        and (dt_desenturmacao::date>'2022-11-30' or dt_desenturmacao is null)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,cd_turma, e1.dt_enturmacao
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join academico.tb_turma t on cd_turma=ci_turma 
),
mult as(
select
tm.cd_turma,
ti.cd_etapa cd_etapa_aluno,
tm.cd_aluno,
dt_enturmacao
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on cd_item=ci_item and ti.cd_etapa = 129 -- 9 ano
join ult_ent te on te.cd_turma = tm.cd_turma and te.cd_aluno = tm.cd_aluno
where 
tm.nr_anoletivo = 2022
),
uni_serie as (
select 
et.cd_turma,
cd_etapa cd_etapa_aluno,
cd_aluno,
dt_enturmacao
from ult_ent et
join turma t on ci_turma = et.cd_turma and t.cd_etapa = 129
where not exists (select  1 from mult m where m.cd_aluno = et.cd_aluno and et.cd_turma = m.cd_turma )
),
ult_ent_origem as (
  select 
  adt.cd_aluno,
  adt.cd_etapa_sige cd_etapa_aluno,
  nm_aluno,
  dt_nascimento,
  ta.cd_inep_aluno,
  adt.id_turma_sige cd_turma
  from public.tb_aluno_etapa_data_corte adt 
  join academico.tb_aluno ta on ta.ci_aluno = adt.cd_aluno 
  where adt.cd_nivel_sige = 26
  and adt.cd_etapa_sige = 129
-- Fim 9 ano

  ),
ult_ent_destino as (
select * from uni_serie 
union 
select * from mult
  ) select count(1) from ult_ent_destino
  ,
relatorio as (
 select
 eo.cd_aluno "CD_ALUNO_SIGE",
 eo.nm_aluno "NM_ALUNO",
 eo.dT_nascimento "DT_NASCIMENTO",
case 
  when utor.cd_unidade_trabalho_pai<=20 then lpad(utor.cd_unidade_trabalho_pai::text,5,'0')
  else concat('021R',utor.cd_regiao::text) end "DS_ORGAO_REGIONAL_ORIGEM",
case when utor.cd_unidade_trabalho_pai<=20 then concat('CREDE ',utor.cd_unidade_trabalho_pai::text) else concat('SEFOR ',substring(utor.cd_unidade_trabalho_pai::text,2,2)) end "NM_CREDE_SEFOR_ORIGEM",
lor.cd_inep::int "ID_MUNICIPIO_ORIGEM",
lor.ds_localidade "NM_MUNICIPIO_ORIGEM",
utor.nr_codigo_unid_trab "ID_ESCOLA_ORIGEM",
utor.nm_unidade_trabalho "NM_ESCOLA_ORIGEM",
tor.ci_turma "CD_TURMA_ORIGEM",
tor.ds_turma "NM_TURMA_ORIGEM",
case when eo.cd_etapa_aluno=122 then 'Ensino Fundamental 2º Ano'
     when eo.cd_etapa_aluno=125 then 'Ensino Fundamental 5º Ano'
     when eo.cd_etapa_aluno=129 then 'Ensino Fundamental 9º Ano' end "DS_ETAPA_SERIE_ORIGEM",  
     
case when eo.cd_etapa_aluno=122 then 15
     when eo.cd_etapa_aluno=125 then 18
     when eo.cd_etapa_aluno=129 then 41 end "TP_ETAPA_ENSINO_ORIGEM", 
tor.cd_turno "CD_TURNO_ORIGEM",
tor.ds_turno "DS_TURNO_ORIGEM",
      
case when tor.cd_modalidade in (36,40) then 1
      when tor.cd_modalidade = 37 then 2
      when tor.cd_modalidade = 38 then  3 end "TP_MODALIDADE_ORIGEM",
case when tor.cd_modalidade in (36,40) then 'Regular'
      when tor.cd_modalidade = 37 then 'Especial'
      when tor.cd_modalidade = 38 then 'EJA' end "DS_MODALIDADE_ORIGEM",
 -- DESTINO
case 
  when utde.cd_unidade_trabalho_pai<=20 then lpad(utde.cd_unidade_trabalho_pai::text,5,'0')
  else concat('021R',utde.cd_regiao::text) end"DS_ORGAO_REGIONAL_DESTINO",
case when utde.cd_unidade_trabalho_pai<=20 then concat('CREDE ',utde.cd_unidade_trabalho_pai::text) else concat('SEFOR ',substring(utde.cd_unidade_trabalho_pai::text,2,2)) end "NM_CREDE_SEFOR_DESTINO",
lde.cd_inep::int "ID_MUNICIPIO_DESTINO",
lde.ds_localidade "NM_MUNICIPIO_DESTINO",
utde.nr_codigo_unid_trab "ID_ESCOLA_DESTINO",
utde.nm_unidade_trabalho "NM_ESCOLA_DESTINO",
tde.ci_turma "ID_TURMA_DESTINO",
tde.ds_turma "NM_TURMA_DESTINO",

case when ed.cd_etapa_aluno=122 then 'Ensino Fundamental 2º Ano'
     when ed.cd_etapa_aluno=125 then 'Ensino Fundamental 5º Ano'
     when ed.cd_etapa_aluno=129 then 'Ensino Fundamental 9º Ano' end "DS_ETAPA_SERIE_DESTINO",  
     
case when ed.cd_etapa_aluno=122 then 15
     when ed.cd_etapa_aluno=125 then 18
     when ed.cd_etapa_aluno=129 then 41 end "TP_ETAPA_ENSINO_DESTINO", 
 tde.cd_turno "CD_TURNO_DESTINO",
tde.ds_turno "DS_TURNO_DESTINO",     
case when tde.cd_modalidade in (36,40) then 1
      when tde.cd_modalidade = 37 then 2
      when tde.cd_modalidade = 38 then  3 end "TP_MODALIDADE_DESTINO",
case when tde.cd_modalidade in (36,40) then 'Regular'
      when tde.cd_modalidade = 37 then 'Especial'
      when tde.cd_modalidade = 38 then 'EJA' end "DS_MODALIDADE_DESTINO",   ,
 dt_enturmacao "DT_TRANSFERENCIA"
 from ult_ent_origem eo
 left join ult_ent_destino ed on eo.cd_aluno = ed.cd_aluno
 join academico.tb_turma tor on tor.ci_turma = eo.cd_turma and tor.nr_anoletivo = 2022 -- origem
 left join academico.tb_turma tde on tde.ci_turma = ed.cd_turma and tde.nr_anoletivo = 2022 -- destino
 join util.tb_unidade_trabalho utor on utor.ci_unidade_trabalho=tor.cd_unidade_trabalho and utor.cd_dependencia_administrativa=2 --origem
 join util.tb_localidades lor on lor.ci_localidade=utor.cd_municipio -- origem
 left join util.tb_unidade_trabalho utde on utde.ci_unidade_trabalho=tde.cd_unidade_trabalho and utde.cd_dependencia_administrativa=2 
 left join util.tb_localidades lde on lde.ci_localidade=utde.cd_municipio -- destino
 )
 select 
*
 from relatorio 
 where 1= 1
 and  "ID_ESCOLA_ORIGEM" <> "ID_ESCOLA_DESTINO" 


 
 
 /*
 select 
 tut.nm_unidade_trabalho,
 tut.ci_unidade_trabalho,
 tut.nr_codigo_unid_trab,
 tt.ds_ofertaitem 
 from rede_fisica.tb_unidade_trabalho tut 
 join academico.tb_turma tt on tt.cd_unidade_trabalho = tut.ci_unidade_trabalho 
 and tt.ci_turma = 839409
 */
----