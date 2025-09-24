drop table if exists tmp.tb_aluno_turma_disciplina;
create table tmp.tb_aluno_turma_disciplina as (
with turmas as (
select
nr_anoletivo,
cd_unidade_trabalho,
ci_turma,
cd_etapa,
cd_turno,
cd_nivel
from academico.tb_turma tt 
where 
    tt.nr_anoletivo = 2024  
    and tt.fl_tipo_seriacao <> 'AC' 
    and tt.cd_tpensino = 1 
    and tt.fl_ativo = 'S' 
    and tt.cd_modalidade <> 38 
    and tt.cd_prefeitura = 0 
    and tt.cd_nivel = 27
    and tt.cd_unidade_trabalho = 678 and ci_turma = 964593
) 
,periodo as ( 
select 
     tput.*,
     nr_semestre
 from 
     academico.tb_periodounidadetrabalho tput
     join academico.tb_periodo tp on 
         ci_periodo = tput.cd_periodo
 where 
     cd_periodo < 5 
     and nr_anoletivo = 2024  
     and cd_unidade_trabalho = 678
     and (dt_fim)::date < current_date::date
)
,periodo_turma as (
select 
ci_turma cd_turma, 
cd_periodo,
nr_semestre
from turmas t
join periodo using(cd_unidade_trabalho)
group by 1,2,3
)
,turma_disciplina as (
select 
td.cd_turma,
cd_disciplina, 
cd_periodo
from academico.tb_turmadisciplina td
join periodo_turma t on t.cd_turma = td.cd_turma and t.nr_semestre  = td.nr_semestre
where 
td.nr_anoletivo = 2024
and t.nr_semestre>0
union
select 
td.cd_turma,
cd_disciplina, 
cd_periodo
from academico.tb_turmadisciplina td
join (select cd_turma, cd_periodo from periodo_turma group by 1,2) pt on td.cd_turma =  pt.cd_turma
where 
td.nr_anoletivo = 2024
and td.nr_semestre = 0
)
select 
    cd_turma,
    cd_disciplina,
    cd_aluno,
    cd_periodo
from academico.tb_ultimaenturmacao tue
join turma_disciplina td using(cd_turma)
where
tue.nr_anoletivo  = 2024 
and tue.fl_tipo_atividade <> 'AC'
)
select 
    td.cd_turma,
    td.cd_disciplina,
    td.cd_aluno,
    td.cd_periodo,
    nr_nota
from tmp.tb_aluno_turma_disciplina td 
join academico.tb_alunoavaliacao taa using(cd_aluno,cd_turma,cd_disciplina,cd_periodo)
where nr_anoletivo = 2024








