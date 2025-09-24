with salas_mult as (
select 
ta.cd_local_funcionamento,
1 fl_multimeios
from rede_fisica.tb_local_funcionamento tlf 
join rede_fisica.tb_local_unid_trab tlut on tlut.cd_local_funcionamento = ci_local_funcionamento 
join rede_fisica.tb_ambiente ta on ta.cd_local_funcionamento = tlf.ci_local_funcionamento 
join rede_fisica.tb_tipo_ambiente tta on tta.ci_tipo_ambiente = ta.cd_tipo_ambiente 
and ta.cd_tipo_ambiente in (13,14,15)
group by 1,2
)
SELECT 
tut.ci_unidade_trabalho id_escola_sige
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
--join rede_fisica.tb_ambiente ta on ta.cd_local_funcionamento = tlf.ci_local_funcionamento 
--join rede_fisica.tb_tipo_ambiente tta on tta.ci_tipo_ambiente = ta.cd_tipo_ambiente 
join salas_mult sm on sm.cd_local_funcionamento = ci_local_funcionamento 
WHERE tut.cd_dependencia_administrativa = 2
and tut.cd_tipo_unid_trab = 401
AND tut.cd_situacao_funcionamento = 1
AND tlut.fl_sede = TRUE 
