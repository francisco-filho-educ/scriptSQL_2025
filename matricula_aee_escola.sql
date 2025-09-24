with turmas as (
select 
*
from academico.tb_turma tt
where 
tt.nr_anoletivo = 2024
and tt.cd_prefeitura = 0
)
,enturmacao_esc as (
select
cd_unidade_trabalho cd_unidade_trabalho_esc,
ds_ofertaitem ds_etapa_esc,
cd_aluno,
cd_turma cd_turma_esc
from academico.tb_ultimaenturmacao tu 
join turmas on ci_turma = cd_turma
where
tu.nr_anoletivo = 2024
and tu.fl_tipo_atividade <> 'AC'
and cd_nivel in (26,27,28)
and tu.cd_aluno in (select distinct cd_aluno from academico.tb_aluno_deficiencia)
)
--select count(1) from enturmacao_esc --15515
--select * from enturmacao_esc --15515
---
,enturmacao_aee as (
select
cd_unidade_trabalho cd_unidade_trabalho_aee,
ds_ofertaitem ds_etapa_aee,
cd_aluno,
cd_turma cd_turma_aee
from academico.tb_ultimaenturmacao tu 
join turmas on ci_turma = cd_turma
where
tu.nr_anoletivo = 2024
and exists(select 1 from turmas t where ci_turma =  cd_turma and cd_nivel in (29,32,33))
)
--select count(1) from enturmacao_aee -- 14730
--select * from enturmacao_aee
,alunos as (
select 
ci_aluno,
nm_aluno,
to_char(dt_nascimento,'dd/mm/yyyy') dt_nascimento
from academico.tb_aluno 
join enturmacao_esc esc on esc.cd_aluno = ci_aluno
)
--select * from alunos
--select count(1) from enturmacao
,aluno_deficiencia_i as (
select 
cd_aluno,
case when cd_deficiencia between 9 and 12 or cd_deficiencia = 24 then 'Autismo' else nm_deficiencia end nm_deficiencia 
from academico.tb_aluno_deficiencia tad 
join academico.tb_deficiencia td on td.ci_deficiencia = tad.cd_deficiencia 
join enturmacao_aee using(cd_aluno)
group by 1,2
)
,aluno_deficiencia as (
select 
	cd_aluno,
	true fl_deficiencia,
	string_agg(
		nm_deficiencia, ', ' ) nm_deficiencia
from aluno_deficiencia_i
group by 1,2
)

,escolas as ( 
SELECT 
tut.ci_unidade_trabalho,
crede.ci_unidade_trabalho id_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) nm_municipio,
upper(tc.nm_categoria) nm_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona
from rede_fisica.tb_unidade_trabalho tut 
left JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
where
tut.cd_situacao_funcionamento = 1
AND tlut.fl_sede = TRUE 
)
select 
e_esc.id_crede_sefor, 
e_esc.nm_crede_sefor, 
e_esc.nm_municipio,
e_esc.nm_categoria,
e_esc.id_escola_inep, 
e_esc.nm_escola,
ds_etapa_esc,
ci_aluno,
nm_aluno,
dt_nascimento,
coalesce(nm_deficiencia,'Não informado') nm_deficiencia,
ds_etapa_aee,
e_aee.nm_escola
from enturmacao_esc esc
inner join enturmacao_aee aee using(cd_aluno)
inner join alunos a on ci_aluno = esc.cd_aluno
left join aluno_deficiencia ad on ad.cd_aluno = esc.cd_aluno
inner join escolas e_esc on e_esc.ci_unidade_trabalho =  cd_unidade_trabalho_esc
inner join escolas e_aee on e_aee.ci_unidade_trabalho =  cd_unidade_trabalho_aee


# USANDO O CUBO PARA DATA DE CORTE:
/*
with base_alunos as (
select 
cd_crede_sefor	,
nm_crede_sefor	,
id_municipio	,
nm_municipio	,
id_escola_inep	,
nm_escola	,
nm_categoria	,
cb.ds_ofertaitem,
case when taam.cd_aluno_excluido is null then cb.cd_aluno else taam.cd_aluno end cd_aluno,
nm_aluno,
dt_nascimento
from dw_sige.tb_cubo_aluno_junho_2024 cb
left join academico.tb_auditoria_aluno_mesclar taam on taam.cd_aluno_excluido = cb.cd_aluno
where  
cd_nivel in  (26,27,28)
group by 1,2,3,4,5,6,7,8,9,10,11
)
--select count(1) from base_alunos 
,ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join academico.tb_turma t 
        on ci_turma=cd_turma 
        and cd_nivel in (29,33,32)
        and cd_prefeitura=0
  where t.nr_anoletivo=2024 --- ANO LETIVO
        and dt_enturmacao::date <='2024-05-30'
        and (dt_desenturmacao::date> dt_enturmacao::date or dt_desenturmacao is null)
        and exists (select 1 from base_alunos ba where ba.cd_aluno = e.cd_aluno)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,
  ds_ofertaitem oferta_aee,
  nm_unidade_trabalho unidade_aee
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join academico.tb_turma t on cd_turma=ci_turma 
  join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho
)     
select 
cd_crede_sefor	,
nm_crede_sefor	,
id_municipio	,
nm_municipio	,
id_escola_inep	,
nm_escola	,
nm_categoria	,
ds_ofertaitem,
cd_aluno,
nm_aluno,
dt_nascimento,
oferta_aee,
unidade_aee
from base_alunos ba
join ult_ent using(cd_aluno) --8362
*/