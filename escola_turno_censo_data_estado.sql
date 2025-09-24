with crede as (
select 
id_crede_sefor,
nm_crede_sefor,
ds_orgao_regional 
from dw_censo.tb_dm_escola de 
where nr_ano_censo = 2020
and id_crede_sefor is not null 
and ds_orgao_regional is not null 
and cd_dependencia = 2
group by 1,2,3
), turno as (
select
id_turma,
case when concat(tt.tx_hr_inicial::text,':',tt.tx_mi_inicial::text)::time < '11:30:00'::time 
       and tt.tx_hr_inicial::int<>1 then 'Manhã'
      when (concat(tt.tx_hr_inicial::text,':',tt.tx_mi_inicial::text)::time > '11:30:00'::time 
         and concat(tt.tx_hr_inicial::text,':',tt.tx_mi_inicial::text)::time < '17:30:00'::time) 
         or tt.tx_hr_inicial::int = 1 then 'Tarde' 
      when concat(tt.tx_hr_inicial::text,':',tt.tx_mi_inicial::text)::time > '17:30:00'::time then 'Noite'
         end ds_turno,
case when concat(tt.tx_hr_inicial::text,':',tt.tx_mi_inicial::text)::time < '11:30:00'::time 
       and tt.tx_hr_inicial::int<>1 then 1
      when (concat(tt.tx_hr_inicial::text,':',tt.tx_mi_inicial::text)::time > '11:30:00'::time 
         and concat(tt.tx_hr_inicial::text,':',tt.tx_mi_inicial::text)::time < '17:30:00'::time) 
         or tt.tx_hr_inicial::int = 1 then 2
      when concat(tt.tx_hr_inicial::text,':',tt.tx_mi_inicial::text)::time > '17:30:00'::time then 3
         end cd_turno
 from censo_esc_d.tb_turma tt 
where tt.tp_dependencia = 2
and tt.co_municipio in(2304103,2305605)
and tt.tx_hr_inicial is not null and  tx_mi_inicial is not null
)
select 
te.nu_ano_censo,
nm_municipio,
id_crede_sefor,
nm_crede_sefor,
tt.co_entidade id_escola_inep,
te.no_entidade nm_escola,
case when ds_turno is null then 4 else cd_turno end cd_turno,
case when ds_turno is null then 'Flexível' else ds_turno end ds_turno,
 sum(tt.qt_matriculas) qt_matriculas,
 sum(case when tp_tipo_local_turma = 1 then qt_matriculas else 0  end) matr_ext_9ano
from censo_esc_d.tb_turma tt 
inner join censo_esc_d.tb_escola te using(co_entidade)
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tt.tp_etapa_ensino
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tt.co_municipio 
join crede on ds_orgao_regional = co_orgao_regional
left join turno using(id_turma)
where tt.tp_dependencia = 2
and id_municipio in(2304103,2305605,2308609)
group by 1,2,3,4,5,6,7,8
union 
select 
te.nu_ano_censo,
nm_municipio,
id_crede_sefor,
nm_crede_sefor,
tt.co_entidade id_escola_inep,
te.no_entidade nm_escola,
99 cd_turno,
'TOTAL'  ds_turno,
 sum(tt.qt_matriculas) qt_matriculas,
 sum(case when tp_tipo_local_turma = 1 then qt_matriculas else 0  end) matr_ext_9ano
from censo_esc_d.tb_turma tt 
inner join censo_esc_d.tb_escola te using(co_entidade)
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tt.tp_etapa_ensino
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tt.co_municipio 
join crede on ds_orgao_regional = co_orgao_regional
left join turno using(id_turma)
where tt.tp_dependencia = 2
and id_municipio in(2304103,2305605,2308609)
group by 1,2,3,4,5,6,7,8
order by 8,7,2