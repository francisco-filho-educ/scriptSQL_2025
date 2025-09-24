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
ds_disciplina_atividade ilike '%Projeto e Desenvolvimento em Dispositivos Móveis%' or 
ds_disciplina_atividade ilike '%Fundamentos de Programação Convencional%' or 
ds_disciplina_atividade ilike '%Introdução à Lógica e à Programação Visual%'
