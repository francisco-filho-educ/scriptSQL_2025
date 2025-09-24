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
) 
--select count(1) from enturmados
,notas as (
select 
cd_aluno,
cd_turma,
cd_grupodisciplina,
avg(nr_nota) nr_nota
from tmp.turma_disc_bim_1 td 
join tmp.notas_bim_1 n using(cd_turma,cd_disciplina,cd_periodo) 
where td.cd_periodo = 1
and td.cd_grupodisciplina not in (5,14)
group by 1,2,3
)
,qtd_notas as (
select 
cd_aluno,
cd_turma,
count(distinct case when nr_nota < 6 then cd_grupodisciplina end ) qtd
from notas 
group by 1,2
) 
SELECT  --qtd, count(1) from qtd_notas group by 1 
tt.nr_anoletivo,
tde.id_crede_sefor, 
nm_crede_sefor, 
nm_municipio,
ds_categoria,
id_escola_sige,
id_escola_inep, 
nm_escola,
ds_localizacao,
cd_turma,
ds_turma,
ds_turno,
tee.cd_etapa,
tee.ds_newetapa ds_etapa,
ds_ofertaitem,
cd_aluno,
nm_aluno,
case when cd_raca is null then 'Não Declarada' else tr.ds_raca end ds_raca,
case when taa.fl_sexo = 'M' then 'Masculino' 
     when taa.fl_sexo = 'F' then 'Feminino' else  'Não Informado' end ds_sexo,
case when qtd=0 then 1 else 0 end fl_0_abaixo,
case when qtd = 1 then 1 else 0 end fl_1_abaixo,
case when qtd = 2 then 1 else 0 end fl_2_abaixo,
case when qtd = 3 then 1 else 0 end fl_3_abaixo,
case when qtd >= 3 then 1 else 0 end fl_acima_3_abaixo
FROM public.tb_dm_escola tde 
join turma tt on tt.cd_unidade_trabalho = tde.id_escola_sige 
--join enturmados et on et.cd_turma = tt.ci_turma
join academico.tb_turno on ci_turno = cd_turno
join academico.tb_etapa_etapamodalidade tee on tee.cd_etapa = tt.cd_etapa and tee.cd_modalidade = tt.cd_modalidade
join qtd_notas na on na.cd_turma = ci_turma 
join academico.tb_aluno taa on taa.ci_aluno = na.cd_aluno and taa.ci_aluno in (select cd_aluno from enturmados)
left join academico.tb_raca tr on tr.ci_raca = taa.cd_raca

