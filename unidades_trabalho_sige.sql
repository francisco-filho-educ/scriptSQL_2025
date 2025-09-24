with mat as (
select cd_unidade_trabalho, 1 fl_matriculas
from academico.tb_turma tt 
where tt.nr_anoletivo = 2022
group by 1,2
)
SELECT 
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
tut.cd_situacao_funcionamento,
tsf.nm_situacao_funcionamento,
tut.cd_tipo_unid_trab,
nm_tipo_unid_trab,
tno.nm_nivel_organizacional,
coalesce(fl_matriculas,0)fl_matriculas
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
left JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
left JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
left join rede_fisica.tb_tipo_unid_trab ttut on ttut.ci_tipo_unid_trab = tut.cd_tipo_unid_trab 
left join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
left join rede_fisica.tb_nivel_organizacional tno on tno.ci_nivel_organizacional = ttut.cd_nivel_organizacional 
left join rede_fisica.tb_dependencia_administrativa tda on tda.ci_dependencia_administrativa = tut.cd_dependencia_administrativa 
WHERE tlut.fl_sede = TRUE 

