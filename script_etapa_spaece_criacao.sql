select  
distinct key_etapas
from base_identificada.tb_spaece_alinhado



select  
count(1)
from base_identificada.tb_spaece_alinhado v
where key_etapas ='23-ENSINO FUNDAMENTAL DE 9 ANOS - CORREÃ?Ã?O DE FLUXO-18-ENSINO FUNDAMENTAL DE 9 ANOS - 5Âº ANO- - ENSINO FUNDAMENTAL'



create table base_identificada.tb_spaece_alinhado_v2 as (
select * from base_identificada.tb_spaece_alinhado
left join public.etapa_spaece es using(cd_etapa_aplicacao_turma,cd_etapa_avaliada_turma,ds_etapa_serie_tabela)
where 
cd_etapa_aplicacao_turma is not null
and cd_etapa_avaliada_turma is not null
)

alter table base_identificada.tb_spaece_alinhado add key_etapas text; 


update base_identificada.tb_spaece_alinhado 
set key_etapas = concat(
cd_etapa_aplicacao_turma::text,
'**',
dc_etapa_aplicacao_turma,
'**',
cd_etapa_avaliada_turma::text,
'**',
dc_etapa_avaliada_turma,
'**',
ds_etapa_serie_tabela::text
)

alter table base_identificada.tb_spaece_alinhado add key_etapas text;

update base_identificada.tb_spaece_alinhado 

