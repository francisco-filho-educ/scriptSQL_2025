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
tt.nr_anoletivo = 2022
and tt.fl_tipo_seriacao = 'RG' and tt.cd_tpensino = 1 and tt.fl_ativo = 'S'
--and tt.cd_modalidade <> 38
and cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191)
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27 --and ci_turma = 812865
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
                  and tut.cd_dependencia_administrativa = 2 
                  )
) --select count(1) from turma
, enturmados as (
select 
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
where tu.nr_anoletivo = 2022
and tu.fl_tipo_atividade <> 'AC'
and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
) --select count(1) from enturmados --319462
, turma_disc as (
select 
tt2.cd_turma,
tg.ci_grupodisciplina,
tg.ds_grupodisciplina
from academico.tb_turmadisciplina tt2 
join academico.tb_disciplinas td2 on td2.ci_disciplina = tt2.cd_disciplina 
join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina = td2.cd_grupodisciplina 
where tt2.nr_anoletivo = 2022
and exists (select 1 from turma t where  tt2.cd_turma = t.ci_turma) 
group by 1,2,3
) --select count(distinct cd_turma) from turma_disc
, notas as (
select 
ta.cd_aluno,
ta.cd_turma,
ta.cd_periodo,
ta.cd_disciplina,
cd_grupodisciplina,
max(ta.nr_nota) nr_nota 
from academico.tb_alunoavaliacao ta 
join academico.tb_disciplinas disc on disc.ci_disciplina = ta.cd_disciplina 
--and disc.fl_possui_avaliacao = 'S' 
and disc.cd_grupodisciplina between 1 and 14 and cd_periodo in (1,2,3)
where ta.nr_anoletivo = 2022
and exists (select 1 from enturmados t where t.cd_aluno = ta.cd_aluno) 
and ta.nr_nota is not null
group by 1,2,3,4,5 
) --select count(distinct cd_aluno) from notas --318863
,notas_media as (
select
cd_aluno,
cd_turma,
cd_grupodisciplina,
avg(nr_nota) nr_nota,
case when avg(nr_nota) <6 then 1 else 0 end fl_abaixo
from notas 
join turma_disc using(cd_turma)
group by 1,2,3
) --select count(distinct cd_aluno) from  notas_media
,
alunos_abaixo as (
select 
cd_turma,
cd_aluno,
sum(fl_abaixo ) nr_abaixo
from notas_media nm
--where fl_abaixo = 1
group by 1,2
) --select count(1), count(distinct cd_aluno) from alunos_abaixo --328976
,mat as (
select 
tie.*,
coalesce(nr_abaixo,0) nr_abaixo
from public.tb_infrequencia_escola tie -- 317657
left join alunos_abaixo ab using(cd_aluno,cd_turma) --8864 --8935
)--select *  from mat
SELECT  --count(1) nr , count(distinct cd_turma) /*
nr_anoletivo,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) ds_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
cd_turma,
ds_turma,
ds_ofertaitem,
cd_aluno,
nm_aluno,
nr_aulas,
nr_faltas,
p_infrq,
coalesce(nr_abaixo,0)nr_abaixo
FROM rede_fisica.tb_unidade_trabalho tut
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
left JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
left JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
left join rede_fisica.tb_tipo_unid_trab ttut on ttut.ci_tipo_unid_trab = tut.cd_tipo_unid_trab 
join mat on mat.ci_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tlut.fl_sede = TRUE 
and tut.cd_dependencia_administrativa = 2
and tut.cd_tipo_unid_trab = 401