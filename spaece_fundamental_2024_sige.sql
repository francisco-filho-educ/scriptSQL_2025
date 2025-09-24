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
	and cd_nivel = 26
	and tt.fl_ativo = 'S'
)
,max_enturmacao as (
select 
cd_aluno,
max(tu.ci_enturmacao) ci_enturmacao
from academico.tb_ultimaenturmacao tu 
where 
nr_anoletivo =  EXTRACT(YEAR from CURRENT_DATE)
and tu.fl_tipo_atividade <> 'AC'
group by 1
)
,enturmacao_i as (
select 
tu.cd_aluno,
cd_turma,
cd_etapa
from academico.tb_ultimaenturmacao tu 
join (select ci_turma, cd_etapa from turmas) as t on  ci_turma = cd_turma
join max_enturmacao using (ci_enturmacao)
where  tu.fl_tipo_atividade <> 'AC'
)
--select count(1) from enturmacao_i --24318
,mult  as(
select
tm.cd_turma,
tm.cd_aluno,
ti.cd_etapa,
1 fl_mult
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
join enturmacao_i ut using(cd_turma,cd_aluno)
where 
tm.nr_anoletivo =  EXTRACT(YEAR from CURRENT_DATE)
)
--select count(1) from mult
,enturmacao as (
select 
cd_aluno,
cd_turma,
cd_etapa,
0 fl_mult
from enturmacao_i eti 
where eti.cd_turma not in (select distinct cd_turma from mult)
union  
select 
cd_aluno,
cd_turma,
cd_etapa,
fl_mult
from mult 
) 
--select * from enturmacao
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
--select *  from aluno_recurso
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
--select * from alunos 

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
)
,distritos as (
SELECT  CASE
            WHEN ut.cd_unidade_trabalho_pai >= 21 THEN ( SELECT tac.cod_crede_censo
               FROM educacenso_exp.tb_associativa_crede tac
              WHERE tac.cod_crede_seduc = 21 AND tac.cd_regiao = ut.cd_regiao
             LIMIT 1)
            ELSE ( SELECT tac.cod_crede_censo
               FROM educacenso_exp.tb_associativa_crede tac
              WHERE tac.cod_crede_seduc = ut.cd_unidade_trabalho_pai
             LIMIT 1)
        END AS cd_distrito, ci_unidade_trabalho
FROM util.tb_unidade_trabalho ut 
where ut.cd_dependencia_administrativa = 2
and cd_tpunidade_trabalho = 1
)
,codigos_credes as (
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
,credes_municipio as (
select 
tde.id_municipio,
tde.nm_municipio ,
id_crede_sefor
from dw_sige.tb_dm_escola tde 
where id_crede_sefor between 1 and 20
group by 1,2,3
)
,escolas as (
select 
    case when id_crede_sefor <10 then '0000'||id_crede_sefor else  '000'||id_crede_sefor end cd_distrito,
	id_crede_sefor,
	cc.nm_municipio_crede,
	tut.ci_unidade_trabalho,
	tlf.cd_municipio_censo id_municipio,
	cm.nm_municipio,
	tut.cd_dependencia_administrativa,
	upper(tc.nm_categoria)  AS ds_categoria,
	tut.ci_unidade_trabalho id_escola_sige,
	tut.nr_codigo_unid_trab id_escola_inep, 
	upper(tut.nm_unidade_trabalho) nm_escola,
	upper(tc.nm_categoria) nm_categoria,
	upper(tlz.nm_localizacao_zona) AS ds_localizacao
from rede_fisica.tb_unidade_trabalho tut
join rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
join rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
join credes_municipio cm on cm.id_municipio =  tlf.cd_municipio_censo 
join codigos_credes cc using(id_crede_sefor)
left join rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
join rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
where 
    tut.cd_dependencia_administrativa in (2,3)
	and tut.cd_situacao_funcionamento = 1
	and tut.cd_tipo_unid_trab =401
	and tlut.fl_sede = true
union
select 
    cd_distrito,
	tut.cd_unidade_trabalho_pai  id_crede_sefor,
	sefor.nm_sigla nm_municipio_crede,
	tut.ci_unidade_trabalho,
	tlf.cd_municipio_censo id_municipio,
	upper(tmc.nm_municipio) nm_municipio,
	tut.cd_dependencia_administrativa,
	upper(tc.nm_categoria)  AS ds_categoria,
	tut.ci_unidade_trabalho id_escola_sige,
	tut.nr_codigo_unid_trab id_escola_inep, 
	upper(tut.nm_unidade_trabalho) nm_escola,
	upper(tc.nm_categoria) nm_categoria,
	upper(tlz.nm_localizacao_zona) AS ds_localizacao
from rede_fisica.tb_unidade_trabalho tut
join rede_fisica.tb_unidade_trabalho sefor on sefor.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai 
join rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
join rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
join rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
join rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
join util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join distritos d on tut.ci_unidade_trabalho = d.ci_unidade_trabalho 
where 
    tut.cd_dependencia_administrativa = 2
    and tlf.cd_municipio_censo = 2304400
	and tut.cd_situacao_funcionamento = 1
	and tut.cd_tipo_unid_trab =401
	and tlut.fl_sede = TRUE

)
,relatorio as (
select
	'Ceará' "NM_UF",
	cd_distrito "CD_DISTRITO",
	id_crede_sefor as "CD_REGIONAL",
	nm_municipio_crede "NM_REGIONAL",
    id_municipio "CD_MUNICIPIO",
	nm_municipio"NM_MUNICIPIO",
	id_escola_inep "CD_ESCOLA",
	nm_escola "NM_ESCOLA",
	nm_categoria "DC_CATEGORIA",
	case when cd_dependencia_administrativa = 2 then 1 else  2 end "CD_REDE_ENSINO",
	case when cd_dependencia_administrativa = 2 then 'ESTADUAL' else 'MUNICIPAL' end "DC_REDE_ENSINO",
	ds_localizacao as "DC_LOCALIZACAO",
	t.ci_turma "CD_TURMA",
	ds_turma "NM_TURMA",
	41  "CD_ETAPA", -- Código do Censo Escolar
    '9º ANO' "DC_ETAPA",  
	1  "CD_TIPO_ENSINO",         
	'REGULAR'  "DC_TIPO_ENSINO",
	ds_turno "DC_TURNO",
	FL_MULT "FL_MULTISSERIADA",
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
from enturmacao et 
join alunos a using(cd_aluno)
inner join turmas t on et.cd_turma = t.ci_turma
inner join escolas e on e.id_escola_sige = t.cd_unidade_trabalho
left join extensao ex on  t.ci_turma = ex.ci_turma
where 1 = 1
   and et.cd_etapa = 129
   and not exists (select 1 from extensao ex2 where ex2.ci_turma = t.ci_turma and cd_tipo_local in (3,4) ) -- retira as turmas do sistema prisional
)
select 
"DC_REDE_ENSINO", 
"CD_REDE_ENSINO", 
COUNT(1),
COUNT(distinct "CD_INSTITUCIONAL_ALUNO") QTD
from relatorio group by 1,2