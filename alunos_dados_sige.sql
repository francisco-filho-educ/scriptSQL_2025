with alunos as (
select 
cd_unidade_trabalho,
ds_ofertaitem,
cd_aluno,
nm_aluno,
ta.ds_email
from academico.tb_turma tt 
join academico.tb_ultimaenturmacao tu on tu.cd_turma = tt.ci_turma 
join academico.tb_aluno ta on ta.ci_aluno = tu.cd_aluno 
where 
tu.fl_tipo_atividade <>'AC'
and tt.nr_anoletivo = 2021
and tt.cd_nivel = 27 
and tt.cd_etapa in (164,186,190)
and tt.cd_prefeitura = 0
and ds_email is not null
)
SELECT 
crede.ci_unidade_trabalho, 
crede.nm_sigla, 
upper(
case when tut.cd_tipo_unid_trab = 402 then 'CCI' else 
tc.nm_categoria end )AS nm_categoria
,tut.nr_codigo_unid_trab, 
tut.nm_unidade_trabalho,
ds_ofertaitem,
cd_aluno,
nm_aluno,
ds_email
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_localidades tmc ON tmc.cd_inep = tlf.cd_municipio_censo
join alunos m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE  --group by 1
ORDER BY 1,3,4,6;