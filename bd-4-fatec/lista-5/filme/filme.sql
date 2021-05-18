CREATE DATABASE locacao_filmes
GO

USE locacao_filmes
GO

CREATE TABLE filme(
    id		INT NOT NULL IDENTITY(1001,1),
    titulo	VARCHAR(40) NOT NULL,
    ano		INT CHECK(ano <= 2021)
    PRIMARY KEY(id)
)
GO

CREATE TABLE estrela(
    id		INT NOT NULL IDENTITY(9901,1),
    nome	VARCHAR(50) NOT NULL
    PRIMARY KEY(id)
)
GO

CREATE TABLE filme_estrela(
    filme_id	INT NOT NULL,
    estrela_id	INT NOT NULL
    PRIMARY KEY(filme_id, estrela_id)
    FOREIGN KEY(filme_id) REFERENCES filme(id),
    FOREIGN KEY(estrela_id) REFERENCES estrela(id)
)
GO

CREATE TABLE dvd(
    num				INT NOT NULL IDENTITY(10001,1),
    data_fabricacao DATE NOT NULL CHECK(data_fabricacao < GETDATE()),
    filme_id		INTEGER NOT NULL
    PRIMARY KEY(num)
    FOREIGN KEY(filme_id) REFERENCES filme(id)
)
GO

CREATE TABLE cliente(
    num_cadastro	INT NOT NULL IDENTITY(5501,1),
    nome			VARCHAR(70) NOT NULL,
    logradouro		VARCHAR(150) NOT NULL,
    num				INT NOT NULL CHECK(num > 0),
    cep				CHAR(8) CHECK(LEN(cep) = 8)
    PRIMARY KEY(num_cadastro)
)
GO

CREATE TABLE locacao(
    dvd_num					INT  NOT NULL,
    cliente_num_cadastro	INT  NOT NULL,
    data_locacao			DATE NOT NULL DEFAULT(GETDATE()),
    data_devolucao			DATE NOT NULL,
    valor					DECIMAL(7,2) CHECK(valor > 0)
    PRIMARY KEY(dvd_num, cliente_num_cadastro, data_locacao)
    FOREIGN KEY(dvd_num) REFERENCES dvd(num),
    FOREIGN KEY(cliente_num_cadastro) REFERENCES cliente(num_cadastro),
	CONSTRAINT chk_dt CHECK(data_devolucao > data_locacao)
)
GO

ALTER TABLE estrela
ADD nome_real VARCHAR(50)
GO

ALTER TABLE filme
ALTER COLUMN titulo VARCHAR(80)
GO

INSERT INTO filme(titulo, ano) VALUES
('Whiplash', 2015),
('Birdman', 2015),
('Interestelar', 2014),
('A culpa é das estrelas', 2014),
('Alexandre e o dia terrível, horrível, espantoso e horroroso', 2014),
('Sing', 2016)
GO

SELECT * FROM filme

INSERT INTO estrela(nome, nome_real) VALUES
('Michael Keaton', 'Michael John Douglas'),
('Emma Stone', 'Emily Jean Stone'),
('Miles Teller', NULL),
('Steve Carell', 'Steven John Carell'),
('Jennifer Garner', 'Jennifer Anne Garner')
GO

SELECT * FROM estrela

INSERT INTO filme_estrela(filme_id, estrela_id) VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)
GO

SELECT * FROM filme_estrela

INSERT INTO dvd(data_fabricacao, filme_id) VALUES
('2020-12-02', 1001),
('2019-10-18', 1002),
('2020-04-03', 1003),
('2020-12-02', 1001),
('2019-10-18', 1004),
('2020-04-03', 1002),
('2020-12-02', 1005),
('2019-10-18', 1002),
('2020-04-03', 1003)
GO

SELECT * FROM dvd

