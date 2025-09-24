with alunos as (
select 
--Crede/Sefor
nm_crede_sefor,
-- município
nm_municipio,
-- escola
id_escola_inep,
nm_escola,
-- oferta
ds_ofertaitem,
-- turma
ds_turma,
-- nome do aluno
case when cd_aluno_excluido is null then tcaj.cd_aluno else taam.cd_aluno end cd_aluno,
nm_aluno,
-- data de nascimento
dt_nascimento,
-- sexo
ds_sexo,
-- cor/raça
ds_raca 
from dw_sige.tb_cubo_aluno_junho_2024 tcaj 
left join academico.tb_auditoria_aluno_mesclar taam on taam.cd_aluno_excluido = tcaj.cd_aluno 
where tcaj.fl_possui_deficiencia = 1
)
,aluno_deficiencia_i as (
select 
cd_aluno,
case when cd_deficiencia between 9 and 12 or cd_deficiencia = 24 then 'Autismo' else nm_deficiencia end nm_deficiencia 
from academico.tb_aluno_deficiencia tad 
join academico.tb_deficiencia td on td.ci_deficiencia = tad.cd_deficiencia 
join alunos using(cd_aluno)
group by 1,2
)
,aluno_deficiencia as (
select 
	cd_aluno,
	string_agg(
		nm_deficiencia, ', ' ) nm_deficiencia
from aluno_deficiencia_i
group by 1
)
,aee as (
select 
tu.cd_aluno,ds_nivel,ds_etapa
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on tt.ci_turma = tu.cd_turma and tt.nr_anoletivo = 2024
join academico.tb_etapa te on te.ci_etapa = tt.cd_etapa 
join academico.tb_nivel tn on tn.ci_nivel = tt.cd_nivel 
where 
tu.nr_anoletivo = 2024
and tt.cd_prefeitura  = 0
and cd_nivel >28
) 
select 
a.*,
nm_deficiencia,
ds_nivel,
ds_etapa
from alunos a 
join aluno_deficiencia ad using(cd_aluno)
left join aee using(cd_aluno)
