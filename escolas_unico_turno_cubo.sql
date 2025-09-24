with alvo as (
select 
id_escola, 
count(distinct cd_turno) qt_turno
from dw_sige.tb_cubo_matricula_2022 tcm 
group by 1
having count(distinct cd_turno) =1
)
select 
nm_crede_sefor, id_escola,nm_escola,ds_turno 
from dw_sige.tb_cubo_matricula_2022 tcm 
join alvo using(id_escola)
where cd_turno in (1,4)
group by 1,2,3,4

select *
from dw_sige.tb_cubo_matricula_2022 tcm where id_escola = 23273534