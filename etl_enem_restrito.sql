select
	nu_ano_enem::text ano,
	nu_inscricao,
	nu_cpf,
	no_inscrito,
	nu_nota_cn::text,
	nu_nota_ch::text,
	nu_nota_lc::text,
	nu_nota_mt::text,
	nu_nota_rd::text,
	case when in_pres_cn = 'P' then '7' else case when in_pres_cn = 'F' then '6' else  NULL end end in_pres_cn,
	case when in_pres_ch = 'P' then '7' else case when in_pres_ch = 'F' then '6' else  NULL end end in_pres_ch,
	case when in_pres_lc = 'P' then '7' else case when in_pres_lc = 'F' then '6' else  NULL end end in_pres_lc,
	case when in_pres_mt = 'P' then '7' else case when in_pres_mt = 'F' then '6' else  NULL end end in_pres_mt,
	case when in_pres_rd = 'P' then '7' else case when in_pres_rd = 'F' then '6' else  NULL end end in_pres_rd
from enem_restrito.tb_enem_2012 te 
union 
select
	te2.nu_ano_enem,
	nu_inscricao,
	nu_cpf,
	no_inscrito,
	nu_nota_cn::text,
	nu_nota_ch::text,
	nu_nota_lc::text,
	nu_nota_mt::text,
	nu_nota_rd::text,
	in_pres_cn::text,
	in_pres_ch::text,
	in_pres_lc::text,
	in_pres_mt::text,
	in_pres_rd::text
from enem_restrito.tb_enem_2013 te2
union 
select
	te2.nu_ano_enem,
	nu_inscricao,
	nu_cpf,
	no_inscrito,
	nu_nota_cn::text,
	nu_nota_ch::text,
	nu_nota_lc::text,
	nu_nota_mt::text,
	nu_nota_rd::text,
	in_pres_cn::text,
	in_pres_ch::text,
	in_pres_lc::text,
	in_pres_mt::text,
	nu_nota_lc::text in_pres_rd
from enem_restrito.tb_enem_2014 te2
union 
select
	te2.nu_ano_enem,
	nu_inscricao,
	nu_cpf,
	no_inscrito,
	nu_nota_cn::text,
	nu_nota_ch::text,
	nu_nota_lc::text,
	nu_nota_mt::text,
	nu_nota_rd::text,
	in_pres_cn::text,
	in_pres_ch::text,
	in_pres_lc::text,
	in_pres_mt::text,
	nu_nota_lc::text in_pres_rd
from enem_restrito.tb_enem_2015 te2
union 
select
	te2.nu_ano_enem,
	nu_inscricao,
	nu_cpf,
	no_inscrito,
	nu_nota_cn::text,
	nu_nota_ch::text,
	nu_nota_lc::text,
	nu_nota_mt::text,
	nu_nota_rd::text,
	in_pres_cn::text,
	in_pres_ch::text,
	in_pres_lc::text,
	in_pres_mt::text,
	nu_nota_lc::text in_pres_rd
from enem_restrito.tb_enem_2016 te2
union 
select
	te3.ano::text nu_ano_enem,
	nu_inscricao,
	nu_cpf,
	no_inscrito,
	nu_nota_cn::text,
	nu_nota_ch::text,
	nu_nota_lc::text,
	nu_nota_mt::text,
	nu_nota_rd::text,
	in_pres_cn::text,
	in_pres_ch::text,
	in_pres_lc::text,
	in_pres_mt::text,
	nu_nota_lc::text in_pres_rd
from enem_restrito.tb_enem_2017 te3
union 
select
	te3.ano::text nu_ano_enem,
	nu_inscricao,
	nu_cpf,
	no_inscrito,
	nu_nota_cn::text,
	nu_nota_ch::text,
	nu_nota_lc::text,
	nu_nota_mt::text,
	nu_nota_rd::text,
	in_pres_cn::text,
	in_pres_ch::text,
	in_pres_lc::text,
	in_pres_mt::text,
	nu_nota_lc::text in_pres_rd
from enem_restrito.tb_enem_2018 te3
union 
select
	te3.ano::text nu_ano_enem,
	nu_inscricao,
	nu_cpf,
	no_inscrito,
	nu_nota_cn::text,
	nu_nota_ch::text,
	nu_nota_lc::text,
	nu_nota_mt::text,
	nu_nota_rd::text,
	in_pres_cn::text,
	in_pres_ch::text,
	in_pres_lc::text,
	in_pres_mt::text,
	nu_nota_lc::text in_pres_rd
from enem_restrito.tb_enem_2019 te3
union 
select
	te4.nu_ano_enem::text,
	nu_inscricao,
	nu_cpf,
	no_inscrito,
	nu_nota_cn::text,
	nu_nota_ch::text,
	nu_nota_lc::text,
	nu_nota_mt::text,
	nu_nota_rd::text,
	in_pres_cn::text,
	in_pres_ch::text,
	in_pres_lc::text,
	in_pres_mt::text,
	nu_nota_lc::text in_pres_rd
from enem_restrito.tb_enem_2020 te4



