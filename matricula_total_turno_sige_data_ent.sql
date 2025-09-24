--etapa da turma
with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
ds_ofertaitem,
cd_unidade_trabalho,
cd_ambiente,
case when cd_turno in (8,9) then 'Integral' else ds_turno end ds_turno
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2023 
and tt.cd_prefeitura = 0
and tt.cd_nivel =27
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
            and tut.cd_dependencia_administrativa = 2)
),
ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join turma t on ci_turma=cd_turma 
  where e.nr_anoletivo=2023 --- ANO LETIVO
        and dt_enturmacao::date<='2023-06-01'  -- DATA DA ENTURMAÇAO > DATA DA DESENTURMAÇAO OU ESTA DEVE SER NULA
        and (dt_desenturmacao::date>'2023-06-01' or dt_desenturmacao is null)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,cd_turma
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join turma t on cd_turma=ci_turma 
) 
mat as (
 select 
cd_unidade_trabalho,
ds_turno,
count(1) total,
sum (case when fl_anexo then 1 else 0 end) nr_anexo
from  ult_ent tue
join turma tt on tt.ci_turma = tue.cd_turma
left join anexo using(ci_turma)
group by 1,2
) --select distinct ds_turno from mat 
SELECT 
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
ds_turno,
total,
nr_anexo
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
and tmc.ci_municipio_censo in(2304103,2305605,2308609)
union 
SELECT 
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
'TOTAL' ds_turno,
sum(total) total,
sum(nr_anexo) nr_anexo
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
and tmc.ci_municipio_censo in(2304103,2305605,2308609)
group BY 1,3,4,5,6,7,8
ORDER BY 1,3,4,6;


-- DATA DE REFERENCIA  DE 2022 -- etapa do aluno
/*
with turma as (
select *
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2022
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tt.fl_ativo = 'S' 
and cd_etapa <> 137
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
            and tut.cd_dependencia_administrativa = 2)
)
,ent as (
  select
  cd_aluno,max(ci_enturmacao) ci_enturmacao
  from academico.tb_enturmacao e
  join academico.tb_turma t 
        on ci_turma=cd_turma 
        and fl_tipo_seriacao!='AC' 
        and cd_prefeitura=0
  where t.nr_anoletivo=2022 --- ANO LETIVO
        and dt_enturmacao::date<='2022-05-25'  -- DATA DA ENTURMAÇAO > DATA DA DESENTURMAÇAO OU ESTA DEVE SER NULA
        and (dt_desenturmacao::date>'2022-05-25' or dt_desenturmacao is null)
  group by 1
),
ult_ent as (
  select
  e1.cd_aluno,cd_turma,dt_enturmacao
  from academico.tb_enturmacao e1
  join ent e2 on e1.ci_enturmacao=e2.ci_enturmacao  
  join academico.tb_turma t on cd_turma=ci_turma 
)
 ,mult  as(
select
tm.cd_turma,
ti.cd_nivel,
ti.cd_etapa,
dt_enturmacao,
tm.cd_aluno
from academico.tb_aluno_multiseriacao tm
join academico.tb_item ti on tm.cd_item=ti.ci_item
join ult_ent using(cd_turma,cd_aluno)
where 
tm.nr_anoletivo = 2022
and ti.cd_prefeitura = 0

) --select * from mult
, outras as (
select
cd_turma,
cd_nivel,
cd_etapa,
dt_enturmacao,
cd_aluno
from ult_ent tu
join turma tt on tu.cd_turma = ci_turma
where 
not exists (select 1 from mult where tu.cd_aluno = mult.cd_aluno)
),
aluno_etapa as(
select * from mult
union
select * from outras
) --select * from aluno_etapa
, etapas_padronizadas as(
select
cd_aluno,
cd_turma,
case when cd_etapa in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
                                     then 'Regular'
    when cd_etapa in (213,214,195,194,175,196,174,173)  then 'EJA' else 'OUTRO' end fl_eja,
case when cd_nivel = 28 then 'Educação Infantil'
     when cd_nivel = 26 then 'Ensino Fundamental'
     when cd_nivel = 27 then 'Ensino Médio' end ds_etapa,

case when cd_etapa =   180 then 'Creche' -- CRECHE
     when cd_etapa =   181 then 'Pré-escola'
     when cd_etapa in (121,122,123,124,125)  then 'Anos Iniciais'
     when cd_etapa in (126,127,128,129)   then 'Anos Finais'
     when cd_etapa in(162,184,188) then '1º Série'
     when cd_etapa in(163,185,189) then '2º Série'
     when cd_etapa in(164,186,190) then '3º Série'
     when cd_etapa in(165,187,191) then '4º Série' 
     when cd_etapa in (194,195,175,196,213,214) then 'EJA Presencial'
     when cd_etapa in (173,174) then 'EJA Semipresencial'
     else 'OUTRA' end ds_etapa_serie,
     to_char(dt_enturmacao,'dd/mm/yyyy') dt_enturmacao
from aluno_etapa ae
)
--select ds_etapa_serie, count(1) from etapas_padronizadas group by 1
,
aluno as ( 
select 
ci_aluno cd_aluno,
nm_aluno,
to_char(dt_nascimento,'dd/mm/yyyy')dt_nascimento,
coalesce(ds_raca, 'Não Declarado') ds_raca,
case when ta.fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo -- 1: masculino | 2: feminino 
from academico.tb_aluno ta
join ult_ent et on et.cd_aluno = ci_aluno
left join academico.tb_aluno_deficiencia tad on tad.cd_aluno = ta.ci_aluno 
left join academico.tb_raca tr on tr.ci_raca = ta.cd_raca

)
select 
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
et.*,
ds_turno,
a.*
from etapas_padronizadas et 
inner join aluno a using(cd_aluno)
inner join turma t on et.cd_turma = t.ci_turma
inner join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho
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
ORDER BY 1
*/