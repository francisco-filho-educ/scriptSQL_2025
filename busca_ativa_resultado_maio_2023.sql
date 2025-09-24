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
oi_o.ds_ofertaitem oferta_origem,
oi_o.cd_etapa cd_etapa_o,
et_o.ds_etapa ds_etapa_o,
m3.cd_unidade_trabalho_destino,
oi_d.ds_ofertaitem oferta_destino,
m3.cd_aluno,
cd_situacao,
oi_d.cd_etapa cd_etapa_d,
et_d.ds_etapa ds_etapa_d,
sit.ds_situacao,
tm2.ds_motivo,
cd_motivo 
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
, movimento as ( -- movimento
select
tra.nr_anoletivo,
tra.nm_aluno,
tra.nm_mae,
tra.nm_pai,
tra.dt_nascimento,
extract (year from age ('2023-05-31'::date, tra.dt_nascimento::date)) nr_idade,
tra.endereco,
tra.ds_bairro,
tra.ds_localidade,
tra.ds_cep,
tra.fone_aluno,
tra.fone_responsavel,
tra.id_aluno_inep,
id_aluno_sige,
tde.id_crede_sefor,
tde.nm_crede_sefor,
tde.nm_municipio,
tde.id_escola_inep,
tde.nm_escola,
tde.ds_categoria,
mv.ds_etapa_d,
mv.oferta_destino,
mv.ds_situacao,
ds_motivo,
cd_motivo
from tmp.tb_relatorio_movimento tra 
join mov_oferta mv on mv.cd_aluno = tra.id_aluno_sige 
join public.tb_dm_escola tde on tde.id_escola_sige = mv.cd_unidade_trabalho_destino
where (cd_motivo is null or cd_motivo not in (4,15,10,11,9) )
and cd_situacao <> 2
)
select
id_crede_sefor,
nm_crede_sefor,
COUNT(1)
from movimento group by 1,2

 * 
 */
-----
,abandono as (
select -- abandono
tra.nr_anoletivo,
tra.nm_aluno,
tra.nm_mae,
tra.nm_pai,
tra.dt_nascimento,
extract (year from age ('2023-05-31'::date, tra.dt_nascimento::date)) nr_idade,
tra.endereco,
tra.ds_bairro,
tra.ds_localidade,
tra.ds_cep,
tra.fone_aluno,
tra.fone_responsavel,
tra.id_aluno_inep,
tra.id_aluno_sige,
tra.id_crede_sefor,
tra.nm_crede_sefor,
tra.nm_municipio,
tra.id_escola_inep,
tra.nm_escola,
tra.nm_categoria,
tra.ds_etapa,
tra.ds_oferta,
mv.ds_situacao
from tmp.tb_relatorio_abandono tra 
join mov_oferta mv on mv.cd_aluno = tra.id_aluno_sige 
where not exists (select 1 from movimento rm where rm.id_aluno_sige = tra.id_aluno_sige) 
and cd_situacao <> 2
)
select
tde.id_crede_sefor,
tde.nm_crede_sefor,
coalesce (COUNT(a.id_aluno_sige),0) qtd
from public.tb_dm_escola tde 
left join abandono a on tde.id_escola_inep::text = a.id_escola_inep::text 
group by 1,2
order by 1
----------------------------------------