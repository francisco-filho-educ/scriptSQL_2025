-- QUANTIDADES POR CREDE / SEFOR
/*
select 
tt.nr_anoletivo,
crede.ci_unidade_trabalho id_crede_sefor, 
crede.nm_sigla,
count(distinct tt.cd_unidade_trabalho) nr_escola,
null nr_doc,
count(distinct case when cd_etapa in(162,184,188) then  tt.ci_turma end) nr_1_serie_t,
sum(case when cd_etapa in(162,184,188) then 1 else 0 end) nr_1_serie,
--
null nr_doc,
count(distinct case when cd_etapa in(163,185,189) then tt.ci_turma end) nr_2_serie_t,
sum(case when cd_etapa in(163,185,189) then 1 else 0 end) nr_2_serie,
--
null nr_doc,
count(distinct case when cd_etapa in(164,186,190) then tt.ci_turma end) nr_3_serie_t,
sum(case when cd_etapa in(164,186,190) then 1 else 0 end) nr_3_serie
from academico.tb_turma tt 
join academico.tb_ultimaenturmacao tu on tu.cd_turma = tt.ci_turma 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = cd_unidade_trabalho 
join rede_fisica.tb_unidade_trabalho crede on crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai 
where 
tt.nr_anoletivo = 2022
and tt.cd_prefeitura = 0
and tut.cd_tipo_unid_trab = 401
and tut.cd_dependencia_administrativa = 2
and tt.cd_nivel = 27
and tt.cd_etapa in (162,184,188,163,185,189,164,186,190)
and tt.cd_turno in (4,1,8,9,5)
--and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (6404,101519,102499) ) -- PPDT
and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (101709,100482) ) -- NTPPS
group by 1,2,3
union 
select 
tt.nr_anoletivo,
99  id_crede_sefor, 
'TOTAL' nm_sigla,
count(distinct tt.cd_unidade_trabalho) nr_escola,
null nr_doc,
count(distinct case when cd_etapa in(162,184,188) then  tt.ci_turma end) nr_1_serie_t,
sum(case when cd_etapa in(162,184,188) then 1 else 0 end) nr_1_serie,
--
null nr_doc,
count(distinct case when cd_etapa in(163,185,189) then tt.ci_turma end) nr_2_serie_t,
sum(case when cd_etapa in(163,185,189) then 1 else 0 end) nr_2_serie,
--
null nr_doc,
count(distinct case when cd_etapa in(164,186,190) then tt.ci_turma end) nr_3_serie_t,
sum(case when cd_etapa in(164,186,190) then 1 else 0 end) nr_3_serie
from academico.tb_turma tt 
join academico.tb_ultimaenturmacao tu on tu.cd_turma = tt.ci_turma 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = cd_unidade_trabalho 
join rede_fisica.tb_unidade_trabalho crede on crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai 
where 
tt.nr_anoletivo = 2022
and tt.cd_prefeitura = 0
and tut.cd_tipo_unid_trab = 401
and tut.cd_dependencia_administrativa = 2
and tt.cd_nivel = 27
and tt.cd_etapa in (162,184,188,163,185,189,164,186,190)
and tt.cd_turno in (4,1,8,9,5)
--and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (6404,101519,102499) )-- PPDT
and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (101709,100482) ) -- NTPPS
group by 1,2,3
order by 2
*/

with mat as (
select 
tt.cd_unidade_trabalho,
null nr_doc,
count(distinct case when cd_etapa in(162,184,188) then  tt.ci_turma end) nr_1_serie_t,
sum(case when cd_etapa in(162,184,188) then 1 else 0 end) nr_1_serie,
--
null nr_doc,
count(distinct case when cd_etapa in(163,185,189) then tt.ci_turma end) nr_2_serie_t,
sum(case when cd_etapa in(163,185,189) then 1 else 0 end) nr_2_serie,
--
null nr_doc,
count(distinct case when cd_etapa in(164,186,190) then tt.ci_turma end) nr_3_serie_t,
sum(case when cd_etapa in(164,186,190) then 1 else 0 end) nr_3_serie
from academico.tb_turma tt 
join academico.tb_ultimaenturmacao tu on tu.cd_turma = tt.ci_turma 
where 
tt.nr_anoletivo = 2022
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and tt.cd_etapa in (162,184,188,163,185,189,164,186,190)
and tt.cd_turno in (4,1,8,9,5)
--and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (6404,101519,102499) ) -- PPDT
and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (101709,100482) ) -- NTPPS
group by 1
) 
SELECT 
2022 nr_ano_sige,
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
case when tut.cd_categoria is null then 'Não se aplica'
           when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
	       when  tut.ci_unidade_trabalho = 47258 then 'CREAECE' else upper(tc.nm_categoria) end AS ds_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
mat.*
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












