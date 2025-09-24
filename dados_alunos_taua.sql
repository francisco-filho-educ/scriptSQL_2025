with turma as (
select *
from academico.tb_turma
where nr_anoletivo = 2021
and cd_prefeitura = 14991
--and cd_nivel in (26,28)
), enturmados as ( --8184
select 
cd_aluno,
cd_turma
from  academico.tb_ultimaenturmacao tu 
where
nr_anoletivo = 2021
--and tu.fl_tipo_atividade <> 'AC'
and exists (select 1 from turma tt where tu.cd_turma = tt.ci_turma )
)-- select count(1) from enturmados
,data_matricula as (
select
cd_aluno,
min(tm.dt_criacao) dt_matricula
from academico.tb_movimento tm 
where tm.nr_anoletivo = 2021
and exists (select 1 from enturmados e where tm.cd_aluno = e.cd_aluno)
and exists (select 1 from turma t where tm.cd_ofertaitem_destino = t.cd_ofertaitem)
and tm.cd_situacao = 2
group by 1
) --select count(1) from data_matricula 
,escolas as (
select
tut.ci_unidade_trabalho cd_unidade_trabalho,
tut.nr_codigo_unid_trab,
lo.cd_inep cd_municipio_esc,
tut.nm_unidade_trabalho,
concat( ds_logradouro,', ',ds_numero,'' )logradouro_esc,--Endereço;
 ds_numero ds_num_esc,--Nº;
 ds_bairro nm_bairro_esc,--Bairro;
 ds_cep ds_cep_esc,--CEP;
 ds_ddd ds_dd_esc,-- DDD;
 ds_telefone ds_telefone_esc,--Telefone;
 ds_localidade nm_municipio_esc
from util.tb_unidade_trabalho tut
left join util.tb_bairros on cd_bairro = ci_bairro
join util.tb_localidades  lo  on ci_localidade = cd_municipio
where tut.nr_codigo_unid_trab in ('23109297','23182857','23109564','23109602','23230053','23109866','23109980','23109998','23110031','23227788','23110244','23110287','23186607','23110562','23110589','23110600','23110856','23110791','23110970','23183500','23269855','23108878','23259345','23224428','23108886','23258292','23109017','23258284','23109645','23109076','23109700','23207817','23109742','23243830','23109726','23109190','23109220','23109238','23108924','23108932','23110929','23269839','23111089')
)--select count(1) from escolas inner join turma t using(cd_unidade_trabalho)   inner join enturmados e on e.cd_turma  = t.ci_turma
,relatorio as (
select 
--1 Composição de Ensino - Descrição/Nome
tni.ds_nivel,
-- 2Composição de Ensino - Nível da modalidade de Ensino
case when tt.cd_nivel = 26 then 1 else 0 end cd_nivel_etapa,
-- 3Série – Descrição/Nome
te.ds_etapa,
-- 4Série - Código da Composição de Ensino
te.ci_etapa,
-- 5Escola/Unidade - Descrição/Nome
nm_unidade_trabalho,
-- 6Escola/Unidade - Usuário Coletor
null nm_usuario_col,
-- 7Escola/Unidade - Logradouro
logradouro_esc,
-- 8Escola/Unidade - Cidade/Municipio
cd_municipio_esc,
-- 9Escola/Unidade – Código INEP
nr_codigo_unid_trab,
-- 10Turma - Descrição/Nome
tt.ds_turma,
-- 11Turma - Altura coletor da Turma
null coletor_turma,
-- 12Turma - Código da Escola
ci_turma,
-- 13Turma - Código Interno da Série 
tt.cd_etapa ,
-- 14Turma – Turno
tn.ds_turno,
-- 15Aluno - Nome
ta.nm_aluno,
-- Aluno – NomeSocial
ta.nm_social,
-- Aluno - Data/Hora de Cadastro,
ta.dt_criacao::text, 
-- Aluno - Código da Série de entrada
tt.cd_etapa cd_etapa_e,
-- Aluno - Turno de entrada
case
when cd_turno = 4 then 0 -- Matutino
when cd_turno = 1 then 1 -- Vespertino
when cd_turno = 2 then 2 -- Noturno
when cd_turno in (5,8,9)  then 3 -- Diurno/Integral
when cd_turno = 7 then 4 end -- Intermediário
cd_turno,
-- Aluno - Data de Nascimento
ta.dt_nascimento::date::text,
-- Aluno – Sexo
case when ta.fl_sexo = 'M' then 0 else 1 end cd_sexo,
-- Aluno - Matrícula
tu.cd_aluno,
-- Aluno - Código Interno da Escola
tt.cd_unidade_trabalho,
-- Aluno - Data de Inicio da Matrícula
dt_matricula,
-- Aluno - Código da Turma
cd_turma,
-- Período
2 cd_periodo,
-- Aluno – Telefone1
concat (ta.nr_ddd_celular,'-' ,ta.nr_fone_celular) fone_1,
-- Aluno – Telefone2
concat (ta.nr_ddd_residencia ,'-' ,ta.nr_fone_residencia) fone_2,
-- Aluno – Telefone3
concat (ta.nr_ddd_celular_responsavel ,'-' ,ta.nr_fone_celular_responsavel) fone_3,
-- Aluno – e-mail 
ta.ds_email,
-- Aluno – Logradouro
ta.ds_logradouro,
-- Aluno – Numero Endereco
ta.ds_numero,
-- Aluno – Complemento
ta.ds_complemento,
-- Aluno – Bairro
ds_bairro,
-- Aluno – Cidade
tl.cd_inep,
-- Aluno – CEP
ta.ds_cep,
-- Aluno – ZonaResidencia
case
when ta.ds_localizacao_residencia ilike 'Rural' then 1 else  0 end cd_zona,
-- Aluno – CPF
ta.nr_cpf,
-- Aluno – Cor_Raca
ta.cd_raca,
-- Aluno – INEP
ta.cd_inep_aluno,
-- Aluno – Nacionalidade
tp.ds_pais,
-- Aluno – Naturalidade
tln.ds_localidade,
-- Aluno – SUS
null ds_sus,
-- Aluno – NIS,
ta.nr_identificacao_social,
-- Aluno – BolsaFamilia
null nr_bolsa_familia,
-- Aluno – Identidade
ta.nr_documento,
-- Aluno – ExpedidorIdentidade
rg.ds_orgaorg,
-- Aluno – DataExpedicaoIdentidade
ta.dt_expdoc,
-- Aluno – ComplementoIdentidade
null ds_complem_rg,
-- Aluno – NomeMae
ta.nm_mae,
-- Aluno – CelularMae
concat (ta.nr_ddd_celular_responsavel ,'-' ,ta.nr_fone_celular_responsavel) nr_cel_mae,
-- Aluno – CPFMae
null cfp_mae,
-- Aluno – NomePai
ta.nm_pai,
-- Aluno – CelularPai
concat (ta.nr_ddd_celular_responsavel ,'-' ,ta.nr_fone_celular_responsavel) nr_cel_pai,
-- Aluno – CPFPai
null cpf_pai
--select distinct tc.nm_curso 
from academico.tb_aluno ta 
left join academico.tb_pais tp on tp.ci_pais = ta.cd_pais_origem 
join enturmados tu on ta.ci_aluno = tu.cd_aluno 
join turma tt on tu.cd_turma = ci_turma 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
left join data_matricula dm on dm.cd_aluno = ci_aluno
left join util.tb_bairros tb on tb.ci_bairro = ta.cd_bairro
left join util.tb_localidades tl on tl.ci_localidade = ta.cd_municipio
left join util.tb_localidades tln on tln.ci_localidade = ta.cd_municipio_nascimento 
left join academico.tb_orgaorg rg on rg.ci_orgaorg = ta.cd_orgaoexp 
inner join academico.tb_nivel tni on tni.ci_nivel = tt.cd_nivel
inner join academico.tb_modalidade tm2 on tm2.ci_modalidade = tt.cd_modalidade
inner join academico.tb_etapa te on te.ci_etapa = tt.cd_etapa
inner join escolas using(cd_unidade_trabalho)
) 
select --count(1) from relatorio 
ds_nivel
,cd_nivel_etapa
,ds_etapa
,ci_etapa
,nm_unidade_trabalho
,nm_usuario_col
,logradouro_esc
,cd_municipio_esc
,nr_codigo_unid_trab
,ds_turma
,coletor_turma
,cd_unidade_trabalho
,cd_etapa
,ds_turno
,nm_aluno
,nm_social
,dt_criacao
,cd_etapa_e
,cd_turno
,dt_nascimento
,cd_sexo
,cd_aluno
,cd_unidade_trabalho
,dt_matricula
,cd_turma
,cd_periodo
,fone_1
,fone_2
,fone_3
,ds_email
,ds_logradouro
,ds_numero
,ds_complemento
,ds_bairro
,cd_inep
,ds_cep
,cd_zona
,nr_cpf
,cd_raca
,cd_inep_aluno
,ds_pais
,ds_localidade
,ds_sus
,nr_identificacao_social
,nr_bolsa_familia
,nr_documento
,ds_orgaorg
,dt_expdoc
,ds_complem_rg
,nm_mae
,nr_cel_mae
,cfp_mae
,nm_pai
,nr_cel_pai
,cpf_pai
from relatorio

