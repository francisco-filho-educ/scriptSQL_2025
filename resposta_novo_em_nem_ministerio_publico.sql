with turma as (
select *
--cd_unidade_trabalho,ci_turma
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2022
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
--and tt.ds_ofertaitem ilike '%subse%'
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2 
                         --and tut.cd_unidade_trabalho_pai = 1
            )
), --select count(1), count(distinct ci_turma ) from turma 
ult_ent as (
  select
  cd_turma,
  cd_aluno
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2022
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ) --select count(1) from ult_ent
  ,
eletiva as (
select 
cd_unidade_trabalho,--, tda.ds_disciplina_atividade ,ds_codigo ,
1 fl_eletiva,
COUNT(distinct tta.cd_disciplina_atividade) qtd_disc
from academico.tb_turma_atividade tta 
join academico.tb_disciplina_atividade tda on tda.ci_disciplina_atividade = tta.cd_disciplina_atividade 
where tta.nr_anoletivo = 2022 
--and tda.cd_eixo_atividade  = 16 -- FORMAÇÃO PROFISSIONAL
and tda.ds_codigo is not null 
and tda.ds_codigo <> ''
group by 1,2 -- having COUNT(distinct tta.cd_disciplina_atividade) >= 2 -- com dois ou mais itinerários formativos implementados
),

tempo_aula as (
SELECT  
tha.cd_unidade_trabalho,
1 fl_contraturno
FROM academico.tb_tempo_eletivo tha -- somente eletivas
WHERE tha.nr_anoletivo=2022 AND tha.nr_aula IN (98,99) -- nr_aula: 1ª aula a 5ª aula é  tempo normal, 98 e 99 aulas no contraturno 
group by 1,2
)
SELECT 
distinct
0 ci_categoria,
0 nm_categoria,
--0 ds_disciplina_atividade ,
--0 ds_codigo,
--tut.nm_unidade_trabalho,
--tut.nr_codigo_unid_trab
count(distinct tmc.ci_municipio_censo) nr_municipio,
count(distinct tut.ci_unidade_trabalho) nr_escolas,
count(1) nr_mat
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
join turma t on t.cd_unidade_trabalho = tut.ci_unidade_trabalho 
left join eletiva de on de.cd_unidade_trabalho = tut.ci_unidade_trabalho 
left join tempo_aula ta on ta.cd_unidade_trabalho = tut.ci_unidade_trabalho 
join ult_ent on ult_ent.cd_turma = t.ci_turma
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
--and tut.cd_categoria  = 5
AND tlut.fl_sede = TRUE 
--and (--fl_eletiva = 1  or 
--     tut.cd_categoria in(10,8,12) )
--and ta.fl_contraturno =1  and tut.cd_categoria not in (8,9,6) -- escolas com contraturno
group by 1,2

/*
 * 1 – Quantidade de escolas de ensino médio da rede (todas as modalidades): 
Resposta: 733

2 – Quantidade de escolas com o Novo ensino médio implantado em 2022(Todas as modalidades).
Resposta: 684

3 – Quantidade total de matrículas do ensino médio (todas as modalidades)
Resposta: 369349 - Em 21/10/2022

4 – Quantidade de escolas com estrutura física adequada ao NEM (Pelo menos um equipamento)
?? Quais seriam esses equipamento???

5 – Quantidade de escolas com plano de comunicação sobre o NEM, elaborado e ativo
??

6 – Quantidade de escolas com ensino médio com educação híbrida implementada em 2022.
Resposta: 137

7 – Quantidade de matrículas nos cursos técnicos em 2022 (Sequencial ou concomitante)
Resposta: 64

8 – Quantidade de municípios com ofertas de itinerário formativo 2022
Resposta: 184

9 – Quantidade de escolas com apenas 1 itinerário formativo implementado em 2022.
Resposta: 1

10 – Quantidade de escolas com dois ou mais itinerários formativos implementados em 2022.
Resposta: 683

11 – Quantidades de escolas que oferecem o 5° itinerário (EPT) em 2022
Resposta: 142

12 – Quantidade de escolas piloto com proposta de flexibilização curricular aprovados em 2022.
??

13 – Quantidade de professores da rede estadual 
Resposta: 20493

14 – Quantidade de gestores da rede estadual (Diretores e coordenadores)
Resposta: 2496

15 Quantidade de professores que já tiveram formação do NEM
??

16 – Quantidade de gestores que já tiveram formação do NEM
??
 * 
 */



