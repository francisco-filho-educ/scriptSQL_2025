select 
tum.nr_anoletivo, 
crede.ci_unidade_trabalho id_crede_sefor,
crede.nm_sigla nm_crede_sefor,
count(1) nr_matriculado,
sum(case when exists (select 1 from academico.tb_ultimaenturmacao ute
                                            where ute.nr_anoletivo=2022 and ute.cd_aluno =  tum.cd_aluno) then 1 else 0 end) nr_enturmado
from academico.tb_ultimomovimento tum
join academico.tb_ofertaitens to2 on tum.cd_ofertaitem_destino = to2.ci_ofertaitem 
join academico.tb_tpmovimento tpm on tpm.ci_tpmovimento = tum.cd_tpmovimento 
join academico.tb_situacao ts on ts.ci_situacao = tum.cd_situacao 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tum.cd_unidade_trabalho_destino 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
JOIN rede_fisica.tb_unidade_trabalho origem on origem.ci_unidade_trabalho = tum.cd_unidade_trabalho_origem 
where tum.nr_anoletivo=2022
and tum.cd_tpmovimento in (3,4,5)
and to2.cd_etapa in(162,184,188)
and tum.cd_situacao = 2
and tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = true
and not exists (select 1 from rede_fisica.tb_unidade_trabalho tut2 where tum.cd_unidade_trabalho_origem = tut2.ci_unidade_trabalho and tut2.cd_dependencia_administrativa = 4)
group by 1,2,3
