CREATE DATABASE exercicios
GO
USE exercicios
GO

-- 1. Fazer um algoritmo que leia 1 n�mero e mostre se � m�ltiplo
-- de 2,3,5 ou nenhum deles.
DECLARE @numero AS INT
SET @numero = 15

IF(@numero % 2 = 0)
BEGIN
	PRINT('� multiplo de 2')	
END

IF(@numero % 3 = 0)
BEGIN
	PRINT('� multiplo de 3')	
END

IF(@numero % 5 = 0)
BEGIN
	PRINT('� multiplo de 5')	
END

IF(@numero % 2 <> 0 AND @numero % 3 <> 0 AND @numero % 5 <> 0)
BEGIN
	PRINT('N�o � multiplo')	
END

-- 2.  Fazer um algoritmo que inverta uma palavra e mostre
-- a palavra original toda min�scula (independente da entrada)
-- e a invertida toda mai�scula.
DECLARE @palavra AS VARCHAR(20)
SET @palavra = 'Jonathan Joestar'
PRINT('Original: ' + LOWER(@palavra))
PRINT('Invertida: ' + UPPER(REVERSE(@palavra)))

