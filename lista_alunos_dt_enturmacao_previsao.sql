with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2023 
and tt.cd_nivel in (26,27)
and cd_etapa in (162,163,184,185,188,189,190,129,183,177) -- alvo 1ª, 2ª serie medio, 3ª serie magisterio, 9º série
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
            and tut.cd_dependencia_administrativa in (2,3)) -- municipal e estadual
),
ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turma t on ci_turma=cd_turma 
  where e.nr_anoletivo=2023 --- ANO LETIVO
        and dt_enturmacao::date<='2023-06-01'  -- DATA DA ENTURMAÇAO > DATA DA DESENTURMAÇAO OU ESTA DEVE SER NULA
        and (dt_desenturmacao::date>'2023-06-01' or dt_desenturmacao is null)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,cd_turma
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join turma t on cd_turma=ci_turma 
) 
 ,mult  as(
select
nr_anoletivo,
tm.cd_turma,
ti.cd_nivel,
ti.cd_etapa,
tm.cd_aluno,
1 fl_multseriado
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
join ult_ent ut using(cd_turma,cd_aluno)
where 
tm.nr_anoletivo = 2023
and cd_etapa = 129
and exists (select 1 from turma where tm.cd_turma = ci_turma)
) --select * from mult
, outras as (
select
nr_anoletivo,
cd_turma,
cd_nivel,
cd_etapa,
cd_aluno,
0 fl_multseriado
from ult_ent tu
join turma tt on tu.cd_turma = ci_turma
where 
not exists (select 1 from mult where tu.cd_aluno = mult.cd_aluno)
)
, mat as (
select * from mult
union 
select * from outras 
)
select  --count(1) a , count(DISTINCT cd_aluno ) b  FROM mat 
nr_anoletivo,
cd_turma,
cd_etapa,
cd_inep_aluno,
cd_aluno,
nm_aluno,
nm_mae,
nm_pai,
to_char(dt_nascimento,'dd/mm/yyyy') data_nascimento,
extract(year from age('2023-05-31'::date,ta.dt_nascimento)) idade,
upper(concat(ta.ds_logradouro, ', ',ta.ds_numero,', ',ta.ds_complemento)) endereco,
tb.ds_bairro,
l.ds_localidade,
ta.ds_cep,
concat (ta.nr_ddd_celular,'-',ta.nr_fone_celular) fone_aluno,
concat (ta.nr_ddd_celular_responsavel ,'-',ta.nr_fone_celular_responsavel) fone_responsavel
from mat ao
join academico.tb_aluno ta on ta.ci_aluno = ao.cd_aluno
join util.tb_localidades l on l.ci_localidade = ta.cd_municipio
left join util.tb_bairros tb on tb.ci_bairro = ta.cd_bairro

