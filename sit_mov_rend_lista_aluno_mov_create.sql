--CRIACAO DA TABELA DE RESULTADOS ------------------
drop table if exists tmp.tb_mov_rend;
create table tmp.tb_mov_rend as (
with
  ult_mov as (
  select cd_aluno, max(ci_movimento) ci_movimento 
  from academico.tb_movimento tm
  where fl_tipo_atividade = 'RG' and nr_anoletivo = 2023 -- ANO LETIVO AVALIADO
  and exists (
      select 1 from rede_fisica.tb_unidade_trabalho ut
      where ut.cd_tipo_unid_trab = 401 
      and cd_dependencia_administrativa = 2
      and ut.ci_unidade_trabalho = tm.cd_unidade_trabalho_destino
      ---and ut.ci_unidade_trabalho= 83
  )
  group by 1
  ), 
  ult_ent as (
  select cd_aluno, max(ci_enturmacao) ci_enturmacao 
  from academico.tb_enturmacao te
  join academico.tb_turma t1 on ci_turma=cd_turma 
  and te.nr_anoletivo=t1.nr_anoletivo
  where te.nr_anoletivo = 2023  -- ANO LETIVO AVALIADO
  and t1.cd_prefeitura=0 
  and fl_tipo_seriacao <> 'AC'
  --and cd_modalidade in (36,40,37,41)
  -- Limita ao ensino médio
  and cd_nivel = 27
  --and cd_etapa in (164,186,190)
  group by 1
  ),
  -- Seleciona todos os alunos matriculados e enturmados atualmente considerados como aprovados ou reprovados
  rendimento as (
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
  where
  te.nr_anoletivo = 2023
  and dt_enturmacao <= current_date ::date and (dt_desenturmacao > current_date::date or dt_desenturmacao is null) -- ANO LETIVO +1
  and t.cd_nivel in (26,27)
  --and t.cd_etapa in (164,186,190)
  ),
  movimento as (
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
  where tm.dt_criacao::date > ('2023-05-30')::date and ((cd_situacao = 1 AND cd_motivo = 1) OR (cd_situacao = 3 AND fl_motivo_cancelamento = 'DF'))
  and not exists(select 1 from rendimento trs where trs.cd_aluno=tm.cd_aluno and trs.nr_anoletivo=tm.nr_anoletivo)
  )
  -- Empilha dados de aprovados, reprovados e abandono
  select cd_aluno,tp_situacao,cd_turma from rendimento
  union
  select cd_aluno,tp_situacao,cd_turma from movimento
  );
 
 
 
 
 /*
  * 
  *
  * 
  */
 ----------------------------------------------------------------------------------------------------------------------------------------------------
 --
 -- EXPORTAÇÃO DA TABELA COMPLETA
 -
  -- 1: APROVADO - 2: REPROVADO - 3: ABANDONO - 0: SEM INFORMACAO
with aluno as ( 
select 
ci_aluno,
nm_aluno,
to_char(dt_nascimento,'dd/mm/yyyy')dt_nascimento,
coalesce(ds_raca, 'Não Declarado') ds_raca,
case when ta.fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo -- 1: masculino | 2: feminino 
from academico.tb_aluno ta
join ult_ent et on et.cd_aluno = ci_aluno
left join academico.tb_raca tr on tr.ci_raca = ta.cd_raca
)
 select
 tt.nr_anoletivo,
 id_crede_sefor,
 nm_crede_sefor,
 id_municipio,
 nm_municipio,
 id_escola_inep,
 nm_escola,
 ds_categoria,
 n.ds_nivel,
 rr.ci_turma,
 ds_turma,
 cd_etapa,
 ds_etapa,
 ds_turno,
 r.cd_aluno,
 nm_aluno,
 dt_nascimento,
 ds_raca,
 ds_sexo,
 case when tp_situacao = 1 then 'Aprovado'
    when tp_situacao = 2 then 'Reprovado'
    when tp_situacao = 3 then 'Abandono'
    else 'Sem informação' end ds_situacao,
 ts.ds_situacao ds_movimento
 from tmp.tb_mov_rend r
 join academico.tb_turma tt on tt.ci_turma = r.cd_turma --and tt.cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191)
 join academico.tb_nivel n on n.ci_nivel = tt.cd_nivel
 join academico.tb_turno on ci_turno = cd_turno
 join academico.tb_etapa et on et.ci_etapa = cd_etapa
 join dw_sige.tb_dm_escola tde on tde.id_escola_sige = tt.cd_unidade_trabalho --and tde.id_municipio <> 2304400
 join aluno a on r.cd_aluno = ci_aluno
 left join academico.tb_ultimomovimento tu on tu.cd_aluno = r.cd_aluno and tu.nr_anoletivo = 2024 and tu.fl_tipo_atividade = 'RG' 
 join academico.tb_situacao ts on tu.cd_situacao = ci_situacao
*/

