with
  ult_mov as (
  select cd_aluno,max(ci_movimento) ci_movimento 
  from academico.tb_movimento tm
  where fl_tipo_atividade = 'RG' and nr_anoletivo = 2023 -- ANO LETIVO AVALIADO
  and exists (
      select 1 from rede_fisica.tb_unidade_trabalho ut
      where ut.cd_tipo_unid_trab = 401 
      and cd_dependencia_administrativa=2
      and ut.ci_unidade_trabalho= tm.cd_unidade_trabalho_destino
      --and ut.ci_unidade_trabalho= 37
  )
  group by 1
  ) --select * from  ult_mov
  , max_ent as (
  select cd_aluno,max(ci_enturmacao) ci_enturmacao 
  from academico.tb_enturmacao te
  join academico.tb_turma t1 on ci_turma=cd_turma 
  and te.nr_anoletivo=t1.nr_anoletivo
  where te.nr_anoletivo = 2023  -- ANO LETIVO AVALIADO
  and t1.cd_prefeitura=0 
  and fl_tipo_seriacao <> 'AC'
  and cd_modalidade in (36,40,37)
  and cd_nivel = 26
  --and cd_etapa in (164,186,190)
  group by 1
  ) --select * from max_ent
 ,ult_ent as (
 select 
 te.cd_aluno, cd_turma, te.dt_enturmacao, te.dt_desenturmacao 
 from academico.tb_enturmacao te
 inner join max_ent using(cd_aluno,ci_enturmacao )
 where te.nr_anoletivo = 2023
 ) --select * from ult_ent 
,mult  as(
select
nr_anoletivo,
tm.cd_turma,
ti.cd_nivel,
ti.cd_etapa,
tm.cd_aluno,
1 fl_multseriado,
dt_enturmacao,
dt_desenturmacao 
from academico.tb_aluno_multiseriacao tm
join ult_ent ut using(cd_turma,cd_aluno)
join academico.tb_item ti on tm.cd_item=ti.ci_item
where 
tm.nr_anoletivo = 2023
) 
--select * from mult
, outras as (
select
nr_anoletivo,
cd_turma,
cd_nivel,
cd_etapa,
cd_aluno,
0 fl_multseriado,
dt_enturmacao,
dt_desenturmacao 
from ult_ent tu
join academico.tb_turma tt on ci_turma=cd_turma 
where tt.nr_anoletivo = 2023  -- ANO LETIVO AVALIADO
and tt.cd_prefeitura=0 
and fl_tipo_seriacao <> 'AC'
and cd_modalidade in (36,40,37)
and cd_nivel = 26
and not exists (select 1 from mult where tu.cd_aluno = mult.cd_aluno)
)
, tue as (
select * from mult
union 
select * 
from outras 
)  
--select * from tue
  -- Seleciona todos os alunos matriculados e enturmados atualmente considerados como aprovados ou reprovados
  , rendimento as (
  SELECT 
  tue.nr_anoletivo, 
  tue.cd_turma,
  tue.cd_aluno,
  tue.cd_etapa,
  case when cd_tiporesultado in (1,2,6) then 1 
       when cd_tiporesultado = 3 then 2 else 0 end tp_situacao
  from ult_mov tum
  join tue on tue.cd_aluno=tum.cd_aluno
  join academico.tb_turma t on t.ci_turma=tue.cd_turma
  join academico.tb_movimento tm on tum.ci_movimento=tm.ci_movimento and tm.cd_unidade_trabalho_destino=t.cd_unidade_trabalho
  left join academico.tb_resultado trs ON trs.cd_aluno = tue.cd_aluno and tue.cd_turma = trs.cd_turma
  where dt_enturmacao <= '2024-01-31'::date and (dt_desenturmacao > '2024-01-31'::date or dt_desenturmacao is null) -- ANO LETIVO +1
  and t.cd_nivel = 26
  --and t.cd_etapa in (164,186,190)
  ) --select * from rendimento
  ,movimento as (
  SELECT 
  tm.nr_anoletivo,
  tue.cd_turma,
  tm.cd_aluno,
  tue.cd_etapa,
  t.cd_unidade_trabalho, 
  3 as tp_situacao
  from ult_mov tum
  join tue on tue.cd_aluno=tum.cd_aluno
  join academico.tb_turma t on t.ci_turma=tue.cd_turma
  join academico.tb_movimento tm on tum.ci_movimento=tm.ci_movimento and tm.cd_unidade_trabalho_destino=t.cd_unidade_trabalho
  left join academico.tb_aluno_cancelamento tac on tm.cd_aluno = tac.cd_aluno and dt_cancelamento::timestamp(0) = tm.dt_criacao::timestamp(0)
  -- DATA COM O ANO LETIVO
  where tm.dt_criacao::date>('2023-05-30')::date and ((cd_situacao = 1 AND cd_motivo = 1) OR (cd_situacao = 3 AND fl_motivo_cancelamento = 'DF'))
  and not exists(select 1 from rendimento trs where trs.cd_aluno=tm.cd_aluno and trs.nr_anoletivo=tm.nr_anoletivo)
  ) --select count(distinct cd_unidade_trabalho) from movimento
  -- Empilha dados de aprovados, reprovados e abandono
  ,resultado as (
  select cd_aluno,tp_situacao,cd_turma, cd_etapa from rendimento
  union
  select cd_aluno,tp_situacao,cd_turma, cd_etapa from movimento
  )
  select * 
  from resultado r -- 1: APROVADO - 2: REPROVADO - 3: ABANDONO - 0: SEM INFORMACAO
