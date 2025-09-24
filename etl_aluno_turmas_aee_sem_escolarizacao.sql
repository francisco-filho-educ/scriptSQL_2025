create table public.tb_dm_turmas_sem_escolarizacao_2023_03_21 as (
select  
tt.nr_anoletivo,
cd_turma,
tt.nr_anoletivo,
tt.ds_turma,
tt.ds_ofertaitem,
tt.cd_etapa,
ds_etapa,
tt.cd_nivel,
ds_nivel,
tt.cd_modalidade,
ds_modalidade,
cd_aluno
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on tt.ci_turma = tu.cd_turma  
join academico.tb_nivel tn on tn.ci_nivel = cd_nivel
join academico.tb_modalidade tm on tm.ci_modalidade = tt.cd_modalidade 
join academico.tb_etapa te on te.ci_etapa = tt.cd_etapa 
and tt.cd_nivel not in (26,27,28)
and tt.nr_anoletivo = 2023
and tt.cd_prefeitura = 0
and exists (select 1 from  public.tb_dm_etapa_aluno_2023_03_21 et where et.cd_aluno = tu.cd_aluno)
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
            and tut.cd_dependencia_administrativa = 2
            --and tut.cd_unidade_trabalho_pai = 1 -- crede
            )
            
            )