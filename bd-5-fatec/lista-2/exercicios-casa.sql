CREATE DATABASE exercicios2
GO

USE exercicios2
GO

-- Exercícios:

-- 1. Fazer um algoritmo que leia 3 valores e retorne se os valores formam um triângulo e se ele é
-- isóceles, escaleno ou equilátero.
-- Condições para formar um triângulo
-- 	Nenhum valor pode ser = 0
-- 	Um lado não pode ser maior que a soma dos outros 2.
DECLARE @valor1 AS INT,
		@valor2 AS INT,
		@valor3 AS INT

SET @valor1 = 2
SET @valor2 = 1
SET @valor3 = 3

IF (@valor1 = 0 OR @valor2 = 0 OR @valor3 = 0)
BEGIN
	RAISERROR('Nenhum valor pode ser = 0', 16, 1)
END

IF (@valor1 > @valor2 + @valor3 OR
	@valor2 > @valor1 + @valor3 OR
	@valor3 > @valor1 + @valor2)
BEGIN
	RAISERROR('Um lado não pode ser maior que a soma dos outros 2', 16, 1)
END

IF(@valor1 = @valor2 AND @valor2 = @valor3)
BEGIN
	PRINT('Equilátero')
END
ELSE
IF((@valor1 <> @valor2) AND (@valor2 <> @valor3) AND (@valor1 <> @valor3))
BEGIN
	PRINT('Escaleno')
END
ELSE
BEGIN
	PRINT('Isósceles')
END

-- 2. Fazer um algoritmo que calcule e exiba, os 15 primeiros termos da série de Fibonacci
-- 1,1,2,3,5,8,13,21,...
-- Ao final, deve calcular e exibir a soma dos 15 termos
DECLARE @somatoria AS INT, @n1 AS INT, @n2 AS INT, @cont AS INT, @valorFibonacci AS INT
SET @n1 = 1
SET @n2 = 1
SET @cont = 0
SET @somatoria = 0

PRINT(@n1)
PRINT(@n2)
WHILE(@cont < 13)
BEGIN
	SET @valorFibonacci = @n1 + @n2
	SET @somatoria = @somatoria + @valorFibonacci
	SET @n1 = @n2
	SET @n2 = @valorFibonacci
	PRINT(@valorFibonacci)
	SET @cont = @cont + 1
END
PRINT('Somatoria: ' + CAST(@somatoria AS VARCHAR(5)))

-- 3. Fazer um algoritmo que retorne se duas cadeias de caracteres são palíndromos
DECLARE @cadeia1 AS VARCHAR(30), @cadeia2 AS VARCHAR(30)
SET @cadeia1 = 'ABBA'
SET @cadeia2 = 'ABBA'

IF(LEN(@cadeia1) <> LEN(@cadeia2))
BEGIN
	RAISERROR('O tamanho das palavras é diferente, impossível ser palíndromo.', 16, 1)
END

IF(@cadeia1 = REVERSE(@cadeia2))
BEGIN
	PRINT('É palíndromo')
END
ELSE
BEGIN
	PRINT('Não é palíndromo')
END

-- 4. Fazer um algoritmo que verifique em uma entrada no formato de uma frase, quantas palavras tem e exiba a quantidade de palavras.
DECLARE @frase AS VARCHAR(50), @qtd_palavras AS INT, @i AS INT, @letra_atual AS CHAR(1), @letra_anterior AS CHAR(1)
SET @frase = 'Olá, essa é minha frase'
SET @qtd_palavras = 0
SET @i = 1
WHILE(@i <= LEN(@frase))
BEGIN
	SET @letra_atual = SUBSTRING(@frase, @i, 1)

	IF(@i = 1) SET @letra_anterior = ' '
	ELSE SET @letra_anterior = SUBSTRING(@frase, @i-1, 1)

	IF(@letra_anterior = ' ' AND @letra_atual <> ' ') SET @qtd_palavras = @qtd_palavras + 1
	SET @i = @i + 1
END
PRINT(@qtd_palavras)