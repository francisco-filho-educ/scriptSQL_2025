with  mov_matricula as (
select *
        from academico.tb_ultimomovimento tm
        join rede_fisica.tb_unidade_trabalho ut on ut.ci_unidade_trabalho=tm.cd_unidade_trabalho_destino 
        where 
        fl_tipo_atividade = 'RG' and nr_anoletivo =  2022 -- ANO LETIVO AVALIADO
        and cd_dependencia_administrativa=2
        --and ut.cd_municipio = 1451           
        and exists(select 1 from public.tb_cubo_sige_2022 tcs where tcs.cd_aluno = tm.cd_aluno and tcs.cd_ano_serie = 12)
        ),
  n_loc as ( 
  select cd_aluno,ci_movimento
  from mov_matricula mm1 where not exists (select cd_aluno from academico.tb_ultimaenturmacao ute
                                            where ute.nr_anoletivo=2022 and ute.cd_aluno =  mm1.cd_aluno)
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
    sit.ds_situacao,
    mm.cd_aluno
    from academico.tb_ofertaitens oi 
    join mov_matricula m3 
       on m3.cd_ofertaitem_destino = oi.ci_ofertaitem and m3.nr_anoletivo = oi.nr_anoletivo
    join n_loc mm using(ci_movimento)
    join academico.tb_tpmovimento tmo on tmo.ci_tpmovimento = m3.cd_tpmovimento
              join academico.tb_situacao sit on sit.ci_situacao = m3.cd_situacao
              where oi.nr_anoletivo = 2022
              and oi.cd_prefeitura = 0
              and oi.cd_nivel = 27 --in (26,27)
              and cd_etapa in (162,184,188,163,185,189,164,186,190)
    ),
    alunos as (
    select 
    ci_aluno cd_aluno,
    nm_aluno,
    to_char(ta.dt_nascimento,'dd/mm/yyyy') dt_nascimento
    from academico.tb_aluno ta 
    where exists (select 1 from n_loc where n_loc.cd_aluno = ci_aluno)
    )
 SELECT 
nr_anoletivo,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor,
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
ci_ofertaitem,
ds_ofertaitem,
cd_nivel,
cd_etapa,
cd_modalidade,
ds_tpmovimento,
ds_situacao,
aa.*
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mov_oferta m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho 
join alunos aa using(cd_aluno)
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
--and tut.cd_categoria =9
--group by 1,2,3--,4,5,6,7,8
--ORDER BY 1,2,3,4,6;