with tb_aluno_c as (
select 
ci_aluno, 
cd_etnia_indigena,
nm_social 
from academico.tb_aluno ta 
where ta.nm_social is not null 
)
select 
det.nr_anoletivo,
tde.id_crede_sefor,
tde.nm_crede_sefor,
--MUNICIPIO
tde.nm_municipio,
--INEP
tde.id_escola_inep,
--ESCOLA
nm_escola,
--CATEGORIA
tde.ds_categoria,
--Ano/Série
case when cd_ano_serie = 99 then ds_etapa_sige else ds_ano_serie end ds_ano_serie,
case when fl_multseriado = 1  then 'SIM' else 'NÂO' end mulseriado,
--MODALIDADE
det.ds_etapa_aluno,
--OFERTA
tt.ds_ofertaitem,
--TURMA
det.ds_turma,
--ID INEP
det.id_escola_inep,
--MATRICULA
det.cd_aluno,
--NOME CIVIL
da.nm_aluno,
--NASCIMENTO
to_char(da.dt_nascimento::date,'dd/mm/yyyy') dt_nascimento,
--IDADE
extract(year from age(dt_nascimento::date)) idade,
--SEXO
da.ds_sexo,
--NOME SOCIAL"
nm_social, 
--RAÇA
ds_raca,
--ETNIA INDÍGENA
nm_etnia_indigena,
string_agg(nm_deficiencia, ', ' ) nm_deficiencia
from public.tb_dm_etapa_aluno_2023_03_21 det
join academico.tb_turma tt on tt.ci_turma = id_turma_sige
join public.tb_dm_aluno_pessoa_2023_03_21 da using(cd_aluno) 
join public.tb_dm_escola tde using(id_escola_sige)
left join academico.tb_aluno_deficiencia tad on tad.cd_aluno = det.cd_aluno
left join academico.tb_deficiencia dee on dee.ci_deficiencia = cd_deficiencia
left join tb_aluno_c c on c.ci_aluno = da.cd_aluno
left join academico.tb_etnia_indigena tei on tei.ci_etnia_indigena = da.cd_etnia_indigena 
where 
tde.cd_categoria = 7
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21 --8208
union 
select 
det.nr_anoletivo,
tde.id_crede_sefor,
tde.nm_crede_sefor,
--MUNICIPIO
tde.nm_municipio,
--INEP
tde.id_escola_inep,
--ESCOLA
nm_escola,
--CATEGORIA
tde.ds_categoria,
--Ano/Série
'AEE' ds_ano_serie,
'NÂO' mulseriado,
--MODALIDADE
ds_etapa,
--OFERTA
tt.ds_ofertaitem,
--TURMA
det.ds_turma,
--ID INEP
tde.id_escola_inep,
--MATRICULA
det.cd_aluno,
--NOME CIVIL
da.nm_aluno,
--NASCIMENTO
to_char(da.dt_nascimento::date,'dd/mm/yyyy') dt_nascimento,
--IDADE
extract(year from age(dt_nascimento::date)) idade,
--SEXO
da.ds_sexo,
--NOME SOCIAL"
nm_social, 
--RAÇA
ds_raca,
--ETNIA INDÍGENA
nm_etnia_indigena,
string_agg(nm_deficiencia, ', ' ) nm_deficiencia
from public.tb_dm_turmas_sem_escolarizacao_2023_03_21_old det
join academico.tb_turma tt on tt.ci_turma = cd_turma
join public.tb_dm_aluno_pessoa_2023_03_21 da using(cd_aluno) 
join public.tb_dm_escola tde on tde.id_escola_sige = tt.cd_unidade_trabalho 
left join academico.tb_aluno_deficiencia tad on tad.cd_aluno = det.cd_aluno
left join academico.tb_deficiencia dee on dee.ci_deficiencia = cd_deficiencia
left join tb_aluno_c c on c.ci_aluno = da.cd_aluno
left join academico.tb_etnia_indigena tei on tei.ci_etnia_indigena = da.cd_etnia_indigena 
where 
tde.cd_categoria = 7
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21 --8208