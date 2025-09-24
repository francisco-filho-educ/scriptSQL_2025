with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2021 
and tt.fl_tipo_seriacao = 'RG' and tt.cd_tpensino = 1 and tt.fl_ativo = 'S'
and tt.cd_modalidade <> 38
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2 and tut.cd_unidade_trabalho_pai>20)
), enturmados as (
select 
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
where tu.nr_anoletivo = 2021
and tu.fl_tipo_atividade <> 'AC'
and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
), turma_disc as (
select 
tt2.cd_disciplina,
tt2.cd_turma,
tg.ci_grupodisciplina,
tg.ds_grupodisciplina
from academico.tb_turmadisciplina tt2 
join academico.tb_disciplinas td2 on td2.ci_disciplina = tt2.cd_disciplina 
join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina = td2.cd_grupodisciplina 
where tt2.nr_anoletivo = 2021
and exists (select 1 from turma t where  tt2.cd_turma = t.ci_turma) 
), notas as (
select 
ta.cd_aluno,
ta.cd_turma,
ta.cd_periodo,
ta.cd_disciplina,
max(ta.nr_nota) nr_nota 
from academico.tb_alunoavaliacao ta 
where ta.nr_anoletivo = 2021
and exists (select 1 from turma t where ta.cd_turma = t.ci_turma) 
and exists (select 1 from academico.tb_disciplinas disc where disc.ci_disciplina = ta.cd_disciplina and disc.fl_tipo = 'B') 
group by 1,2,3,4 
)
select 
nr_anoletivo,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho,
e.cd_aluno,
e.cd_turma,
td.cd_disciplina,
td.ci_grupodisciplina,
td.ds_grupodisciplina,
n.cd_periodo,
n.nr_nota
from enturmados e
inner join turma on ci_turma = e.cd_turma
inner join turma_disc td on td.cd_turma = e.cd_turma
left join notas n on n.cd_aluno = e.cd_aluno and e.cd_turma = n.cd_turma and td.cd_disciplina = n.cd_disciplina