create table base_identificada.tb_spaece_alinhado_ano_serie as (
select
id_spaece_ceipe,
case
when key_etapas like '56**EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL (8 E 9 ANOS) MULTIETAPA**15**EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL (8 E 9 ANOS) MULTIETAPA** - ENSINO FUNDAMENTAL' then 2
when key_etapas like '22**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI**15**ENSINO FUNDAMENTAL DE 9 ANOS - 2Âº ANO** - ENSINO FUNDAMENTAL' then 2
when key_etapas like '10**1ª SÉRIE EM**100**1º PERÍODO** - ENSINO MEDIO' then 10
when key_etapas like '22**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI**18**ENSINO FUNDAMENTAL DE 9 ANOS - 5º ANO** - ENSINO FUNDAMENTAL' then 5
when key_etapas like '11**2º ANO EM****** - ENSINO MEDIO' then 11
when key_etapas like '27**EJA - ENSINO MÉDIO**120**EJA PRESENCIAL - ENSINO MÉDIO**EJA - ENSINO MEDIO' then 12
when key_etapas like '12**3ª SÉRIE EM NORMAL/MAGISTERIO**12**3ª SÉRIE EM** - ENSINO MEDIO' then 12
when key_etapas like '23**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÇÃO DE FLUXO**15**ENSINO FUNDAMENTAL DE 9 ANOS - 2º ANO** - ENSINO FUNDAMENTAL' then 2
when key_etapas like '24**ENSINO FUNDAMENTAL DE 8 E 9 ANOS - MULTI 8 E 9 ANOS**15**ENSINO FUNDAMENTAL DE 9 ANOS - 2Âº ANO** - ENSINO FUNDAMENTAL' then 2
when key_etapas like '56**EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL (8 E 9 ANOS) MULTIETAPA**15**ENSINO FUNDAMENTAL DE 9 ANOS - 2º ANO** - ENSINO FUNDAMENTAL' then 2
when key_etapas like '22**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI**2**2º ANO**2 ANO - ENSINO FUNDAMENTAL' then 2
when key_etapas like '9**9º ANO****** - ENSINO FUNDAMENTAL' then 9
when key_etapas like '11**2ª SÉRIE EM**11**2ª SÉRIE EM INTEGRADO** - ENSINO MEDIO' then 11
when key_etapas like '12**3º ANO EM****** - ENSINO MEDIO' then 12
when key_etapas like '10**1ª SÉRIE EM**10**1ª SÉRIE EM EDU ESP** - ENSINO MEDIO' then 10
when key_etapas like '2**2º ANO******2 ANO - ENSINO FUNDAMENTAL' then 2
when key_etapas like '22**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI**15**ENSINO FUNDAMENTAL DE 9 ANOS - 2º ANO** - ENSINO FUNDAMENTAL' then 2
when key_etapas like '56**EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL (8 E 9 ANOS) MULTIETAPA**2**2º ANO**2 ANO - ENSINO FUNDAMENTAL' then 2
when key_etapas like '37**ENSINO MÉDIO - NORMAL/MAGISTÉRIO 3ª SÉRIE**12**3ª SÉRIE EM** - ENSINO MEDIO' then 12
when key_etapas like '9**9º ANO**9**EJA IV**EJA - ENSINO FUNDAMENTAL' then 9
when key_etapas like '22**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI**15**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI** - ENSINO FUNDAMENTAL' then 2
when key_etapas like '9**9º ANO**9**9º ANO**9 ANO - ENSINO FUNDAMENTAL' then 9
when key_etapas like '18**ENSINO FUNDAMENTAL DE 9 ANOS - 5º ANO**5**5º ANO**5 ANO - ENSINO FUNDAMENTAL' then 5
when key_etapas like '24**ENSINO FUNDAMENTAL DE 8 E 9 ANOS - MULTI 8 E 9 ANOS**18**ENSINO FUNDAMENTAL DE 9 ANOS - 5º ANO** - ENSINO FUNDAMENTAL' then 5
when key_etapas like '27**ENSINO MÉDIO - 3ª SÉRIE**120**EJA PRESENCIAL - ENSINO MÉDIO**EJA - ENSINO MEDIO' then 12
when key_etapas like '71**EJA - ENSINO MÉDIO**27**EJA - ENSINO MÉDIO**EJA - ENSINO MEDIO' then 12
when key_etapas like '23**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÇÃO DE FLUXO**18**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÇÃO DE FLUXO** - ENSINO FUNDAMENTAL' then 5
when key_etapas like '90**EJA PRESENCIAL - ANOS FINAIS**90**EJA PRESENCIAL - ANOS FINAIS**EJA - ENSINO FUNDAMENTAL' then 9
when key_etapas like '23**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÇÃO DE FLUXO**5**5º ANO**5 ANO - ENSINO FUNDAMENTAL' then 5
when key_etapas like '41**ENSINO FUNDAMENTAL DE 9 ANOS - 9Âº ANO**41**ENSINO FUNDAMENTAL DE 9 ANOS - 9Âº ANO** - ENSINO FUNDAMENTAL' then 9
when key_etapas like '11**2ª SÉRIE EM**11**2ª SÉRIE EM REG** - ENSINO MEDIO' then 11
when key_etapas like '101**1ª SÉRIE EM INTEGRADO**10**1ª SÉRIE EM** - ENSINO MEDIO' then 10
when key_etapas like '23**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÇÃO DE FLUXO**2**2º ANO**2 ANO - ENSINO FUNDAMENTAL' then 2
when key_etapas like '10**1ª SÉRIE EM****** - ENSINO MEDIO' then 10
when key_etapas like '56**EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL (8 E 9 ANOS) MULTIETAPA**41**EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL (8 E 9 ANOS) MULTIETAPA** - ENSINO FUNDAMENTAL' then 5
when key_etapas like '37**ENSINO MÉDIO - NORMAL/MAGISTÉRIO 3ª SÉRIE**27**ENSINO MÉDIO - NORMAL/MAGISTÉRIO 3ª SÉRIE** - ENSINO MEDIO' then 12
when key_etapas like '41**ENSINO FUNDAMENTAL DE 9 ANOS - 9º ANO**9**9º ANO**9 ANO - ENSINO FUNDAMENTAL' then 9
when key_etapas like '12**3 Serie Ensino Medio******3 SERIE - ENSINO MEDIO' then 12
when key_etapas like '15**ENSINO FUNDAMENTAL DE 9 ANOS - 2Âº ANO**15**ENSINO FUNDAMENTAL DE 9 ANOS - 2Âº ANO** - ENSINO FUNDAMENTAL' then 2
when key_etapas like '22**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI**18**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI** - ENSINO FUNDAMENTAL' then 5
when key_etapas like '9**EJA EF - 2º SEGMENTO******EJA - ENSINO FUNDAMENTAL' then 9
when key_etapas like '4**ENSINO FUNDAMENTAL DE 8 ANOS - 1Âª SÃ?RIE**15**ENSINO FUNDAMENTAL DE 9 ANOS - 2Âº ANO** - ENSINO FUNDAMENTAL' then 2
when key_etapas like '23**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÇÃO DE FLUXO**15**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÇÃO DE FLUXO** - ENSINO FUNDAMENTAL' then 2
when key_etapas like '2**2º ANO**2**2º ANO** - ENSINO FUNDAMENTAL' then 2
when key_etapas like '22**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI**5**5º ANO**5 ANO - ENSINO FUNDAMENTAL' then 5
when key_etapas like '56**EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL (8 E 9 ANOS) MULTIETAPA**41**ENSINO FUNDAMENTAL DE 9 ANOS - 9º ANO** - ENSINO FUNDAMENTAL' then 9
when key_etapas like '12**3ª SÉRIE EM**12**3ª SÉRIE EM** - ENSINO MEDIO' then 12
when key_etapas like '23**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÃ?Ã?O DE FLUXO**41**ENSINO FUNDAMENTAL DE 9 ANOS - 9Âº ANO** - ENSINO FUNDAMENTAL' then 9
when key_etapas like '12**3ª SÉRIE EM INTEGRADO**12**3ª SÉRIE EM** - ENSINO MEDIO' then 12
when key_etapas like '100**EJA PRESENCIAL - ENSINO MÉDIO**100**EJA PRESENCIAL - ENSINO MÉDIO**EJA - ENSINO FUNDAMENTAL' then 10
when key_etapas like '15**ENSINO FUNDAMENTAL DE 9 ANOS - 2º ANO**15**ENSINO FUNDAMENTAL DE 9 ANOS - 2º ANO** - ENSINO FUNDAMENTAL' then 2
when key_etapas like '24**ENSINO FUNDAMENTAL DE 8 E 9 ANOS - MULTI 8 E 9 ANOS**2**2º ANO**2 ANO - ENSINO FUNDAMENTAL' then 2
when key_etapas like '10**1ª SÉRIE EM**10**1ª SÉRIE EM** - ENSINO MEDIO' then 10
when key_etapas like '23**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÃ?Ã?O DE FLUXO**15**ENSINO FUNDAMENTAL DE 9 ANOS - 2Âº ANO** - ENSINO FUNDAMENTAL' then 2
when key_etapas like '15**ENSINO FUNDAMENTAL DE 9 ANOS - 2º ANO**2**2º ANO**2 ANO - ENSINO FUNDAMENTAL' then 2
when key_etapas like '71**EJA - ENSINO MÉDIO**12**3ª SÉRIE EM**EJA - ENSINO MEDIO' then 12
when key_etapas like '9**9 Ano Ensino Fundamental******9 ANO - ENSINO FUNDAMENTAL' then 9
when key_etapas like '5**5º ANO**5**5º ANO**5 ANO - ENSINO FUNDAMENTAL' then 5
when key_etapas like '5**5 Ano Ensino Fundamental******5 ANO - ENSINO FUNDAMENTAL' then 5
when key_etapas like '56**EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL (8 E 9 ANOS) MULTIETAPA**5**5º ANO**5 ANO - ENSINO FUNDAMENTAL' then 5
when key_etapas like '3**3º ANO****** - ENSINO FUNDAMENTAL' then 12
when key_etapas like '18**ENSINO FUNDAMENTAL DE 9 ANOS - 5Âº ANO**18**ENSINO FUNDAMENTAL DE 9 ANOS - 5Âº ANO** - ENSINO FUNDAMENTAL' then 5
when key_etapas like '12**3ª SÉRIE EM**12**2º PERÍODO**EJA - ENSINO MEDIO' then 12
when key_etapas like '23**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÇÃO DE FLUXO**41**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÇÃO DE FLUXO** - ENSINO FUNDAMENTAL' then 9
when key_etapas like '2**2 Ano Ensino Fundamental******2 ANO - ENSINO FUNDAMENTAL' then 2
when key_etapas like '23**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÇÃO DE FLUXO**18**ENSINO FUNDAMENTAL DE 9 ANOS - 5º ANO** - ENSINO FUNDAMENTAL' then 5
when key_etapas like '2**2º ANO****** - ENSINO FUNDAMENTAL' then 2
when key_etapas like  '11**2 Serie Ensino Medio******2 SERIE - ENSINO MEDIO' then 2
when key_etapas like  '12**3ª SÉRIE EM****** - ENSINO MEDIO' then 12
when key_etapas like  '27**ENSINO MÉDIO - 3ª SÉRIE**12**3ª SÉRIE EM** - ENSINO MEDIO' then 12
when key_etapas like  '24**ENSINO FUNDAMENTAL DE 8 E 9 ANOS - MULTI 8 E 9 ANOS**15**ENSINO FUNDAMENTAL DE 9 ANOS - 2º ANO** - ENSINO FUNDAMENTAL' then 2
when key_etapas like  '10**1ª SÉRIE EM**10**1ª SÉRIE EM NORMAL/MAGISTERIO** - ENSINO MEDIO' then 10
when key_etapas like  '56**EDUCAÃ?Ã?O INFANTIL E ENSINO FUNDAMENTAL (8 E 9 ANOS) MULTIETAPA**15**ENSINO FUNDAMENTAL DE 9 ANOS - 2Âº ANO** - ENSINO FUNDAMENTAL' then 2
when key_etapas like  '10**EJA EM - 1º PERIODO******EJA - ENSINO MEDIO' then 10
when key_etapas like  '11**2ª SÉRIE EM**11**2ª SÉRIE EM EDU ESP** - ENSINO MEDIO' then 11
when key_etapas like  '12**3ª SÉRIE EM**120**2º PERÍODO** - ENSINO MEDIO' then 12
when key_etapas like  '10**1ª SÉRIE EM**10**1ª SÉRIE EM REG** - ENSINO MEDIO' then 10
when key_etapas like  '12**3ª SÉRIE EM**12**3ª SÉRIE EM NORMAL** - ENSINO MEDIO' then 12
when key_etapas like  '11**2ª SÉRIE EM**11**2ª SÉRIE EM** - ENSINO MEDIO' then 11
when key_etapas like  '22**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI**18**ENSINO FUNDAMENTAL DE 9 ANOS - 5Âº ANO** - ENSINO FUNDAMENTAL' then 5
when key_etapas like  '4**4º ANO****** - ENSINO FUNDAMENTAL' then 5
when key_etapas like  '23**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÇÃO DE FLUXO**41**ENSINO FUNDAMENTAL DE 9 ANOS - 9º ANO** - ENSINO FUNDAMENTAL' then 9
when key_etapas like  '5**5º ANO****** - ENSINO FUNDAMENTAL' then 5
when key_etapas like  '10**1ª SÉRIE EM**10**1ª SÉRIE EM INTEGRADO** - ENSINO MEDIO' then 10
when key_etapas like  '22**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI**41**ENSINO FUNDAMENTAL DE 9 ANOS - 9Âº ANO** - ENSINO FUNDAMENTAL' then 9
when key_etapas like  '24**ENSINO FUNDAMENTAL DE 8 E 9 ANOS - MULTI 8 E 9 ANOS**18**ENSINO FUNDAMENTAL DE 9 ANOS - 5Âº ANO** - ENSINO FUNDAMENTAL' then 5
when key_etapas like  '71**EJA - ENSINO MÉDIO**120**EJA PRESENCIAL - ENSINO MÉDIO**EJA - ENSINO MEDIO' then 12
when key_etapas like  '27**CURSO TÉCNICO INTEGRADO (ENSINO MÉDIO INTEGRADO) 3ª SÉRIE**12**3ª SÉRIE EM** - ENSINO MEDIO' then 12
when key_etapas like  '23**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÃ?Ã?O DE FLUXO**18**ENSINO FUNDAMENTAL DE 9 ANOS - 5Âº ANO** - ENSINO FUNDAMENTAL' then 5
when key_etapas like  '5**5º ANO**5**5º ANO** - ENSINO FUNDAMENTAL' then 5
when key_etapas like  '10**1ª SÉRIE EM INTEGRADO**10**1ª SÉRIE EM** - ENSINO MEDIO' then 10
when key_etapas like  '12**EJA EM - 2º PERIODO******EJA - ENSINO MEDIO' then 12
when key_etapas like  '27**ENSINO MÉDIO - 3ª SÉRIE**27**ENSINO MÉDIO - 3ª SÉRIE** - ENSINO MEDIO' then 12
when key_etapas like  '24**ENSINO FUNDAMENTAL DE 8 E 9 ANOS - MULTI 8 E 9 ANOS**5**5º ANO**5 ANO - ENSINO FUNDAMENTAL' then 5
when key_etapas like  '4**ENSINO FUNDAMENTAL DE 8 ANOS - 1ª SÉRIE**2**2º ANO**2 ANO - ENSINO FUNDAMENTAL' then 2
when key_etapas like  '22**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI**9**9º ANO**9 ANO - ENSINO FUNDAMENTAL' then 9
when key_etapas like  '9**9º ANO**9**EJA PRESENCIAL - ANOS FINAIS**EJA - ENSINO FUNDAMENTAL' then 9
when key_etapas like  '12**3ª SÉRIE EM**12**3ª SÉRIE EM EDU ESP** - ENSINO MEDIO' then 12
when key_etapas like  '23**ENSINO FUNDAMENTAL DE 9 ANOS - CORREÇÃO DE FLUXO**9**9º ANO**9 ANO - ENSINO FUNDAMENTAL' then 9
when key_etapas like  '32**CURSO TÉCNICO INTEGRADO (ENSINO MÉDIO INTEGRADO) 3ª SÉRIE**12**3ª SÉRIE EM** - ENSINO MEDIO' then 12
when key_etapas like  '56**EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL (8 E 9 ANOS) MULTIETAPA**18**ENSINO FUNDAMENTAL DE 9 ANOS - 5º ANO** - ENSINO FUNDAMENTAL' then 5
when key_etapas like  '12**ENSINO FUNDAMENTAL DE 8 ANOS - MULTI**18**ENSINO FUNDAMENTAL DE 9 ANOS - 5Âº ANO** - ENSINO FUNDAMENTAL' then 5
when key_etapas like  '2**2º ANO**2**2º ANO**2 ANO - ENSINO FUNDAMENTAL' then 2
when key_etapas like  '10**1 Serie Ensino Medio******1 SERIE - ENSINO MEDIO' then 10
when key_etapas like  '11**2ª SÉRIE EM****** - ENSINO MEDIO' then 11
when key_etapas like  '9**9º ANO**9**9º ANO** - ENSINO FUNDAMENTAL' then 9
when key_etapas like  '100**1º PERÍODO**10**1ª SÉRIE EM** - ENSINO MEDIO' then 10
when key_etapas like  '22**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI**41**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI** - ENSINO FUNDAMENTAL' then 9
when key_etapas like  '120**2º PERÍODO**12**3ª SÉRIE EM** - ENSINO MEDIO' then 12
when key_etapas like  '41**ENSINO FUNDAMENTAL DE 9 ANOS - 9º ANO**41**ENSINO FUNDAMENTAL DE 9 ANOS - 9º ANO** - ENSINO FUNDAMENTAL' then 9
when key_etapas like  '12**3ª SÉRIE EM**58**3ª SÉRIE EM INTEGRADO** - ENSINO MEDIO' then 12
when key_etapas like  '10**1ª SÉRIE EM**10**1ª SÉRIE EM EP** - ENSINO MEDIO' then 10
when key_etapas like  '10**1ª SÉRIE EM**10**1º PERÍODO**EJA - ENSINO MEDIO' then 10
when key_etapas like  '11**2ª SÉRIE EM**11**2ª SÉRIE EM EP** - ENSINO MEDIO' then 10
when key_etapas like  '12**3ª SÉRIE EM**12**3ª SÉRIE EM EP** - ENSINO MEDIO' then 11
when key_etapas like  '11**2ª SÉRIE EM INTEGRADO**11**2ª SÉRIE EM** - ENSINO MEDIO' then 12
when key_etapas like  '10**1ª SÉRIE EM NORMAL/MAGISTERIO**10**1ª SÉRIE EM** - ENSINO MEDIO' then 10
when key_etapas like  '11**2ª SÉRIE EM NORMAL/MAGISTERIO**11**2ª SÉRIE EM** - ENSINO MEDIO' then 11
when key_etapas like  '1**1º ANO****** - ENSINO FUNDAMENTAL' then 10
when key_etapas like  '10**1ª SÉRIE EM**10**1ª SÉRIE EM NORMAL** - ENSINO MEDIO' then 10
when key_etapas like  '56**EDUCAÃ?Ã?O INFANTIL E ENSINO FUNDAMENTAL (8 E 9 ANOS) MULTIETAPA**18**ENSINO FUNDAMENTAL DE 9 ANOS - 5Âº ANO** - ENSINO FUNDAMENTAL' then 5
when key_etapas like  '74**CURSO TÉCNICO INTEGRADO NA MODALIDADE EJA (EJA INTEGRADA À EDUCAÇÃO PROFISSIONAL DE NÍVEL MÉDIO)**120**EJA PRESENCIAL - ENSINO MÉDIO**EJA - ENSINO MEDIO' then 12
when key_etapas like  '12**3ª SÉRIE EM**12**3ª SÉRIE EM REG** - ENSINO MEDIO' then 12
when key_etapas like  '90**EJA PRESENCIAL - ANOS FINAIS**9**9º ANO**EJA - ENSINO FUNDAMENTAL' then 9
when key_etapas like  '56**EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL (8 E 9 ANOS) MULTIETAPA**18**EDUCAÇÃO INFANTIL E ENSINO FUNDAMENTAL (8 E 9 ANOS) MULTIETAPA** - ENSINO FUNDAMENTAL' then 5
when key_etapas like  '11**2ª SÉRIE EM**11**2ª SÉRIE EM NORMAL** - ENSINO MEDIO' then 11
when key_etapas like  '32**CURSO TÉCNICO INTEGRADO (ENSINO MÉDIO INTEGRADO) 3ª SÉRIE**27**CURSO TÉCNICO INTEGRADO (ENSINO MÉDIO INTEGRADO) 3ª SÉRIE** - ENSINO MEDIO' then 12
when key_etapas like  '10**1º ANO EM****** - ENSINO MEDIO' then 10
when key_etapas like  '18**ENSINO FUNDAMENTAL DE 9 ANOS - 5º ANO**18**ENSINO FUNDAMENTAL DE 9 ANOS - 5º ANO** - ENSINO FUNDAMENTAL' then 5
when key_etapas like  '22**ENSINO FUNDAMENTAL DE 9 ANOS - MULTI**41**ENSINO FUNDAMENTAL DE 9 ANOS - 9º ANO** - ENSINO FUNDAMENTAL' then 9 else 99 end cd_ano_serie_ceipe,
case when dc_etapa_avaliada_turma ilike '%EJA%' or dc_etapa_aplicacao_turma ilike '%EJA%' then 1 else 0 end fl_eja
from base_identificada.tb_spaece_alinhado
group by 1,2,3,4,5
)

