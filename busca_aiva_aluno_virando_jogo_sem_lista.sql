--LISTA ALUNOS NÃO CONCLUÍNTES MATRICULADOS ENTRE 2020 A 2022 E NÃO LOCALIZADOS EM 2023

with aluno_ano as (
select
cd_aluno,
max(nr_anoletivo) nr_anoletivo
from academico.tb_ultimaenturmacao tu
where 
tu.nr_anoletivo > 2019
and exists (select 1 from academico.tb_turma t where t.ci_turma = tu.cd_turma and t.cd_prefeitura = 0 and t.cd_nivel in (26,27))
group by 1
),
---
concluintes as(
select 
cd_aluno,
'SIM' ds_conluinte
from public.tb_aluno_resultado_2020 tar 
join academico.tb_turma t on t.ci_turma = tar.cd_turma 
where t.nr_anoletivo =2020
  and (t.cd_etapa in (164,186,190,191,214) or t.cd_anofinaleja = 2)-- Aprovados no (3º e 4º serie EM)
  and cd_tiporesultado in (1,2,6)
union 
select 
cd_aluno,
'SIM' ds_conluinte
from public.tb_aluno_resultado_2021 tar 
join academico.tb_turma t on t.ci_turma = tar.cd_turma 
where t.nr_anoletivo =2021
  and (t.cd_etapa in (164,186,190,191,214) or t.cd_anofinaleja = 2)-- Aprovados no (3º e 4º serie EM)
  and cd_tiporesultado in (1,2,6)
union 
select 
cd_aluno,
'SIM' ds_conluinte
from public.tb_aluno_resultado_2022 tar 
join academico.tb_turma t on t.ci_turma = tar.cd_turma 
where t.nr_anoletivo =2022
  and (t.cd_etapa in (164,186,190,191,214) or t.cd_anofinaleja = 2)-- Aprovados no (3º e 4º serie EM)
  and cd_tiporesultado in (1,2,6)
),
aluno_etapa as(
select 
aa.cd_aluno,
aa.nr_anoletivo,
t.cd_unidade_trabalho,
cd_turma,
t.ds_ofertaitem,
coalesce(ds_conluinte,'NÃO') ds_concluinte
from aluno_ano aa
join academico.tb_ultimaenturmacao tu on tu.cd_aluno = aa.cd_aluno and aa.nr_anoletivo  = tu.nr_anoletivo 
join academico.tb_turma t on t.ci_turma = tu.cd_turma and t.cd_prefeitura = 0 and t.cd_nivel in (26,27)
left join concluintes c on c.cd_aluno = aa.cd_aluno
where 
aa.nr_anoletivo < 2023
--and not exists (select 1 from concluintes c where c.cd_aluno = aa.cd_aluno  ) -- filtro concluiu o EM
and not exists (select 1 from academico.tb_ultimomovimento tm 
						 where tm.nr_anoletivo = 2023 and tm.cd_aluno = aa.cd_aluno and tm.cd_situacao =2) -- filtro matriculado
)
,alunos as (
select 
nm_aluno,
nm_mae,
nm_pai,
to_char(a.dt_nascimento,'dd/mm/yyyy') dt_nascimento,
tl.ds_localidade nm_municipio,
a.ds_logradouro,
a.ds_numero,
a.ds_complemento,
ds_bairro,
a.ds_cep,
a.nr_fone_celular,
a.nr_fone_residencia,
a.nr_fone_residencia_responsavel,
a.nr_fone_celular_responsavel,
a.ci_aluno cd_aluno
from academico.tb_aluno a
left join util.tb_localidades tl on tl.ci_localidade = a.cd_municipio
left join util.tb_bairros tb on tb.ci_bairro = a.cd_bairro 
where a.cd_municipio = 1488
and extract(year from age(a.dt_nascimento::date)) between 15 and 22
)
select 
a.*,
ds_concluinte,
ae.nr_anoletivo,
tut.nm_unidade_trabalho nm_escola,
upper(tmc.nm_municipio) AS nm_municipio_escola,
ds_ofertaitem
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join aluno_etapa ae on ae.cd_unidade_trabalho = tut.ci_unidade_trabalho 
join alunos a  using(cd_aluno)
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
ORDER BY 1,2,4,6,8;

