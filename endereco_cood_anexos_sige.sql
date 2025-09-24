-- ANEXOS --------
with anexos as (
select --count(distinct tt.cd_unidade_trabalho)
tt.cd_unidade_trabalho cd_unidade_trabalho_sede,
tlf.nm_local_funcionamento nome_anexo, 
upper(concat(tlf.nm_logradouro,', ',tlf.ds_numero,', ',tlf.nm_bairro,', CEP: ',tlf.nr_cep)) ds_endereco_anexo,
upper(tmc.nm_municipio) nm_municipio_anexo,
tlf.nr_latitude,
tlf.nr_longitude,
sum(tt.qtdenturmados) nr_mat
from academico.tb_turma tt
join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = lut.cd_local_funcionamento
left join util.tb_municipio_censo tmc on tmc.ci_municipio_censo = tlf.cd_municipio_censo 
where tt.nr_anoletivo = 2023
and lut.fl_sede = false
and cd_nivel in (27,26,28)
and cd_prefeitura  = 0 
group by 1,2,3,4,5,6
),
infra as  (
select --count(distinct tt.cd_unidade_trabalho)
tlut.cd_unidade_trabalho,
1 fl_lab_informatica
from rede_fisica.tb_ambiente ta 
join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = ta.cd_local_funcionamento
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_local_funcionamento = tlf.ci_local_funcionamento
where ta.cd_tipo_ambiente in (18,78)
group by 1,2
)
select
--CÓDIGO DA CREDE/SEFOR
tut.cd_unidade_trabalho_pai id_crede,
--CREDE/SEFOR
crede.nm_sigla nm_crede,
--CÓDIGO DO MUNICÍPIO
tmc.ci_municipio_censo,
--MUNICÍPIO
upper(tmc.nm_municipio)nm_municipio,
--Localização
--CÓDIGO DA ESCOLA
tut.nr_codigo_unid_trab id_escola_inep,
tut.nm_unidade_trabalho,
nm_categoria,
upper(tlz.nm_localizacao_zona) nm_localizacao_zona,
--NOME DO ANEXO
nome_anexo,
--ENDEREÇO
nr_mat,
ds_endereco_anexo,
--MUNICÍPIO
nm_municipio_anexo,
a.nr_latitude,
a.nr_longitude
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
join rede_fisica.tb_situacao_funcionamento sf on sf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join anexos a on cd_unidade_trabalho_sede = tut.ci_unidade_trabalho 
left join infra inf on inf.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
order by 1
