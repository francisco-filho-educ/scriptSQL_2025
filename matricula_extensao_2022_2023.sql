 with 
turmas as (
select *, 
case when cd_turno = 4 then 1
when cd_turno = 1 then 2
when cd_turno = 2 then 3
when cd_turno = 5 then 4 end cd_turno_c
from academico.tb_turma tt
join (select ci_turno, ds_turno from academico.tb_turno) as tn on tn.ci_turno = tt.cd_turno 
where nr_anoletivo > 2021
and cd_nivel in  (26,27,28) --and tt.dt_horainicio 
and cd_prefeitura= 0
)
,enturmacao as (
select 
cd_aluno,cd_turma
from academico.tb_ultimaenturmacao tu 
where tu.nr_anoletivo = 2023 and exists (select 1 from turmas t where ci_turma = cd_turma)
and tu.fl_tipo_atividade <> 'AC'
union
select 
dt.cd_aluno, dt.id_turma_sige cd_turma
from public.tb_aluno_etapa_data_corte dt 
where  dt.cd_etapa_aluno in (1,2,3)
) 
,extensao as (
select
     tt.nr_anoletivo,
     tt.cd_unidade_trabalho,
     ci_turma cd_turma
     from turmas tt
     join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
     join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
     join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = lut.cd_local_funcionamento 
     join rede_fisica.tb_tipo_local ttl on ttl.ci_tipo_local = tlf.cd_tipo_local 
     where tt.nr_anoletivo > 2021
     and lut.fl_sede = false
     and cd_nivel in (26,27,28)
     and tt.cd_prefeitura = 0-- and tt.cd_unidade_trabalho = 15465
     group by 1,2,3 
) --select * from extensao where cd_unidade_trabalho = 15465

,mat_extensao as ( 
select
     cd_unidade_trabalho,
     count(case when nr_anoletivo = 2022 then cd_aluno  end ) nr_extensao_2022,
     count(case when nr_anoletivo = 2023 then cd_aluno  end ) nr_extensao_2023
from enturmacao
join extensao  using(cd_turma)
group by 1

),
mat_sede as (
select 
      t.cd_unidade_trabalho,
     count(case when nr_anoletivo = 2022 then cd_aluno  end ) nr_sede_2022,
     count(case when nr_anoletivo = 2023 then cd_aluno  end ) nr_sede_2023
from enturmacao e
join turmas t on t.ci_turma = cd_turma
where 
not exists (select 1 from extensao  ex where e.cd_turma =  ex.cd_turma)
group by 1
),
mat_total as (
select 
      t.cd_unidade_trabalho,
     count(case when t.nr_anoletivo = 2022 then cd_aluno  end ) nr_total_2022,
     count(case when t.nr_anoletivo = 2023 then cd_aluno  end ) nr_total_2023
from enturmacao e
join turmas t on t.ci_turma = cd_turma
group by 1
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
and tut.nr_codigo_unid_trab <> '23000043'
--and tut.categoria not in (13,7) -- escolas regulares
--and tut.categoria = 7  -- escolas indigenas
--and tut.cd_categoria = 13-- escolas quilombolas
) --select * from escolas --754
/*
select  --count(1) nr_linha, count(distinct ci_aluno)
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
ci_municipio_censo,
ds_localizacao,
id_escola_inep,
nm_escola,
ds_categoria,
coalesce( nr_total_2022   ,0)nr_total_2022   ,
coalesce( nr_total_2023   ,0)nr_total_2023   ,
coalesce( nr_sede_2022    ,0)nr_sede_2022    ,
coalesce( nr_sede_2023    ,0)nr_sede_2023    ,
coalesce( nr_extensao_2022,0)nr_extensao_2022,
coalesce( nr_extensao_2023,0)nr_extensao_2023
from escolas e  
left join mat_total et on et.cd_unidade_trabalho = id_escola_sige 
left join mat_sede sd  on sd.cd_unidade_trabalho = id_escola_sige 
left join mat_extensao ex  on ex.cd_unidade_trabalho = id_escola_sige 
*/
select  --count(1) nr_linha, count(distinct ci_aluno)
id_crede_sefor,
nm_crede_sefor,
sum(coalesce( nr_total_2022   ,0)) nr_total_2022   ,
sum(coalesce( nr_total_2023   ,0)) nr_total_2023   ,
sum(coalesce( nr_sede_2022    ,0)) nr_sede_2022    ,
sum(coalesce( nr_sede_2023    ,0)) nr_sede_2023    ,
sum(coalesce( nr_extensao_2022,0)) nr_extensao_2022,
sum(coalesce( nr_extensao_2023,0)) nr_extensao_2023
from escolas e  
left join mat_total et on et.cd_unidade_trabalho = id_escola_sige 
left join mat_sede sd  on sd.cd_unidade_trabalho = id_escola_sige 
left join mat_extensao ex  on ex.cd_unidade_trabalho = id_escola_sige 
group by 1,2
order by 1






