with bairros as (
select
ci_unidade_trabalho,
cd_bairro, ds_bairro, ds_regional 
from util.tb_unidade_trabalho ut 
left join public.tb_bairros_fortaleza_regional tbfr on ci_bairro = cd_bairro 
where ut.cd_bairro is not null
)
select --count(1)
tut.nr_codigo_unid_trab id_escola_inep,	
tut.nr_codigo_unid_trab_provisorio cd_provisorio,
 upper(tut.nm_unidade_trabalho) nome_fantasia,
'SECRETARIA DA EDUCAÇÃO' razao_social,
tut.nr_cnpj  cnpj,
upper(tut.ds_telefone1) fone,
lower(case when tut.ds_email_corporativo is null then tut.ds_email_alternativo else tut.ds_email_corporativo end) e_mail,
upper(tlf.nm_logradouro) endereco_logradouro,
upper(tlf.ds_numero) endereco_numero,
coalesce(ds_bairro,'-') endereco_bairro,
tlf.nr_cep endereco_cep,
upper(tlf.ds_complemento) endereco_complemento,
upper(nm_municipio) endereco_municipio
--responsavel_cpf,
--responsave_nome,
--responsavel_cargo,
--responsavel_e-mail,
FROM rede_fisica.tb_unidade_trabalho tut
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
inner join public.tb_dm_macroregioes tdm on tdm.id_municipio = tlf.cd_municipio_censo
left join bairros b on b.ci_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab in (402,401)
and tut.cd_situacao_funcionamento = 1
AND tlut.fl_sede = true
order by 2,4,5,8