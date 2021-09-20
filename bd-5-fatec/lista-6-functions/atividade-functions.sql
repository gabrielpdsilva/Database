CREATE DATABASE produto_functions
GO

USE produto_functions
GO

CREATE TABLE produto(
	codigo INT,
	nome VARCHAR(30),
	valor_unitario DECIMAL(7,2),
	qtd_estoque INT,
	PRIMARY KEY(codigo)
)
GO

INSERT INTO produto(codigo, nome, valor_unitario, qtd_estoque) VALUES
(1, 'Livro', 15., 4),
(2, 'DVD', 15.30, 9),
(3, 'Mouse', 6.10, 10),
(4, 'Camiseta', 20, 1),
(5, 'USB', 26.99, 2)
GO

-- Fazer uma Scalar Function que verifique, na tabela produtos
-- (codigo, nome, valor unitário e qtd estoque) quantos produtos estão
-- com estoque abaixo de um valor de entrada (O valor mínimo deve ser
-- parâmetro de entrada)

CREATE FUNCTION fn_qtd_prod_estoque_baixo(@qtd_minima_exigida INT)
RETURNS INT
AS
BEGIN

	DECLARE @qtd_produtos_estoque INT

		SET @qtd_produtos_estoque = (
			SELECT COUNT(codigo)
			FROM produto
			WHERE produto.qtd_estoque < @qtd_minima_exigida
		)

	RETURN @qtd_produtos_estoque
END
GO

SELECT dbo.fn_qtd_prod_estoque_baixo(5) AS qtd_produtos_estoque_baixo

-- Fazer uma Multi Statement Table Function que liste o código, o nome
-- e a quantidade dos produtos que estão com o estoque abaixo de um
-- valor de entrada (O valor mínimo deve ser parâmetro de entrada)

CREATE FUNCTION fn_listar_produtos_estoque_baixo(@qtd_minima_exigida INT)
RETURNS @table TABLE (
	codigo INT,
	nome VARCHAR(30),
	qtd_estoque INT
)
AS
BEGIN

	INSERT INTO @table (codigo, nome, qtd_estoque)
		SELECT codigo, nome, qtd_estoque FROM produto
		WHERE produto.qtd_estoque < @qtd_minima_exigida

	RETURN
END
GO

SELECT * FROM fn_listar_produtos_estoque_baixo(3)