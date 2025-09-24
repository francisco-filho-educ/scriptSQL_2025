select 
case 
when tm.nu_idade_referencia between 0 and 5 then '0 a 5'
when tm.nu_idade_referencia between 6 and 10 then '6 a 10'
when tm.nu_idade_referencia between 11 and 14 then '11 a 14'
when tm.nu_idade_referencia between 15 and 17 then '15 a 17'
when tm.nu_idade_referencia >17 then 'Acima de 17'  else 'DD' end faixa_etaria,
--cego
sum(case when tm.co_municipio = 2304400 and tp_sexo = 1 and in_cegueira = 1 then 1 else 0 end ) nr_fortaleza_ceg_m,
sum(case when tm.co_municipio = 2304400 and tp_sexo <> 1 and in_cegueira = 1 then 1 else 0 end ) nr_fortaleza_ceg_f,
--baixa v
sum(case when tm.co_municipio = 2304400 and tp_sexo = 1 and in_baixa_visao = 1 then 1 else 0 end ) nr_fortaleza_bv_m,
sum(case when tm.co_municipio = 2304400 and tp_sexo <> 1 and in_baixa_visao = 1 then 1 else 0 end ) nr_fortaleza_bv_f,
--cego
sum(case when tm.co_municipio = 2312403 and tp_sexo = 1 and in_cegueira = 1  then 1 else 0 end ) nr_sao_ceg_m,
sum(case when tm.co_municipio = 2312403 and tp_sexo <> 1 and in_cegueira = 1  then 1 else 0 end ) nr_sao_ceg_f,
--baixa v
sum(case when tm.co_municipio = 2312403 and tp_sexo = 1 and in_baixa_visao = 1 then 1 else 0 end ) nr_sao_bv_m,
sum(case when tm.co_municipio = 2312403 and tp_sexo <> 1 and in_baixa_visao = 1 then 1 else 0 end ) nr_sao_bv_f,
--cego
sum(case when tm.co_municipio = 2310209 and tp_sexo = 1 and in_cegueira = 1    then 1 else 0 end ) nr_parac_cg_m,
sum(case when tm.co_municipio = 2310209 and tp_sexo <> 1 and in_cegueira = 1    then 1 else 0 end ) nr_parac_cg_f,
--baixa v
sum(case when tm.co_municipio = 2310209 and tp_sexo = 1 and in_baixa_visao = 1   then 1 else 0 end ) nr_parac_bv_m,
sum(case when tm.co_municipio = 2310209 and tp_sexo <> 1 and in_baixa_visao = 1   then 1 else 0 end ) nr_parac_bv_f
from censo_esc_d.tb_matricula tm 
where 
(in_baixa_visao = 1 or in_cegueira = 1)
and tp_dependencia  = 2
and tp_etapa_ensino is not null --and co_municipio = 2310209
group by 1


select 
count(case when tm.co_municipio = 2304400  and td.tp_sexo = 1 then td.co_pessoa_fisica end ) nr_fortaleza_ceg_m,
count(case when tm.co_municipio = 2304400  and td.tp_sexo  <> 1 then td.co_pessoa_fisica end ) nr_fortaleza_ceg_f,
count(case when tm.co_municipio = 2312403  and td.tp_sexo  = 1 then  td.co_pessoa_fisica  end ) nr_sao_ceg_m,
count(case when tm.co_municipio = 2312403  and td.tp_sexo  <> 1 then  td.co_pessoa_fisica  end ) nr_sao_ceg_f,
count(case when tm.co_municipio = 2310209  and td.tp_sexo  = 1 then  td.co_pessoa_fisica  end ) nr_parac_bv_m,
count(case when tm.co_municipio = 2310209  and td.tp_sexo <> 1 then  td.co_pessoa_fisica  end ) nr_parac_bv_f
from censo_esc_d.tb_matricula tm
join censo_esc_d.tb_docente td using(id_turma)
where 
(tm.in_baixa_visao = 1 or tm.in_cegueira = 1)
and tm.tp_dependencia  = 2
and tm.tp_etapa_ensino is not null

select 
tm.co_municipio,
no_entidade,
count(1) qtd,
case when te.in_sala_atendimento_especial = 1 then 'SIM' else 'NÃO' end ds_aee
from censo_esc_d.tb_matricula tm 
join censo_esc_d.tb_escola te using(co_entidade)
where 
(in_baixa_visao = 1 or in_cegueira = 1)
and tm.tp_dependencia  = 2
and tp_etapa_ensino is not null
and tm.co_municipio in (2310209,2312403,2304400)
group by 1,2,4
order by 1


