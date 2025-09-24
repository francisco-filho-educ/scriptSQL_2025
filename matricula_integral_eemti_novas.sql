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
/*and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2
						and (tut.nr_codigo_unid_trab in ('23263644','23190337','23078901','23185112','23259825','23041811','23021772','23043130','23252600','23545453','23545437','23002468','23009578','23252669','23545496','23031530','23545518','23021322','23016230','23029153','23029943','23026359','23025611','23049375','23545534','23000242','23054409','23054530','23246642','23178248','23057793','23056177','23056606','23059745','23000240','23000243','23264071','23125586','23252413','23132507','23132876','23098775','23085347','23095075','23265833','23120878','23000253','23462361','23149434','23150297','23155817','23179902','23163330','23154721','23159545','23068809','23073721','23272058','23069260','23233885')
                        or tut.cd_categoria  = 9) 
                         )*/
                        ),                        
ult_ent as (
  select
  cd_aluno,
  cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2022 
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ),mat as (
select 
cd_unidade_trabalho,
cd_etapa,
count(1) nr_matricula,
count(distinct ci_turma) nr_turma,
case when exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = t.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2
						and (tut.nr_codigo_unid_trab in ('23263644','23190337','23078901','23185112','23259825','23041811','23021772','23043130','23252600','23545453','23545437','23002468','23009578','23252669','23545496','23031530','23545518','23021322','23016230','23029153','23029943','23026359','23025611','23049375','23545534','23000242','23054409','23054530','23246642','23178248','23057793','23056177','23056606','23059745','23000240','23000243','23264071','23125586','23252413','23132507','23132876','23098775','23085347','23095075','23265833','23120878','23000253','23462361','23149434','23150297','23155817','23179902','23163330','23154721','23159545','23068809','23073721','23272058','23069260','23233885')
                        or tut.cd_categoria  = 9)) then 1 else 0 end  fl_eemti
from turma t
join ult_ent on ci_turma = cd_turma
group by 1,2
)
select ---* from mat
/*
count(distinct tut.ci_unidade_trabalho) nr_escolas,
sum( nr_turma) nr_total_turma,
sum( nr_matricula) nr_total_mat,
sum(case when fl_eemti = 1 then  nr_turma else 0 end) nr_eemti_turma,
sum(case when fl_eemti = 1 then  nr_matricula else 0 end) nr_eemti_mat,
sum(case when tmc.ci_municipio_censo = 2304400 then  nr_turma else 0 end) nr_fortaleza_turma,
sum(case when tmc.ci_municipio_censo = 2304400 then  nr_matricula else 0 end) nr_fortaleza_mat,
sum(case when tmc.ci_municipio_censo = 2304400  and fl_eemti = 1 then  nr_turma else 0 end) nr_eemti_fortaleza_turma,
sum(case when tmc.ci_municipio_censo = 2304400  and fl_eemti = 1 then  nr_matricula else 0 end) nr_eemti_fortaleza_mat
*/
sum(nr_matricula) nr_mat,
sum(case when cd_etapa in(162,184,188) then nr_matricula else 0 end) nr_1_serie,
sum(case when cd_etapa in(163,185,189) then nr_matricula else 0 end) nr_2_serie,
sum(case when cd_etapa in(164,186,190) then nr_matricula else 0 end) nr_3_serie
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
join mat m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab in (401,402)
AND tlut.fl_sede = TRUE 
and fl_eemti = 1
--d tut.nr_codigo_unid_trab in ('23263644','23190337','23078901','23185112','23259825','23041811','23021772','23043130','23252600','23545453','23545437','23002468','23009578','23252669','23545496','23031530','23545518','23021322','23016230','23029153','23029943','23026359','23025611','23049375','23545534','23000242','23054409','23054530','23246642','23178248','23057793','23056177','23056606','23059745','23000240','23000243','23264071','23125586','23252413','23132507','23132876','23098775','23085347','23095075','23265833','23120878','23000253','23462361','23149434','23150297','23155817','23179902','23163330','23154721','23159545','23068809','23073721','23272058','23069260','23233885')

--and tut.nr_codigo_unid_trab = '23000116'
--and tut.cd_categoria =9
--ORDER BY 1,3,4,6;



select 
tut.*
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
--in mat m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab in (401,402)
and tmc.nm_municipio ilike '%santa%uit%eria%'
AND tlut.fl_sede = TRUE 
