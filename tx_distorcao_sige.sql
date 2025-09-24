with alunos as (
select
id_escola_inep,
cd_aluno,
ae.nr_idade,
cd_turma,
ds_nivel,
case 
     when  ae.cd_etapa_aluno = 121 then 1
     when  ae.cd_etapa_aluno = 122 then 2
     when  ae.cd_etapa_aluno = 123 then 3
     when  ae.cd_etapa_aluno = 124 then 4
     when  ae.cd_etapa_aluno = 125 then 5
     when  ae.cd_etapa_aluno = 126 then 6
     when  ae.cd_etapa_aluno = 127 then 7
     when  ae.cd_etapa_aluno = 128 then 8
     when  ae.cd_etapa_aluno = 129 then 9
     when  ae.cd_etapa_aluno in(162,184,188) then 10
     when  ae.cd_etapa_aluno in(163,185,189) then 11
     when  ae.cd_etapa_aluno in(164,186,190) then 12
     when  ae.cd_etapa_aluno in(165,187,191) then 13 else 99 end cd_ano_serie
from dw_sige.tb_cubo_aluno_junho_2024 ae
where ae.cd_etapa_aluno in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
)
,alunos_distorcao as (
select 
a.*,
case when nr_idade - cd_ano_serie > 6 then 1 else 0 end fl_distorcao
from alunos a
)
select
id_escola_inep,
ds_nivel,
round(sum( fl_distorcao)  / count(1)::numeric*100,1) tx_distorcao
from alunos_distorcao 
group by 1,2


