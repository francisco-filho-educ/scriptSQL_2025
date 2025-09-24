with 
turmas as (
	select * from academico.tb_turma tt
	where
tt.nr_anoletivo = 2022
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) 
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
                  and tut.cd_dependencia_administrativa = 2
                  
)
),
enturmados as (
	select cd_aluno,cd_turma from academico.tb_ultimaenturmacao e
	where exists(select 1 from turmas t where t.ci_turma=e.cd_turma)
) --select count(1) from enturmados
,disciplinas as (
select 
td.ci_disciplina 
from academico.tb_disciplinas td 
where td.fl_possui_avaliacao  ilike 'S'
and td.cd_prefeitura = 0
and td.cd_grupodisciplina between 1 and 14
)
,notas as (
select
cd_aluno,
cd_turma,
tg.ci_grupodisciplina,
tg.ds_grupodisciplina,
cd_periodo,
max(taa.nr_nota) nr_nota
from academico.tb_alunoavaliacao taa
join academico.tb_disciplinas d on cd_disciplina=ci_disciplina
join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina =d.cd_grupodisciplina  
join enturmados using(cd_aluno, cd_turma)
where taa.cd_periodo between 1 and 3
and nr_nota is not null 
group by 1,2,3,4,5
) 
select --count(1) from notas
nr_anoletivo,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) ds_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
e.cd_turma,
cd_etapa,
ds_etapa,
cd_turno,
ds_turno,
ci_grupodisciplina,
ds_grupodisciplina,
cd_periodo,
e.cd_aluno,
avg(nr_nota) nr_nota
from enturmados e
join turmas t on t.ci_turma =  e.cd_turma 
join academico.tb_etapa et on  et.ci_etapa = t.cd_etapa
join academico.tb_turno tn on tn.ci_turno = t.cd_turno
left join notas n on n.cd_aluno = e.cd_aluno and n.cd_turma = e.cd_turma
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
left JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
left JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
left join rede_fisica.tb_tipo_unid_trab ttut on ttut.ci_tipo_unid_trab = tut.cd_tipo_unid_trab 
WHERE tlut.fl_sede = TRUE 
and tut.cd_dependencia_administrativa = 2
and tut.cd_tipo_unid_trab = 401
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17