with
ano_letivo_avaliado as (
  select 2024 ano
),
ult_mov as (
  select cd_aluno,max(ci_movimento) ci_movimento 
  from academico.tb_movimento tm
  where fl_tipo_atividade = 'RG' and nr_anoletivo in (select ano from ano_letivo_avaliado ) -- ANO LETIVO AVALIADO
  and exists (
      select 1 from rede_fisica.tb_unidade_trabalho ut
      where ut.cd_tipo_unid_trab = 401 
      and cd_dependencia_administrativa = 2
      and ut.ci_unidade_trabalho = tm.cd_unidade_trabalho_destino
      --and ut.ci_unidade_trabalho= 83
  )
  group by 1
  ), 
  ult_ent as (
  select cd_aluno,max(ci_enturmacao) ci_enturmacao 
  from academico.tb_enturmacao te
  join academico.tb_turma t1 on ci_turma=cd_turma  --and cd_unidade_trabalho= 83
  and te.nr_anoletivo=t1.nr_anoletivo
  where te.nr_anoletivo  in (select ano from ano_letivo_avaliado )  -- ANO LETIVO AVALIADO
  and t1.cd_prefeitura = 0 
  and fl_tipo_seriacao <> 'AC'
  and cd_modalidade in (36,40,37)
  -- Limita ao ensino médio
  and cd_nivel = 27
  --and cd_etapa in (164,186,190)
  group by 1
  ),
  -- Seleciona todos os alunos matriculados e enturmados atualmente considerados como aprovados ou reprovados
  rendimento as (
  SELECT 
  te.nr_anoletivo, 
  te.cd_turma,
  te.cd_aluno,
  case when cd_tiporesultado in (1,2,6) then 1 
       when cd_tiporesultado = 3 then 2 else 0 end tp_situacao
  from ult_mov tum
  join ult_ent tue on tue.cd_aluno = tum.cd_aluno
  join academico.tb_enturmacao te on te.ci_enturmacao=tue.ci_enturmacao
  join academico.tb_turma t on t.ci_turma=te.cd_turma  --and cd_unidade_trabalho= 83
  join academico.tb_movimento tm on tum.ci_movimento=tm.ci_movimento and tm.cd_unidade_trabalho_destino=t.cd_unidade_trabalho
  left join academico.tb_resultado trs ON trs.cd_aluno = te.cd_aluno and te.cd_turma = trs.cd_turma
  where dt_enturmacao <= current_date ::date and (dt_desenturmacao > current_date::date or dt_desenturmacao is null) -- ANO LETIVO +1
  and t.cd_nivel = 27
  --and t.cd_etapa in (164,186,190)
  ),
  movimento as (
  SELECT 
  tm.nr_anoletivo,
  te.cd_turma,
  tm.cd_aluno,
  t.cd_unidade_trabalho, 
  3 as tp_situacao
  from ult_mov tum
  join ult_ent tue on tue.cd_aluno=tum.cd_aluno
  join academico.tb_enturmacao te on te.ci_enturmacao=tue.ci_enturmacao
  join academico.tb_turma t on t.ci_turma=te.cd_turma  --and cd_unidade_trabalho= 83
  join academico.tb_movimento tm on tum.ci_movimento=tm.ci_movimento and tm.cd_unidade_trabalho_destino=t.cd_unidade_trabalho
  left join academico.tb_aluno_cancelamento tac on tm.cd_aluno = tac.cd_aluno and dt_cancelamento::timestamp(0) = tm.dt_criacao::timestamp(0)
  -- DATA COM O ANO LETIVO
  where tm.dt_criacao::date>(select ano||'-05-30' from ano_letivo_avaliado )::date and ((cd_situacao = 1 AND cd_motivo = 1) OR (cd_situacao = 3 AND fl_motivo_cancelamento = 'DF'))
  and not exists(select 1 from rendimento trs where trs.cd_aluno=tm.cd_aluno and trs.nr_anoletivo=tm.nr_anoletivo)
  )
  -- Empilha dados de aprovados, reprovados e abandono
  ,resultado as (
  select cd_aluno,tp_situacao,cd_turma from rendimento
  union
  select cd_aluno,tp_situacao,cd_turma from movimento
  ) -- 1: APROVADO - 2: REPROVADO - 3: ABANDONO - 0: SEM INFORMACAO
  ,aluno as ( 
select 
ci_aluno,
nm_aluno,
to_char(dt_nascimento,'dd/mm/yyyy')dt_nascimento,
coalesce(ds_raca, 'Não Declarado') ds_raca,
case when ta.fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo -- 1: masculino | 2: feminino 
from academico.tb_aluno ta
join ult_ent et on et.cd_aluno = ci_aluno
left join academico.tb_raca tr on tr.ci_raca = ta.cd_raca
)
 select 
 tt.nr_anoletivo,
 id_crede_sefor,
 nm_crede_sefor,
 id_municipio,
 nm_municipio,
 id_escola_inep,
 nm_escola,
 ds_categoria,
 n.ds_nivel,
 tt.ci_turma,
 ds_turma,
 cd_etapa,
 ds_etapa,
 ds_turno,
 r.cd_aluno,
 nm_aluno,
 dt_nascimento,
 ds_raca,
 ds_sexo,
 case when tp_situacao = 1 then 'Aprovado'
    when tp_situacao = 2 then 'Reprovado'
    when tp_situacao = 3 then 'Abandono'
    else 'Sem informação' end ds_situacao
 from resultado r
 join academico.tb_turma tt on tt.ci_turma = r.cd_turma and tt.cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191)
 join academico.tb_nivel n on n.ci_nivel = tt.cd_nivel
 join academico.tb_turno on ci_turno = cd_turno
 join academico.tb_etapa et on et.ci_etapa = cd_etapa
 join dw_sige.tb_dm_escola tde on tde.id_escola_sige = tt.cd_unidade_trabalho --and tde.id_municipio <> 2304400
 join aluno a on r.cd_aluno = ci_aluno