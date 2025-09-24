select
substring(tpf.no_pessoa_fisica,1,5) key_nome,
nu_cpf::bigint,
nu_ano_censo,
co_pessoa_fisica,
no_pessoa_fisica
from censo_esc_ce.tb_pessoa_fisica_2007_2017 tpf
join censo_esc_ce.tb_



select
substring(tpf.no_pessoa_fisica,1,5) key 
from censo_esc_ce.tb_pessoa_fisica_2007_2017 tpf
join enem_restrito.tb_enem_2012 te on te.nu_cpf = tpf.nu_cpf 