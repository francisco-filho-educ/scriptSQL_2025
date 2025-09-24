with busca as (
select 
co_pessoa_fisica,
no_pessoa_fisica,
no_mae,
no_pai,
dt_nascimento,
nu_cpf
from base_identificada.tb_pessoa_final tpc
where 
--tpc.no_pessoa_fisica ilike 'CARLOS O%BANDEIRA%'
-- no_mae ilike 'MARIA OLENILDA AQUINO' 
-- and tpc.dt_nascimento ilike '%1985'
--co_pessoa_fisica = 111011356979
-- tpc.nu_cpf = 32047197821
--group by 2,3,4,5,6
),
mat as (
select 
nu_ano_censo,
co_pessoa_fisica, 
co_entidade,
tp_etapa_ensino,
tp_situacao
from censo_esc_ce.tb_situacao_alinhado tm
where tp_etapa_ensino is not null 
and exists(select 1 from busca b where b.co_pessoa_fisica = tm.co_pessoa_fisica ) --and b.nu_ano_censo = tm.nu_ano_censo)

)
select
mat.co_pessoa_fisica,
no_pessoa_fisica,
no_mae,
dt_nascimento,
nu_cpf,
--concat('O ÚLTIMO REGISTRO FOI EM ',mat.nu_ano_censo, ', NA ESCOLA ',e.nm_escola, ', ONDE CURSOU O ', UPPER(tde.ds_etapa_ensino))
mat.nu_ano_censo,
ds_etapa_ensino,
co_entidade,
nm_escola,
case 
when tp_situacao = 2 then 'Abandono'
when tp_situacao = 3 then 'Falecido'
when tp_situacao = 4 then 'Reprovado'
when tp_situacao = 5 then 'Aprovado'
when tp_situacao = 9 then 'Sem informação de Rendimento ou Abandono' end ds_situacao
from busca b
join  mat on mat.co_pessoa_fisica = b.co_pessoa_fisica 
join dw_censo.tb_dm_etapa tde on tp_etapa_ensino = tde.cd_etapa_ensino 
join dw_censo.tb_dm_escola e on co_entidade = e.id_escola_inep and mat.nu_ano_censo = e.nr_ano_censo 
order by nu_ano_censo 