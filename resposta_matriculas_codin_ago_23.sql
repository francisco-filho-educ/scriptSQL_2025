with turma as (
select *
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2023
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tt.fl_ativo = 'S' 
and cd_etapa <> 137
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
)
,enturmados as (
  select
  cd_aluno,cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2023
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ) --select count(1) from ult_ent 
 ,mult  as(
select
tm.cd_turma,
ti.cd_nivel,
ti.cd_etapa,
tm.cd_aluno,
1 fl_multseriado
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
join enturmados ut using(cd_turma,cd_aluno)
where 
tm.nr_anoletivo = 2023
and ti.cd_prefeitura = 0

) --select * from mult
, outras as (
select
cd_turma,
cd_nivel,
cd_etapa,
cd_aluno,
0 fl_multseriado
from enturmados tu
join turma tt on tu.cd_turma = ci_turma
where 
not exists (select 1 from mult where tu.cd_aluno = mult.cd_aluno)
),
aluno_etapa as(
select cd_aluno, cd_turma, cd_etapa cd_etapa_aluno from mult
union
select  cd_aluno, cd_turma, cd_etapa cd_etapa_aluno from outras
) 
--select * from aluno_etapa
,escolas as (
SELECT 
2023 nr_ano_sige,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
case when tut.cd_categoria is null then 'Não se aplica'
           when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
	       when  tut.ci_unidade_trabalho = 47258 then 'CREAECE' 
           when tut.cd_categoria in (155,193,194,200,212,517,558,395,291,292,433,442,484,273,278,47724,47747,47788,47975,50025,50199,47244,242) then 'TEMPO INTEGRAL' -- NOVAS EEMTIS 2023
	       else upper(tc.nm_categoria) end AS ds_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
tlf.cd_localizacao_zona,
tut.cd_categoria,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
tut.cd_situacao_funcionamento,
tsf.nm_situacao_funcionamento
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab in (402,401)
AND tlut.fl_sede = TRUE 
)
select 
nr_anoletivo,
-- Qtd. matriculados em turmas de creche com tempo integral 
sum(case when cd_etapa_aluno = 180 and cd_nivel = 28 and cd_turno in (5,8,9) then 1 else 0 end) qtd_1, 
-- Qtd. matriculados em turmas de creche com tempo parcial 
sum(case when cd_etapa_aluno = 180 and cd_nivel = 28 and cd_turno not in (5,8,9) then 1 else 0 end) qtd_2, 
-- Qtd. matriculados em turmas de pré-escola com tempo integral 
sum(case when cd_etapa_aluno = 181 and cd_nivel = 28 and cd_turno in (5,8,9) then 1 else 0 end) qtd_3, 
-- Qtd. matriculados em turmas de pré-escola com tempo parcial 
sum(case when cd_etapa_aluno = 181 and cd_nivel = 28 and cd_turno not in (5,8,9) then 1 else 0 end) qtd_4,
-- Qtd. matriculados no ensino fundamental regular anos iniciais em zonas urbanas
sum(case when (cd_etapa_aluno between 121 and 125) and cd_nivel = 26 and cd_localizacao_zona = 1 then 1 else 0 end) qtd_5, 
-- Qtd. matriculados no ensino fundamental regular anos iniciais em zonas rurais
sum(case when (cd_etapa_aluno between 121 and 125) and cd_nivel = 26 and cd_localizacao_zona = 2 then 1 else 0 end) qtd_6, 
-- Qtd. matriculados no ensino fundamental regular anos finais em zonas urbanas
sum(case when (cd_etapa_aluno between 126 and 129) and cd_nivel = 26 and cd_localizacao_zona = 1 then 1 else 0 end) qtd_7, 
-- Qtd. matriculados no ensino fundamental regular anos finais em zonas rurais
sum(case when (cd_etapa_aluno between 126 and 129) and cd_nivel = 26 and cd_localizacao_zona = 2 then 1 else 0 end) qtd_8, 
-- Qtd. matriculados em turmas do ensino fundamental regular (anos iniciais e anos finais) com tempo integral
sum(case when (cd_etapa_aluno between 121 and 129) and cd_nivel = 26  and cd_turno in (5,8,9) then 1 else 0 end) qtd_9, 
-- Qtd. matriculados no ensino médio regular anos finais em zonas urbanas
sum(case when cd_etapa_aluno in(162,184,188,163,185,189,164,186,190,165,187,191) and cd_nivel = 27 and cd_localizacao_zona = 1 then 1 else 0 end) qtd_10, 
-- Qtd. matriculados no ensino médio regular em zonas rurais
sum(case when cd_etapa_aluno in(162,184,188,163,185,189,164,186,190,165,187,191) and cd_nivel = 27 and cd_localizacao_zona = 2 then 1 else 0 end) qtd_11, 
-- Qtd. matriculados no ensino médio regular em turmas de tempo integral (EEEPs, EEMTI, escolas regulares e escolas militares…)
sum(case when cd_etapa_aluno in(162,184,188,163,185,189,164,186,190,165,187,191) and cd_nivel = 27 and cd_turno in (5,8,9) then 1 else 0 end) qtd_12, 
-- Qtd. matriculados em turmas de ensino médio profissionalizante integrado  (EEEPs)
sum(case when cd_etapa_aluno in(162,184,188,163,185,189,164,186,190,165,187,191) and cd_nivel = 27 and cd_modalidade = 40  then 1 else 0 end) qtd_13, 
-- Qtd. matriculados em turmas de ensino médio de EJA qualifica e ensino médio noturno com qualificação profissional
sum(case when exists (select 1 from academico.tb_turmadisciplina tt2 
					where tt2.cd_turma = ci_turma 
					and t.nr_anoletivo = tt2.nr_anoletivo 
					and tt2.cd_disciplina = 102882 -- disciplina qualifica
					)	 then 1 else 0 end) qtd_14, 
