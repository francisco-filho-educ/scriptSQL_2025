#5º Ano Lingua portuguesa
CASE
WHEN vl_proficiencia::numeric <= 125 THEN 1
WHEN vl_proficiencia::numeric > 125 AND vl_proficiencia::numeric <= 175 THEN 2
WHEN vl_proficiencia::numeric > 175 AND vl_proficiencia::numeric <= 225 THEN 3
WHEN vl_proficiencia::numeric > 225 THEN 4 
END cd_padrao

CASE
WHEN vl_proficiencia::numeric <= 125 THEN 'Muito Crítico'
WHEN vl_proficiencia::numeric > 125 AND vl_proficiencia::numeric <= 175 THEN 'Crítico'
WHEN vl_proficiencia::numeric > 175 AND vl_proficiencia::numeric <= 225 THEN 'Intermediário'
WHEN vl_proficiencia::numeric > 225 THEN 'Adequado'
END ds_padrao


#5º Ano Matemática
CASE
WHEN vl_proficiencia::numeric <= 150 THEN 1
WHEN vl_proficiencia::numeric > 150 AND vl_proficiencia::numeric <= 200 THEN 2
WHEN vl_proficiencia::numeric > 200 AND vl_proficiencia::numeric <= 250 THEN 3
WHEN vl_proficiencia::numeric > 250 THEN 4 
END cd_padrao


CASE
WHEN vl_proficiencia::numeric <= 150 THEN 'Muito Crítico'
WHEN vl_proficiencia::numeric > 150 AND vl_proficiencia::numeric <= 200 THEN 'Crítico'
WHEN vl_proficiencia::numeric > 200 AND vl_proficiencia::numeric <= 250 THEN 'Intermediário'
WHEN vl_proficiencia::numeric > 250 THEN 'Adequado'
END ds_padrao


#9º Ano Lingua portuguesa
CASE
WHEN vl_proficiencia::numeric <= 200 THEN 1
WHEN vl_proficiencia::numeric > 200 AND vl_proficiencia::numeric <= 250 THEN 2
WHEN vl_proficiencia::numeric >  250 vl_proficiencia::numeric <= 300 THEN 3
WHEN vl_proficiencia::numeric > 300 THEN 4 
END cd_padrao

CASE
WHEN vl_proficiencia::numeric <= 200 THEN 'Muito Crítico'
WHEN vl_proficiencia::numeric > 200 AND vl_proficiencia::numeric <= 250 THEN 'Crítico'
WHEN vl_proficiencia::numeric >  250 vl_proficiencia::numeric <= 300    THEN 'Intermediário'
WHEN vl_proficiencia::numeric > 300 THEN 'Adequado' 
END ds_padrao



#9º Ano Matemática
CASE
WHEN vl_proficiencia::numeric <= 225 THEN 1
WHEN vl_proficiencia::numeric > 225 AND vl_proficiencia::numeric <= 275 THEN 2
WHEN vl_proficiencia::numeric > 275 AND vl_proficiencia::numeric <= 325 THEN 3
WHEN vl_proficiencia::numeric > 325 THEN 4 
END cd_padrao


CASE
WHEN vl_proficiencia::numeric <= 225 THEN 'Muito Crítico'
WHEN vl_proficiencia::numeric > 225 AND vl_proficiencia::numeric <= 275 THEN 'Crítico'
WHEN vl_proficiencia::numeric > 275 AND vl_proficiencia::numeric <= 325 THEN 'Intermediário'
WHEN vl_proficiencia::numeric > 325 THEN  'Adequado'
END ds_padrao


# 2º Ano Classico

CASE
WHEN vl_proficiencia::numeric <= 75 THEN 1
WHEN vl_proficiencia::numeric >  75 AND vl_proficiencia::numeric <= 100 THEN 2
WHEN vl_proficiencia::numeric >  100 AND vl_proficiencia::numeric <= 125 THEN 3
WHEN vl_proficiencia::numeric >  125 AND vl_proficiencia::numeric <= 150 THEN 3
WHEN vl_proficiencia::numeric >  150 THEN 4 
END cd_padrao


CASE
WHEN vl_proficiencia::numeric <= 75 THEN 'Não Alfabetizado'
WHEN vl_proficiencia::numeric >  75 AND vl_proficiencia::numeric <= 100 THEN 'Alfabetização Incompleta'
WHEN vl_proficiencia::numeric >  100 AND vl_proficiencia::numeric <= 125 THEN 'Intermediário'
WHEN vl_proficiencia::numeric >  125 AND vl_proficiencia::numeric <= 150 THEN 'Suficiente'
WHEN vl_proficiencia::numeric >  150 THEN 'Desejável'
END ds_padrao
