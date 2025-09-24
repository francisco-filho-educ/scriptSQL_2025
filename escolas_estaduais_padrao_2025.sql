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
,ambiente as (
select 
tut.ci_unidade_trabalho,
cd_tipo_ambiente,
nm_tipo_ambiente,
nm_ambiente_status status
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
join rede_fisica.tb_ambiente ta on ta.cd_local_funcionamento = ci_local_funcionamento 
join rede_fisica.tb_tipo_ambiente tta on tta.ci_tipo_ambiente = ta.cd_tipo_ambiente 
join rede_fisica.tb_ambiente_status tas on tas.ci_ambiente_status = ta.cd_ambiente_status 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
and cd_ambiente_status = 1 -- and tut.ci_unidade_trabalho = 483
group by 1,2,3,4
)
,rede_fisica_final as (
select 
ci_unidade_trabalho,
max(	case when cd_tipo_ambiente =	13	 Then 1 else 0 end )	fl_possi_biblioteca	,
max(	case when cd_tipo_ambiente =	117	 Then 1 else 0 end )	fl_possui_gremio	,
max(	case when cd_tipo_ambiente =	19	 Then 1 else 0 end )	fl_possui_lab_biologia	,
max(	case when cd_tipo_ambiente =	71	 Then 1 else 0 end )	fl_possui_lab_ciencias	,
max(	case when cd_tipo_ambiente =	114	 Then 1 else 0 end )	fl_possui_lab_edificacoes	,
max(	case when cd_tipo_ambiente =	113	 Then 1 else 0 end )	fl_possui_lab_enfermagem	,
max(	case when cd_tipo_ambiente =	21	 Then 1 else 0 end )	fl_possui_fisica	,
max(	Case when cd_tipo_ambiente in (	18,78)	 Then 1 else 0 end )	fl_possui_lab_informatica	,
max(	case when cd_tipo_ambiente =	115	 Then 1 else 0 end )	fl_possui_lab_linguas	,
max(	case when cd_tipo_ambiente =	22	 Then 1 else 0 end )	fl_possui_lab_matematica	,
max(	case when cd_tipo_ambiente =	20	 Then 1 else 0 end )	fl_possui_lab_quimica	,
max(	case when cd_tipo_ambiente =	118	 Then 1 else 0 end )	fl_possui_lab_redacao	,
max(	case when cd_tipo_ambiente =	122	 Then 1 else 0 end )	fl_possui_lab_educ_profissional	,
max(	case when cd_tipo_ambiente =	116	 Then 1 else 0 end )	fl_possui_lab_tecnologico	,
max(	case when cd_tipo_ambiente =	12	 Then 1 else 0 end )	fl_possui_sala_leitura	,
max(	case when cd_tipo_ambiente =	15	 Then 1 else 0 end )	fl_possui_sala_multimeios	,
max(	case when cd_tipo_ambiente =	14	 Then 1 else 0 end )	fl_possui_sala_multimida	,
max(	case when cd_tipo_ambiente =	16	 Then 1 else 0 end )	fl_possui_sala_aee
from ambiente 
group by 1
)
select --count(1)
tut.ci_unidade_trabalho id_escola_sige,
crede.ci_unidade_trabalho cd_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
cd_macrorregiao,
upper(tdm.nm_macrorregiao)nm_macrorregiao ,
id_municipio,
upper(nm_municipio) AS nm_municipio,
case 
when  tut.cd_tipo_unid_trab = 402 then 402
when  tut.ci_unidade_trabalho in (47258,50410) then 50410  
when tut.cd_categoria is null then 99
else tut.cd_categoria end AS cd_categoria,
case 
when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
when  tut.ci_unidade_trabalho in (47258,50410) then 'CREAECE' 
when tut.cd_categoria is null then 'Não se aplica'
else upper(tc.nm_categoria) end AS nm_categoria,
--tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
coalesce(ds_bairro,'-')ds_bairro,
coalesce(ds_regional,'-')ds_regional, 
coalesce(fl_possi_biblioteca	,0)	fl_possi_biblioteca,
coalesce(fl_possui_gremio	,0)	fl_possui_gremio,
coalesce(fl_possui_lab_biologia	,0)	fl_possui_lab_biologia,
coalesce(fl_possui_lab_ciencias	,0)	fl_possui_lab_ciencias,
coalesce(fl_possui_lab_edificacoes	,0)	fl_possui_lab_edificacoes,
coalesce(fl_possui_lab_enfermagem	,0)	fl_possui_lab_enfermagem,
coalesce(fl_possui_fisica	,0)	fl_possui_fisica,
coalesce(fl_possui_lab_informatica	,0)	fl_possui_lab_informatica,
coalesce(fl_possui_lab_linguas	,0)	fl_possui_lab_linguas,
coalesce(fl_possui_lab_matematica	,0)	fl_possui_lab_matematica,
coalesce(fl_possui_lab_quimica	,0)	fl_possui_lab_quimica,
coalesce(fl_possui_lab_redacao	,0)	fl_possui_lab_redacao,
coalesce(fl_possui_lab_educ_profissional	,0)	fl_possui_lab_educ_profissional,
coalesce(fl_possui_lab_tecnologico	,0)	fl_possui_lab_tecnologico,
coalesce(fl_possui_sala_leitura	,0)	fl_possui_sala_leitura,
coalesce(fl_possui_sala_multimeios	,0)	fl_possui_sala_multimeios,
coalesce(fl_possui_sala_multimida	,0)	fl_possui_sala_multimida,
coalesce(fl_possui_sala_aee	,0)	fl_possui_sala_aee,
case when tcon.cd_unidade_trabalho is not null then 1 else 0 end fl_conselho_escolar,
to_char(current_date,'dd/mm/yyyy') dt_extracao
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
join rede_fisica_final rf on rf.ci_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
inner join public.tb_dm_macroregioes tdm on tdm.id_municipio = tlf.cd_municipio_censo
left join bairros b on b.ci_unidade_trabalho = tut.ci_unidade_trabalho 
left join (select distinct cd_unidade_trabalho from organismoscolegiados.tb_conselho 
                    where dt_fim >= current_timestamp  and fl_ativo     
					) as  tcon on tcon.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab in (402,401)
and tut.cd_situacao_funcionamento = 1
AND tlut.fl_sede = true
);
alter table dw_sige.tb_dm_escola add primary key (id_escola_sige);

/*
select  * from dw_sige.tb_dm_escola 
select  count(1), count(distinct id_escola_sige ) from dw_sige.tb_dm_escola 
select  count(1), count(distinct id_escola_sige ) from dw_sige.tb_dm_escola 
*/
