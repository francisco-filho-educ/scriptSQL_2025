select 
ci_aluno::int,
nm_aluno,
nm_mae,
nm_pai,
dt_nascimento,
cd_inep_aluno
from academico.tb_aluno ata 
where 1 = 1
and  nm_aluno ilike '%MIREL%SANTOS%BARBO%'
and nm_mae ilike '%RAFAELA%SOU_A%SANTOS%'
and exists(
select 
from academico.tb_enturmacao te where te.cd_aluno = ata.ci_aluno and te.nr_anoletivo = 2022
)

