with principal as (
select 
--Órgão Regional
te.co_orgao_regional::text,
--Código da Escola
te.co_entidade,
--Nome da Escola
te.no_entidade ,
--Dependência administrativa
case when te.tp_dependencia = 1  then 'Federal'
     when te.tp_dependencia = 2  then 'Estadual'
     when te.tp_dependencia = 3  then 'Municipal'
     when te.tp_dependencia = 4  then 'Privada' end ds_dependencia,
--Localização
 case when te.tp_dependencia = 1 then 'Urbana' else 'Rural' end ds_localizacao,
--Endereço
 tce.ds_endereco, 
--Número
 tce.nu_endereco,
--Complemento
 tce.ds_complemento,
--Bairro
 tce.no_bairro,
--CEP
 tce.co_cep,
--DDD
 tce.nu_ddd,
--Telefone
 tce.nu_telefone,
--Outro telefone
null nu_telefone_outro,
--E-mail
 tce.tx_email,
--Creche
sum(case when tp_etapa_ensino = 1 then 1 else 0 end) nr_creche,
sum(case when tp_etapa_ensino = 2 then 1 else 0 end) nr_pre,
--Pré-escola
sum(case when cd_ano_serie = 	1	Then 1 else 0 end)	Serie_1,
sum(case when cd_ano_serie = 	2	Then 1 else 0 end)	Serie_2,
sum(case when cd_ano_serie = 	3	Then 1 else 0 end)	Serie_3,
sum(case when cd_ano_serie = 	4	Then 1 else 0 end)	Serie_4,
sum(case when cd_ano_serie = 	5	Then 1 else 0 end)	Serie_5,
sum(case when cd_ano_serie = 	6	Then 1 else 0 end)	Serie_6,
sum(case when cd_ano_serie = 	7	Then 1 else 0 end)	Serie_7,
sum(case when cd_ano_serie = 	8	Then 1 else 0 end)	Serie_8,
sum(case when cd_ano_serie = 	9	Then 1 else 0 end)	Serie_9,
--Ensino Médio
 sum(case when cd_etapa = 3 and tm.in_regular  = 1 then 1 else 0 end) medio_regular,
--Curso FIC Integrado na modalidade EJA - Nível Fundamental
 sum(case when tp_etapa_ensino = 73 then 1 else 0 end) fic_fund,
--Curso FIC integrado na modalidade EJA - Nível Médio
 sum(case when tp_etapa_ensino = 67 then 1 else 0 end) fic_medio,
--Curso FIC concomitante
 sum(case when tp_etapa_ensino = 68 then 1 else 0 end) fic_conc,
--Curso Técnico Integrado (Ensino Médio Integrado)
 sum(case when tp_etapa_ensino in (30,31,32,33,34) then 1 else 0 end) medio_integrado,
--Curso Técnico Integrado na modalidade EJA (EJA integrada à Educação Profissional)
 sum(case when tp_etapa_ensino = 74 then 1 else 0 end) eja_intregada,
--Curso Técnico Concomitante ou Subsequente
 sum(case when tp_etapa_ensino = 74 then 1 else 0 end) eja_intregada,
--EJA
--Fundamental anos iniciais – Presencial
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa_fase = 3 and tm.tp_mediacao_didatico_pedago = 1 then 1 else 0 end) eja_ai_pres,
--Fundamental anos finais – Presencial
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa_fase = 4 and tm.tp_mediacao_didatico_pedago = 1 then 1 else 0 end) eja_af_pres,
--Médio – Presencial
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa = 3 and tm.tp_mediacao_didatico_pedago = 1 then 1 else 0 end) eja_medio_pres,
--Fundamental anos iniciais – Semipresencial 
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa_fase = 3 and tm.tp_mediacao_didatico_pedago = 2 then 1 else 0 end) eja_ai_semi,
--Fundamental anos finais – Semipresencial 
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa_fase = 4 and tm.tp_mediacao_didatico_pedago = 2 then 1 else 0 end) eja_af_semi, 
--Médio – Semipresencial 
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa = 3 and tm.tp_mediacao_didatico_pedago = 2 then 1 else 0 end) eja_medio_semi,
 --EAD
