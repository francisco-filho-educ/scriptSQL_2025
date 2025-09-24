with mat as( 
select 
tm.co_entidade,count(1) nr_matriculas
from censo_esc_d.tb_matricula tm 
join censo_esc_d.tb_turma tt using(id_turma)
where 
tm.nu_ano_censo =2021
and tm.tp_dependencia in (2,3)
and tt.nu_duracao_turma > 7
and tm.in_regular = 1
and tm.tp_etapa_ensino is not null
group by 1
)
, credes as (
select 
tde.ds_orgao_regional,
tde.id_crede_sefor,
nm_crede_sefor
from dw_censo.tb_dm_escola tde 
where
tde.nr_ano_censo = 2019
and id_crede_sefor is not null
)
select 
nu_ano_censo,
te.co_orgao_regional,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
sum(nr_matriculas)nr_matriculas
from censo_esc_d.tb_escola te 
left join credes on ds_orgao_regional = te.co_orgao_regional 
join dw_censo.tb_dm_municipio tdm on id_municipio = te.co_municipio 
join mat using(co_entidade)
where 
tp_dependencia in (2,3)
and tdm.id_uf = 23
and nm_municipio in('Massapê','Mauriti','Meruoca','Milagres','Missão Velha','Mombaça','Monsenhor Tabosa','Morada Nova','Morrinhes','Mucambo','Mulungu','Nova Olinda','Nova Russas','Novo Oriente','Ocara','Orós','Pacajus','Pacatuba','Pacoti','Paracuru','Paraipaba','Parambu','Pedra Branca','Pentecoste','Pereiro','Pindoretama','Piquet Carneiro','Porteiras','Quiterianópolis','Quixadá','Quixelô','Quixeramobim','Quixeré','Redenção','Reriutaba','Russas','Saboeiro','Santa Quitéria','Santana do Acaraú','Santana do Cariri')
group by 1,2,3,4,5