-- Qtd. matriculados em turmas de ensino profissionalizante concomitante.
sum(case when ds_ofertaitem ilike '%conco%' then 1 else 0 end) qtd_15,					
-- Qtd. De matrículas em turmas de educação especial (exclusivas)
sum(case when cd_modalidade  = 37 then 1 else 0 end) qtd_16,
-- Total  de matrículas em turmas de educação profissional (EEEPs, EJA qualifica e  ensino médio noturno com qualificação profissional
sum(case when cd_modalidade = 40 or 
                    exists (select 1 from academico.tb_turmadisciplina tt2 
					where tt2.cd_turma = ci_turma 
					and t.nr_anoletivo = tt2.nr_anoletivo 
					and tt2.cd_disciplina = 102882 -- disciplina qualifica
					)	 then 1 else 0 end) qtd_17,
-- Qtd. De matrículas em turmas de AEE
sum(case when cd_nivel in (29,33,32) then 1 else 0 end) qtd_18,
-- Qtd. matriculados em turmas de ensino médio de EJA sem formação profissional
sum(case when cd_etapa_aluno in(195,194,175,196,174,173) then 1 else 0 end) qtd_19,
-- Qtd. matriculados em turmas de ensino médio de EJA qualifica com qualificação profissional
sum(case when cd_etapa_aluno in(213,214) then 1 else 0 end) qtd_20,
-- Total de matrículas nas escolas estaduais indígenas e quilombolas 
sum(case when cd_categoria in (7,13) then 1 else 0 end) qtd_21,
-- Qtd. matriculados em turmas de creche com tempo integral em escolas indígenas e quilombolas
sum(case when cd_categoria in (7,13) and cd_etapa_aluno = 180 and cd_nivel = 28 and cd_turno in (5,8,9) then 1 else 0 end) qtd_22,
-- Qtd. matriculados em turmas de creche com tempo parcial em escolas indígenas e quilombolas 
sum(case when cd_categoria in (7,13) and cd_etapa_aluno = 180 and cd_nivel = 28 and cd_turno not in (5,8,9) then 1 else 0 end) qtd_23,
-- Qtd. matriculados em turmas de pré-escola com tempo integral em escolas indígenas e quilombolas 
sum(case when cd_categoria in (7,13) and cd_etapa_aluno = 181 and cd_nivel = 28 and cd_turno in (5,8,9) then 1 else 0 end) qtd_24,
-- Qtd. matriculados em turmas de pré-escola com tempo parcial em escolas indígenas e quilombolas 
sum(case when cd_categoria in (7,13) and cd_etapa_aluno = 181 and cd_nivel = 28 and cd_turno not in (5,8,9) then 1 else 0 end) qtd_25,
-- Qtd. De matrículas em turmas de educação especial em escolas  indígenas e quilombolas 
sum(case when cd_categoria in (7,13) and cd_modalidade = 37 then 1 else 0 end) qtd_26,
-- Qtd. matriculados no ensino fundamental regular anos finais em turmas de alternancia
sum(case when (cd_etapa_aluno between 126 and 129) and  cd_modalidade = 41  then 1 else 0 end) qtd_27,
-- Qtd. matriculados no ensino médio em escolas rurais  em turmas de alternancia
sum(case when cd_nivel = 27 and  cd_modalidade = 41  and cd_localizacao_zona = 2 then 1 else 0 end) qtd_28,
-- Qtd. matriculados no ensino médio profissionalizante em turmas de alternancia
sum(case when cd_nivel = 27 and cd_modalidade = 41 and cd_curso <> 1 then 1 else 0 end) qtd_29,
-- Qtd. matriculados em escolas indígenas e quilombolas em turmas de alternancia
sum(case when cd_categoria in (7,13) and cd_modalidade = 41 then 1 else 0 end) qtd_30,
-- Qtd. matriculados em turmas de ensino médio de EJA sem formação profissional em regime de alternancia
sum(case when cd_modalidade = 41 and cd_etapa in (195,194,175,196,174,173) then 1 else 0 end) qtd_31,
-- Qtd. matriculados em turmas de ensino médio de EJA qualifica com qualificação profissional em regime de alternancia
sum(case when cd_modalidade = 41 and cd_etapa in (213,214) then 1 else 0 end) qtd_32,
count(1) total_geral
from enturmados ent 
join aluno_etapa ae using(cd_aluno,cd_turma)
join turma t on t.ci_turma = ent.cd_turma
join escolas e on e.id_escola_sige = t.cd_unidade_trabalho 
group by 1
