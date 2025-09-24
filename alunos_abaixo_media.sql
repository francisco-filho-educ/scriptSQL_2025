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
tt.nr_anoletivo = 2022
and tt.fl_tipo_seriacao = 'RG' and tt.cd_tpensino = 1 and tt.fl_ativo = 'S'
and tt.cd_modalidade <> 38
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27 --and ci_turma = 812865
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
                  and tut.cd_dependencia_administrativa = 2 and tut.cd_categoria = 8 )
), enturmados as (
select 
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
where tu.nr_anoletivo = 2022
and tu.fl_tipo_atividade <> 'AC'
and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
), turma_disc as (
select 
tt2.cd_turma,
tg.ci_grupodisciplina,
tg.ds_grupodisciplina
from academico.tb_turmadisciplina tt2 
join academico.tb_disciplinas td2 on td2.ci_disciplina = tt2.cd_disciplina 
join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina = td2.cd_grupodisciplina 
where tt2.nr_anoletivo = 2022
and exists (select 1 from turma t where  tt2.cd_turma = t.ci_turma) 
group by 1,2,3
), notas as (
select 
ta.cd_aluno,
ta.cd_turma,
ta.cd_periodo,
ta.cd_disciplina,
cd_grupodisciplina,
max(ta.nr_nota) nr_nota 
from academico.tb_alunoavaliacao ta 
join academico.tb_disciplinas disc on disc.ci_disciplina = ta.cd_disciplina 
--and disc.fl_possui_avaliacao = 'S' 
and disc.cd_grupodisciplina between 1 and 14 and cd_periodo = 1
where ta.nr_anoletivo = 2022
and exists (select 1 from enturmados t where t.cd_aluno = ta.cd_aluno) 
group by 1,2,3,4,5 
) -- select count(distinct cd_aluno) from notas
,notas_media as (
select
cd_aluno,
cd_turma,
cd_periodo,
cd_grupodisciplina,
avg(nr_nota) nr_nota,
case when avg(nr_nota) <6 then 1 else 0 end fl_abaixo
from notas 
group by 1,2,3,4
),alunos_abaixo_3 as (
select 
cd_turma,
cd_aluno,
count(distinct cd_grupodisciplina) nr_abaixo
from notas_media nm
where fl_abaixo = 1
group by 1,2
),
qtd_abaixo as (
select 
cd_turma,
count(1) nr_aluno_abaixo
from alunos_abaixo_3 
where nr_abaixo >3
group by 1
),
alunos_notas as (
select 
cd_turma,
count(distinct cd_aluno) nr_aluno_nota
from notas_media
group by 1
) 
select 
sum(nr_aluno_nota) aluno_nota,
sum(nr_aluno_abaixo) nr_aluno_abaixo,
sum(nr_aluno_abaixo) / sum(nr_aluno_nota)::numeric perc
from alunos_notas
left join qtd_abaixo using(cd_turma)

