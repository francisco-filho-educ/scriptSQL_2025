with turmas as (
select  *
from academico.tb_turma t
join academico.tb_curso tc on tc.ci_curso = t.cd_curso 
where 
nr_anoletivo = 2024
and cd_nivel = 27
and (cd_etapa in (213,214) or cd_curso in (137,136))
and cd_turno = 2 
)
,extensao as (
select
     tt.ci_turma, 
     --Quando não tiver o nome da extesão ira aprecer o tipo de local de funcionamento 
     case when tlf.nm_local_funcionamento ='' or tlf.nm_local_funcionamento is null then ttl.nm_tipo_local else tlf.nm_local_funcionamento  end nm_local_funcionamento ,
     tlf.ci_local_funcionamento
     from turmas tt
     join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
     join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
     join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = lut.cd_local_funcionamento 
     join rede_fisica.tb_tipo_local ttl on ttl.ci_tipo_local = tlf.cd_tipo_local 
     where  lut.fl_sede = false
     and cd_nivel =27
     and tt.cd_prefeitura = 0-- and tt.cd_unidade_trabalho = 15465
     group by 1,2,3
     
) 
,turma_disciplina as (
select 
cd_turma, 
cd_disciplina,
ds_disciplina
from academico.tb_turmadisciplina tt2
join academico.tb_disciplinas td on td.ci_disciplina = tt2.cd_disciplina and td.fl_tipo ilike 'P'
where tt2.nr_anoletivo = 2024 
and exists (select from turmas t where tt2.cd_turma = ci_turma )
and tt2.cd_turno  = 2
and cd_turma is not null 
group by 1,2,3
)
select --* from turma_disciplina
nr_anoletivo,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
nm_categoria,
t.ci_turma,
t.ds_turma,
coalesce(ex.nm_local_funcionamento, '--') extensao,
case when t.cd_modalidade  = 38 then 'EJA' else tm.ds_modalidade end ds_modalidade,
ds_ofertaitem,
nm_curso,
coalesce(ds_disciplina, 'Não informado') ds_disciplina,
t.qtdenturmados 
from turmas t 
join academico.tb_modalidade tm on tm.ci_modalidade = t.cd_modalidade
left join turma_disciplina td on td.cd_turma  = ci_turma 
join  rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join extensao ex on ex.ci_turma = t.ci_turma
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab in (402,401)
AND tlut.fl_sede = true
order by 2,7,11,12


