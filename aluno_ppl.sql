with turma_ppl as (
select  * 
from academico.tb_turma tt 
where tt.nr_anoletivo = 2018 
and tt.cd_prefeitura = 0 
and cd_nivel in (26,27)
and exists (select 1 from academico.tb_turmaatendimento tt2 where tt2.cd_turma = ci_turma and tt2.cd_tpatendimentoturma in (2,3))
and tt.fl_ativo = 'S'
), entrada as (
select 
cd_aluno,min(te.ci_enturmacao) cd_enturmacao_in 
from academico.tb_enturmacao te 
where exists (select 1 from turma_ppl where ci_turma = te.cd_turma)
group by 1
), saida as (
select 
cd_aluno,max(te.ci_enturmacao) cd_enturmacao_out
from academico.tb_enturmacao te 
where exists (select 1 from turma_ppl where ci_turma = te.cd_turma)
group by 1
),data_entrada as (
select 
te2.cd_aluno,
te2.cd_turma,
te2.dt_enturmacao 
from academico.tb_enturmacao te2 
inner join entrada on cd_enturmacao_in = te2.ci_enturmacao 
),data_saida as (
select 
te2.cd_aluno,
te2.cd_turma,
te2.dt_desenturmacao
from academico.tb_enturmacao te2 
inner join saida on cd_enturmacao_out = te2.ci_enturmacao 
) select 
cd_aluno ,
e.cd_turma,
dt_enturmacao,
dt_desenturmacao
from data_entrada e join data_saida s using(cd_aluno)



