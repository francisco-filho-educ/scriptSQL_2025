with ultimo_mov as (
select 
cd_aluno,
max(tm.ci_movimento) ci_movimento
from academico.tb_movimento tm
where 
fl_tipo_atividade = 'RG' and nr_anoletivo = 2023
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut 
					where tut.ci_unidade_trabalho = tm.cd_unidade_trabalho_destino 
					and tut.cd_dependencia_administrativa = 2) 
group by 1
        )             
, mov_oferta as( 
select 
m3.nr_anoletivo,
cd_unidade_trabalho_origem,
m3.cd_tpmovimento,
cd_ofertaitem_origem,
od.ds_ofertaitem oferta_origem,
m3.cd_unidade_trabalho_destino,
oi.ds_ofertaitem oferta_destino,
cd_ofertaitem_destino,
m3.cd_aluno,
cd_situacao,
oi.cd_etapa,
sit.ds_situacao
from academico.tb_movimento m3
join ultimo_mov  mm using(ci_movimento)
join academico.tb_ofertaitens oi on oi.ci_ofertaitem = m3.cd_ofertaitem_destino
join academico.tb_ofertaitens od on od.ci_ofertaitem = m3.cd_ofertaitem_origem
left join academico.tb_situacao sit on sit.ci_situacao = m3.cd_situacao
where 
oi.nr_anoletivo = 2023
and oi.fl_tipo_seriacao = 'RG'
)   
select --count(1) from  mov_oferta  --423599
nr_anoletivo,
cd_unidade_trabalho_origem,
cd_ofertaitem_origem,
oferta_origem,
cd_unidade_trabalho_destino,
oferta_destino,
cd_ofertaitem_destino,
cd_aluno,
cd_situacao,
cd_etapa,
ds_situacao,
cd_aluno,
nm_aluno nome_aluno,
nm_mae nome_mae,
nm_pai,
to_char(dt_nascimento,'dd/mm/yyyy') data_nascimento,
ta.nr_cpf,
ta.cd_inep_aluno,
ta.cd_municipio cd_municipio_endereco,
l.ds_localidade nm_municipio_end,
ds_situacao 
from mov_oferta ao
join academico.tb_aluno ta on ta.ci_aluno = ao.cd_aluno
join util.tb_localidades l on l.ci_localidade = ta.cd_municipio
left join util.tb_bairros tb on tb.ci_bairro = ta.cd_bairro