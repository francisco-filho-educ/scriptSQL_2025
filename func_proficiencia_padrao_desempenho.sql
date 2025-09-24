CREATE OR REPLACE FUNCTION public.proficiencias_padrao(
    vl_proficiencia NUMERIC,
    cd_ano_serie INT,
    cd_disciplina INT
)
RETURNS TEXT AS $$
BEGIN
    -- Ano/série 2
    IF cd_ano_serie = 2 THEN
        IF vl_proficiencia <= 75 AND cd_disciplina = 1 THEN
            RETURN 'Não Alfabetizado';
        ELSIF vl_proficiencia <= 100 THEN
            RETURN 'Alfabetização Incompleta';
        ELSIF vl_proficiencia <= 125 THEN
            RETURN 'Intermediário';
        ELSIF vl_proficiencia <= 150 THEN
            RETURN 'Suficiente';
        ELSIF vl_proficiencia > 150 THEN
            RETURN 'Desejável';
        ELSE
            RETURN 'ERRO!!';
        END IF;

    -- Ano/série 5
    ELSIF cd_ano_serie = 5 THEN
        IF cd_disciplina = 1 THEN
            IF vl_proficiencia <= 125 THEN
                RETURN 'Muito Crítico';
            ELSIF vl_proficiencia <= 175 THEN
                RETURN 'Crítico';
            ELSIF vl_proficiencia <= 225 THEN
                RETURN 'Intermediário';
            ELSE
                RETURN 'Adequado';
            END IF;
        ELSE
            IF vl_proficiencia <= 150 THEN
                RETURN 'Muito Crítico';
            ELSIF vl_proficiencia <= 200 THEN
                RETURN 'Crítico';
            ELSIF vl_proficiencia <= 250 THEN
                RETURN 'Intermediário';
            ELSE
                RETURN 'Adequado';
            END IF;
        END IF;

    -- Ano/série 9
    ELSIF cd_ano_serie = 9 THEN
        IF cd_disciplina = 1 THEN
            IF vl_proficiencia <= 200 THEN
                RETURN 'Muito Crítico';
            ELSIF vl_proficiencia <= 250 THEN
                RETURN 'Crítico';
            ELSIF vl_proficiencia <= 300 THEN
                RETURN 'Intermediário';
            ELSE
                RETURN 'Adequado';
            END IF;
        ELSE
            IF vl_proficiencia <= 225 THEN
                RETURN 'Muito Crítico';
            ELSIF vl_proficiencia <= 275 THEN
                RETURN 'Crítico';
            ELSIF vl_proficiencia <= 325 THEN
                RETURN 'Intermediário';
            ELSE
                RETURN 'Adequado';
            END IF;
        END IF;

    -- Ano/série 12
    ELSIF cd_ano_serie = 12 THEN
        IF cd_disciplina = 1 THEN
            IF vl_proficiencia <= 225 THEN
                RETURN 'Muito Crítico';
            ELSIF vl_proficiencia <= 275 THEN
                RETURN 'Crítico';
            ELSIF vl_proficiencia <= 325 THEN
                RETURN 'Intermediário';
            ELSE
                RETURN 'Adequado';
            END IF;
        ELSE
            IF vl_proficiencia <= 250 THEN
                RETURN 'Muito Crítico';
            ELSIF vl_proficiencia <= 300 THEN
                RETURN 'Crítico';
            ELSIF vl_proficiencia <= 350 THEN
                RETURN 'Intermediário';
            ELSE
                RETURN 'Adequado';
            END IF;
        END IF;

    -- Erro para ano/série inválido
    ELSE
        RETURN 'ERRO! Ano/série inválido!';
    END IF;
END;
$$ LANGUAGE plpgsql;
/*

select 
vl_proficiencia,
proficiencias_padrao(vl_proficiencia, 2, 1) ds_padrao 
from tb_spaece_2022_lp_ef_5_9ano spa
where spa.cd_etapa_avaliada = 15
*/