/*
SELECT 
--crede.ci_unidade_trabalho, 
--crede.nm_sigla, 
tut.nr_codigo_unid_trab, 
tut.nm_unidade_trabalho,
ds_ofertaitem,
cd_aluno,
nm_aluno,
ds_email
FROM rede_fisica.tb_unidade_trabalho tut 
--JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_localidades tmc ON tmc.cd_inep = tlf.cd_municipio_censo
join alunos m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE 1=1 --tut.cd_dependencia_administrativa = 2--AND tut.cd_situacao_funcionamento = 1
--AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE  --group by 1
and tut.nr_codigo_unid_trab in ('23109297','23182857','23109564','23109602','23230053','23109866','23109980','23109998','23110031','23227788','23110244','23110287','23186607','23110562','23110589','23110600','23110856','23110791','23110970','23183500','23269855','23108878','23259345','23224428','23108886','23258292','23109017','23258284','23109645','23109076','23109700','23207817','23109742','23243830','23109726','23109190','23109220','23109238','23108924','23108932','23110929','23269839','23111089')
ORDER BY 1,3,4,6;
*/
/*

select 
cd_prefeitura,sum(qtdenturmados)
from academico.tb_turma tt 
JOIN util.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
where tt.nr_anoletivo =2021
and tut.cd_municipio = 1740
and tt.cd_prefeitura = 14991
and tt.fl_tipo_seriacao ='RG'
group by 1
*/