alter table base_identificada.tb_spaece_alinhado add column id_spaece_ceipe serial 

alter table base_identificada.tb_spaece_alinhado_ano_serie add column id serial 

with pessoa as (
select 
co_pessoa_fisica
from censo_esc_ce.tb_pessoa_fisica_2007_2017
union 
select 
co_pessoa_fisica
from censo_esc_ce.tb_pessoa_fisica_2018 tpf 
union 
select 
co_pessoa_fisica
from censo_esc_ce.tb_pessoa_fisica_2019 tpf 
), co_inep as (
select 
id_spaece_ceipe,
tsa.cd_aluno_inep co_pessoa_fisica
from base_identificada.tb_spaece_alinhado tsa
where 
exists ( select 1 from pessoa where  tsa.cd_aluno_inep::text = co_pessoa_fisica::text)
), inst as (
select 
id_spaece_ceipe,
tsa.cd_aluno_institucional co_pessoa_fisica
from base_identificada.tb_spaece_alinhado tsa
where 
exists ( select 1 from pessoa where  tsa.cd_aluno_institucional::text = co_pessoa_fisica::text)
and not  exists ( select 1 from co_inep  co where co.id_spaece_ceipe  = tsa.id_spaece_ceipe)
), cd_aluno as (
select 
id_spaece_ceipe,
tsa.cd_aluno co_pessoa_fisica
from base_identificada.tb_spaece_alinhado tsa
where 
exists ( select 1 from pessoa where  tsa.cd_aluno::text = co_pessoa_fisica::text)
and not  exists ( select 1 from co_inep  co where co.id_spaece_ceipe  = tsa.id_spaece_ceipe)
), total as (
select * from co_inep
union 
select * from inst
) select count(1) from total
---
---

