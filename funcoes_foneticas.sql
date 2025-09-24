--CRIA UMA FUNÇÃO DE BUSCA DE NOMES FONÉTICOS PARA NOMES SIMPLES
CREATE OR REPLACE FUNCTION public.fonetico_soundex(palavra TEXT)
RETURNS TEXT AS $$
DECLARE
    resultado TEXT;
    codigo TEXT;
BEGIN
    -- Manter a primeira letra
    resultado := upper(left(palavra, 1));

    -- Substituir letras por códigos
    codigo := translate(upper(palavra), 
                        'BFPVCGJKQSXZDTLMNR', 
                        '11112222223334456');

    -- Remover vogais e letras desnecessárias, exceto a primeira
    codigo := regexp_replace(codigo, '[AEIOUYHW]', '', 'g');

    -- Remover caracteres consecutivos duplicados
    codigo := regexp_replace(codigo, '([0-9])\1+', '\1', 'g');

    -- Limitar o código a três caracteres adicionais
    resultado := resultado || left(codigo, 3);

    -- Preencher com zeros, se necessário
    RETURN left(resultado || '000', 4);
END;
$$ LANGUAGE plpgsql;

--UTILIZANDO A FUNÇÃO FONÉTICA JÁ CRIADA, CRIA UMA NOVA FUNCAO PARA NOMES COMPLETOS
CREATE OR REPLACE FUNCTION public.fonetico_nome_completo(nome TEXT)
RETURNS TEXT AS $$
DECLARE
    resultado TEXT := '';
    palavra TEXT;
    palavras_comuns TEXT[] := ARRAY['DAS', 'DE', 'E', 'DA', 'DOS', 'DO', 'A', 'O', 'AS', 'OS', 'S'];
BEGIN
    -- Loop para dividir o nome em palavras
    FOR palavra IN SELECT unnest(string_to_array(upper(nome), ' '))
    LOOP
        -- Ignorar palavras comuns
        IF NOT (palavra = ANY (palavras_comuns)) THEN
            -- Concatenar o código fonético da palavra
            resultado := resultado || fonetico_soundex(palavra) || ' ';
        END IF;
    END LOOP;

    -- Retornar o resultado removendo espaços extras
    RETURN trim(resultado);
END;
$$ LANGUAGE plpgsql;
/*

ALTER TABLE base_identificada.tb_pessoa_censo ADD COLUMN codigo_fonetico TEXT;
update base_identificada.tb_pessoa_censo set codigo_fonetico = fonetico_nome_completo(no_pessoa_fisica);

ALTER TABLE base_identificada.tb_pessoa_censo ADD COLUMN codigo_fonetico_mae TEXT;
ALTER TABLE base_identificada.tb_pessoa_censo ADD COLUMN codigo_fonetico_pai TEXT;

SHOW search_path;

update base_identificada.tb_pessoa_censo 
set codigo_fonetico_mae = public.fonetico_nome_completo(no_mae)
where no_mae is not null;

update base_identificada.tb_pessoa_censo 
set  codigo_fonetico_pai = public.fonetico_nome_completo(no_pai)
where no_pai is not null;
*/