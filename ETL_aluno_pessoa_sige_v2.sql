select
ci_aluno cd_aluno,
cd_turma,
cd_inep_aluno,
nm_aluno,
case when nm_mae is not null then nm_mae else  tp1.nm_pessoa end nm_filiacao_1,
case when nm_pai is not null then nm_pai else  tp2.nm_pessoa end nm_filiacao_2,
ta.dt_nascimento::text,
case when ta.cd_raca is null then 6 else ta.cd_raca end cd_raca,
coalesce(ds_raca, 'Não Declarado') ds_raca,
ta.cd_etnia_indigena,
ta.cd_povos_comunid_trad,
case when ta.fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo, -- 1: masculino | 2: feminino 
case when ta.fl_sexo = 'M' then 1 else 2 end cd_sexo, -- 1: masculino | 2: feminino 
case when tad.cd_deficiencia is not null then 1 else 0 end fl_especial,
case when ta.fl_bolsaescola = 'S' then 1 else 0 end fl_bolsaescola,
case when ta.fl_transporte = 'S' then 1 else 0 end fl_transporte,
ta.cd_municipio_nascimento,
ta.cd_municipio cd_municipio_residencia,
ta.ds_localizacao_residencia, 
case when ta.fl_atendimento_especializado = 'S' then 1 else 0 end fl_atendimento_especializado,
max(case when tad.cd_deficiencia = 2 then 1 else 0 end) fl_baixa_visao,
--Cegueira
max(case when tad.cd_deficiencia = 1 then 1 else 0 end) fl_cegueira,
--Deficiência Auditiva
max(case when tad.cd_deficiencia = 4 then 1 else 0 end) fl_def_auditiva,
--Deficiência Física
max(case when tad.cd_deficiencia = 6 then 1 else 0 end) fl_def_fisica,
--Surdez
max(case when tad.cd_deficiencia = 3 then 1 else 0 end) fl_surdez,
--Surdocegueira
max(case when tad.cd_deficiencia = 5 then 1 else 0 end) fl_surdocegueira,
--Deficiência Intelectual
max(case when tad.cd_deficiencia = 7 then 1 else 0 end) fl_def_intelectual,
--Deficiência Múltipla
max(case when tad.cd_deficiencia = 8 then 1 else 0 end) fl_def_multipla,
--Autismo
max(case when tad.cd_deficiencia between 9 and 12 then 1 else 0 end) fl_autismo,
--Altas habilidades/ superdotação
max(case when tad.cd_deficiencia = 13 then 1 else 0 end) fl_def_fisica
from academico.tb_aluno ta
join academico.tb_ultimaenturmacao tu on tu.cd_aluno = ta.ci_aluno 
left join academico.tb_aluno_deficiencia tad on tad.cd_aluno = ta.ci_aluno 
left join academico.tb_raca tr on tr.ci_raca = ta.cd_raca
left join academico.tb_pessoa tp1 on tp1.ci_pessoa = cd_filiacao_1
left join academico.tb_pessoa tp2 on tp2.ci_pessoa = cd_filiacao_2
where 
tu.nr_anoletivo = 2024
and tu.fl_tipo_atividade <> 'AC'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
