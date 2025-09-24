with infra as (
select 
nu_ano_censo nr_ano_censo,
tte.co_entidade,
QT_SALAS_UTILIZADAS,
--1. Biblioteca
case when IN_BIBLIOTECA = 1 or IN_BIBLIOTECA_SALA_LEITURA = 1 then 'Sim' else 'Não' end bib_censo,
case when  IN_SALA_LEITURA = 1 then 'Sim' else 'Não' end sala_leitura,
--2. Quadra
case when IN_QUADRA_ESPORTES = 1  then 'Sim' else 'Não' end quadra_censo,
--3. Sala dos professores 
case when IN_SALA_PROFESSOR = 1  then 'Sim' else 'Não' end sala_prof_censo,
--  diretoria e secretaria
case when  IN_SECRETARIA = 1  then 'Sim' else 'Não' end secretaria,
case when IN_SALA_DIRETORIA = 1  then 'Sim' else 'Não' end diretoria,
--4. Lei
case when IN_LABORATORIO_INFORMATICA = 1  then 'Sim' else 'Não' end lei_censo,
--5. Lec
case when IN_LABORATORIO_CIENCIAS = 1  then 'Sim' else 'Não' end lec_censo,
--banheiros
case when IN_BANHEIRO = 1 then 'Sim' else 'Não' end banheiro,
case when  IN_BANHEIRO_PNE = 1  then 'Sim' else 'Não' end banheiro_pne,
--sala aee
case when  IN_SALA_ATENDIMENTO_ESPECIAL = 1  then 'Sim' else 'Não' end sala_aee,
--
case when  IN_ENERGIA_REDE_PUBLICA = 1  then 'Sim' else 'Não' end energia,
case when  IN_INTERNET = 1  then 'Sim' else 'Não' end internet,
case when  IN_AGUA_REDE_PUBLICA = 1  then 'Sim' else 'Não' end agua_publica,
case when  IN_ESGOTO_INEXISTENTE = 1 then 'Não' else 'Sim' end esgoto,
case when  IN_ESGOTO_REDE_PUBLICA = 1  then 'Sim' else 'Não' end esgoto_publico
from censo_esc_ce.tb_escola_2022 tte 
where tp_dependencia = 2 
and tp_situacao_funcionamento = 1
union 
select 
nu_ano_censo nr_ano_censo,
tte.co_entidade,
QT_SALAS_UTILIZADAS,
--1. Biblioteca
case when IN_BIBLIOTECA = 1 or IN_BIBLIOTECA_SALA_LEITURA = 1 then 'Sim' else 'Não' end bib_censo,
case when  IN_SALA_LEITURA = 1 then 'Sim' else 'Não' end sala_leitura,
--2. Quadra
case when IN_QUADRA_ESPORTES = 1  then 'Sim' else 'Não' end quadra_censo,
--3. Sala dos professores 
case when IN_SALA_PROFESSOR = 1  then 'Sim' else 'Não' end sala_prof_censo,
--  diretoria e secretaria
case when  IN_SECRETARIA = 1  then 'Sim' else 'Não' end secretaria,
case when IN_SALA_DIRETORIA = 1  then 'Sim' else 'Não' end diretoria,
--4. Lei
case when IN_LABORATORIO_INFORMATICA = 1  then 'Sim' else 'Não' end lei_censo,
--5. Lec
case when IN_LABORATORIO_CIENCIAS = 1  then 'Sim' else 'Não' end lec_censo,
--banheiros
case when IN_BANHEIRO = 1 then 'Sim' else 'Não' end banheiro,
case when  IN_BANHEIRO_PNE = 1  then 'Sim' else 'Não' end banheiro_pne,
--sala aee
case when  IN_SALA_ATENDIMENTO_ESPECIAL = 1  then 'Sim' else 'Não' end sala_aee,
--
case when  IN_ENERGIA_REDE_PUBLICA = 1  then 'Sim' else 'Não' end energia,
case when  IN_INTERNET = 1  then 'Sim' else 'Não' end internet,
case when  IN_AGUA_REDE_PUBLICA = 1  then 'Sim' else 'Não' end agua_publica,
case when  IN_ESGOTO_INEXISTENTE = 1 then 'Não' else 'Sim' end esgoto,
case when  IN_ESGOTO_REDE_PUBLICA = 1  then 'Sim' else 'Não' end esgoto_publico
from censo_esc_ce.tb_escola_2021 tte 
where tp_dependencia = 2 
and tp_situacao_funcionamento = 1
union 
select 
nu_ano_censo nr_ano_censo,
tte.co_entidade,
QT_SALAS_UTILIZADAS,
--1. Biblioteca
case when IN_BIBLIOTECA = 1 or IN_BIBLIOTECA_SALA_LEITURA = 1 then 'Sim' else 'Não' end bib_censo,
case when  IN_SALA_LEITURA = 1 then 'Sim' else 'Não' end sala_leitura,
--2. Quadra
case when IN_QUADRA_ESPORTES = 1  then 'Sim' else 'Não' end quadra_censo,
--3. Sala dos professores 
case when IN_SALA_PROFESSOR = 1  then 'Sim' else 'Não' end sala_prof_censo,
--  diretoria e secretaria
case when  IN_SECRETARIA = 1  then 'Sim' else 'Não' end secretaria,
case when IN_SALA_DIRETORIA = 1  then 'Sim' else 'Não' end diretoria,
--4. Lei
case when IN_LABORATORIO_INFORMATICA = 1  then 'Sim' else 'Não' end lei_censo,
--5. Lec
case when IN_LABORATORIO_CIENCIAS = 1  then 'Sim' else 'Não' end lec_censo,
--banheiros
case when IN_BANHEIRO = 1 then 'Sim' else 'Não' end banheiro,
case when  IN_BANHEIRO_PNE = 1  then 'Sim' else 'Não' end banheiro_pne,
--sala aee
case when  IN_SALA_ATENDIMENTO_ESPECIAL = 1  then 'Sim' else 'Não' end sala_aee,
--
case when  IN_ENERGIA_REDE_PUBLICA = 1  then 'Sim' else 'Não' end energia,
case when  IN_INTERNET = 1  then 'Sim' else 'Não' end internet,
case when  IN_AGUA_REDE_PUBLICA = 1  then 'Sim' else 'Não' end agua_publica,
case when  IN_ESGOTO_INEXISTENTE = 1 then 'Não' else 'Sim' end esgoto,
case when  IN_ESGOTO_REDE_PUBLICA = 1  then 'Sim' else 'Não' end esgoto_publico
from censo_esc_ce.tb_escola_2020 tte 
where tp_dependencia = 2 
and tp_situacao_funcionamento = 1
union 
select 
nu_ano_censo nr_ano_censo,
tte.co_entidade,
QT_SALAS_UTILIZADAS,
--1. Biblioteca
case when IN_BIBLIOTECA = 1 or IN_BIBLIOTECA_SALA_LEITURA = 1 then 'Sim' else 'Não' end bib_censo,
case when  IN_SALA_LEITURA = 1 then 'Sim' else 'Não' end sala_leitura,
--2. Quadra
case when IN_QUADRA_ESPORTES = 1  then 'Sim' else 'Não' end quadra_censo,
--3. Sala dos professores 
case when IN_SALA_PROFESSOR = 1  then 'Sim' else 'Não' end sala_prof_censo,
--  diretoria e secretaria
case when  IN_SECRETARIA = 1  then 'Sim' else 'Não' end secretaria,
case when IN_SALA_DIRETORIA = 1  then 'Sim' else 'Não' end diretoria,
--4. Lei
case when IN_LABORATORIO_INFORMATICA = 1  then 'Sim' else 'Não' end lei_censo,
--5. Lec
case when IN_LABORATORIO_CIENCIAS = 1  then 'Sim' else 'Não' end lec_censo,
--banheiros
case when IN_BANHEIRO = 1 then 'Sim' else 'Não' end banheiro,
case when  IN_BANHEIRO_PNE = 1  then 'Sim' else 'Não' end banheiro_pne,
--sala aee
case when  IN_SALA_ATENDIMENTO_ESPECIAL = 1  then 'Sim' else 'Não' end sala_aee,
--
case when  IN_ENERGIA_REDE_PUBLICA = 1  then 'Sim' else 'Não' end energia,
case when  IN_INTERNET = 1  then 'Sim' else 'Não' end internet,
case when  IN_AGUA_REDE_PUBLICA = 1  then 'Sim' else 'Não' end agua_publica,
case when  IN_ESGOTO_INEXISTENTE = 1 then 'Não' else 'Sim' end esgoto,
case when  IN_ESGOTO_REDE_PUBLICA = 1  then 'Sim' else 'Não' end esgoto_publico
from censo_esc_ce.tb_escola_2019 tte 
where tp_dependencia = 2 
and tp_situacao_funcionamento = 1
union 
select 
nu_ano_censo nr_ano_censo,
tte.co_entidade,
nu_salas_utilizadas QT_SALAS_UTILIZADAS,
--1. Biblioteca
case when IN_BIBLIOTECA = 1 or IN_BIBLIOTECA_SALA_LEITURA = 1 then 'Sim' else 'Não' end bib_censo,
case when  IN_SALA_LEITURA = 1 then 'Sim' else 'Não' end sala_leitura,
--2. Quadra
case when IN_QUADRA_ESPORTES = 1  then 'Sim' else 'Não' end quadra_censo,
--3. Sala dos professores 
case when IN_SALA_PROFESSOR = 1  then 'Sim' else 'Não' end sala_prof_censo,
--  diretoria e secretaria
case when  IN_SECRETARIA = 1  then 'Sim' else 'Não' end secretaria,
case when IN_SALA_DIRETORIA = 1  then 'Sim' else 'Não' end diretoria,
--4. Lei
case when IN_LABORATORIO_INFORMATICA = 1  then 'Sim' else 'Não' end lei_censo,
--5. Lec
case when IN_LABORATORIO_CIENCIAS = 1  then 'Sim' else 'Não' end lec_censo,
--banheiros
case when IN_BANHEIRO_FORA_PREDIO = 1 or IN_BANHEIRO_DENTRO_PREDIO = 1 then 'Sim' else 'Não' end banheiro,
case when  IN_BANHEIRO_PNE = 1  then 'Sim' else 'Não' end banheiro_pne,
--sala aee
case when  IN_SALA_ATENDIMENTO_ESPECIAL = 1  then 'Sim' else 'Não' end sala_aee,
--
case when  IN_ENERGIA_REDE_PUBLICA = 1  then 'Sim' else 'Não' end energia,
case when  IN_INTERNET = 1  then 'Sim' else 'Não' end internet,
case when  IN_AGUA_REDE_PUBLICA = 1  then 'Sim' else 'Não' end agua_publica,
case when  IN_ESGOTO_INEXISTENTE = 1 then 'Não' else 'Sim' end esgoto,
case when  IN_ESGOTO_REDE_PUBLICA = 1  then 'Sim' else 'Não' end esgoto_publico
from censo_esc_ce.tb_escola_2007_2018  tte 
where tp_dependencia = 2 
and tp_situacao_funcionamento = 1
and nu_ano_censo > 2007
)
select 
tde.nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
nm_municipio,
id_escola_inep,
nm_escola,
ds_dependencia,
ds_categoria_escola_sige,
ds_localizacao,
ds_localizacao_diferenciada,
qt_salas_utilizadas ,
bib_censo   ,
sala_leitura    ,
quadra_censo    ,
sala_prof_censo ,
secretaria  ,
diretoria   ,
lei_censo   ,
lec_censo   ,
banheiro    ,
banheiro_pne    ,
sala_aee    ,
energia ,
internet    ,
agua_publica    ,
esgoto  ,
esgoto_publico 
from dw_censo.tb_dm_escola tde 
join dw_censo.tb_dm_municipio tdm using(id_municipio)
join infra on id_escola_inep = co_entidade and infra.nr_ano_censo = tde.nr_ano_censo 
order by  tde.nr_ano_censo, id_crede_sefor, nm_municipio, nm_escola



