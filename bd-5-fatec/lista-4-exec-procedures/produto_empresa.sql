/*
Exercício:

Considere a tabela Produto com os seguintes atributos:
Produto (Codigo | Nome | Valor)
Considere a tabela ENTRADA e a tabela SAÍDA com os seguintes atributos:
(Codigo_Transacao | Codigo_Produto | Quantidade | Valor_Total)
Cada produto que a empresa compra, entra na tabela ENTRADA.
Cada produto que a empresa vende, entra na tabela SAIDA.
Criar uma procedure que receba um código (‘e’ para ENTRADA e ‘s’ para SAIDA),
criar uma exceção de erro para código inválido, receba o codigo_transacao,
codigo_produto e a quantidade e preencha a tabela correta, com o valor_total
de cada transação de cada produto.

*/

CREATE DATABASE produto_empresa
GO

USE produto_empresa
GO

CREATE TABLE produto(
    codigo INT NOT NULL,
    nome VARCHAR(70),
    valor DECIMAL(5,2)
    PRIMARY KEY(codigo)
)
GO

CREATE TABLE entrada(
    codigo_transacao INT NOT NULL,
    codigo_produto INT NOT NULL,
    quantidade INT,
    valor_total DECIMAL(5,2)
    PRIMARY KEY(codigo_transacao)
    FOREIGN KEY(codigo_produto) REFERENCES produto(codigo)
)
GO

CREATE TABLE saida(
    codigo_transacao INT NOT NULL,
    codigo_produto INT NOT NULL,
    quantidade INT,
    valor_total DECIMAL(5,2)
    PRIMARY KEY(codigo_transacao)
    FOREIGN KEY(codigo_produto) REFERENCES produto(codigo)
)
GO

DROP PROCEDURE sp_inserir_produto
CREATE PROCEDURE sp_inserir_produto (
    @tipo_de_acao AS CHAR(1),
	@codigo_transacao INT,
    @codigo_produto INT,
	@quantidade INT,
    @nome_produto VARCHAR(70),
    @valor_produto DECIMAL(5,2),
	@saida VARCHAR(100) OUTPUT
)
AS
DECLARE @tabela VARCHAR(15),
        @query VARCHAR(350),
        @erro VARCHAR(MAX)

	IF(@tipo_de_acao = 'e')
	BEGIN
		SET @tabela = 'entrada'
	END
	ELSE
	BEGIN
		SET @tabela = 'saida'		
	END

	SET @query = 'INSERT INTO '+@tabela+'(codigo_transacao, codigo_produto, quantidade, valor_total) VALUES('+ CAST(@codigo_transacao AS VARCHAR(7)) + ', ' + CAST(@codigo_produto AS VARCHAR(7)) + ', ' + CAST(@quantidade AS VARCHAR(7)) + ', ' + CAST(@valor_produto AS VARCHAR(7)) + ')'

	BEGIN TRY
		INSERT INTO produto(codigo, nome, valor) VALUES(@codigo_produto, @nome_produto, @valor_produto)
		EXEC (@query)
		SET @saida = @tabela + ' inserido(a) com sucesso!'
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		RAISERROR(@erro, 16, 1)
	END CATCH
    
DECLARE @output_compra VARCHAR(100)
EXEC sp_inserir_produto 'e', 1, 7, 3, 'calca', 50.2, @output_compra OUTPUT

DECLARE @output_venda VARCHAR(100)
EXEC sp_inserir_produto 's', 10, 5, 2, 'camiseta', 35.1, @output_venda OUTPUT

SELECT * FROM produto
SELECT * FROM entrada
SELECT * FROM saida
