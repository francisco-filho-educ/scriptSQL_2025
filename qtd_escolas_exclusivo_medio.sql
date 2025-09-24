with turma as (
select
*
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2021 
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tt.fl_tipo_seriacao = 'RG'
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
), fund as (
  select cd_unidade_trabalho from turma 
  where cd_nivel = 26
),
medio as (
  select cd_unidade_trabalho from turma 
  where cd_nivel = 27
)
 select count(distinct cd_unidade_trabalho ) from turma medio --715
 --select count(distinct cd_unidade_trabalho ) from medio  where not exists (select 1 from fund where medio.cd_unidade_trabalho =  fund.cd_unidade_trabalho) --610

select count(distinct cd_unidade_trabalho ) 
from rede_fisica.tb_unidade_trabalho tut 
join medio on tut.ci_unidade_trabalho =  cd_unidade_trabalho 
where 
tut.cd_categoria = 7 --23
and not exists (select 1 from fund where medio.cd_unidade_trabalho =  fund.cd_unidade_trabalho) --3