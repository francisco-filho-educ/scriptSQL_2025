with alunos as (
select ci_aluno
from academico.tb_aluno ta 
where ta.fl_nome_social 
), situacao as (
select 
2019 nr_anoletivo,
cd_turma,
cd_aluno,
tmr.tp_situacao 
from tb_movimento_rendimento_2019 tmr 
where exists (select 1 from alunos a where a.ci_aluno = tmr.cd_aluno) 
union 
select 
2020 nr_anoletivo,
cd_turma,
cd_aluno,
tmr.tp_situacao 
from tb_movimento_rendimento_2020 tmr 
where exists (select 1 from alunos a where a.ci_aluno = tmr.cd_aluno) 
)
select 
t.nr_anoletivo,
tc.nm_categoria,
count(1) nr_mat,
sum (case when s.tp_situacao = 8 then 1 else 0 end)nr_aba,
sum (case when s.tp_situacao = 8 then 1 else 0 end) / count(1)::numeric p_aba
from situacao s
join academico.tb_turma t on t.ci_turma = s.cd_turma and t.nr_anoletivo = s.nr_anoletivo
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho
join rede_fisica.tb_categoria tc on tc.ci_categoria = tut.cd_categoria 
group by 1,2
union 
select 
t.nr_anoletivo,
'TOTAL' nm_categoria,
count(1) nr_mat,
sum (case when s.tp_situacao = 8 then 1 else 0 end)nr_aba,
sum (case when s.tp_situacao = 8 then 1 else 0 end) / count(1)::numeric nr_aba
from situacao s
join academico.tb_turma t on t.ci_turma = s.cd_turma and t.nr_anoletivo = s.nr_anoletivo
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho
join rede_fisica.tb_categoria tc on tc.ci_categoria = tut.cd_categoria 
group by 1,2
order by 1,2

--select round(0.09027777777777777778*100,2) 







