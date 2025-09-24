with credes as (
select
tde.ds_orgao_regional,nm_crede_sefor
from dw_censo.tb_dm_escola tde 
where tde.nr_ano_censo = 2020
and cd_dependencia = 2 and tde.ds_orgao_regional is not null
group by 1,2
)
select 
'CE' "NM_UF",
te.co_orgao_regional "CD_REGIONAL",
nm_crede_sefor "NM_REGIONAL",
id_municipio "CD_MUNICIPIO",
nm_municipio "NM_MUNICIPIO",
te.co_entidade "CD_ESCOLA",
te.no_entidade "NM_ESCOLA",
case when te.tp_dependencia = 2 then 'ESTADUAL' else 'MUNICIPAL' end "DC_REDE_ENSINO",
case when te.tp_localizacao  = 1 then 'URBANA' else 'RURAL' end "DC_LOCALIZACAO",
tt.id_turma "CD_TURMA",
tt.no_turma "NM_TURMA",
case when cd_ano_serie = 1 then '2º ANO - ENSINO FUNDAMENTAL'
	 when cd_ano_serie = 4 then '5º ANO - ENSINO FUNDAMENTAL'
	 when cd_ano_serie = 8 then '9º ANO - ENSINO FUNDAMENTAL'
     when cd_ano_serie = 11 then '3ª SÉRIE - ENSINO MÉDIO' END "DC_ETAPA",
'REGULAR' "DC_TIPO_ENSINO",
case when concat(tt.tx_hr_inicial,':',tt.tx_mi_inicial)::time < '11:30:00'::time 
       and tt.tx_hr_inicial::int<>1 then 'MANHA'
      when (concat(tt.tx_hr_inicial,':',tt.tx_mi_inicial)::time > '11:30:00'::time 
         and concat(tt.tx_hr_inicial,':',tt.tx_mi_inicial)::time < '17:30:00'::time) 
         or tt.tx_hr_inicial::int = 1 then 'TARDE' 
      when concat(tt.tx_hr_inicial,':',tt.tx_mi_inicial)::time > '17:30:00'::time then 'NOITE'
         end "DC_TURNO",
'' "NM_PROFESSOR",
case when tt.tp_etapa_ensino = 22 then 1 else 0 end "FL_MULTISSERIADA",
case when tt.tp_tipo_local_turma  = 1 then 1 else 0 end "FL_ANEXO",
'' "NM_ANEXO",
count(1) "QT_ALUNO",
sum(case when tm.in_cegueira = 1 then 1 else 0 end) "QT_ALUNO_CEGOS",
sum(case when tm.in_baixa_visao = 1 then 1 else 0 end) "QT_ALUNO_BAIXA_VISAO",
sum(case when tm.in_surdez = 1 or tm.in_def_auditiva = 1 then 1 else 0 end) "QT_ALUNO_SURDEZ",
sum(case when tm.in_surdocegueira = 1 then 1 else 0 end) "QT_ALUNO_SURDOCEGUEIRA"
--select distinct (co_orgao_regional)
from censo_esc_d.tb_matricula tm 
join censo_esc_d.tb_turma tt on tt.id_turma = tm.id_turma 
join censo_esc_d.tb_escola te on te.co_entidade = tt.co_entidade 
join dw_censo.tb_dm_etapa tet on tet.cd_etapa_ensino = tm.tp_etapa_ensino 
left join credes on te.co_orgao_regional  = ds_orgao_regional
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = te.co_municipio 
where 
tm.nu_ano_censo = 2021
and tm.tp_dependencia in (2,3)
and cd_ano_serie in (1,4,8,11)
and tm.in_regular = 1
and (tm.in_surdez = 1 or tm.in_def_auditiva = 1 or tm.in_surdocegueira = 1 or tm.in_baixa_visao = 1 or tm.in_cegueira = 1 )
--and (IN_RECURSO_BRAILLE = 1 or IN_RECURSO_AMPLIADA_18  = 1  or IN_RECURSO_AMPLIADA_24 = 1 )
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18 ---19,20,21