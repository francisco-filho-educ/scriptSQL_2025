select
no_inscrito,
nu_cpf,
nu_nota_cn::numeric,
nu_nota_ch::numeric,
nu_nota_lc::numeric,
nu_nota_mt::numeric,
nu_nota_rd::numeric 
from enem_restrito.tb_enem_alinhado_2012_2020 tea 
where ano::int  =2015