INSERT INTO cliente(nome, logradouro, num, cep) VALUES
('Matilde Luz', 'Rua Síria', 150, '03086040'),
('Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
('Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
('Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
('Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')
GO

SELECT * FROM cliente

-- Pra funcionar é importante que a data de devolução
-- seja maior do que a data que esse código está sendo executado
INSERT INTO locacao(dvd_num, cliente_num_cadastro, data_locacao, data_devolucao, valor) VALUES
(10001, 5502, '2021-02-18', '2021-05-21', 3.50),
(10009, 5502, '2021-02-18', '2021-05-21', 3.50),
(10002, 5503, '2021-02-18', '2021-05-19', 3.50),
(10002, 5505, '2021-02-20', '2021-05-23', 3.00),
(10004, 5505, '2021-02-20', '2021-05-23', 3.00),
(10005, 5503, '2021-02-20', '2021-05-23', 3.00),
(10001, 5501, '2021-02-24', '2021-05-26', 3.50),
(10008, 5501, '2021-02-24', '2021-05-26', 3.50)
GO

SELECT * FROM locacao

UPDATE cliente
SET cep = '08411150' WHERE num_cadastro = 5503
GO

UPDATE cliente
SET cep = '02918190' WHERE num_cadastro = 5504
GO

UPDATE locacao
SET valor = 3.25 WHERE cliente_num_cadastro = 5502
GO

UPDATE locacao
SET valor = 3.10 WHERE cliente_num_cadastro = 5501
GO

UPDATE dvd
SET data_fabricacao = '2019-07-14' WHERE num = 10005
GO

UPDATE estrela
SET nome_real = 'Miles Alexander Teller' WHERE nome = 'Miles teller'
GO

DELETE filme
WHERE titulo = 'Sing'
GO

-- 04/05/2021

--1) Fazer uma consulta que retorne ID, Ano, nome do Filme (Caso o
-- nome do filme tenha mais de 10 caracteres, para caber no campo da
-- tela, mostrar os 10 primeiros caracteres, seguidos de reticências ...)
-- dos filmes cujos DVDs foram fabricados depois de 01/01/2020
SELECT id, ano,
	CASE
		WHEN
			LEN(titulo) > 10 THEN
				SUBSTRING(titulo, 1, 10) + '...'
			ELSE
				titulo
	END AS titulo_filme
FROM filme
WHERE id IN
(
	SELECT filme_id
	FROM dvd
	WHERE data_fabricacao > '2020-01-01'
)
GO

-- 2) Fazer uma consulta que retorne num, data_fabricacao,
-- qtd_meses_desde_fabricacao (Quantos meses desde que o dvd foi
-- fabricado até hoje) do filme Interestelar
SELECT num, data_fabricacao,
	DATEDIFF(MONTH, data_fabricacao, GETDATE()) AS qtd_meses_desde_fabricacao
FROM dvd
WHERE filme_id IN
(
	SELECT id
	FROM filme WHERE titulo = 'Interestelar'
)
GO

-- 3) Fazer uma consulta que retorne num_dvd, data_locacao,
-- data_devolucao, dias_alugado(Total de dias que o dvd ficou
-- alugado) e valor das locações da cliente que tem, no nome, o termo Rosa
SELECT dvd_num, data_locacao, data_devolucao,
	DATEDIFF(DAY, data_locacao, data_devolucao) AS dias_alugado
FROM locacao
WHERE cliente_num_cadastro IN
(
	SELECT num_cadastro
	FROM cliente
	WHERE nome LIKE '%Rosa%'
)
GO

-- 4) Nome, endereço_completo (logradouro e número concatenados),
-- cep (formato XXXXX-XXX) dos clientes que alugaram DVD de num 10002.
SELECT nome,
	logradouro + '-' + CONVERT(CHAR(10), num) AS endereco_completo,
	SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6, 3) AS cep
FROM cliente
WHERE num_cadastro IN
(
	SELECT cliente_num_cadastro
	FROM locacao
	WHERE dvd_num IN
	(
		SELECT num
		FROM dvd
		WHERE num = 10002
	)
)
GO

-- 11/05/2021
--1) Consultar num_cadastro do cliente, nome do cliente,
-- data_locacao (Formato dd/mm/aaaa), Qtd_dias_alugado (total de dias que o filme ficou alugado),
-- titulo do filme, ano do filme da locação do cliente cujo nome inicia com Matilde
SELECT cli.num_cadastro, cli.nome AS nome_cliente,
		CONVERT(CHAR(10), loc.data_locacao, 103) AS data_locacao, DATEDIFF(DAY, data_locacao, data_devolucao) AS qtd_dias_alugado, 
		film.titulo AS titulo_filme, film.ano AS ano_filme
FROM cliente cli, locacao loc, filme film, dvd d
WHERE cli.num_cadastro = loc.cliente_num_cadastro
	AND loc.dvd_num = d.num
	AND film.id = d.filme_id
	AND cli.nome LIKE 'Matilde%'