drop table if exists base_identificada.tb_codigo_inep_spaece;
create table base_identificada.tb_codigo_inep_spaece as (
/*
 * VALIDAÇÃO DE CODIGOS INEP DE ALUNOS
 */
select 
tsa.id_spaece_ceipe,
tsa.nr_ano,
st.cd_aluno_inep
from base_identificada.tb_codigo_inep_spaece_temp st 
join base_identificada.tb_spaece_alinhado tsa using(id_spaece_ceipe) 
join base_identificada.tb_pessoa_censo tpc on tpc.nu_ano_censo::int = tsa.nr_ano 
			and tpc.co_pessoa_fisica::text = st.cd_aluno_inep 
);


create table base_identificada.tb_matricula as (
select 
nu_ano_censo,
co_pessoa_fisica,
co_entidade,
id_turma,
tp_etapa_ensino,
cd_etapa,
tde.cd_ano_serie,
in_eja fl_eja
from censo_esc_ce.tb_matricula_2007_2018 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
union 
select 
nu_ano_censo,
co_pessoa_fisica,
co_entidade,
id_turma,
tp_etapa_ensino,
cd_etapa,
tde.cd_ano_serie,
in_eja fl_eja
from censo_esc_ce.tb_matricula_2019 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
union 
select 
nu_ano_censo,
co_pessoa_fisica,
co_entidade,
id_turma,
tp_etapa_ensino,
cd_etapa,
tde.cd_ano_serie,
in_eja fl_eja
from censo_esc_ce.tb_matricula_2020 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
)

