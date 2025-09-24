with mat as (
select 
tt.nr_anoletivo,
cd_unidade_trabalho,
ci_turma,
cd_etapa,
cd_aluno
from academico.tb_turma tt 
join public.tb_dm_etapa_aluno_2023_06_01 tu on tu.id_turma_sige = tt.ci_turma 
where 
tt.nr_anoletivo = 2023
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and tt.cd_etapa in (162,184,188,163,185,189,164,186,190)
--and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (6404,101519,102499) ) -- PPDT
--and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (101709,100482) ) -- NTPPS
) 
SELECT 
nr_anoletivo,
tut.cd_unidade_trabalho_pai id_crede_sefor,
upper(crede.nm_sigla) nm_crede_sefor,
count(distinct ci_turma) qtd_turmas,
count(1) NR_matricula,
count(distinct case when exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = mat.ci_turma  and td.cd_disciplina in (101709,100482) ) then  ci_turma end) ntpps_turmas,
count(case when exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = mat.ci_turma  and td.cd_disciplina in (101709,100482) ) then  cd_aluno end) ntpps_matricula,
--1
count(distinct case when cd_etapa in(162,184,188) then  ci_turma end) qtd_turmas_1,
count(case when cd_etapa in(162,184,188)   then  cd_aluno end) nr_matricula_1,
count(distinct case when cd_etapa in(162,184,188) and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = mat.ci_turma  and td.cd_disciplina in (101709,100482) ) then  ci_turma end) ntpps_turmas_1,
count(case when cd_etapa in(162,184,188) and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = mat.ci_turma  and td.cd_disciplina in (101709,100482) ) then  cd_aluno end) ntpps_matricula_1,
--2
count(distinct case when cd_etapa in(163,185,189) then  ci_turma end) qtd_turmas_2,
count(case when cd_etapa in(163,185,189)  then  cd_aluno end) nr_matricula_2,
count(distinct case when cd_etapa in(163,185,189) and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = mat.ci_turma  and td.cd_disciplina in (101709,100482) ) then  ci_turma end) ntpps_turmas_2,
count(case when cd_etapa in(163,185,189) and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = mat.ci_turma  and td.cd_disciplina in (101709,100482) ) then  cd_aluno end) ntpps_matricula_2,
--3
count(distinct case when cd_etapa in(163,185,189) then  ci_turma end) qtd_turmas_3,
count(case when cd_etapa in(163,185,189)  then  cd_aluno end) nr_matricula_3,
count(distinct case when cd_etapa in(163,185,189) and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = mat.ci_turma  and td.cd_disciplina in (101709,100482) ) then  ci_turma end) ntpps_turmas_3,
count(case when cd_etapa in(163,185,189) and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = mat.ci_turma  and td.cd_disciplina in (101709,100482) ) then  cd_aluno end) ntpps_matricula_3
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab in (402,401)
AND tlut.fl_sede = TRUE 
group by 1,2,3

/*
TURMAS
*/
/*

with mat as (
select 
*
from academico.tb_turma tt 
where 
tt.nr_anoletivo = 2024
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and tt.cd_etapa in (162,184,188,163,185,189,164,186,190)
--and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (6404,101519,102499) ) -- PPDT
--and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (101709,100482) ) -- NTPPS
) 
SELECT 
nr_anoletivo,
tut.cd_unidade_trabalho_pai id_crede_sefor,
upper(crede.nm_sigla) nm_crede_sefor,
count(distinct ci_turma) qtd_turmas,
count(distinct case when exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = mat.ci_turma  and td.cd_disciplina in (101709,100482) ) then  ci_turma end) ntpps_turmas,
--1
count(distinct case when cd_etapa in(162,184,188) then  ci_turma end) qtd_turmas_1,
count(distinct case when cd_etapa in(162,184,188) and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = mat.ci_turma  and td.cd_disciplina in (101709,100482) ) then  ci_turma end) ntpps_turmas_1,
--2
count(distinct case when cd_etapa in(163,185,189) then  ci_turma end) qtd_turmas_2,
count(distinct case when cd_etapa in(163,185,189) and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = mat.ci_turma  and td.cd_disciplina in (101709,100482) ) then  ci_turma end) ntpps_turmas_2,
--3
count(distinct case when cd_etapa in(163,185,189) then  ci_turma end) qtd_turmas_3,
count(distinct case when cd_etapa in(163,185,189) and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = mat.ci_turma  and td.cd_disciplina in (101709,100482) ) then  ci_turma end) ntpps_turmas_3
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab in (402,401)
AND tlut.fl_sede = TRUE 
group by 1,2,3

*/