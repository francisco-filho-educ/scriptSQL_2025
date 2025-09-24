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
and tt.cd_modalidade <> 38
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27  --and ci_turma = 812865
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = 190--tt.cd_unidade_trabalho 
                  and tut.cd_dependencia_administrativa = 2 )
) --select * from turma
, enturmados as (
select 
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
where tu.nr_anoletivo = 2022
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
where tt2.nr_anoletivo = 2022
and exists (select 1 from turma t where  tt2.cd_turma = t.ci_turma) 
group by 1,2,3
), notas as (
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
and disc.cd_grupodisciplina between 1 and 14 --and cd_periodo = 1
where ta.nr_anoletivo = 2022
and exists (select 1 from enturmados t where t.cd_aluno = ta.cd_aluno and t.cd_turma = ta.cd_turma) 
group by 1,2,3,4,5 
) -- select count(distinct cd_aluno) from notas
,notas_media as (
select
cd_aluno,
cd_turma,
cd_periodo,
cd_grupodisciplina,
avg(nr_nota) nr_nota,
case when avg(nr_nota) <6 then 1 else 0 end fl_abaixo
from notas 
group by 1,2,3,4
) --select fl_abaixo, count(1) from notas_media group by 1
,alunos_abaixo as (
select 
cd_turma,
cd_aluno,
cd_periodo,
count(distinct  case when fl_abaixo = 1 then cd_grupodisciplina end ) nr_abaixo
from notas_media nm
group by 1,2,3
)
select 
2022 nr_ano_sige,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
tmc.ci_municipio_censo id_municipio,
upper(tmc.nm_municipio) AS nm_municipio,
tut.cd_dependencia_administrativa,
tda.nm_dependencia_administrativa,
case when tut.cd_categoria is not null then upper(tc.nm_categoria) 
           else upper(nm_tipo_unid_trab) end AS ds_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao, 
am.*
from alunos_abaixo am --where nr_abaixo is null
join turma on ci_turma = am.cd_turma
from ult_ent tue
join turma tt on tt.ci_turma = tue.cd_turma
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
join rede_fisica.tb_unidade_trabalho tutpai on tut.cd_unidade_trabalho_pai = tutpai.ci_unidade_trabalho 
join rede_fisica.tb_local_unid_trab tlu on tlu.cd_unidade_trabalho  = tut.ci_unidade_trabalho 
join rede_fisica.tb_local_funcionamento tlf on tlu.cd_local_funcionamento  = tlf.ci_local_funcionamento 
join util.tb_municipio_censo tl on tlf.cd_municipio_censo = tl.ci_municipio_censo
join rede_fisica.tb_categoria tc on tc.ci_categoria = tut.cd_categoria
where
tut.cd_situacao_funcionamento = 1 
and tlu.fl_sede = true
and tut.cd_tipo_unid_trab = 401