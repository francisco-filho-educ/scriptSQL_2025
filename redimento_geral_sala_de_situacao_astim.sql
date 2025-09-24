with tb_notas as (
    select 
        nr_anoletivo, 
        cd_crede, 
        nm_crede, 
        cd_municipio, 
        nm_municipio, 
        cd_unidade_trabalho, 
        nr_codigo_unid_trab, 
        nm_unidade_trabalho,
        cd_subcategoria, 
        nm_subcategoria, 
        is_prioritaria,
        main.cd_nivel, 
        ds_nivel, 
        cd_modalidade, 
        ds_modalidade, 
        ttrn.id_ordem as cd_turno, 
        ttrn.ds_turno,
        ci_curso as cd_curso,
        case 
            when ci_curso = 1 then 'Médio Regular Anual'
            when ci_curso = 126 then 'Médio Regular Semestral'
            when ci_curso = 27 then 'Magistério'
            else initcap(replace(nm_curso,'TÉCNICO EM ','')) 
        end as nm_curso,
        cd_etapa, 
        ds_etapa, 
        cd_turma, 
        ds_turma, 
        ci_area_de_conhecimento as cd_area_de_conhecimento, 
        nm_area_de_conhecimento,
        ci_grupodisciplina as cd_disciplina, 
        ds_grupodisciplina as ds_disciplina,
        qtd_enturmados, 
        cd_periodo, 
        sum(qtd_enturmados) qtd_informar_ad, 
        sum(qtd_informado_ad) as qtd_informado_ad,
        sum(qtd_informar_td) qtd_informar_td, 
        sum(qtd_informado_td) as qtd_informado_td,
        avg(nr_media)::numeric(5,2) as nr_media,
        case when is_prioritaria then 'Prioritária' else 'Não Prioritária' end as ds_classific_dif
    from (
        select tt.nr_anoletivo,
            tut.cd_unidade_trabalho_pai as cd_crede, 
            tutpai.nm_sigla as nm_crede,
            tl.ci_localidade as cd_municipio, 
            tl.ds_localidade as nm_municipio,
            tut.ci_unidade_trabalho as cd_unidade_trabalho, 
            tut.nr_codigo_unid_trab,
            tut.nm_unidade_trabalho,
             tut.cd_subcategoria,
            teem.cd_nivel, 
            teem.ds_nivel,
            teem.cd_newmodalidade as cd_modalidade, 
            teem.ds_newmodalidade as ds_modalidade,
            teem.cd_newetapa as cd_etapa, 
            teem.ds_newetapa as ds_etapa,
            tt.cd_curso, 
            tt.cd_turno, 
            tt.ci_turma as cd_turma, 
            tt.ds_turma,
            td.cd_grupodisciplina, 
            td.ci_disciplina as cd_disciplina, 
            td.ds_disciplina,
            tam.cd_periodo, 
            qtd_enturmados, 
            coalesce(nr_notas,0) as qtd_informado_ad, 
            nr_media,
            1 as qtd_informar_td,
            case when coalesce(nr_notas,0)::numeric/qtd_enturmados >= 0.8 then 1 else 0 end as qtd_informado_td,
            case when ci_escolas_prioritarias is not null then true else false end as is_prioritaria
        from academico.tb_turma tt
        join util.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho
        join academico.tb_etapa_etapamodalidade teem on tt.cd_etapa = teem.cd_etapa and tt.cd_modalidade = teem.cd_modalidade
        join util.tb_localidades tl on tl.ci_localidade = tut.cd_municipio
        join util.tb_unidade_trabalho tutpai on tutpai.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
        cross join (
            select tput.*, nr_semestre as semestre 
            from academico.tb_periodounidadetrabalho tput
            join academico.tb_periodo tp on ci_periodo = tput.cd_periodo
            where cd_periodo < 5 and nr_anoletivo = 2024 and cd_unidade_trabalho = 678 
            and (dt_fim)::date < current_date::date
        ) tam
        join academico.tb_turmadisciplina ttd on ci_turma = ttd.cd_turma and (ttd.nr_semestre = tam.semestre or ttd.nr_semestre = 0) and ttd.nr_anoletivo = tt.nr_anoletivo
        join academico.tb_disciplinas td on td.ci_disciplina = ttd.cd_disciplina and fl_possui_avaliacao = 'S'
        join (
            select cd_turma, 
            count(cd_aluno) as qtd_enturmados 
            from academico.tb_ultimaenturmacao tue 
            join academico.tb_turma tt on ci_turma = tue.cd_turma and tue.nr_anoletivo = tt.nr_anoletivo and cd_nivel = 27 
            where tt.nr_anoletivo = 2024 and tt.fl_tipo_seriacao <> 'AC' and tt.cd_tpensino = 1 and tt.fl_ativo = 'S' 
            and tt.cd_modalidade <> 38 and tt.cd_prefeitura = 0 and tt.cd_unidade_trabalho = 678  
            group by 1
        ) tue on tue.cd_turma = tt.ci_turma
        left join (
            select tt.nr_anoletivo,
                    cd_periodo, 
                    ci_turma, 
                    cd_disciplina, 
                    count(nr_nota) as nr_notas, 
                    avg(nr_nota) as nr_media
            from academico.tb_ultimaenturmacao tue
            join academico.tb_turma tt on tue.nr_anoletivo = tt.nr_anoletivo and tue.cd_turma = tt.ci_turma and cd_nivel = 27
            join academico.tb_alunoavaliacao taa on taa.nr_anoletivo = tt.nr_anoletivo and taa.cd_aluno = tue.cd_aluno
            where tt.nr_anoletivo = 2024 and tt.fl_tipo_seriacao <> 'AC' and tt.cd_tpensino = 1 and tt.fl_ativo = 'S' 
            and tt.cd_modalidade <> 38 and tt.cd_prefeitura = 0 and tt.cd_unidade_trabalho = 678 
            group by 1,2,3,4
        ) taa on taa.ci_turma = tt.ci_turma and taa.nr_anoletivo = tam.nr_anoletivo and taa.cd_periodo = tam.cd_periodo and taa.cd_disciplina = ci_disciplina
        left join saladesituacao.tb_escolas_prioritarias tep on tep.cd_unidade_trabalho = tut.ci_unidade_trabalho and tep.nr_anoletivo = 2024
        where ttd.fl_ativo = 'S' and tt.nr_anoletivo = 2024 and tt.fl_tipo_seriacao <> 'AC' and tt.cd_tpensino = 1 and tt.fl_ativo = 'S' 
        and tt.cd_modalidade <> 38 and tt.cd_prefeitura = 0 and tt.cd_unidade_trabalho = 678 
    ) main
    join util.tb_subcategoria tcat on tcat.ci_subcategoria = main.cd_subcategoria
    join academico.tb_grupodisciplina tgd on tgd.ci_grupodisciplina = main.cd_grupodisciplina
    join academico.tb_grupodisciplina_area tgda on tgda.cd_grupodisciplina = ci_grupodisciplina and tgda.cd_nivel = 27
    join academico.tb_area_de_conhecimento tac on ci_area_de_conhecimento = tgda.cd_area_de_conhecimento
    join academico.tb_turno ttrn on ci_turno = main.cd_turno
    join academico.tb_curso tc on ci_curso = main.cd_curso
    group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,ds_classific_dif
    order by cd_crede, nm_municipio, nm_unidade_trabalho, ds_modalidade desc, cd_turno, cd_etapa, ds_turma, nm_curso, ds_grupodisciplina, cd_periodo
)
select * from tb_notas
union
select 
    nr_anoletivo,
    cd_crede,
    nm_crede,
    cd_municipio,
    nm_municipio, 
    cd_unidade_trabalho,
    nr_codigo_unid_trab,
    nm_unidade_trabalho,
    cd_subcategoria,
    nm_subcategoria,
    is_prioritaria,
    cd_nivel,
    ds_nivel,
    cd_modalidade,
    ds_modalidade,
    cd_turno,
    ds_turno,
    cd_curso,
    nm_curso,
    cd_etapa,
    ds_etapa,
    cd_turma,
    ds_turma,
    cd_area_de_conhecimento,
    nm_area_de_conhecimento,
    cd_disciplina,
    ds_disciplina,
    qtd_enturmados, 
    5 as cd_periodo, 
    sum(qtd_informar_ad) as qtd_informar_ad, 
    sum(qtd_informado_ad) as qtd_informado_ad,
    sum(qtd_informar_td) as qtd_informar_td, 
    sum(qtd_informado_td) as qtd_informado_td,
    avg(nr_media)::numeric(5,2) as nr_media, 
    ds_classific_dif
from tb_notas
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,ds_classific_dif
order by cd_crede, nm_municipio, nm_unidade_trabalho, ds_modalidade desc, cd_turno, cd_etapa, ds_turma, nm_curso, ds_disciplina, cd_periodo;