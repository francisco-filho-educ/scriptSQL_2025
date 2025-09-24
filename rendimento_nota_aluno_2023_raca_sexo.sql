with turma as (
select
nr_anoletivo,
ci_turma,
cd_nivel,
cd_etapa,
cd_turno,
tt.ds_turma,
ds_ofertaitem,
cd_modalidade,
cd_unidade_trabalho
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2023
and tt.fl_tipo_seriacao = 'RG' and tt.cd_tpensino = 1 and tt.fl_ativo = 'S'
and tt.cd_modalidade <> 38
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
and cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) 
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2 --and tut.ci_unidade_trabalho = 37
						)
) 
, enturmados as (
select 
cd_aluno,
cd_turma
from academico.tb_ultimaenturmacao tu 
where tu.nr_anoletivo = 2023
and tu.fl_tipo_atividade <> 'AC'
and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
), turma_disc as (
select 
tt2.cd_disciplina,
tt2.cd_turma,
cd_grupodisciplina,
1 cd_periodo
from academico.tb_turmadisciplina tt2 
join academico.tb_disciplinas td2 on td2.ci_disciplina = tt2.cd_disciplina 
where tt2.nr_anoletivo = 2023
and exists (select 1 from turma t where  tt2.cd_turma = t.ci_turma) 
and td2.cd_grupodisciplina between 1 and 14
union 
select 
tt2.cd_disciplina,
tt2.cd_turma,
cd_grupodisciplina,
2 cd_periodo
from academico.tb_turmadisciplina tt2 
join academico.tb_disciplinas td2 on td2.ci_disciplina = tt2.cd_disciplina 
where tt2.nr_anoletivo = 2023
and exists (select 1 from turma t where  tt2.cd_turma = t.ci_turma) 
and td2.cd_grupodisciplina between 1 and 14
), notas as (
select 
ta.cd_aluno,
ta.cd_turma,
ta.cd_periodo,
ta.cd_disciplina,
max(ta.nr_nota) nr_nota 
from academico.tb_alunoavaliacao ta 
where ta.nr_anoletivo = 2023
and exists (select 1 from turma t where ta.cd_turma = t.ci_turma) 
and exists (select 1 from academico.tb_disciplinas disc where disc.ci_disciplina = ta.cd_disciplina and disc.fl_tipo = 'B') 
group by 1,2,3,4 
)
,notas_aluno as (
select 
nr_anoletivo,
tee.cd_newetapa cd_etapa,
tee.ds_newetapa ds_etapa,
ds_ofertaitem,
cd_unidade_trabalho,
e.cd_aluno,
e.cd_turma,
ds_turma,
case when cd_turno in (8,9) then 'Integral' else ds_turno end ds_turno,
td.cd_disciplina,
cd_grupodisciplina,
ds_grupodisciplina,
max(case when td.cd_periodo = 1 then nr_nota end) nota_1_bim,
max(case when td.cd_periodo = 2 then nr_nota end) nota_2_bim
from enturmados e
inner join turma t on ci_turma = e.cd_turma
join academico.tb_turno on ci_turno = cd_turno
join academico.tb_etapa_etapamodalidade tee on tee.cd_etapa = t.cd_etapa and tee.cd_modalidade = t.cd_modalidade
inner join turma_disc td on td.cd_turma = e.cd_turma
join academico.tb_grupodisciplina tg2 on td.cd_grupodisciplina =  ci_grupodisciplina
left join notas n on n.cd_aluno = e.cd_aluno and e.cd_turma = n.cd_turma and td.cd_disciplina = n.cd_disciplina and n.cd_periodo = td.cd_periodo
group by 1,2,3,4,5,6,7,8,9,10,11,12
)
SELECT 
nr_anoletivo,
crede.ci_unidade_trabalho, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS ds_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
cd_turma,
ds_turma,
ds_turno,
cd_etapa,
ds_etapa,
ds_ofertaitem,
cd_aluno,
nm_aluno,
case when cd_raca is null then 'Não Declarada' else tr.ds_raca end ds_raca,
case when taa.fl_sexo = 'M' then 'Masculino' 
     when taa.fl_sexo = 'F' then 'Feminino' else  'Não Informado' end ds_sexo,
ds_grupodisciplina,
cd_grupodisciplina,
avg(nota_1_bim) nr_nota_1_bim,
avg(nota_2_bim) nr_nota_2_bim
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
join notas_aluno na on na.cd_unidade_trabalho = tut.ci_unidade_trabalho 
join academico.tb_aluno taa on taa.ci_aluno = na.cd_aluno and taa.ci_aluno in (select cd_aluno from enturmados )
left join academico.tb_raca tr on tr.ci_raca = taa.cd_raca
WHERE 
tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21
