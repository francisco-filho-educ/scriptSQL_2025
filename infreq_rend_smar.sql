/*
--rendimento_abaixo_media
select 
nr_anoletivo,
cd_crede,
nm_crede,
cd_municipio,
nm_municipio,
cd_unidade_trabalho,
nr_codigo_unid_trab,
nm_unidade_trabalho,
cd_subcategoria,
nm_subcategoria,
is_prioritaria,
ds_classific_dif,
cd_nivel,
ds_nivel,
cd_modalidade,
ds_modalidade,
cd_turno,
ds_turno,
cd_curso,
nm_curso,
cd_etapa,
ds_etapa,
cd_turma,
ds_turma,
cd_periodo,
total_alunos,
ab.abaixo_0,
ab.abaixo_1,
ab.abaixo_2,
ab.abaixo_3,
abaixo_3_ou_mais
from saladesituacao.tb_rendimento_abaixo_da_media ab
where nr_anoletivo = 2024

-- infrequecia_percentual

select 
*
from saladesituacao.tb_infrequencia_percentual_2024 tip 
where nr_anoletivo  = 2024

-- rendimento_alimentacao

select 
*
from saladesituacao.tb_rendimento_geral trg 
where nr_anoletivo = 2023

-- infrequecia_superior
select --8935
nr_anoletivo,
cd_crede,
nm_crede,
cd_municipio,
nm_municipio,
cd_unidade_trabalho,
nr_codigo_unid_trab,
nm_unidade_trabalho,
cd_subcategoria,
nm_subcategoria,
cd_nivel,
ds_nivel,
cd_modalidade,
ds_modalidade,
cd_turno,
ds_turno,
cd_curso,
nm_curso,
cd_etapa,
ds_etapa,
cd_turma,
ds_turma,
max(qtd_enturmados) qtd_enturmados,
--select 
count(distinct cd_aluno) qtd_alunos_infrquentes
--select nm_crede, count(distinct tis.cd_unidade_trabalho) nr_esco
from saladesituacao.tb_infrequencia_superior tis 
where nr_anoletivo = 2023 --and cd_crede = 1 
group by nr_anoletivo,cd_crede,nm_crede,cd_municipio,nm_municipio,cd_unidade_trabalho,nr_codigo_unid_trab,nm_unidade_trabalho,cd_subcategoria,nm_subcategoria,cd_nivel,ds_nivel,cd_modalidade,ds_modalidade,cd_turno,ds_turno,cd_curso,nm_curso,cd_etapa,ds_etapa,cd_turma,ds_turma
*/