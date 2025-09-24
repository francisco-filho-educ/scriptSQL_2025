select 
tut.cd_unidade_trabalho_pai id_crede_sefor, 
tutpai.nm_sigla nm_crede_sefor, 
tut.nr_codigo_unid_trab::int id_cci, 
tut.nm_unidade_trabalho nm_cci,
tl.ci_municipio_censo::int id_municipio,
UPPER(tl.nm_municipio) nm_municipio,
ccite.nr_anoletivo, 
ccite.nr_semestre
--, ccite.ci_enturmacao
, ccitmod.cd_idioma, 
ccii.ds_idioma, 
ccite.cd_modulo,
ccitmod.ds_modulo, 
ccite.cd_turma, 
ccitt.ds_turma, 
ccitt.cd_semana , 
ccitt.hr_inicio, 
ccitt.hr_fim,
--, ccitt.cd_ambiente
ccitm.ci_matricula::int,  
ccitm.cd_tipo_aluno, 
ccitta.nm_tipo_aluno, 
ccitm.cd_aluno::int, 
ccitm.nr_cpf_professor,
ta.nm_aluno
--, ccitm.cd_aluno_cci::int
--, ccite.fl_ultima_enturmacao
from sigecci.tb_enturmacao ccite 
join sigecci.tb_matricula ccitm on  ccite.cd_matricula = ccitm.ci_matricula
JOIN sigecci.tb_turma ccitt ON ccite.cd_turma=ccitt.ci_turma
JOIN sigecci.tb_modulo ccitmod ON ccite.cd_modulo = ccitmod.ci_modulo 
JOIN sigecci.tb_idioma ccii ON ccitmod.cd_idioma = ccii.ci_idioma
JOIN sigecci.tb_tipo_aluno ccitta ON ccitm.cd_tipo_aluno= ccitta.ci_tipo_aluno
join rede_fisica.tb_unidade_trabalho tut on ccite.cd_cci_indicado = tut.ci_unidade_trabalho
join rede_fisica.tb_unidade_trabalho tutpai on tut.cd_unidade_trabalho_pai = tutpai.ci_unidade_trabalho 
join rede_fisica.tb_local_unid_trab tlu on tlu.cd_unidade_trabalho  = tut.ci_unidade_trabalho 
join rede_fisica.tb_local_funcionamento tlf on tlu.cd_local_funcionamento  = tlf.ci_local_funcionamento 
join util.tb_municipio_censo tl on tlf.cd_municipio_censo = tl.ci_municipio_censo
left join academico.tb_aluno ta ON ccitm.cd_aluno = ta.ci_aluno
where 
ccite.nr_anoletivo = 2023  and 
ccite.fl_ultima_enturmacao = true and tut.cd_tipo_unid_trab = 402 AND ccitm.cd_tipo_aluno=1
-- and ccite.nr_semestre = 1  and tut.cd_tipo_unid_trab = 402 and 
--group by 1,2,3,4,5,6
UNION
select 
tut.cd_unidade_trabalho_pai id_crede_sefor, 
tutpai.nm_sigla nm_crede_sefor, 
tut.nr_codigo_unid_trab::int id_cci, 
tut.nm_unidade_trabalho nm_cci, 
tl.ci_municipio_censo::int id_municipio, 
UPPER(tl.nm_municipio) nm_municipio, 
ccite.nr_anoletivo, ccite.nr_semestre,
--, ccite.ci_enturmacao
ccitmod.cd_idioma,
ccii.ds_idioma, 
ccite.cd_modulo, 
ccitmod.ds_modulo, 
ccite.cd_turma, 
ccitt.ds_turma,  
ccitt.cd_semana , 
ccitt.hr_inicio, 
ccitt.hr_fim,
--, ccitt.cd_ambiente
ccitm.ci_matricula::int,  
ccitm.cd_tipo_aluno,
ccitta.nm_tipo_aluno, 
ccitm.cd_aluno::int, 
ccitm.nr_cpf_professor,
tc30d.c6 AS nm_aluno
--, ta.nm_aluno
--, ccitm.cd_aluno_cci::int
--, ccite.fl_ultima_enturmacao
from sigecci.tb_enturmacao ccite 
join sigecci.tb_matricula ccitm on  ccite.cd_matricula = ccitm.ci_matricula
JOIN sigecci.tb_turma ccitt ON ccite.cd_turma=ccitt.ci_turma
JOIN sigecci.tb_modulo ccitmod ON ccite.cd_modulo = ccitmod.ci_modulo 
JOIN sigecci.tb_idioma ccii ON ccitmod.cd_idioma = ccii.ci_idioma
JOIN sigecci.tb_tipo_aluno ccitta ON ccitm.cd_tipo_aluno= ccitta.ci_tipo_aluno
join rede_fisica.tb_unidade_trabalho tut on ccite.cd_cci_indicado = tut.ci_unidade_trabalho
join rede_fisica.tb_unidade_trabalho tutpai on tut.cd_unidade_trabalho_pai = tutpai.ci_unidade_trabalho 
join rede_fisica.tb_local_unid_trab tlu on tlu.cd_unidade_trabalho  = tut.ci_unidade_trabalho 
join rede_fisica.tb_local_funcionamento tlf on tlu.cd_local_funcionamento  = tlf.ci_local_funcionamento 
join util.tb_municipio_censo tl on tlf.cd_municipio_censo = tl.ci_municipio_censo
left join educacenso.tb_censo_30_docente tc30d ON ccitm.nr_cpf_professor = tc30d.c5
--academico.tb_aluno ta ON ccitm.cd_aluno = ta.ci_aluno
where 
ccite.nr_anoletivo = 2023  and 
ccite.fl_ultima_enturmacao = true and tut.cd_tipo_unid_trab = 402 AND ccitm.cd_tipo_aluno=2
-- and ccite.nr_semestre = 1
--group by 1,2,3,4,5,6
order by 1,3,5