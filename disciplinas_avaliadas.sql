with disciplinas as (
select
ci_disciplina,
    td.cd_grupodisciplina,
    UPPER(
        CASE
            WHEN td.cd_grupodisciplina BETWEEN 1 AND 16 THEN tg.ds_grupodisciplina
            WHEN (td.cd_grupodisciplina IS NULL OR td.cd_grupodisciplina = 0) AND td.cd_areatrabalho IS NOT NULL THEN ta.ds_areatrabalho
            ELSE td.ds_disciplina
        END
    ) AS ds_disciplina
FROM
    academico.tb_disciplinas td
LEFT JOIN
    academico.tb_grupodisciplina tg ON tg.ci_grupodisciplina = td.cd_grupodisciplina
LEFT JOIN
    academico.tb_areatrabalho ta ON ta.ci_areatrabalho = td.cd_areatrabalho
WHERE
    td.cd_prefeitura = 0
    AND td.fl_possui_avaliacao = 'S'
)
