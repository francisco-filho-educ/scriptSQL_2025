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
)
,enturmacao as (
select 
cd_aluno,cd_turma
from academico.tb_ultimaenturmacao tu 
where exists (select 1 from turmas t where ci_turma = cd_turma)
and tu.fl_tipo_atividade <> 'AC'
) 
,extensao as (
select
     tt.cd_unidade_trabalho,
     --tt.ci_turma, 
     --Quando não tiver o nome da extesão ira aprecer o tipo de local de funcionamento 
     case when tlf.nm_local_funcionamento ='' or tlf.nm_local_funcionamento is null then ttl.nm_tipo_local else tlf.nm_local_funcionamento  end nm_local_funcionamento ,
     tlf.ci_local_funcionamento
     from turmas tt
     join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
     join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
     join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = lut.cd_local_funcionamento 
     join rede_fisica.tb_tipo_local ttl on ttl.ci_tipo_local = tlf.cd_tipo_local 
     where tt.nr_anoletivo = 2022
     and lut.fl_sede = false
     and cd_nivel =27
     and tt.cd_prefeitura = 0-- and tt.cd_unidade_trabalho = 15465
     group by 1,2,3
     
) --select * from extensao where cd_unidade_trabalho = 15465
/*
,mat_extensao as ( 
select
    cd_unidade_trabalho,
     cd_turma, 
     nm_local_funcionamento,
     ci_local_funcionamento,
      count(1) nr_matricula_extensao
from enturmacao
join extensao  ex on ex.ci_turma = cd_turma
group by 1,2,3,4

),
mat_sede as (
select 
      t.cd_unidade_trabalho,
      cd_turma, 
      count(1) nr_matricula_sede
from enturmacao e
join turmas t on t.ci_turma = cd_turma
where 
not exists (select 1 from extensao  ex where e.cd_turma =  ex.ci_turma)
group by 1,2
),
mat_total as (
select 
      t.cd_unidade_trabalho,
      cd_turma, 
      count(1) nr_matricula_total
from enturmacao e
join turmas t on t.ci_turma = cd_turma
group by 1,2
) */

,escolas as (
select
crede.ci_unidade_trabalho id_crede_sefor, 
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
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = TRUE 
--and tut.nr_codigo_unid_trab ='23462337'
--and tut.categoria not in (13,7) -- escolas regulares
--and tut.categoria = 7  -- escolas indigenas
--and tut.cd_categoria = 13-- escolas quilombolas
) --select * from escolas --754
/*
select  --count(1) nr_linha, count(distinct ci_aluno)
id_crede_sefor as "ID_CREDE_SEFOR",
nm_crede_sefor as "NM_CREDE_SEFOR",
nm_municipio as "NM_MUNICIPIO",
ci_municipio_censo as "ID_MUNICIPIO",
'ESTADUAL' as "DS_DEPENDENCIA",
ds_localizacao as "DS_LOCALIZACAO",
id_escola_inep as "ID_ESCOLA",
nm_escola as "NM_ESCOLA",
ds_categoria "CATEGORIA",
ex.nm_local_funcionamento as "NM_EXTENSAO"
sum(nr_matricula_total) nr_matricula_total,
sum(nr_matricula_sede) nr_matricula_sede,
sum(nr_matricula_extensao) nr_matricula_extensao,
count(distinct et.cd_turma) nr_turmas_total,
count(distinct sd.cd_turma) nr_turmas_sede,
count(distinct ex.cd_turma) nr_turmas_extensao
from mat_total et
inner join turmas t on et.cd_turma = t.ci_turma
inner join escolas e on e.id_escola_sige = t.cd_unidade_trabalho
left join mat_extensao ex on  t.ci_turma = ex.cd_turma
left join mat_sede sd on  t.ci_turma = sd.cd_turma 
group by 1,2,3,4,5,6,7,8,9,10
*/
-- LISTA DE ESCOLAS E EXTENSOES -
select  --count(1) nr_linha, count(distinct ci_aluno)
id_crede_sefor as "ID_CREDE_SEFOR",
nm_crede_sefor as "NM_CREDE_SEFOR",
nm_municipio as "NM_MUNICIPIO",
ci_municipio_censo as "ID_MUNICIPIO",
'ESTADUAL' as "DS_DEPENDENCIA",
ds_localizacao as "DS_LOCALIZACAO",
id_escola_inep as "ID_ESCOLA",
nm_escola as "NM_ESCOLA",
ds_categoria "CATEGORIA",
ex.nm_local_funcionamento as "NM_EXTENSAO"
from escolas e
join extensao ex on ex.cd_unidade_trabalho =  e.id_escola_sige

/*
*
*/
 --------------   TOTAL POR ESCOLA --------------------------
 with 
