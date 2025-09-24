/*
 * SERVIDOR SEDUC ASTIM
 */
with mat as (
select 
case when tt.cd_turno in (5,8,9) then 'Integral' else ds_turno end ds_turno,
case when tt.cd_etapa in (180,181) OR (tt.cd_etapa = 177) then 0
     when tt.cd_etapa = 121 then 1 
     when tt.cd_etapa = 122 then 2 
     when tt.cd_etapa = 123 then 3 
     when tt.cd_etapa = 124 then 4 
     when tt.cd_etapa = 125 then 5 
     when tt.cd_etapa = 126 then 6 
     when tt.cd_etapa = 127 then 7 
     when tt.cd_etapa = 128 then 8 
     when tt.cd_etapa = 129 then 9 
     when tt.cd_etapa = 183 and tt.cd_nivel  =  26 then  10
     when  tt.cd_etapa between 212 and 129 or (tt.cd_etapa = 183 and tt.cd_nivel = 26)  then 11
     when tt.cd_etapa in (162,184,188,137) then 12
     when tt.cd_etapa in (163,185,189) then 13
     when tt.cd_etapa in (164,186,190) then 14
     when tt.cd_etapa in (165,187,191) then 15
     when tt.cd_etapa in (162,184,188,163,185,189,164,186,190,165,187,191) then 16
     when tt.cd_etapa in (194,195,175,196,213,214) then 17
     when tt.cd_etapa in (173,174) then 18 end cd_orde,
case when tt.cd_etapa in (180,181) OR (tt.cd_etapa = 177) then 'Educação Infantil'
     when tt.cd_etapa = 121 then  '1º Ano EF' 
     when tt.cd_etapa = 122 then  '2º Ano EF' 
     when tt.cd_etapa = 123 then  '3º Ano EF' 
     when tt.cd_etapa = 124 then  '4º Ano EF' 
     when tt.cd_etapa = 125 then  '5º Ano EF' 
     when tt.cd_etapa = 126 then  '6º Ano EF' 
     when tt.cd_etapa = 127 then  '7º Ano EF' 
     when tt.cd_etapa = 128 then  '8º Ano EF' 
     when tt.cd_etapa = 129 then  '9º Ano EF' 
     when tt.cd_etapa = 183 and tt.cd_nivel  =  26 then  'Multiseriado'
     --when  tt.cd_etapa between 221 and 129 or (tt.cd_etapa = 183 and tt.cd_nivel = 26)  then 'TOTAL EF'
     when tt.cd_etapa in (162,184,188,137) then '1ª Série EM'
     when tt.cd_etapa in (163,185,189) then '2ª Série EM'
     when tt.cd_etapa in (164,186,190) then '3ª Série EM'
     when tt.cd_etapa in (165,187,191) then '4ª Série EM'
     --when tt.cd_etapa in (162,184,188,163,185,189,164,186,190,165,187,191) then 'TOTAL EM'
     when tt.cd_etapa in (194,195,175,196,213,214) then 'EJA – ESCOLA'
     when tt.cd_etapa in (173,174) then 'CEJA - SEMI' end ds_serie,
count(1) nr_mat
from public.tb_dm_etapa_aluno_2022_09_02 tdea 
join academico.tb_turma tt on tt.ci_turma = tdea.cd_turma 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
join academico.tb_etapa on ci_etapa = tt.cd_etapa
group by 1,2,3
) 
select * from mat 
where 1=1 
--and ds_turno  ilike 'int%'  
--and cd_orde >16 
order by 2 


/*
 * SERVIDOR CEIPE
 */

select
ds_turno,
case when tt.cd_etapa_sige in (180,181) OR (tt.cd_etapa_sige = 177) then 1
     when tt.cd_etapa_sige = 121 then 1 
     when tt.cd_etapa_sige = 122 then 2 
     when tt.cd_etapa_sige = 123 then 3 
     when tt.cd_etapa_sige = 124 then 4 
     when tt.cd_etapa_sige = 125 then 5 
     when tt.cd_etapa_sige = 126 then 6 
     when tt.cd_etapa_sige = 127 then 7 
     when tt.cd_etapa_sige = 128 then 8 
     when tt.cd_etapa_sige = 129 then 9 
     when tt.cd_etapa_sige = 183 and tt.cd_nivel  =  26 then  10
     when  tt.cd_etapa_sige between 212 and 129 or (tt.cd_etapa_sige = 183 and tt.cd_nivel = 26)  then 11
     when tt.cd_etapa_sige in (162,184,188,137) then 12
     when tt.cd_etapa_sige in (163,185,189) then 13
     when tt.cd_etapa_sige in (164,186,190) then 14
     when tt.cd_etapa_sige in (165,187,191) then 15
     when tt.cd_etapa_sige in (162,184,188,163,185,189,164,186,190,165,187,191) then 16
     when tt.cd_etapa_sige in (194,195,175,196,213,214) then 17
     when tt.cd_etapa_sige in (173,174) then 18 end cd_orde,
case when tt.cd_etapa_sige in (180,181) OR (tt.cd_etapa_sige = 177) then 'Educação Infantil'
     when tt.cd_etapa_sige = 121 then  '1º Ano EF' 
     when tt.cd_etapa_sige = 122 then  '2º Ano EF' 
     when tt.cd_etapa_sige = 123 then  '3º Ano EF' 
     when tt.cd_etapa_sige = 124 then  '4º Ano EF' 
     when tt.cd_etapa_sige = 125 then  '5º Ano EF' 
     when tt.cd_etapa_sige = 126 then  '6º Ano EF' 
     when tt.cd_etapa_sige = 127 then  '7º Ano EF' 
     when tt.cd_etapa_sige = 128 then  '8º Ano EF' 
     when tt.cd_etapa_sige = 129 then  '9º Ano EF' 
     when tt.cd_etapa_sige = 183 and tt.cd_nivel  =  26 then  'Multiseriado'
     --when  tt.cd_etapa_sige between 221 and 129 or (tt.cd_etapa_sige = 183 and tt.cd_nivel = 26)  then 'TOTAL EF'
     when tt.cd_etapa_sige in (162,184,188,137) then '1ª Série EM'
     when tt.cd_etapa_sige in (163,185,189) then '2ª Série EM'
     when tt.cd_etapa_sige in (164,186,190) then '3ª Série EM'
     when tt.cd_etapa_sige in (165,187,191) then '4ª Série EM'
     --when tt.cd_etapa_sige in (162,184,188,163,185,189,164,186,190,165,187,191) then 'TOTAL EM'
     when tt.cd_etapa_sige in (194,195,175,196,213,214) then 'EJA – ESCOLA'
     when tt.cd_etapa_sige in (173,174) then 'CEJA - SEMI' end ds_serie,
sum(nr_ent) mat
from dw_sige.tb_cubo_matricula_2022 tt
where cd_nivel in (26,27,28)
group by 1,2,3

