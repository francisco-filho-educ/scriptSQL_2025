select 
co_pessoa_fisica id_aluno_inep,
concat(tm.nu_ano,'-',nu_mes,'-',nu_dia)::date dt_nascimento,
case when tp_cor_raca is null then 0 else tp_cor_raca end cd_cor_raca,
case
when tp_cor_raca = 0 then 'Não declarada'
when tp_cor_raca = 1 then 'Branca'
when tp_cor_raca = 2 then 'Preta'
when tp_cor_raca = 3 then 'Parda'
when tp_cor_raca = 4 then 'Amarela'
when tp_cor_raca = 5 then 'Indígena' else 'Não declarada' end ds_cor_raca,
case when tp_sexo = 1 then 'Masculino' else 'Feminino' end ds_sexo, 
tp_sexo cd_sexo,
tp_nacionalidade cd_nacionalidade,
case
when tp_nacionalidade = 1 then 'Brasileira'
when tp_nacionalidade = 2 then 'Brasileira - nascido no exterior ou naturalizado'
when tp_nacionalidade = 3 then 'Estrangeira' end ds_nacionalidade,
tm.co_pais_origem id_pais_origem,
tpo.no_pais_origem nm_pais_origem,
in_necessidade_especial fl_necessidade_especial,
in_transporte_publico fl_transporte_escolar,
co_municipio_nasc id_municipio_nascimento,
mn.nm_municipio nm_municipio_nascimento, 
co_municipio_end cd_municipio_residencia,
md.nm_municipio nm_municipio_residencia,
tp_zona_residencial cd_localizacao_residencia, 
case when tp_zona_residencial = 1 then 'Urbana' else 'Rural' end ds_localizacao_residencia, 
coalesce(in_baixa_visao,0) fl_def_baixa_visao,
coalesce(in_cegueira,0) fl_def_cegueira,
coalesce(in_def_auditiva,0) fl_def_auditiva,
coalesce(in_def_fisica,0) fl_def_fisica,
coalesce(in_surdez,0) fl_def_surdez,
coalesce(in_surdocegueira,0) fl_def_surdocegueira,
coalesce(in_def_intelectual,0) fl_def_intelectual,
coalesce(in_def_multipla,0) fl_def_multipla,
coalesce(in_autismo,0) fl_def_autismo,
coalesce(in_superdotacao,0) fl_def_superdotacao,
nu_idade_referencia nr_idade_referencia
from censo_esc_ce.tb_matricula_2019 tm 
join dw_censo.tb_dm_municipio mn on mn.id_municipio = tm.co_municipio_nasc 
join dw_censo.tb_dm_municipio md on md.id_municipio = tm.co_municipio_end 
left join censo_esc_ce.tb_pais_origem tpo on tpo.nu_ano_censo = tm.nu_ano_censo and tpo.co_pais_origem = tm.co_pais_origem 
where tm.nu_ano_censo = 2019
and tp_etapa_ensino is not null 
