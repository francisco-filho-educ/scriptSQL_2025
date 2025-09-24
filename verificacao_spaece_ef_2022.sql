--Lista de registros com o CD_ALUNO (CD_REG_ORGAO_ALUNO) duplicado na base INEP
with codigos as (
select 
no_pessoa_fisica ,co_pessoa_fisica , id_turma, te.nm_escola, tde.ds_etapa_ensino 
from censo_esc_ce.tb_matricula_2022 tm 
join censo_esc_ce.tb_pessoa_fisica_2022 tpf using(co_pessoa_fisica)
join dw_censo.tb_dm_etapa tde on cd_etapa_ensino = tp_etapa_ensino 
join dw_censo.tb_dm_escola te on te.id_escola_inep = co_entidade and nr_ano_censo = nu_ano_censo 
where 
tp_etapa_ensino is not null 
and tm.co_pessoa_fisica 
in (
112318252946,
112318252946,
116824063770,
116824063770,
119059158708,
119059158708,
119717543070,
119717543070,
121104990287,
121104990287,
121138282609,
121138282609,
121164950672,
121164950672,
121371667470,
121371667470,
121375663037,
121375663037,
121895194627,
121895194627,
122270063073,
122270063073,
122487215878,
122487215878,
122487970013,
122487970013,
122488760926,
122488760926,
122635059380,
122635059380,
122763007790,
122763007790,
123407407113,
123407407113,
123463660996,
123463660996,
123479735761,
123479735761,
123658440146,
123658440146,
124071842201,
124071842201,
124225972118,
124225972118,
124411607700,
124411607700,
124940190284,
124940190284,
125010468700,
125010468700,
125269567732,
125269567732,
126258254054,
126258254054,
127314761336,
127314761336,
127614952170,
127614952170,
127811322330,
127811322330,
127881793910,
127881793910,
127932105527,
127932105527,
127934598792,
127934598792,
128039681935,
128039681935,
130049693513,
130049693513,
130056074882,
130056074882,
130133055336,
130133055336,
144709284961,
144709284961,
144956651200,
144956651200,
149907329362,
149907329362,
149918425228,
149918425228,
149945058702,
149945058702,
150008926319,
150008926319,
150040427489,
150040427489,
150164927432,
150164927432,
150166914877,
150166914877,
150201567600,
150201567600,
150203395637,
150203395637,
151149870701,
151149870701,
176003037953,
176003037953,
176718512566,
176718512566,
177214198834,
177214198834,
177369152102,
177369152102,
177377431708,
177377431708,
177816384504,
177816384504,
178209057358,
178209057358,
179364273680,
179364273680,
179368169844,
179368169844,
182989091431,
182989091431,
183486350764,
183486350764,
185107807657,
185107807657,
185648692098,
185648692098,
204105407730,
204105407730
)
--and  no_pessoa_fisica like 'JOSE LEVY DA SILVA SANTOS'
),
unicos as ( 
select co_pessoa_fisica , count(1) from codigos  group by 1 having count(1) =1
), 
duplicados as (

select co_pessoa_fisica , count(1) from codigos  group by 1 having count(1) > 1
)

--select * from codigos join unicos using (co_pessoa_fisica) order by 2
select * from codigos join duplicados using (co_pessoa_fisica) order by 2

--select * from codigos

)


-------------------------------------
select 
--"DS_ETAPA_SERIE_TURMA" ,
"NM_MUNICIPIO" , count(1)
from spaece_aplicacao_2022.tb_base_aplicacao_fundamental_inicial tbafi 
where "ID_MUNICIPIO" 
in (
2300309,
2301604,
2302800,
2303006,
2306405,
2307502,
2307700,
2308104,
2308609,
2310308,
2311603,
2313401
)
group by 1


--------------------------------------------

select 
no_entidade,
tm.co_entidade,
tde.ds_etapa_ensino, 
tt.no_turma,
count(1)
from censo_esc_ce.tb_matricula_2022 tm 
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
join censo_esc_ce.tb_escola_2022 te using(co_entidade)
join censo_esc_ce.tb_turma_2022 tt using(id_turma)
where tm.co_entidade in (
--23028670
--23028777
--23206357
23047062
) and cd_etapa = 2
group by 1,2,3,4
---------------------------------------------------------------


