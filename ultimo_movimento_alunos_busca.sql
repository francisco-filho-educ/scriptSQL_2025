with ultimo_mov as (
select 
cd_aluno,
max(tm.ci_movimento) ci_movimento
from academico.tb_movimento tm
join (select tut.ci_unidade_trabalho from rede_fisica.tb_unidade_trabalho tut 
					where tut.cd_dependencia_administrativa = 2
					) as tut on tut.ci_unidade_trabalho = tm.cd_unidade_trabalho_destino 
where 
fl_tipo_atividade = 'RG' 
and nr_anoletivo = 2024
/*and tm.cd_unidade_trabalho_destino = 261 -- filtro de escola*/
group by 1
        )    
select 
m3.nr_anoletivo,
m3.cd_tpmovimento,
m3.cd_unidade_trabalho_destino id_escola_sige,
oi.ds_ofertaitem,
m3.cd_ofertaitem_destino cd_ofertaitem, 
cd_situacao,
oi.cd_etapa,
sit.ds_situacao,
cd_inep_aluno,
um.cd_aluno,
nm_aluno,
nm_mae,
nm_pai,
ta.nr_cpf,
ta.nr_cia,
ta.nr_identificacao_social,
cod_inep cd_municipio_nascimento, 
concat (ta.nr_ddd_celular,'-',ta.nr_fone_celular) fone_aluno,
concat (ta.nr_ddd_celular_responsavel ,'-',ta.nr_fone_celular_responsavel) fone_responsavel,
m3.dt_criacao
from ultimo_mov um
join academico.tb_movimento m3 using(ci_movimento) 
join academico.tb_aluno ta on ci_aluno = um.cd_aluno
join academico.tb_ofertaitens oi on oi.ci_ofertaitem = m3.cd_ofertaitem_destino and oi.nr_anoletivo = 2024
join academico.tb_situacao sit on sit.ci_situacao = m3.cd_situacao
left join util.tb_localidades l on l.ci_localidade = ta.cd_municipio_nascimento 
where m3.nr_anoletivo = 2024