with turma as (
select
tt.nr_anoletivo,
ci_turma cd_turma,
cd_nivel,
ds_nivel,
cd_unidade_trabalho,
case when cd_etapa in(162,184,188) then 162
     when cd_etapa in(163,185,189) then 163
     when cd_etapa in(164,186,190) then 164
     when cd_etapa in(165,187,191) then 165 else cd_etapa end cd_etapa,
case when cd_etapa in(162,184,188) then '1ª Série'
     when cd_etapa in(163,185,189) then '2ª Série'
     when cd_etapa in(164,186,190) then '3ª Série'
     when cd_etapa in(165,187,191) then '4ª Série' else ds_etapa end ds_etapa
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
join academico.tb_nivel on ci_nivel = cd_nivel
join academico.tb_etapa on ci_etapa =  cd_etapa
where
tt.nr_anoletivo = 2024
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27)
)
,ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turma t 
        on t.cd_turma=e.cd_turma 
  where e.nr_anoletivo=2024 --- ANO LETIVO
        and dt_enturmacao::date<='2024-09-23'  -- DATA DA ENTURMAÇAO > DATA DA DESENTURMAÇAO OU ESTA DEVE SER NULA
        --and (dt_desenturmacao::date> '2024-09-23' or dt_desenturmacao is null)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,
  cd_turma,
  case when dt_desenturmacao is null then 1 else 0 end fl_enturmado
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join academico.tb_turma t 
  	on cd_turma=ci_turma 
  	--and cd_nivel=27  -- SEELECIONA A ETAPA DE ENSINO
  	--and (cd_etapa in (164,186,190,214) or cd_anofinaleja=2) ---- SELECIONA AS SÉRIES
)
,aluno_envio as (
select
case when taam.cd_aluno_excluido is null then "idExternoEstudante"::int else taam.cd_aluno end cd_aluno,
nome nm_aluno,
cpf nr_cpf,
taca."numeroNISResponsavel" nis,
"dataNascimento" dt_nascimento
from gestaopresente.tb_aluno_congelado_academico taca 
left join academico.tb_auditoria_aluno_mesclar taam on taam.cd_aluno_excluido = taca."idExternoEstudante"::int
where cpf is not null 
)
,alunos_nome_cpf as (
select 
cd_aluno,
nm_aluno,
nr_cpf,
nr_identificacao_social nis,
ta.dt_nascimento::date::text
from academico.tb_aluno ta 
join ult_ent on cd_aluno = ci_aluno
where ci_aluno not in (select cd_aluno from aluno_envio )
union 
select * from aluno_envio
)
,alunos as (
select 
ac.cd_aluno,
ac.nm_aluno,
ac.nr_cpf,
ac.nis,
ac.dt_nascimento,
coalesce(ds_raca,'Não Declarada') ds_raca,
case when ta.fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo,
fl_enturmado,
cd_turma
from alunos_nome_cpf ac
join academico.tb_aluno ta on ac.cd_aluno = ci_aluno 
join academico.tb_raca tr on ci_raca  = cd_raca
join ult_ent on ult_ent.cd_aluno = ac.cd_aluno
)
select * from turma 
		 join alunos using  (cd_turma)
		 -- where fl_enturmado = 1
