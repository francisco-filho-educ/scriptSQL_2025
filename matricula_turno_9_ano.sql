select 
te.nu_ano_censo,
nm_municipio,
case when concat(tt.tx_hr_inicial,':',tt.tx_mi_inicial)::time < '11:30:00'::time 
       and tt.tx_hr_inicial::int<>1 then 'Manhã'
      when (concat(tt.tx_hr_inicial,':',tt.tx_mi_inicial)::time > '11:30:00'::time 
         and concat(tt.tx_hr_inicial,':',tt.tx_mi_inicial)::time < '17:30:00'::time) 
         or tt.tx_hr_inicial::int = 1 then 'Tarde' 
      when concat(tt.tx_hr_inicial,':',tt.tx_mi_inicial)::time > '17:30:00'::time then 'Noite'
         end ds_turno,
 sum(tt.qt_matriculas) qt_matriculas,
 sum(case when tp_tipo_local_turma = 1 then qt_matriculas else 0  end) matr_ext_9ano
from censo_esc_d.tb_turma tt 
inner join censo_esc_d.tb_escola te using(co_entidade)
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tt.tp_etapa_ensino
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tt.co_municipio 
where tt.tp_dependencia = 3
and tde.cd_ano_serie = 9
and id_municipio in(2304103,2305605)
group by 1,2,3
union 
select 
te.nu_ano_censo,
nm_municipio,
'TOTAL' ds_turno,
 sum(tt.qt_matriculas) qt_matriculas,
 sum(case when tp_tipo_local_turma = 1 then qt_matriculas else 0  end) matr_ext_9ano
from censo_esc_d.tb_turma tt 
inner join censo_esc_d.tb_escola te using(co_entidade)
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tt.tp_etapa_ensino
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tt.co_municipio 
where tt.tp_dependencia = 3
and tde.cd_ano_serie = 9
and id_municipio in(2304103,2305605)
group by 1,2,3
order by 2,3

select 
te.nu_ano_censo,
nm_municipio,
 sum(tt.qt_matriculas) qt_matriculas,
 sum(case when tp_tipo_local_turma = 1 then qt_matriculas else 0  end) matr_ext_9ano
from censo_esc_d.tb_turma tt 
inner join censo_esc_d.tb_escola te using(co_entidade)
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tt.tp_etapa_ensino
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tt.co_municipio 
where tt.tp_dependencia = 3
and tde.cd_etapa_fase = 4
and tt.in_eja  = 1
and id_municipio in(2304103,2305605)
group by 1,2


