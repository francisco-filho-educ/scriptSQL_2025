with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2021 
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
),/*
ult_ent as (
  select
  cd_aluno,cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2021 
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
),*/
ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join academico.tb_turma t 
        on ci_turma=cd_turma 
        and fl_tipo_seriacao!='AC' 
        and cd_prefeitura=0
  where t.nr_anoletivo=2021 --- ANO LETIVO
        and dt_enturmacao::date<='2022-01-06'  -- DATA DA ENTURMAÇAO > DATA DA DESENTURMAÇAO OU ESTA DEVE SER NULA
        and (dt_desenturmacao::date>'2022-01-06' or dt_desenturmacao is null)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,cd_turma
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join academico.tb_turma t on cd_turma=ci_turma 
) --select count(1) from ult_ent
,mat as (
 select 
cd_unidade_trabalho,
count(1) total
--cd_nivel, cd_etapa, ds_etapa, count(1)
from  ult_ent tue
join turma tt on tt.ci_turma = tue.cd_turma
group by 1
) SELECT 
crede.ci_unidade_trabalho,
crede.nm_sigla nm_crede_sefor, 
--case when  crede.ci_unidade_trabalho < 21 then crede.ci_unidade_trabalho else 21 end cd_crede_sefor, 
--case when  crede.ci_unidade_trabalho < 21 then crede.nm_sigla else 'SEFOR' end nm_crede_sefor, 
--tmc.nm_municipio,
sum(total) qtd
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
--and tut.cd_categoria =9
group by 1,2--,3
ORDER BY 1--,3
