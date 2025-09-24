with contagem as (
select 
tde.nr_anoletivo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
te.id_escola_inep,
te.nm_escola,
te.ds_categoria,
count(1) total,
(count(1)*2)::int total_x2 --355.406
from public.tb_dm_etapa_aluno_2023_03_21 tde
join public.tb_dm_escola te using(id_escola_sige)
where tde.cd_etapa_aluno in (1,2,3)
and cd_turno in (1,2,4)
and cd_categoria not in (7,13,12)
/*
and((tde.cd_subetapa = 2 and cd_oferta_ensino = 1) or 
(cd_ano_serie in (10,11,12,13)) )
*/
and(tde.cd_subetapa = 1 and cd_oferta_ensino = 1) 
group by 1,2,3,4,5,6,7
)
,relatorio_incial as (
select 
nr_anoletivo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
ds_categoria,
total,
total_x2,
(total_x2 * (0.2972222225))::int  nr_p, --retirar 2 do maior  --  99.514     
round(total_x2 * 0.51,0) nr_m, --somar 4 a maior   ---   170.596      
(total_x2 * 0.202)::int nr_g,  -- somar 26      ---  67.526      
(total_x2 * 0.04298)::int nr_g_g, --diminuir 4 -- 14.216    
(total_x2 * 0.01139)::int nr_xg--   3.554                                               
from contagem 
)
,relatorio as (
select ----------------------------------------------------------------      14.216      3.554
nr_anoletivo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
ds_categoria,
total,
total_x2 total_x2,
case when nr_p%2 = 0 then nr_p else nr_p-1  end nr_p,
case when nr_m%2 = 0 then nr_m else nr_m-1  end nr_m,
case when nr_g%2 = 0 then nr_g else nr_g-1  end nr_g,
case when nr_g_g%2 = 0 then nr_g_g else nr_g_g-1  end nr_g_g,
case when nr_xg%2 = 0 then nr_xg else nr_xg-1  end   nr_xg  --  99.514     170.596      67.526      14.216      3.554
from relatorio_incial 
)
select   * from relatorio 
/*
count(distinct id_escola_inep),
   sum(total) total,
sum(total_x2) total_x2,
    SUM(nr_p) nr_p, 
    SUM(nr_m) nr_m,
    SUM(nr_g) nr_g,
  SUM(nr_g_g) nr_g_g,
   SUM(nr_xg) nr_xg
from relatorio 
*/


