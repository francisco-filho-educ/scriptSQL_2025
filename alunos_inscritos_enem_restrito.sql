with 
turmas as (
select *
from academico.tb_turma tt
where nr_anoletivo > 2011 and nr_anoletivo <2018
--nr_anoletivo = 2020
and cd_nivel =27
and cd_prefeitura = 0
and cd_etapa in(164,186,190) 
)
,enturmacao as (
  select
  e.nr_anoletivo, cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turmas t on ci_turma=cd_turma and fl_tipo_seriacao!='AC'
  where t.nr_anoletivo=2012 and dt_enturmacao::date<='2012-05-31' and (dt_desenturmacao::date>'2020-05-31' or dt_desenturmacao is null)
  group by 1,2
  union 
  select
  e.nr_anoletivo, cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turmas t on ci_turma=cd_turma and fl_tipo_seriacao!='AC' 
  where t.nr_anoletivo=2013 and dt_enturmacao::date<='2013-05-31' and (dt_desenturmacao::date>'2021-05-31' or dt_desenturmacao is null)
  group by 1,2
  union 
  select
  e.nr_anoletivo, cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turmas t on ci_turma=cd_turma and fl_tipo_seriacao!='AC' 
  where t.nr_anoletivo=2014 and dt_enturmacao::date<='2014-05-31' and (dt_desenturmacao::date>'2022-05-31' or dt_desenturmacao is null)
  group by 1,2
  union 
  select
  e.nr_anoletivo, cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join  turmas t on ci_turma=cd_turma and fl_tipo_seriacao!='AC' 
  where t.nr_anoletivo=2015 and dt_enturmacao::date<='2015-05-31' and (dt_desenturmacao::date>'2023-05-31' or dt_desenturmacao is null)
  group by 1,2
    union 
  select
  e.nr_anoletivo, cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join  turmas t on ci_turma=cd_turma and fl_tipo_seriacao!='AC' 
  where t.nr_anoletivo=2016 and dt_enturmacao::date<='2016-05-31' and (dt_desenturmacao::date>'2023-05-31' or dt_desenturmacao is null)
  group by 1,2
  union 
  select
  e.nr_anoletivo, cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join  turmas t on ci_turma=cd_turma and fl_tipo_seriacao!='AC' 
  where t.nr_anoletivo=2017 and dt_enturmacao::date<='2017-05-31' and (dt_desenturmacao::date>'2023-05-31' or dt_desenturmacao is null)
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
  
  
  
  
  
  