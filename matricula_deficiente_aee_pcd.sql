with turma as (
select *
from academico.tb_turma tt 
join academico.tb_nivel on cd_nivel  = ci_nivel
where
tt.nr_anoletivo = 2024
and tt.cd_prefeitura = 0
and tt.fl_ativo = 'S' 
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
            and tut.cd_dependencia_administrativa = 2) --and ci_turma = 965911
)
,ult_ent as (
  select
  cd_aluno,
  cd_turma,
  tu.fl_tipo_atividade 
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2024
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma) --group by 1
  and cd_aluno in (select distinct cd_aluno from academico.tb_aluno_deficiencia tad )
  ) --select count(1) from ult_ent
,deficientes as (
select 
cd_aluno,
case when td.id_tipo  = '2' then 'Autismo'
    when td.id_tipo  = '3' then 'Altas Habilidades/Superdotação' 
    else td.nm_deficiencia end 
     nm_deficiencia
from academico.tb_aluno_deficiencia tad 
join academico.tb_deficiencia td on ci_deficiencia = cd_deficiencia 
where cd_aluno in (select cd_aluno from ult_ent)
group by 1,2
)
, aluno_deficiencia as (
select 
cd_aluno,
string_agg(nm_deficiencia ,', ' ) nm_deficiencia 
from deficientes
group by 1
)
,alunos as (
select 
cd_aluno,
nm_aluno,
to_char(ta2.dt_nascimento,'dd/mm/yyyy') dt_nascimento,
case when fl_sexo = 'M' then 'Masculino' else 'Feminino' end ds_sexo,
tr.ds_raca,
nm_deficiencia
from academico.tb_aluno ta2 
join academico.tb_raca tr on tr.ci_raca = ta2.cd_raca
join aluno_deficiencia def on def.cd_aluno = ci_aluno 
), 
aee as (
select 
cd_aluno,
ds_etapa
from ult_ent
join turma on cd_turma = ci_turma
join academico.tb_etapa on ci_etapa = cd_etapa
where 
cd_nivel not in (26,27,28)
group by 1,2
)
,aluno_aee as (
select-- count(1), count(distinct cd_aluno ) 
cd_aluno,
string_agg(ds_etapa,', ') atendimento 
from aee
group by 1
)
select
t.nr_anoletivo,
crede.ci_unidade_trabalho cd_crede_sefor, 
crede.nm_sigla nm_crede_sefor, 
upper(tmc.nm_municipio) AS nm_municipio,
case 
when  tut.cd_tipo_unid_trab = 402 then 'CCI' 
when  tut.ci_unidade_trabalho = 47258 then 'CREAECE' 
when tut.cd_categoria is null then 'Não se aplica'
else upper(tc.nm_categoria) end AS nm_categoria,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola,
t.ds_ofertaitem,
alunos.*,
coalesce(atendimento,'--' ) atendimento
from ult_ent et
inner join alunos  using(cd_aluno)
left join aluno_aee using(cd_aluno)
inner join turma t on et.cd_turma = t.ci_turma and  t.cd_nivel in (26,27,28)
inner join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
and et.fl_tipo_atividade <> 'AC'
--ORDER BY 2,4,5,7,10,8
