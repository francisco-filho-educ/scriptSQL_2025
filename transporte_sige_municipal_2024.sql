with turma as (
select
tt.nr_anoletivo,
ci_turma cd_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2024
and tt.cd_nivel in (26,27,28)
and tt.fl_tipo_seriacao = 'RG'
)
,ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turma t 
        on t.cd_turma=e.cd_turma 
  where e.nr_anoletivo=2024 --- ANO LETIVO
        and dt_enturmacao::date<='2024-05-30'  -- DATA DA ENTURMAÇAO > DATA DA DESENTURMAÇAO OU ESTA DEVE SER NULA
        and (dt_desenturmacao::date>'2024-05-30' or dt_desenturmacao is null)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,cd_turma
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join academico.tb_turma t 
  	on cd_turma=ci_turma 
  	--and cd_nivel=27  -- SEELECIONA A ETAPA DE ENSINO
  	--and (cd_etapa in (164,186,190,214) or cd_anofinaleja=2) ---- SELECIONA AS SÉRIES
)
, alunos as (
select 
ci_aluno,
ta.cd_municipio,
ta.ds_localizacao
from academico.tb_aluno ta 
where ta.fl_transporte = 'S'
and exists (select 1 from ult_ent t where t.cd_aluno = ci_aluno)
), 
mat as (
select 
cd_unidade_trabalho,
cd_municipio,
cd_etapa,
cd_aluno 
from alunos
join ult_ent  using(cd_aluno)
join turma using(cd_turma)
)
SELECT 
2024 nr_anoletivo,
cd_municipio_censo id_municipio,
upper(tmc.nm_municipio) AS nm_municipio,
case when tut.cd_dependencia_administrativa = 3 then 'MUNICIPAL' else 'ESTADUAL' end ds_dependencia,
count(1) total,
sum(case when cd_localizacao_zona = 1  then 1 else 0 end) nr_urbano,
sum(case when cd_localizacao_zona = 0  then 1 else 0 end) nr_rural
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa in (2,3)
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
group by 1,2,3,4