alter table base_identificada.tb_matricula add id_matricula_ceipe serial;

alter table base_identificada.tb_pessoa_censo add key_pessoa text;

update 
base_identificada.tb_pessoa_censo 
set key_pessoa = replace(no_pessoa_fisica,' ','' );


alter table base_identificada.tb_spaece_alinhado add key_pessoa text;
update 
base_identificada.tb_spaece_alinhado 
set key_pessoa = replace(nm_aluno ,' ','' );


create table tb_qtd_key_pessoa_censo_by_escola_ano_serie as (
select
nu_ano_censo nr_ano,
tpc.co_pessoa_fisica cd_aluno_inep,
co_entidade::bigint cd_escola,
cd_etapa cd_etapa_ceipe,
cd_ano_serie cd_ano_serie_ceipe,
key_pessoa,
fl_eja,
count(1) qtd
from base_identificada.tb_pessoa_censo tpc
join base_identificada.tb_matricula tm using(nu_ano_censo,co_pessoa_fisica)
group by 1,2,3,4,5,6,7
)


create table tb_qtd_key_pessoa_spaece_by_escola_ano_serie as (
select
nr_ano,
cd_escola::bigint,
cd_etapa_ceipe,
cd_ano_serie_ceipe,
key_pessoa,
fl_eja,
count(1) qtd
from base_identificada.tb_spaece_alinhado tsa 
join base_identificada.tb_spaece_alinhado_ano_serie using(nr_ano,nu_sequencial)
group by 1,2,3,4,5,6
)


