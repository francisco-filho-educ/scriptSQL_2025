with turma as (
select
*
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2022
and tt.fl_tipo_seriacao = 'RG' and tt.cd_tpensino = 1 and tt.fl_ativo = 'S'
and tt.cd_modalidade <> 38
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27 --and  ci_turma = 819643
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
                  and tut.cd_dependencia_administrativa = 2 )
)
, enturmados as (
select 
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
where tu.nr_anoletivo = 2022
and tu.fl_tipo_atividade <> 'AC'
and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
) --select * from enturmados
, turma_disc as (
select 
tt2.cd_turma,
cd_disciplina
from academico.tb_turmadisciplina tt2 
where tt2.nr_anoletivo = 2022
and exists (select 1 from turma t where  tt2.cd_turma = t.ci_turma) 
group by 1,2
) --select 1 from turma_disc
, notas as (
select 
ta.cd_aluno,
ta.cd_turma,
ta.cd_periodo,
ta.cd_disciplina,
max(ta.nr_nota) nr_nota 
from academico.tb_alunoavaliacao ta 
join academico.tb_disciplinas disc on disc.ci_disciplina = ta.cd_disciplina 
join academico.tb_grupodisciplina gd on gd.ci_grupodisciplina = disc.cd_grupodisciplina 
--and disc.fl_possui_avaliacao = 'S' 
and disc.cd_grupodisciplina between 1 and 14 -- and cd_periodo = 1
where ta.nr_anoletivo = 2022
and exists (select 1 from enturmados t where t.cd_aluno = ta.cd_aluno) 
group by 1,2,3,4
) --select 1  from notas
,notas_esperadas as (
select 
cd_turma,
1 cd_periodo,
cd_disciplina,
cd_aluno
from enturmados
join turma_disc using(cd_turma)
union 
select 
cd_turma,
2 cd_periodo,
cd_disciplina,
cd_aluno
from enturmados
join turma_disc using(cd_turma)
)-- select * from notas_esperadas
SELECT 
2022 nr_anoletivo,
crede.ci_unidade_trabalho  cd_crede,
upper(crede.nm_sigla) nm_crede, 
tmc.ci_municipio_censo cd_municipio,
upper(tmc.nm_municipio) AS nm_municipio,
tut.ci_unidade_trabalho cd_unidade_trabalho,
tut.nr_codigo_unid_trab,
tut.nm_unidade_trabalho,
tut.cd_categoria cd_subcategoria,
nm_categoria nm_subcategoria,
null is_prioritaria,
cd_nivel,
ds_nivel,
cd_modalidade,
ds_modalidade,
cd_turno,
ds_turno,
cd_curso,
nm_curso,
case
     when cd_etapa in(162,184,188) then 162
     when cd_etapa in(163,185,189) then 163
     when cd_etapa in(164,186,190) then 164
     when cd_etapa in(165,187,191) then 165 else 0 end  cd_etapa,
case
     when cd_etapa in(162,184,188) then '1ª Série'
     when cd_etapa in(163,185,189) then '2ª Série'
     when cd_etapa in(164,186,190) then '3ª Série'
     when cd_etapa in(165,187,191) then '4ª Série' else 'Não se aplica' end ds_etapa,
ci_turma  cd_turma,
ds_turma,
null cd_area_de_conhecimento,
'' nm_area_de_conhecimento,
cd_grupodisciplina cd_disciplina,
ds_grupodisciplina ds_disciplina,
count(distinct ne.cd_aluno) qtd_enturmados,
ne.cd_periodo,
count(distinct ne.cd_aluno) qtd_informar_ad,
count( distinct nr.cd_aluno) qtd_informado_ad,
count(distinct ne.cd_turma) qtd_informar_td,
count(distinct nr.cd_turma) qtd_informado_td,
null nr_media,
'' ds_classific_dif
--select ne.cd_periodo,cd_grupodisciplina , count(distinct cd_aluno) qtd_enturmados
from notas_esperadas ne
join academico.tb_disciplinas td on ci_disciplina = ne.cd_disciplina
join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina = td.cd_grupodisciplina 
left join notas nr on nr.cd_turma = ne.cd_turma and nr.cd_periodo = ne.cd_periodo and ne.cd_disciplina = nr.cd_disciplina
join turma t on ci_turma = ne.cd_turma 
join academico.tb_nivel tn on tn.ci_nivel = t.cd_nivel 
join academico.tb_turno on ci_turno = cd_turno
left join academico.tb_modalidade tm on tm.ci_modalidade = t.cd_modalidade
left join academico.tb_curso tc2 on ci_curso = t.cd_curso
join rede_fisica.tb_unidade_trabalho tut on t.cd_unidade_trabalho = tut.ci_unidade_trabalho 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab in (402,401)
AND tlut.fl_sede = TRUE  
and ne.cd_periodo = 2 
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,29


/*
select 
sum(qtdenturmados)
from academico.tb_turma tt where ci_turma = 819643


*/
