select 
    tt.nr_anoletivo,
    tut.cd_unidade_trabalho_pai as cd_crede,
    tutpai.nm_sigla as nm_crede,
    tl.ci_localidade as cd_municipio,
    tl.ds_localidade as nm_municipio,
    tut.ci_unidade_trabalho as cd_unidade_trabalho,
    tut.nr_codigo_unid_trab,
    tut.nm_unidade_trabalho,
    tut.cd_subcategoria,
    nm_subcategoria,
    is_prioritaria,
    case 
        when is_prioritaria then 'Prioritária' 
        else 'Não Prioritária' 
    end as ds_classific_dif,
    teem.cd_nivel,
    teem.ds_nivel,
    teem.cd_newmodalidade as cd_modalidade,
    teem.ds_newmodalidade as ds_modalidade,
    ttrn.id_ordem as cd_turno,
    ttrn.ds_turno,
    ci_curso as cd_curso,
    case    
        when ci_curso = 1 then 'Médio Regular Anual'
        when ci_curso = 126 then 'Médio Regular Semestral'
        when ci_curso = 27 then 'Magistério'
        else initcap(replace(nm_curso,'TÉCNICO EM ','')) 
    end as nm_curso,
    teem.cd_newetapa as cd_etapa,
    teem.ds_newetapa as ds_etapa,
    tt.ci_turma as cd_turma,
    tt.ds_turma,
    cd_periodo,
    (abaixo_0+abaixo_1+abaixo_2+abaixo_3+abaixo_4+abaixo_5+abaixo_6+abaixo_7+abaixo_8+abaixo_9+abaixo_10+abaixo_11+abaixo_12+abaixo_13) as total_alunos,
    abaixo_0,
    abaixo_1,
    abaixo_2,
    abaixo_3,
    abaixo_4,
    abaixo_5,
    abaixo_6,
    abaixo_7,
    abaixo_8,
    abaixo_9,
    abaixo_10,
    abaixo_11,
    abaixo_12,
    abaixo_13,
    (abaixo_3+abaixo_4+abaixo_5+abaixo_6+abaixo_7+abaixo_8+abaixo_9+abaixo_10+abaixo_11+abaixo_12+abaixo_13) as abaixo_3_ou_mais
