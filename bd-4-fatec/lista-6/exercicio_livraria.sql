CREATE DATABASE livraria
GO

USE livraria
GO

CREATE TABLE clientes(
    cod         INT             NOT NULL,
    nome        VARCHAR(80)     NOT NULL,
    logradouro  VARCHAR(100),
    numero      INT,
    telefone    CHAR(9)
    PRIMARY KEY(cod)
)
GO


CREATE TABLE corredor(
    cod  INT         NOT NULL,
    tipo VARCHAR(50) NOT NULL
    PRIMARY KEY(cod)
)
GO

CREATE TABLE autores(
	cod         INT             NOT NULL,
    nome        VARCHAR(70)     NOT NULL,
    pais        VARCHAR(15)     NOT NULL,
    biografia   VARCHAR(200)    NOT NULL
    PRIMARY KEY(cod)
)
GO


CREATE TABLE livros(
    cod             INT         NOT NULL,
    cod_autor       INT         NOT NULL,
    cod_corredor    INT         NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    pag             INT         NOT NULL,
    idioma          VARCHAR(30) NOT NULL
    PRIMARY KEY(cod)
    FOREIGN KEY(cod_corredor) REFERENCES corredor(cod),
    FOREIGN KEY(cod_autor) REFERENCES autores(cod)
)
GO

CREATE TABLE emprestimo(
    cod_cli     INT         NOT NULL,
    data        DATETIME    NOT NULL,
    cod_livro   INT         NOT NULL
    PRIMARY KEY(cod_cli, data, cod_livro)
    FOREIGN KEY(cod_cli) REFERENCES clientes(cod),
    FOREIGN KEY(cod_livro) REFERENCES livros(cod)
)
GO

--1) Fazer uma consulta que retorne o nome do cliente e
-- a data do empréstimo formatada padrão BR (dd/mm/yyyy)

SELECT c.nome, CONVERT(CHAR(10), emp.data, 103) AS data_locacao
FROM clientes c, emprestimo emp
WHERE emp.cod_cli = c.cod

--2) Fazer uma consulta que retorne Nome do autor e Quantos
-- livros foram escritos por Cada autor, ordenado pelo número
-- de livros. Se o nome do autor tiver mais de 25 caracteres,
-- mostrar só os 13 primeiros.

SELECT
	CASE
		WHEN
			LEN(aut.nome) > 25 THEN
				SUBSTRING(aut.nome, 1, 13) + '...'
			ELSE
				aut.nome
	END AS nome_autor,
	COUNT(liv.cod_autor) AS qtd_livros
FROM autores aut, livros liv
WHERE liv.cod_autor = aut.cod
GROUP BY aut.nome
ORDER BY COUNT(liv.cod_autor) DESC

--3) Fazer uma consulta que retorne o nome do autor e o país de
-- origem do livro com maior número de páginas cadastrados no sistema

SELECT aut.nome, aut.pais, MAX(liv.pag) AS qtd_paginas
FROM autores aut, livros liv
WHERE liv.cod_autor = aut.cod
GROUP BY aut.nome, aut.pais
ORDER BY MAX(liv.pag) DESC

--4) Fazer uma consulta que retorne nome e endereço concatenado
-- dos clientes que tem livros emprestados

SELECT cli.nome,
	cli.logradouro + '-' + CONVERT(CHAR(10), cli.numero) AS endereco_completo
FROM clientes cli, emprestimo emp
WHERE emp.cod_cli = cli.cod

--5) Nome dos Clientes, sem repetir e, concatenados como
-- enderço_telefone, o logradouro, o numero e o telefone) dos
-- clientes que Não pegaram livros. Se o logradouro e o 
-- número forem nulos e o telefone não for nulo, mostrar só o
-- telefone. Se o telefone for nulo e o logradouro e o número não
-- forem nulos, mostrar só logradouro e número. Se os três existirem,
-- mostrar os três.
-- O telefone deve estar mascarado XXXXX-XXXX

SELECT DISTINCT cli.nome,
	CASE
		WHEN (cli.logradouro IS NULL AND cli.numero IS NULL AND cli.telefone IS NOT NULL) THEN
			cli.telefone
		ELSE
			CASE
				WHEN (cli.logradouro IS NOT NULL AND cli.numero IS NOT NULL AND cli.telefone IS NULL) THEN
					cli.logradouro + '-' + CONVERT(CHAR(10), cli.numero)
					ELSE
						cli.logradouro + '-' + CONVERT(CHAR(04), cli.numero) + '; ' + SUBSTRING(cli.telefone, 1, 5) + '-' + SUBSTRING(cli.telefone, 6, 4)
				END
		END AS endereco_telefone
FROM clientes cli
LEFT OUTER JOIN emprestimo emp
ON cli.cod = emp.cod_cli
WHERE emp.cod_cli IS NULL

--6) Fazer uma consulta que retorne Quantos livros não foram emprestados
SELECT COUNT(liv.nome) AS livros_nao_emprestados
FROM livros liv
LEFT OUTER JOIN emprestimo emp
ON liv.cod = emp.cod_livro
WHERE emp.cod_livro IS NULL

--7) Fazer uma consulta que retorne Nome do Autor, Tipo do corredor e
-- quantos livros, ordenados por quantidade de livro
SELECT DISTINCT aut.nome, corr.tipo, COUNT(liv.cod_corredor) AS qtd_livros
FROM autores aut, corredor corr, livros liv
WHERE liv.cod_autor = aut.cod
GROUP BY aut.nome, corr.tipo
ORDER BY COUNT(liv.cod_corredor) DESC


--8) Considere que hoje é dia 18/05/2012, faça uma consulta que apresente
-- o nome do cliente, o nome do livro, o total de dias que cada um está com
-- o livro e, uma coluna que apresente, caso o número de dias seja superior a
-- 4, apresente 'Atrasado', caso contrário, apresente 'No Prazo'
SELECT cli.nome, liv.nome, DATEDIFF(DAY, emp.data, '2012-05-18') AS dias_emprestado,
	CASE
		WHEN DATEDIFF(DAY, emp.data, '2012-05-18') > 4 THEN
			'Atrasado'
		ELSE
			'No Prazo'
		END AS status_emprestimo
FROM clientes cli, livros liv, emprestimo emp
WHERE emp.cod_cli = cli.cod
	AND emp.cod_livro = liv.cod

--9) Fazer uma consulta que retorne cod de corredores, tipo de corredores e
-- quantos livros tem em cada corredor
SELECT corr.cod, corr.tipo, COUNT(liv.cod_corredor) AS qtd_livros_corredor
FROM corredor corr, livros liv
WHERE liv.cod_corredor = corr.cod
GROUP BY corr.cod, corr.tipo

--10) Fazer uma consulta que retorne o Nome dos autores cuja quantidade de
-- livros cadastrado é maior ou igual a 2.
SELECT aut.nome
FROM autores aut, livros liv
WHERE liv.cod_autor = aut.cod
GROUP BY aut.nome
HAVING COUNT(liv.cod_autor) >= 2

--11) Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o
-- nome do cliente, o nome do livro dos empréstimos que tem 7 dias ou mais
SELECT cli.nome AS nome_cliente, liv.nome AS nome_livro
FROM clientes cli, livros liv, emprestimo emp
WHERE emp.cod_cli = cli.cod
	AND emp.cod_livro = liv.cod
	AND DATEDIFF(DAY, emp.data, '2012-05-18') >= 7

/*
USE master
GO

DROP DATABASE livraria
GO
*/