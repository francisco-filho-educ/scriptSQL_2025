drop table if exists dw_sige.tb_dm_escola;
create table dw_sige.tb_dm_escola as (
with bairros as (
select
ci_unidade_trabalho,
cd_bairro, ds_bairro, ds_regional 
from util.tb_unidade_trabalho tut 
left join public.tb_bairros_fortaleza_regional tbfr on ci_bairro = cd_bairro 
where tut.cd_bairro is not null
)
select --count(1)
extract(year from current_date) nr_anoletivo,
tut.ci_unidade_trabalho id_escola_sige,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tdm.nm_macrorregiao)nm_macrorregiao ,
id_municipio,
upper(nm_municipio) AS nm_municipio,
case 
when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
when  tut.ci_unidade_trabalho in (47258,50410) then 'CREAECE' 
when tut.cd_categoria is null then 'Não se aplica'
else upper(tc.nm_categoria) end AS ds_categoria,
--tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
coalesce(ds_bairro,'-')ds_bairro,
coalesce(ds_regional,'-')ds_regional 
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
)