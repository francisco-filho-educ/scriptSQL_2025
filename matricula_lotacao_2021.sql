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
						and tut.cd_dependencia_administrativa = 2 
						and (tut.cd_categoria = 9 or tut.nr_codigo_unid_trab in ('23062738','23062703','23264675','23249676','23124121','23127171','23129018','23095881','23126833','23225190','23219181','23245292','23115050','23275057','23106590','23142286','23151528','23167190','23108657','23264624','23167963','23162350','23038004','23044039','23170620','23167386','23002115','23004258','23007648','23545429','23271850','23013125','23018445','23264101','23247754','23051671','23052643','23055693','23055995','23157879','23077387','23065273','23078758','23075791','23068710')
						)
						)
				

),
ult_ent as (
  select
  cd_aluno,cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2021 
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
  ), lotacao as (
select
tt.cd_unidade_trabalho,
count(distinct dl.cpf) nr_prof 
from academico.tb_turma tt
join lotacaocoave.mvw_coave_turmas_presenciais lt on lt.ci_turma = tt.ci_turma
join lotacaocoave.mvw_coave_docentes dl on dl.cd_vinculo = lt.cd_vinculo
where exists (select 1 from turma t where  lt.ci_turma = tt.ci_turma)
group by 1
),
mat as (
  select 
  cd_unidade_trabalho,
  count(1) nr_mat
  from ult_ent
  join turma on ci_turma = cd_turma
  group by 1
  )
SELECT 
2021 nr_ano,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
nr_mat,
nr_prof
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
join lotacao l on l.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
ORDER BY 1,3,4,6;
