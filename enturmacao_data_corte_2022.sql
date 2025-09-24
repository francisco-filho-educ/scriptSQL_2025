with enturmacao as (
select  
cd_aluno,cd_turma
from sige_2022.academico_tb_enturmacao ate group by 1,2
)
select 
tut.cd_unidade_trabalho_pai cod_crede,
tut.nr_codigo_unid_trab cd_escola_inep,
tut.nm_unidade_trabalho nm_escola,
cd_turma,
ds_turma,
cd_etapa,
ds_etapa,
ci_aluno cd_aluno_sige,
ata.cd_inep_aluno,
case when fl_sexo = 'M' then 1 else 2 end cd_sexo,
case when fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo,
coalesce(cd_raca,6) cd_raca,
coalesce(ds_raca, 'Não Declarada') ds_raca,
ata.dt_nascimento,
extract(year from age('2022-05-25 00:00:00'::timestamp,dt_nascimento)) idade
from dl_sige.academico_tb_aluno ata 
--join dw_sige.tb_enturmacao_data_corte dc on ci_aluno =dc.cd_aluno
join enturmacao dc on ci_aluno =dc.cd_aluno
join sige_2022.academico_tb_turma tt on tt.ci_turma = dc.cd_turma 
left join dl_sige.tb_raca tr on ci_raca = cd_raca
join dl_sige.academico_tb_etapa ate on ate.ci_etapa = tt.cd_etapa 
join dl_sige.rede_fisica_tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
where 
tt.cd_prefeitura = 0
and cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191)
and tt.cd_nivel = 27
