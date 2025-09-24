with extensao as (
SELECT 
tt.ci_turma, 
1 "FL_ANEXO",
lut.cd_unidade_trabalho,
tut.nm_unidade_trabalho "NM_ANEXO"
from academico.tb_turma tt
join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = lut.cd_unidade_trabalho 
where tt.nr_anoletivo = 2021
and lut.fl_sede = false
and tt.cd_prefeitura = 0
and (tt.cd_etapa=214 or tt.cd_anofinaleja=2 or cd_etapa in (180,190,186))
),  turmas as (
select
tt.ci_turma "CD_TURMA",
tt.ds_turma "NM_TURMA",
case when (tt.cd_etapa=214 or tt.cd_anofinaleja=2) then 'Ensino Médio Ano II'
     when cd_etapa in (180,190) then 'Ensino Medio 3ª Série'
     when cd_etapa = 186 then 'Ensino Médio - Integrado 3ª Serie' end "DC_ETAPA",  
     
case when (tt.cd_etapa=214 or tt.cd_anofinaleja=2) then 'EJA' 
     when cd_etapa in (180,190,186) then 'Regular'
     end "DC_TIPO_ENSINO",                 
ds_turno "DC_TURNO",              
"NM_ANEXO",
count(1) "QT_ALUNO"             
         --select 
              from academico.tb_ultimaenturmacao tue
              join academico.tb_turma tt on tt.ci_turma = tue.cd_turma  
              join academico.tb_turno on ci_turno=tt.cd_turno
              join academico.tb_etapa on tt.cd_etapa = ci_etapa
              left join extensao ex on ex.ci_turma = tt.ci_turma   
              where 1 = 1
              and tue.nr_anoletivo = 2021
              and fl_tipo_atividade <> 'AC'
              -- and cd_inep_aluno is not null
              and cd_prefeitura = 0
              and cd_nivel = 27  
              and (tt.cd_etapa=214 or tt.cd_anofinaleja=2) or cd_etapa in (180,190,186)
group by 1,2,3,4,5,6
) select distinct "DC_TURNO" from TURMAS 
              
/*              
                CASE
            WHEN tut.cd_unidade_trabalho_pai >= 21 THEN ( SELECT tac.cod_crede_censo
               FROM educacenso_exp.tb_associativa_crede tac
              WHERE tac.cod_crede_seduc = 21 AND tac.cd_regiao = tut.cd_regiao
             LIMIT 1)
            ELSE ( SELECT tac.cod_crede_censo
               FROM educacenso_exp.tb_associativa_crede tac
              WHERE tac.cod_crede_seduc = tut.cd_unidade_trabalho_pai
             LIMIT 1)
        END AS "ORGAO_REGIONAL",
               tut.cd_unidade_trabalho_pai "ID_CREDE_SEFOR",   
              tutpai.nm_sigla "NM_CREDE_SEFOR",       
              ds_localidade  "NM_MUNICIPIO",
              cd_inep "ID_MUNICIPIO",
              'ESTADUAL' "DS_DEPENDENCIA",
              case when tut.cd_localizacao = '1' then 'Urbana' 
              when  tut.cd_localizacao = '2' then 'Rural'  Else 'Indefinido' end "DS_LOCALIZACAO",
              tut.nr_codigo_unid_trab  "ID_ESCOLA",
              tut.nm_unidade_trabalho "NM_ESCOLA",
              
              
 */
              -------