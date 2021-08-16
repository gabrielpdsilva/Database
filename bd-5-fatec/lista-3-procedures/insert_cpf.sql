CREATE DATABASE validar_cpf
GO

USE validar_cpf
GO

-- procedure pra verificar se o cpf
-- possui todos os digitos iguais
CREATE PROCEDURE sp_cpf_digitos_diferentes(@cpf CHAR(11), @cpf_valido BIT OUTPUT)
AS
BEGIN
    DECLARE @valor_cpf INT,
			@digitos_identicos BIT,
			@index INT,
			@digito_anterior CHAR(1),
			@digito_atual CHAR(1)

    SET @digitos_identicos = 1
    SET @index = 1

    WHILE(@index <= LEN(@cpf))
    BEGIN
        IF(@index = 1) SET @digito_anterior = SUBSTRING(@cpf, @index, 1)
		ELSE SET @digito_anterior = SUBSTRING(@cpf, @index-1, 1)

		SET @digito_atual = SUBSTRING(@cpf, @index, 1)

		IF(@digito_anterior <> @digito_atual)
		BEGIN
			SET @digitos_identicos = 0
		END

        IF(@index = 11 AND @digitos_identicos = 1) SET @cpf_valido = 0

        SET @index = @index + 1
    END

	IF(@digitos_identicos = 0)
	BEGIN
		SET @cpf_valido = 1
	END
	ELSE
	BEGIN
		SET @cpf_valido = 0
	END
END


-- procedure pra calcular o cpf
CREATE PROCEDURE sp_calcular_cpf(@CPF VARCHAR(11), @cpf_valido BIT OUTPUT)
AS
BEGIN
  DECLARE @index INT,
          @soma INT,
          @digito_1 INT,
          @digito_2 INT

	BEGIN

		-- primeiro digito
		SET @SOMA = 0
		SET @index = 1
		WHILE (@index <= 9)
		BEGIN
		  SET @soma = @soma + CONVERT(INT,SUBSTRING(@CPF, @index, 1)) * (11 - @index);
		  SET @index = @index + 1
		END

		SET @digito_1 = 11-(@soma % 11)

		IF (@digito_1 > 9) SET @digito_1 = 0

		-- segundo digito
		SET @soma = 0
		SET @index = 1
		WHILE (@index <= 10)
		BEGIN
			SET @soma = @soma + CONVERT(INT,SUBSTRING(@CPF, @index, 1)) * (12 - @index);
			SET @index = @index + 1
		END

		SET @digito_2 = 11-(@soma % 11)

		IF (@digito_2 > 9) SET @digito_2 = 0

		-- Validando
		IF (@digito_1 = SUBSTRING(@CPF,LEN(@CPF)-1,1)) AND (@digito_2 = SUBSTRING(@CPF,LEN(@CPF),1))
			SET @cpf_valido = 1
		ELSE
			SET @cpf_valido = 0
		END
END

-- Demonstracao

-- Exemplo valido de CPF: 37319812037
-- Exemplo valido de CPF: 33333333333
-- Exemplo invalido de CPF: 12345678910

DECLARE @output_digitos_diferentes AS BIT
DECLARE @output_cpf_valido AS BIT
DECLARE @input_cpf AS CHAR(11)

SET @input_cpf = '12345678910'

EXEC sp_calcular_cpf @input_cpf, @output_cpf_valido OUTPUT
PRINT @output_cpf_valido

IF(@output_cpf_valido = 1)
BEGIN
	EXEC sp_cpf_digitos_diferentes @input_cpf, @output_digitos_diferentes OUTPUT
	PRINT @output_digitos_diferentes

	IF(@output_digitos_diferentes = 1) PRINT('CPF valido!')
	ELSE RAISERROR('CPF invalido!', 16, 1)

END
ELSE RAISERROR('CPF invalido!', 16, 1)

-- Exercício: Baseado na SP já criada no exercício anterior (Validação de CPF),
-- criar uma DATABASE, com uma tabela cadastro (cpf, nome, logradouro, numero),
-- a inserção de dados na tabela deve vir de uma SP que recebe cpf, nome,
-- logradouro e número e, apenas realize o insert se o CPF for válido. Lançar
-- um RAISE ERROR para CPF inválido.

CREATE TABLE cadastro(
cpf CHAR(11) NOT NULL,
nome VARCHAR(30),
logradouro VARCHAR(30),
numero INT
PRIMARY KEY(cpf)
)
GO

DROP PROCEDURE sp_insert_cadastro
CREATE PROCEDURE sp_insert_cadastro(@cpf CHAR(11),
									@nome VARCHAR(30),
									@logradouro VARCHAR(30),
									@numero INT,
									@insert_concluido BIT OUTPUT) AS
BEGIN

	DECLARE @output_digitos_diferentes AS BIT,
			@output_cpf_valido AS BIT

	EXEC sp_calcular_cpf @cpf, @output_cpf_valido OUTPUT
	PRINT @output_cpf_valido
	SET @insert_concluido = 0
	IF(@output_cpf_valido = 1)
	BEGIN
		EXEC sp_cpf_digitos_diferentes @cpf, @output_digitos_diferentes OUTPUT
		PRINT @output_digitos_diferentes

		IF(@output_digitos_diferentes = 1)
		BEGIN
			INSERT INTO cadastro(cpf, nome, logradouro, numero) VALUES(@cpf, @nome, @logradouro, @numero)
			SET @insert_concluido = 1
		END
		ELSE RAISERROR('CPF invalido!', 16, 1)

	END
	ELSE RAISERROR('CPF invalido!', 16, 1)
	
END

DECLARE @output BIT
EXEC sp_insert_cadastro '61638954011', 'Ana', 'Rua Alguma Coisa', 199, @output OUTPUT
PRINT @output

SELECT * FROM cadastro