--Fundamental anos iniciais – Semipresencial 
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa_fase = 3 and tm.tp_mediacao_didatico_pedago = 3 then 1 else 0 end) eja_ai_ead,
--Fundamental anos finais – Semipresencial 
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa_fase = 4 and tm.tp_mediacao_didatico_pedago = 3 then 1 else 0 end) eja_af_ed, 
--Médio – Semipresencial 
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa = 3 and tm.tp_mediacao_didatico_pedago = 3 then 1 else 0 end) eja_medio_ead
from censo_esc_ce.tb_matricula_2023 tm 
join censo_esc_ce.tb_escola_2023 te using(nu_ano_censo,co_entidade)
left join censo_esc_ce.tb_catalogo_escolas_2022 tce using(co_entidade)
left join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where tm.co_municipio = 2304400
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
)
-- ESPECIAL 
,especial as (
select
co_entidade,
sum(case when tp_etapa_ensino = 1 then 1 else 0 end) nr_creche_esp,
sum(case when tp_etapa_ensino = 2 then 1 else 0 end) nr_pre_esp,
--Pré-escola
sum(case when cd_ano_serie = 	1	Then 1 else 0 end)	Serie_1_esp,
sum(case when cd_ano_serie = 	2	Then 1 else 0 end)	Serie_2_esp,
sum(case when cd_ano_serie = 	3	Then 1 else 0 end)	Serie_3_esp,
sum(case when cd_ano_serie = 	4	Then 1 else 0 end)	Serie_4_esp,
sum(case when cd_ano_serie = 	5	Then 1 else 0 end)	Serie_5_esp,
sum(case when cd_ano_serie = 	6	Then 1 else 0 end)	Serie_6_esp,
sum(case when cd_ano_serie = 	7	Then 1 else 0 end)	Serie_7_esp,
sum(case when cd_ano_serie = 	8	Then 1 else 0 end)	Serie_8_esp,
sum(case when cd_ano_serie = 	9	Then 1 else 0 end)	Serie_9_esp,
--Ensino Médio
 sum(case when cd_etapa = 3 and tm.in_regular  = 1 then 1 else 0 end) medio_regular_esp,
--Curso FIC Integrado na modalidade EJA - Nível Fundamental
 sum(case when tp_etapa_ensino = 73 then 1 else 0 end) fic_fund_esp,
--Curso FIC integrado na modalidade EJA - Nível Médio
 sum(case when tp_etapa_ensino = 67 then 1 else 0 end) fic_medio_esp,
--Curso FIC concomitante
 sum(case when tp_etapa_ensino = 68 then 1 else 0 end) fic_conc_esp,
--Curso Técnico Integrado (Ensino Médio Integrado)
 sum(case when tp_etapa_ensino in (30,31,32,33,34) then 1 else 0 end) medio_integrado_esp,
--Curso Técnico Integrado na modalidade EJA (EJA integrada à Educação Profissional)
 sum(case when tp_etapa_ensino = 74 then 1 else 0 end) eja_intregada_esp,
--Curso Técnico Concomitante ou Subsequente
 sum(case when tp_etapa_ensino = 74 then 1 else 0 end) eja_intregada_esp,
--EJA
--Fundamental anos iniciais – Presencial
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa_fase = 3 and tm.tp_mediacao_didatico_pedago = 1 then 1 else 0 end) eja_ai_pres_esp,
--Fundamental anos finais – Presencial
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa_fase = 4 and tm.tp_mediacao_didatico_pedago = 1 then 1 else 0 end) eja_af_pres_esp,
--Médio – Presencial
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa = 3 and tm.tp_mediacao_didatico_pedago = 1 then 1 else 0 end) eja_medio_pres_esp,
--Fundamental anos iniciais – Semipresencial 
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa_fase = 3 and tm.tp_mediacao_didatico_pedago = 2 then 1 else 0 end) eja_ai_semi_esp,
--Fundamental anos finais – Semipresencial 
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa_fase = 4 and tm.tp_mediacao_didatico_pedago = 2 then 1 else 0 end) eja_af_semi_esp, 
--Médio – Semipresencial 
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa = 3 and tm.tp_mediacao_didatico_pedago = 2 then 1 else 0 end) eja_medio_semi_esp,
 --EAD
--Fundamental anos iniciais – Semipresencial 
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa_fase = 3 and tm.tp_mediacao_didatico_pedago = 3 then 1 else 0 end) eja_ai_ead_esp,
--Fundamental anos finais – Semipresencial 
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa_fase = 4 and tm.tp_mediacao_didatico_pedago = 3 then 1 else 0 end) eja_af_ed_esp, 
--Médio – Semipresencial 
 sum(case when tm.IN_EJA = 1 and tde.cd_etapa = 3 and tm.tp_mediacao_didatico_pedago = 3 then 1 else 0 end) eja_medio_ead_esp
from censo_esc_ce.tb_matricula_2023 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
where in_necessidade_especial = 1
group by 1
)
,complem_aee as (
select
co_entidade, 
-- Atividade complementar	
sum(case when tm.tp_tipo_atendimento_turma = 3  then 1 else 0 end) nr_atc,
-- AEE
sum(case when tm.tp_tipo_atendimento_turma = 4  then 1 else 0 end) nr_aee
from censo_esc_ce.tb_matricula_2023 tm 
where tm.tp_tipo_atendimento_turma in (3,4)
group by 1
)
select 
p.*, 
e.*,
ae.*
from principal p
left join especial e using(co_entidade)
left join complem_aee ae using(co_entidade)