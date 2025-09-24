/*
* LISTA NOMINAL
*/
with 
turmas as (
select *
from academico.tb_turma tt
where nr_anoletivo =2025
and cd_nivel in (26,27,28)
and cd_prefeitura = 0
--and ci_turma = 682962
)
,enturmacao as (
   select
  e.nr_anoletivo, cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join  turmas t on ci_turma=cd_turma and fl_tipo_seriacao!='AC' 
  where t.nr_anoletivo=2025 and dt_enturmacao::date<='2025-02-28' and (dt_desenturmacao::date>'2025-02-28' or dt_desenturmacao is null)
  group by 1,2
)
--select * from enturmacao
,
ult_ent as (
  select
  e1.nr_anoletivo, 
  e1.cd_aluno, 
  e1.cd_turma,
  to_char(e1.dt_enturmacao, 'dd/mm/yyyy') dt_enturmacao
  from academico.tb_enturmacao e1
  join enturmacao et on e1.ci_enturmacao=et.ci_enturmacao  
  )
,anexo as ( 
select
ci_turma,
cd_etapa,
cd_anofinaleja,
ds_ofertaitem,
ds_turma,
tt.cd_unidade_trabalho,
nm_local_funcionamento
from  turmas tt 
join academico.tb_etapa te on tt.cd_etapa = te.ci_etapa 
join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento and tt.cd_unidade_trabalho = lut.cd_unidade_trabalho 
join rede_fisica.tb_local_funcionamento tlf on  tlf.ci_local_funcionamento = lut.cd_local_funcionamento and tlf.cd_tipo_local = 4 --unidades prisionais 

) 
--select ci_turma, count(1)  from anexo  where nr_anoletivo = 2023 group by 1 having count(1)>1
--select * from anexo where ci_turma = 894196
,alunos as (
select 
cd_turma ci_turma,
cd_aluno,
nm_aluno,
to_char(dt_nascimento,'dd/mm/yyyy') dt_nascimento,
nm_mae,
dt_enturmacao
from academico.tb_aluno ta2 
join ult_ent  u on u.cd_aluno = ci_aluno
)
select
a.nr_anoletivo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
nm_local_funcionamento,
ds_ofertaitem,
ds_turma,
cd_aluno,
nm_aluno,
dt_nascimento,
nm_mae,
dt_enturmacao
from alunos al 
join anexo a  using(ci_turma)
join dw_sige.tb_dm_escola tde on tde.id_escola_sige = cd_unidade_trabalho

/*
* CONTANGENS - VERIFICAR DATAS
*/


with 
turmas as (
select *
from academico.tb_turma tt
where nr_anoletivo > 2019
--nr_anoletivo = 2020
and cd_nivel in (26,27,28)
and cd_prefeitura = 0
--and ci_turma = 682962
)
,enturmacao as (
  select
  e.nr_anoletivo, cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turmas t on ci_turma=cd_turma and fl_tipo_seriacao!='AC'
  where t.nr_anoletivo=2020 and dt_enturmacao::date<='2020-05-31' and (dt_desenturmacao::date>'2020-05-31' or dt_desenturmacao is null)
  group by 1,2
  union 
  select
  e.nr_anoletivo, cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turmas t on ci_turma=cd_turma and fl_tipo_seriacao!='AC' 
  where t.nr_anoletivo=2021 and dt_enturmacao::date<='2021-05-31' and (dt_desenturmacao::date>'2021-05-31' or dt_desenturmacao is null)
  group by 1,2
  union 
  select
  e.nr_anoletivo, cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turmas t on ci_turma=cd_turma and fl_tipo_seriacao!='AC' 
  where t.nr_anoletivo=2022 and dt_enturmacao::date<='2022-05-31' and (dt_desenturmacao::date>'2022-05-31' or dt_desenturmacao is null)
  group by 1,2
  union 
  select
  e.nr_anoletivo, cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join  turmas t on ci_turma=cd_turma and fl_tipo_seriacao!='AC' 
  where t.nr_anoletivo=2023 and dt_enturmacao::date<='2023-05-31' and (dt_desenturmacao::date>'2023-05-31' or dt_desenturmacao is null)
  group by 1,2
)
--select * from enturmacao
,
ult_ent as (
  select
  e1.nr_anoletivo, e1.cd_aluno, e1.cd_turma
  from academico.tb_enturmacao e1
  join enturmacao et on e1.ci_enturmacao=et.ci_enturmacao  
  )
,anexo as ( 
select
tt.nr_anoletivo,
ci_turma,
cd_etapa,
cd_anofinaleja,
tt.cd_unidade_trabalho,
nm_local_funcionamento
from  turmas tt 
join academico.tb_etapa te on tt.cd_etapa = te.ci_etapa 
join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento and tt.cd_unidade_trabalho = lut.cd_unidade_trabalho 
join rede_fisica.tb_local_funcionamento tlf on  tlf.ci_local_funcionamento = lut.cd_local_funcionamento and tlf.cd_tipo_local = 4 --unidades prisionais 

) 
--select ci_turma, count(1)  from anexo  where nr_anoletivo = 2023 group by 1 having count(1)>1
--select * from anexo where ci_turma = 894196
,alunos as (
select 
nr_anoletivo,
cd_aluno,
dt_nascimento,
extract(year from age( concat(nr_anoletivo,'-05-31')::timestamp, dt_nascimento)) idade
from academico.tb_aluno ta2 
join ult_ent  u on u.cd_aluno = ci_aluno
where extract(year from age( concat(nr_anoletivo,'-05-31')::timestamp, dt_nascimento))between 18 and 29
)
select
a.nr_anoletivo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
nm_local_funcionamento,
sum( case when cd_etapa in (213,214,195,194,175,196,174,173) then 1 else 0 end)  Total_ejas,
sum( case when cd_etapa in (194,213) then 1 else 0 end) eja_fund_anos_iniciais,
sum( case when cd_etapa in (195,214) then 1 else 0 end) eja_fund_anos_finais,
sum( case when cd_etapa =196  then 1 else 0  end ) eja_medio
from ult_ent u
join anexo a on a.ci_turma = u.cd_turma
join public.tb_dm_escola tde on tde.id_escola_sige = cd_unidade_trabalho
group by 1,2,3,4,5,6,7