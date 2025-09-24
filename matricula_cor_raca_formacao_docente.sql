with doc as (
select 
co_entidade,
count(distinct co_pessoa_fisica) nr_doc_total,
count(distinct case when tp_escolaridade < 4 then co_pessoa_fisica end) nr_doc_medio,
count(distinct case when tp_escolaridade = 4 then co_pessoa_fisica end) nr_doc_superior,
count(distinct case when in_especializacao = 1 or in_mestrado = 1 or in_doutorado = 1 then co_pessoa_fisica end) nr_pos
from censo_esc_d.tb_docente td 
where
nu_ano_censo = 2022
and td.co_municipio = 2301307
and tp_dependencia = 3
group by 1
)

select 
tfm.nr_ano_censo,
nm_crede_sefor,
'Araripe' municipio,
tde.id_escola_inep,
nm_escola,
ds_localizacao,
sum(nr_matriculas) total,
sum(case when cd_cor_raca = 0 then tfm.nr_matriculas else 0 end) nd,
sum(case when cd_cor_raca = 1 then nr_matriculas else 0 end) Branca,
sum(case when cd_cor_raca = 2 then nr_matriculas else 0 end) Preta,
sum(case when cd_cor_raca = 3 then nr_matriculas else 0 end) Parda,
sum(case when cd_cor_raca = 4 then nr_matriculas else 0 end) Amarela,
sum(case when cd_cor_raca = 5 then nr_matriculas else 0 end) Indigena,
nr_doc_total,
nr_doc_medio,
nr_doc_superior,
nr_pos
from dw_censo.tb_ft_matricula_dinamico tfm 
join dw_censo.tb_dm_turma_dinamico tdt on tdt.id_dm_turma = tfm.id_dm_turma 
join dw_censo.tb_dm_escola_dinamico tde on tde.id_dm_escola = tfm.id_dm_escola 
join doc on doc.co_entidade = tde.id_escola_inep 
where 
cd_dependencia = 3
and tde.id_municipio =2301307
group by 1,2,3,4,5,6,14,15,16,17