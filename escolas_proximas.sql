 with turma as (
select
*
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2022
and tt.fl_ativo = 'S'
and tt.cd_prefeitura = 0
and tt.cd_nivel in  (27,28,29) --and  ci_turma = 819643
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
                  and tut.cd_dependencia_administrativa = 2 )
)
, enturmados as (
select 
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
where tu.nr_anoletivo = 2022
and tu.fl_tipo_atividade <> 'AC'
and exists (select 1 from turma t where ci_turma = tu.cd_turma)
)
select  
tut.ci_unidade_trabalho,
tmc.nm_municipio,
tut.nm_unidade_trabalho, 
count(1) nr_enturmados 
from enturmados
inner join turma t on cd_turma = ci_turma 
join rede_fisica.tb_unidade_trabalho tut on t.cd_unidade_trabalho = tut.ci_unidade_trabalho 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab in (402,401)
AND tlut.fl_sede = TRUE 
--and tut.ci_unidade_trabalho in (525,528,595,684,692,481,492,218,226,235)
--and tut.ci_unidade_trabalho in (236,619,668,602,639,487,470,222)
and tut.ci_unidade_trabalho in (665,641,575,488,591,223,234,346,472)
--and tut.nm_unidade_trabalho
  --in ('EEFM JOSÉ BEZERRA MENEZES','EEFM SÃO JOSÉ DOS ARPOADORES','EEFM DOUTOR CÉSAR CALS','EEEP JUAREZ TÁVORA','EEM PROFESSOR ARRUDA','EEEP PRESIDENTE ROOSEVELT','EEM DOUTOR JOÃO RIBEIRO RAMOS','EEM VIRGÍLIO TÁVORA','EEEP JOAQUIM ANTÔNIO ALBANO') --or tut.ci_unidade_trabalho in (525,528,595,684,692,481,492,218,226,235)
  group by 1,2,3
  order by 3