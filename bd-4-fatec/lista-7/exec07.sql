CREATE DATABASE exec07
GO

USE exec07
GO

CREATE TABLE cliente(
    rg VARCHAR(20) NOT NULL,
    cpf VARCHAR(20) NOT NULL,
    nome VARCHAR(30) NOT NULL,
    endereco VARCHAR(30) NOT NULL,
    PRIMARY KEY(rg)
)
GO

CREATE TABLE pedido(
    nota_fiscal INT NOT NULL,
    valor INT NOT NULL,
    data DATE NOT NULL,
    rg_cliente VARCHAR(20) NOT NULL
    PRIMARY KEY(nota_fiscal)
    FOREIGN KEY(rg_cliente) REFERENCES cliente(rg)
)
GO

CREATE TABLE fornecedor(
    codigo INT NOT NULL,
    nome VARCHAR(30) NOT NULL,
    endereco VARCHAR(30) NOT NULL,
    telefone VARCHAR(20),
    cgc VARCHAR(30),
    cidade VARCHAR(30),
    transporte VARCHAR(30),
    pais VARCHAR(30),
    moeda VARCHAR(5)
    PRIMARY KEY(codigo)
)
GO

CREATE TABLE mercadoria(
    codigo INT NOT NULL,
    descricao VARCHAR(30) NOT NULL,
    preco INT NOT NULL,
    qtd INT NOT NULL,
    cod_fornecedor INT NOT NULL
    PRIMARY KEY(codigo)
    FOREIGN KEY(cod_fornecedor) REFERENCES fornecedor(codigo)
)
GO

-- Consultar 10% de desconto no pedido 1003
SELECT valor, (valor - (0.1 * valor)) AS valor_10_desconto
FROM pedido
WHERE pedido.nota_fiscal = 1003

-- Consultar 5% de desconto em pedidos com valor maior de R$700,00
SELECT valor, (valor - (0.05 * valor)) AS valor_05_desconto
FROM pedido
WHERE pedido.valor > 700

-- Consultar e atualizar aumento de 20% no valor de marcadorias com
-- estoque menor de 10
SELECT *
FROM mercadoria

UPDATE mercadoria
SET preco = (preco + (0.2 * preco))
WHERE mercadoria.qtd < 10


SELECT *
FROM mercadoria

-- Data e valor dos pedidos do Luiz
SELECT p.data, p.valor
FROM pedido p, cliente c
WHERE p.rg_cliente = c.rg
	AND c.nome LIKE 'Luiz%'

-- CPF, Nome e endereço do cliente de nota 1004
SELECT c.cpf, c.nome, c.endereco
FROM cliente c, pedido p
WHERE p.rg_cliente = c.rg
AND p.nota_fiscal = 1004

-- País e meio de transporte da Cx. De som
SELECT f.pais, f.transporte
FROM mercadoria m, fornecedor f
WHERE m.cod_fornecedor = f.codigo
	AND m.descricao LIKE 'Cx. de som%'

-- Nome e Quantidade em estoque dos produtos fornecidos pela Clone
SELECT m.descricao, m.qtd
FROM mercadoria m, fornecedor f
WHERE m.cod_fornecedor = f.codigo
	AND f.nome LIKE 'Clone%'

-- Endereço e telefone dos fornecedores do monitor
SELECT f.endereco, f.telefone
FROM mercadoria m, fornecedor f
WHERE m.cod_fornecedor = f.codigo
	AND m.descricao LIKE 'monitor%'

-- Tipo de moeda que se compra o notebook
SELECT f.moeda
FROM mercadoria m, fornecedor f
WHERE m.cod_fornecedor = f.codigo
	AND m.descricao LIKE 'notebook%'

-- Há quantos dias foram feitos os pedidos e, criar uma coluna que
--escreva Pedido antigo para pedidos feitos há mais de 6 meses
SELECT DATEDIFF(DAY, p.data, GETDATE()) AS dias_pedido,
	CASE
		WHEN DATEDIFF(MONTH, p.data, GETDATE()) > 6 THEN
			'Pedido antigo'
		ELSE
			'-'
		END AS mais_de_6_meses
FROM pedido p
-- Nome e Quantos pedidos foram feitos por cada cliente
SELECT c.nome, COUNT(p.rg_cliente) AS qtd_pedido
FROM cliente c, pedido p
WHERE p.rg_cliente = c.rg
GROUP BY c.nome

-- RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos
SELECT c.nome
FROM cliente c
LEFT JOIN pedido p
ON c.rg = p.rg_cliente
WHERE p.rg_cliente IS NULL

/*
USE master
GO

DROP DATABASE exec07
GO
*/