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
  is 'Dados finais da Situa��o do Aluno do Censo Escolar   1 - Calculada segundo a data de refer�ncia do Censo Escolar (31 de maio).          
2 - Calculado segundo ano de nascimento (idade que completa no ano do Censo).          
3 - Alunos do Ensino M�dio que tamb�m cursam Educa��o Profissional Concomitante.           
4 - Os dados de c�digo da turma, c�digo da escola, c�digo da etapa, c�digo da modalidade referem-se a situa��o final das matr�culas e, por isso, podem ser distintos das informa��es dos microdados que s�o relativas � situa��o inicial da matr�cula.           
5 - Esta tabela n�o possui matr�culas de AEE e Atividade Complementar.';
-- Add comments to the columns 
comment on column censo_esc_ce.tb_situacao_2021.nu_ano_censo
  is 'Ano do Censo';
comment on column censo_esc_ce.tb_situacao_2021.co_projeto
  is 'C�digo do projeto do sistema - (Educacenso=2110601)';
comment on column censo_esc_ce.tb_situacao_2021.co_evento
  is 'C�digo do evento do sistema Educacenso que diferencia os per�odos de coleta - 24 - Coleta inicial; 55 - Coleta final (admiss�o posterior)';
comment on column censo_esc_ce.tb_situacao_2021.id_matricula
  is 'C�digo da matr�cula';
comment on column censo_esc_ce.tb_situacao_2021.co_pessoa_fisica
  is 'C�digo do aluno (ID_INEP)';
comment on column censo_esc_ce.tb_situacao_2021.nu_dia
  is 'Data de nascimento - dia (DD)';
comment on column censo_esc_ce.tb_situacao_2021.nu_mes
  is 'Data de nascimento - m�s (MM)';
comment on column censo_esc_ce.tb_situacao_2021.nu_ano
  is 'Data de nascimento - ano (YYYY)';
comment on column censo_esc_ce.tb_situacao_2021.nu_idade_referencia
  is 'Idade do aluno no m�s de refer�ncia do Censo Escolar (31 de maio)1';
comment on column censo_esc_ce.tb_situacao_2021.nu_idade
  is 'Idade2';
comment on column censo_esc_ce.tb_situacao_2021.tp_sexo
  is 'Sexo - 1 - Masculino; 2 - Feminino';
comment on column censo_esc_ce.tb_situacao_2021.tp_cor_raca
  is 'Cor/ra�a:
0 - N�o declarada
1 - Branca
2 - Preta
3 - Parda
4 - Amarela
5 - Ind�gena';
comment on column censo_esc_ce.tb_situacao_2021.in_necessidade_especial
  is 'Aluno com defici�ncia, transtorno global do desenvolvimento ou altas habilidades/superdota��o
0 - N�o
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.tp_mediacao_didatico_pedago
  is 'Tipo de media��o did�tico-pedag�gica
1 - Presencial
2 - Semipresencial
3 - Educa��o a Dist�ncia - EAD';
comment on column censo_esc_ce.tb_situacao_2021.in_especial_exclusiva
  is 'Aluno de turma exclusiva de alunos com defici�ncia, transtorno global do desenvolvimento ou altas habilidades/superdota��o (Classes Especiais)
0 - N�o
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.in_regular
  is 'Modo, maneira ou metodologia de ensino correspondente �s turmas com etapas consecutivas, Creche ao Ensino M�dio. Etapas consideradas (nas antigas modalidades 1 e 2): 1,2,3,4,5,6,7,8,9,10,11,14,15, 16,17,18,19, 20,21,41,25,26,27,28,29,30,31,32,33,34,35, 36,37 e 38
0 - N�o
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.in_eja
  is 'Modo, maneira ou metodologia de ensino correspondente �s turmas (Educa��o de Jovens e Adultos) destinadas  a pessoas  que  n�o  cursaram  o  ensino  fundamental  e/ou  m�dio  em idade pr�pria). Etapas consideradas: 65,67,69,70,71,73 e 74.
0 - N�o
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.in_profissionalizante
  is 'Modo profissionalizante de ensino correspondente �s turmas. Etapas consideradas: 30,31,32,33,34,35,36,37, 38,39,40,64,65,67,68,73 e 74.
0 - N�o
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.tp_etapa_ensino
  is 'Etapa de ensino da matr�cula
