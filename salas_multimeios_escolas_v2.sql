with salas_mult as (
select 
ta.cd_local_funcionamento,
1 fl_multimeios
from rede_fisica.tb_local_funcionamento tlf 
join rede_fisica.tb_local_unid_trab tlut on tlut.cd_local_funcionamento = ci_local_funcionamento 
join rede_fisica.tb_ambiente ta on ta.cd_local_funcionamento = tlf.ci_local_funcionamento 
join rede_fisica.tb_tipo_ambiente tta on tta.ci_tipo_ambiente = ta.cd_tipo_ambiente 
and ta.cd_tipo_ambiente in (12,13,14,15,33)
group by 1,2
)
select  -- count(distinct tut.ci_unidade_trabalho)/*
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep,
coalesce(case when tut.nr_codigo_unid_trab in ('23054530','23263466','23002115','23002115','23462329','23231289','23271663','23548053') then  1 else fl_multimeios end,0) fl_sala_multimeios 
FROM rede_fisica.tb_unidade_trabalho tut 
left JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
left JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
left JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
left join rede_fisica.tb_tipo_unid_trab ttut on ttut.ci_tipo_unid_trab = tut.cd_tipo_unid_trab 
left join salas_mult using(cd_local_funcionamento)
left join rede_fisica.tb_nivel_organizacional tno on tno.ci_nivel_organizacional = ttut.cd_nivel_organizacional 
left join rede_fisica.tb_dependencia_administrativa tda on tda.ci_dependencia_administrativa = tut.cd_dependencia_administrativa 
WHERE tlut.fl_sede = TRUE 
and tut.cd_dependencia_administrativa =2 
and tut.cd_situacao_funcionamento = 1

