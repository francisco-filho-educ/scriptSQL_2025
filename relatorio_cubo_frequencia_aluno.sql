with turma as (
select
nr_anoletivo,
ci_turma,
ds_turma,
cd_nivel,
tee.cd_newetapa cd_etapa,
tee.ds_newetapa ds_etapa,
ds_ofertaitem,
cd_turno,
cd_unidade_trabalho
from academico.tb_turma tt 
join academico.tb_etapa_etapamodalidade tee using(cd_etapa,cd_modalidade,cd_nivel)
--join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = cd_unidade_trabalho and tut.cd_unidade_trabalho_pai = 10 -- FILTRO DE CREDE
where
tt.nr_anoletivo = 2024
and tt.fl_tipo_seriacao = 'RG' and tt.cd_tpensino = 1 
and tt.fl_ativo = 'S'
--and tt.cd_modalidade <> 38
and cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) -- FILTRO DE ETAPAS
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27 -- FILTRO DE NIVEL
--and tt.cd_unidade_trabalho = 517 -- FILTRO DE ESCOLA
--and ci_turma = 967681 -- FILTRO DE TURMA
) --select count(1) from turma
, enturmados as (
select 
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
where tu.nr_anoletivo = 2024
and tu.fl_tipo_atividade <> 'AC'
and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
)
, --select count(1) from enturmados --319462
alunos as  (
select 
ci_aluno cd_aluno,
case when cd_raca is null then 'Não Declarada' else tr.ds_raca end ds_raca,
case when fl_sexo = 'M' then 'Masculino' 
     when fl_sexo = 'F' then 'Feminino' else  'Não Informado' end ds_sexo
from academico.tb_aluno
left join academico.tb_raca tr on tr.ci_raca = cd_raca
where exists (select 1 from enturmados  where cd_aluno = ci_aluno)
),
mat as (
select
tm.cd_unidade_trabalho,
i.nr_anoletivo,
i.cd_turma,
cd_etapa,
ds_etapa,
ds_turno,
ds_turma,
i.cd_aluno,
ds_raca,
ds_sexo,
nr_mes,
nr_ano,
cd_grupodisciplina,
ds_grupodisciplina,
sum(nr_aulas) nr_aulas,
sum(coalesce(nr_faltas,0)) nr_faltas
from public.tb_infrequencia_aluno_disc i
join alunos a on a.cd_aluno = i.cd_aluno
join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina = cd_grupodisciplina
join turma tm on tm.ci_turma = i.cd_turma
join academico.tb_turno tn on tn.ci_turno = tm.cd_turno
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
)
,relatorio as (
select
nr_anoletivo,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
tmc.ci_municipio_censo id_municipio,
upper(tmc.nm_municipio) AS nm_municipio,
nm_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
cd_turma,
cd_etapa,
ds_etapa,
ds_turno,
ds_turma,
cd_aluno,
ds_raca,
ds_sexo,
nr_mes,
nr_ano,
cd_grupodisciplina,
ds_grupodisciplina,
nr_aulas,
nr_faltas
from  mat 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = mat.cd_unidade_trabalho
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
left JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
left JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
left join rede_fisica.tb_tipo_unid_trab ttut on ttut.ci_tipo_unid_trab = tut.cd_tipo_unid_trab  
where
tlut.fl_sede = TRUE 
and tut.cd_dependencia_administrativa = 2
and tut.cd_tipo_unid_trab = 401
) 
select  
id_crede_sefor,
nm_crede_sefor,
id_municipio,
nm_municipio,
id_escola,
nm_escola,
nm_categoria,
cd_etapa,
ds_etapa,
ds_turno,
ds_turma,
nr_anoletivo,
cd_grupodisciplina,
ds_grupodisciplina,
cd_turma,
cd_aluno ci_aluno,
nr_ano,
nr_mes,
ds_raca,
ds_sexo,
nr_aulas,
nr_faltas,
nr_aulas - nr_faltas nr_frequencia
from relatorio 

