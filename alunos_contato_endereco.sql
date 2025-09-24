with turmas as (
select 
nr_anoletivo,
cd_unidade_trabalho,
cd_etapa,
ci_turma cd_turma
from academico.tb_turma tt 
where 
tt.nr_anoletivo >=2022 --and tt.cd_unidade_trabalho = 74
and cd_nivel in (26,27)
)
,enturmados as (
select  
nr_anoletivo,
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
join turmas using(cd_turma,nr_anoletivo)
)
,alvo as (
select  
cd_aluno,
cd_turma
from enturmados e1
where nr_anoletivo  = 2022
and not exists (select 1 from enturmados e2 where e2.nr_anoletivo =  2023 and e1.cd_aluno = e2.cd_aluno)
)/*
,contatos as (
select 
ci_aluno,
case when nr_ddd_residencia is null then nr_fone_residencia else nr_ddd_residencia||'-'||nr_fone_residencia end  nr_contato
from academico.tb_aluno ta 
join alvo on cd_aluno = ci_aluno
where 
nr_fone_residencia is not null
union 
select 
ci_aluno,
case when nr_ddd_celular_responsavel is null then nr_fone_celular_responsavel else nr_ddd_celular_responsavel||'-'||nr_fone_celular_responsavel end  nr_contato
from academico.tb_aluno ta 
join alvo on cd_aluno = ci_aluno
where 
nr_fone_celular_responsavel is not null
union
select 
ci_aluno,
case when nr_ddd_celular is null then nr_fone_celular else nr_ddd_celular||'-'||nr_fone_celular end  nr_contato
from academico.tb_aluno ta 
join alvo on cd_aluno = ci_aluno
where 
nr_fone_celular is not null
)*/
,concluintes as (
SELECT 
'Concluiu o ensino médio' ds_situacao,
te.cd_aluno
from enturmados  te 
join turmas t on te.cd_turma = t.cd_turma 
left join academico.tb_resultado trs ON trs.cd_aluno = te.cd_aluno and te.cd_turma = trs.cd_turma
where
t.nr_anoletivo =  2022
and cd_tiporesultado in (1,2,6)
and cd_etapa in (213,214,196,164,186)
)
select  --* from  concluintes
ci_aluno cd_aluno,
nm_aluno nome_aluno,
nm_mae nome_mae,
to_char(dt_nascimento,'dd/mm/yyyy') data_nascimento,
ta.fl_sexo sexo,
upper(ta.ds_logradouro) endereco,
ta.ds_numero numero,
upper(ta.ds_complemento) complemento,
upper(tb.ds_bairro) bairro,
upper(l.ds_localidade) municipio_end,
case when nr_ddd_residencia is null then nr_fone_residencia else nr_ddd_residencia||'-'||nr_fone_residencia end  fone_residencia,
case when nr_ddd_celular is null then nr_fone_celular else nr_ddd_celular||'-'||nr_fone_celular end  celular,
case when nr_ddd_celular_responsavel is null then nr_fone_celular_responsavel else nr_ddd_celular_responsavel||'-'||nr_fone_celular_responsavel end  contato_resposavel,
ta.nm_responsavel,
coalesce(ds_situacao,'Possível evasão') ds_situacao
from academico.tb_aluno ta
left join concluintes c on ta.ci_aluno = c.cd_aluno
join util.tb_localidades l on l.ci_localidade = ta.cd_municipio
left join util.tb_bairros tb on tb.ci_bairro = ta.cd_bairro
where extract(year from age(ta.dt_nascimento)) between 15 and 22
and cd_bairro in (38760,38761,38768,40504,42142,39032,59640,60654, 51662,1126,1122,39008,53860,46799,1081,1089,1100,1106) -- LISTA DE BAIRROS
and exists (
select 1 from alvo et where et.cd_aluno = ta.ci_aluno
)
