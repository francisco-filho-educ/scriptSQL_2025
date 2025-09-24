with mov as (
select cd_aluno,max(ci_movimento) ci_movimento
        from academico.tb_movimento tm
        join rede_fisica.tb_unidade_trabalho ut on ut.ci_unidade_trabalho=tm.cd_unidade_trabalho_destino 
        join rede_fisica.tb_unidade_trabalho ut2 on ut2.ci_unidade_trabalho=tm.cd_unidade_trabalho_origem 
        where 
        fl_tipo_atividade = 'RG' 
        and nr_anoletivo =  2022 -- ANO LETIVO AVALIADO
        and ut.cd_dependencia_administrativa=2
        and ut2.cd_dependencia_administrativa = 3 
        group by 1
), 
mov_matricula as (
select  
       *
        from academico.tb_ultimomovimento tm
        join academico.tb_situacao ts on ts.ci_situacao = tm.cd_situacao 
        where exists (select 1 from mov m where m.cd_aluno = tm.cd_aluno) 
        and nr_anoletivo =  2022 -- ANO LETIVO AVALIADO

  ), mov_oferta as(
    select 
    m3.nr_anoletivo,
    oi.ci_ofertaitem,
    oi.ds_ofertaitem,
    oi.cd_nivel,
    oi.cd_etapa,
    oi.cd_modalidade,
    oi.cd_unidade_trabalho,
    tmo.ds_tpmovimento,
    cd_situacao,
    m3.cd_aluno
    from academico.tb_ofertaitens oi 
    join mov_matricula m3 
       on m3.cd_ofertaitem_destino = oi.ci_ofertaitem and m3.nr_anoletivo = oi.nr_anoletivo
    join academico.tb_tpmovimento tmo on tmo.ci_tpmovimento = m3.cd_tpmovimento
              join academico.tb_situacao sit on sit.ci_situacao = m3.cd_situacao
              where oi.nr_anoletivo = 2022
              and oi.cd_prefeitura = 0
              and oi.cd_nivel = 27 --in (26,27)
              and cd_etapa in(162,184,188)
              and cd_situacao = 1
    )
    ,escola_origem as (
    select 
    eo.cd_aluno,
    tmc.nm_municipio nm_municipio_origem, 
    tut.nr_codigo_unid_trab inep_escola_origem,
    tut.nm_unidade_trabalho escola_origem
    from academico.tb_movimento eo
    join mov using (ci_movimento)
join rede_fisica.tb_unidade_trabalho tut on eo.cd_unidade_trabalho_origem =  tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
where tlut.fl_sede = TRUE   
)
,alunos as (
select 
ci_aluno,
nm_aluno,
ta.cd_inep_aluno,
to_char(dt_nascimento,'dd/mm/yyyy')dt_nascimento
from academico.tb_aluno ta 
where exists (select 1 from mov where mov.cd_aluno = ci_aluno)
)
/*
SELECT 
nr_anoletivo,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor,
count(distinct cd_aluno) nr_aluno,
count(distinct case when cd_situacao = 2 then m.cd_aluno end) nr_matriculado,
count(distinct case when cd_situacao = 1 then m.cd_aluno end) nr_esperando_confirmacao,
count(distinct case when cd_situacao = 3 then m.cd_aluno end) nr_excluido,
count(distinct case when cd_situacao = 6 then m.cd_aluno end) nr_transferencia
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mov_oferta m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
--and tut.cd_categoria =9
group by 1,2,3
*/
----------------------------
---------------------------    
SELECT 
nr_anoletivo,
cd_aluno,
cd_inep_aluno,
nm_aluno,
dt_nascimento,
nm_municipio_origem, 
inep_escola_origem,
escola_origem,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor,
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mov_oferta m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho 
left join escola_origem o using(cd_aluno)
join alunos a on ci_aluno = m.cd_aluno
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
--and tut.cd_categoria =9
--group by 1,2,3,4,5,6,7,8,7,8,9,10,11,12,1
--ORDER BY 1,2,3,4,6;