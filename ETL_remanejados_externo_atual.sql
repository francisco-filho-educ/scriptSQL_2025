with anoletivo as (
select 
max(nr_anoletivo) nr_anoatual
from academico.tb_turma
where nr_anoletivo > 2022
and cd_prefeitura = 0
)
,remanejados as (
select 
tm.ci_movimento,
tm.cd_unidade_trabalho_origem,
tm.cd_unidade_trabalho_destino,
tm.cd_ofertaitem_origem,
tm.cd_ofertaitem_destino,
ofeo.ds_ofertaitem oferta_origem, 
ofed.ds_ofertaitem oferta_destino,
ofed.cd_nivel,
tm.cd_aluno
from academico.tb_movimento tm
join anoletivo on tm.nr_anoletivo = nr_anoatual
join academico.tb_ofertaitens ofeo on ofeo.ci_ofertaitem = cd_ofertaitem_origem 
join academico.tb_ofertaitens ofed on ofed.ci_ofertaitem = cd_ofertaitem_destino 
where fl_tipo_atividade = 'RG'
and cd_tpmovimento in (2,3,4,5)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tm.cd_unidade_trabalho_destino and cd_dependencia_administrativa=2)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tm.cd_unidade_trabalho_origem and cd_dependencia_administrativa=3)
and ofed.cd_nivel = 27
) 
,ultimo_mov as (
select
cd_aluno,
max(tm.ci_movimento) ci_movimento
from academico.tb_movimento tm
join anoletivo on tm.nr_anoletivo = nr_anoatual
where fl_tipo_atividade = 'RG'
and exists (select 1 from remanejados r where r.cd_aluno = tm.cd_aluno)
group by 1
        )             
, mov_oferta as( 
select 
tm.nr_anoletivo,
tm.cd_aluno,
cd_situacao,
sit.ds_situacao,
oferta_destino,
oferta_origem,
r.cd_unidade_trabalho_origem,
r.cd_unidade_trabalho_destino
from academico.tb_movimento tm
join ultimo_mov  mm using(ci_movimento)
join remanejados r on r.cd_aluno  = tm.cd_aluno
left join academico.tb_situacao sit on sit.ci_situacao = tm.cd_situacao
where  cd_situacao <>2 
) 
,escolas as (
SELECT 
2022 nr_ano_sige,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
case when tut.cd_categoria is null then 'Não se aplica'
           when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
	       when  tut.ci_unidade_trabalho = 47258 then 'CREAECE' else upper(tc.nm_categoria) end AS nm_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
tut.cd_situacao_funcionamento,
tsf.nm_situacao_funcionamento
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
AND tlut.fl_sede = TRUE 
) 
select 
nr_anoletivo ano,
nm_aluno nome_aluno,
nm_mae nome_mae,
to_char(dt_nascimento,'dd/mm/yyyy') data_nascimento,
ta.fl_sexo sexo,
ta.ds_logradouro endereco,
ta.ds_numero numero,
ta.ds_complemento complemento,
tb.ds_bairro bairro,
l.ds_localidade municipio_end,
replace(
replace(
replace(
concat(ta.nr_ddd_residencia,'-', ta.nr_fone_residencia,' / ' ,ta.nr_ddd_celular,'-',ta.nr_fone_celular,' / ',ta.nr_ddd_celular_responsavel,'-',ta.nr_fone_celular_responsavel),'- / -',''),'- / ',''),'/ -','' ) contato,
eo.nm_municipio nm_municipio_origem,
eo.id_escola_inep inep,
eo.nm_escola nome_escola,
oferta_origem nome_serie_origem,
ed.id_crede_sefor,
ed.nm_crede_sefor,
ed.id_escola_inep,
ed.nm_escola,
ed.nm_categoria,
oferta_destino,
ds_situacao 
from mov_oferta ao
join escolas eo on eo.id_escola_sige = ao.cd_unidade_trabalho_origem
join escolas ed on ed.id_escola_sige = ao.cd_unidade_trabalho_destino
join academico.tb_aluno ta on ta.ci_aluno = cd_aluno
join util.tb_localidades l on l.ci_localidade = ta.cd_municipio
left join util.tb_bairros tb on tb.ci_bairro = ta.cd_bairro