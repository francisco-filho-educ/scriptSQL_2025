with 
anexo as ( 
select
distinct ta.ci_ambiente
from rede_fisica.tb_ambiente ta 
join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
join rede_fisica.tb_local_funcionamento tlf on  tlf.ci_local_funcionamento = lut.cd_local_funcionamento 
where
tlf.cd_tipo_local = 4 --unidades prisionais
--tlf.cd_tipo_local = 6 --Unidade de Atendimento Socioeducativa
)
,turma_ppl_i as (
select
nr_anoletivo,
cd_unidade_trabalho,
cd_turma,
ds_ofertaitem,
ds_turma,
cd_ambiente,
cd_etapa cd_etapa_turma
from academico.tb_turma tt 
join academico.tb_turmaatendimento tt2 on tt2.cd_turma = ci_turma
where tt.nr_anoletivo = 2024
and tt.cd_prefeitura = 0 
and cd_nivel in (26,27)
and tt.fl_ativo = 'S'
and tt2.cd_tpatendimentoturma  = 3
)
,turma_ppl_anexo as (
select
nr_anoletivo,
cd_unidade_trabalho,
ci_turma cd_turma,
ds_ofertaitem,
ds_turma,
cd_ambiente,
cd_etapa cd_etapa_turma
from academico.tb_turma tt 
join academico.tb_turmaatendimento tt2 on tt2.cd_turma = ci_turma
where tt.nr_anoletivo = 2024
and tt.cd_prefeitura = 0 
and cd_nivel in (26,27)
and tt.fl_ativo = 'S'
and exists (select 1 from anexo an where  an.ci_ambiente = tt.cd_ambiente)
and ci_turma not in (select cd_turma from turma_ppl_i)
)
,turma_ppl as (
select * from turma_ppl_i
union  
select * from turma_ppl_anexo
)
, ult_ent as (
select 
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao te 
where
nr_anoletivo = 2024
and exists (select 1 from turma_ppl t where t.cd_turma = te.cd_turma)
) 
,alfabetiado  as(
select
tm.cd_turma,
'SIM' ds_alfabetizado,
tm.cd_aluno
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
join ult_ent using(cd_turma,cd_aluno)
where 
tm.nr_anoletivo = 2024
and ti.cd_prefeitura = 0 --and cd_turma = 965911
) 
--select * from  data_entrada
,alunos as (
select 
ci_aluno,
nm_aluno
from academico.tb_aluno ta 
where exists (select 1 from ult_ent dta where  dta.cd_aluno = ta.ci_aluno)
)
select -- count(1) nr_linha, count(distinct e.cd_aluno) nr_aluno /*
t.nr_anoletivo , --count(1) nr_linha /*
-- MATRICULA (código do aluno)
e.cd_aluno,	
-- NOME DO ALUNO (nome civil)
nm_aluno,	
-- MUNICÍPIO
tl.ds_localidade,
-- INEP
tut.nr_codigo_unid_trab,
-- ESCOLA
tut.nm_unidade_trabalho,
-- CATEGORIA DE ESCOLA (Ceja ou Regular)	
ts.nm_subcategoria,
-- OFERTA
t.ds_ofertaitem,
-- TURMA	
t.ds_turma,
-- UNIDADE DE ATENDIMENTO/Extensão de Matrícula (CS ou UP)
tlf.nm_local_funcionamento,
ttl.nm_tipo_local,
coalesce(ds_alfabetizado,'NÃO') ds_alfabetizado
--anexo.nm_unidade_trabalho,
from turma_ppl t 
join ult_ent e on t.cd_turma =  e.cd_turma 
join alunos ta on e.cd_aluno = ci_aluno 
--join academico.tb_turmaatendimento tt3 on e.cd_turma  = tt3.cd_turma 
left join rede_fisica.tb_ambiente tam on tam.ci_ambiente = t.cd_ambiente 
left join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = tam.cd_local_funcionamento 
left join rede_fisica.tb_tipo_local ttl on ttl.ci_tipo_local = tlf.cd_tipo_local 
join util.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho 
join util.tb_unidade_trabalho crede on crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai 
join util.tb_subcategoria ts on ts.ci_subcategoria = tut.cd_subcategoria 
join util.tb_localidades tl on tl.ci_localidade = tut.cd_municipio 
left join alfabetiado al on al.cd_aluno = e.cd_aluno 
order by 3