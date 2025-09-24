with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
case when cd_turno in (8,9) then 'Integral' else ds_turno end ds_turno,
cd_unidade_trabalho
from academico.tb_turma tt 
join academico.tb_turno tr on tr.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2022 
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and cd_turno in (8,9,5)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2
						and (tut.nr_codigo_unid_trab in ('23263644','23190337','23078901','23185112','23259825','23041811','23021772','23043130','23252600','23545453','23545437','23002468','23009578','23252669','23545496','23031530','23545518','23021322','23016230','23029153','23029943','23026359','23025611','23049375','23545534','23000242','23054409','23054530','23246642','23178248','23057793','23056177','23056606','23059745','23000240','23000243','23264071','23125586','23252413','23132507','23132876','23098775','23085347','23095075','23265833','23120878','23000253','23462361','23149434','23150297','23155817','23179902','23163330','23154721','23159545','23068809','23073721','23272058','23069260','23233885')
                        or tut.cd_categoria  = 9) 
                         )
                        ),                        
ult_ent as (
  select
  cd_aluno,
  cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2022 
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  )
select 
 count(distinct cd_aluno)
from turma 
join ult_ent on ci_turma = cd_turma

