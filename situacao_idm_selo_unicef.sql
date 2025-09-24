with 
municipios as (
select * from public.municipio_idh mi 
)
/*
municipios as (
select 
id_municipio, nm_municipio 
from dw_censo.tb_dm_municipio tdm 
where 
tdm.sg_uf = 'CE' and (
nm_municipio 	ilike	'Acarape'	or 
nm_municipio 	ilike	'Canindé'	or 
nm_municipio 	ilike	'Ibaretama'	or 
nm_municipio 	ilike	'Madalena'	or 
nm_municipio 	ilike	'Morada Nova'	or 
nm_municipio 	ilike	'Mulungu'	or 
nm_municipio 	ilike	'Paramoti'	or 
nm_municipio 	ilike	'Santana do Cariri'	or 
nm_municipio 	ilike	'São Luís do Curu'	or 
nm_municipio 	ilike	'Uruburetama'	or 
nm_municipio 	ilike	'Baturité'	or 
nm_municipio 	ilike	'Aiuaba'	or 
nm_municipio 	ilike	'Fortim'	or 
nm_municipio 	ilike	'Frecheirinha'	or 
nm_municipio 	ilike	'General Sampaio'	or 
nm_municipio 	ilike	'Ipaumirim'	or 
nm_municipio 	ilike	'Jijoca de Jericoacoara'	or 
nm_municipio 	ilike	'Moraújo'	or 
nm_municipio 	ilike	'Penaforte'	or 
nm_municipio 	ilike	'Santana do Acaraú'	or 
nm_municipio 	ilike	'Acaraú'	or 
nm_municipio 	ilike	'Boa Viagem'	or 
nm_municipio 	ilike	'Brejo Santo'	or 
nm_municipio 	ilike	'Cascavel'	or 
nm_municipio 	ilike	'Itarema'	or 
nm_municipio 	ilike	'Pacajus'	or 
nm_municipio 	ilike	'Pedra Branca'	or 
nm_municipio 	ilike	'Pentecoste'	or 
nm_municipio 	ilike	'Tamboril'	or 
nm_municipio 	ilike	'Tianguá'	or 
nm_municipio 	ilike	'Ubajara'	
)
)
*/

,sit as (
select 
ts.nu_ano_censo,
ts.co_municipio,
ts.co_entidade,
-- total
count(1) nr_mat_total,
sum(case when tp_situacao = 5 then 1 else 0 end)::numeric  nr_aprovados_t,	
sum(case when tp_situacao = 4 then 1 else 0 end)::numeric  nr_reprovados_t,	
sum(case when tp_situacao = 2 then 1 else 0 end)::numeric  nr_abandono_t,
-- 1 amo
sum(case when tde.cd_ano_serie = 10 then 1 else 0 end) nr_mat_1,
sum(case when tde.cd_ano_serie = 10  and tp_situacao = 5 then 1 else 0 end)::numeric  nr_aprovados_1,	
sum(case when tde.cd_ano_serie = 10  and tp_situacao = 4 then 1 else 0 end)::numeric  nr_reprovados_1,	
sum(case when tde.cd_ano_serie = 10  and tp_situacao = 2 then 1 else 0 end)::numeric  nr_abandono_1,
-- 2 amo
sum(case when tde.cd_ano_serie = 11 then 1 else 0 end) nr_mat_2,
sum(case when tde.cd_ano_serie = 11 and  tp_situacao = 5 then 1 else 0 end)::numeric  nr_aprovados_2,	
sum(case when tde.cd_ano_serie = 11 and  tp_situacao = 4 then 1 else 0 end)::numeric  nr_reprovados_2,	
sum(case when tde.cd_ano_serie = 11 and tp_situacao = 2 then 1 else 0 end)::numeric  nr_abandono_2,
-- 3 amo
sum(case when tde.cd_ano_serie = 12 then 1 else 0 end) nr_mat_3,
sum(case when tde.cd_ano_serie = 12 and tp_situacao = 5 then 1 else 0 end)::numeric  nr_aprovados_3,	
sum(case when tde.cd_ano_serie = 12 and tp_situacao = 4 then 1 else 0 end)::numeric  nr_reprovados_3,	
sum(case when tde.cd_ano_serie = 12 and tp_situacao = 2 then 1 else 0 end)::numeric  nr_abandono_3
from censo_esc_ce.tb_situacao_2019 ts 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = ts.tp_etapa_ensino 
where 
ts.tp_dependencia = 2
and tde.cd_ano_serie between 10 and 12
and tp_situacao in (2,5,4)
--and ts.co_municipio = 2302107
group by 1,2,3
) 
select
--tde.id_escola_inep,
--tde.id_municipio,
--Ano
nu_ano_censo,
--Município
nm_municipio,
--Escola
nm_escola,
--Localização
ds_localizacao,
--Tx. total
round(case when  nr_mat_total <1 then 0.0 else nr_abandono_t::numeric/nr_mat_total::numeric*100 end ,2) tx_aba,
--1º Ano
round(case when  nr_mat_1 <1 then 0.0 else nr_abandono_1::numeric/nr_mat_1::numeric*10 end ,2) tx_aba_1,
--2º Ano
round(case when  nr_mat_2 <1 then 0.0 else nr_abandono_2::numeric/nr_mat_2::numeric*10 end ,2) tx_aba_2,
--3º Ano
round(case when  nr_mat_3 <1 then 0.0 else nr_abandono_3::numeric/nr_mat_3::numeric*10 end ,2) tx_aba_1,
--CRED
id_crede_sefor,
"IDM"::TEXT,
"IDHM"::TEXT,
COR
--count( distinct tdm.id_municipio)
from dw_sige.tb_dm_escola tde 
join municipios tdm USING(id_municipio) 
left join sit on tde.id_escola_inep = co_entidade::text






