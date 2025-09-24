/*
with projeto as ( 
select 
tt.cd_unidade_trabalho, 
max(case when exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (6404,101519,102499) ) then 1 else 0 end )fl_pddt,
max(case when exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (101709,100482) ) then 1 else 0 end) fl_ntpps 
from academico.tb_turma tt 
where 
tt.nr_anoletivo = 2023
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and tt.cd_etapa in (162,184,188,163,185,189,164,186,190)
and tt.cd_turno in (4,1,8,9,5)
--and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (6404,101519,102499) ) -- PPDT
--and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (101709,100482) ) -- NTPPS
group by 1
)
,integral as (
select 
tt.cd_unidade_trabalho, 
max(case when tt.cd_turno in (5,8,9) then 1 else 0 end) fl_integral
from academico.tb_turma tt 
where 
tt.nr_anoletivo = 2023
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
group by 1
)
--RELATORIO POR CREDE
/*
SELECT
2023 nr_anoletivo,
tut.cd_unidade_trabalho_pai id_crede_sefor,
upper(crede.nm_sigla) nm_crede_sefor, 
count(1) qtd_escolas,
sum(fl_integral) qtd_temp_i,
sum(fl_pddt) qtd_pddt,
sum(fl_ntpps) qtd_ntpps
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join integral i on i.cd_unidade_trabalho = tut.ci_unidade_trabalho 
left join projeto p on p.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = TRUE 
group by 1,2,3
*/
--RELATORIO POR MUNICIPIO
/*
SELECT
2023 nr_anoletivo,
case when crede.ci_unidade_trabalho < 21 then  crede.ci_unidade_trabalho else 99 END id_crede_sefor, 
upper(case when crede.ci_unidade_trabalho < 21 then  crede.nm_sigla else 'SEFOR' END) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
count(1) qtd_escolas,
sum(fl_integral) qtd_temp_i,
sum(fl_pddt) qtd_pddt,
sum(fl_ntpps) qtd_ntpps
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join integral i on i.cd_unidade_trabalho = tut.ci_unidade_trabalho 
left join projeto p on p.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = TRUE 
group by 1,2,3,4
order by 2
*/
--RELATORIO POR BAIRRO DE FORTALEZA
SELECT
2023 nr_anoletivo,
--tut.nm_unidade_trabalho,
upper(tmc.nm_municipio) AS nm_municipio,
--tlf.nm_bairro,
upper(case when  nm_bairro ilike 'barra do c%' then 'BARRA DO CEARA' 
     when  nm_bairro ilike 'CONJ%CEA%' then 'CONJUNTO CEARA'
     when  nm_bairro ilike 'J_QUEI CLUBE' then 'JOQUEI CLUBE'
     else nm_bairro end) nm_bairro,
--upper(tlf.nm_bairro) nm_bairro,
count(1) qtd_escolas,
sum(fl_integral) qtd_temp_i,
sum(fl_pddt) qtd_pddt,
sum(fl_ntpps) qtd_ntpps
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo and tlf.cd_municipio_censo = 2304400
join integral i on i.cd_unidade_trabalho = tut.ci_unidade_trabalho 
left join projeto p on p.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = true-- and nm_bairro = 'CONJUNO CEARA'
group by 1,2,3
order by 3
*/
------ CURSOS EEEPS ----------------------------------------------------
/*
with cursos_eep as ( 
select 
tt.cd_unidade_trabalho, 
tc.nm_curso
from academico.tb_turma tt 
join academico.tb_curso tc on tt.cd_curso = tc.ci_curso 
where 
tt.nr_anoletivo = 2023
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and cd_modalidade =40
and cd_curso <> 1
group by 1,2
)/*
select
2023 nr_anoletivo,
--tut.nm_unidade_trabalho,
upper(tmc.nm_municipio) AS nm_municipio,
--tlf.nm_bairro,
upper(case when  nm_bairro ilike 'barra do c%' then 'BARRA DO CEARA' 
     when  nm_bairro ilike 'CONJ%CEA%' then 'CONJUNTO CEARA'
     when  nm_bairro ilike 'J_QUEI CLUBE' then 'JOQUEI CLUBE'
     else nm_bairro end) nm_bairro,
nm_curso,
count(distinct tut.ci_unidade_trabalho) qtd_escolas
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo and tlf.cd_municipio_censo = 2304400
join cursos_eep i on i.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = true-- and nm_bairro = 'CONJUNO CEARA'
and tut.cd_categoria  = 8
group by 1,2,3,4
order by 3*/
--RELATORIO POR CREDE
/*
SELECT
2023 nr_anoletivo,
tut.cd_unidade_trabalho_pai id_crede_sefor,
upper(crede.nm_sigla) nm_crede_sefor,
nm_curso,
count(distinct tut.ci_unidade_trabalho) qtd_escolas
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join cursos_eep i on i.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = TRUE and tut.cd_categoria  = 8
group by 1,2,3,4
*/
--RELATORIO POR MUNICIPIO
SELECT
2023 nr_anoletivo,
case when crede.ci_unidade_trabalho < 21 then  crede.ci_unidade_trabalho else 99 END id_crede_sefor, 
upper(case when crede.ci_unidade_trabalho < 21 then  crede.nm_sigla else 'SEFOR' END) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
nm_curso,
count(distinct tut.ci_unidade_trabalho) qtd_escolas
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join cursos_eep i on i.cd_unidade_trabalho = tut.ci_unidade_trabalho
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = TRUE and tut.cd_categoria  = 8
group by 1,2,3,4,5
order by 2
*/
-------------------------------- CAD UNINICO -----------------------------------------------------------------------------------
--RELATORIO POR BAIRRO DE FORTALEZA
SELECT
2023 nr_anoletivo,
--tut.nm_unidade_trabalho,
upper(tmc.nm_municipio) AS nm_municipio,
--tlf.nm_bairro,
upper(case when  nm_bairro ilike 'barra do c%' then 'BARRA DO CEARA' 
     when  nm_bairro ilike 'CONJ%CEA%' then 'CONJUNTO CEARA'
     when  nm_bairro ilike 'J_QUEI CLUBE' then 'JOQUEI CLUBE'
     else nm_bairro end) nm_bairro,
--upper(tlf.nm_bairro) nm_bairro,
count(1) qtd_escolas,
sum(fl_integral) qtd_temp_i,
sum(fl_pddt) qtd_pddt,
sum(fl_ntpps) qtd_ntpps
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo and tlf.cd_municipio_censo = 2304400
join integral i on i.cd_unidade_trabalho = tut.ci_unidade_trabalho 
left join projeto p on p.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = true-- and nm_bairro = 'CONJUNO CEARA'
group by 1,2,3
order by 3

