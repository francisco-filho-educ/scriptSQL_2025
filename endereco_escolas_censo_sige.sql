select 
NR_ANO_CENSO,
ID_CREDE_SEFOR,
NM_CREDE_SEFOR,
ID_MUNICIPIO::bigint,
NM_MUNICIPIO,
DS_DEPENDENCIA,
ID_ESCOLA_INEP::text,
nm_escola,
DS_LOCALIZACAO,
concat(tce.ds_endereco,', ' ,tce.nu_endereco,', ',tce.ds_complemento)  ENDERECO,
NO_BAIRRO,
CO_CEP::text,
TX_EMAIL,
concat('(',tce.nu_ddd::text,')', tce.nu_telefone::text) nu_telefone 
from dw_censo.tb_cubo_matricula tcm
left join censo_esc_ce.tb_catalogo_escolas_2021 tce on tce.co_entidade = id_escola_inep
where nr_ano_censo  = 2022
and tcm.fl_eja = 1
and cd_dependencia <> 2
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
union 
select 
2022 nr_anoletivo,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
tmc.ci_municipio_censo::bigint AS id_municipio,
upper(tmc.nm_municipio) AS nm_municipio,
'ESTADUAL' DS_DEPENDENCIA,
tut.nr_codigo_unid_trab ID_ESCOLA_INEP,
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
concat(tlf.nm_logradouro,', ',tlf.ds_numero,', ',tlf.ds_complemento) ENDERECO,
tlf.nm_bairro,
tlf.nr_cep::text CO_CEP,
tut.ds_email_corporativo TX_EMAIL,
tut.ds_telefone1::text nu_telefone 
--select count(1), count(distinct tut.ci_unidade_trabalho)
FROM dl_sige.rede_fisica_tb_unidade_trabalho tut 
JOIN dl_sige.rede_fisica_tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN dl_sige.rede_fisica_tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN dl_sige.rede_fisica_tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN dl_sige.rede_fisica_tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN dl_sige.rede_fisica_tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN dl_sige.util_tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = TRUE 
and tut.nr_codigo_unid_trab in (select id_escola_inep::text from dw_censo.tb_cubo_matricula tcm2 where nr_ano_censo = 2022 and fl_eja = 1 and cd_dependencia=2)

