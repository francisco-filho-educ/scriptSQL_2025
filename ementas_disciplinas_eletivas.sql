select 
ds_codigo,
ds_disciplina_atividade,
ds_objetivos,
ds_objetivos_eletiva,
ds_conteudo,
ds_recursos,
ds_avaliacao,
ds_referencias 
from academico.tb_disciplina_atividade tda 
where 
ds_disciplina_atividade ilike '%Projeto e Desenvolvimento em Dispositivos M�veis%' or 
ds_disciplina_atividade ilike '%Fundamentos de Programa��o Convencional%' or 
ds_disciplina_atividade ilike '%Introdu��o � L�gica e � Programa��o Visual%'
