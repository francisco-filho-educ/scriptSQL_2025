with 
anexo as ( 
select
ta.ci_ambiente
from rede_fisica.tb_ambiente ta 
join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
join rede_fisica.tb_local_funcionamento tlf on  tlf.ci_local_funcionamento = lut.cd_local_funcionamento 
where
tlf.cd_tipo_local = 4 --unidades prisionais
)
,turma_ppl as (
select *
from academico.tb_turma tt 
where tt.nr_anoletivo in (2021,2022)
and  tt.cd_prefeitura = 0 
and cd_nivel in (26,27)
and (exists (select 1 from academico.tb_turmaatendimento tt2 where tt2.cd_turma = ci_turma and tt2.cd_tpatendimentoturma in (2,3))
    or  (exists (select 1 from anexo an where  an.ci_ambiente = tt.cd_ambiente)))
and tt.fl_ativo = 'S'
--and cd_ambiente is null 
)
, data_ent as (
select 
cd_aluno,
max(te.ci_enturmacao) ci_enturmacao
from academico.tb_enturmacao te 
where exists (select 1 from turma_ppl where ci_turma = te.cd_turma)
and (te.dt_enturmacao between '2021-01-01'::date and '2021-07-31'::date 
	  or te.dt_enturmacao between '2022-01-01'::date and '2022-07-31'::date)
and te.dt_desenturmacao::date > te.dt_enturmacao::date
group by 1

),
ultima_ent as (
select * from academico.tb_enturmacao te 
join data_ent using(ci_enturmacao,cd_aluno)
)
 ,mult  as(
select
tm.nr_anoletivo,
tt.cd_unidade_trabalho,
tm.cd_turma,
ti.cd_nivel,
ti.cd_etapa,
dt_enturmacao,
tm.cd_aluno,
1 fl_multseriado,
tt.cd_ambiente
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
join turma_ppl tt on tm.cd_turma = ci_turma
join ultima_ent ut using(cd_turma,cd_aluno)
) --select * from mult
, outras as (
select
tu.nr_anoletivo,
tt.cd_unidade_trabalho,
cd_turma,
cd_nivel,
cd_etapa,
dt_enturmacao,
cd_aluno,
0 fl_multseriado,
tt.cd_ambiente
from ultima_ent tu
join turma_ppl tt on tu.cd_turma = ci_turma
where 
not exists (select 1 from mult where tu.cd_aluno = mult.cd_aluno or mult.cd_turma = tu.cd_turma)
),
aluno_etapa as(
select * from mult
union
select * from outras
) 
,alunos as (
select
ci_aluno,
fl_sexo,
cd_raca,
case when cd_raca is null then 'Não Declarada' else tr.ds_raca end ds_raca,
case when exists (select 1 from academico.tb_aluno_deficiencia tad where tad.cd_aluno = ci_aluno ) then 1 else 0 end fl_deficiencia,
dta.*
from academico.tb_aluno ta 
join aluno_etapa dta on  dta.cd_aluno = ta.ci_aluno
left join academico.tb_aluno_deficiencia tad on tad.cd_aluno = ta.ci_aluno 
left join academico.tb_raca tr on tr.ci_raca = ta.cd_raca
where
 extract(year from age(dt_enturmacao,dt_nascimento)) <18
 and not exists (select from public.tb_concluintes tc where tc.cd_aluno = dta.cd_aluno and dta.nr_anoletivo =tc.nr_anoletivo )
)
select -- extract(year from age('2023-03-31'::date,'1978-03-20'::date)) 
-- count(1) nr_linha, count(distinct e.cd_aluno) nr_aluno /*
ta.nr_anoletivo , --count(1) nr_linha /*
-- CREDE
crede.nm_sigla,
-- MUNICÍPIO
tl.ds_localidade,
-- INEP
tut.nr_codigo_unid_trab,
-- ESCOLA
tut.nm_unidade_trabalho,
-- Tipo de Atendimento (UP ou CS)	
ttl.nm_tipo_local, 
-- SITUAÇÃO (provisório, sentença, semiliberdade)	
-- Gênero da/o aluno	
-- CATEGORIA DE ESCOLA (Ceja ou Regular)	
nm_subcategoria,
tlf.nm_local_funcionamento,
ds_raca,
--totais
count(distinct cd_aluno  ) total_geral,
count(distinct case when fl_sexo = 'M'      then cd_aluno  end) total_m,
count(distinct case when fl_sexo = 'F'      then cd_aluno  end) total_f,
count(distinct case when fl_deficiencia = 1 then cd_aluno  end) total_defi,
--ano serie
count(distinct case when cd_etapa in (121,122,123,124,125,126,127,128,129,183) then cd_aluno  end) total_fund,
count(distinct case when cd_etapa in (121,122,123,124,125,126,127,128,129,183) and fl_sexo = 'M'      then cd_aluno  end) total_fund_m,
count(distinct case when cd_etapa in (121,122,123,124,125,126,127,128,129,183) and fl_sexo = 'F'      then cd_aluno  end) total_fund_f,
count(distinct case when cd_etapa in (121,122,123,124,125,126,127,128,129,183) and fl_deficiencia = 1 then cd_aluno  end) total_fund_defi,
--anos iniciais
count(distinct case when cd_etapa in (121,122,123,124,125) then cd_aluno end) fund_ai,
count(distinct case when cd_etapa in (121,122,123,124,125) and fl_sexo = 'M'       then cd_aluno end) fund_ai_m,
count(distinct case when cd_etapa in (121,122,123,124,125) and fl_sexo = 'F'       then cd_aluno end) fund_ai_f,
count(distinct case when cd_etapa in (121,122,123,124,125) and fl_deficiencia = 1  then cd_aluno end) fund_ai_def,
-- anos finais
count(distinct case when cd_etapa in (126,127,128,129,183) then cd_aluno  end) fund_af,
count(distinct case when cd_etapa in (126,127,128,129,183) and fl_sexo = 'M'       then cd_aluno  end) fund_af_m,
count(distinct case when cd_etapa in (126,127,128,129,183) and fl_sexo = 'F'       then cd_aluno  end) fund_af_f,
count(distinct case when cd_etapa in (126,127,128,129,183) and fl_deficiencia = 1  then cd_aluno  end) fund_af_def,
--medio regular
count(distinct case when cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) then cd_aluno  end) medio_total_r,
count(distinct case when cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) and fl_sexo = 'M'   then cd_aluno  end) medio_total_r_M,
count(distinct case when cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) and fl_sexo = 'f'  then cd_aluno  end) medio_total_r_F,
count(distinct case when cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) and fl_deficiencia = 1  then cd_aluno  end) medio_total_r_D,

count(distinct case when cd_etapa in(162,184,188) then cd_aluno end) nr_1_serie,
count(distinct case when cd_etapa in(162,184,188) and fl_sexo = 'M'       then cd_aluno end) nr_1_serie_m,
count(distinct case when cd_etapa in(162,184,188) and fl_sexo = 'F'       then cd_aluno end) nr_1_serie_f,
count(distinct case when cd_etapa in(162,184,188) and fl_deficiencia = 1  then cd_aluno end) nr_1_serie_def,

count(distinct case when cd_etapa in(163,185,189) then cd_aluno  end) nr_2_serie,
count(distinct case when cd_etapa in(163,185,189) and fl_sexo = 'M'       then cd_aluno  end) nr_2_serie_m,
count(distinct case when cd_etapa in(163,185,189) and fl_sexo = 'F'       then cd_aluno  end) nr_2_serie_f,
count(distinct case when cd_etapa in(163,185,189) and fl_deficiencia = 1  then cd_aluno  end) nr_2_serie_def,

count(distinct case when cd_etapa in(164,186,190) then cd_aluno  end) nr_3_serie,
count(distinct case when cd_etapa in(164,186,190) and fl_sexo = 'M'       then cd_aluno  end) nr_3_serie_m,
count(distinct case when cd_etapa in(164,186,190) and fl_sexo = 'F'       then cd_aluno  end) nr_3_serie_f,
count(distinct case when cd_etapa in(164,186,190) and fl_deficiencia = 1  then cd_aluno  end) nr_3_serie_def,

count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173)then cd_aluno  end)  Total_ejas,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_sexo = 'M'      then cd_aluno  end)  Total_ejas_m,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_sexo = 'F'      then cd_aluno  end)  Total_ejas_f,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_deficiencia = 1 then cd_aluno  end)  Total_ejas_def,

count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173)  and cd_nivel = 26 then cd_aluno  end)  Total_ejas_fund,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_sexo = 'M'        and cd_nivel = 26 then cd_aluno  end)  Total_ejas_fund_m,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_sexo = 'F'        and cd_nivel = 26 then cd_aluno  end)  Total_ejas_fund_f,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_deficiencia = 1   and cd_nivel = 26 then cd_aluno  end)  Total_ejas_fund_def,

count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173)  and cd_nivel = 27 then cd_aluno  end)  Total_ejas_medio,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_sexo = 'M'        and cd_nivel = 27 then cd_aluno  end)  Total_ejas_medio_m,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_sexo = 'F'        and cd_nivel = 27 then cd_aluno  end)  Total_ejas_medio_f,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_deficiencia = 1   and cd_nivel = 27 then cd_aluno  end)  Total_ejas_medio_def
from alunos ta 
join academico.tb_turmaatendimento tt3 on ta.cd_turma  = tt3.cd_turma 
left join rede_fisica.tb_ambiente tam on tam.ci_ambiente = ta.cd_ambiente 
left join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = tam.cd_local_funcionamento 
left join rede_fisica.tb_tipo_local ttl on ttl.ci_tipo_local = tlf.cd_tipo_local 
join util.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = ta.cd_unidade_trabalho 
join util.tb_unidade_trabalho crede on crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai 
join util.tb_subcategoria ts on ts.ci_subcategoria = tut.cd_subcategoria 
join util.tb_localidades tl on tl.ci_localidade = tut.cd_municipio 
group by 1,2,3,4,5,6,7,8,9

union 
select -- extract(year from age('2023-03-31'::date,'1978-03-20'::date)) 
-- count(1) nr_linha, count(distinct e.cd_aluno) nr_aluno /*
ta.nr_anoletivo , --count(1) nr_linha /*
-- CREDE
crede.nm_sigla,
-- MUNICÍPIO
tl.ds_localidade,
-- INEP
tut.nr_codigo_unid_trab,
-- ESCOLA
tut.nm_unidade_trabalho,
-- Tipo de Atendimento (UP ou CS)	
ttl.nm_tipo_local, 
-- SITUAÇÃO (provisório, sentença, semiliberdade)	
-- Gênero da/o aluno	
-- CATEGORIA DE ESCOLA (Ceja ou Regular)	
nm_subcategoria,
tlf.nm_local_funcionamento,
'TOTAL' ds_raca,
--totais
count(distinct cd_aluno  ) total_geral,
count(distinct case when fl_sexo = 'M'      then cd_aluno  end) total_m,
count(distinct case when fl_sexo = 'F'      then cd_aluno  end) total_f,
count(distinct case when fl_deficiencia = 1 then cd_aluno  end) total_defi,
--ano serie
count(distinct case when cd_etapa in (121,122,123,124,125,126,127,128,129,183) then cd_aluno  end) total_fund,
count(distinct case when cd_etapa in (121,122,123,124,125,126,127,128,129,183) and fl_sexo = 'M'      then cd_aluno  end) total_fund_m,
count(distinct case when cd_etapa in (121,122,123,124,125,126,127,128,129,183) and fl_sexo = 'F'      then cd_aluno  end) total_fund_f,
count(distinct case when cd_etapa in (121,122,123,124,125,126,127,128,129,183) and fl_deficiencia = 1 then cd_aluno  end) total_fund_defi,
--anos iniciais
count(distinct case when cd_etapa in (121,122,123,124,125) then cd_aluno end) fund_ai,
count(distinct case when cd_etapa in (121,122,123,124,125) and fl_sexo = 'M'       then cd_aluno end) fund_ai_m,
count(distinct case when cd_etapa in (121,122,123,124,125) and fl_sexo = 'F'       then cd_aluno end) fund_ai_f,
count(distinct case when cd_etapa in (121,122,123,124,125) and fl_deficiencia = 1  then cd_aluno end) fund_ai_def,
-- anos finais
count(distinct case when cd_etapa in (126,127,128,129,183) then cd_aluno  end) fund_af,
count(distinct case when cd_etapa in (126,127,128,129,183) and fl_sexo = 'M'       then cd_aluno  end) fund_af_m,
count(distinct case when cd_etapa in (126,127,128,129,183) and fl_sexo = 'F'       then cd_aluno  end) fund_af_f,
count(distinct case when cd_etapa in (126,127,128,129,183) and fl_deficiencia = 1  then cd_aluno  end) fund_af_def,
--medio regular
count(distinct case when cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) then cd_aluno  end) medio_total_r,
count(distinct case when cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) and fl_sexo = 'M'   then cd_aluno  end) medio_total_r_M,
count(distinct case when cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) and fl_sexo = 'f'  then cd_aluno  end) medio_total_r_F,
count(distinct case when cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) and fl_deficiencia = 1  then cd_aluno  end) medio_total_r_D,

count(distinct case when cd_etapa in(162,184,188) then cd_aluno end) nr_1_serie,
count(distinct case when cd_etapa in(162,184,188) and fl_sexo = 'M'       then cd_aluno end) nr_1_serie_m,
count(distinct case when cd_etapa in(162,184,188) and fl_sexo = 'F'       then cd_aluno end) nr_1_serie_f,
count(distinct case when cd_etapa in(162,184,188) and fl_deficiencia = 1  then cd_aluno end) nr_1_serie_def,

count(distinct case when cd_etapa in(163,185,189) then cd_aluno  end) nr_2_serie,
count(distinct case when cd_etapa in(163,185,189) and fl_sexo = 'M'       then cd_aluno  end) nr_2_serie_m,
count(distinct case when cd_etapa in(163,185,189) and fl_sexo = 'F'       then cd_aluno  end) nr_2_serie_f,
count(distinct case when cd_etapa in(163,185,189) and fl_deficiencia = 1  then cd_aluno  end) nr_2_serie_def,

count(distinct case when cd_etapa in(164,186,190) then cd_aluno  end) nr_3_serie,
count(distinct case when cd_etapa in(164,186,190) and fl_sexo = 'M'       then cd_aluno  end) nr_3_serie_m,
count(distinct case when cd_etapa in(164,186,190) and fl_sexo = 'F'       then cd_aluno  end) nr_3_serie_f,
count(distinct case when cd_etapa in(164,186,190) and fl_deficiencia = 1  then cd_aluno  end) nr_3_serie_def,

count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173)then cd_aluno  end)  Total_ejas,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_sexo = 'M'      then cd_aluno  end)  Total_ejas_m,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_sexo = 'F'      then cd_aluno  end)  Total_ejas_f,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_deficiencia = 1 then cd_aluno  end)  Total_ejas_def,

count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173)  and cd_nivel = 26 then cd_aluno  end)  Total_ejas_fund,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_sexo = 'M'        and cd_nivel = 26 then cd_aluno  end)  Total_ejas_fund_m,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_sexo = 'F'        and cd_nivel = 26 then cd_aluno  end)  Total_ejas_fund_f,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_deficiencia = 1   and cd_nivel = 26 then cd_aluno  end)  Total_ejas_fund_def,

count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173)  and cd_nivel = 27 then cd_aluno  end)  Total_ejas_medio,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_sexo = 'M'        and cd_nivel = 27 then cd_aluno  end)  Total_ejas_medio_m,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_sexo = 'F'        and cd_nivel = 27 then cd_aluno  end)  Total_ejas_medio_f,
count(distinct case when cd_etapa in (213,214,195,194,175,196,174,173) and fl_deficiencia = 1   and cd_nivel = 27 then cd_aluno  end)  Total_ejas_medio_def
from alunos ta 
join academico.tb_turmaatendimento tt3 on ta.cd_turma  = tt3.cd_turma 
left join rede_fisica.tb_ambiente tam on tam.ci_ambiente = ta.cd_ambiente 
left join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = tam.cd_local_funcionamento 
left join rede_fisica.tb_tipo_local ttl on ttl.ci_tipo_local = tlf.cd_tipo_local 
join util.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = ta.cd_unidade_trabalho 
join util.tb_unidade_trabalho crede on crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai 
join util.tb_subcategoria ts on ts.ci_subcategoria = tut.cd_subcategoria 
join util.tb_localidades tl on tl.ci_localidade = tut.cd_municipio 
group by 1,2,3,4,5,6,7,8,9

