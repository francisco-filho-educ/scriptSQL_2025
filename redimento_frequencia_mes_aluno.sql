with 
turmas as (
select *
from academico.tb_turma 
where  nr_anoletivo =2022
and cd_prefeitura = 0
and cd_nivel in (26,27)
and fl_tipo_seriacao!='AC' -- and ci_turma =744871
),
enturmados as (
select *  
from academico.tb_enturmacao e
where nr_anoletivo =2022
and exists(select 1 from turmas t where t.ci_turma=e.cd_turma)
and cd_aluno = 2954360
group by 1,2
) select  * from enturmados join turmas on ci_turma = cd_turma 
,aulas as (
  select 
  ent.cd_aluno,
  ent.cd_turma, 
  td.cd_grupodisciplina,
sum(case when nr_mes =  1  then nr_aulas else 0 end)   nr_aulasjan,
sum(case when nr_mes =  2  then nr_aulas else 0 end)   nr_aulasfev,
sum(case when nr_mes =  3  then nr_aulas else 0 end)   nr_aulasmar,
sum(case when nr_mes =  4  then nr_aulas else 0 end)   nr_aulasabr,
sum(case when nr_mes =  5  then nr_aulas else 0 end)   nr_aulasmai,
sum(case when nr_mes =  6  then nr_aulas else 0 end)   nr_aulasjun,
sum(case when nr_mes =  7  then nr_aulas else 0 end)   nr_aulasjul,
sum(case when nr_mes =  8  then nr_aulas else 0 end)   nr_aulasago,
sum(case when nr_mes =  9  then nr_aulas else 0 end)   nr_aulasset,
sum(case when nr_mes =  10   then nr_aulas else 0 end) nr_aulasout,
sum(case when nr_mes =  11   then nr_aulas else 0 end) nr_aulasnov,
sum(case when nr_mes =  12   then nr_aulas else 0 end) nr_aulasdez
  from enturmados ent 
   join academico.tb_alunofrequencia_total_aulas_mes aftam on ent.cd_turma=aftam.cd_turma
  join academico.tb_disciplinas td on td.ci_disciplina = aftam.cd_disciplina 
  where nr_anoletivo =2022 
  and aftam.nr_mes between 1 and 12
  and td.fl_possui_avaliacao = 'S'
  and td.cd_grupodisciplina between 1 and 14
  and nr_ano = nr_anoletivo 
  group by 1,2,3
) --select  * from aulas 
,faltas as (
select 
ent.cd_aluno,
ent.cd_turma,
td.cd_grupodisciplina, 
sum(case when nr_mes =  1  then nr_faltas else 0 end)   nr_faltasjan,
sum(case when nr_mes =  2  then nr_faltas else 0 end)   nr_faltasfev,
sum(case when nr_mes =  3  then nr_faltas else 0 end)   nr_faltasmar,
sum(case when nr_mes =  4  then nr_faltas else 0 end)   nr_faltasabr,
sum(case when nr_mes =  5  then nr_faltas else 0 end)   nr_faltasmai,
sum(case when nr_mes =  6  then nr_faltas else 0 end)   nr_faltasjun,
sum(case when nr_mes =  7  then nr_faltas else 0 end)   nr_faltasjul,
sum(case when nr_mes =  8  then nr_faltas else 0 end)   nr_faltasago,
sum(case when nr_mes =  9  then nr_faltas else 0 end)   nr_faltasset,
sum(case when nr_mes =  10   then nr_faltas else 0 end) nr_faltasout,
sum(case when nr_mes =  11   then nr_faltas else 0 end) nr_faltasnov,
sum(case when nr_mes =  12   then nr_faltas else 0 end) nr_faltasdez
from enturmados ent 
join academico.tb_alunofrequencia af on ent.cd_turma=af.cd_turma and af.cd_aluno  = ent.cd_aluno
join academico.tb_disciplinas td on td.ci_disciplina = af.cd_disciplina 
where nr_anoletivo =2022 
and nr_ano = nr_anoletivo 
and af.nr_mes between 1 and 12
and td.fl_possui_avaliacao = 'S'
and td.cd_grupodisciplina between 1 and 14
group by 1,2,3
) --select 1
,notas as (
select
tdd.cd_grupodisciplina,
et.cd_aluno,
et.cd_turma,
avg(tdb.nr_nota_1) nr_nota_1,
avg(tdb.nr_nota_2) nr_nota_2,
avg(tdb.nr_nota_3) nr_nota_3,
avg(tdb.nr_nota_4) nr_nota_4,
avg(tdb.nr_nota_5) nr_nota_5,
avg(tdb.nr_mediafinal) nr_mediafinal
from rendimento.tb_detalhes_boletim_2022 tdb
join academico.tb_disciplinas tdd on tdd.ci_disciplina = cd_disciplina
join enturmados et on et.cd_aluno =  tdb.cd_aluno and tdb.cd_turma = et.cd_turma
group by 1,2,3
)
select
t.nr_anoletivo,
tutp.nm_sigla nm_crede,
tut.cd_unidade_trabalho_pai cd_crede,
tut.nr_codigo_unid_trab id_escola_inep,
tut.nm_unidade_trabalho,
t.ci_turma,
t.ds_ofertaitem, 
tr.ds_turno,
nm_aluno,
a.cd_aluno,
ds_grupodisciplina,
coalesce(	nr_aulasjan,	0)	nr_aulasjan,
coalesce(	nr_faltasjan,	0)	nr_faltasjan,
coalesce(	nr_aulasfev,	0)	nr_aulasfev,
coalesce(	nr_faltasfev,	0)	nr_faltasfev,
coalesce(	nr_aulasmar,	0)	nr_aulasmar,
coalesce(	nr_faltasmar,	0)	nr_faltasmar,
coalesce(	nr_aulasabr,	0)	nr_aulasabr,
coalesce(	nr_faltasabr,	0)	nr_faltasabr,
coalesce(	nr_aulasmai,	0)	nr_aulasmai,
coalesce(	nr_faltasmai,	0)	nr_faltasmai,
coalesce(	nr_aulasjun,	0)	nr_aulasjun,
coalesce(	nr_faltasjun,	0)	nr_faltasjun,
coalesce(	nr_aulasjul,	0)	nr_aulasjul,
coalesce(	nr_faltasjul,	0)	nr_faltasjul,
coalesce(	nr_aulasago,	0)	nr_aulasago,
coalesce(	nr_faltasago,	0)	nr_faltasago,
coalesce(	nr_aulasset,	0)	nr_aulasset,
coalesce(	nr_faltasset,	0)	nr_faltasset,
coalesce(	nr_aulasout,	0)	nr_aulasout,
coalesce(	nr_faltasout,	0)	nr_faltasout,
coalesce(	nr_aulasnov,	0)	nr_aulasnov,
coalesce(	nr_faltasnov,	0)	nr_faltasnov,
coalesce(	nr_aulasdez,	0)	nr_aulasdez,
coalesce(	nr_faltasdez,	0)	nr_faltasdez,
nr_nota_1,
nr_nota_2,
nr_nota_3,
nr_nota_4,
nr_nota_5,
nr_mediafinal
from aulas a 
join academico.tb_grupodisciplina tgd on tgd.ci_grupodisciplina = a.cd_grupodisciplina
join turmas t on t.ci_turma = a.cd_turma
join academico.tb_aluno ta on ta.ci_aluno = a.cd_aluno
left join faltas f on f.cd_aluno = a.cd_aluno and a.cd_turma = f.cd_turma and a.cd_grupodisciplina = f.cd_grupodisciplina
left join notas n on n.cd_aluno = a.cd_aluno and a.cd_turma = n.cd_turma and a.cd_grupodisciplina = n.cd_grupodisciplina
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho
join rede_fisica.tb_unidade_trabalho tutp on tutp.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai 
join academico.tb_turno tr on tr.ci_turno = t.cd_turno 
order by tut.nm_unidade_trabalho , ds_grupodisciplina, ds_ofertaitem 
---
