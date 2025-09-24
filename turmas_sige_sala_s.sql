with turma as (
select
*
from academico.tb_turma tt 
where
tt.nr_anoletivo = 2022
and tt.fl_tipo_seriacao = 'RG' and tt.cd_tpensino = 1 and tt.fl_ativo = 'S'
and tt.cd_modalidade <> 38
and tt.cd_prefeitura = 0
and tt.cd_nivel = 27
--and  tt.cd_unidade_trabalho = ",cd_unidade_trabalho,"
and cd_etapa in (162,184,188,163,185,189,164,186,190,165,187,191)
)
select
ci_turma,
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
ds_turma
from turma t
join academico.tb_nivel tn on tn.ci_nivel = t.cd_nivel 
join academico.tb_turno on ci_turno = cd_turno
left join academico.tb_modalidade tm on tm.ci_modalidade = t.cd_modalidade
left join academico.tb_curso tc2 on ci_curso = t.cd_curso