1 - Educa��o Infantil - Creche
2 - Educa��o Infantil - Pr�-escola
4 - Ensino Fundamental de 8 anos - 1� S�rie
5 - Ensino Fundamental de 8 anos - 2� S�rie
6 - Ensino Fundamental de 8 anos - 3� S�rie
7 - Ensino Fundamental de 8 anos - 4� S�rie
8 - Ensino Fundamental de 8 anos - 5� S�rie
9 - Ensino Fundamental de 8 anos - 6� S�rie
10 - Ensino Fundamental de 8 anos - 7� S�rie
11 - Ensino Fundamental de 8 anos - 8� S�rie
14 - Ensino Fundamental de 9 anos - 1� Ano
15 - Ensino Fundamental de 9 anos - 2� Ano
16 - Ensino Fundamental de 9 anos - 3� Ano
17 - Ensino Fundamental de 9 anos - 4� Ano
18 - Ensino Fundamental de 9 anos - 5� Ano
19 - Ensino Fundamental de 9 anos - 6� Ano
20 - Ensino Fundamental de 9 anos - 7� Ano
21 - Ensino Fundamental de 9 anos - 8� Ano
41 - Ensino Fundamental de 9 anos - 9� Ano
25 - Ensino M�dio - 1� S�rie
26 - Ensino M�dio - 2� S�rie
27 - Ensino M�dio - 3� S�rie
28 - Ensino M�dio - 4� S�rie
29 - Ensino M�dio - N�o Seriada
30 - Curso T�cnico Integrado (Ensino M�dio Integrado) 1� S�rie
31 - Curso T�cnico Integrado (Ensino M�dio Integrado) 2� S�rie
32 - Curso T�cnico Integrado (Ensino M�dio Integrado) 3� S�rie
33 - Curso T�cnico Integrado (Ensino M�dio Integrado) 4� S�rie
34 - Curso T�cnico Integrado (Ensino M�dio Integrado) N�o Seriada
35 - Ensino M�dio - Normal/Magist�rio 1� S�rie
36 - Ensino M�dio - Normal/Magist�rio 2� S�rie
37 - Ensino M�dio - Normal/Magist�rio 3� S�rie
38 - Ensino M�dio - Normal/Magist�rio 4� S�rie
39 - Curso T�cnico - Concomitante
40 - Curso T�cnico - Subsequente
65 - EJA - Ensino Fundamental - Projovem Urbano
67 - Curso FIC integrado na modalidade EJA  - N�vel M�dio
68 - Curso FIC Concomitante 
69 - EJA - Ensino Fundamental -  Anos iniciais
70 - EJA - Ensino Fundamental -  Anos finais
71 - EJA - Ensino M�dio
73 - Curso FIC integrado na modalidade EJA - N�vel Fundamental (EJA integrada � Educa��o Profissional de N�vel Fundamental)
74 - Curso T�cnico Integrado na Modalidade EJA (EJA integrada � Educa��o Profissional de N�vel M�dio)';
comment on column censo_esc_ce.tb_situacao_2021.in_prof_concomitante
  is 'Aluno cursa atividade profissional concomitante com o Ensino M�dio. 3
0 - N�o
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.id_turma
  is 'C�digo da turma 4
Turmas do evento 55 podem n�o existir nas tabelas da coleta inicial. (Turmas novas criadas para admiss�o do aluno)';
comment on column censo_esc_ce.tb_situacao_2021.tp_tipo_turma
  is 'Tipo de atendimento 5
0 - N�o se aplica
1 - Classe hospitalar
2 - Unidade de atendimento socioeducativo
3 - Unidade prisional';
comment on column censo_esc_ce.tb_situacao_2021.tp_unificada
  is 'Unificada, multietapa, multi ou corre��o de fluxo
0 - N�o
1 - Unificada
2 - Multietapa
3 - Multi
4 - Corre��o de fluxo
5 - Mista (Concomitante e Subsequente)';
comment on column censo_esc_ce.tb_situacao_2021.co_entidade
  is 'C�digo da Escola 4';
comment on column censo_esc_ce.tb_situacao_2021.co_orgao_regional
  is 'C�digo do �rg�o Regional de Ensino';
comment on column censo_esc_ce.tb_situacao_2021.co_regiao
  is 'C�digo da regi�o geogr�fica';
comment on column censo_esc_ce.tb_situacao_2021.co_mesorregiao
  is 'C�digo da mesorregi�o';
comment on column censo_esc_ce.tb_situacao_2021.co_microrregiao
  is 'C�digo da microrregi�o';
comment on column censo_esc_ce.tb_situacao_2021.co_uf
  is 'C�digo UF';
comment on column censo_esc_ce.tb_situacao_2021.co_municipio
  is 'C�digo Munic�pio';
comment on column censo_esc_ce.tb_situacao_2021.co_distrito
  is 'C�digo do Distrito';
comment on column censo_esc_ce.tb_situacao_2021.tp_localizacao
  is 'Localiza��o
1 - Urbana
2 - Rural';
comment on column censo_esc_ce.tb_situacao_2021.tp_dependencia
  is 'Depend�ncia Administrativa
1 - Federal
2 - Estadual
3 - Municipal
4 - Privada';
comment on column censo_esc_ce.tb_situacao_2021.tp_localizacao_diferenciada
  is 'Localiza��o diferenciada da escola
0 - N�o se aplica
1 - �rea de assentamento
2 - Terra ind�gena
3 - �rea remanescente de quilombos
4 - Unidade de uso sustent�vel
5 - Unidade de uso sustent�vel em terra ind�gena
6 - Unidade de uso sustent�vel em �rea remanescente de quilombos';
comment on column censo_esc_ce.tb_situacao_2021.in_educacao_indigena
  is 'Educa��o Ind�gena
0 - N�o
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.tp_situacao
  is 'Falecido: aluno que deixou de ir � escola por falecimento.
Aprovado: quando o aluno alcan�a os crit�rios m�nimos para a conclus�o satisfat�ria da etapa de ensino na qual se encontrava, estando apto para se matricular na etapa seguinte no pr�ximo ano letivo.
Reprovado: quando o aluno n�o alcan�a os crit�rios m�nimos para a conclus�o da etapa de ensino na qual se encontrava, n�o estando apto para se matricular na etapa seguinte no pr�ximo ano letivo.
Abandono: quando o aluno deixou de ir � escola antes do t�rmino do ano letivo sem requerer formalmente sua transfer�ncia.
SIR - Matr�cula sem informa��o de Rendimento ou Movimento.
2 - Abandono
3 - Falecido
4 - Reprovado
5 - Aprovado
9 - Sir';
comment on column censo_esc_ce.tb_situacao_2021.in_concluinte
  is 'Aluno que tenha sido aprovado e terminado uma etapa final do ensino fundamental, ensino m�dio ou de educa��o profissional com emiss�o de certificado. (etapas: 11,41,27,28,29,32,33,34,37,38,39,40,70,71,73,74,65,67 e 68).
0 - N�o
1 - Sim';
comment on column censo_esc_ce.tb_situacao_2021.in_transferido
  is 'Aluno que foi para outra escola ap�s a data de refer�ncia do Censo Escolar.
0 - N�o
1 - Sim';
