CREATE DATABASE exaula2
GO
USE exaula2
GO
CREATE TABLE fornecedor (
ID				INT				NOT NULL	PRIMARY KEY,
nome			VARCHAR(50)		NOT NULL,
logradouro		VARCHAR(100)	NOT NULL,
numero			INT				NOT NULL,
complemento		VARCHAR(30)		NOT NULL,
cidade			VARCHAR(70)		NOT NULL
)
GO
CREATE TABLE cliente (
cpf			CHAR(11)		NOT NULL		PRIMARY KEY,
nome		VARCHAR(50)		NOT NULL,	
telefone	VARCHAR(9)		NOT NULL,
)
GO
CREATE TABLE produto (
codigo		INT				NOT NULL	PRIMARY KEY,
descricao	VARCHAR(50)		NOT NULL,
fornecedor	INT				NOT NULL,
preco		DECIMAL(7,2)	NOT NULL
FOREIGN KEY (fornecedor) REFERENCES fornecedor(ID)
)
GO
CREATE TABLE venda (
codigo			INT				NOT NULL,
produto			INT				NOT NULL,
cliente			CHAR(11)		NOT NULL,
quantidade		INT				NOT NULL,
data			DATE			NOT NULL
PRIMARY KEY (codigo, produto, cliente, data)
FOREIGN KEY (produto) REFERENCES produto (codigo),
FOREIGN KEY (cliente) REFERENCES cliente (cpf)
)

--Quantos produtos não foram vendidos (nome da coluna qtd_prd_nao_vend) ?
SELECT COUNT(p.codigo) AS qtd_prd_nao_vend
FROM produto p
LEFT OUTER JOIN venda v
ON p.codigo = v.produto
WHERE v.produto IS NULL

--Descrição do produto, Nome do fornecedor, count() do produto nas vendas
SELECT p.descricao, f.nome, COUNT(p.fornecedor) AS qtd_produto_vendas
FROM produto p, fornecedor f, venda v
WHERE p.codigo = v.produto
	AND p.fornecedor = f.ID
GROUP BY p.descricao, f.nome

--Nome do cliente e Quantos produtos cada um comprou ordenado pela quantidade
SELECT c.nome, COUNT(v.cliente) AS qtd_produtos
FROM cliente c, venda v
WHERE v.cliente = c.cpf
GROUP BY c.nome
ORDER BY qtd_produtos DESC

--Descrição do produto e Quantidade de vendas do produto com menor valor do catálogo de produtos
SELECT TOP 1 p.descricao, v.quantidade
FROM produto p, venda v
WHERE v.produto = p.codigo
GROUP BY p.descricao, v.quantidade, p.preco
ORDER BY p.preco ASC

--Nome do Fornecedor e Quantos produtos cada um fornece
SELECT f.nome, COUNT(p.fornecedor) AS qtd_produtos_que_fornece
FROM fornecedor f, produto p
WHERE p.fornecedor = f.ID
GROUP BY f.nome

--Considerando que hoje é 20/10/2019, consultar, sem repetições, o código da compra, nome do cliente,
--telefone do cliente (Mascarado XXXX-XXXX ou XXXXX-XXXX) e quantos dias da data da compra
SELECT DISTINCT v.codigo, c.nome, SUBSTRING(c.telefone, 1, 5) + '-' + SUBSTRING(c.telefone, 6, 4) AS telefone, DATEDIFF(DAY, v.data, '2019-10-20') AS qtd_dias_compra
FROM cliente c, venda v
WHERE c.cpf = v.cliente

--CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do cliente e quantidade comprada dos clientes que
--compraram mais de 2 produtos
SELECT SUBSTRING(c.cpf, 1, 3) + '.' + SUBSTRING(c.cpf, 4, 3) + '.' + SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 3) AS cpf, c.nome, COUNT(v.cliente) AS qtd_comprada
FROM cliente c, venda v
WHERE v.cliente = c.cpf
GROUP BY c.cpf, c.nome
HAVING COUNT(v.cliente) > 2

--Sem repetições, Código da venda, CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do Cliente e Soma
--do valor_total gasto(valor_total_gasto = preco do produto * quantidade de venda).Ordenar por nome do cliente
SELECT DISTINCT v.codigo,
				SUBSTRING(c.cpf, 1, 3) + '.' + SUBSTRING(c.cpf, 4, 3) + '.' + SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 3) AS cpf,
				c.nome, SUM(p.preco * v.quantidade) AS soma_total_gasto
FROM venda v, cliente c, produto p
WHERE c.cpf = v.cliente
	AND p.codigo = v.produto
GROUP BY c.nome, c.cpf, c.telefone, v.codigo
ORDER BY c.nome ASC

--Código da venda, data da venda em formato (DD/MM/AAAA) e uma coluna, chamada dia_semana, que escreva
--o dia da semana por extenso

--Exemplo: Caso dia da semana 1, escrever domingo. Caso 2, escrever segunda-feira, assim por diante,
--até caso dia 7, escrever sábado
SET LANGUAGE 'Brazilian'
SELECT v.codigo, CONVERT(CHAR(10), v.data, 103) AS data, DATENAME(WEEKDAY, v.data) AS dia_semana
FROM venda v