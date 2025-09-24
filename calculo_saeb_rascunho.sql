with fator_proficiencia as (
select 
id_serie,
id_aluno,
case when proficiencia_lp_saeb::numeric>200 then 1 else 0 end fl_adequando_lp,
case when proficiencia_mt_saeb::numeric>225 then 1 else 0 end fl_adequando_mt
from saeb.base_vaar_2023 bv 
where co_uf::int = 23
--and ID_DEPENDENCIA_ADM::int = 2
and bv.id_serie::int  = 5
and proficiencia_lp_saeb is not null 
union 
select 
id_serie,
id_aluno,
case when proficiencia_lp_saeb::numeric>275 then 1 else 0 end fl_adequando_lp,
case when proficiencia_mt_saeb::numeric>300 then 1 else 0 end fl_adequando_mt
from saeb.base_vaar_2023 bv 
where co_uf::int = 23
--and ID_DEPENDENCIA_ADM::int = 2
and bv.id_serie::int = 9
and proficiencia_lp_saeb is not null 
union 
select 
id_serie,
id_aluno,
case when proficiencia_lp_saeb::numeric>300 then 1 else 0 end fl_adequando_lp,-- /  sum((proficiencia_lp_saeb::numeric*peso_aluno_lp::numeric)) *100
case when proficiencia_mt_saeb::numeric>350 then 1 else 0 end fl_adequando_mt
from saeb.base_vaar_2023 bv 
where co_uf::int = 23
and ID_DEPENDENCIA_ADM::int = 2
and bv.id_serie::int in (12,13)
and proficiencia_lp_saeb is not null 
)
,peso as (
select 
id_serie,
id_aluno,
PESO_ALUNO_LP::numeric fator_peso_lp,
PESO_ALUNO_MT::numeric fator_peso_mt
from saeb.base_vaar_2023 bv 
where co_uf::int = 23
--and ID_DEPENDENCIA_ADM::int = 2
and proficiencia_lp_saeb is not null 
)
--select count(1) from peso --280491
select
sum(fl_adequando_lp) /sum(fator_peso_lp) perc_adequado_lp,
sum(fl_adequando_mt) /sum(fator_peso_mt) perc_adequado_mt
from fator_proficiencia 
inner join peso using(id_serie,id_aluno)



select 
id_serie, count(1)
from saeb.base_vaar_2023 bv 
where co_uf::int = 23 and proficiencia_lp_saeb is not null 
group by 1 