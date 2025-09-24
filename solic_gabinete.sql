with mat as (
select 
tt.cd_unidade_trabalho,
ds_etapa,
cd_etapa,
count(1) nr_matriculas
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on tt.ci_turma = cd_turma
join academico.tb_etapa te on te.ci_etapa = cd_etapa
where
tu.nr_anoletivo = 2021
and cd_prefeitura =0
and tu.fl_tipo_atividade <>'AC'
and cd_nivel in (26,27,28)
and cd_etapa <> 137
--and cd_etapa in (162,184)
--and ds_ofertaitem ilike '%EJA%'
group by 1,2,3
), eemti as (
select 
ci_unidade_trabalho,
'Tempo Integral' nm_categoria,
1 fl_eemti
from rede_fisica.tb_unidade_trabalho tut2 
where tut2.nr_codigo_unid_trab in ('23061693','23060948','23061499','23180226','23062720','23063505','23063076','23063599','23064510','23244992','23462329','23079495','23079533','23079851','23081830','23079649','23079959','23080132','23081945','23082160','23083476','23083654','23062738','23062703','23264675','23249676','23040297','23041889','23036273','23022060','23045493','23269014','23254068','23038004','23044039','23008300','23545410','23236477','23506989','23002115','23004258','23007648','23545429','23265795','23005033','23271850','23011769','23008814','23026693','23236434','23244780','23013125','23020431','23025905','23025832','23019556','23030631','23025190','23025140','23185287','23024658','23018445','23264101','23247754','23264640','23252529','23051671','23051850','23494000','23052643','23055693','23055995','23060298','23265000','23127821','23133554','23124121','23127171','23129018','23138106','23135905','23100770','23100311','23101865','23099194','23102020','23095881','23126833','23217510','23029854','23085550','23085568','23085193','23087196','23090545','23225190','23219181','23116951','23119799','23121459','23245292','23115050','23235705','23564016','23224509','23145633','23545704','23142375','23142804','23241489','23275057','23106590','23142286','23148543','23140518','23150173','23151528','23152737','23162813','23162406','23163020','23255269','23163410','23167190','23108657','23264624','23167963','23164050','23236752','23156201','23157011','23190884','23165774','23165421','23165430','23166100','23162350','23157879','23160110','23168749','23171804','23170492','23158514','23234814','23170620','23167386','23065494','23065249','23188774','23067233','23069767','23071010','23072571','23225408','23073136','23188545','23068078','23069031','23227818','23069201','23078561','23077387','23073853','23073039','23068086','23068833','23071354','23252294','23069546','23068930','23069562','23070820','23078707','23214457','23077883','23068523','23069120','23078529','23069244','23065273','23078758','23075791','23068710','23188154','23071370','23069511','23068825','23186518','23071591','23078669','23071087','23065486','23073713','23072199','23068183','23068965','23072431','23069082','23069627','23069163','23068841')
)
SELECT 
case when fl_eemti = 1 then eemti.nm_categoria else tc.nm_categoria end  nm_categoria,
count(distinct tut.ci_unidade_trabalho) nr_escolas,
sum(case when cd_etapa in (121,122,123,124,125,183) then nr_matriculas else 0 end) fund_ai,
sum(case when cd_etapa in (126,127,128,129) then nr_matriculas else 0 end) fund_af,
sum(case when cd_etapa in(162,184,188) then nr_matriculas else 0 end) nr_1_serie,
sum(case when cd_etapa in(163,185,189) then nr_matriculas else 0 end) nr_2_serie,
sum(case when cd_etapa in(164,186,190) then nr_matriculas else 0 end) nr_3_serie,
sum(case when cd_etapa in(165,187,191) then nr_matriculas else 0 end) nr_4_serie,
sum(nr_matriculas)
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
left join eemti on eemti.ci_unidade_trabalho = tut.ci_unidade_trabalho 
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
--and cd_etapa in(162,184,188,163,185,189,164,186,190,165,187,191) -- medio regular
--and cd_etapa in (121,122,123,124,125,126,127,128,129,183) -- fundamental regular
--and cd_etapa in (213,214,195,194,175,196,174,173) --ejas
--and tut.cd_categoria =9
group by 1
--ORDER BY 1,3,4,6;

/*
select 
nr_anoletivo,
count(1) nr_matriculas
from sigecci.tb_enturmacao te 
join util.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = te.cd_cci_indicado 
where
te.nr_anoletivo = 2021
and te.fl_apto 
and te .fl_ultima_enturmacao 
and te.fl_enturmado
and te.fl_ultima_enturmacao 
and te.nr_semestre = 1
--and te.dt_enturmacao::date <= '2021-05-26'::date
--and (te.dt_desenturmacao::date > '2021-05-26'::date or te.dt_desenturmacao is null)
group by 1


select
tt.nr_anoletivo,
'Estadual' ds_dependencia,
fl_tipo, 
count(distinct ci_lotacaoprofessor) nr_lotacao,
count(distinct cpf) nr_cpf
from academico.tb_ultimaenturmacao tue
join academico.tb_turma tt on tt.ci_turma = tue.cd_turma and tue.nr_anoletivo = tt.nr_anoletivo
join lotacaocoave.mvw_coave_turmas_presenciais lt on lt.ci_turma = tt.ci_turma
join lotacaocoave.mvw_coave_docentes dl on dl.cd_vinculo = lt.cd_vinculo
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
join academico.tb_disciplinas td on td.ci_disciplina = lt.cd_disciplina 
where 
tt.nr_anoletivo::int = 2021
and tut.cd_dependencia_administrativa::int = 2
and tut.cd_tipo_unid_trab in (401,402)
and tt.cd_prefeitura::int = 0
and tue.fl_tipo_atividade <>'AC'
and cd_nivel::int in (26,27,28)
--and tut.cd_categoria = 8
and fl_tipo = 'B'
group by 1,2,3

*/