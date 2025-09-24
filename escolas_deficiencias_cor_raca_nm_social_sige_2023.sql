with turma as (
select 
ci_turma,
tt.ds_turma
from academico.tb_turma tt 
where nr_anoletivo = 2023 
and ci_turma in (select  distinct e.id_turma_sige from public.tb_dm_etapa_aluno_2023_06_01 e )
),
anexo AS (
select
tt.ci_turma, 
tlf.nm_local_funcionamento
from academico.tb_turma tt
join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
join rede_fisica.tb_local_funcionamento tlf on ta.cd_local_funcionamento = tlf.ci_local_funcionamento 
join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = tlf.ci_local_funcionamento 
where tt.nr_anoletivo = 2023
and lut.fl_sede = false
and cd_nivel in (27,26,28)
and tt.cd_prefeitura = 0
group by 1,2
)
,deficiencia as (
select 
cd_aluno,
nm_deficiencia 
from academico.tb_aluno_deficiencia tad2 
join academico.tb_deficiencia td on td.ci_deficiencia = cd_deficiencia 
)
,social as ( 
select
aa.ci_aluno,
aa.fl_nome_social,
aa.nm_social,
aa.ds_nacionalidade,
tp.ds_pais 
from academico.tb_aluno aa 
left join academico.tb_pais tp on tp.ci_pais = aa.cd_pais_origem 
where aa.ci_aluno in (select  e.cd_aluno from public.tb_dm_etapa_aluno_2023_06_01 e )
)
select 
-- CREDE/SEFOR
tde.nm_crede_sefor, 
-- MUNICIPIO
tde.nm_municipio,
-- INEP
id_escola_inep,
-- ESCOLA
tde.nm_escola,
-- CATEGORIA
ds_categoria,
-- Ano/Série
case when cd_ano_serie = 99 then 'EJA' else m.ds_ano_serie end ds_serie,
-- ETAPA DA EDUCAÇÃO
m.ds_etapa_aluno,
-- MODALIDADE
m.ds_modalidade,
-- OFERTA
m.ds_oferta_ensino,
-- TURMA
ds_turma,
-- LOCAL DE FUNCIONAMENTO (ANEXO)
--nm_local_funcionamento,
-- ID INEP
a.cd_inep_aluno,
-- MATRICULA
a.cd_aluno,
-- NOME CIVIL
a.nm_aluno,
-- NASCIMENTO
a.dt_nascimento,
-- IDADE
a.nr_idade_referencia,
-- SEXO
a.ds_sexo,
-- POSSUI NOME SOCIAL
case when nm_social is null then 1 else 0 end fl_nm_social,
-- NOME SOCIAL
nm_social,
-- NACIONALIDADE
ds_nacionalidade,
-- PAÍS DE ORIGEM
ds_pais,
-- RAÇA
a.ds_raca,
-- ETNIA INDÍGENA
tei.nm_etnia_indigena,
-- DEFICIÊNCIAS
string_agg(nm_deficiencia, ', ' ) nm_deficiencia,
-- BAIXA VISÃO
a.fl_def_auditiva,
-- CEGUEIRA
a.fl_cegueira,
-- SURDEZ
a.fl_surdez,
-- SURDO-CEGUEIRA
a.fl_surdocegueira,
-- AUDITIVA
a.fl_def_auditiva,
-- FÍSICA
a.fl_def_fisica,
-- MENTAL
a.fl_def_fisica,
-- MÚLTIPLA
a.fl_def_multipla,
-- AUTISMO 
a.fl_autismo
from public.tb_dm_aluno_pessoa_2023_06_01 a
join public.tb_dm_etapa_aluno_2023_06_01 m using(cd_aluno)
join turma t on t.ci_turma = m.id_turma_sige 
join public.tb_dm_escola tde using(id_escola_sige,id_escola_inep)
--join anexo ax on ax.ci_turma = m.id_turma_sige
left join social s on s.ci_aluno= a.cd_aluno 
left join deficiencia tad on tad.cd_aluno = a.cd_aluno
left join academico.tb_etnia_indigena tei on tei.ci_etnia_indigena = a.cd_etnia_indigena 
where cd_categoria = 7 
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,24,25,26,27,28,29,30,31,32
--group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,26,27,28,29,30,31,32,33
--select cd_ano_serie from public.tb_dm_etapa_aluno_2023_06_01 group by 1


