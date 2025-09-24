with sige as (
select 
2022 nr_ano_censo,
case when tce.cod_inep is null then t.nr_codigo_unid_trab::text else tce.cod_inep end id_escola_inep,
cd_categoria cd_categoria_escola_sige,
nm_categoria ds_categoria_escola_sige
from dl_sige.rede_fisica_tb_unidade_trabalho t 
join dl_sige.rede_fisica_tb_categoria c on c.ci_categoria = t.cd_categoria 
left join dl_sige.tb_codigo_criacao_escola tce on tce.cod_sige::text = nr_codigo_unid_trab
where t.cd_tipo_unid_trab = 401
and exists(select 1 from censo_esc_ce.tb_escola_2022 te where te.co_entidade::text = t.nr_codigo_unid_trab)
or exists(select 1 from dl_sige.tb_codigo_criacao_escola tce where tce.cod_sige::text = nr_codigo_unid_trab and cod_inep <> 'f')

)
,cubo as (
select 
nr_ano_censo,
id_escola_inep::text,
tde.cd_categoria_escola_sige,
tde.ds_categoria_escola_sige
from dw_censo.tb_dm_escola tde 
union
select 
2022 nr_ano_censo,
tcm.id_escola::text id_escola_inep,
tcm.cd_categoria cd_categoria_escola_sige,
tcm.nm_categoria ds_categoria_escola_sige
from dw_sige.tb_cubo_matricula_2022 tcm 
where exists(select 1 from censo_esc_ce.tb_escola_2022 te where te.co_entidade::text = id_escola::text)
group by 1,2,3,4
)
,escolas as (
select 
nr_ano_censo,
id_escola_inep,
cd_categoria_escola_sige,
ds_categoria_escola_sige
from sige s
where not exists(select 1 from cubo te where te.id_escola_inep = s.id_escola_inep)-- id_escola)
group by 1,2,3,4
union 
select * from cubo
)
select  * from escolas --where id_escola_inep::int = '23277548'