create table base_identificada.tb_base_spaece_censo_1 as (
select
sa.id_spaece_ceipe,
sa.nr_ano,
sa.nu_sequencial,
sc.cd_aluno_inep,
sa.cd_escola,
sa.cd_etapa_ceipe,
sas.cd_ano_serie_ceipe,
sas.fl_eja,
sa.vl_perc_acertos_lp,
sa.prof_lp,
sa.prof_lp_erro,
sa.vl_perc_acertos_mt,
sa.prof_mt,
sa.prof_mt_erro,
sa.fl_avaliado
from base_identificada.tb_spaece_alinhado sa
join base_identificada.tb_codigo_inep_spaece sc on sc.id_spaece_ceipe = sa.id_spaece_ceipe 
join base_identificada.tb_spaece_alinhado_ano_serie sas on sas.nr_ano = sa.nr_ano and sas.nu_sequencial = sa.nu_sequencial
join base_identificada.tb_spaece_censo tpc 
	on sa.nr_ano = tpc.nr_ano 
	and tpc.key_pessoa = sa.key_pessoa 
	and sc.cd_aluno_inep::bigint = tpc.cd_aluno_inep::bigint
	and sas.cd_ano_serie_ceipe = tpc.cd_ano_serie_ceipe 
	and sa.cd_escola::bigint = tpc.cd_escola 
)--31406415



