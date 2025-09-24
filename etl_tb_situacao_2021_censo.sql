-- Create table
create table censo_esc_ce.tb_situacao_2021
(
  select
  nu_ano_censo                ::int         nu_ano_censo                ,
  co_projeto                  ::int         co_projeto                  ,
  co_evento                   ::int         co_evento                   ,
  id_matricula                ::bigint      id_matricula                ,
  co_pessoa_fisica            ::bigint      co_pessoa_fisica            ,
  nu_dia                      ::int         nu_dia                      ,
  nu_mes                      ::int         nu_mes                      ,
  nu_ano                      ::int         nu_ano                      ,
  nu_idade_referencia         ::int         nu_idade_referencia         ,
  nu_idade                    ::int         nu_idade                    ,
  tp_sexo                     ::int         tp_sexo                     ,
  tp_cor_raca                 ::int         tp_cor_raca                 ,
  in_necessidade_especial     ::int         in_necessidade_especial     ,
  tp_mediacao_didatico_pedago ::int         tp_mediacao_didatico_pedago ,
  in_especial_exclusiva       ::int         in_especial_exclusiva       ,
  in_regular                  ::int         in_regular                  ,
  in_eja                      ::int         in_eja                      ,
  in_profissionalizante       ::int         in_profissionalizante       ,
  tp_etapa_ensino             ::int         tp_etapa_ensino             ,
  in_prof_concomitante        ::int         in_prof_concomitante        ,
  id_turma                    ::int         id_turma                    ,
  tp_tipo_turma               ::int         tp_tipo_turma               ,
  tp_tipo_atendimento_turma   ::int         tp_tipo_atendimento_turma   ,
  tp_tipo_local_turma         ::int         tp_tipo_local_turma         ,
  tp_unificada                ::int         tp_unificada                ,
  co_entidade                 ::int         co_entidade                 ,
  co_orgao_regional           ::VARCHAR(10) co_orgao_regional           ,
  co_regiao                   ::int         co_regiao                   ,
  co_mesorregiao              ::int         co_mesorregiao              ,
  co_microrregiao             ::int         co_microrregiao             ,
  co_uf                       ::int         co_uf                       ,
  co_municipio                ::int         co_municipio                ,
  co_distrito                 ::int         co_distrito                 ,
  tp_localizacao              ::int         tp_localizacao              ,
  tp_dependencia              ::int         tp_dependencia              ,
  tp_localizacao_diferenciada ::int         tp_localizacao_diferenciada ,
  in_educacao_indigena        ::int         in_educacao_indigena        ,
  tp_situacao                 ::int         tp_situacao                 ,
  in_concluinte               ::int         in_concluinte               ,
  in_transferido              ::int in_transferido   
from censo_esc_ce.tb_situacao_2021_t;
-- Add comments to the table 
comment on table censo_esc_ce.tb_situacao_2021
  is 'Dados finais da Situação do Aluno do Censo Escolar   1 - Calculada segundo a data de referência do Censo Escolar (31 de maio).          
2 - Calculado segundo ano de nascimento (idade que completa no ano do Censo).          
3 - Alunos do Ensino Médio que também cursam Educação Profissional Concomitante.           
4 - Os dados de código da turma, código da escola, código da etapa, código da modalidade referem-se a situação final das matrículas e, por isso, podem ser distintos das informações dos microdados que são relativas à situação inicial da matrícula.           
5 - Esta tabela não possui matrículas de AEE e Atividade Complementar.';
-- Add comments to the columns 
comment on column censo_esc_ce.tb_situacao_2021.nu_ano_censo
  is 'Ano do Censo';
comment on column censo_esc_ce.tb_situacao_2021.co_projeto
  is 'Código do projeto do sistema - (Educacenso=2110601)';
comment on column censo_esc_ce.tb_situacao_2021.co_evento
  is 'Código do evento do sistema Educacenso que diferencia os períodos de coleta - 24 - Coleta inicial; 55 - Coleta final (admissão posterior)';
comment on column censo_esc_ce.tb_situacao_2021.id_matricula
  is 'Código da matrícula';
comment on column censo_esc_ce.tb_situacao_2021.co_pessoa_fisica
  is 'Código do aluno (ID_INEP)';
comment on column censo_esc_ce.tb_situacao_2021.nu_dia
  is 'Data de nascimento - dia (DD)';
comment on column censo_esc_ce.tb_situacao_2021.nu_mes
  is 'Data de nascimento - mês (MM)';
comment on column censo_esc_ce.tb_situacao_2021.nu_ano
  is 'Data de nascimento - ano (YYYY)';
comment on column censo_esc_ce.tb_situacao_2021.nu_idade_referencia
  is 'Idade do aluno no mês de referência do Censo Escolar (31 de maio)1';
comment on column censo_esc_ce.tb_situacao_2021.nu_idade
  is 'Idade2';
comment on column censo_esc_ce.tb_situacao_2021.tp_sexo
  is 'Sexo - 1 - Masculino; 2 - Feminino';
comment on column censo_esc_ce.tb_situacao_2021.tp_cor_raca
  is 'Cor/raça:
0 - Não declarada
1 - Branca
2 - Preta
3 - Parda
4 - Amarela
5 - Indígena';
comment on column censo_esc_ce.tb_situacao_2021.in_necessidade_especial
  is 'Aluno com deficiência, transtorno global do desenvolvimento ou altas habilidades/superdotação
0 - Não
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.tp_mediacao_didatico_pedago
  is 'Tipo de mediação didático-pedagógica
1 - Presencial
2 - Semipresencial
3 - Educação a Distância - EAD';
comment on column censo_esc_ce.tb_situacao_2021.in_especial_exclusiva
  is 'Aluno de turma exclusiva de alunos com deficiência, transtorno global do desenvolvimento ou altas habilidades/superdotação (Classes Especiais)
0 - Não
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.in_regular
  is 'Modo, maneira ou metodologia de ensino correspondente às turmas com etapas consecutivas, Creche ao Ensino Médio. Etapas consideradas (nas antigas modalidades 1 e 2): 1,2,3,4,5,6,7,8,9,10,11,14,15, 16,17,18,19, 20,21,41,25,26,27,28,29,30,31,32,33,34,35, 36,37 e 38
0 - Não
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.in_eja
  is 'Modo, maneira ou metodologia de ensino correspondente às turmas (Educação de Jovens e Adultos) destinadas  a pessoas  que  não  cursaram  o  ensino  fundamental  e/ou  médio  em idade própria). Etapas consideradas: 65,67,69,70,71,73 e 74.
0 - Não
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.in_profissionalizante
  is 'Modo profissionalizante de ensino correspondente às turmas. Etapas consideradas: 30,31,32,33,34,35,36,37, 38,39,40,64,65,67,68,73 e 74.
0 - Não
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.tp_etapa_ensino
  is 'Etapa de ensino da matrícula
1 - Educação Infantil - Creche
2 - Educação Infantil - Pré-escola
4 - Ensino Fundamental de 8 anos - 1ª Série
5 - Ensino Fundamental de 8 anos - 2ª Série
6 - Ensino Fundamental de 8 anos - 3ª Série
7 - Ensino Fundamental de 8 anos - 4ª Série
8 - Ensino Fundamental de 8 anos - 5ª Série
9 - Ensino Fundamental de 8 anos - 6ª Série
10 - Ensino Fundamental de 8 anos - 7ª Série
11 - Ensino Fundamental de 8 anos - 8ª Série
14 - Ensino Fundamental de 9 anos - 1º Ano
15 - Ensino Fundamental de 9 anos - 2º Ano
16 - Ensino Fundamental de 9 anos - 3º Ano
17 - Ensino Fundamental de 9 anos - 4º Ano
18 - Ensino Fundamental de 9 anos - 5º Ano
19 - Ensino Fundamental de 9 anos - 6º Ano
20 - Ensino Fundamental de 9 anos - 7º Ano
21 - Ensino Fundamental de 9 anos - 8º Ano
41 - Ensino Fundamental de 9 anos - 9º Ano
25 - Ensino Médio - 1ª Série
26 - Ensino Médio - 2ª Série
27 - Ensino Médio - 3ª Série
28 - Ensino Médio - 4ª Série
29 - Ensino Médio - Não Seriada
30 - Curso Técnico Integrado (Ensino Médio Integrado) 1ª Série
31 - Curso Técnico Integrado (Ensino Médio Integrado) 2ª Série
32 - Curso Técnico Integrado (Ensino Médio Integrado) 3ª Série
33 - Curso Técnico Integrado (Ensino Médio Integrado) 4ª Série
34 - Curso Técnico Integrado (Ensino Médio Integrado) Não Seriada
35 - Ensino Médio - Normal/Magistério 1ª Série
36 - Ensino Médio - Normal/Magistério 2ª Série
37 - Ensino Médio - Normal/Magistério 3ª Série
38 - Ensino Médio - Normal/Magistério 4ª Série
39 - Curso Técnico - Concomitante
40 - Curso Técnico - Subsequente
65 - EJA - Ensino Fundamental - Projovem Urbano
67 - Curso FIC integrado na modalidade EJA  - Nível Médio
68 - Curso FIC Concomitante 
69 - EJA - Ensino Fundamental -  Anos iniciais
70 - EJA - Ensino Fundamental -  Anos finais
71 - EJA - Ensino Médio
73 - Curso FIC integrado na modalidade EJA - Nível Fundamental (EJA integrada à Educação Profissional de Nível Fundamental)
74 - Curso Técnico Integrado na Modalidade EJA (EJA integrada à Educação Profissional de Nível Médio)';
comment on column censo_esc_ce.tb_situacao_2021.in_prof_concomitante
  is 'Aluno cursa atividade profissional concomitante com o Ensino Médio. 3
0 - Não
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.id_turma
  is 'Código da turma 4
Turmas do evento 55 podem não existir nas tabelas da coleta inicial. (Turmas novas criadas para admissão do aluno)';
comment on column censo_esc_ce.tb_situacao_2021.tp_tipo_turma
  is 'Tipo de atendimento 5
0 - Não se aplica
1 - Classe hospitalar
2 - Unidade de atendimento socioeducativo
3 - Unidade prisional';
comment on column censo_esc_ce.tb_situacao_2021.tp_unificada
  is 'Unificada, multietapa, multi ou correção de fluxo
0 - Não
1 - Unificada
2 - Multietapa
3 - Multi
4 - Correção de fluxo
5 - Mista (Concomitante e Subsequente)';
comment on column censo_esc_ce.tb_situacao_2021.co_entidade
  is 'Código da Escola 4';
comment on column censo_esc_ce.tb_situacao_2021.co_orgao_regional
  is 'Código do Órgão Regional de Ensino';
comment on column censo_esc_ce.tb_situacao_2021.co_regiao
  is 'Código da região geográfica';
comment on column censo_esc_ce.tb_situacao_2021.co_mesorregiao
  is 'Código da mesorregião';
comment on column censo_esc_ce.tb_situacao_2021.co_microrregiao
  is 'Código da microrregião';
comment on column censo_esc_ce.tb_situacao_2021.co_uf
  is 'Código UF';
comment on column censo_esc_ce.tb_situacao_2021.co_municipio
  is 'Código Município';
comment on column censo_esc_ce.tb_situacao_2021.co_distrito
  is 'Código do Distrito';
comment on column censo_esc_ce.tb_situacao_2021.tp_localizacao
  is 'Localização
1 - Urbana
2 - Rural';
comment on column censo_esc_ce.tb_situacao_2021.tp_dependencia
  is 'Dependência Administrativa
1 - Federal
2 - Estadual
3 - Municipal
4 - Privada';
comment on column censo_esc_ce.tb_situacao_2021.tp_localizacao_diferenciada
  is 'Localização diferenciada da escola
0 - Não se aplica
1 - Área de assentamento
2 - Terra indígena
3 - Área remanescente de quilombos
4 - Unidade de uso sustentável
5 - Unidade de uso sustentável em terra indígena
6 - Unidade de uso sustentável em área remanescente de quilombos';
comment on column censo_esc_ce.tb_situacao_2021.in_educacao_indigena
  is 'Educação Indígena
0 - Não
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.tp_situacao
  is 'Falecido: aluno que deixou de ir à escola por falecimento.
Aprovado: quando o aluno alcança os critérios mínimos para a conclusão satisfatória da etapa de ensino na qual se encontrava, estando apto para se matricular na etapa seguinte no próximo ano letivo.
Reprovado: quando o aluno não alcança os critérios mínimos para a conclusão da etapa de ensino na qual se encontrava, não estando apto para se matricular na etapa seguinte no próximo ano letivo.
Abandono: quando o aluno deixou de ir à escola antes do término do ano letivo sem requerer formalmente sua transferência.
SIR - Matrícula sem informação de Rendimento ou Movimento.
2 - Abandono
3 - Falecido
4 - Reprovado
5 - Aprovado
9 - Sir';
comment on column censo_esc_ce.tb_situacao_2021.in_concluinte
  is 'Aluno que tenha sido aprovado e terminado uma etapa final do ensino fundamental, ensino médio ou de educação profissional com emissão de certificado. (etapas: 11,41,27,28,29,32,33,34,37,38,39,40,70,71,73,74,65,67 e 68).
0 - Não
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.in_transferido
  is 'Aluno que foi para outra escola após a data de referência do Censo Escolar.
0 - Não
1 - Sim';
