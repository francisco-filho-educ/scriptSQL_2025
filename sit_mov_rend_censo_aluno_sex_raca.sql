select 
nu_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
tde.id_escola_inep,
nm_escola,
tde.ds_categoria_escola_sige,
id_turma,
et.ds_ano_serie,
et.cd_ano_serie,
coalesce (ds_turno, '--') ds_turno,
co_pessoa_fisica  id_aluno_inep,
case when tp_sexo = 1  then 'Masculino' else 'Feminino' end ds_sexo,
ds_cor_raca,
case when tp_situacao = 5 then 'Aprovado'
     when tp_situacao = 4 then 'Reprovado'
     when tp_situacao = 2 then 'Abandono' end ds_situacao
from censo_esc_ce.tb_situacao_2022 tfs
join dw_censo.tb_dm_escola tde on id_escola_inep = co_entidade and nr_ano_censo = 2022
join dw_censo.tb_dm_municipio tdm using(id_municipio)
join dw_censo.tb_dm_cor_raca on cd_cor_raca = tp_cor_raca 
join dw_censo.tb_dm_etapa et on et.cd_etapa_ensino = tp_etapa_ensino
left join dw_censo.tb_dm_turma tdt using(id_turma)
where nu_ano_censo = 2022
and in_regular = 1
and tp_dependencia = 2
and et.cd_ano_serie between 10 and 12
and tp_situacao in (5,4,2)