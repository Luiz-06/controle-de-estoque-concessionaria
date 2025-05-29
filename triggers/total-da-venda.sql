CREATE OR REPLACE FUNCTION total_da_venda() RETURNS TRIGGER AS 
$$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Atualiza o valor total da venda
        UPDATE VENDA 
        SET VALOR_TOTAL = (
            SELECT SUM(IV.QTD_DE_ITENS * C.PRECO)
            FROM ITEM_VENDA AS IV
            JOIN LOJA_CARRO AS LC ON IV.COD_LOJA_CARRO = LC.COD_LOJA_CARRO
            JOIN CARRO AS C ON LC.COD_CARRO = C.COD_CARRO
            WHERE IV.COD_VENDA = NEW.COD_VENDA
        )
        WHERE COD_VENDA = NEW.COD_VENDA;

        -- Atualiza o estoque do carro
        UPDATE CARRO 
        SET QTD_EM_ESTOQUE = QTD_EM_ESTOQUE - NEW.QTD_DE_ITENS
        WHERE COD_CARRO = (
            SELECT LC.COD_CARRO
            FROM LOJA_CARRO AS LC
            WHERE LC.COD_LOJA_CARRO = NEW.COD_LOJA_CARRO
        );

    ELSIF TG_OP = 'UPDATE' THEN
        -- Recalcula o total da venda
        UPDATE VENDA 
        SET VALOR_TOTAL = (
            SELECT SUM(IV.QTD_DE_ITENS * C.PRECO)
            FROM ITEM_VENDA AS IV
            JOIN LOJA_CARRO AS LC ON IV.COD_LOJA_CARRO = LC.COD_LOJA_CARRO
            JOIN CARRO AS C ON LC.COD_CARRO = C.COD_CARRO
            WHERE IV.COD_VENDA = NEW.COD_VENDA
        )
        WHERE COD_VENDA = NEW.COD_VENDA;

        -- Devolve estoque antigo
        UPDATE CARRO
        SET QTD_EM_ESTOQUE = QTD_EM_ESTOQUE + OLD.QTD_DE_ITENS
        WHERE COD_CARRO = (
            SELECT LC.COD_CARRO
            FROM LOJA_CARRO AS LC
            WHERE LC.COD_LOJA_CARRO = OLD.COD_LOJA_CARRO
        );

        -- Reduz estoque novo
        UPDATE CARRO
        SET QTD_EM_ESTOQUE = QTD_EM_ESTOQUE - NEW.QTD_DE_ITENS
        WHERE COD_CARRO = (
            SELECT LC.COD_CARRO
            FROM LOJA_CARRO AS LC
            WHERE LC.COD_LOJA_CARRO = NEW.COD_LOJA_CARRO
        );

    ELSIF TG_OP = 'DELETE' THEN
        -- Recalcula o total da venda
        UPDATE VENDA 
        SET VALOR_TOTAL = (
            SELECT COALESCE(SUM(IV.QTD_DE_ITENS * C.PRECO), 0)
            FROM ITEM_VENDA AS IV
            JOIN LOJA_CARRO AS LC ON IV.COD_LOJA_CARRO = LC.COD_LOJA_CARRO
            JOIN CARRO AS C ON LC.COD_CARRO = C.COD_CARRO
            WHERE IV.COD_VENDA = OLD.COD_VENDA
        )
        WHERE COD_VENDA = OLD.COD_VENDA;

        -- Devolve estoque do carro
        UPDATE CARRO 
        SET QTD_EM_ESTOQUE = QTD_EM_ESTOQUE + OLD.QTD_DE_ITENS
        WHERE COD_CARRO = (
            SELECT LC.COD_CARRO
            FROM LOJA_CARRO AS LC
            WHERE LC.COD_LOJA_CARRO = OLD.COD_LOJA_CARRO
        );
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER total_da_venda_tr 
AFTER INSERT OR UPDATE OR DELETE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION total_da_venda();

-- Testes

select * from venda
select * from item_venda
select * from loja_carro
select * from carro

insert into venda
values
(1,1,1,null,current_date)

insert into item_venda
values
(1,1,1,1)

insert into item_venda
values
(2,1,2,1)

insert into item_venda
values
(3,1,3,1)

UPDATE ITEM_VENDA
SET QTD_DE_ITENS = 3
WHERE COD_ITEM_VENDA = 2;

DELETE FROM ITEM_VENDA
WHERE COD_ITEM_VENDA = 3;