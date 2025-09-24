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
  , ult_ent as (
  select cd_aluno,max(ci_enturmacao) ci_enturmacao 
  from academico.tb_enturmacao te
  join academico.tb_turma t1 on ci_turma=cd_turma 
  and te.nr_anoletivo=t1.nr_anoletivo
  where te.nr_anoletivo = 2023  -- ANO LETIVO AVALIADO
  and t1.cd_prefeitura=0 
  and fl_tipo_seriacao <> 'AC'
  and cd_modalidade in (36,40,37)
  -- Limita ao ensino médio
  --and cd_nivel = 27
  --and cd_etapa in (164,186,190)
  group by 1
  ) --select * from ult_ent 
  -- Seleciona todos os alunos matriculados e enturmados atualmente considerados como aprovados ou reprovados
  , rendimento as (
  SELECT 
  te.nr_anoletivo, 
  te.cd_turma,
  te.cd_aluno,
  case when cd_tiporesultado in (1,2,6) then 1 
       when cd_tiporesultado = 3 then 2 else 0 end tp_situacao
  from ult_mov tum
  join ult_ent tue on tue.cd_aluno=tum.cd_aluno
  join academico.tb_enturmacao te on te.ci_enturmacao=tue.ci_enturmacao
  join academico.tb_turma t on t.ci_turma=te.cd_turma
  join academico.tb_movimento tm on tum.ci_movimento=tm.ci_movimento and tm.cd_unidade_trabalho_destino=t.cd_unidade_trabalho
  left join academico.tb_resultado trs ON trs.cd_aluno = te.cd_aluno and te.cd_turma = trs.cd_turma
  where dt_enturmacao <= '2024-01-31'::date and (dt_desenturmacao > '2024-01-31'::date or dt_desenturmacao is null) -- ANO LETIVO +1
  and t.cd_nivel in (26,27)
  --and t.cd_etapa in (164,186,190)
  ) ---select * from rendimento
  ,movimento as (
  SELECT 
  tm.nr_anoletivo,
  te.cd_turma,
  tm.cd_aluno,
  t.cd_unidade_trabalho, 
  3 as tp_situacao
  from ult_mov tum
  join ult_ent tue on tue.cd_aluno=tum.cd_aluno
  join academico.tb_enturmacao te on te.ci_enturmacao=tue.ci_enturmacao
  join academico.tb_turma t on t.ci_turma=te.cd_turma
  join academico.tb_movimento tm on tum.ci_movimento=tm.ci_movimento and tm.cd_unidade_trabalho_destino=t.cd_unidade_trabalho
  left join academico.tb_aluno_cancelamento tac on tm.cd_aluno = tac.cd_aluno and dt_cancelamento::timestamp(0) = tm.dt_criacao::timestamp(0)
  -- DATA COM O ANO LETIVO
  where tm.dt_criacao::date>('2023-05-30')::date and ((cd_situacao = 1 AND cd_motivo = 1) OR (cd_situacao = 3 AND fl_motivo_cancelamento = 'DF'))
  and not exists(select 1 from rendimento trs where trs.cd_aluno=tm.cd_aluno and trs.nr_anoletivo=tm.nr_anoletivo)
  ) --select count(distinct cd_unidade_trabalho) from movimento
  -- Empilha dados de aprovados, reprovados e abandono
  ,resultado as (
  select cd_aluno,tp_situacao,cd_turma from rendimento
  union
  select cd_aluno,tp_situacao,cd_turma from movimento
  )
 select * from resultado -- 1: APROVADO - 2: REPROVADO - 3: ABANDONO - 0: SEM INFORMACAO

/*
  -- Exibe os cálculos da saída final
  select 
  tt.nr_anoletivo,
  utpai.ci_unidade_trabalho cd_crede,
  utpai.nm_sigla nm_crede,
  l.cd_inep id_municipio,
  l.ds_localidade nm_municipio,
  sb.sg_subcategoria categoria,
  ut.ci_unidade_trabalho,
  ut.nr_codigo_unid_trab as cd_escola,
  ut.nm_unidade_trabalho nm_escola,
--aprovacao 
count(case when tp_situacao in (1,2,6) and tt.cd_etapa in (162,184,188) then cd_aluno end) apr_1ano,
count(case when tp_situacao in (1,2,6) and tt.cd_etapa in (163,185,189) then cd_aluno end) apr_2ano,
count(case when tp_situacao in (1,2,6) and tt.cd_etapa in (164,186,190) then cd_aluno end) apr_3ano,
count(case when tp_situacao in (1,2,6) and tt.cd_etapa in (165,187,191) then cd_aluno end) apr_4ano,
--reprovaçaõ
count(case when tp_situacao=3 and tt.cd_etapa in (162,184,188) then cd_aluno end) rep_1ano,
count(case when tp_situacao=3 and tt.cd_etapa in (163,185,189) then cd_aluno end) rep_2ano,
count(case when tp_situacao=3 and tt.cd_etapa in (164,186,190) then cd_aluno end) rep_3ano,
count(case when tp_situacao=3 and tt.cd_etapa in (165,187,191) then cd_aluno end) rep_4ano,
--abandono
count(case when tp_situacao=8 and tt.cd_etapa in (162,184,188) then cd_aluno end) aba_1ano,
count(case when tp_situacao=8 and tt.cd_etapa in (163,185,189) then cd_aluno end) aba_2ano,
count(case when tp_situacao=8 and tt.cd_etapa in (164,186,190) then cd_aluno end) aba_3ano,
count(case when tp_situacao=8 and tt.cd_etapa in (165,187,191) then cd_aluno end) aba_4ano,
--sem informações
count(case when tp_situacao not in (1,2,6,3,8) and tt.cd_etapa in (162,184,188) then cd_aluno end) sf_1ano,
count(case when tp_situacao not in (1,2,6,3,8) and tt.cd_etapa in (163,185,189) then cd_aluno end) sf_2ano,
count(case when tp_situacao not in (1,2,6,3,8) and tt.cd_etapa in (164,186,190) then cd_aluno end) sf_3ano,
count(case when tp_situacao not in (1,2,6,3,8) and tt.cd_etapa in (165,187,191) then cd_aluno end) sf_4ano
  from resultado r --326440 
  join academico.tb_turma tt on ci_turma=r.cd_turma
  join util.tb_unidade_trabalho ut on ut.ci_unidade_trabalho=tt.cd_unidade_trabalho
  join util.tb_unidade_trabalho utpai on utpai.ci_unidade_trabalho=ut.cd_unidade_trabalho_pai
  join util.tb_subcategoria sb on ut.cd_subcategoria = ci_subcategoria
  join util.tb_localidades l on ci_localidade=ut.cd_municipio
  where nr_anoletivo = 2019
  and tt.cd_nivel = 27
  and tt.cd_etapa in (162,163,164,184,185,186,187,188,189,190,191)
  and ut.nr_codigo_unid_trab = '23109149'
  group by 1,2,3,4,5,6,7,8,9