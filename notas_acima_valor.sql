with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
ds_turma,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2023
and tt.fl_tipo_seriacao = 'RG' 
and tt.cd_modalidade <> 38
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27  --and ci_turma = 812865
and tt.cd_etapa in (162,163,184,185,189,190)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut 
			where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho
			and tut.cd_dependencia_administrativa = 2 and tut.cd_unidade_trabalho_pai in (1,21,22,23))
) --select * from turma
, enturmados as (
select 
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
where tu.nr_anoletivo = 2023
and tu.fl_tipo_atividade <> 'AC'
and exists (select 1 from turma t where t.ci_turma = tu.cd_turma) 
), turma_disc as (
select 
tt2.cd_turma,
tg.ci_grupodisciplina,
tg.ds_grupodisciplina
from academico.tb_turmadisciplina tt2 
join academico.tb_disciplinas td2 on td2.ci_disciplina = tt2.cd_disciplina 
join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina = td2.cd_grupodisciplina 
where tt2.nr_anoletivo = 2023
and exists (select 1 from turma t where  tt2.cd_turma = t.ci_turma) 
group by 1,2,3
), notas as (
select 
cd_aluno,
cd_turma,
cd_disciplina,
cd_grupodisciplina,
nr_mediafinal 
from rendimento.tb_detalhes_boletim_2023 tdb 
join academico.tb_disciplinas disc on disc.ci_disciplina = tdb.cd_disciplina 
--and disc.fl_possui_avaliacao = 'S' 
and disc.cd_grupodisciplina between 1 and 14 --and cd_periodo = 1
where tdb.nr_anoletivo = 2023
and exists (select 1 from enturmados t where t.cd_aluno = tdb.cd_aluno and t.cd_turma = tdb.cd_turma) 
) 
--select *  from notas
,notas_media as (
select
cd_aluno,
cd_turma,
cd_grupodisciplina,
avg(nr_mediafinal ) nr_mediafinal
from notas 
group by 1,2,3
)
,retirar as (
select 
distinct cd_aluno
from notas_media where nr_mediafinal <9
)

select 
tt.nr_anoletivo,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
tl.ci_municipio_censo id_municipio,
upper(nm_municipio) AS nm_municipio,
tc.nm_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
cd_turma,
ds_turma,
ds_ofertaitem,
cd_aluno,
nm_aluno,
to_char(ta.dt_nascimento,'dd/mm/yyyy') dt_nascimento,
ta.nm_mae,
gd.ds_grupodisciplina,
nr_mediafinal
from notas_media tue
join academico.tb_grupodisciplina gd on gd.ci_grupodisciplina = tue.cd_grupodisciplina
join academico.tb_aluno ta on ta.ci_aluno = tue.cd_aluno
join turma tt on tt.ci_turma = tue.cd_turma
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
join rede_fisica.tb_unidade_trabalho crede on tut.cd_unidade_trabalho_pai = crede.ci_unidade_trabalho 
join rede_fisica.tb_local_unid_trab tlu on tlu.cd_unidade_trabalho  = tut.ci_unidade_trabalho 
join rede_fisica.tb_local_funcionamento tlf on tlu.cd_local_funcionamento  = tlf.ci_local_funcionamento 
join util.tb_municipio_censo tl on tlf.cd_municipio_censo = tl.ci_municipio_censo
join rede_fisica.tb_categoria tc on tc.ci_categoria = tut.cd_categoria
where
not exists (select 1 from retirar r where r.cd_aluno = tue.cd_aluno)
and tut.cd_situacao_funcionamento = 1 
and tlu.fl_sede = true
and tut.cd_tipo_unid_trab = 401