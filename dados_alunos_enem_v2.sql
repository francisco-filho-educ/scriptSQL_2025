select
tt.nr_anoletivo,
m_e.ds_localidade municipio_e,
tut.nr_codigo_unid_trab,
nm_unidade_trabalho,
cd_aluno,
ds_ofertaitem,
nm_aluno,
to_char(ta.dt_nascimento,'dd/mm/yyyy') dt_nascimento,
ta.nm_mae,
ta.nr_cpf
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on tt.ci_turma = cd_turma
join academico.tb_etapa te on te.ci_etapa = cd_etapa
join academico.tb_aluno ta on ta.ci_aluno = tu.cd_aluno 
join util.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
join util.tb_localidades m_e on tut.cd_municipio = m_e.ci_localidade 
join util.tb_localidades m_a on ta.cd_municipio = m_a.ci_localidade 
where 
tu.nr_anoletivo = 2020
and cd_prefeitura =0
and tu.fl_tipo_atividade <>'AC'
and cd_nivel = 27
and ta.nr_cpf is not null


