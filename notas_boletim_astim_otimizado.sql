with turma as (
select
*
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2021 
and tt.fl_tipo_seriacao = 'RG' and tt.cd_tpensino = 1 and tt.fl_ativo = 'S'
and tt.cd_modalidade <> 38
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27	
and tt.cd_unidade_trabalho  = 131
), enturmados as (
select 
nr_anoletivo,
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
where tu.nr_anoletivo = 2021
and tu.fl_tipo_atividade <> 'AC'
and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
),aluno_nota as (
    select 
    cd_periodo,
    cd_turma,
    cd_disciplina,
    cd_aluno,
    nr_nota
    from academico.tb_alunoavaliacao ta
    where exists (select 1 from enturmados ent  where ta.nr_anoletivo = ent.nr_anoletivo and ent.cd_aluno = ta.cd_aluno)
), --select *  from aluno_nota
aluno_turma_nota as (
select
tt.cd_unidade_trabalho,
cd_periodo,
cd_aluno,
ds_newetapa as ds_etapa,
ds_turma,
ci_turmadisciplina,
ci_grupodisciplina,
ds_grupodisciplina,
AVG(nr_nota) nr_nota
   from turma tt
   join academico.tb_etapa_etapamodalidade teem on tt.cd_etapa = teem.cd_etapa and tt.cd_modalidade = teem.cd_modalidade
   join academico.tb_turmadisciplina ttd on ci_turma = ttd.cd_turma and ttd.nr_anoletivo = tt.nr_anoletivo
   join academico.tb_disciplinas td on td.ci_disciplina = ttd.cd_disciplina and fl_possui_avaliacao = 'S'
   join academico.tb_grupodisciplina tgd on tgd.ci_grupodisciplina = td.cd_grupodisciplina
   left join aluno_nota taa on taa.cd_turma = tt.ci_turma  and taa.cd_disciplina = ci_disciplina
   where
   ci_grupodisciplina between 1 and 14
   and  (ttd.nr_semestre = 1 or ttd.nr_semestre = 0) 
   and tt.cd_unidade_trabalho  = 131 --- FILTRO DE TESTE
   and cd_aluno = 27
   group by 1,2,3,4,5,6,7,8
 ) select  * from aluno_turma_nota
 
 
 