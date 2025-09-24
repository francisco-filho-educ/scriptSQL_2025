select
cd_periodo bimestre,
cd_aluno,
nr_codigo_unid_trab cod_inep_escola,
cd_unidade_trabalho_pai cod_crede,
ds_etapa,
ds_turma
,case when count(mat) > 0 then avg(nota_mat)::numeric(5,2) else null end as nota_mat
,case when count(port) > 0 then avg(nota_port)::numeric(5,2) else null end as nota_port
,case when count(red) > 0 then avg(nota_red)::numeric(5,2) else null end as nota_red,bool_or(fl_red)as fl_red
,case when count(art) > 0 then avg(nota_art)::numeric(5,2) else null end as nota_art,bool_or(fl_art)as fl_art
,case when count(ing) > 0 then avg(nota_ing)::numeric(5,2) else null end as nota_ing,bool_or(fl_ing)as fl_ing
,case when count(esp) > 0 then avg(nota_esp)::numeric(5,2) else null end as nota_esp,bool_or(fl_esp)as fl_esp
,case when count(educfis) > 0 then avg(nota_educfis)::numeric(5,2) else null end as nota_educfis
,case when count(fis) > 0 then avg(nota_fis)::numeric(5,2) else null end as nota_fis
,case when count(quim) > 0 then avg(nota_quim)::numeric(5,2) else null end as nota_quim
,case when count(bio) > 0 then avg(nota_bio)::numeric(5,2) else null end as nota_bio
,case when count(geo) > 0 then avg(nota_geo)::numeric(5,2) else null end as nota_geo
,case when count(his) > 0 then avg(nota_his)::numeric(5,2) else null end as nota_his
,case when count(fil) > 0 then avg(nota_fil)::numeric(5,2) else null end as nota_fil,bool_or(fl_fil)as fl_fil
,case when count(soci) > 0 then avg(nota_soci)::numeric(5,2) else null end as nota_soci,bool_or(fl_soci)as fl_soci
from ( select
cd_periodo,
tue.cd_aluno,
tut.nr_codigo_unid_trab,
tut.cd_unidade_trabalho_pai,
ds_newetapa as ds_etapa,ds_turma,
ci_turmadisciplina,ci_grupodisciplina,
ds_grupodisciplina,nr_nota
       ,case when ci_grupodisciplina = 1 then coalesce(nr_nota,0) end as nota_mat
       ,case when ci_grupodisciplina = 4 then coalesce(nr_nota,0) end as nota_port
       ,case when ci_grupodisciplina = 5 then coalesce(nr_nota,0) end as nota_red
       ,case when ci_grupodisciplina = 5 and ci_turmadisciplina is not null then true else false end as fl_red
       ,case when ci_grupodisciplina = 7 then coalesce(nr_nota,0) end as nota_art
       ,case when ci_grupodisciplina = 7 and ci_turmadisciplina is not null then true else false end as fl_art
       ,case when ci_grupodisciplina = 13 then coalesce(nr_nota,0) end as nota_ing
       ,case when ci_grupodisciplina = 13 and ci_turmadisciplina is not null then true else false end as fl_ing
       ,case when ci_grupodisciplina = 14 then coalesce(nr_nota,0) end as nota_esp
       ,case when ci_grupodisciplina = 14 and ci_turmadisciplina is not null then true else false end as fl_esp
       ,case when ci_grupodisciplina = 8 then coalesce(nr_nota,0) end as nota_educfis
       ,case when ci_grupodisciplina = 10 then coalesce(nr_nota,0) end as nota_fis
       ,case when ci_grupodisciplina = 11 then coalesce(nr_nota,0) end as nota_quim
       ,case when ci_grupodisciplina = 6 then coalesce(nr_nota,0) end as nota_bio
       ,case when ci_grupodisciplina = 3 then coalesce(nr_nota,0) end as nota_geo
       ,case when ci_grupodisciplina = 2 then coalesce(nr_nota,0) end as nota_his
       ,case when ci_grupodisciplina = 9 then coalesce(nr_nota,0) end as nota_fil
       ,case when ci_grupodisciplina = 9 and ci_turmadisciplina is not null then true else false end as fl_fil
       ,case when ci_grupodisciplina = 12 then coalesce(nr_nota,0) end as nota_soci
       ,case when ci_grupodisciplina = 12 and ci_turmadisciplina is not null then true else false end as fl_soci
       --NOTAS COM NULOS
       ,case when ci_grupodisciplina = 1 then nr_nota end as mat,case when ci_grupodisciplina = 4 then nr_nota end as port
       ,case when ci_grupodisciplina = 5 then nr_nota end as red,case when ci_grupodisciplina = 7 then nr_nota end as art
       ,case when ci_grupodisciplina = 13 then nr_nota end as ing,case when ci_grupodisciplina = 14 then nr_nota end as esp
       ,case when ci_grupodisciplina = 8 then nr_nota end as educfis,case when ci_grupodisciplina = 10 then nr_nota end as fis
       ,case when ci_grupodisciplina = 11 then nr_nota end as quim,case when ci_grupodisciplina = 6 then nr_nota end as bio
       ,case when ci_grupodisciplina = 3 then nr_nota end as geo,case when ci_grupodisciplina = 2 then nr_nota end as his
       ,case when ci_grupodisciplina = 9 then nr_nota end as fil,case when ci_grupodisciplina = 12 then nr_nota end as soci
       --select 1
       from academico.tb_turma tt
       join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho and tut.cd_dependencia_administrativa = 2
       join academico.tb_etapa_etapamodalidade teem on tt.cd_etapa = teem.cd_etapa and tt.cd_modalidade = teem.cd_modalidade
       join academico.tb_turmadisciplina ttd on ci_turma = ttd.cd_turma and (ttd.nr_semestre = 1 or ttd.nr_semestre = 0) and ttd.nr_anoletivo = tt.nr_anoletivo
       join academico.tb_disciplinas td on td.ci_disciplina = ttd.cd_disciplina and fl_possui_avaliacao = 'S'
       join academico.tb_grupodisciplina tgd on tgd.ci_grupodisciplina = td.cd_grupodisciplina and ci_grupodisciplina between 1 and 14
       join academico.tb_ultimaenturmacao tue on tue.cd_turma = tt.ci_turma and tue.nr_anoletivo = tt.nr_anoletivo
       left
       join( select tt.nr_anoletivo,cd_periodo,ci_turma,cd_disciplina,tue.cd_aluno,nr_nota
             from academico.tb_ultimaenturmacao tue
             join academico.tb_turma tt on tue.nr_anoletivo = tt.nr_anoletivo and tue.cd_turma = tt.ci_turma and cd_nivel = 27
             join academico.tb_alunoavaliacao taa on taa.nr_anoletivo = tt.nr_anoletivo and taa.cd_aluno = tue.cd_aluno
             where tt.nr_anoletivo = 2021 and tt.fl_tipo_seriacao <> 'AC' and tt.cd_tpensino = 1 and tt.fl_ativo = 'S'
             and tt.cd_modalidade <> 38
             and tt.cd_prefeitura = 0
             and cd_periodo in (3,4)
             and tt.cd_nivel = 27
       )taa on taa.ci_turma = tt.ci_turma and taa.nr_anoletivo = tt.nr_anoletivo and taa.cd_disciplina = ci_disciplina and tue.cd_aluno = taa.cd_aluno
       where ttd.fl_ativo = 'S' and tt.nr_anoletivo = 2021 and tt.fl_tipo_seriacao <> 'AC' and tt.cd_tpensino = 1 and tt.fl_ativo = 'S'
       and tt.cd_modalidade <> 38
       and tt.cd_prefeitura = 0
       --and tut.cd_unidade_trabalho_pai = 20  --FILTRO POR CREDE
       --and tt.ci_turma = 534643 and tue.cd_aluno = 969944 order by tue.cd_aluno,ds_grupodisciplina
       )foo
group by cd_unidade_trabalho_pai,nr_codigo_unid_trab,ds_etapa,ds_turma,cd_aluno,cd_periodo
order by 2,3,4,1
