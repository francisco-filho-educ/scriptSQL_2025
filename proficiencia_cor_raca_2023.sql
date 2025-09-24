select 
ds_categoria_escola_sige nm_categoria,
ds_localizacao ,
tdap.ds_raca,
tdap.ds_sexo,
tslme.nm_disciplina,
s.dc_padrao_desempenho,
count(1) qtd_alunos
from spaece.tb_spaece_2023_lp_mt_em s --202096
inner join dw_sige.tb_dm_aluno_pessoa_2023_06_01 tdap on tdap.cd_aluno::text = s.cd_aluno 
inner join dw_censo.tb_dm_escola tde on tde.id_escola_inep =  s.cd_escola 
where 
cd_etapa_aplicacao = 27
and fl_avaliado = 1
and tde.nr_ano_censo = 2023
group by 1,2,3,4,5,6

--178234