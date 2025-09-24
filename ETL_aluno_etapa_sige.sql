with turma as (
select *
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2023
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tt.fl_ativo = 'S' 
and cd_etapa <> 137
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
)
,ult_ent as (
  select
  cd_aluno,cd_turma,tu.dt_enturmacao
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2023
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ) --select count(1) from ult_ent 
 ,mult  as(
select
tm.cd_turma,
ti.cd_nivel,
ti.cd_etapa,
dt_enturmacao::text,
tm.cd_aluno,
1 fl_multseriado
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
join ult_ent ut using(cd_turma,cd_aluno)
where 
tm.nr_anoletivo = 2023
and ti.cd_prefeitura = 0

) --select * from mult
, outras as (
select
cd_turma,
cd_nivel,
cd_etapa,
dt_enturmacao::text,
cd_aluno,
0 fl_multseriado
from ult_ent tu
join turma tt on tu.cd_turma = ci_turma
where 
not exists (select 1 from mult where tu.cd_aluno = mult.cd_aluno)
),
aluno_etapa as(
select * from mult
union
select * from outras
) --select * from aluno_etapa

, etapas_padronizadas as(
select
nr_anoletivo,
cd_unidade_trabalho id_escola_sige,
nr_codigo_unid_trab id_escola_inep,
cd_turma id_turma_sige,
ae.cd_nivel cd_nivel_sige,
ds_nivel ds_nivel_sige,
ae.cd_etapa cd_etapa_sige,
ds_etapa ds_etapa_sige,
fl_multseriado,
cd_turno,
ds_turno,
case when ae.cd_etapa in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
      									             then 1
	  when ae.cd_etapa in (213,214,195,194,175,196,174,173)  then 2 else 99 end cd_oferta_ensino,
      
case when ae.cd_etapa in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
      									             then 'Ensino Regular'
when ae.cd_etapa in (213,214,195,194,175,196,174,173)  then 'EJA' else 'Não se aplica' end ds_oferta_ensino,
case when  ae.cd_nivel = 28 then 1
     when  ae.cd_nivel = 26 then 2
     when  ae.cd_nivel = 27 and  ae.cd_etapa<>137 then 3 else 99 end  cd_etapa_aluno,
case when  ae.cd_nivel = 28 then 'Educação Infantil'
     when  ae.cd_nivel = 26 then 'Ensino Fundamental'
     when  ae.cd_nivel = 27 and  ae.cd_etapa<>137 then 'Ensino Médio' else 'Não se aplica' end ds_etapa_aluno,
case when  ae.cd_etapa in (121,122,123,124,125,172,194) then 1
     when  ae.cd_etapa in (126,127,128,129,174,195)     then 2
     when  ae.cd_etapa  = 175                           then 3 else 99 end cd_subetapa,
case when  ae.cd_etapa in (121,122,123,124,125,172,194) then 'Anos Iniciais'
     when  ae.cd_etapa in (126,127,128,129,174,195)     then 'Anos Finais'
     when  ae.cd_etapa  = 175                           then 'Anos Iniciais e Anos Finais' else 'Não se aplica' end ds_subetapa,
case 
     when  ae.cd_etapa = 121 then 1
     when  ae.cd_etapa = 122 then 2
     when  ae.cd_etapa = 123 then 3
     when  ae.cd_etapa = 124 then 4
     when  ae.cd_etapa = 125 then 5
     when  ae.cd_etapa = 126 then 6
     when  ae.cd_etapa = 127 then 7
     when  ae.cd_etapa = 128 then 8
     when  ae.cd_etapa = 129 then 9
     when  ae.cd_etapa in(162,184,188) then 10
     when  ae.cd_etapa in(163,185,189) then 11
     when  ae.cd_etapa in(164,186,190) then 12
     when  ae.cd_etapa in(165,187,191) then 13 else 99 end cd_ano_serie,
case 
     when  ae.cd_etapa = 121 then ' 1º Ano'
     when  ae.cd_etapa = 122 then ' 2º Ano'
     when  ae.cd_etapa = 123 then ' 3º Ano'
     when  ae.cd_etapa = 124 then ' 4º Ano'
     when  ae.cd_etapa = 125 then ' 5º Ano'
     when  ae.cd_etapa = 126 then ' 6º Ano'
     when  ae.cd_etapa = 127 then ' 7º Ano'
     when  ae.cd_etapa = 128 then ' 8º Ano'
     when  ae.cd_etapa = 129 then ' 9º Ano'
     when  ae.cd_etapa in(162,184,188) then '1ª Série'
     when  ae.cd_etapa in(163,185,189) then '2ª Série'
     when  ae.cd_etapa in(164,186,190) then '3ª Série'
     when  ae.cd_etapa in(165,187,191) then '4ª Série' else 'Não se aplica' end ds_ano_serie,
cd_aluno
from aluno_etapa ae
join academico.tb_nivel tn on tn.ci_nivel = ae.cd_nivel
join academico.tb_etapa te on te.ci_etapa = ae.cd_etapa
join turma t on t.ci_turma = cd_turma
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2
)
select * from etapas_padronizadas
