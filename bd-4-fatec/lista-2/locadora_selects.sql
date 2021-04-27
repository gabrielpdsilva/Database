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
    dvd_num					INT NOT NULL,
    cliente_num_cadastro	INT NOT NULL,
    data_locacao			DATE NOT NULL DEFAULT(GETDATE()),
    data_devolucao			DATE CHECK(data_devolucao > GETDATE()),
    valor					DECIMAL(7,2) CHECK(valor > 0)
    PRIMARY KEY(dvd_num, cliente_num_cadastro, data_locacao)
    FOREIGN KEY(dvd_num) REFERENCES dvd(num),
    FOREIGN KEY(cliente_num_cadastro) REFERENCES cliente(num_cadastro)
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

--USE master
--GO
--DROP DATABASE locacao_filmes
--GO

--1) Fazer um select que retorne os nomes dos filmes de 2014
SELECT titulo FROM filme
WHERE ano = 2014

-- 2) Fazer um select que retorne o id e o ano do filme Birdman
SELECT id, ano FROM filme
WHERE titulo = 'Birdman'

-- 3) Fazer um select que retorne o id e o ano do filme que chama ___plash
SELECT id, ano FROM filme
WHERE titulo LIKE '%plash'

-- 4) Fazer um select que retorne o id, o nome e o nome_real da estrela cujo nome começa
-- com Steve
SELECT id, nome, nome_real FROM estrela 
WHERE nome LIKE 'steve%'

-- 5) Fazer um select que retorne FilmeId e a data_fabricação em formato (DD/MM/YYYY)
-- (apelidar de fab) dos filmes fabricados a partir de 01-01-2020
SELECT filme_id, CONVERT(CHAR(10), data_fabricacao, 103) AS fab FROM dvd
WHERE data_fabricacao > '01-01-2020'

-- 6) Fazer um select que retorne DVDnum, data_locacao, data_devolucao, valor e valor
-- com multa de acréscimo de 2.00 da locação do cliente 5505
SELECT dvd_num, data_locacao, data_devolucao, valor, CAST(valor * 1.02 AS DECIMAL(3,2)) AS acrescimo
FROM locacao
WHERE cliente_num_cadastro = 5505

-- 7) Fazer um select que retorne Logradouro, num e CEP de Matilde Luz
SELECT logradouro + ', ' + CAST(num AS VARCHAR(5)) + ' - ' + cep AS 'endereco'
FROM cliente
WHERE nome = 'Matilde Luz'

-- 8) Fazer um select que retorne Nome real de Michael Keaton
SELECT nome_real FROM estrela
WHERE nome = 'Michael Keaton'

-- 9) Fazer um select que retorne o num_cadastro, o nome e o endereço completo,
-- concatenando (logradouro, numero e CEP), apelido end_comp, dos clientes cujo ID é
-- maior ou igual 5503
SELECT num_cadastro, nome, logradouro + ', ' + CAST(num AS VARCHAR(5)) + ' - ' + cep AS end_comp
FROM cliente
WHERE num_cadastro >= 5503
