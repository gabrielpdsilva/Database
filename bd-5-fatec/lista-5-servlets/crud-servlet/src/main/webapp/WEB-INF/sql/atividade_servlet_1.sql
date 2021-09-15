CREATE DATABASE atividade_servlet_1
GO

USE atividade_servlet_1
GO

CREATE TABLE filme(
	idFilme			INT,
	nomeBR			VARCHAR(45),
	nomeEN			VARCHAR(45),
	anoLancamento	INT,
	sinopse			TEXT
	PRIMARY KEY(idFilme)
)
GO

CREATE PROCEDURE sp_realizar_alteracao(
	@tipo_operacao	CHAR(1),
	@idFilme		INT,
	@nomeBR			VARCHAR(45),
	@nomeEN			VARCHAR(45),
	@anoLancamento	INT,
	@sinopse		TEXT,
	@saida			VARCHAR(100) OUTPUT
) AS
BEGIN

	IF(@tipo_operacao = 'I')
	BEGIN
		BEGIN TRY
			INSERT INTO filme(
				idFilme,
				nomeBR,
				nomeEN,
				anoLancamento,
				sinopse
			) VALUES(
				@idFilme,
				@nomeBR,
				@nomeEN,
				@anoLancamento,
				@sinopse
			)
			SET @saida = 'INSERT realizado com sucesso.'
		END TRY
		BEGIN CATCH
			RAISERROR('Não foi possível fazer o INSERT.', 16, 1)
		END CATCH
	END

	IF(@tipo_operacao = 'U')
	BEGIN
		BEGIN TRY
			UPDATE filme
			SET nomeBR = @nomeBR,
				nomeEN = @nomeEN,
				anoLancamento = @anoLancamento,
				sinopse = @sinopse
			WHERE idFilme = @idFilme
			SET @saida = 'UPDATE realizado com sucesso.'
		END TRY
		BEGIN CATCH
			RAISERROR('Não foi possível fazer o UPDATE.', 16, 1)
		END CATCH
	END

	IF(@tipo_operacao = 'D')
	BEGIN
		BEGIN TRY
			DELETE filme
			WHERE idFilme = @idFilme
			SET @saida = 'DELETE realizado com sucesso.'
		END TRY
		BEGIN CATCH
			RAISERROR('Não foi possível fazer o DELETE.', 16, 1)
		END CATCH
	END

END

SELECT * FROM filme

DECLARE @saida AS VARCHAR(100)
EXEC sp_realizar_alteracao 'I', 1, 'O poderoso chefão', 'The godfather', 1972, 'Filme de mafia', @saida OUTPUT

DECLARE @saida AS VARCHAR(100)
EXEC sp_realizar_alteracao 'U', 1, 'O poderoso chefão', 'The godfather', 1971, 'Filme de mafia', @saida OUTPUT

DECLARE @saida AS VARCHAR(100)
EXEC sp_realizar_alteracao 'D', 1, 'O poderoso chefão', 'The godfather', 1971, 'Filme de mafia', @saida OUTPUT
