/*
 * ATENÇÃO: NECESSÁRIO RETIRAR OS CONCLUINTES EJA ATRAVÉS DO CRUZAMENTO COM A TABELA DE SITUAÇÃO DO CENSO ESCOLAR
 */
with mat_24 as (
select
cd_aluno
from academico.tb_turma tt 
join academico.tb_ultimaenturmacao tu on tt.ci_turma = tu.cd_turma
where
tt.nr_anoletivo = 2024
and tu.fl_tipo_atividade <> 'AC'
and cd_nivel in (26,27)
)
,concluintes as (
select 
case when cd_aluno_excluido is null then tc.cd_aluno else taam.cd_aluno end cd_aluno
from public.tb_concluintes_a_partir_2019 tc 
left join academico.tb_auditoria_aluno_mesclar taam on taam.cd_aluno_excluido = tc.cd_aluno
where tc.nr_anoletivo >2021
)
,mat_23 as (
select
tt.nr_anoletivo,
cd_aluno,
cd_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem ds_ofertaitem_21,
cd_unidade_trabalho
from academico.tb_turma tt 
join academico.tb_ultimaenturmacao tu on tt.ci_turma = tu.cd_turma
where
tt.nr_anoletivo = 2023
and tt.cd_prefeitura = 0
and cd_aluno not in (select cd_aluno from mat_24)
and tu.cd_aluno not in (select cd_aluno from concluintes )
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
and tu.fl_tipo_atividade <> 'AC'
and cd_nivel in (26,27)
)
--select count(1) from mat_23
,mat_22 as (
select
tt.nr_anoletivo,
cd_aluno,
cd_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem ds_ofertaitem_21,
cd_unidade_trabalho
from academico.tb_turma tt 
join academico.tb_ultimaenturmacao tu on tt.ci_turma = tu.cd_turma
where
tt.nr_anoletivo = 2022
and tt.cd_prefeitura = 0
and cd_aluno not in (select cd_aluno from mat_24)
and cd_aluno not in (select cd_aluno from mat_23)
and tu.cd_aluno not in (select cd_aluno from concluintes )
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
and tu.fl_tipo_atividade <> 'AC'
and cd_nivel in (26,27)
)
,alunos_total  as (
select * from mat_23
union 
select * from mat_22
)
select 
cd_aluno,
--Ano do censo
at.nr_anoletivo,
--Código da entidade
id_escola_inep,
--Nome da entidade
nm_escola,
--Dependência administrativa
'Estadual' ds_dependencia,
--Localização
ds_localizacao,
--Município Escola
nm_municipio nm_municipio_escola,
--Municipio Aluno
l.ds_localidade,
--Distrito
--Bairro
b.ds_bairro,
--Logradouro
a.ds_logradouro,
--Cep
a.ds_cep,
--Idade (numérico)
extract(year from age(current_date,a.dt_nascimento)) idade,
--Sexo
case when a.fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo, -- 1: masculino | 2: feminino 
--Cor/Raça
coalesce(ds_raca, 'Não Declarado') ds_raca
from alunos_total at
join academico.tb_aluno a on ci_aluno = cd_aluno 
join util.tb_bairros b on b.ci_bairro = cd_bairro
join util.tb_localidades l on l.ci_localidade = a.cd_municipio
left join academico.tb_raca tr on tr.ci_raca = cd_raca
inner join dw_sige.tb_dm_escola tde on tde.id_escola_sige = cd_unidade_trabalho
where 
tde.id_municipio in (2303709, 2307650, 2307700, 2306405, 2312908, 2311306, 2305506, 2304202, 2307304, 2304400)
--group by 1


/*
select 
ds_etapa, count(1)
from public.tb_concluintes_a_partir_2019
inner join academico.tb_turma tt on ci_turma = cd_turma 
join academico.tb_etapa te on te.ci_etapa = cd_etapa
group  by 1
*/
