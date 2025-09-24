-- SIGE----
with possui as (
select 
tut.ci_unidade_trabalho,
nm_tipo_ambiente,
nm_ambiente_status status, 
'' ds_motivo_desuso,
'' ds_observacao
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
and cd_tipo_ambiente in (18,19,20,21,71,78,116,22,113,114,115,118,122)
--and cd_tipo_ambiente in (74, 52)
and cd_ambiente_status = 1 -- and tut.ci_unidade_trabalho = 483
group by 1,2,3,4,5
) 
--select count(1), count(distinct ci_unidade_trabalho) qtd  from possui
--select ci_unidade_trabalho, count(1) qtd  from possui group by 1 having count(1) >1
,nao_possui as (
select 
tut.ci_unidade_trabalho,
nm_tipo_ambiente,
tas.nm_ambiente_status status,
ta.ds_motivo_desuso,
ta.ds_observacao--, tlut.cd_local_funcionamento
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
join rede_fisica.tb_ambiente ta on ta.cd_local_funcionamento = ci_local_funcionamento 
join rede_fisica.tb_tipo_ambiente tta on tta.ci_tipo_ambiente = ta.cd_tipo_ambiente and (cd_ambiente_status <> 1 or cd_ambiente_status is null )
left join rede_fisica.tb_ambiente_status tas on tas.ci_ambiente_status = ta.cd_ambiente_status 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
and cd_tipo_ambiente in (18,19,20,21,71,78,116,22,113,114,115,118,122)
--and cd_tipo_ambiente in (74, 52)
and not exists (select 1 from possui where tut.ci_unidade_trabalho = possui.ci_unidade_trabalho) 
--and tut.ci_unidade_trabalho = 483
group by 1,2,3,4,5
)
--select count(1), count(distinct ci_unidade_trabalho) qtd from nao_possui
,infra as (
select * from possui
union 
select * from nao_possui
) 
select
--count(1), count(distinct ci_unidade_trabalho) qtd from infra  --906	715
nr_anoletivo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
ds_categoria,
id_escola_inep,
nm_escola,
tde.ds_localizacao,
coalesce (nm_tipo_ambiente,'NÃO INFORMADO') nm_tipo_ambiente,
coalesce (status , 'Sem informação de uso ou existência') status,
ds_motivo_desuso,
ds_observacao
from dw_sige.tb_dm_escola tde
left join infra on id_escola_sige = ci_unidade_trabalho
where 
tde.fl_matricula = 1
and tde.cd_categoria between 5 and 14
and id_escola_sige <> 47258
ORDER BY 2,4,4,7;

