with excluidos as (
select 
cd_aluno,  
cd_aluno_excluido
from academico.tb_auditoria_aluno_mesclar 
where dt_criacao > '2023-06-01'::date
group by 1,2
)
select
nr_anoletivo,
id_escola_sige,
id_escola_inep,
id_turma_sige,
cd_nivel_sige,
ds_nivel_sige,
cd_etapa_sige,
ds_etapa_sige,
fl_multseriado,
fl_turma_ppl,
cd_turno,
ds_turno,
cd_modalidade,
ds_modalidade,
cd_oferta_ensino,
ds_oferta_ensino,
cd_etapa_aluno,
ds_etapa_aluno,
cd_subetapa,
ds_subetapa,
cd_ano_serie,
ds_ano_serie,
case when m.cd_aluno_excluido is null then m.cd_aluno else et.cd_aluno end cd_aluno
from public.tb_dm_etapa_aluno_2023_06_01 et 
left join  excluidos as m on m.cd_aluno_excluido = et.cd_aluno 