--2) Consultar nome da estrela, nome_real da estrela, título do filme dos filmes
-- cadastrados do ano de 2015
SELECT est.nome, est.nome_real, film.titulo
FROM estrela est, filme film, filme_estrela fe
WHERE est.id = fe.estrela_id
	AND film.id = fe.filme_id
	AND film.ano = 2015

--3) Consultar título do filme, data_fabricação do dvd (formato dd/mm/aaaa), caso
-- a diferença do ano do filme com o ano atual seja maior que 6, deve aparecer a
-- diferença do ano com o ano atual concatenado com a palavra anos (Exemplo: 7 anos),
-- caso contrário só a diferença (Exemplo: 4).
SELECT CAST(filme.ano AS VARCHAR(4)) AS ano_filme FROM filme
SELECT film.titulo, CONVERT(CHAR(10), d.data_fabricacao, 103) AS data_fabricacao,
	CASE
		WHEN (YEAR(GETDATE()) - film.ano > 6) THEN
			CAST((YEAR(GETDATE()) - film.ano) AS VARCHAR(1)) + ' anos'
		ELSE
			CAST((YEAR(GETDATE()) - film.ano) AS VARCHAR(1))
	END AS diferenca_com_ano_atual
FROM filme film, dvd d
WHERE d.filme_id = film.id
GO

-- 18/05/2021

-- 1) Consultar num_cadastro do cliente, nome do cliente, titulo do filme,
-- data_fabricação do dvd, valor da locação, dos dvds que tem a maior data de
-- fabricação dentre todos os cadastrados.
SELECT c.num_cadastro, c.nome, f.titulo, d.data_fabricacao, l.valor
FROM cliente c, filme f, dvd d, locacao l
WHERE c.num_cadastro = l.cliente_num_cadastro
	AND f.id = d.filme_id
	AND d.num = l.dvd_num
	AND d.data_fabricacao IN (
		SELECT MAX(dvd.data_fabricacao)
		FROM dvd
	)
GROUP BY c.num_cadastro, c.nome, f.titulo, d.data_fabricacao, l.valor
ORDER BY c.nome
GO

-- 2) Consultar num_cadastro do cliente, nome do cliente, data de
-- locação (Formato DD/MM/AAAA) e a quantidade de DVD´s alugados por cliente
-- (Chamar essa coluna de qtd), por data de locação.
SELECT c.num_cadastro, c.nome, l.data_locacao, COUNT(l.dvd_num) AS qtd
FROM cliente c, locacao l
WHERE c.num_cadastro = l.cliente_num_cadastro
GROUP BY c.num_cadastro, c.nome, l.data_locacao
ORDER BY c.nome
GO

-- 3) Consultar num_cadastro do cliente, nome do cliente, data de
-- locação (Formato DD/MM/AAAA) e o valor total de todos os dvd´s alugados
-- (Chamar essa coluna de valor_total), por data de locação.
SELECT c.num_cadastro, c.nome, CONVERT(CHAR(10), l.data_locacao, 103) AS data_locacao, SUM(l.valor) AS valor_total
FROM cliente c, locacao l, dvd d
WHERE c.num_cadastro = l.cliente_num_cadastro
	AND d.num = l.dvd_num
GROUP BY c.num_cadastro, c.nome, l.data_locacao
ORDER BY c.nome
GO

-- 4) Consultar num_cadastro do cliente, nome do cliente, Endereço
-- concatenado de logradouro e numero como Endereco, data de locação
-- (Formato DD/MM/AAAA) dos clientes que alugaram mais de 2 filmes simultaneamente
SELECT c.num_cadastro, c.nome,
c.logradouro + '-' + CONVERT(CHAR(10), c.num) AS endereco_completo,
CONVERT(CHAR(10), l.data_locacao, 103) AS data_locacao
FROM cliente c, locacao l, dvd d
WHERE c.num_cadastro = l.cliente_num_cadastro
	AND d.num = l.dvd_num
GROUP BY c.num_cadastro, c.nome, l.data_locacao, c.logradouro, c.num
HAVING COUNT(l.dvd_num) > 1
ORDER BY c.nome
GO

USE master
GO

DROP DATABASE locacao_filmes
GO