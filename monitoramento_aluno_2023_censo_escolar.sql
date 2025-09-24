select 
tm.nu_ano_censo nr_anoletivo,
e.id_crede_sefor cd_crede_sefor,
e.nm_crede_sefor,
nm_municipio,
e.ds_categoria_escola_sige nm_categoria,
id_escola_inep,
nm_escola,
e.ds_localizacao nm_localizacao_zona,
tm.co_pessoa_fisica cd_aluno,
tm.id_turma cd_turma,
case when tm.in_eja =  1 then 'EJA' else 'Regular' end fl_eja,
ds_etapa ds_nivel,
case 
     when cd_etapa = 1 and cd_etapa_fase = 1 then 180
     when cd_etapa = 1 and cd_etapa_fase = 2 then 181
     when cd_etapa = 2 and tm.in_regular = 1 then (cd_ano_serie + 120)
     when cd_etapa = 3 and cd_ano_serie  = 10 then 162 
     when cd_etapa = 3 and cd_ano_serie  = 11 then 163 
     when cd_etapa = 3 and cd_ano_serie  = 12 then 164
     when cd_etapa = 3 and cd_ano_serie  = 14 then 165
     when cd_etapa = 3 and tm.in_eja = 1 and tm.in_profissionalizante  = 1 then 213
     when tm.in_eja = 1 and tm.in_profissionalizante  <> 1 then 196
     when tm.in_eja = 1 and tm.tp_mediacao_didatico_pedago <> 1 then 173
     else tm.tp_etapa_ensino 
	 end cd_etapa,
case 
     when cd_etapa = 1 and cd_etapa_fase = 1 then 'Creche'
     when cd_etapa = 1 and cd_etapa_fase = 2 then 'Pré-escola'
     when tm.in_regular = 1 and cd_etapa in (2,3) then  replace(replace(ds_ano_serie,' EM',''),' EF','')
     when cd_etapa = 3 and tm.in_eja = 1 and tm.in_profissionalizante  = 1 and tm.tp_mediacao_didatico_pedago = 1 then 'EJA Qualifica'
     when tm.in_eja = 1 and tm.in_profissionalizante  <> 1 and tm.tp_mediacao_didatico_pedago = 1 then 'EJA Presencial'
     when tm.in_eja = 1 and tm.tp_mediacao_didatico_pedago <> 1 then 'EJA Semipresencial'
     else ds_etapa_ensino 
	 end ds_etapa,
case when tm.nu_duracao_turma >= 420 then 'Integral' else 
case when tm.tp_mediacao_didatico_pedago <> 1 then  'Flexível' else 
    case when concat(tx_hr_inicial,':',tx_mi_inicial)::time < '11:30:00'::time 
       and tx_hr_inicial::int<>1 then 'Manhã'
      when (concat(tt.tx_hr_inicial,':',tt.tx_mi_inicial)::time > '11:30:00'::time 
         and concat(tt.tx_hr_inicial,':',tt.tx_mi_inicial)::time < '17:30:00'::time) 
         or tt.tx_hr_inicial::int = 1 then 'Tarde'
      when concat(tt.tx_hr_inicial,':',tt.tx_mi_inicial)::time > '17:30:00'::time then 'Noite'
         end end end ds_turno,
co_pessoa_fisica ci_aluno,
'--' nm_aluno,
to_char(concat(nu_ano,'-',nu_mes,'-',nu_dia)::date,'dd/mm/yyyy') dt_nascimento,
case
when tp_cor_raca::int= 0 then 'Não declarada'
when tp_cor_raca::int= 1 then 'Branca'
when tp_cor_raca::int= 2 then 'Preta'
when tp_cor_raca::int= 3 then 'Parda'
when tp_cor_raca::int= 4 then 'Amarela'
when tp_cor_raca::int= 5 then 'Indígena'
else 'Não declarada'
end ds_raca,
case when tm.tp_sexo = 1  then 'Masculino' else 'Feminino' end ds_sexo
--select e.ds_categoria_escola_sige, count(1)
from censo_esc_d.tb_matricula_2023 tm 
join censo_esc_d.tb_turma_2023 tt on tm.id_turma = tt.id_turma 
join dw_censo.tb_dm_escola_dinamico_1 e on id_escola_inep = tm.co_entidade  --392905
join dw_censo.tb_dm_etapa tde on tde.cd_etapa_ensino = tm.tp_etapa_ensino 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = e.id_municipio
where tm.tp_dependencia  = 2
and tm.tp_etapa_ensino is not null
and e.fl_seduc = 1
and cd_etapa in (1,2,3) 
