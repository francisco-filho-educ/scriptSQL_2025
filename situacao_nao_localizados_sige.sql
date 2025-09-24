with turmas as ( 
select 
nr_anoletivo,
cd_unidade_trabalho,
ci_turma cd_turma,
cd_etapa, 
ds_ofertaitem
from academico.tb_turma t
where nr_anoletivo = 2023
and cd_prefeitura  = 0
and cd_nivel in (26,27)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = t.cd_unidade_trabalho and tut.cd_unidade_trabalho_pai = 6)
)
,ult_ent as (
  select
  tu2.nr_anoletivo,
  cd_aluno, 
  cd_turma 
  from academico.tb_ultimaenturmacao tu2 
  where exists (select 1 from turmas t where tu2.cd_turma = t.cd_turma)
  and tu2.fl_tipo_atividade <> 'AC'
) 
,ultimo_mov as (
select 
cd_aluno,
max(tm.ci_movimento) ci_movimento
from academico.tb_movimento tm
where 
fl_tipo_atividade = 'RG' and nr_anoletivo = 2023   
and exists (select 1 from public.temp ut where  ut.cd_aluno =  tm.cd_aluno) 
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho=tm.cd_unidade_trabalho_destino and cd_dependencia_administrativa=2)
group by 1
        )             
--select count(distinct cd_aluno ) from ultimo_mov 
, mov_oferta as(
select 
m3.nr_anoletivo,
m3.cd_aluno,
cd_situacao,
sit.ds_situacao
from academico.tb_movimento m3
join ultimo_mov  mm using(ci_movimento)
left join academico.tb_situacao sit on sit.ci_situacao = m3.cd_situacao
)
select 
ao.cd_aluno,
case when cd_situacao = 2 and ut.cd_aluno is null then 'Matriculado e Enturmado'
     when cd_situacao = 2 and ut.cd_aluno is not null then 'Matriculado NÃO Enturmado'
     else ds_situacao end ds_situacao 
from mov_oferta ao
left join ult_ent ut on ut.cd_aluno = ao.cd_aluno



