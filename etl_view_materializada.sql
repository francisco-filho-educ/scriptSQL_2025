CREATE MATERIALIZED VIEW lotacaocoave.mw_cubo_matriculas as
with mult as(
select
tm.nr_anoletivo,
t.cd_unidade_trabalho,
tm.cd_turma,
t.cd_nivel,
tn.ds_nivel,
ti.cd_etapa,
te2.ds_etapa,
1 fl_multseriado,
0 fl_cci,
case
when cd_turno = 4 then 1
when cd_turno = 1 then 2
when cd_turno = 2 then 3
when cd_turno in (5,8,9) then 4
when cd_turno = 3 then 5
when cd_turno = 7 then 6 end cd_turno,
case when cd_turno in (8,9) then 'Integral' else ds_turno end ds_turno,
tm.cd_aluno
from academico.tb_aluno_multiseriacao tm
join academico.tb_turma t on tm.cd_turma = ci_turma
join academico.tb_item ti on tm.cd_item=ti.ci_item
join academico.tb_nivel tn on tn.ci_nivel = t.cd_nivel 
join academico.tb_etapa te2 on te2.ci_etapa = ti.cd_etapa 
join academico.tb_turno on ci_turno = cd_turno
where 
t.nr_anoletivo = extract (year FROM current_date)
and t.cd_prefeitura  = 0
)
,outras as (
select
tt.nr_anoletivo,
tt.cd_unidade_trabalho,
tu.cd_turma,
cd_nivel,
tn.ds_nivel,
tt.cd_etapa,
te.ds_etapa,
0 fl_multseriado,
0 fl_cci,
case
when cd_turno = 4 then 1
when cd_turno = 1 then 2
when cd_turno = 2 then 3
when cd_turno in (5,8,9) then 4
when cd_turno = 3 then 5
when cd_turno = 7 then 6 end cd_turno,
case when cd_turno in (8,9) then 'Integral' else ds_turno end ds_turno,
tu.cd_aluno
from academico.tb_ultimaenturmacao tu
join academico.tb_turma tt on tu.cd_turma = ci_turma
join academico.tb_etapa te on te.ci_etapa = tt.cd_etapa 
join academico.tb_nivel tn on tn.ci_nivel = tt.cd_nivel 
join academico.tb_turno on ci_turno = cd_turno
where 
tt.nr_anoletivo = extract (year FROM current_date)
and tt.cd_prefeitura  = 0
and not exists (select 1 from mult where tu.cd_aluno = mult.cd_aluno)
),
aluno_etapa as(
select * from mult
union
select * from outras
) --select * from aluno_etapa where fl_cci = 1
, mat as(
select
nr_anoletivo,
cd_unidade_trabalho,
cd_turma id_turma_sige,
cd_nivel cd_nivel_sige,
ds_nivel ds_nivel_sige,
cd_etapa cd_etapa_sige,
ds_etapa ds_etapa_sige,
fl_multseriado,
fl_cci,
cd_turno,
ds_turno,
case when cd_etapa in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
      									             then 1
	  when cd_etapa in (213,214,195,194,175,196,174,173)  then 2 else 99 end cd_oferta_ensino,
      
case when cd_etapa in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
      									             then 'Ensino Regular'
when cd_etapa in (213,214,195,194,175,196,174,173)  then 'EJA' else 'Não se aplica' end ds_oferta_ensino,
case when cd_nivel = 28 then 1
     when cd_nivel = 26 then 2
     when cd_nivel = 27 and cd_etapa<>137 then 3 else 99 end cd_etapa_aluno,
case when cd_nivel = 28 then 'Educação Infantil'
     when cd_nivel = 26 then 'Ensino Fundamental'
     when cd_nivel = 27 and cd_etapa<>137 then 'Ensino Médio' else 'Não se aplica' end ds_etapa_aluno,
case when cd_etapa in (121,122,123,124,125,172,194) then 1
     when cd_etapa in (126,127,128,129,174,195)     then 2
     when cd_etapa  = 175                           then 3 else 99 end cd_subetapa,
case when cd_etapa in (121,122,123,124,125,172,194) then 'Anos Iniciais'
     when cd_etapa in (126,127,128,129,174,195)     then 'Anos Finais'
     when cd_etapa  = 175                           then 'Anos Iniciais e Anos Finais' else 'Não se aplica' end ds_subetapa,
case 
     when cd_etapa = 121 then 1
     when cd_etapa = 122 then 2
     when cd_etapa = 123 then 3
     when cd_etapa = 124 then 4
     when cd_etapa = 125 then 5
     when cd_etapa = 126 then 6
     when cd_etapa = 127 then 7
     when cd_etapa = 128 then 8
     when cd_etapa = 129 then 9
     when cd_etapa in(162,184,188) then 10
     when cd_etapa in(163,185,189) then 11
     when cd_etapa in(164,186,190) then 12
     when cd_etapa in(165,187,191) then 13 else 99 end cd_ano_serie,
case 
     when cd_etapa = 121 then '1º Ano'
     when cd_etapa = 122 then '2º Ano'
     when cd_etapa = 123 then '3º Ano'
     when cd_etapa = 124 then '4º Ano'
     when cd_etapa = 125 then '5º Ano'
     when cd_etapa = 126 then '6º Ano'
     when cd_etapa = 127 then '7º Ano'
     when cd_etapa = 128 then '8º Ano'
     when cd_etapa = 129 then '9º Ano'
     when cd_etapa in(162,184,188) then '1ª Série'
     when cd_etapa in(163,185,189) then '2ª Série'
     when cd_etapa in(164,186,190) then '3ª Série'
     when cd_etapa in(165,187,191) then '4ª Série' else 'Não se aplica' end ds_ano_serie,
cd_aluno
from aluno_etapa 
)
,mat_escolar as (
select  --* from etapas_padronizadas where fl_cci = 1
nr_anoletivo,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
tmc.ci_municipio_censo id_municipio,
upper(tmc.nm_municipio) AS nm_municipio,
case when tut.nr_codigo_unid_trab in ('23263644','23190337','23078901','23185112','23259825','23041811','23021772',
'23043130','23252600','23545453','23545437','23002468','23009578','23252669','23545496','23031530','23545518','23021322',
'23016230','23029153','23029943','23026359','23025611','23049375','23545534','23000242','23054409','23054530','23246642',
'23178248','23057793','23056177','23056606','23059745','23000240','23000243','23125586','23252413','23132507',
'23132876','23098775','23085347','23095075','23265833','23120878','23000253','23462361','23149434','23150297','23155817',
'23179902','23163330','23154721','23159545','23068809','23073721','23272058','23069260','23233885') then 'TEMPO INTEGRAL' 
 else 
case when tut.cd_tipo_unid_trab  = 402 then 'CCI' else  upper(tc.nm_categoria) end  end nm_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.ci_unidade_trabalho id_escola_sige, 
tut.nm_unidade_trabalho nm_escola,
tlz.ci_localizacao_zona cd_localizacao,
upper(tlz.nm_localizacao_zona) AS nm_localizacao,
id_turma_sige,
cd_nivel_sige,
ds_nivel_sige,
cd_etapa_sige,
ds_etapa_sige,
fl_multseriado,
fl_cci,
cd_turno,
ds_turno,
cd_oferta_ensino,
ds_oferta_ensino,
cd_etapa_aluno,
ds_etapa_aluno,
cd_subetapa,
ds_subetapa,
cd_ano_serie,
ds_ano_serie,
cd_aluno
FROM rede_fisica.tb_unidade_trabalho tut 
join  mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
)
,mat_idiomas as (
select
te.nr_anoletivo,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
tl.cd_inep id_municipio,
upper(tl.ds_localidade) AS nm_municipio,
'CCI' nm_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.ci_unidade_trabalho id_escola_sige, 
tut.nm_unidade_trabalho nm_escola,
tut.cd_localizacao::int,
case when tut.cd_localizacao::int = 1  then 'URBANA' else 'RURAL' end ds_localizacao,
replace(to_char(tt.ci_turma ,'100000000'),' ','')::numeric cd_turma,
99 cd_nivel,
'Não se aplica' ds_nivel,
4004 cd_etapa,
'Ensino de Idiomas' ds_etapa,
0 fl_multseriado,
1 fl_cci,
case
when hr_inicio <'12:00:00'::time then 1
when hr_inicio >='12:00:00'::time and hr_inicio <'18:00:00'::time then 2
when hr_inicio >='12:00:00'::time and hr_inicio <'18:00:00'::time then 3 else 99
end cd_turno,
case
when hr_inicio <'12:00:00'::time then 'Manhã'
when hr_inicio >='12:00:00'::time and hr_inicio <'18:00:00'::time then 'Tarde' 
when hr_inicio >='18:00:00'::time and hr_inicio >'22:00:00'::time  then  'Noite' else 'Não informado' 
end ds_turno,
99 cd_oferta_ensino,
'Não se aplica' ds_oferta_ensino,
5 cd_etapa_aluno,
'Ensino de Idiomas' ds_etapa_aluno,
99 cd_subetapa,
'Não se aplica' ds_subetapa,
99 cd_ano_serie,
'Não se aplica' ds_ano_serie,
coalesce(cd_aluno,0) cd_aluno
from sigecci.tb_enturmacao te
join sigecci.tb_turma tt on tt.ci_turma = te.cd_turma 
join util.tb_unidade_trabalho tut on te.cd_cci_indicado  = tut.ci_unidade_trabalho
join util.tb_unidade_trabalho crede on crede.ci_unidade_trabalho =tut.cd_unidade_trabalho_pai 
join util.tb_localidades tl on tl.ci_localidade = tut.cd_municipio 
where
te.nr_anoletivo = extract (year FROM current_date)
and te.fl_apto 
and te .fl_ultima_enturmacao 
and te.fl_enturmado
), dt_ultima_enturmacao as (
select
nr_anoletivo, max(tu.dt_enturmacao) dt_ultimaenturmacao  
from academico.tb_ultimaenturmacao tu 
where nr_anoletivo = extract (year FROM current_date)
group by 1
) 
select 
me.*, dt_ultimaenturmacao  
from  mat_escolar me 
join dt_ultima_enturmacao using(nr_anoletivo)
union all
select 
mi.*, dt_ultimaenturmacao  mi
from  mat_idiomas mi
join dt_ultima_enturmacao using(nr_anoletivo)

