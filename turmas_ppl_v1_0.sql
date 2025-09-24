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
where tt.nr_anoletivo >= 2018
and tt.cd_prefeitura = 0 
and cd_nivel in (26,27)
and (exists (select 1 from academico.tb_turmaatendimento tt2 where tt2.cd_turma = ci_turma and tt2.cd_tpatendimentoturma in (2,3))
    or  (exists (select 1 from anexo an where  an.ci_ambiente = tt.cd_ambiente)))
and tt.fl_ativo = 'S'
--and cd_ambiente is null 
), entrada as (
select 
cd_aluno,
min(te.ci_enturmacao) cd_enturmacao_in 
from academico.tb_enturmacao te 
where exists (select 1 from turma_ppl where ci_turma = te.cd_turma)
group by 1
) --select * from  entrada 
, saida as (
select 
cd_aluno,
max(te.ci_enturmacao) cd_enturmacao_out
from academico.tb_enturmacao te 
where exists (select 1 from turma_ppl where ci_turma = te.cd_turma)
group by 1
),-- select * from  saida
data_entrada as (
select 
te2.cd_aluno,
te2.cd_turma,
te2.dt_enturmacao
from academico.tb_enturmacao te2 
inner join entrada on cd_enturmacao_in = te2.ci_enturmacao 
),data_saida as (
select 
te2.cd_aluno,
te2.cd_turma,
te2.dt_desenturmacao
from academico.tb_enturmacao te2 
inner join saida on cd_enturmacao_out = te2.ci_enturmacao 
), ultimo_mov as (
select 
cd_aluno,
max(tm.ci_movimento) ci_movimento
from academico.tb_movimento tm 
where 
nr_anoletivo in (select distinct nr_anoletivo from turma_ppl)
and exists (select 1 from data_entrada det where det.cd_aluno = tm.cd_aluno)
and tm.cd_unidade_trabalho_destino in (select distinct cd_unidade_trabalho from turma_ppl)
and tm.cd_unidade_trabalho_origem <> tm.cd_unidade_trabalho_destino 
and tm.cd_situacao = 2
group by 1
), aluno_mov as ( 
select 
nr_anoletivo,
cd_aluno,
cd_unidade_trabalho_origem,
tm.cd_ofertaitem_origem
from academico.tb_movimento tm 
join  ultimo_mov using(ci_movimento,cd_aluno)
),
--select * from  data_entrada
alunos as (
select 
ci_aluno,
ta.cd_inep_aluno,
nm_aluno,
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
t.cd_unidade_trabalho,
--ttl.nm_tipo_local, 
-- CREDE
tut.nm_sigla,
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
ta.fl_sexo,
-- CATEGORIA DE ESCOLA (Ceja ou Regular)	
ts.nm_subcategoria,
-- OFERTA
t.ds_ofertaitem,
-- TURMA	
t.ds_turma,
-- UNIDADE DE ATENDIMENTO/Extensão de Matrícula (CS ou UP)
tlf.nm_local_funcionamento,
--anexo.nm_unidade_trabalho,
-- MATRICULA (código do aluno)
e.cd_aluno,	
-- NOME DO ALUNO (nome civil)
nm_aluno,	
-- NOME SOCIAL (quando houver)	
nm_social,
-- DATA DE NASCIMENTO
dt_nascimento,	
-- DEFICIÊNCIA	
nm_deficiencia, 
-- DATA DE INGRESSO (data da enturmação)	
dt_enturmacao,
-- DATA DE saida (data desenturmacao)
dt_desenturmacao,
-- ESCOLA ANTERIOR (última escola em que o estudante esteve matriculado)	
case when  tut_o.nr_codigo_unid_trab = '00' or tut_o.ci_unidade_trabalho is null then 'Escola não localizada'
     when  tut_o.nr_codigo_unid_trab = '000'  then 'Inexistente' else tut_o.nm_unidade_trabalho end escola_ant,
-- ANO DA MATRÍCULA NA ESCOLA ANTERIOR
-- OFERTA DA MATRÍCULA NA ESCOLA ANTERIOR	
case when to_o.ci_ofertaitem = 95618 then 'NUNCA ESTUDOU' 
     when to_o.ci_ofertaitem is null  then 'Oferta não localizada'
     else to_o.ds_ofertaitem END oferta_anterior,
'SEDUC/SIGE ESCOLA 2018 A 2021 - Produzido por SEDUC/COADE/CEIPE/Indicadores'  fonte_origem--*/
from turma_ppl t 
join data_entrada e on t.ci_turma =  e.cd_turma 
join alunos ta on e.cd_aluno = ci_aluno 
left join data_saida s using(cd_aluno)
join academico.tb_turmaatendimento tt3 on e.cd_turma  = tt3.cd_turma 
left join rede_fisica.tb_ambiente tam on tam.ci_ambiente = t.cd_ambiente 
left join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = tam.cd_local_funcionamento 
left join rede_fisica.tb_tipo_local ttl on ttl.ci_tipo_local = tlf.cd_tipo_local 
join util.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho 
join util.tb_unidade_trabalho crede on crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai 
join util.tb_subcategoria ts on ts.ci_subcategoria = tut.cd_subcategoria 
join util.tb_localidades tl on tl.ci_localidade = tut.cd_municipio 
--left join rede_fisica.tb_local_unid_trab tlut on tlut.cd_local_funcionamento = tam.cd_local_funcionamento 
left join aluno_mov  am on am.cd_aluno = e.cd_aluno 
left  join academico.tb_ofertaitens to_o on to_o.ci_ofertaitem = am.cd_ofertaitem_origem
left  join rede_fisica.tb_unidade_trabalho tut_o on  tut_o.ci_unidade_trabalho = cd_unidade_trabalho_origem
order by 1
