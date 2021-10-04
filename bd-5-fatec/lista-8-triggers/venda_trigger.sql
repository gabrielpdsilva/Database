-- Parte 1 da tarefa esta em:
-- lista-6-functions/atividade-functions.sql

USE produto_functions
GO

CREATE TABLE venda(
	codigo_venda	INT		NOT NULL,
	data_compra		DATE	NOT NULL,
	codigo_produto	INT		NOT NULL,
	quantidade		INT		NOT NULL
	PRIMARY KEY(codigo_venda, data_compra, codigo_produto)
)
GO

SELECT * FROM produto
SELECT * FROM venda

INSERT INTO produto VALUES(6, 'Jaqueta', 230, 0)
INSERT INTO venda VALUES(1, '2021-10-04', 1, 2)

-- Criar uma trigger after que, se a quantidade em
-- estoque do produto for igual a zero, não permitir o INSERT

CREATE TRIGGER t_insert_venda ON venda
AFTER INSERT
AS
BEGIN
	DECLARE @id_produto INT,
			@qtd_estoque INT

	SELECT @id_produto = codigo_produto FROM INSERTED
	SET @qtd_estoque = (SELECT qtd_estoque FROM produto WHERE codigo = @id_produto)

	IF (@qtd_estoque <= 0)
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Nao existem produtos no estoque', 16, 1)
	END
END

INSERT INTO venda VALUES(2, '2021-10-04', 6, 1)