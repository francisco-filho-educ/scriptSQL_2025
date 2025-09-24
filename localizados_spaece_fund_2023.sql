with alunos as (
select
b.cd_inep_aluno, 
case when cd_inep_aluno =	215464341003	then	144657402470	
        when cd_inep_aluno =	178713415297	then	179193315529	
        when cd_inep_aluno =	214361044161	then	202705735427	
        when cd_inep_aluno =	214697999361	then	151994668287	
        when cd_inep_aluno =	218582594796	then	122437856330	
        when cd_inep_aluno =	214449510761	then	130083489800	
        when cd_inep_aluno =	185572933995	then	183414119110	
        when cd_inep_aluno =	218088587350	then	122208296507	
        when cd_inep_aluno =	218088579250	then	124092455100	
        when cd_inep_aluno =	215685043900	then	183472735880	
        when cd_inep_aluno =	215691443389	then	127825619284	
        when cd_inep_aluno =	215691309143	then	176270915600	
        when cd_inep_aluno =	215691498876	then	183008848310	
        when cd_inep_aluno =	215691492401	then	176272929489	
        when cd_inep_aluno =	215684715727	then	183467703673	
        when cd_inep_aluno =	215730723898	then	183215126230	end co_pessoa_fisica,
nm_aluno,
nm_pai_aluno,
nm_mae_aluno 
from spaece_aplicacao_2023.base_aplicacao_spaece_fundamental_2023_08_30 b
where b.cd_inep_aluno in (215464341003,
178713415297,
214361044161,
214697999361,
218582594796,
214449510761,
185572933995,
218088587350,
218088579250,
215685043900,
215691443389,
215691309143,
215691498876,
215691492401,
215684715727,
215730723898) 
) 
,credes_reg as (
select 
co_entidade,
case when tte.co_orgao_regional not ilike '%021R%' then co_orgao_regional else concat(2,substring(co_orgao_regional,5,5)) end::int id_crede_regiao
from censo_esc_d.tb_tb_escola_2023 tte 
where tte.co_orgao_regional is not null 
)
,credes_sefor as (
select 
tde.ds_orgao_regional co_orgao_regional,
id_crede_sefor,
nm_crede_sefor
from dw_censo.tb_dm_escola tde 
where tde.nr_ano_censo = 2022 and tde.nm_crede_sefor is not null and tde.id_crede_sefor >20
and tde.cd_categoria_escola_sige  = 8
group by 1,2,3
)
,deficiencias as(
select  co_pessoa_fisica, 'Baixa visão' ds_deficiencia 
from censo_esc_d.tb_matricula_2023 bs 
 where bs.in_baixa_visao = 1
union
select  co_pessoa_fisica, 'Cegueira'   ds_deficiencia
from censo_esc_d.tb_matricula_2023 bs 
 where in_cegueira::int = 1 
union
select  co_pessoa_fisica,  'Deficiência auditiva'   ds_deficiencia
from censo_esc_d.tb_matricula_2023 bs 
 where in_def_auditiva::int = 1
union
select  co_pessoa_fisica, 'Deficiência física'   ds_deficiencia
from censo_esc_d.tb_matricula_2023 bs 
 where in_def_fisica::int = 1 
union
select  co_pessoa_fisica, 'Surdez'   ds_deficiencia
from censo_esc_d.tb_matricula_2023 bs 
 where in_surdez::int = 1 
union
select  co_pessoa_fisica, 'Surdocegueira'   ds_deficiencia
from censo_esc_d.tb_matricula_2023 bs 
 where in_surdocegueira::int = 1 
union
select  co_pessoa_fisica, 'Deficiência intelectual'   ds_deficiencia
from censo_esc_d.tb_matricula_2023 bs 
 where in_def_intelectual::int = 1 
union
select  co_pessoa_fisica, 'Deficiência multipla'   ds_deficiencia
from censo_esc_d.tb_matricula_2023 bs 
 where in_def_multipla::int = 1 
union
select  co_pessoa_fisica, 'Autismo'   ds_deficiencia
from censo_esc_d.tb_matricula_2023 bs 
 where bs.in_autismo ::int = 1 
union
select  co_pessoa_fisica, 'Superdotacao' ds_deficiencia
from censo_esc_d.tb_matricula_2023 bs  -- COMPLEMENTO DA VARIAVEL QUE FALTOU NA BASE INEP
where in_superdotacao::int = 1 
)
,alunos_def as (
select 
co_pessoa_fisica,
string_agg(ds_deficiencia,', ') ds_deficiencias
from deficiencias
group by 1
)
,recurso as (
select co_pessoa_fisica,  'LEDOR'   ds_recurso from censo_esc_d.tb_matricula_2023  where in_recurso_ledor = 1 union
select co_pessoa_fisica,  'TRANSCRICAO'   ds_recurso from censo_esc_d.tb_matricula_2023  where in_recurso_transcricao = 1 union
select co_pessoa_fisica,  'INTERPRETE'   ds_recurso from censo_esc_d.tb_matricula_2023  where in_recurso_interprete = 1 union
select co_pessoa_fisica,  'LIBRAS'   ds_recurso from censo_esc_d.tb_matricula_2023  where in_recurso_libras = 1 union
select co_pessoa_fisica,  'LABIAL'   ds_recurso from censo_esc_d.tb_matricula_2023  where in_recurso_labial  = 1 union
select co_pessoa_fisica,  'AMPLIADA 18'   ds_recurso from censo_esc_d.tb_matricula_2023  where in_recurso_ampliada_18 = 1 union
select co_pessoa_fisica,  'AMPLIADA 24'   ds_recurso from censo_esc_d.tb_matricula_2023  where in_recurso_ampliada_24 = 1 union
select co_pessoa_fisica,  'CD AUDIO'   ds_recurso from censo_esc_d.tb_matricula_2023  where in_recurso_cd_audio = 1 union
select co_pessoa_fisica,  'PROVA PORTUGUES'   ds_recurso from censo_esc_d.tb_matricula_2023  where in_recurso_prova_portugues = 1 union
--select co_pessoa_fisica,  'VIDEO LIBRAS'   ds_recurso from censo_esc_d.tb_matricula_2023  where recurso_video_libras = 1 union
select co_pessoa_fisica,  'BRAILLE'   ds_recurso from censo_esc_d.tb_matricula_2023  where in_recurso_braille = 1 
)
,aluno_recurso as (
select 
co_pessoa_fisica,
string_agg(ds_recurso, ', ') ds_recursos
from recurso
group by 1
)
select --count(1) --304886
'CE' nm_uf,
cc.id_crede_regiao cd_distrito,
trim(case when id_crede_regiao <21 then 'CREDE '||nm_crede_sefor_municipio else tte.co_orgao_regional end)  nm_distrito,
case when id_crede_regiao < 21 then id_crede_regiao else cs.id_crede_sefor end cd_regional,
case when id_crede_regiao < 21 then tcm.nm_crede_sefor else cs.nm_crede_sefor end nm_regional,
id_municipio cd_municipio,
nm_municipio,
co_entidade cd_escola,
no_entidade nm_escola,
case when  tte.tp_dependencia = 2 then 'Estadual' else 'Municipal' end dc_rede_ensino,
case when tte.tp_dependencia = 1 then 'Urbano' else 'Rural' end dc_localizacao,
bs.id_turma cd_turma,
no_turma nm_turma,
--tt.tp_etapa_ensino cd_etapa_ensino_turma,
tde_a.ds_etapa_ensino dc_etapa,
tde_t.ds_etapa_ensino dc_etapa_ensino_turma,
case when bs.in_eja = 1 then 'EJA' else 'Regular' end dc_tipo_ensino,
case when tt.nu_duracao_turma >= 420 then 'INTEGRAL' else 
    case when concat(tx_hr_inicial,':',tx_mi_inicial)::time < '11:30:00'::time 
       and tx_hr_inicial::int<>1 then 'MANHÃ'
      when (concat(tx_hr_inicial,':',tx_mi_inicial)::time > '11:30:00'::time 
         and concat(tx_hr_inicial,':',tx_mi_inicial)::time < '17:30:00'::time) 
         or tx_hr_inicial::int = 1 then 'TARDE'
      when concat(tx_hr_inicial,':',tx_mi_inicial)::time > '17:30:00'::time then 'NOITE' 
         end end dc_turno,
