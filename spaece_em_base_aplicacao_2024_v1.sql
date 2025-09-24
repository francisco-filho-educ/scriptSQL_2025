with 
turmas as (
select
	nr_anoletivo,
	ds_turma,
	ci_turma,
	cd_ambiente,
	cd_unidade_trabalho,
	cd_modalidade,
	cd_etapa,
	cd_nivel,
	cd_prefeitura,
	cd_anofinaleja,
case 
	when cd_turno = 4 then 1
	when cd_turno = 1 then 2
	when cd_turno = 2 then 3 
	when cd_turno in (5,8,9,10) then 4 end cd_turno,
case 
	when cd_turno = 4 then 'Manhã'
	when cd_turno = 1 then 'Tarde'
	when cd_turno = 2 then 'Noite'
	when cd_turno in (5,8,9,10) then 'Integral' end ds_turno
from academico.tb_turma tt
where nr_anoletivo = EXTRACT(YEAR from CURRENT_DATE)
	and cd_nivel = 27 --and tt.dt_horainicio 
	and cd_prefeitura= 0 
	and cd_etapa not in (173,174) --retirar turmas semi-presenciais
	and ((tt.cd_etapa=214 or tt.cd_anofinaleja=2) or cd_etapa in (164,190,186)) --and ci_turma =822564
	and tt.fl_ativo = 'S'
)
,extensao as (
select
     tt.ci_turma, 
     tlf.nm_local_funcionamento,
     tlf.ci_local_funcionamento,
     cd_tipo_local,
     1 fl_anexo
     from turmas tt
     join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
     join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
     join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = lut.cd_local_funcionamento 
where 
     lut.fl_sede = false
     group by 1,2,3,4
),
 credes as (
select 
	tut.ci_unidade_trabalho id_crede_sefor, 
	upper(tut.nm_sigla) nm_crede_sefor, 
	upper(tmc.nm_municipio) AS nm_municipio_crede
from rede_fisica.tb_unidade_trabalho tut 
join rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
join rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
join util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
where tut.cd_dependencia_administrativa = 2
	--and tut.cd_situacao_funcionamento = 1
	and tut.ci_unidade_trabalho between 1 and 23
	and tlut.fl_sede = TRUE 
)
,escolas as (
select
	id_crede_sefor, 
	case when id_crede_sefor > 20 then nm_crede_sefor else nm_municipio_crede end nm_regional, 
	tmc.ci_municipio_censo,
	upper(tmc.nm_municipio) AS nm_municipio,
	upper(tc.nm_categoria)  AS ds_categoria,
	tut.ci_unidade_trabalho id_escola_sige,
	tut.nr_codigo_unid_trab id_escola_inep, 
	upper(tut.nm_unidade_trabalho) nm_escola,
	upper(tlz.nm_localizacao_zona) AS ds_localizacao
from rede_fisica.tb_unidade_trabalho tut
join rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
join rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left join rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
join rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
join util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join credes c on tut.cd_unidade_trabalho_pai  = id_crede_sefor
where tut.cd_dependencia_administrativa = 2
	and tut.cd_situacao_funcionamento = 1
	and tut.cd_tipo_unid_trab =401
	and tlut.fl_sede = TRUE 
	and tut.cd_categoria <> 6
	--and tut.categoria not in (13,7) -- escolas regulares
	--and tut.categoria = 7  -- escolas indigenas
	--and tut.cd_categoria = 13-- escolas quilombolas
) --select * from escolas --754
,enturmacao as (
select 
te.cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao  te 
join turmas on ci_turma = cd_turma
where 
te.nr_anoletivo = EXTRACT(YEAR from CURRENT_DATE)
and te.fl_tipo_atividade <> 'AC'
)
--select count(1) from enturmacao
,aluno_deficiencia_i as (
select 
cd_aluno,
case when cd_deficiencia between 9 and 12 or cd_deficiencia = 24 then 'Autismo' else nm_deficiencia end nm_deficiencia 
from academico.tb_aluno_deficiencia tad 
join academico.tb_deficiencia td on td.ci_deficiencia = tad.cd_deficiencia 
join enturmacao using(cd_aluno)
group by 1,2
)
,aluno_deficiencia as (
select 
	cd_aluno,
	true fl_deficiencia,
	string_agg(
		nm_deficiencia, ', ' ) nm_deficiencia
from aluno_deficiencia_i
group by 1,2
)
--select * from aluno_deficiencia
,aluno_recurso as (
select 
	cd_aluno, 
	string_agg(
	case 
    	when ar.cd_recurso_avaliacao = 1 then 'Auxílio ledor'
      	when ar.cd_recurso_avaliacao = 2 then 'Auxílio transcrição'
      	when ar.cd_recurso_avaliacao = 3 then 'Guia-Intérprete'
      	when ar.cd_recurso_avaliacao = 4 then 'Intérprete de Libras'
      	when ar.cd_recurso_avaliacao = 5 then 'Leitura Labial'
      	when ar.cd_recurso_avaliacao = 6 then 'Prova Ampliada (fonte 18)'
      	when ar.cd_recurso_avaliacao = 7 then 'Prova Ampliada (fonte 24)'
      	when ar.cd_recurso_avaliacao = 8 then 'Prova Ampliada (fonte 24)'
      	when ar.cd_recurso_avaliacao = 9 then 'Prova em braile' end, ', ') ds_recurso_avaliacao
from academico.tb_aluno_recurso_espec_aval ar 
group by 1
)
,alunos as (
select 
	cd_turma,
	e.cd_aluno,
	nm_aluno,
	ta2.cd_inep_aluno,
	ta2.dt_nascimento,
	case when fl_sexo = 'M' then 1 else 2 end cd_sexo,
	case when fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo,
	nm_mae,
	nm_pai,
	ta2.cd_raca,
	tr.ds_raca,
	case when fl_deficiencia then 'Sim' else 'Não' end ds_possui_deficiencia,
	nm_deficiencia,
	ds_recurso_avaliacao
from academico.tb_aluno ta2 
join enturmacao e on e.cd_aluno = ci_aluno
left join academico.tb_raca tr on tr.ci_raca = ta2.cd_raca
left join aluno_deficiencia def on def.cd_aluno = ci_aluno 
left join aluno_recurso ar on ar.cd_aluno = ta2.ci_aluno 
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
) --select count(1) nr_linha, count(distinct cd_aluno) from alunos
,relatorio as (
select
	'Ceará' "NM_UF",
	id_crede_sefor as "CD_REGIONAL",
	nm_regional "NM_REGIONAL",
	ci_municipio_censo "CD_MUNICIPIO",
	nm_municipio"NM_MUNICIPIO",
	id_escola_inep "CD_ESCOLA",
	nm_escola "NM_ESCOLA",
	1 "CD_REDE_ENSINO",
	'Estadual' "DC_REDE_ENSINO",
	ds_localizacao as "DC_LOCALIZACAO",
	t.ci_turma "CD_TURMA",
	ds_turma "NM_TURMA",
	case when (t.cd_etapa=214 or t.cd_anofinaleja=2) then 71
	      when cd_etapa in (164,190,186) then 27 end "CD_ETAPA", -- Código do Censo Escolar
	case when (t.cd_etapa=214 or t.cd_anofinaleja=2) then 'EJA - ENSINO MÉDIO'
	     when cd_etapa in (164,190,186) then 'ENSINO MÉDIO - 3ª SÉRIE' end "DC_ETAPA",
	case when (t.cd_etapa=214 or t.cd_anofinaleja=2) then 2
	      when cd_etapa in (164,190,186) then 1 end "CD_TIPO_ENSINO",         
	case when (t.cd_etapa=214 or t.cd_anofinaleja=2) then 'EJA'
	      when cd_etapa in (164,190,186) then 'Regular' end "DC_TIPO_ENSINO",
	ds_turno "DC_TURNO",
	'' "NM_PROFESSOR",
	0 "FL_MULTISSERIADA",
	coalesce(fl_anexo,0) "FL_ANEXO",
	nm_local_funcionamento "NM_ANEXO",
	cd_aluno "CD_INSTITUCIONAL_ALUNO",
	cd_inep_aluno  "CD_INEP_ALUNO",
	nm_aluno "NM_ALUNO",
	to_char(dt_nascimento,'dd/mm/yyyy')  "DT_NASCIMENTO",
	ds_sexo  "DC_SEXO",
	nm_deficiencia "DC_DEFICIENCIA",
	nm_mae "NM_MAE_ALUNO",
	-- variaveis propostas COADE 
	cd_raca as "CD_COR_RACA",
	ds_raca as "DC_COR_RACA",
	nm_pai as "NM_PAI_ALUNO",
	ds_recurso_avaliacao as "DC_RECURSO_AVALIACAO" 
from alunos et
inner join turmas t on et.cd_turma = t.ci_turma
inner join escolas e on e.id_escola_sige = t.cd_unidade_trabalho
left join extensao ex on  t.ci_turma = ex.ci_turma
where 1 = 1
   and not exists (select 1 from extensao ex2 where ex2.ci_turma = t.ci_turma and cd_tipo_local in (3,4) ) -- retira as turmas do sistema prisional
)
select 
*
from relatorio
