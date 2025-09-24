select 
2024 nr_anoletivo,
--id_crede_sefor
tut.cd_unidade_trabalho_pai,
--nm_crede_sefor
crede.nm_sigla,
--id_municipio
tmc.ci_municipio_censo,
nm_municipio,
--id_escola
tut.nr_codigo_unid_trab,
--nm_escola
tut.nm_unidade_trabalho,
--nr_ent_3s_20
sum(case when tt.nr_anoletivo = 2023 and cd_etapa = 186 then tt.qtdenturmados else 0 end ) nr_ent_3s_2023,
--nr_ent_2s
sum(case when tt.nr_anoletivo = 2023 and cd_etapa = 185 then tt.qtdenturmados else 0 end ) nr_ent_2s_2023,
--nr_ent_3s
sum(case when tt.nr_anoletivo = 2024 and cd_etapa = 186 then tt.qtdenturmados else 0 end ) nr_ent_2s_2024
from academico.tb_turma tt 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
where 
nr_anoletivo > 2022
and cd_curso  = 25
and cd_prefeitura = 0 
and cd_nivel = 27
and cd_etapa in (185,186)
and tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab = 401
and tut.cd_categoria = 8
AND tlut.fl_sede = true
group by 1,2,3,4,5,6,7