select
tt.nr_anoletivo,
tt.cd_unidade_trabalho,
tt.ds_ofertaitem,
tu.cd_turma,
tu.cd_aluno,
cd_nivel,
ds_nivel,
cd_ambiente,
case when cd_turno in (8,9) then 'Integral' else ds_turno end ds_turno,
case when cd_etapa in(162,184,188) then '1ª Série'
     when cd_etapa in(163,185,189) then '2ª Série'
     when cd_etapa in(164,186,190) then '3ª Série'
     when cd_etapa in(165,187,191) then '4ª Série' else te.ds_etapa end ds_etapa
from academico.tb_turma tt
join academico.tb_ultimaenturmacao tu on tu.cd_turma = tt.ci_turma 
join academico.tb_etapa te on te.ci_etapa = tt.cd_etapa 
join academico.tb_nivel tn on tt.cd_nivel = tn.ci_nivel 
join academico.tb_turno tr on tr.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2022 
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tu.fl_tipo_atividade <> 'AC'
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
