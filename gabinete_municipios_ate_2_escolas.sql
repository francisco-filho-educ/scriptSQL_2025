with mat as (
select cd_unidade_trabalho, count(1) nr_matricula
from academico.tb_turma tt
join academico.tb_ultimaenturmacao tu on tu.cd_turma = ci_turma
where tt.nr_anoletivo = 2022
and tt.cd_prefeitura = 0
and tu.fl_tipo_atividade <> 'AC'
and tt.cd_nivel in (26,27,28)
group by 1
),
escolas_categoria as (
SELECT 
case when ci_categoria in (9,8) then upper(tc.nm_categoria) else 'REGULAR' end nm_categoria , 
tc.ci_categoria, 
tlf.cd_municipio_censo id_municipio,
tm.no_municipio,
count(distinct tut.ci_unidade_trabalho) nr_escolas,
sum(nr_matricula)
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
left JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
left join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
left join rede_fisica.tb_tipo_unid_trab ttut on ttut.ci_tipo_unid_trab = tut.cd_tipo_unid_trab 
left join educacenso_exp.tb_municipio tm on tm.pk_cod_municipio = tlf.cd_municipio_censo 
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
left join rede_fisica.tb_nivel_organizacional tno on tno.ci_nivel_organizacional = ttut.cd_nivel_organizacional 
left join rede_fisica.tb_dependencia_administrativa tda on tda.ci_dependencia_administrativa = tut.cd_dependencia_administrativa 
WHERE tlut.fl_sede = TRUE 
and tut.cd_dependencia_administrativa = 2
group by 1,2,3,4
),
escolas_qtd as (
select 
id_municipio, sum(nr_escolas) nr_escolas_t
from escolas_categoria 
group by 1 having  sum(nr_escolas) <3
), 
municipios_qtd as (
select 
id_municipio,
no_municipio,
nr_escolas_t, 
sum(case when ci_categoria not in (9,8) then nr_escolas else 0 end) nr_regular,
sum(case when ci_categoria = 8  then nr_escolas else 0 end) nr_eeep,
sum(case when ci_categoria = 9  then nr_escolas else 0 end) nr_eemti
from escolas_qtd
join escolas_categoria using(id_municipio)
group by 1,2,3
)
select  * from municipios_qtd 
nr_escolas_t, 
count(1) nr_municipios,
sum(nr_regular) nr_regular,
sum(nr_eeep) nr_eeep,
sum(nr_eemti) nr_eemti
from municipios_qtd 
group by 1