turmas as (
select *, 
case when cd_turno = 4 then 1
when cd_turno = 1 then 2
when cd_turno = 2 then 3
when cd_turno = 5 then 4 end cd_turno_c
from academico.tb_turma tt
join (select ci_turno, ds_turno from academico.tb_turno) as tn on tn.ci_turno = tt.cd_turno 
where nr_anoletivo = 2023
and cd_nivel in  (26,27,28) --and tt.dt_horainicio 
and cd_prefeitura= 0
)
,enturmacao as (
select 
cd_aluno,cd_turma
from academico.tb_ultimaenturmacao tu 
where exists (select 1 from turmas t where ci_turma = cd_turma)
and tu.fl_tipo_atividade <> 'AC'
) 
,extensao as (
select
     tt.cd_unidade_trabalho,
     tt.ci_turma, 
     --Quando não tiver o nome da extesão ira aprecer o tipo de local de funcionamento 
     case when tlf.nm_local_funcionamento ='' or tlf.nm_local_funcionamento is null then ttl.nm_tipo_local else tlf.nm_local_funcionamento  end nm_local_funcionamento ,
     tlf.ci_local_funcionamento
     from turmas tt
     join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
     join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
     join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = lut.cd_local_funcionamento 
     join rede_fisica.tb_tipo_local ttl on ttl.ci_tipo_local = tlf.cd_tipo_local 
     where tt.nr_anoletivo = 2023
     and lut.fl_sede = false
     and cd_nivel =27
     and tt.cd_prefeitura = 0-- and tt.cd_unidade_trabalho = 15465
     group by 1,2,3,4
     
) --select * from extensao where cd_unidade_trabalho = 15465

,mat_extensao as ( 
select
    cd_unidade_trabalho,
     cd_turma, 
     nm_local_funcionamento,
     ci_local_funcionamento,
      count(1) nr_matricula_extensao
from enturmacao
join extensao  ex on ex.ci_turma = cd_turma
group by 1,2,3,4

),
mat_sede as (
select 
      t.cd_unidade_trabalho,
      cd_turma, 
      count(1) nr_matricula_sede
from enturmacao e
join turmas t on t.ci_turma = cd_turma
where 
not exists (select 1 from extensao  ex where e.cd_turma =  ex.ci_turma)
group by 1,2
),
mat_total as (
select 
      t.cd_unidade_trabalho,
      cd_turma, 
      count(1) nr_matricula_total
from enturmacao e
join turmas t on t.ci_turma = cd_turma
group by 1,2
) 
,escolas as (
select
crede.ci_unidade_trabalho id_crede_sefor, 
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
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = TRUE 
and tut.nr_codigo_unid_trab ='23052643'
--and tut.categoria not in (13,7) -- escolas regulares
--and tut.categoria = 7  -- escolas indigenas
--and tut.cd_categoria = 13-- escolas quilombolas
) --select * from escolas --754

select  --count(1) nr_linha, count(distinct ci_aluno)
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
ci_municipio_censo,
ds_localizacao,
id_escola_inep,
nm_escola,
ds_categoria,
sum(nr_matricula_total) nr_matricula_total,
sum(nr_matricula_sede) nr_matricula_sede,
sum(nr_matricula_extensao) nr_matricula_extensao,
count(distinct et.cd_turma) nr_turmas_total,
count(distinct sd.cd_turma) nr_turmas_sede,
count(distinct ex.cd_turma) nr_turmas_extensao
from mat_total et
inner join turmas t on et.cd_turma = t.ci_turma
inner join escolas e on e.id_escola_sige = t.cd_unidade_trabalho
left join mat_extensao ex on  t.ci_turma = ex.cd_turma
left join mat_sede sd on  t.ci_turma = sd.cd_turma 
group by 1,2,3,4,5,6,7,8


--- RELATORIO SIGE NA DATA DE CORTE ------------------------------------------------------------------------------------

 --------------   TOTAL POR ESCOLA --------------------------
 with extensao as (
select
     tt.cd_unidade_trabalho,
     tt.ci_turma, 
     --Quando não tiver o nome da extesão ira aprecer o tipo de local de funcionamento 
     case when tlf.nm_local_funcionamento ='' or tlf.nm_local_funcionamento is null then ttl.nm_tipo_local else tlf.nm_local_funcionamento  end nm_local_funcionamento ,
     tlf.ci_local_funcionamento
     from academico.tb_turma tt
     join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
     join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
     join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = lut.cd_local_funcionamento 
     join rede_fisica.tb_tipo_local ttl on ttl.ci_tipo_local = tlf.cd_tipo_local 
     where tt.nr_anoletivo = 2023
     and lut.fl_sede = false
     and cd_nivel in (26,28,27)
     and tt.cd_prefeitura = 0-- and tt.cd_unidade_trabalho = 15465
     group by 1,2,3,4
     
) --select * from extensao where cd_unidade_trabalho = 15465
,mat_extensao as ( 
select
     cd_unidade_trabalho,
     count(1) nr_matricula_extensao
from public.tb_dm_etapa_aluno_2023_06_01 tdea 
join extensao  ex on ex.ci_turma = id_turma_sige
group by 1
) 
--select sum(nr_matricula_extensao)  from mat_extensao 
,mat_sede as (
select 
      id_escola_sige,
      count(1) nr_matricula_sede
from public.tb_dm_etapa_aluno_2023_06_01 tdea 
where 
tdea.id_escola_sige  in (select cd_unidade_trabalho from extensao)
and not exists (select 1 from extensao  ex where id_turma_sige =  ex.ci_turma)
group by 1
)
select 
m.nr_anoletivo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
ds_categoria,
tde.id_escola_inep,
nm_escola,
coalesce(nr_matricula_sede,0 )nr_matricula_sede,
coalesce(nr_matricula_extensao,0) nr_matricula_extensao,
count(1) nr_total
from public.tb_dm_etapa_aluno_2023_06_01 m
join public.tb_dm_escola tde using(id_escola_sige)
left join mat_extensao ex on m.id_escola_sige = cd_unidade_trabalho
left join mat_sede sd on m.id_escola_sige = sd.id_escola_sige
where 
m.id_escola_sige  in (select cd_unidade_trabalho from extensao)
group by 1,2,3,4,5,6,7,8,9
order by 2,4,5,6
