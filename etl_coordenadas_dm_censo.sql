with sige as (
select 
2022 nr_ano_censo,
tut.nr_codigo_unid_trab id_escola_inep,
case when tlf.nr_latitude>0 then tlf.nr_latitude *(-1) else nr_latitude end nr_latitude,
case when tlf.nr_longitude>0 then tlf.nr_longitude *(-1) else nr_longitude end nr_longitude
FROM dl_sige.rede_fisica_tb_unidade_trabalho tut 
JOIN dl_sige.rede_fisica_tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN dl_sige.rede_fisica_tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
WHERE
tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab in (401,402)
AND tlut.fl_sede = TRUE 
and nr_latitude is not null 
and nr_longitude is not null
)
select 
nr_ano_censo,
id_escola_inep::text,
case when nr_latitude>0 then nr_latitude *(-1) else nr_latitude end nr_latitude,
case when nr_longitude>0 then nr_longitude *(-1) else nr_longitude end nr_longitude
from dw_censo.tb_dm_escola tde
where 
nr_latitude is not null 
and nr_longitude is not null
and nr_ano_censo < 2022
union 
select *  from sige 