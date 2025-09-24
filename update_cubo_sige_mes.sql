update dw_sige.tb_cubo_aluno_junho
set cd_aluno = cd_aluno_novo
from (select 
      cd_aluno cd_aluno_novo,
      cd_aluno_excluido 
      from academico.tb_auditoria_aluno_mesclar) as taam
where cd_aluno = cd_aluno_excluido; 