'' nm_professor,
case when tt.tp_etapa_ensino in (56,22)  then 1 else 0 end FL_MULTISSERIADA,
case when tt.tp_tipo_local_turma = 1 then 1 else 0 end  FL_ANEXO,
'' nm_anexo,
cd_inep_aluno,
NM_ALUNO,
to_char(concat(nu_ano,'-',nu_mes,'-',nu_dia)::date,'dd/mm/yyyy') DT_NASCIMENTO,
case when tp_sexo = 1 then 'Masculino' else 'Feminino' end dc_sexo,
nm_mae_aluno,
bs.tp_cor_raca as CD_COR_RACA,
case when tp_cor_raca = 0 then 'NÃO DECLARADA'
     when tp_cor_raca = 1 then 'BRANCA'
     when tp_cor_raca = 2 then 'PRETA'
     when tp_cor_raca = 3 then 'PARDA'
     when tp_cor_raca = 4 then 'AMARELA'
     when tp_cor_raca = 5 then 'INDÍGENA' end as DS_COR_RACA,
nm_pai_aluno,
NULL tp_deficiencia,
ds_deficiencias,
ds_recursos
from censo_esc_d.tb_matricula_2023 bs
join alunos a using(co_pessoa_fisica)
join censo_esc_d.tb_turma_2023 tt using(id_turma,co_entidade)
join censo_esc_d.tb_tb_escola_2023 tte using(co_entidade)
join credes_reg cc using(co_entidade)
left join dw_censo.tb_dm_credes_sefor tcm on tcm.id_crede_sefor = cc.id_crede_regiao 
left join credes_sefor cs using(co_orgao_regional)
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tte.co_municipio 
join dw_censo.tb_dm_etapa tde_a on tde_a.cd_etapa_ensino = bs.tp_etapa_ensino 
join dw_censo.tb_dm_etapa tde_t on tde_t.cd_etapa_ensino = tt.tp_etapa_ensino 
left join alunos_def def on bs.co_pessoa_fisica = def.co_pessoa_fisica
left join aluno_recurso rec on bs.co_pessoa_fisica = rec.co_pessoa_fisica
where tde_a.cd_ano_serie in (2,5,9)
and bs.tp_dependencia in (2,3)
and tt.tp_tipo_local_turma not in (2,3) -- retira as turmas prisionais


