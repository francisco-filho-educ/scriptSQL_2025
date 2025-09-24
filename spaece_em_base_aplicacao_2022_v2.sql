with 
turmas as (
select *, 
case when cd_turno = 4 then 1
when cd_turno = 1 then 2
when cd_turno = 2 then 3
when cd_turno = 5 then 4 end cd_turno_c
from academico.tb_turma tt
join (select ci_turno, ds_turno from academico.tb_turno) as tn on tn.ci_turno = tt.cd_turno 
where nr_anoletivo = 2022
and cd_nivel = 27 --and tt.dt_horainicio 
and cd_prefeitura= 0 
and cd_etapa not in (173,174) --retirar turmas semi-presenciais
and ((tt.cd_etapa=214 or tt.cd_anofinaleja=2) or cd_etapa in (164,190,186)) --and ci_turma =822564
) --select cd_etapa, count(1) from turmas group by 1
,extensao as (
select
     tt.ci_turma, 
     tlf.nm_local_funcionamento,
     tlf.ci_local_funcionamento
     from turmas tt
     join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
     join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
     join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = lut.cd_local_funcionamento 
     where tt.nr_anoletivo = 2022
     and lut.fl_sede = false
     and cd_nivel =27
     and tt.cd_prefeitura = 0
     and tlf.cd_tipo_local <> 4 -- retira os anexo em sistemas prisionais
     group by 1,2,3
),
regiao as (
select 
ut.ci_unidade_trabalho,
tac.cod_crede_censo
from util.tb_unidade_trabalho ut 
join educacenso_exp.tb_associativa_crede tac on tac.cod_crede_seduc  = ut.cd_unidade_trabalho_pai
where ut.cd_unidade_trabalho_pai <21 and ut.cd_dependencia_administrativa =2
union 
select 
ut.ci_unidade_trabalho,
tac.cod_crede_censo
from util.tb_unidade_trabalho ut
join educacenso_exp.tb_associativa_crede tac on tac.cd_regiao  = ut.cd_regiao 
where ut.cd_unidade_trabalho_pai >20  
and ut.cd_dependencia_administrativa =2
and ut.cd_regiao is not null
),
escolas as (
SELECT
crede.ci_unidade_trabalho id_crede_sefor, 
cod_crede_censo,
upper(crede.nm_sigla) nm_crede_sefor, 
tmc.ci_municipio_censo,
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria)  AS ds_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao
FROM rede_fisica.tb_unidade_trabalho tut
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join regiao r on r.ci_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = TRUE 
and tut.cd_categoria <> 6
--and tut.categoria not in (13,7) -- escolas regulares
--and tut.categoria = 7  -- escolas indigenas
--and tut.cd_categoria = 13-- escolas quilombolas
) --select * from escolas --754
,enturmacao as (
select 
cd_aluno,cd_turma
from academico.tb_ultimaenturmacao tu 
where exists (select 1 from turmas t where ci_turma = cd_turma)
and tu.fl_tipo_atividade <> 'AC'
)
,alunos as (
select 
ci_aluno,
nm_aluno,
ta2.cd_inep_aluno,
ta2.dt_nascimento,
case when fl_sexo = 'M' then 1 else 2 end cd_sexo,
case when fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo,
nm_mae,
nm_pai,
ta2.cd_raca,
tr.ds_raca,
case when def.cd_deficiencia is null then 'Não' else 'Sim' end ds_possui_deficiencia,
string_agg(d.nm_deficiencia ,', ' ) nm_deficiencia ,
--ar.cd_recurso_avaliacao,
string_agg(
case 
    when ar.cd_recurso_avaliacao = 1 then 'Auxílio ledor'
	when ar.cd_recurso_avaliacao = 2 then 'Auxílio transcrição'
	when ar.cd_recurso_avaliacao = 3 then 'Guia-Intérprete'
	when ar.cd_recurso_avaliacao = 4 then 'Intérprete de Libras'
	when ar.cd_recurso_avaliacao = 5 then 'Leitura Labial'
	when ar.cd_recurso_avaliacao = 6 then 'Prova Ampliada (fonte 16)'
	when ar.cd_recurso_avaliacao = 7 then 'Prova Ampliada (fonte 20)'
	when ar.cd_recurso_avaliacao = 8 then 'Prova Ampliada (fonte 24)'
	when ar.cd_recurso_avaliacao = 9 then 'Prova em braile' end, ', ') ds_recurso_avaliacao
from academico.tb_aluno ta2 
left join academico.tb_raca tr on tr.ci_raca = ta2.cd_raca
left join academico.tb_aluno_deficiencia def on def.cd_aluno = ci_aluno 
left join academico.tb_deficiencia d on def.cd_deficiencia = ci_deficiencia
left join academico.tb_aluno_recurso_espec_aval ar on ar.cd_aluno = ta2.ci_aluno 
where exists (select 1 from enturmacao e where ci_aluno = e.cd_aluno ) --and cd_deficiencia is not null
group by 1,2,3,4,5,6,7,8,9,10,11
) --select count(1) nr_linha, count(distinct ci_aluno) from alunos
select  --count(1) nr_linha, count(distinct ci_aluno) /*
cod_crede_censo as "ORGAO_REGIONAL",
id_crede_sefor as "ID_CREDE_SEFOR",
nm_crede_sefor as "NM_CREDE_SEFOR",
nm_municipio as "NM_MUNICIPIO",
ci_municipio_censo as "ID_MUNICIPIO",
'ESTADUAL' as "DS_DEPENDENCIA",
ds_localizacao as "DS_LOCALIZACAO",
id_escola_inep as "ID_ESCOLA",
nm_escola as "NM_ESCOLA",
ds_categoria "CATEGORIA",
t.ci_turma as "ID_TURMA",
ds_turma "NM_TURMA",
substring(t.dt_horainicio::text,11) as "TX_HR_INICIAL",
substring(t.dt_horafim::text,11) as "TX_HR_FINAL",
t.cd_turno_c as "CD_TURNO",
ds_turno as "NM_TURNO",   
case when (t.cd_etapa=214 or t.cd_anofinaleja=2) then 'EJA Ensino Médio ano II'
      when cd_etapa in (164,190) then 'Ensino Medio 3ª Série'
      when cd_etapa = 186 then 'Ensino Médio - Integrado 3ª Serie' end "DS_ETAPA_SERIE",  
case when (t.cd_etapa=214 or t.cd_anofinaleja=2) then 72 
      when cd_etapa in (164,190) then 27
      when cd_etapa = 186 then 32 end "TP_ETAPA_ENSINO",  
case when cd_modalidade in (36,40) then 1
      when cd_modalidade = 37 then 2
      when cd_modalidade = 38 then  3 end "TP_MODALIDADE",
case when cd_modalidade in (36,40) then 'Regular'
      when cd_modalidade = 37 then 'Especial'
      when cd_modalidade = 38 then 'EJA' end "DS_MODALIDADE",
cd_inep_aluno as "CO_PESSOA_FISICA",
ci_aluno as "CD_ALUNO_SIGE",
---as 'NR_CPF',
nm_aluno as "NM_ALUNO",
dt_nascimento as "DT_NASCIMENTO",
cd_sexo as "CD_SEXO",
ds_sexo as "DS_SEXO",
cd_raca as "CD_COR_RACA",
ds_raca as "DS_COR_RACA",
nm_mae as "NM_MAE",
nm_pai as "NM_PAI",
ds_possui_deficiencia as "DS_POSSUI_DEFICIENCIA",
nm_deficiencia as "NM_DEFICIENCIA",
ds_recurso_avaliacao as "DS_RECURSO_AVALIACAO",
nm_local_funcionamento as "NM_EXTENSAO"
--select count(1) --107291
from enturmacao et
inner join turmas t on et.cd_turma = t.ci_turma
inner join alunos a on a.ci_aluno = et.cd_aluno
inner join escolas e on e.id_escola_sige = t.cd_unidade_trabalho
left join extensao ex on  t.ci_turma = ex.ci_turma