create table base_identificada.tb_base_spaece_censo_2 as (
select
sa.id_spaece_ceipe,
sa.nr_ano,
sa.nu_sequencial,
sc.cd_aluno_inep,
sa.cd_escola,
sa.cd_etapa_ceipe,
sas.cd_ano_serie_ceipe,
sas.fl_eja,
sa.vl_perc_acertos_lp,
sa.prof_lp,
sa.prof_lp_erro,
sa.vl_perc_acertos_mt,
sa.prof_mt,
sa.prof_mt_erro,
sa.fl_avaliado
from base_identificada.tb_spaece_alinhado sa
join base_identificada.tb_codigo_inep_spaece sc on sc.id_spaece_ceipe = sa.id_spaece_ceipe 
join base_identificada.tb_spaece_alinhado_ano_serie sas on sas.nr_ano = sa.nr_ano and sas.nu_sequencial = sa.nu_sequencial
and not exists(select 1 from base_identificada.tb_base_spaece_censo_1 r1 where r1.id_spaece_ceipe = sa.id_spaece_ceipe )
)--97638



create table base_identificada.tb_base_spaece_censo_3 as (
select
sa.id_spaece_ceipe,
sa.nr_ano,
sa.nu_sequencial,
tpc.cd_aluno_inep,
sa.cd_escola,
sa.cd_etapa_ceipe,
sas.cd_ano_serie_ceipe,
sas.fl_eja,
sa.vl_perc_acertos_lp,
sa.prof_lp,
sa.prof_lp_erro,
sa.vl_perc_acertos_mt,
sa.prof_mt,
sa.prof_mt_erro,
sa.fl_avaliado
from base_identificada.tb_spaece_alinhado sa
join base_identificada.tb_spaece_alinhado_ano_serie sas on sas.nr_ano = sa.nr_ano and sas.nu_sequencial = sa.nu_sequencial
join base_identificada.tb_spaece_censo tpc 
	on sa.nr_ano = tpc.nr_ano 
	and tpc.key_pessoa = sa.key_pessoa 
	and sas.cd_ano_serie_ceipe = tpc.cd_ano_serie_ceipe 
	and sa.cd_escola::bigint = tpc.cd_escola
	and tpc.fl_eja = sas.fl_eja 
and not exists(select 1 from base_identificada.tb_base_spaece_censo_1 r1 where r1.id_spaece_ceipe = sa.id_spaece_ceipe )
and not exists(select 1 from base_identificada.tb_base_spaece_censo_2 r2 where r2.id_spaece_ceipe = sa.id_spaece_ceipe )
)--

create table base_identificada.tb_base_spaece_censo_4 as (
select
sa.id_spaece_ceipe,
sa.nr_ano,
sa.nu_sequencial,
tpc.cd_aluno_inep,
sa.cd_escola,
sa.cd_etapa_ceipe,
sas.cd_ano_serie_ceipe,
sas.fl_eja,
sa.vl_perc_acertos_lp,
sa.prof_lp,
sa.prof_lp_erro,
sa.vl_perc_acertos_mt,
sa.prof_mt,
sa.prof_mt_erro,
sa.fl_avaliado
from base_identificada.tb_spaece_alinhado sa
join base_identificada.tb_spaece_alinhado_ano_serie sas on sas.nr_ano = sa.nr_ano and sas.nu_sequencial = sa.nu_sequencial
join base_identificada.tb_spaece_censo tpc 
	on sa.nr_ano = tpc.nr_ano 
	and tpc.key_pessoa = sa.key_pessoa 
	and sa.cd_escola::bigint = tpc.cd_escola
and not exists(select 1 from base_identificada.tb_base_spaece_censo_1 r1 where r1.id_spaece_ceipe = sa.id_spaece_ceipe )
and not exists(select 1 from base_identificada.tb_base_spaece_censo_2 r2 where r2.id_spaece_ceipe = sa.id_spaece_ceipe )
and not exists(select 1 from base_identificada.tb_base_spaece_censo_2 r3 where r3.id_spaece_ceipe = sa.id_spaece_ceipe )
)

