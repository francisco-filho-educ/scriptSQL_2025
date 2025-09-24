/*
drop table if exists tmp.tb_alvo;
create table tmp.tb_alvo as (
with excluidos as (
select 
cd_aluno,  
cd_aluno_excluido
from academico.tb_auditoria_aluno_mesclar 
where dt_criacao > '2023-06-01'::date
group by 1,2
)
,alunos as (
select
id_turma_sige cd_turma,
ds_sexo,
ds_raca,
case when m.cd_aluno_excluido is null then et.cd_aluno else m.cd_aluno end cd_aluno,
nm_aluno,
p.dt_nascimento 
from public.tb_dm_etapa_aluno_2023_06_01 et 
join public.tb_dm_aluno_pessoa_2023_06_01 p using(cd_aluno)
left join  excluidos as m on m.cd_aluno_excluido = et.cd_aluno 
)
,turmas as (
select 
ci_turma
from academico.tb_turma tt 
where 
tt.nr_anoletivo = 2023 
and tt.cd_nivel in (26,27,28)
and tt.fl_tipo_seriacao = 'RG'
and cd_prefeitura  = 0
)
,boletim as (
select 
distinct cd_aluno
from rendimento.tb_detalhes_boletim_2023 tdb 
where 
exists (select 1 from turmas where cd_turma = ci_turma)
and tdb.nr_mediafinal is not null
)
select 
*
from alunos a 
where 
not exists (select 1 from academico.tb_ultimaenturmacao  b where b.cd_aluno  = a.cd_aluno and nr_anoletivo = 2023 and b.fl_tipo_atividade <> 'AC')
);

*/

with ultimo_mov as (
select 
cd_aluno,
max(tm.ci_movimento) ci_movimento
from academico.tb_movimento tm
where 
fl_tipo_atividade = 'RG' and nr_anoletivo = 2023
and exists (select 1 from tmp.tb_alvo a where tm.cd_aluno = a.cd_aluno)
group by 1
        )      
, mov_oferta as( 
select
m3.nr_anoletivo,
cd_unidade_trabalho_origem,
m3.cd_tpmovimento,
oi_o.ds_ofertaitem oferta_origem,
oi_o.cd_etapa cd_etapa_o,
et_o.ds_etapa ds_etapa_o,
m3.cd_unidade_trabalho_destino,
oi_d.ds_ofertaitem oferta_destino,
m3.cd_aluno,
cd_situacao,
cd_motivo,
oi_d.cd_etapa cd_etapa_d,
et_d.ds_etapa ds_etapa_d,
sit.ds_situacao,
tm2.ds_motivo
from academico.tb_movimento m3
join ultimo_mov  mm using(ci_movimento)
join academico.tb_ofertaitens oi_d on oi_d.ci_ofertaitem = m3.cd_ofertaitem_destino
join academico.tb_ofertaitens oi_o on oi_o.ci_ofertaitem = m3.cd_ofertaitem_origem
join academico.tb_etapa et_o on et_o.ci_etapa = oi_o.cd_etapa
join academico.tb_etapa et_d on et_d.ci_etapa = oi_d.cd_etapa
left join academico.tb_situacao sit on sit.ci_situacao = m3.cd_situacao
left join academico.tb_motivo tm2 on ci_motivo = m3.cd_motivo 
where 
oi_d.nr_anoletivo = 2023
and oi_d.fl_tipo_seriacao = 'RG'
) 
,escolas as (
SELECT 
2023 nr_ano_sige,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
case when tut.cd_categoria is null then 'Não se aplica'
           when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
	       when  tut.ci_unidade_trabalho = 47258 then 'CREAECE' 
           when tut.cd_categoria in (155,193,194,200,212,517,558,395,291,292,433,442,484,273,278,47724,47747,47788,47975,50025,50199,47244,242) then 'TEMPO INTEGRAL' -- NOVAS EEMTIS 2023
	       else upper(tc.nm_categoria) end AS ds_categoria,
tut.ci_unidade_trabalho id_escola_sige,
tut.nr_codigo_unid_trab id_escola_inep, 
upper(tut.nm_unidade_trabalho) nm_escola,
upper(tlz.nm_localizacao_zona) AS ds_localizacao,
tut.cd_situacao_funcionamento,
tsf.nm_situacao_funcionamento
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join rede_fisica.tb_situacao_funcionamento tsf on tsf.ci_situacao_funcionamento = tut.cd_situacao_funcionamento 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab in (402,401)
AND tlut.fl_sede = TRUE 
)
select 
nr_anoletivo,
id_crede_sefor, 
nm_crede_sefor, 
nm_municipio,
id_escola_inep,
nm_escola,
ds_categoria,
oferta_destino,
cd_etapa_d,
ds_etapa_d,
cd_aluno,
cd_situacao,
cd_motivo,
ta.nm_aluno,
av.dt_nascimento,
ds_raca,
ds_sexo,
extract(year from age('2023-05-31'::date,ta.dt_nascimento)) idade,
concat(ta.ds_logradouro, ', ',ta.ds_numero,', ',ta.ds_complemento) endereco,
tb.ds_bairro,
l.ds_localidade,
ta.ds_cep,
concat (ta.nr_ddd_celular,'-',ta.nr_fone_celular) fone_aluno,
concat (ta.nr_ddd_celular_responsavel ,'-',ta.nr_fone_celular_responsavel) fone_responsavel,
ds_situacao,
ds_motivo
from mov_oferta ao
join tmp.tb_alvo av using(cd_aluno)
join escolas on cd_unidade_trabalho_destino = id_escola_sige
join academico.tb_aluno ta on ta.ci_aluno = ao.cd_aluno
join util.tb_localidades l on l.ci_localidade = ta.cd_municipio
left join util.tb_bairros tb on tb.ci_bairro = ta.cd_bairro