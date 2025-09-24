-- enturmados em 2023 e não matriculados em 2024
with nao_enturmados as (
select 
tu.nr_anoletivo,
cd_aluno,
cd_unidade_trabalho,
cd_turma,
ds_ofertaitem
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on tt.ci_turma = tu.cd_turma and tt.nr_anoletivo = tu.nr_anoletivo 
where 
tu.nr_anoletivo = 2023
and tt.cd_prefeitura = 0 
and tu.fl_tipo_atividade <> 'AC'
and tt.cd_nivel in (26,27)
and not exists(select 1 from academico.tb_ultimomovimento tum
						where
						tum.cd_aluno = tu.cd_aluno 
						and tum.nr_anoletivo = 2024 
						and fl_tipo_atividade = 'RG' 
						and tum.cd_situacao in (6,2)
					     )
) --select count(1) from nao_enturmados --123237

--Cais do Porto, Mucuripe, Vicente Pinzón, Lagamar e Jardim das Oliveiras -- 38424,1046,1061,
,alunos as (
select 
ci_aluno cd_aluno,
cd_inep_aluno,
nm_aluno,
nm_mae,
nm_pai,
to_char(dt_nascimento,'dd/mm/yyyy') data_nascimento,
extract(year from age('2023-05-31'::date,ta.dt_nascimento)) idade,
concat(ta.ds_logradouro, ', ',ta.ds_numero,', ',ta.ds_complemento) endereco,
cd_bairro,
tb.ds_bairro,
l.ds_localidade nm_municipio,
l.cd_inep id_municipio
ta.ds_cep,
concat (ta.nr_ddd_celular,'-',ta.nr_fone_celular) fone_aluno,
concat (ta.nr_ddd_celular_responsavel ,'-',ta.nr_fone_celular_responsavel) fone_responsavel
from academico.tb_aluno ta 
join util.tb_localidades l on l.ci_localidade = ta.cd_municipio
left join util.tb_bairros tb on tb.ci_bairro = ta.cd_bairro
where 
cd_municipio in (1347,1722,1284,1486,1488,1422)
and extract (year from age(current_date,ta.dt_nascimento::date)) between 15 and 22 
and exists (select 1 from nao_enturmados  ne where ci_aluno = cd_aluno)
)
--select ds_localidade, count(1) from  alunos   group by 1
select
um.cd_aluno,
cd_inep_aluno,
nm_aluno,
nm_mae,
nm_pai,
data_nascimento,
idade,
endereco,
cd_bairro.
ds_bairro,
id_municipio,
nm_municipio,
ds_cep,
fone_aluno,
fone_responsavel,
um.nr_anoletivo ultimo_ano,
nm_escola,
tde.nm_municipio nm_municipio_escola,
ds_ofertaitem,
case when conc.cd_aluno is null then 'NÃO' else 'SIM' end concluinte
from nao_enturmados um 
join alunos a using(cd_aluno)
join dw_sige.tb_dm_escola tde on tde.id_escola_sige =  cd_unidade_trabalho
left join public.tb_concluintes_2023 conc on conc.cd_aluno  = um.cd_aluno




/*
 -- cria ou atualiza a tabela de concluintes
drop table if exists public.tb_concluintes_2023;
create table public.tb_concluintes_2023 as (
with ano_referencia as (
select 2023 nr_anoletivo
)
,turma as (
select 
*
from academico.tb_turma tt 
join academico.tb_etapa te on te.ci_etapa = tt.cd_etapa 
where nr_anoletivo in (select * from ano_referencia )
and cd_nivel = 27 
and (cd_etapa in (214,164,186,191) or tt.cd_anofinaleja = 2)
)
  ,ult_ent as (
  select cd_aluno,max(ci_enturmacao) ci_enturmacao 
  from academico.tb_enturmacao te
  join turma t1 on ci_turma=cd_turma  and te.nr_anoletivo=t1.nr_anoletivo
  group by 1
  ), 
  enturmados as (
  select *
  from academico.tb_enturmacao te2 
  join ult_ent using(cd_aluno,ci_enturmacao)
  ) 
  SELECT
  t.nr_anoletivo, 
  t.cd_unidade_trabalho,
  te.cd_turma,
  te.cd_aluno,
  cd_tiporesultado
  from enturmados  te 
  join turma t on te.cd_turma = t.ci_turma 
  left join academico.tb_resultado trs ON trs.cd_aluno = te.cd_aluno and te.cd_turma = trs.cd_turma
  where
  t.nr_anoletivo in (select * from ano_referencia )
  and cd_tiporesultado in (1,2,6)
  )
  
  
 */

