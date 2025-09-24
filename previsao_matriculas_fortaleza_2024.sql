select 
cd_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
nm_categoria,
ds_nivel,
ds_etapa_aluno,
ds_ofertaitem,
ds_turma,
ds_turno,
count(1) qtd
from dw_sige.tb_cubo_aluno_junho_2024 tcaj 
where 
nm_categoria not like 'CEJA'
and cd_nivel in (26,27)
and tcaj.cd_tipo_local not in (3,4) --and id_escola_inep::numeric =23243864
group by  1,2,3,4,5,6,7,8,9,10,11