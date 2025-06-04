-- Valida a adição de valor a venda do funcionario

CREATE OR REPLACE FUNCTION fn_atualiza_qtd_vendida_funcionario()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Adiciona o valor da nova venda ao funcionário
        UPDATE FUNCIONARIO
        SET QTD_VENDIDA_NO_MES = COALESCE(QTD_VENDIDA_NO_MES, 0) + NEW.VALOR_TOTAL
        WHERE COD_FUNCIONARIO = NEW.COD_FUNCIONARIO;

    ELSIF TG_OP = 'UPDATE' THEN
        -- Se o valor da venda mudou ou o funcionário responsável mudou
        IF OLD.VALOR_TOTAL IS DISTINCT FROM NEW.VALOR_TOTAL OR OLD.COD_FUNCIONARIO IS DISTINCT FROM NEW.COD_FUNCIONARIO THEN
            -- Remove o valor antigo do funcionário antigo (se houver)
            IF OLD.COD_FUNCIONARIO IS NOT NULL THEN
                 UPDATE FUNCIONARIO
                 SET QTD_VENDIDA_NO_MES = COALESCE(QTD_VENDIDA_NO_MES, 0) - OLD.VALOR_TOTAL
                 WHERE COD_FUNCIONARIO = OLD.COD_FUNCIONARIO;
            END IF;

            -- Adiciona o novo valor ao novo funcionário
            UPDATE FUNCIONARIO
            SET QTD_VENDIDA_NO_MES = COALESCE(QTD_VENDIDA_NO_MES, 0) + NEW.VALOR_TOTAL
            WHERE COD_FUNCIONARIO = NEW.COD_FUNCIONARIO;
        END IF;

    ELSIF TG_OP = 'DELETE' THEN
        -- Subtrai o valor da venda deletada do funcionário
        UPDATE FUNCIONARIO
        SET QTD_VENDIDA_NO_MES = COALESCE(QTD_VENDIDA_NO_MES, 0) - OLD.VALOR_TOTAL
        WHERE COD_FUNCIONARIO = OLD.COD_FUNCIONARIO;
    END IF;

    RETURN NULL; -- Para triggers AFTER, o valor de retorno é geralmente ignorado
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_atualiza_qtd_vendida_funcionario
AFTER INSERT OR UPDATE OR DELETE ON VENDA
FOR EACH ROW
EXECUTE FUNCTION fn_atualiza_qtd_vendida_funcionario();


SELECT COD_FUNCIONARIO, NOME, QTD_VENDIDA_NO_MES FROM FUNCIONARIO WHERE COD_FUNCIONARIO = 1;
-- Suponha que QTD_VENDIDA_NO_MES seja X antes da inserção.

INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA)
VALUES (200, 1, 1, 1000.00, CURRENT_DATE);

-- Verificação:
SELECT COD_FUNCIONARIO, NOME, QTD_VENDIDA_NO_MES FROM FUNCIONARIO WHERE COD_FUNCIONARIO = 1;
-- Espera-se: QTD_VENDIDA_NO_MES = X + 1000.00