with mat as (
select
tt.nr_anoletivo,
cd_aluno,
ds_turma,
ci_turma cd_turma,
cd_unidade_trabalho,
ds_ofertaitem,
row_number() OVER () as id_aluno
from academico.tb_turma tt 
join academico.tb_ultimaenturmacao tu on tu.cd_turma = ci_turma and tu.nr_anoletivo = 2023 --and cd_aluno = 4890038
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = cd_unidade_trabalho and tut.cd_unidade_trabalho_pai = 12
where
tt.nr_anoletivo = 2023
and tt.fl_tipo_seriacao = 'RG' and tt.cd_tpensino = 1 
and tt.fl_ativo = 'S'
--and tt.cd_modalidade <> 38
and cd_etapa in(163,185,189)
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27 
and tu.fl_tipo_atividade <> 'AC'
--and ci_turma = 888226
--and tt.cd_unidade_trabalho = 593
) 
,max_respostas as (
select 
cd_aluno, 
cd_turma,
max(tr.cd_turma_aplicacao_liberada)  cd_turma_aplicacao_liberada
from diretordeturma.tb_respostaaplicaorubrica_aluno tr
join mat using(cd_turma,cd_aluno)
group by 1,2
)
,respostas as (
select
id_aluno,
cd_turma,
ds_turma,
cd_unidade_trabalho,
ds_ofertaitem,
cd_aplicacao,
cd_rubrica,
cd_degrau
from diretordeturma.tb_respostaaplicaorubrica_aluno tra 
join max_respostas using(cd_turma_aplicacao_liberada,cd_aluno,cd_turma)
join mat  using(cd_aluno,cd_turma) 
group by 1,2,3,4,5,6,7,8
)
,relatorio as (
select
nr_anoletivo,
crede.ci_unidade_trabalho, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
ds_ofertaitem,
ds_turma,
nm_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
id_aluno,
nm_rubrica,
tm.nm_macrocomoetencia,
nm_degrau,
nr_valor_degrau
from diretordeturma.tb_aplicacao ta 
join diretordeturma.tb_aplicacao_rubricas tar on tar.cd_aplicacao = ta.ci_aplicacao 
join diretordeturma.tb_rubricas tr on tr.ci_rubricas = cd_rubrica 
join respostas tra on tra.cd_aplicacao = ta.ci_aplicacao and tra.cd_rubrica = ci_rubricas
join diretordeturma.tb_degrausrubricas td on td.ci_degrausrubricas = tra.cd_degrau 
join diretordeturma.tb_macrocompetencia tm on tm.ci_macrocompetencia = tr.cd_macrocompetencia 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = cd_unidade_trabalho
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
left JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
left JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
left join rede_fisica.tb_tipo_unid_trab ttut on ttut.ci_tipo_unid_trab = tut.cd_tipo_unid_trab  
where
--p_faltas>0.2
tlut.fl_sede = TRUE 
and tut.cd_dependencia_administrativa = 2
and tut.cd_unidade_trabalho_pai = 12
and tut.cd_tipo_unid_trab = 401
) select * from relatorio