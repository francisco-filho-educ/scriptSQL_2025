with 
anexo as ( 
select
ta.ci_ambiente
from rede_fisica.tb_ambiente ta 
join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
join rede_fisica.tb_local_funcionamento tlf on  tlf.ci_local_funcionamento = lut.cd_local_funcionamento 
where
tlf.cd_tipo_local = 4 --unidades prisionais
--tlf.cd_tipo_local = 6 --Unidade de Atendimento Socioeducativa
)
,turma_ppl as (
select *
from academico.tb_turma tt 
where tt.nr_anoletivo >= 2023
and tt.cd_prefeitura = 0 
and cd_nivel in (26,27)
and (exists (select 1 from academico.tb_turmaatendimento tt2 where tt2.cd_turma = ci_turma and tt2.cd_tpatendimentoturma  = 3 )  
    or  (exists (select 1 from anexo an where  an.ci_ambiente = tt.cd_ambiente)))
and tt.fl_ativo = 'S'
-- cd_tpatendimentoturma  =  3 prisionais 
-- cd_tpatendimentoturma  =  2 socioeducativo
--and cd_ambiente is null 
)
--select * from turma_ppl 
, entrada as (
select 
cd_aluno,
min(te.ci_enturmacao) cd_enturmacao_in 
from academico.tb_enturmacao te 
where exists (select 1 from turma_ppl where ci_turma = te.cd_turma)
group by 1
) 
,data_entrada as (
select 
te2.cd_aluno,
te2.cd_turma,
te2.dt_enturmacao,
dt_desenturmacao
from academico.tb_enturmacao te2 
inner join entrada on cd_enturmacao_in = te2.ci_enturmacao 
)
--select * from  data_entrada
,alunos as (
select 
ci_aluno,
ta.cd_inep_aluno,
nm_aluno,
nm_mae,
nm_pai,
nr_cpf,
ta.dt_nascimento,
ta.fl_sexo,
ta.nm_social,
td.nm_deficiencia 
from academico.tb_aluno ta 
left join academico.tb_aluno_deficiencia tad on tad.cd_aluno = ta.ci_aluno 
left join academico.tb_deficiencia td on td.ci_deficiencia = tad.cd_deficiencia 
where exists (select 1 from data_entrada dta where  dta.cd_aluno = ta.ci_aluno)
)
select -- count(1) nr_linha, count(distinct e.cd_aluno) nr_aluno /*
t.nr_anoletivo , --count(1) nr_linha /*
-- MATRICULA (código do aluno)
e.cd_aluno,	
-- NOME DO ALUNO (nome civil)
nm_aluno,	
-- NOME SOCIAL (quando houver)	
nm_social,
-- Gênero da/o aluno	
ta.fl_sexo,
-- DATA DE NASCIMENTO
to_char(dt_nascimento,'dd/mm/yyyy') dt_nascimento,	
nr_cpf,
nm_mae,
nm_pai,
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
-- SITUAÇÃO (provisório, sentença, semiliberdade)	
-- DATA DE INGRESSO (data da enturmação)	
to_char(dt_enturmacao,'dd/mm/yyyy') dt_enturmacao,
-- DATA DE saida (data desenturmacao)
to_char(dt_desenturmacao,'dd/mm/yyyy')  dt_desenturmacao
--anexo.nm_unidade_trabalho,
from turma_ppl t 
join data_entrada e on t.ci_turma =  e.cd_turma 
join alunos ta on e.cd_aluno = ci_aluno 
--join academico.tb_turmaatendimento tt3 on e.cd_turma  = tt3.cd_turma 
left join rede_fisica.tb_ambiente tam on tam.ci_ambiente = t.cd_ambiente 
left join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = tam.cd_local_funcionamento 
left join rede_fisica.tb_tipo_local ttl on ttl.ci_tipo_local = tlf.cd_tipo_local 
join util.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho 
join util.tb_unidade_trabalho crede on crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai 
join util.tb_subcategoria ts on ts.ci_subcategoria = tut.cd_subcategoria 
join util.tb_localidades tl on tl.ci_localidade = tut.cd_municipio 
order by 3