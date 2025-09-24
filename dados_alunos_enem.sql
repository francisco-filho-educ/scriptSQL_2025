select
cd_aluno,
ds_ofertaitem,
nm_aluno,
ta.dt_nascimento,
ta.nm_mae,
ta.nr_cpf,
ta.cd_municipio
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on tt.ci_turma = cd_turma
join academico.tb_etapa te on te.ci_etapa = cd_etapa
join academico.tb_aluno ta on ta.ci_aluno = tu.cd_aluno 
where 
tu.nr_anoletivo >2011
and cd_prefeitura =0
and tu.fl_tipo_atividade <>'AC'
and cd_nivel = 27
and ta.nr_cpf is not null


