---TABELA DE NOTAS: aluno_notas
/*
drop table if exists tmp.notas; 
create table tmp.notas as (
with notas_i as (
select 
    taa.nr_anoletivo,
    cd_unidade_trabalho,
    cd_periodo,
    nr_semestre,
    cd_turma,
    ds_ofertaitem,
    cd_etapa,
    cd_disciplina,
    cd_grupodisciplina,
    cd_aluno,
    max(nr_nota) nr_nota
from academico.tb_alunoavaliacao taa
join academico.tb_disciplinas td on ci_disciplina = taa.cd_disciplina and cd_grupodisciplina between 1 and 16 and cd_grupodisciplina <> 5
join academico.tb_turma t on taa.cd_turma = ci_turma  and t.nr_anoletivo =  2024 ---and t.cd_unidade_trabalho = 63
where taa.nr_anoletivo = 2024
and t.cd_prefeitura = 0
and t.cd_etapa in (162,184,188,163,185,189,164,186,190,165,187,191) 
group by 1,2,3,4,5,6,7,8,9,10
)
select 
    nr_anoletivo,
    cd_unidade_trabalho,
    nr_semestre,
    cd_periodo,
    cd_turma,
    ds_ofertaitem,
    cd_etapa,
    cd_grupodisciplina,
    cd_aluno,
    avg(nr_nota) nr_nota
from notas_i 
group by 1,2,3,4,5,6,7,8,9
)
*/
with notas as (
select
n.cd_aluno,
n.cd_turma,
n.cd_periodo,
n.cd_grupodisciplina,
sum(case when nr_nota<6 then 1 else 0 end) fl_abaixo
from tmp.notas n
join saladesituacao.tb_rendimento_geral td on n.cd_grupodisciplina = td.cd_disciplina 
            and n.cd_periodo = td.cd_periodo and td.cd_turma =  n.cd_turma
--inner join tmp.turma_disciplina td using(nr_anoletivo,cd_turma,cd_grupodisciplina,cd_periodo,nr_semestre)
group by 1 ,2,3,4
)
,notas_qtd as (
select 
cd_aluno,
cd_turma,
cd_periodo,
sum(fl_abaixo) qtd
from notas 
group by 1,2,3;

--------------------------------------------------------------------------------------------------------------------------

--TABELA DE ALIMENTAÇÃO DE NOTAS: alimentacao_notas.csv

select 
cd_turma,
cd_periodo,
cd_disciplina,
ds_disciplina,
qtd_informar_ad,
qtd_informado_ad 
from saladesituacao.tb_rendimento_geral trg 
where 
trg.nr_anoletivo = 2024



