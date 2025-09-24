with doc_curso as (
SELECT
doc.co_pessoa_fisica,
co_curso_1 co_curso
from censo_esc_ce.tb_docente_2020 doc
where
nu_ano_censo = 2020
and
co_uf = 23
and tp_tipo_docente in (1,5)
and tp_dependencia in (2,3)
and co_curso_1 is not null 
group by 1,2
union
SELECT
doc.co_pessoa_fisica,
co_curso_2 co_curso
from censo_esc_ce.tb_docente_2020 doc
where
nu_ano_censo =2020 --between 2008 and 2017
and
co_uf = 23
and tp_tipo_docente in (1,5)
and tp_dependencia in (2,3)
and co_curso_2 is not null 
group by 1,2
union
SELECT
doc.co_pessoa_fisica,
co_curso_3 co_curso
from censo_esc_ce.tb_docente_2020 doc
where
nu_ano_censo =2020 --between 2008 and 2017
and
co_uf = 23
and tp_tipo_docente in (1,5)
and tp_dependencia in (2,3)
and co_curso_3 is not null 
group by 1,2
), 
doc_disciplina as (
select
nu_ano_censo,
CO_PESSOA_FISICA,
tp_dependencia,
co_municipio,
max(in_disc_lingua_portuguesa) in_disc_lingua_portuguesa,
max(IN_DISC_EDUCACAO_FISICA)  IN_DISC_EDUCACAO_FISICA,
max(IN_DISC_ARTES)  IN_DISC_ARTES,
max(IN_DISC_LINGUA_INGLES)  IN_DISC_LINGUA_INGLES,
max(IN_DISC_LINGUA_ESPANHOL)  IN_DISC_LINGUA_ESPANHOL,
max(IN_DISC_LINGUA_FRANCES)  IN_DISC_LINGUA_FRANCES,
max(IN_DISC_LINGUA_OUTRA)  IN_DISC_LINGUA_OUTRA,
max(IN_DISC_LIBRAS)  IN_DISC_LIBRAS,
max(IN_DISC_LINGUA_INDIGENA)  IN_DISC_LINGUA_INDIGENA,
max(IN_DISC_PORT_SEGUNDA_LINGUA)  IN_DISC_PORT_SEGUNDA_LINGUA,
max(IN_DISC_MATEMATICA)  IN_DISC_MATEMATICA,
max(IN_DISC_CIENCIAS)  IN_DISC_CIENCIAS,
max(IN_DISC_FISICA)  IN_DISC_FISICA,
max(IN_DISC_QUIMICA)  IN_DISC_QUIMICA,
max(IN_DISC_BIOLOGIA)  IN_DISC_BIOLOGIA,
max(IN_DISC_HISTORIA)  IN_DISC_HISTORIA,
max(IN_DISC_GEOGRAFIA)  IN_DISC_GEOGRAFIA,
max(IN_DISC_SOCIOLOGIA)  IN_DISC_SOCIOLOGIA,
max(IN_DISC_FILOSOFIA)  IN_DISC_FILOSOFIA,
max(IN_DISC_ESTUDOS_SOCIAIS)  IN_DISC_ESTUDOS_SOCIAIS,
max(IN_DISC_EST_SOCIAIS_SOCIOLOGIA)  IN_DISC_EST_SOCIAIS_SOCIOLOGIA,
max(IN_DISC_ENSINO_RELIGIOSO) IN_DISC_ENSINO_RELIGIOSO
from censo_esc_ce.tb_docente_2020 doc
join dw_censo.tb_dm_etapa tde on doc.tp_etapa_ensino = tde.cd_etapa_ensino 
where
nu_ano_censo = 2020 --between 2008 and 2017
and
co_uf = 23
and tp_tipo_docente in (1,5)
and tp_dependencia in (2,3)
and cd_etapa in (2,3)
group by 1,2,3,4
),
--DISCIPLINA CURSO -----------------------------------------------------
doc_disciplina_curso as (
select
nu_ano_censo,
co_municipio,
tp_dependencia,
--inicio portugues
case when
in_disc_lingua_portuguesa = 1 
and 
co_curso not in ('0115L131','0115L111','0115L121','0115L141','0115L151','0115L161','0115L171','0115L181','0115L191','0115L201',
'0231L122','0231L132','0231L142','0231L152','0231L162','0231L172','0231L182','0231L212','0231L192','0231L202')
then dd.co_pessoa_fisica end doc_portugues, 
--inicio lingua estrangeira
case when 
(
 in_disc_lingua_ingles = 1
 or 
  in_disc_lingua_espanhol = 1
 or 
  in_disc_lingua_frances  = 1
 or 
  in_disc_lingua_outra = 1
)
and 
co_curso not in ('0115L041','0115L151','0115L021','0115L121','0115L031','0115L141','0115L011','0115L111','0115L051','0115L161','0115L061','0115L171','0115L101','0115L201',
'0231L052','0231L162','0231L032','0231L142','0231L042','0231L152','0231L062','0231L172','0231L072','0231L182','0231L012','0231L132','0231L212','0231L112')  
then dd.co_pessoa_fisica end doc_lingua_estrang, 
--inicio artes
case when 
in_disc_artes = 1 
and 
co_curso not in ('0114A011','0114A021','0114D011','0114M021','0114T011',
'0213A012','0213A032','0215D012','0215M012','0215T012','0213A022','0215A012')
then dd.co_pessoa_fisica end doc_artes,  
--inicio educacao fisica
case when
in_disc_educacao_fisica = 1 
and 
 co_curso not in ('0915E012','0114E031')  
then dd.co_pessoa_fisica end doc_ed_fisica,  
--inicio Matematica
case when 
in_disc_matematica = 1 
and 
co_curso not in  ('0114M011','0541M012','0541M022')
then dd.co_pessoa_fisica end doc_mat,  
--inicio Ciencias
case when 
 in_disc_ciencias = 1 
and 
co_curso not  in ('0114B011','0114C021','0114F021','0114F021','0511B012','0533F012','0531Q012','0588P012')  
then dd.co_pessoa_fisica end doc_ciencias,  
--inicio Quimica
case when
 in_disc_quimica = 1 
and 
co_curso not in ('0114C021','0114Q011','0531Q012')  
then dd.co_pessoa_fisica end doc_quimica,  
--inicio Fisica
case when 
in_disc_fisica = 1 
and 
co_curso not in ('0114C021','0114F021','0533F012','0533F022')  
then dd.co_pessoa_fisica end doc_fisica,  
--inicio Biologia
case when
 in_disc_biologia = 1 
and 
co_curso not in ('0114C021','0114B011','0511B012') 
then dd.co_pessoa_fisica end doc_biologia,  
--inicio Estudos Sociais
case when 
 in_disc_estudos_sociais = 1 
and 
co_curso not in ('0114G011','0114H011','0114C031','0312G012','0222H012','0312C022','0312A012') 
then dd.co_pessoa_fisica end doc_estudos_sociais,  
--inicio Historia
case when
in_disc_historia = 1 
and 
co_curso not in ('0114H011','0222H012') 
then dd.co_pessoa_fisica end doc_historia,  
--inicio Geografia
case when 
in_disc_geografia = 1 
and 
co_curso not in ('0114G011','0312G012') 
then dd.co_pessoa_fisica end doc_geografia,  
--inicio Sociologia
case when
in_disc_sociologia = 1 
and 
co_curso not in ('0114C031','0312C022','0312A012','0312S012') 
then dd.co_pessoa_fisica end doc_sociologia,  
--inicio Filosofia
case when
in_disc_filosofia = 1 
and 
co_curso not in ('0114F011','0223F012') 
then dd.co_pessoa_fisica end doc_filosofia,  
--inicio Ensino Religioso
case when
in_disc_ensino_religioso = 1 
and 
co_curso not in ('0114E071','0221T012','0221C012') 
then dd.co_pessoa_fisica end doc_ensino_religioso,
-- TOTAIS
-- in_disc_lingua_portuguesa
case when
in_disc_lingua_portuguesa = 1 
then dd.co_pessoa_fisica end doc_portugues_total, 
--inicio lingua estrangeira
case when 
(
 in_disc_lingua_ingles = 1
 or 
  in_disc_lingua_espanhol = 1
 or 
  in_disc_lingua_frances  = 1
 or 
  in_disc_lingua_outra = 1
)
then dd.co_pessoa_fisica end doc_lingua_estrang_total, 
--inicio artes
case when 
in_disc_artes = 1 
then dd.co_pessoa_fisica end doc_artes_total,  
--inicio educacao fisica
case when
in_disc_educacao_fisica = 1 
then dd.co_pessoa_fisica end doc_ed_fisica_total,  
--inicio Matematica
case when 
in_disc_matematica = 1 
then dd.co_pessoa_fisica end doc_mat_total,  
--inicio Ciencias
case when 
 in_disc_ciencias = 1 
then dd.co_pessoa_fisica end doc_ciencias_total,  
--inicio Quimica
case when
 in_disc_quimica = 1 
then dd.co_pessoa_fisica end doc_quimica_total,  
--inicio Fisica
case when 
in_disc_fisica = 1 
then dd.co_pessoa_fisica end doc_fisica_total,  
--inicio Biologia
case when
 in_disc_biologia = 1 
then dd.co_pessoa_fisica end doc_biologia_total,  
--inicio Estudos Sociais
case when 
 in_disc_estudos_sociais = 1 
then dd.co_pessoa_fisica end doc_estudos_sociais_total,  
--inicio Historia
case when
in_disc_historia = 1 
then dd.co_pessoa_fisica end doc_historia_total,  
--inicio Geografia
case when 
in_disc_geografia = 1 
then dd.co_pessoa_fisica end doc_geografia_total,  
--inicio Sociologia
case when
in_disc_sociologia = 1 
then dd.co_pessoa_fisica end doc_sociologia_total,  
--inicio Filosofia
case when
in_disc_filosofia = 1 
then dd.co_pessoa_fisica end doc_filosofia_total,  
--inicio Ensino Religioso
case when
in_disc_ensino_religioso = 1 
then dd.co_pessoa_fisica end doc_ensino_religioso_total 
from doc_disciplina  dd
left join doc_curso dc on dc.co_pessoa_fisica = dd.co_pessoa_fisica
where 
(IN_DISC_LINGUA_PORTUGUESA=1 OR 
IN_DISC_EDUCACAO_FISICA=1 OR 
IN_DISC_ARTES=1 OR 
IN_DISC_LINGUA_INGLES=1 OR 
IN_DISC_LINGUA_ESPANHOL=1 OR 
IN_DISC_LINGUA_FRANCES=1 OR 
IN_DISC_PORT_SEGUNDA_LINGUA=1 OR 
IN_DISC_MATEMATICA=1 OR 
IN_DISC_CIENCIAS=1 OR 
IN_DISC_FISICA=1 OR 
IN_DISC_QUIMICA=1 OR 
IN_DISC_BIOLOGIA=1 OR 
IN_DISC_HISTORIA=1 OR 
IN_DISC_GEOGRAFIA=1 OR 
IN_DISC_SOCIOLOGIA=1 OR 
IN_DISC_FILOSOFIA=1 OR 
IN_DISC_ESTUDOS_SOCIAIS=1 OR 
IN_DISC_EST_SOCIAIS_SOCIOLOGIA=1 OR 
IN_DISC_ENSINO_RELIGIOSO=1)
)
-- TOTAIS --------------------------------------------------------------------------------------------------
,doc_totais as (
select 
dd.nu_ano_censo,
dd.co_pessoa_fisica,
dd.co_municipio,
dd.tp_dependencia,
case 
when -- lingua portuguesa
(
in_disc_lingua_portuguesa = 1 
and 
co_curso not in ('0115L131','0115L111','0115L121','0115L141','0115L151','0115L161','0115L171','0115L181','0115L191','0115L201',
'0231L122','0231L132','0231L142','0231L152','0231L162','0231L172','0231L182','0231L212','0231L192','0231L202')
)
or -- lingua estrangeira
(
(
 in_disc_lingua_ingles = 1
 or 
  in_disc_lingua_espanhol = 1
 or 
  in_disc_lingua_frances  = 1
 or 
  in_disc_lingua_outra = 1
)
and 
co_curso not in ('0115L041','0115L151','0115L021','0115L121','0115L031','0115L141','0115L011','0115L111','0115L051','0115L161','0115L061','0115L171','0115L101','0115L201',
'0231L052','0231L162','0231L032','0231L142','0231L042','0231L152','0231L062','0231L172','0231L072','0231L182','0231L012','0231L132','0231L212','0231L112') 
)
or -- artes
(
in_disc_artes = 1 
and 
co_curso not in ('0114A011','0114A021','0114D011','0114M021','0114T011',
'0213A012','0213A032','0215D012','0215M012','0215T012','0213A022','0215A012') 
)
or --inicio educacao fisica
(
in_disc_educacao_fisica = 1 
and 
 co_curso not in ('0915E012','0114E031')  
)
or --inicio Matematica
(
in_disc_matematica = 1 
and 
co_curso not in ('0114M011','0541M012','0541M022') 
) 
or --inicio Ciencias
(
 in_disc_ciencias = 1 
and 
co_curso not  in ('0114B011','0114C021','0114F021','0114F021','0511B012','0533F012','0531Q012','0588P012')  
)
or --inicio Quimica
(
 in_disc_quimica = 1 
and 
co_curso not in ('0114C021','0114Q011','0531Q012') 
)
or --inicio Fisica
(
in_disc_fisica = 1 
and 
co_curso not in ('0114C021','0114F021','0533F012','0533F022')  
)
or --inicio Biologia
(
in_disc_biologia = 1 
and 
co_curso not in ('0114C021','0114B011','0511B012')
)
or --inicio Estudos Sociais
(
 in_disc_estudos_sociais = 1 
and 
co_curso not in ('0114G011','0114H011','0114C031','0312G012','0222H012','0312C022','0312A012') 
)
or--inicio Historia
(
in_disc_historia = 1 
and 
co_curso not in ('0114H011','0222H012')
)
or --inicio Geografia
(
in_disc_geografia = 1 
and 
co_curso not in ('0114G011','0312G012') 
)
or --inicio Sociologia
(
in_disc_sociologia = 1 
and 
co_curso not in ('0114C031','0312C022','0312A012','0312S012') 
)
or --inicio Filosofia
(
in_disc_filosofia = 1 
and 
co_curso not in ('0114F011','0223F012')
)
or--inicio Ensino Religioso
(
in_disc_ensino_religioso = 1 
and 
co_curso not in ('0114E071','0221T012','0221C012') 
) 
then 1 else 0 end fl_inadequado
from doc_disciplina  dd
left join doc_curso dc on dc.co_pessoa_fisica = dd.co_pessoa_fisica
where 
(IN_DISC_LINGUA_PORTUGUESA=1 OR 
IN_DISC_EDUCACAO_FISICA=1 OR 
IN_DISC_ARTES=1 OR 
IN_DISC_LINGUA_INGLES=1 OR 
IN_DISC_LINGUA_ESPANHOL=1 OR 
IN_DISC_LINGUA_FRANCES=1 OR 
IN_DISC_PORT_SEGUNDA_LINGUA=1 OR 
IN_DISC_MATEMATICA=1 OR 
IN_DISC_CIENCIAS=1 OR 
IN_DISC_FISICA=1 OR 
IN_DISC_QUIMICA=1 OR 
IN_DISC_BIOLOGIA=1 OR 
IN_DISC_HISTORIA=1 OR 
IN_DISC_GEOGRAFIA=1 OR 
IN_DISC_SOCIOLOGIA=1 OR 
IN_DISC_FILOSOFIA=1 OR 
IN_DISC_ESTUDOS_SOCIAIS=1 OR 
IN_DISC_EST_SOCIAIS_SOCIOLOGIA=1 OR 
IN_DISC_ENSINO_RELIGIOSO=1)
)
, qtd_municipio_dep as (
select 
nu_ano_censo,
co_municipio,
tp_dependencia,
count(distinct co_pessoa_fisica ) qtd_total,
count(distinct case when fl_inadequado  = 1 then co_pessoa_fisica end ) qtd_inadequado
from doc_totais
group by 1,2,3
)
, qtd_municipio_total as (
select 
nu_ano_censo,
co_municipio,
8 tp_dependencia,
count(distinct co_pessoa_fisica ) qtd_total,
count(distinct case when fl_inadequado  = 1 then co_pessoa_fisica end ) qtd_inadequado
from doc_totais
group by 1,2,3
)
select  --* from doc_disciplina_curso
dt.nu_ano_censo,
nm_municipio,
dt.co_municipio,
dt.tp_dependencia,
case when dt.tp_dependencia = 2 then 'Estadual' else 'Municipal' end ds_dependencia, 
qtd_total,
qtd_inadequado,
round(qtd_inadequado::numeric/qtd_total::numeric*100,1) perc_total,
count(distinct doc_artes_total)  doc_artes_total,
count(distinct doc_artes)  doc_artes,
round(case when count(distinct doc_artes_total) < 1 then 0.0 else count(distinct doc_artes)::numeric/count(distinct doc_artes_total)::numeric*100 end,1) perc_artes,
count(distinct doc_biologia_total)  doc_biologia_total,
count(distinct doc_biologia)  doc_biologia,
round(case when count(distinct doc_biologia_total) < 1 then 0.0 else count(distinct doc_biologia)::numeric/count(distinct doc_biologia_total)::numeric*100 end,1) perc_biologia,
count(distinct doc_ciencias_total)  doc_ciencias_total,
count(distinct doc_ciencias)  doc_ciencias,
round(case when count(distinct doc_ciencias_total) < 1 then 0.0 else count(distinct doc_ciencias)::numeric/count(distinct doc_ciencias_total)::numeric*100 end,1) perc_ciencias,
count(distinct doc_ed_fisica_total)  doc_ed_fisica_total,
count(distinct doc_ed_fisica)  doc_ed_fisica,
round(case when count(distinct doc_ed_fisica_total) < 1 then 0.0 else count(distinct doc_ed_fisica)::numeric/count(distinct doc_ed_fisica_total)::numeric*100 end,1) perc_ed_fisica,
count(distinct doc_ensino_religioso_total)  doc_ensino_religioso_total,
count(distinct doc_ensino_religioso)  doc_ensino_religioso,
round(case when count(distinct doc_ensino_religioso_total) < 1 then 0.0 else count(distinct doc_ensino_religioso)::numeric/count(distinct doc_ensino_religioso_total)::numeric*100 end,1) perc_ensino_religioso,
count(distinct doc_filosofia_total)  doc_filosofia_total,
count(distinct doc_filosofia)  doc_filosofia,
round(case when count(distinct doc_filosofia_total) < 1 then 0.0 else count(distinct doc_filosofia)::numeric/count(distinct doc_filosofia_total)::numeric*100 end,1) perc_filosofia,
count(distinct doc_fisica_total)  doc_fisica_total,
count(distinct doc_fisica)  doc_fisica,
round(case when count(distinct doc_fisica_total) < 1 then 0.0 else count(distinct doc_fisica)::numeric/count(distinct doc_fisica_total)::numeric*100 end,1) perc_fisica,
count(distinct doc_geografia_total)  doc_geografia_total,
count(distinct doc_geografia)  doc_geografia,
round(case when count(distinct doc_geografia_total) < 1 then 0.0 else count(distinct doc_geografia)::numeric/count(distinct doc_geografia_total)::numeric*100 end,1) perc_geografia,
count(distinct doc_historia_total)  doc_historia_total,
count(distinct doc_historia)  doc_historia,
round(case when count(distinct doc_historia_total) < 1 then 0.0 else count(distinct doc_historia)::numeric/count(distinct doc_historia_total)::numeric*100 end,1) perc_historia,
count(distinct doc_lingua_estrang_total)  doc_lingua_estrang_total,
count(distinct doc_lingua_estrang)  doc_lingua_estrang,
round(case when count(distinct doc_lingua_estrang_total) < 1 then 0.0 else count(distinct doc_lingua_estrang)::numeric/count(distinct doc_lingua_estrang_total)::numeric*100 end,1) perc_lingua_estrang,
count(distinct doc_mat_total)  doc_mat_total,
count(distinct doc_mat)  doc_mat,
round(case when count(distinct doc_mat_total) < 1 then 0.0 else count(distinct doc_mat)::numeric/count(distinct doc_mat_total)::numeric*100 end,1) perc_mat,
count(distinct doc_portugues_total)  doc_portugues_total,
count(distinct doc_portugues)  doc_portugues,
round(case when count(distinct doc_portugues_total) < 1 then 0.0 else count(distinct doc_portugues)::numeric/count(distinct doc_portugues_total)::numeric*100 end,1) perc_portugues,
count(distinct doc_quimica_total)  doc_quimica_total,
count(distinct doc_quimica)  doc_quimica,
round(case when count(distinct doc_quimica_total) < 1 then 0.0 else count(distinct doc_quimica)::numeric/count(distinct doc_quimica_total)::numeric*100 end,1) perc_quimica,
count(distinct doc_sociologia_total)  doc_sociologia_total,
count(distinct doc_sociologia)  doc_sociologia,
round(case when count(distinct doc_sociologia_total) < 1 then 0.0 else count(distinct doc_sociologia)::numeric/count(distinct doc_sociologia_total)::numeric*100 end,1) perc_sociologia
from qtd_municipio_dep dt 
join doc_disciplina_curso dc using(tp_dependencia,co_municipio)
join dw_censo.tb_dm_municipio tdm on id_municipio = dc.co_municipio
--where dt.co_municipio = 2304400
group by 1,2,3,4,5,6,7
union
select  --* from doc_disciplina_curso
dt.nu_ano_censo,
nm_municipio,
dt.co_municipio,
dt.tp_dependencia,
'TOTAL'  ds_dependencia, 
qtd_total,
qtd_inadequado,
round(qtd_inadequado::numeric/qtd_total::numeric*100,1) perc_total,
count(distinct doc_artes_total)  doc_artes_total,
count(distinct doc_artes)  doc_artes,
round(case when count(distinct doc_artes_total) < 1 then 0.0 else count(distinct doc_artes)::numeric/count(distinct doc_artes_total)::numeric*100 end,1) perc_artes,
count(distinct doc_biologia_total)  doc_biologia_total,
count(distinct doc_biologia)  doc_biologia,
round(case when count(distinct doc_biologia_total) < 1 then 0.0 else count(distinct doc_biologia)::numeric/count(distinct doc_biologia_total)::numeric*100 end,1) perc_biologia,
count(distinct doc_ciencias_total)  doc_ciencias_total,
count(distinct doc_ciencias)  doc_ciencias,
round(case when count(distinct doc_ciencias_total) < 1 then 0.0 else count(distinct doc_ciencias)::numeric/count(distinct doc_ciencias_total)::numeric*100 end,1) perc_ciencias,
count(distinct doc_ed_fisica_total)  doc_ed_fisica_total,
count(distinct doc_ed_fisica)  doc_ed_fisica,
round(case when count(distinct doc_ed_fisica_total) < 1 then 0.0 else count(distinct doc_ed_fisica)::numeric/count(distinct doc_ed_fisica_total)::numeric*100 end,1) perc_ed_fisica,
count(distinct doc_ensino_religioso_total)  doc_ensino_religioso_total,
count(distinct doc_ensino_religioso)  doc_ensino_religioso,
round(case when count(distinct doc_ensino_religioso_total) < 1 then 0.0 else count(distinct doc_ensino_religioso)::numeric/count(distinct doc_ensino_religioso_total)::numeric*100 end,1) perc_ensino_religioso,
count(distinct doc_filosofia_total)  doc_filosofia_total,
count(distinct doc_filosofia)  doc_filosofia,
round(case when count(distinct doc_filosofia_total) < 1 then 0.0 else count(distinct doc_filosofia)::numeric/count(distinct doc_filosofia_total)::numeric*100 end,1) perc_filosofia,
count(distinct doc_fisica_total)  doc_fisica_total,
count(distinct doc_fisica)  doc_fisica,
round(case when count(distinct doc_fisica_total) < 1 then 0.0 else count(distinct doc_fisica)::numeric/count(distinct doc_fisica_total)::numeric*100 end,1) perc_fisica,
count(distinct doc_geografia_total)  doc_geografia_total,
count(distinct doc_geografia)  doc_geografia,
round(case when count(distinct doc_geografia_total) < 1 then 0.0 else count(distinct doc_geografia)::numeric/count(distinct doc_geografia_total)::numeric*100 end,1) perc_geografia,
count(distinct doc_historia_total)  doc_historia_total,
count(distinct doc_historia)  doc_historia,
round(case when count(distinct doc_historia_total) < 1 then 0.0 else count(distinct doc_historia)::numeric/count(distinct doc_historia_total)::numeric*100 end,1) perc_historia,
count(distinct doc_lingua_estrang_total)  doc_lingua_estrang_total,
count(distinct doc_lingua_estrang)  doc_lingua_estrang,
round(case when count(distinct doc_lingua_estrang_total) < 1 then 0.0 else count(distinct doc_lingua_estrang)::numeric/count(distinct doc_lingua_estrang_total)::numeric*100 end,1) perc_lingua_estrang,
count(distinct doc_mat_total)  doc_mat_total,
count(distinct doc_mat)  doc_mat,
round(case when count(distinct doc_mat_total) < 1 then 0.0 else count(distinct doc_mat)::numeric/count(distinct doc_mat_total)::numeric*100 end,1) perc_mat,
count(distinct doc_portugues_total)  doc_portugues_total,
count(distinct doc_portugues)  doc_portugues,
round(case when count(distinct doc_portugues_total) < 1 then 0.0 else count(distinct doc_portugues)::numeric/count(distinct doc_portugues_total)::numeric*100 end,1) perc_portugues,
count(distinct doc_quimica_total)  doc_quimica_total,
count(distinct doc_quimica)  doc_quimica,
round(case when count(distinct doc_quimica_total) < 1 then 0.0 else count(distinct doc_quimica)::numeric/count(distinct doc_quimica_total)::numeric*100 end,1) perc_quimica,
count(distinct doc_sociologia_total)  doc_sociologia_total,
count(distinct doc_sociologia)  doc_sociologia,
round(case when count(distinct doc_sociologia_total) < 1 then 0.0 else count(distinct doc_sociologia)::numeric/count(distinct doc_sociologia_total)::numeric*100 end,1) perc_sociologia
from qtd_municipio_total dt 
join doc_disciplina_curso dc using(co_municipio)
join dw_censo.tb_dm_municipio tdm on id_municipio = dc.co_municipio
--where dt.co_municipio = 2304400
group by 1,2,3,4,5,6,7
order by  nm_municipio ,tp_dependencia

