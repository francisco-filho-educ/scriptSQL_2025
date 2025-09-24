
with turma as (
select *
--cd_unidade_trabalho,ci_turma
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2023
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191)
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
  where tu.nr_anoletivo = 2023
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ) --select count(1) from ult_ent
,
--with 
eletivas as (
select 
cd_turno,
cd_etapa,
cd_categoria,
1 fl_eletiva,
sum(tme.nr_eletivas_professor)
from academico.tb_mapabasico_eletiva tme -- se a escola tem eletiva verifica se a escola e turma oferece eletiva
group by 1,2,3 having sum(tme.nr_eletivas_professor)>0
) 
SELECT 
0 ci_categoria,
 nm_categoria,
--0 ds_disciplina_atividade ,
--0 ds_codigo,
--tut.nm_unidade_trabalho,
--tut.nr_codigo_unid_trab,
-- t.ci_turma
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
join ult_ent on ult_ent.cd_turma = t.ci_turma
--join public.tb_dm_etapa_aluno_2023_03_21 t on t.id_escola_sige = tut.ci_unidade_trabalho and cd_etapa_aluno = 3 and cd_ano_serie in (10,11,12,13)
left join eletivas tme on tme.cd_etapa = t.cd_etapa and tme.cd_turno = t.cd_turno and tme.cd_categoria = tut.cd_categoria 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
and (fl_eletiva = 1  or tut.cd_categoria in (10,8,12) or (t.cd_turno = 2 and t.cd_etapa in(162,184,188))) and tut.cd_categoria <> 7 -- seleciona as escolas e turmas do novo ensino médio
group by 1,2
