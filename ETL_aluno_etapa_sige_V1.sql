with turma as (
select *
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2022 
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tt.fl_ativo = 'S'
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
)
,ult_ent as (
  select
  cd_aluno,cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2022
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  )
 ,mult  as(
select
tm.cd_turma,
ti.cd_nivel,
ti.cd_etapa,
1 fl_multseriado,
tm.cd_aluno
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
where 
tm.nr_anoletivo = 2022
and ti.cd_prefeitura = 0

) --select * from mult
, outras as (
select
cd_turma,
cd_nivel,
cd_etapa,
0 fl_multseriado,
cd_aluno
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
ae.*,
case when cd_etapa in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
      									             then 0
	  when cd_etapa in (213,214,195,194,175,196,174,173)  then 1 else 99 end fl_eja,
case when cd_nivel = 28 then 1
     when cd_nivel = 26 then 2
     when cd_nivel = 27 and cd_etapa<>137 then 3 else 99 end cd_etapa_aluno,
case when cd_etapa in (121,122,123,124,125,172,194) then 1
     when cd_etapa in (126,127,128,129,174,195)     then 2
     when cd_etapa  = 175                           then 3 else 99 end cd_etapa_fase_aluno,
case 
     when cd_etapa = 121 then 1
     when cd_etapa = 122 then 2
     when cd_etapa = 123 then 3
     when cd_etapa = 124 then 4
     when cd_etapa = 125 then 5
     when cd_etapa = 126 then 6
     when cd_etapa = 127 then 7
     when cd_etapa = 128 then 8
     when cd_etapa = 129 then 9
     when cd_etapa in(162,184,188) then 10
     when cd_etapa in(163,185,189) then 11
     when cd_etapa in(164,186,190) then 12
     when cd_etapa in(165,187,191) then 13 else 99 end cd_ano_serie
from aluno_etapa ae
),
aluno as ( 
select 
ci_aluno cd_aluno,
case when ta.fl_sexo = 'M' then 1 else 2 end cd_sexo, -- 1: masculino | 2: feminino 
max(case when tad.cd_deficiencia = 2 then 1 else 0 end) fl_baixa_visao,
--Cegueira
max(case when tad.cd_deficiencia = 1 then 1 else 0 end) fl_cegueira,
--Deficiência Auditiva
max(case when tad.cd_deficiencia = 4 then 1 else 0 end) fl_def_auditiva,
--Deficiência Física
max(case when tad.cd_deficiencia = 6 then 1 else 0 end) fl_def_fisica,
--Surdez
max(case when tad.cd_deficiencia = 3 then 1 else 0 end) fl_surdez,
--Surdocegueira
max(case when tad.cd_deficiencia = 5 then 1 else 0 end) fl_surdocegueira,
--Deficiência Intelectual
max(case when tad.cd_deficiencia = 7 then 1 else 0 end) fl_def_intelectual,
--Deficiência Múltipla
max(case when tad.cd_deficiencia = 8 then 1 else 0 end) fl_def_multipla,
--Autismo
max(case when tad.cd_deficiencia between 9 and 12 then 1 else 0 end) fl_autismo,
--Altas habilidades/ superdotação
max(case when tad.cd_deficiencia = 13 then 1 else 0 end) fl_def_fisica
from academico.tb_aluno ta
left join academico.tb_aluno_deficiencia tad on tad.cd_aluno = ta.ci_aluno 
where exists (select 1 from ult_ent et where et.cd_aluno = ci_aluno)
group by 1
)
select * from etapas_padronizadas inner join aluno using(cd_aluno)