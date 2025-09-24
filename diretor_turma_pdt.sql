select 
tt.nr_anoletivo,
crede.ci_unidade_trabalho id_crede_sefor, 
crede.nm_sigla,
case when cd_turno in (4,1) then 1
     when cd_turno in (8,9,5) then 2 end id_turno,
case when cd_turno in (4,1) then 'Diurno - parcial'
     when cd_turno in (8,9,5) then 'Integral' end ds_turNo,
count(distinct tt.cd_unidade_trabalho) nr_escola,
count(distinct tt.ci_turma) nr_turma,
count(1) nr_aluno,
count(distinct case when cd_etapa in(162,184,188) then tt.cd_unidade_trabalho end) nr_1_serie_esc,
count(distinct case when cd_etapa in(162,184,188) then  tt.ci_turma end) nr_1_serie_t,
sum(case when cd_etapa in(162,184,188) then 1 else 0 end) nr_1_serie,
--
count(distinct case when cd_etapa in(163,185,189) then  tt.cd_unidade_trabalho  else 0 end) nr_2_serie_esc,
count(distinct case when cd_etapa in(163,185,189) then tt.ci_turma end) nr_2_serie_t,
sum(case when cd_etapa in(163,185,189) then 1 else 0 end) nr_2_serie,
--
count(distinct case when cd_etapa in(164,186,190) then  tt.cd_unidade_trabalho  else 0 end) nr_3_serie_esc,
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
and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (6404,101519,102499) )
group by 1,2,3,4,5
union 
select 
tt.nr_anoletivo,
crede.ci_unidade_trabalho id_crede_sefor, 
crede.nm_sigla,
9 id_turno,
'TOTAL' ds_turNo,
count(distinct tt.cd_unidade_trabalho) nr_escola,
count(distinct tt.ci_turma) nr_turma,
count(1) nr_aluno,
count(distinct case when cd_etapa in(162,184,188) then tt.cd_unidade_trabalho end) nr_1_serie_esc,
count(distinct case when cd_etapa in(162,184,188) then  tt.ci_turma end) nr_1_serie_t,
sum(case when cd_etapa in(162,184,188) then 1 else 0 end) nr_1_serie,
--
count(distinct case when cd_etapa in(163,185,189) then  tt.cd_unidade_trabalho  else 0 end) nr_2_serie_esc,
count(distinct case when cd_etapa in(163,185,189) then tt.ci_turma end) nr_2_serie_t,
sum(case when cd_etapa in(163,185,189) then 1 else 0 end) nr_2_serie,
--
count(distinct case when cd_etapa in(164,186,190) then  tt.cd_unidade_trabalho  else 0 end) nr_3_serie_esc,
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
and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (6404,101519,102499) )
group by 1,2,3,4,5
union 
select 
tt.nr_anoletivo,
99 id_crede_sefor, 
'TOTAL' nm_sigla,
9 id_turno,
'TOTAL' ds_turNo,
count(distinct tt.cd_unidade_trabalho) nr_escola,
count(distinct tt.ci_turma) nr_turma,
count(1) nr_aluno,
count(distinct case when cd_etapa in(162,184,188) then tt.cd_unidade_trabalho end) nr_1_serie_esc,
count(distinct case when cd_etapa in(162,184,188) then  tt.ci_turma end) nr_1_serie_t,
sum(case when cd_etapa in(162,184,188) then 1 else 0 end) nr_1_serie,
--
count(distinct case when cd_etapa in(163,185,189) then  tt.cd_unidade_trabalho  else 0 end) nr_2_serie_esc,
count(distinct case when cd_etapa in(163,185,189) then tt.ci_turma end) nr_2_serie_t,
sum(case when cd_etapa in(163,185,189) then 1 else 0 end) nr_2_serie,
--
count(distinct case when cd_etapa in(164,186,190) then  tt.cd_unidade_trabalho  else 0 end) nr_3_serie_esc,
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
and exists (select 1 from academico.tb_turmadisciplina td where td.cd_turma = tt.ci_turma  and td.cd_disciplina in (6404,101519,102499) )
group by 1,2,3,4,5
order by 3,4