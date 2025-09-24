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