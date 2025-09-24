with turma as (
select
cd_unidade_trabalho,
nr_anoletivo,
ci_turma,
ds_anofinaleja,
tt.cd_nivel,
tt.cd_etapa,
ds_etapa,
ds_turma,
ds_turno
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
join academico.tb_etapa te on cd_etapa = ci_etapa
where
tt.nr_anoletivo = 2024
and tt.cd_nivel  = 27
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
            and tut.cd_dependencia_administrativa = 2 ) -- municipal e estadual
)
,ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turma t on ci_turma=cd_turma 
  where e.nr_anoletivo=2024 --- ANO LETIVO
        and dt_enturmacao::date<='2024-02-01'  -- DATA DA ENTURMAÇAO > DATA DA DESENTURMAÇAO OU ESTA DEVE SER NULA
        and (dt_desenturmacao::date>'2024-02-01' or dt_desenturmacao is null)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,cd_turma
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join turma t on cd_turma=ci_turma 
) 
,alunos as (
select 
ci_aluno cd_aluno,
nm_aluno,
extract(year from AGE('2024-05-31'::date,ta.dt_nascimento)) nr_idade,
to_char(ta.dt_nascimento,'dd/mm/yyyy') dt_nascimento,
case when ta.fl_possui_cpf then 'SIM' else 'NÃO' end possui_cpf,
case when ta.fl_bolsaescola = 'S' then 'SIM' else 'NÃO' end possui_bolsa_escola,
case when ta.nr_identificacao_social is not null then 'SIM' else 'NÃO' end possui_nis,
ta.nr_cpf,
ta.nr_identificacao_social
from academico.tb_aluno ta 
where exists (select 1 from ult_ent where cd_aluno = ci_aluno)
and extract(year from AGE('2024-05-31'::date,ta.dt_nascimento))  <= 24
) 
select 
t.nr_anoletivo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
tde.ds_categoria,
ci_turma,
ds_turma,
ds_etapa,
ds_turno,
a.*
from turma t
join ult_ent on ci_turma = cd_turma
join alunos a using(cd_aluno)
join dw_sige.tb_dm_escola tde on tde.id_escola_sige = cd_unidade_trabalho 
order by 1



# totais usando o cubo
select 
'14 a 24 anos' idade, 
count(1) total,
sum(case when cd_etapa = 162 then 1 else 0 end) serie_1,
sum(case when cd_etapa = 163 then 1 else 0 end) serie_2,
sum(case when cd_etapa = 164 then 1 else 0 end) serie_3,
sum(case when cd_etapa = 165 then 1 else 0 end) serie_4,
sum(case when cd_etapa in (196,213) then 1 else 0 end) eja_pres,
sum(case when cd_etapa =173 then 1 else 0 end) eja_semi
from public.tb_cubo_matricula_sige_01_04_2024 tcms 
where 
nr_idade between 14 and 24
and nr_identificacao_social is not null
and ds_nivel ilike 'ensino médio'
and cd_etapa <> 193
group by 1
union 
select 
'19 a 24 anos' idade, 
count(1) total,
sum(case when cd_etapa = 162 then 1 else 0 end) serie_1,
sum(case when cd_etapa = 163 then 1 else 0 end) serie_2,
sum(case when cd_etapa = 164 then 1 else 0 end) serie_3,
sum(case when cd_etapa = 165 then 1 else 0 end) serie_4,
sum(case when cd_etapa in (196,213) then 1 else 0 end) eja_pres,
sum(case when cd_etapa =173 then 1 else 0 end) eja_semi
from public.tb_cubo_matricula_sige_01_04_2024 tcms 
where 
nr_idade between 19 and 24
and nr_identificacao_social is not null
and ds_nivel ilike 'ensino médio'
and cd_etapa <> 193
group by 1