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

-- infrequecia percentual

select 
*
from saladesituacao.tb_infrequencia_percentual_2024 tip 
where nr_anoletivo  = 2024

-- rendimento alimentacao

select 
*
from saladesituacao.tb_rendimento_geral trg 
where nr_anoletivo = 2024

-- infrequecia acima de 20

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
where nr_anoletivo = 2024 --and cd_crede = 1 
--group by 1
group by nr_anoletivo,cd_crede,nm_crede,cd_municipio,nm_municipio,cd_unidade_trabalho,nr_codigo_unid_trab,nm_unidade_trabalho,cd_subcategoria,nm_subcategoria,cd_nivel,ds_nivel,cd_modalidade,ds_modalidade,cd_turno,ds_turno,cd_curso,nm_curso,cd_etapa,ds_etapa,cd_turma,ds_turma
*/

# INFREQUENCIA 20% POR ALUNO:
select --8935
nr_anoletivo,
cd_crede,
nm_crede,
tis.cd_municipio,
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
tis.qtd_enturmados,
cd_aluno,
nm_aluno,
to_char(ta.dt_nascimento,'dd/mm/yyyy') dt_nascimento, 
case when ta.fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo,
case when cd_raca is null then 'Não Declarada' else tr.ds_raca end ds_raca,
nr_aulas,
nr_faltas 
from saladesituacao.tb_infrequencia_superior tis 
join academico.tb_aluno ta on ta.ci_aluno = tis.cd_aluno 
left join academico.tb_raca tr on tr.ci_raca = cd_raca
where nr_anoletivo = 2024
and cd_aluno is not null

#


-- VERSAO SERGIO -------------------------------------
/*
-- rendimento alimentação
SELECT
ds_turma,  
cd_turma,
ds_turno, 
cd_etapa,
nm_unidade_trabalho, 
cd_unidade_trabalho,
ds_disciplina, 
cd_disciplina,
nr_codigo_unid_trab,
ds_etapa,   
qtd_informado_ad, -- as duas últimas de cada tabela são as singulares dessa tabela
qtd_informar_ad
--select *
from saladesituacao.tb_rendimento_geral trg 
where nr_anoletivo = 2024

-- 2 == rendimento abaixo da média
SELECT
ds_turma,  
cd_turma,
ds_turno, 
cd_etapa,
nm_unidade_trabalho, 
cd_unidade_trabalho,
nr_codigo_unid_trab,
ds_etapa, 
abaixo_3_ou_mais, -- 
total_alunos
from saladesituacao.tb_rendimento_abaixo_da_media tr
where nr_anoletivo = 2024

-- 3 == infrequencia percentual
SELECT
ds_turma,  
cd_turma,
ds_turno, 
cd_etapa,
nm_unidade_trabalho, 
cd_unidade_trabalho,
ds_disciplina, 
cd_disciplina,
nr_codigo_unid_trab,
ds_etapa, 
nr_registrado,
nr_freq
from saladesituacao.tb_infrequencia_percentual tip 
where nr_anoletivo = 2024