--Lista de registros com o CD_ALUNO (CD_REG_ORGAO_ALUNO) duplicado na base INEP
with codigos as (
select 
no_pessoa_fisica ,co_pessoa_fisica , id_turma, te.nm_escola, tde.ds_etapa_ensino, tm.tp_dependencia 
from censo_esc_ce.tb_matricula_2022 tm 
join censo_esc_ce.tb_pessoa_fisica_2022 tpf using(co_pessoa_fisica)
join dw_censo.tb_dm_etapa tde on cd_etapa_ensino = tp_etapa_ensino 
join dw_censo.tb_dm_escola te on te.id_escola_inep = co_entidade and nr_ano_censo = nu_ano_censo 
where 
tp_etapa_ensino is not null 
and tm.co_pessoa_fisica  = 122002504287
in (
112318252946,
112318252946,
116824063770,
116824063770,
119059158708,
119059158708,
119717543070,
119717543070,
121104990287,
121104990287,
121138282609,
121138282609,
121164950672,
121164950672,
121371667470,
121371667470,
121375663037,
121375663037,
121895194627,
121895194627,
122270063073,
122270063073,
122487215878,
122487215878,
122487970013,
122487970013,
122488760926,
122488760926,
122635059380,
122635059380,
122763007790,
122763007790,
123407407113,
123407407113,
123463660996,
123463660996,
123479735761,
123479735761,
123658440146,
123658440146,
124071842201,
124071842201,
124225972118,
124225972118,
124411607700,
124411607700,
124940190284,
124940190284,
125010468700,
125010468700,
125269567732,
125269567732,
126258254054,
126258254054,
127314761336,
127314761336,
127614952170,
127614952170,
127811322330,
127811322330,
127881793910,
127881793910,
127932105527,
127932105527,
127934598792,
127934598792,
128039681935,
128039681935,
130049693513,
130049693513,
130056074882,
130056074882,
130133055336,
130133055336,
144709284961,
144709284961,
144956651200,
144956651200,
149907329362,
149907329362,
149918425228,
149918425228,
149945058702,
149945058702,
150008926319,
150008926319,
150040427489,
150040427489,
150164927432,
150164927432,
150166914877,
150166914877,
150201567600,
150201567600,
150203395637,
150203395637,
151149870701,
151149870701,
176003037953,
176003037953,
176718512566,
176718512566,
177214198834,
177214198834,
177369152102,
177369152102,
177377431708,
177377431708,
177816384504,
177816384504,
178209057358,
178209057358,
179364273680,
179364273680,
179368169844,
179368169844,
182989091431,
182989091431,
183486350764,
183486350764,
185107807657,
185107807657,
185648692098,
185648692098,
204105407730,
204105407730
)
--and  no_pessoa_fisica like 'JOSE LEVY DA SILVA SANTOS'
),
unicos as ( 
select co_pessoa_fisica , count(1) from codigos  group by 1 having count(1) =1
), 
duplicados as (

select co_pessoa_fisica , count(1) from codigos  group by 1 having count(1) > 1
)

--select * from codigos join unicos using (co_pessoa_fisica) order by 2
select * from codigos join duplicados using (co_pessoa_fisica) order by 2

--select * from codigos

)




select 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
ds_categoria_escola_sige,
id_escola_inep,
nm_escola,
sum(nr_matriculas),
sum(case when cd_ano_serie = 10 then nr_matriculas else 0 end) serie_1,
sum(case when cd_ano_serie = 11 then nr_matriculas else 0 end) serie_2,
sum(case when cd_ano_serie = 12 then nr_matriculas else 0 end) serie_3,
sum(case when cd_ano_serie = 99 then nr_matriculas else 0 end) eja
from dw_censo.tb_cubo_matricula tcm 
where 
nr_ano_censo = 2022
and cd_dependencia = 2
and cd_categoria_escola_sige <> 99
and cd_etapa = 3
group by 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
ds_categoria_escola_sige,
id_escola_inep,
nm_escola







