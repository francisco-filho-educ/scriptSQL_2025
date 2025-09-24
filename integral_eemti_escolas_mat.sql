with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
case when cd_turno in (8,9) then 'Integral' else ds_turno end ds_turno,
cd_unidade_trabalho
from academico.tb_turma tt 
join academico.tb_turno tr on tr.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2022 
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and cd_turno in (8,9,5)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2
						and tut.cd_categoria  = 9) 
                        ),                        
ult_ent as (
  select
  cd_aluno,
  cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2022 
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ),mat as (
select 
cd_unidade_trabalho,
count(1) nr_matricula
from turma t
join ult_ent on ci_turma = cd_turma
group by 1
)
select 
crede.ci_unidade_trabalho id_crede_sefor,
crede.nm_sigla nm_crede_sefor,
tmc.ci_municipio_censo,
upper(tmc.nm_municipio) nm_municipio,
tut.nr_codigo_unid_trab id_escola_inep,
tut.nm_unidade_trabalho nm_escola,
nr_matricula
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
join mat m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab = 401
order by 1,4,6
