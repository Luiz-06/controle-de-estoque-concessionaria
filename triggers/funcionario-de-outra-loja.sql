CREATE OR REPLACE FUNCTION verificar_funcionario_loja_item_venda()
RETURNS TRIGGER AS $$
DECLARE
    loja_funcionario INT;
    loja_carro INT;
    cod_funcionario INT;
BEGIN
    -- Pegar o código do funcionário na venda
    SELECT COD_FUNCIONARIO INTO cod_funcionario
    FROM VENDA
    WHERE COD_VENDA = NEW.COD_VENDA;

    -- Pegar a loja do funcionário
    SELECT LC.COD_LOJA INTO loja_funcionario
    FROM FUNCIONARIO F
    JOIN LOJA_CARRO LC ON F.COD_LOJA_CARRO = LC.COD_LOJA_CARRO
    WHERE F.COD_FUNCIONARIO = cod_funcionario;

    -- Pegar a loja do carro no item de venda
    SELECT COD_LOJA INTO loja_carro
    FROM LOJA_CARRO
    WHERE COD_LOJA_CARRO = NEW.COD_LOJA_CARRO;

    -- Comparar as lojas
    IF loja_funcionario <> loja_carro THEN
        RAISE EXCEPTION 'Funcionário só pode vender carros da loja onde trabalha.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verificar_funcionario_loja_item_venda_tr
BEFORE INSERT OR UPDATE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION verificar_funcionario_loja_item_venda();
