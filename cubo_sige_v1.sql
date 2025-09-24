with mult as(
select
tm.nr_anoletivo,
t.cd_unidade_trabalho,
tm.cd_turma,
t.cd_nivel,
tn.ds_nivel,
ti.cd_etapa,
te2.ds_etapa,
1 fl_multseriado,
case
when cd_turno = 4 then 1
when cd_turno = 1 then 2
when cd_turno = 2 then 3
when cd_turno in (5,8,9) then 4
when cd_turno = 3 then 5
when cd_turno = 7 then 6 end cd_turno,
case when cd_turno in (8,9) then 'Integral' else ds_turno end ds_turno,
tm.cd_aluno
from academico.tb_aluno_multiseriacao tm
join academico.tb_turma t on tm.cd_turma = ci_turma
join academico.tb_item ti on tm.cd_item=ti.ci_item
join academico.tb_nivel tn on tn.ci_nivel = t.cd_nivel 
join academico.tb_etapa te2 on te2.ci_etapa = ti.cd_etapa 
join academico.tb_turno on ci_turno = cd_turno
where 
t.nr_anoletivo = 2022
and t.cd_prefeitura  = 0
), 
outras as (
select
tt.nr_anoletivo,
tt.cd_unidade_trabalho,
tu.cd_turma,
cd_nivel,
tn.ds_nivel,
tt.cd_etapa,
te.ds_etapa,
0 fl_multseriado,
case
when cd_turno = 4 then 1
when cd_turno = 1 then 2
when cd_turno = 2 then 3
when cd_turno in (5,8,9) then 4
when cd_turno = 3 then 5
when cd_turno = 7 then 6 end cd_turno,
case when cd_turno in (8,9) then 'Integral' else ds_turno end ds_turno,
tu.cd_aluno
from academico.tb_ultimaenturmacao tu
join academico.tb_turma tt on tu.cd_turma = ci_turma
join academico.tb_etapa te on te.ci_etapa = tt.cd_etapa 
join academico.tb_nivel tn on tn.ci_nivel = tt.cd_nivel 
join academico.tb_turno on ci_turno = cd_turno
where 
tt.nr_anoletivo = 2022
and tt.cd_prefeitura  = 0
and not exists (select 1 from mult where tu.cd_aluno = mult.cd_aluno)
),
aluno_etapa as(
select * from mult
union
select * from outras
), etapas_padronizadas as(
select
nr_anoletivo,
cd_turma id_turma_sige,
cd_nivel cd_nivel_sige,
ds_nivel ds_nivel_sige,
cd_etapa cd_etapa_sige,
ds_etapa ds_etapa_sige,
fl_multseriado,
cd_turno,
ds_turno,
case when cd_etapa in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
      									             then 1
	  when cd_etapa in (213,214,195,194,175,196,174,173)  then 2 else 99 end cd_oferta_ensino,
      
case when cd_etapa in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
      									             then 'Ensino Regular'
when cd_etapa in (213,214,195,194,175,196,174,173)  then 'EJA' else 'Não se aplica' end ds_oferta_ensino,
case when cd_nivel = 28 then 1
     when cd_nivel = 26 then 2
     when cd_nivel = 27 and cd_etapa<>137 then 3 else 99 end cd_etapa_aluno,
case when cd_nivel = 28 then 'Educação Infantil'
     when cd_nivel = 26 then 'Ensino Fundamental'
     when cd_nivel = 27 and cd_etapa<>137 then 'Ensino Médio' else 'Não se aplica' end ds_etapa_aluno,
case when cd_etapa in (121,122,123,124,125,172,194) then 1
     when cd_etapa in (126,127,128,129,174,195)     then 2
     when cd_etapa  = 175                           then 3 else 99 end cd_subetapa,
case when cd_etapa in (121,122,123,124,125,172,194) then 'Anos Iniciais'
     when cd_etapa in (126,127,128,129,174,195)     then 'Anos Finais'
     when cd_etapa  = 175                           then 'Anos Iniciais e Anos Finais' else 'Não se aplica' end ds_subetapa,
case 
     when cd_etapa = 121 then 1
     when cd_etapa = 122 then 2
     when cd_etapa = 123 then 3
     when cd_etapa = 124 then 4
     when cd_etapa = 125 then 5
     when cd_etapa = 126 then 6
     when cd_etapa = 127 then 7
     when cd_etapa = 128 then 8
     when cd_etapa = 129 then 9
     when cd_etapa in(162,184,188) then 10
     when cd_etapa in(163,185,189) then 11
     when cd_etapa in(164,186,190) then 12
     when cd_etapa in(165,187,191) then 13 else 99 end cd_ano_serie,
case 
     when cd_etapa = 121 then ' 1º Ano'
     when cd_etapa = 122 then ' 2º Ano'
     when cd_etapa = 123 then ' 3º Ano'
     when cd_etapa = 124 then ' 4º Ano'
     when cd_etapa = 125 then ' 5º Ano'
     when cd_etapa = 126 then ' 6º Ano'
     when cd_etapa = 127 then ' 7º Ano'
     when cd_etapa = 128 then ' 8º Ano'
     when cd_etapa = 129 then ' 9º Ano'
     when cd_etapa in(162,184,188) then '1ª Série'
     when cd_etapa in(163,185,189) then '2ª Série'
     when cd_etapa in(164,186,190) then '3ª Série'
     when cd_etapa in(165,187,191) then '4ª Série' else 'Não se aplica' end ds_ano_serie,
cd_aluno
from aluno_etapa 
)
select * from etapas_padronizadas