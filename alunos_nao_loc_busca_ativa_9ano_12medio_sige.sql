with turmas_aluno as ( -- alunos do 9 ano fund e 1a e 2a serie do ano anterior 
select 
t.nr_anoletivo,
cd_unidade_trabalho cd_unidade_trabalho_anterior,
ci_turma cd_turma_anterior,
cd_etapa cd_etapa_anterior, 
ds_etapa ds_etapa_anterior,
ue.cd_aluno
from academico.tb_turma t
join academico.tb_ultimaenturmacao ue on t.ci_turma = cd_turma
join academico.tb_etapa te on ci_etapa = cd_etapa
where t.nr_anoletivo = 2022
and cd_prefeitura  = 0
and cd_nivel in (26,27)
and cd_etapa in (129,162,163,184,185,188,189)
and fl_tipo_atividade <> 'AC'
)
--select count(distinct cd_aluno ) from turmas_aluno 
,ultimo_mov as ( -- ultimo movimento desses alunos no sige
select 
cd_aluno,
max(tm.ci_movimento) ci_movimento
from academico.tb_movimento tm
where 
fl_tipo_atividade = 'RG' and nr_anoletivo = 2023   
and exists (select 1 from turmas_aluno ut where  ut.cd_aluno =  tm.cd_aluno) 
group by 1
        )             
--select 1 count(distinct cd_aluno ) from ultimo_mov 
, mov_oferta as(
select 
m3.nr_anoletivo,
m3.cd_unidade_trabalho_destino,
m3.cd_ofertaitem_destino,
m3.cd_aluno,
cd_situacao,
sit.ds_situacao,
oi.cd_etapa cd_etapa_destino
from academico.tb_movimento m3
join ultimo_mov  mm using(ci_movimento)
join academico.tb_ofertaitens oi on oi.ci_ofertaitem = m3.cd_ofertaitem_destino
left join academico.tb_situacao sit on sit.ci_situacao = m3.cd_situacao
where 
oi.nr_anoletivo = 2023
and oi.fl_tipo_seriacao = 'RG'
)        
,relatorio as (
select --cd_situacao, ds_situacao, count(1) from mov_oferta group by 1,2 
ao.nr_anoletivo,
ao.cd_unidade_trabalho_anterior,
cd_turma_anterior,
cd_etapa_anterior, 
ds_etapa_anterior,
ao.cd_aluno,
ut.cd_unidade_trabalho_destino,
ut.cd_ofertaitem_destino,
ut.cd_situacao,
ut.cd_etapa_destino,
case when ut.cd_aluno is null then 'Não localizado em 2023'
     else ds_situacao end ds_situacao 
from turmas_aluno  ao
left join (select * from mov_oferta ut where cd_situacao <> 2) as ut  using(cd_aluno)
where 
not exists  (select 1 from mov_oferta ut where cd_situacao = 2  and  ut.cd_aluno = ao.cd_aluno)
) --select * from relatorio
,escolas as (
select 
tut.ci_unidade_trabalho id_escola_sige,
tut.cd_unidade_trabalho_pai id_crede_sefor,
crede.nm_sigla nm_crede_sefor,
tmc.ci_municipio_censo id_municipio,
upper(nm_municipio) nm_municipio,
tut.nr_codigo_unid_trab id_escola_inep,
tut.nm_unidade_trabalho  nm_escola,
tc.nm_categoria
from rede_fisica.tb_unidade_trabalho tut
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
where 
tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
)
select 
nr_anoletivo ano,
cd_aluno,
nm_aluno nome_aluno,
nm_mae nome_mae,
to_char(dt_nascimento,'dd/mm/yyyy') data_nascimento,
ta.fl_sexo sexo,
upper(ta.ds_logradouro) endereco,
ta.ds_numero numero,
upper(ta.ds_complemento) complemento,
upper(tb.ds_bairro) bairro,
upper(l.ds_localidade) municipio_end,
replace(
replace(
replace(
concat(ta.nr_ddd_residencia,'-', ta.nr_fone_residencia,' / ' ,ta.nr_ddd_celular,'-',ta.nr_fone_celular,' / ',ta.nr_ddd_celular_responsavel,'-',ta.nr_fone_celular_responsavel),'- / -',''),'- / ',''),'/ -','' ) contato,
eo.nm_municipio nm_municipio_origem,
eo.id_escola_inep inep,
eo.nm_escola nome_escola,
ds_etapa_anterior,
ed.id_crede_sefor,
ed.nm_crede_sefor,
ed.id_escola_inep,
ed.nm_escola,
upper(ed.nm_categoria) nm_categoria,
cd_etapa_destino,
ds_situacao 
from relatorio ao
join escolas eo on eo.id_escola_sige = cd_unidade_trabalho_anterior
join escolas ed on ed.id_escola_sige = cd_unidade_trabalho_destino
join academico.tb_aluno ta on ta.ci_aluno = ao.cd_aluno
join util.tb_localidades l on l.ci_localidade = ta.cd_municipio
left join util.tb_bairros tb on tb.ci_bairro = ta.cd_bairro