from (
    select 
        foo2.nr_anoletivo as nr_ano,
        cd_periodo,
        foo2.cd_unidade_trabalho,
        ci_turma,
        coalesce(sum(abaixo_0),0) as abaixo_0,
        coalesce(sum(abaixo_1),0) as abaixo_1,
        coalesce(sum(abaixo_2),0) as abaixo_2,
        coalesce(sum(abaixo_3),0) as abaixo_3,
        coalesce(sum(abaixo_4),0) as abaixo_4,
        coalesce(sum(abaixo_5),0) as abaixo_5,
        coalesce(sum(abaixo_6),0) as abaixo_6,
        coalesce(sum(abaixo_7),0) as abaixo_7,
        coalesce(sum(abaixo_8),0) as abaixo_8,
        coalesce(sum(abaixo_9),0) as abaixo_9,
        coalesce(sum(abaixo_10),0) as abaixo_10,
        coalesce(sum(abaixo_11),0) as abaixo_11,
        coalesce(sum(abaixo_12),0) as abaixo_12,
        coalesce(sum(abaixo_13),0) as abaixo_13,
        case 
            when ci_escolas_prioritarias is not null then true 
            else false 
        end as is_prioritaria
    from (
        select 
            nr_anoletivo,
            cd_periodo,
            cd_unidade_trabalho,
            ci_turma,
            case 
                when qtd_nota_abaixo = 0 then count(cd_aluno) 
            end as abaixo_0,
            case 
                when qtd_nota_abaixo = 1 then count(cd_aluno) 
            end as abaixo_1,
            case 
                when qtd_nota_abaixo = 2 then count(cd_aluno) 
            end as abaixo_2,
            case 
                when qtd_nota_abaixo = 3 then count(cd_aluno) 
            end as abaixo_3,
            case 
                when qtd_nota_abaixo = 4 then count(cd_aluno) 
            end as abaixo_4,
            case 
                when qtd_nota_abaixo = 5 then count(cd_aluno) 
            end as abaixo_5,
            case 
                when qtd_nota_abaixo = 6 then count(cd_aluno) 
            end as abaixo_6,
            case 
                when qtd_nota_abaixo = 7 then count(cd_aluno) 
            end as abaixo_7,
            case 
                when qtd_nota_abaixo = 8 then count(cd_aluno) 
            end as abaixo_8,
            case 
                when qtd_nota_abaixo = 9 then count(cd_aluno) 
            end as abaixo_9,
            case 
                when qtd_nota_abaixo = 10 then count(cd_aluno) 
            end as abaixo_10,
            case 
                when qtd_nota_abaixo = 11 then count(cd_aluno) 
            end as abaixo_11,
            case 
                when qtd_nota_abaixo = 12 then count(cd_aluno) 
            end as abaixo_12,
            case 
                when qtd_nota_abaixo >= 13 then count(cd_aluno) 
            end as abaixo_13
        from (
            select 
                nr_anoletivo,
                cd_periodo,
                cd_unidade_trabalho,
                ci_turma,
                cd_aluno,
                sum(nota_abaixo) as qtd_nota_abaixo
            from (
                with notas as (
                    select 
                        tt.nr_anoletivo,
                        ttd.cd_periodo,
                        tt.cd_unidade_trabalho,
                        ci_turma,
                        taa.cd_disciplina,
                        tue.cd_aluno,
                        nr_nota
                    from 
                        academico.tb_ultimaenturmacao tue
                        join academico.tb_turma tt on 
                            tue.nr_anoletivo = tt.nr_anoletivo 
                            and tue.cd_turma = tt.ci_turma
                        join academico.tb_alunoavaliacao taa on 
                            taa.nr_anoletivo = tt.nr_anoletivo 
                            and taa.cd_aluno = tue.cd_aluno
                        join (
                            select 
                                ttd.nr_anoletivo,
                                cd_periodo,
                                cd_turma,
                                cd_disciplina
                            from (
                                select 
                                    tput.*,
                                    nr_semestre as semestre 
                                from 
                                    academico.tb_periodounidadetrabalho tput
                                    join academico.tb_periodo tp on 
                                        ci_periodo = tput.cd_periodo
                                where 
                                    cd_periodo < 5 
                                    and nr_anoletivo = 2024  
                                    and cd_unidade_trabalho = 678
                                    and (dt_fim)::date < current_date::date
                            )tam
                            join academico.tb_turmadisciplina ttd on 
                                (ttd.nr_semestre = tam.semestre or ttd.nr_semestre = 0) 
                                and ttd.nr_anoletivo = tam.nr_anoletivo
                            join academico.tb_turma tt on 
                                tt.nr_anoletivo = ttd.nr_anoletivo 
                                and tt.ci_turma = ttd.cd_turma 
                                and tt.cd_unidade_trabalho = 678
                            join academico.tb_disciplinas td on 
                                td.ci_disciplina = ttd.cd_disciplina 
                                and fl_possui_avaliacao = 'S' 
                                and cd_grupodisciplina between 1 and 14 
                                and not cd_grupodisciplina = 5
                        )ttd on 
                            ttd.nr_anoletivo = tt.nr_anoletivo 
                            and ttd.cd_turma = tt.ci_turma 
                            and ttd.cd_periodo = taa.cd_periodo 
                            and ttd.cd_disciplina = taa.cd_disciplina
                    where 
                        tt.nr_anoletivo = 2024  
                        and tt.fl_tipo_seriacao <> 'AC' 
                        and tt.cd_tpensino = 1 
                        and tt.fl_ativo = 'S' 
                        and tt.cd_modalidade <> 38 
                        and tt.cd_prefeitura = 0 
                        and tt.cd_nivel = 27
                        and tt.cd_unidade_trabalho = 678
                )
                select 
                    nr_anoletivo,
                    5 as cd_periodo,
                    cd_unidade_trabalho,
                    ci_turma,
                    cd_disciplina,
                    cd_aluno,
                    avg(nr_nota)::numeric(5,2) as nr_nota,
                    case 
                        when avg(nr_nota)::numeric(5,2) < 6 then 1 
                        else 0 
                    end as nota_abaixo
                from 
                    notas 
                group by 
                    1,2,3,4,5,6
                union
                select 
                    *,
                    case 
                        when nr_nota < 6 then 1 
                        else 0 
                    end as nota_abaixo 
                from 
                    notas
            )foo
            group by 
                nr_anoletivo,
                cd_periodo,
                cd_unidade_trabalho,
                ci_turma,
                cd_aluno
        )foo
        group by 
            nr_anoletivo,
            cd_periodo,
            cd_unidade_trabalho,
            ci_turma,
            qtd_nota_abaixo
    )foo2
    left join 
        saladesituacao.tb_escolas_prioritarias tep on 
            tep.cd_unidade_trabalho = foo2.cd_unidade_trabalho 
            and tep.nr_anoletivo = 2024 
    group by 
        foo2.nr_anoletivo,
        cd_periodo,
        foo2.cd_unidade_trabalho,
        ci_turma,
        ci_escolas_prioritarias
)foo3
join 
    academico.tb_turma tt on 
        tt.ci_turma = foo3.ci_turma
join 
    util.tb_unidade_trabalho tut on 
        tut.ci_unidade_trabalho = tt.cd_unidade_trabalho
join 
    util.tb_subcategoria tcat on 
        tcat.ci_subcategoria = tut.cd_subcategoria
join 
    academico.tb_etapa_etapamodalidade teem on 
        tt.cd_etapa = teem.cd_etapa 
        and tt.cd_modalidade = teem.cd_modalidade
join 
    util.tb_localidades tl on 
        tl.ci_localidade = tut.cd_municipio
join 
    util.tb_unidade_trabalho tutpai on 
        tutpai.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
join 
    academico.tb_turno ttrn on 
        ci_turno = tt.cd_turno
join 
    academico.tb_curso tc on 
        ci_curso = tt.cd_curso
order by 
    tt.nr_anoletivo,
    tt.ci_turma,
    cd_periodo;