
select 
id_crede_sefor,
nm_crede_sefor,
id_municipio,
nm_municipio,
id_escola_inep,
nm_escola_recente,
ds_dependencia,
ds_localizacao,
max(case when cd_local_turma = 1 then 1 else 0 end)fl_anexo,
sum (nr_matriculas) nr_mat,
ds_endereco,
nu_endereco,
ds_complemento,
no_bairro,
co_cep,
tce.nu_latitude,
tce.nu_longitude
--select sum (nr_matriculas) nr_mat
from dw_censo.tb_cubo_matricula tcm 
left join censo_esc_ce.tb_catalogo_escolas_2021 tce on tce.co_entidade = tcm.id_escola_inep 
where 
nr_ano_censo = 2022
and cd_etapa = 2
and cd_dependencia = 3
group by 
id_crede_sefor,
nm_crede_sefor,
id_municipio,
nm_municipio,
id_escola_inep,
nm_escola_recente,
ds_dependencia,
ds_localizacao,
ds_endereco,
nu_endereco,
ds_complemento,
no_bairro,
co_cep,
nu_latitude,
nu_longitude