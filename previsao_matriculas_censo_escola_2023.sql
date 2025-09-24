--BASE CENSO ESCOLAR
with 
credes as( 
select id_crede_sefor, nm_crede_sefor, ds_orgao_regional 
				from dw_censo.tb_dm_escola tde 
				join dw_censo.tb_dm_municipio tdm using(id_municipio)
				where nr_ano_censo = 2022 
				and cd_categoria_escola_sige = 8
				group by 1,2,3
)
select
ano,
id_crede_sefor,
nm_crede_sefor,
substring(no_entidade,1,5) ds_orgao_regional,
no_municipio,
dependencia,
no_entidade1,
tbce.no_turma,
count(1) qtd_aluno
--select distinct no_entidade
from spaece_aplicacao_2023.tb_base_censo_escolar tbce 
left join credes c on c.ds_orgao_regional = substring(no_entidade,1,5)
where no_etapa_ensino ilike 'Ensino fundamental de 9 anos - 9º Ano'
group by 1,2,3,4,5,6,7,8

--BASE SIGE


