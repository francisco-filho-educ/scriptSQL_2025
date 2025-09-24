with turmas as (
select *
from academico.tb_turma tt
join academico.tb_etapa te on te.ci_etapa = cd_etapa
where nr_anoletivo = 2024 
and cd_nivel in  (26,27)  --and tt.dt_horainicio 
--and cd_prefeitura = 0 -- retirar o filtro quando for geral
) 
--select cd_etapa,ds_etapa, cd_anofinaleja from turmas t group by 1,2,3
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
     where tt.nr_anoletivo = 2024
     and lut.fl_sede = false
     --and tlf.cd_tipo_local not in (4,3) -- retira os anexo em sistemas prisionais
     group by 1,2,3,4
)
,enturmacao_i as (
select 
cd_aluno,
cd_turma,
cd_etapa
from academico.tb_ultimaenturmacao tu 
join (select ci_turma, cd_etapa from turmas) as t on  ci_turma = cd_turma
and tu.fl_tipo_atividade <> 'AC'
)
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
tm.nr_anoletivo = 2024
)
--select count(1) from mult
,enturmacao as (
select 
cd_aluno,
cd_turma,
cd_etapa,
0 fl_mult
from enturmacao_i eti 
where cd_turma not in (select distinct cd_turma  from mult)
union  
select 
cd_aluno,
cd_turma,
cd_etapa,
fl_mult
from mult 
) 
-- select distinct cd_etapa  from enturmacao
,matricula_geral as (
select 
s.nr_anoletivo,
cd_aluno,
cd_turma,
ds_turma,
ds_ofertaitem,
et.cd_etapa,
case when et.cd_etapa = 129 then 9 else 12 end id_serie,
case when et.cd_etapa = 129 then '9º Ano - Ensino Fundamental'
     when et.cd_etapa in (164,190,186)  then '3º Série - Ensino Médio' 
     when et.cd_etapa = 195  then 'EJA Presencial - Anos finais'
     when (et.cd_etapa =214 or (et.cd_etapa = 196 and cd_anofinaleja = 2))  then 'EJA Presencial - Ensino Médio'
     else et.cd_etapa::text
     end ds_serie,
fl_mult,
case when cd_turno = 4 then 1
when cd_turno = 1 then 2
when cd_turno = 2 then 3
when cd_turno in (5,8,9,10)  then 4 
when cd_turno = 7 then 5
when cd_turno = 3 then 6
end cd_turno,
case when cd_turno = 4 then 'Manhã'
	when cd_turno = 1 then 'Tarde'
	when cd_turno = 2 then 'Noite'
	when cd_turno in (5,8,9,10) then 'Integral' 
	when cd_turno = 7 then	'Intermediário'
	when cd_turno = 3	then 'Flexível'
	else 'Não informado' end ds_turno,
case when et.cd_etapa in (129,164,190,186) then 1 else 2 end cd_modalidade,
case when et.cd_etapa in (129,164,190,186) then 'REGULAR' else 'EJA' end ds_modalidade,
cd_unidade_trabalho id_escola_sige
from enturmacao et
join turmas s on s.ci_turma = cd_turma 
where et.cd_etapa in (129,195,164,190,186,214) or (et.cd_etapa = 196 and cd_anofinaleja = 2)
)
,matricula as (
select
nr_anoletivo,
id_escola_sige,
cd_turma,
ds_turma,
ds_serie,
id_serie,
ds_turno,
cd_turno,
ds_modalidade,
cd_modalidade,
count(1) qt_matriculas
from matricula_geral --where cd_turno >5 group by 1,2
group by 1,2,3,4,5,6,7,8,9,10
)

,credes as (
select 
tut.ci_unidade_trabalho id_crede_sefor,
--tut.nm_sigla nm_crede_sefor,
tl.ds_localidade nm_municipio_crede
from util.tb_unidade_trabalho tut 
join util.tb_localidades tl on tl.ci_localidade = tut.cd_municipio 
where tut.ci_unidade_trabalho 
between 1 and 23
)
,credes_municipio as (
select 
tde.id_municipio,
tde.nm_municipio ,
id_crede_sefor,
nm_crede_sefor,
nm_municipio_crede
from public.tb_dm_escola tde 
join credes using (id_crede_sefor)
where id_crede_sefor between 1 and 20
group by 1,2,3,4,5
union  
select 
2304400 id_municipio,
'FORTALEZA' nm_municipio ,
21 id_crede_sefor,
'SEFOR' nm_crede_sefor,
'FORTALEZA' nm_municipio_crede
)
,escolas as (
select
2024 nr_anoletivo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio_crede,
id_municipio,
nm_municipio ,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
tut.cd_dependencia_administrativa,
case when tut.cd_dependencia_administrativa = 2 then 'ESTADUAL' else 'MUNICIPAL' end ds_dependencia, 
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
upper(tlf.nm_bairro) nm_bairro,
upper(tlf.nm_logradouro) nm_endereco,
tlf.ds_numero,
upper(tlf.ds_complemento) complemento,
tlf.nr_cep,
tut.ds_email_corporativo,
tut.ds_email_alternativo,
tut.ds_telefone1,
tut.ds_telefone2,
tlf.nr_latitude,
tlf.nr_longitude
from rede_fisica.tb_unidade_trabalho tut
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN credes_municipio  tmc ON tmc.id_municipio = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = in (2,3) -- verificar dependencia
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = TRUE 
)
select
*
from escolas
join matricula using(id_escola_sige)