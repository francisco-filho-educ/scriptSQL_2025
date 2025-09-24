with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2021 
and tt.cd_prefeitura = 0
and tt.cd_nivel =27
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
and cd_turno in (4,1,5,8,9)
and cd_etapa in(162,184,188)
),
ult_ent as (
  select
  cd_aluno,cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2021 
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ), 
mat as (
  select 
  cd_unidade_trabalho,
  ds_ofertaitem,
  count(1) nr_mat
  from ult_ent
  join turma on ci_turma = cd_turma
  group by 1
  )
SELECT 
2021 
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
ds_ofertaitem,
nr_mat
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
ORDER BY 1,3,4,6;


------------------ crede sefor -----------------------------------------
with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2021 
and tt.cd_prefeitura = 0
and tt.cd_nivel =27
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
            and tut.cd_dependencia_administrativa = 2)
and cd_turno in (4,1,5,8,9)
and cd_etapa in(162,184,188)
),
ult_ent as (
  select
  cd_aluno,cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2021 
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ), 
mat as (
  select 
  cd_unidade_trabalho,
  '1º Serie Ensino Médio' ds_ofertaitem,
  count(distinct cd_turma) nr_turmas,
  count(1) nr_mat
  from ult_ent
  join turma on ci_turma = cd_turma
  group by 1,2
  )
SELECT 
2021 nr_ano,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
--upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria,
--,tut.nr_codigo_unid_trab id_escola_inep, 
--tut.nm_unidade_trabalho nm_escola,
--upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
ds_ofertaitem,
count(distinct tut.ci_unidade_trabalho) nr_escola,
sum(nr_turmas) nr_turmas,
sum(nr_mat) nr_mat
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
group by  1,2,3,4,5
--ORDER BY 1,3,4,6;
union 
SELECT 
2021 nr_ano,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
--upper(tmc.nm_municipio) AS nm_municipio,
'TOTAL'  nm_categoria,
--,tut.nr_codigo_unid_trab id_escola_inep, 
--tut.nm_unidade_trabalho nm_escola,
--upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
ds_ofertaitem,
count(distinct tut.ci_unidade_trabalho) nr_escola,
sum(nr_turmas) nr_turmas,
sum(nr_mat) nr_mat
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
group by  1,2,3,4,5
union 
SELECT 
2021 nr_ano,
0 cd_crede_sefor, 
'TOTAL' nm_crede_sefor, 
--upper(tmc.nm_municipio) AS nm_municipio,
'TOTAL'  nm_categoria,
--,tut.nr_codigo_unid_trab id_escola_inep, 
--tut.nm_unidade_trabalho nm_escola,
--upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
ds_ofertaitem,
count(distinct tut.ci_unidade_trabalho) nr_escola,
sum(nr_turmas) nr_turmas,
sum(nr_mat) nr_mat
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
group by  1,2,3,4,5