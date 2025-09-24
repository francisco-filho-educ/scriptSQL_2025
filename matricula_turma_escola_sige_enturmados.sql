with turma as (
select
*
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2022
and tt.cd_prefeitura = 0
and tt.cd_nivel = 26
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2 
            --and tut.cd_unidade_trabalho_pai = 1
            )
and tt.cd_etapa in (121,122,123,124,125,126,127,128,129,183)
), --select count(1), count(distinct ci_turma ) from turma 
ult_ent as (
  select
  cd_turma,
  cd_aluno
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2022
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ),
mat as (
select 
 nr_anoletivo,
cd_unidade_trabalho,
ds_ofertaitem,
ds_turma,
ci_turma,
count(distinct ci_turma)nr_turmas,
count(1) nr_ent
from  ult_ent tue
join turma tt on tt.ci_turma = tue.cd_turma
group by 1,2,3,4,5
) SELECT 
nr_anoletivo,
--CREDE
crede.ci_unidade_trabalho id_crede_sefor,
crede.nm_sigla nm_crede_sefor, 
--MUNICIPIO
tmc.ci_municipio_censo,
upper(tmc.nm_municipio) AS nm_municipio,
--INEP
tut.nr_codigo_unid_trab id_escola_inep, 
--ESCOLA
tut.nm_unidade_trabalho nm_escola,
--CATEGORIA
upper(tc.nm_categoria) AS nm_categoria,
ci_turma,
ds_ofertaitem,
ds_turma,
nr_ent
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
ORDER BY 1,2,4,6;
