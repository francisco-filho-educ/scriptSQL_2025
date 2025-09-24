with gravidas as (
select 
cd_aluno,
fl_esteve_gravida,
fl_gravida 
from  diario.tb_monitoramento_aluno_anual g 
where nr_ano_letivo = 2023
and (g.fl_gravida or g.fl_esteve_gravida) 
)
,turma as (
select
nr_anoletivo,
ci_turma,
cd_unidade_trabalho
from academico.tb_turma tt 
join academico.tb_turno tn on tn.ci_turno = tt.cd_turno 
where
tt.nr_anoletivo = 2023
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tt.fl_ativo = 'S' 
and cd_etapa <> 137
and exists (select 1 from rede_fisica.tb_unidade_trabalho tut where tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
						and tut.cd_dependencia_administrativa = 2)
)
,ult_ent as (
 select
  cd_aluno,
  cd_turma
  from academico.tb_ultimaenturmacao tu 
  where tu.nr_anoletivo = 2023
  and tu.fl_tipo_atividade <> 'AC'
  and exists (select 1 from turma t where t.ci_turma = tu.cd_turma)
 )
 ,alunos as (
select 
ci_aluno,
case when cd_raca = 1	then 1 else 0 end  fl_Branca,
case when cd_raca = 2	then 1 else 0 end  fl_Preta,
case when cd_raca = 3	then 1 else 0 end  fl_Parda,
case when cd_raca = 4	then 1 else 0 end  fl_Amarela,
case when cd_raca = 5	then 1 else 0 end  fl_Indigena,
case when cd_raca = 6	then 1 else 0 end  fl_Nao_Declarada
from academico.tb_aluno ta 
where fl_sexo = 'F'  
and exists (select 1 from ult_ent u  where u.cd_aluno = ci_aluno )
--and extract(year from age(current_date,ta.dt_nascimento)) between 10 and 49
) 
select count(1) from alunos
,mat as (
select
nr_anoletivo,
cd_unidade_trabalho,
g.cd_aluno,
fl_Branca,
fl_Preta,
fl_Parda,
fl_Amarela,
fl_Indigena,
fl_Nao_Declarada,
fl_esteve_gravida,
fl_gravida 
from turma tt 
join ult_ent ut on ut.cd_turma = ci_turma
join alunos a on ci_aluno = ut.cd_aluno 
left join gravidas g on g.cd_aluno = ut.cd_aluno

)
select 
nr_anoletivo,
crede.ci_unidade_trabalho id_crede_sefor, 
upper(crede.nm_sigla) nm_crede_sefor, 
count(1) total,
count(case when fl_gravida or fl_esteve_gravida then cd_aluno end ) gravida,
sum(	fl_Branca	)	fl_Branca,	
sum(case when 	fl_Branca	= 1	and (fl_gravida or fl_esteve_gravida) then 1 else 0 end)	mr_Branca_grav,
sum(	fl_Preta	)	fl_Preta,	
sum(case when 	fl_Preta	= 1	and (fl_gravida or fl_esteve_gravida) then 1 else 0 end)	mr_Preta_grav,
sum(	fl_Parda	)	fl_Parda,	
sum(case when 	fl_Parda	= 1	and (fl_gravida or fl_esteve_gravida) then 1 else 0 end)	mr_Parda_grav,
sum(	fl_Amarela	)	fl_Amarela,	
sum(case when 	fl_Amarela	= 1	and (fl_gravida or fl_esteve_gravida) then 1 else 0 end)	mr_Amarela_grav,
sum(	fl_Indigena	)	fl_Indigena,	
sum(case when 	fl_Indigena	= 1	and (fl_gravida or fl_esteve_gravida) then 1 else 0 end)	mr_Indigena_grav,
sum(	fl_Nao_Declarada	)	fl_Nao_Declarada,	
sum(case when 	fl_Nao_Declarada	= 1	and (fl_gravida or fl_esteve_gravida) then 1 else 0 end)	mr_Nao_Declarada_grav
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
left JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
group by 1,2,3