with crede as (
select 
tde.ds_orgao_regional,
id_crede_sefor::INT,
nm_crede_sefor
from dw_censo.tb_dm_escola tde 
where nr_ano_censo = 2022 
and cd_dependencia = 2
and ds_orgao_regional is not null
group by 1,2,3
)
,escolas as (
select 
nu_ano_censo,
case when tte.co_entidade = 23279621 then '021R2' 
     when tte.co_entidade = 23279109 then '021R5'
	 else co_orgao_regional end co_orgao_regional ,
co_municipio,
co_entidade,
no_entidade,
case when tp_localizacao = 1 then 'Urbana' else 'Rural' end ds_localizacao
from censo_esc_d.tb_tb_escola_2023 tte
where 
tte.tp_dependencia = 3
and tte.tp_situacao_funcionamento = 1
)
select
tm.nu_ano_censo::INT,
CO_orgao_regional||'`' ,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
co_entidade,
no_entidade,
ds_localizacao,
count(1) qtd_matriculas
from censo_esc_d.tb_matricula_2023 tm 
join ESCOLAS tte using(co_entidade,nu_ano_censo)
join dw_censo.tb_dm_municipio mu on mu.id_municipio = tte.co_municipio 
left join crede on  ds_orgao_regional = tte.co_orgao_regional 
where 
tm.tp_dependencia = 3
and tp_etapa_ensino = 41
and nu_duracao_turma >= 420
group by 1,2,3,4,5,6,7,8