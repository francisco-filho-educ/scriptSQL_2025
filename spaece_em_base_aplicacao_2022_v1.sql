with 
turmas as (
select *
from academico.tb_turma tt
where nr_anoletivo = 2022
and cd_nivel = 27
and ((tt.cd_etapa=214 or tt.cd_anofinaleja=2) or cd_etapa in (180,190,186))
),
extensao as (
select
     tt.ci_turma, 
     tlf.nm_local_funcionamento,
     tlf.ci_local_funcionamento
     from turmas tt
     join rede_fisica.tb_ambiente ta on tt.cd_ambiente=ta.ci_ambiente
     join rede_fisica.tb_local_unid_trab lut on lut.cd_local_funcionamento = ta.cd_local_funcionamento 
     join rede_fisica.tb_local_funcionamento tlf on tlf.ci_local_funcionamento = lut.cd_local_funcionamento 
     where tt.nr_anoletivo = 2021
     and lut.fl_sede = false
     and cd_nivel in (27,26,28)
     and tt.cd_prefeitura = 0
     group by 1,2,3
),
regiao as (
select 
tut.ci_unidade_trabalho,
tac.cod_crede_censo
from util.tb_unidade_trabalho tut 
join educacenso_exp.tb_associativa_crede tac on tac.cd_regiao  = tut.cd_unidade_trabalho_pai
where tut.cd_unidade_trabalho_pai <21 and tut.cd_dependencia_administrativa =2
union 
select 
tut.ci_unidade_trabalho,
tac.ds_crede_censo
from util.tb_unidade_trabalho tut 
join educacenso_exp.tb_associativa_crede tac on tac.cd_regiao  = tut.cd_regiao 
where tut.cd_unidade_trabalho_pai >20  and tut.cd_dependencia_administrativa =2
),
escolas as (
SELECT 
crede.ci_unidade_trabalho, 
cod_crede_censo,
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
case when tut.cd_categoria is null then 'Não se aplica'
           when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
	       when  tut.ci_unidade_trabalho = 47258 then 'CREAECE' else upper(tc.nm_categoria) end AS ds_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao ,tut.cd_tipo_unid_trab
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join regiao r on r.ci_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab =401
AND tlut.fl_sede = TRUE 
) select * from escolas






/*
select
     case
          when tut.cd_unidade_trabalho_pai >= 21 
               then ( select tac.cod_crede_censo from educacenso_exp.tb_associativa_crede tac where tac.cod_crede_seduc = 21 and tac.cd_regiao = tut.cd_regiao limit 1)
               else ( select tac.cod_crede_censo from educacenso_exp.tb_associativa_crede tac  where tac.cod_crede_seduc = tut.cd_unidade_trabalho_pai limit 1) end as "ORGAO_REGIONAL",
          tut.cd_unidade_trabalho_pai "ID_CREDE_SEFOR",   
          tutpai.nm_sigla "NM_CREDE_SEFOR",       
          ds_localidade  "NM_MUNICIPIO",
     cd_inep "ID_MUNICIPIO",
     'ESTADUAL' "DS_DEPENDENCIA",
     case when tut.cd_localizacao = '1' then 'Urbana' 
          when  tut.cd_localizacao = '2' then 'Rural'  Else 'Indefinido' end "DS_LOCALIZACAO",
     tut.nr_codigo_unid_trab  "ID_ESCOLA",
     tut.nm_unidade_trabalho "NM_ESCOLA",
     ds_turma "NM_TURMA",
     tt.ci_turma "ID_TURMA", 
     tt.dt_horainicio "TX_HR_INICIAL",
     tt.dt_horafim "TX_HR_FINAL",
     case when (to_timestamp(to_char(tt.dt_horafim,'HH24:MI:SS'),'HH24:MI:SS') - to_timestamp(to_char(tt.dt_horainicio,'HH24:MI:SS'),'HH24:MI:SS'))>='07:00:00' then 'Integral' 
          else 'Parcial' end "DS_TEMPO", 
          tt.cd_turno "CD_TURNO",
          ds_turno "NM_TURNO",     
     case when (tt.cd_etapa=214 or tt.cd_anofinaleja=2) then 'Ensino Médio ano II'
               when cd_etapa in (180,190) then 'Ensino Medio 3ª Série'
               when cd_etapa = 186 then 'Ensino Médio - Integrado 3ª Serie' end "DS_ETAPA_SERIE",  
     case when (tt.cd_etapa=214 or tt.cd_anofinaleja=2) then 72 
          when cd_etapa in (180,190) then 27
          when cd_etapa = 186 then 32 end "TP_ETAPA_ENSINO", 
     ds_modalidade "DS_MODALIDADE",
     ci_aluno "CD_ALUNO_SIGE",
     cd_inep_aluno "CO_PESSOA_FISICA",
     tue.cd_aluno "CD_ALUNO_SIGE",
     --nr_cpf "NR_CPF",
     nm_aluno "NM_ALUNO",
     dt_nascimento "DT_NASCIMENTO",
     case when fl_sexo = 'M' then 1
          when fl_sexo = 'F' then 2 end "CD_SEXO",
     case when fl_sexo = 'M' then 'Masculino'
          when fl_sexo = 'F' then 'Feminino' end "DS_SEXO",
          --verifcar cor raca
     cd_raca "CD_COR_RACA",    
     case when cd_raca = 1 then 'Nao Declarada'
          when cd_raca = 2 then 'Branca'
          when cd_raca = 3 then 'Preta'
          when cd_raca = 4 then 'Parda'
          when cd_raca = 5 then 'Amarela'
          when cd_raca = 6 then 'Indigena' 
     end "DS_COR_RACA",
     nm_mae "NM_MAE",
     nm_pai "NM_PAI",
     case when cd_deficiencia between 1 and 13 then 'Sim' else 'Não' end "DS_POSSUI_DEFICIENCIA",
     nm_deficiencia "NM_DEFICIENCIA",
     nm_curso "NM_CURSO_PROFISSIONAL",
     nm_local_funcionamento "NM_EXTENSAO"*/
select ds_etapa, count(1)
from academico.tb_ultimaenturmacao tue
join academico.tb_turma tt on tt.ci_turma = tue.cd_turma  
join util.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho
join util.tb_unidade_trabalho tutpai on tutpai.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
join academico.tb_aluno a on tue.cd_aluno = a.ci_aluno
join util.tb_localidades   on ci_localidade = tut.cd_municipio
join academico.tb_turno on ci_turno=tt.cd_turno
join academico.tb_etapa on tt.cd_etapa = ci_etapa
join util.tb_subcategoria on tut.cd_subcategoria = ci_subcategoria
join academico.tb_modalidade on tt.cd_modalidade = ci_modalidade
left join academico.tb_aluno_deficiencia def on def.cd_aluno = ci_aluno
left join academico.tb_deficiencia on def.cd_deficiencia = ci_deficiencia
left join academico.tb_aluno_recurso_espec_aval talr ON talr.cd_aluno = tue.cd_aluno
left join academico.tb_curso c on tt.cd_curso = ci_curso
left join extensao ex on ex.ci_turma = tt.ci_turma  
where 1 = 1
     and tue.nr_anoletivo = 2022
     and fl_tipo_atividade <> 'AC'
     and cd_prefeitura = 0
     and cd_nivel = 27
     and tut.cd_tpunidade_trabalho = 1
     and tut.cd_dependencia_administrativa > 3      
     and (tt.cd_etapa=214 or tt.cd_anofinaleja=2) or cd_etapa in (180,190,186)
group by 1
              
              
             