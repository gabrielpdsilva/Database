CREATE DATABASE exec10
GO

USE exec10
GO

CREATE TABLE medicamentos(
    codigo INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    apresentacao VARCHAR(30) NOT NULL,
    unidade_de_cadastro VARCHAR(30) NOT NULL,
    preco_proposto DECIMAL(8,4) NOT NULL
    PRIMARY KEY(codigo)
)
GO

CREATE TABLE cliente(
    cpf VARCHAR(15) NOT NULL,
    nome VARCHAR(30) NOT NULL,
    rua VARCHAR(30) NOT NULL,
    num INT NOT NULL,
    bairro VARCHAR(30) NOT NULL,
    telefone VARCHAR(10) NOT NULL
    PRIMARY KEY(cpf)
)
GO

CREATE TABLE venda(
    nota_fiscal INT NOT NULL,
    cpf_cliente VARCHAR(15) NOT NULL,
    codigo_medicamento INT NOT NULL,
    quantidade INT NOT NULL,
    valor_total DECIMAL(7,2) NOT NULL,
    data DATETIME NOT NULL
    PRIMARY KEY(nota_fiscal, cpf_cliente, codigo_medicamento)
    FOREIGN KEY(cpf_cliente) REFERENCES cliente(cpf),
    FOREIGN KEY(codigo_medicamento) REFERENCES medicamentos(codigo)
)
GO

-- Nome, apresentação, unidade e valor unitário dos remédios que ainda não
-- foram vendidos. Caso a unidade de cadastro seja comprimido, mostrar Comp.
SELECT m.nome, m.apresentacao,
	CASE
		WHEN m.unidade_de_cadastro LIKE '%Comprimido%' THEN
			SUBSTRING(m.unidade_de_cadastro, 1, 5) + '.'
		ELSE
			m.unidade_de_cadastro
		END AS unid_de_cadastro,
	m.preco_proposto
FROM medicamentos m
LEFT OUTER JOIN venda v
ON m.codigo = v.codigo_medicamento
	WHERE v.codigo_medicamento IS NULL

-- Nome dos clientes que compraram Amiodarona
SELECT cli.nome
FROM cliente cli, venda ven, medicamentos med
WHERE cli.cpf = ven.cpf_cliente
	AND med.codigo = ven.codigo_medicamento
	AND med.nome LIKE '%Amiodarona%'
	
-- CPF do cliente, endereço concatenado, nome do medicamento (como nome de
-- remédio),  apresentação do remédio, unidade, preço proposto, quantidade
-- vendida e valor total dos remédios vendidos a Maria Zélia
SELECT cli.cpf,
	'Rua ' + cli.rua + '; numº ' + CONVERT(VARCHAR(4), cli.num) + ', ' + cli.bairro AS endereco,
	men.nome AS nome_remedio, men.apresentacao, men.unidade_de_cadastro, men.preco_proposto, ven.quantidade, ven.valor_total
FROM cliente cli, venda ven, medicamentos men
WHERE cli.cpf = ven.cpf_cliente
	AND men.codigo = ven.codigo_medicamento
	AND cli.nome LIKE '%Maria Zélia%'

-- Data de compra, convertida, de Carlos Campos
SELECT CONVERT(CHAR(10), ven.data, 103) AS data
FROM cliente cli, venda ven
WHERE cli.cpf = ven.cpf_cliente
	AND cli.nome LIKE '%Carlos Campos%'

-- Alterar o nome da  Amitriptilina(Cloridrato) para Cloridrato de Amitriptilina
SELECT *
FROM medicamentos

UPDATE medicamentos
SET nome = 'Cloridrato de Amitriptilina'
WHERE medicamentos.nome LIKE '%Amitriptilina(Cloridrato)%'

SELECT *
FROM medicamentos