create table base_identificada.tb_base_spaece_censo_5 as (
select
sa.id_spaece_ceipe,
sa.nr_ano,
sa.nu_sequencial,
null cd_aluno_inep,
sa.cd_escola,
sa.cd_etapa_ceipe,
sas.cd_ano_serie_ceipe,
sas.fl_eja,
sa.vl_perc_acertos_lp,
sa.prof_lp,
sa.prof_lp_erro,
sa.vl_perc_acertos_mt,
sa.prof_mt,
sa.prof_mt_erro,
sa.fl_avaliado
from base_identificada.tb_spaece_alinhado sa
join base_identificada.tb_spaece_alinhado_ano_serie sas on sas.nr_ano = sa.nr_ano and sas.nu_sequencial = sa.nu_sequencial
and not exists(select 1 from base_identificada.tb_base_spaece_censo_1 r1 where r1.id_spaece_ceipe = sa.id_spaece_ceipe )
and not exists(select 1 from base_identificada.tb_base_spaece_censo_2 r2 where r2.id_spaece_ceipe = sa.id_spaece_ceipe )
and not exists(select 1 from base_identificada.tb_base_spaece_censo_3 r3 where r3.id_spaece_ceipe = sa.id_spaece_ceipe )
and not exists(select 1 from base_identificada.tb_base_spaece_censo_4 r4 where r4.id_spaece_ceipe = sa.id_spaece_ceipe )
)


create table base_identificada.tb_base_spaece_censo as (
select 
	id_spaece_ceipe::int,
	nr_ano::int,
	nu_sequencial::text,
	cd_aluno_inep::bigint,
	cd_escola::text,
	cd_etapa_ceipe::int,
	cd_ano_serie_ceipe::int,
	fl_eja::int,
	vl_perc_acertos_lp::numeric,
	prof_lp::numeric,
	prof_lp_erro::numeric,
	vl_perc_acertos_mt::numeric,
	prof_mt::numeric,
	prof_mt_erro::numeric,
	fl_avaliado::int
from base_identificada.tb_base_spaece_censo_1
union 
select 
	id_spaece_ceipe::int,
	nr_ano::int,
	nu_sequencial::text,
	cd_aluno_inep::bigint,
	cd_escola::text,
	cd_etapa_ceipe::int,
	cd_ano_serie_ceipe::int,
	fl_eja::int,
	vl_perc_acertos_lp::numeric,
	prof_lp::numeric,
	prof_lp_erro::numeric,
	vl_perc_acertos_mt::numeric,
	prof_mt::numeric,
	prof_mt_erro::numeric,
	fl_avaliado::int
from base_identificada.tb_base_spaece_censo_2
union 
select 
	id_spaece_ceipe::int,
	nr_ano::int,
	nu_sequencial::text,
	cd_aluno_inep::bigint,
	cd_escola::text,
	cd_etapa_ceipe::int,
	cd_ano_serie_ceipe::int,
	fl_eja::int,
	vl_perc_acertos_lp::numeric,
	prof_lp::numeric,
	prof_lp_erro::numeric,
	vl_perc_acertos_mt::numeric,
	prof_mt::numeric,
	prof_mt_erro::numeric,
	fl_avaliado::int
from base_identificada.tb_base_spaece_censo_3
union 
select 
	id_spaece_ceipe::int,
	nr_ano::int,
	nu_sequencial::text,
	cd_aluno_inep::bigint,
	cd_escola::text,
	cd_etapa_ceipe::int,
	cd_ano_serie_ceipe::int,
	fl_eja::int,
	vl_perc_acertos_lp::numeric,
	prof_lp::numeric,
	prof_lp_erro::numeric,
	vl_perc_acertos_mt::numeric,
	prof_mt::numeric,
	prof_mt_erro::numeric,
	fl_avaliado::int
from base_identificada.tb_base_spaece_censo_4
union 
select 
	id_spaece_ceipe::int,
	nr_ano::int,
	nu_sequencial::text,
	null cd_aluno_inep,
	cd_escola::text,
	cd_etapa_ceipe::int,
	cd_ano_serie_ceipe::int,
	fl_eja::int,
	vl_perc_acertos_lp::numeric,
	prof_lp::numeric,
	prof_lp_erro::numeric,
	vl_perc_acertos_mt::numeric,
	prof_mt::numeric,
	prof_mt_erro::numeric,
	fl_avaliado::int
from base_identificada.tb_base_spaece_censo_5
)






