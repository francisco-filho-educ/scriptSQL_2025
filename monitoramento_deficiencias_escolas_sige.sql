with turma as (
select *
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2024
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tt.fl_ativo = 'S' 
and cd_etapa <> 137
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
            and tut.cd_dependencia_administrativa = 2) --and ci_turma = 965911
)
,ult_ent as (
  select
  cd_aluno,
  --max(cd_turma) 
  cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2024
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma) --group by 1
  ) --select count(1) from ult_ent
  
,deficientes as (
select 
cd_aluno,
case when td.id_tipo  = '2' then 'Autismo'
    when td.id_tipo  = '3' then 'Altas Habilidades/Superdotação' 
    else td.nm_deficiencia end 
     nm_deficiencia
from academico.tb_aluno_deficiencia tad 
join academico.tb_deficiencia td on ci_deficiencia = cd_deficiencia 
where exists(select 1 from ult_ent where ult_ent.cd_aluno = tad.cd_aluno)
group by 1,2
)
,mat_deficientes as (
select 
t.cd_unidade_trabalho,
nm_deficiencia, count(1) qtd_deficientes
from deficientes d
join ult_ent u on u.cd_aluno = d.cd_aluno
join turma t on t.ci_turma =  u.cd_turma
group by 1,2
)
,enturmados as (
select
tut.ci_unidade_trabalho cd_unidade_trabalho,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
case 
when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
when  tut.ci_unidade_trabalho = 47258 then 'CREAECE' 
when tut.nr_codigo_unid_trab in (
'23046490',
'23234580',
'23236574',
'23237775',
'23015705',
'23024291',
'23022248',
'23017368',
'23050764',
'23051930',
'23277890',
'23127430',
'23135425',
'23221348',
'23093935',
'23245026',
'23246634',
'23144793',
'23156210',
'23074701',
'23072237',
'23072865',
'23069619',
'23225416',
'23069988',
'23065214') then 'TEMPO INTEGRAL'
when tut.cd_categoria is null then 'Não se aplica'
else upper(tc.nm_categoria) end AS nm_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
count(1) qtd_total_enturmados
from ult_ent et 
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
group by 1,2,3,4,5,6,7,8
ORDER BY 1
)
--select * from enturmados et 
--select * from  mat_deficientes et 
select
*
from enturmados et 
join mat_deficientes d using(cd_unidade_trabalho)
--1 - Deficiência  | 2 - Transtorno do Espectro Autista (TEA)  | 3 - Altas Habilidades/Superdotação  | 4 - Transtorno do Desenvolvimento e/ou da Aprendizagem
