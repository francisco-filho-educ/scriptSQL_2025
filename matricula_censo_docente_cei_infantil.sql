with escola_mat as (
select 
nm_municipio,
e.id_escola_inep, 
nm_escola, 
ds_dependencia, 
sum(m.nr_matriculas) nr_mat
from dw_censo.tb_ft_matricula m
join dw_censo.tb_dm_turma t using(id_dm_turma)
join dw_censo.tb_dm_escola e using(id_dm_escola)
join dw_censo.tb_dm_municipio tdm using(id_municipio)
where m.nr_ano_censo = 2020
and t.cd_etapa = 1
and (e.nm_escola ilike '%CEI %' or e.nm_escola ilike 'Centro%Educa%Infantil' or e.nm_escola ilike '%CEI-%' )
and e.cd_dependencia in (2,3)
group by 1,2,3,4
)
select 
1 ord, 
nu_ano_censo,
nm_municipio,
id_escola_inep, 
nm_escola, 
ds_dependencia, 
nr_mat,
count(distinct td.co_pessoa_fisica) nr_doc
from censo_esc_ce.tb_docente_2020 td 
join escola_mat on id_escola_inep = co_entidade
where nu_ano_censo = 2020
and tp_etapa_ensino in (1,2)
and td.tp_dependencia in (2,3)
and td.tp_tipo_docente = 1
group by 1,2,3,4,5,6,7
union 
select 
0 ord, 
nu_ano_censo,
'TOTAL' nm_municipio,
0 id_escola_inep, 
'TOTAL' nm_escola, 
ds_dependencia, 
sum(nr_mat) nr_mat,
count(distinct td.co_pessoa_fisica) nr_doc
from censo_esc_ce.tb_docente_2020 td 
join escola_mat on id_escola_inep = co_entidade
where nu_ano_censo = 2020
--and tp_etapa_ensino in (1,2)
and td.tp_dependencia in (2,3)
and td.tp_tipo_docente = 1
group by 1,2,3,4,5,6
order by ord, nm_municipio, nm_escola

