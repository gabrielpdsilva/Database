CREATE DATABASE exec08
GO

USE exec08
GO

CREATE TABLE cliente(
    codigo INT NOT NULL,
    nome VARCHAR(40) NOT NULL,
    endereco VARCHAR(40) NOT NULL,
    telefone VARCHAR(10) NOT NULL,
    telefone_comercial VARCHAR(10),
    PRIMARY KEY(codigo)
)
GO

CREATE TABLE tipos_mercadoria(
    codigo INT NOT NULL,
    nome VARCHAR(40) NOT NULL,
    PRIMARY KEY(codigo)
)
GO

CREATE TABLE corredores(
    codigo INT NOT NULL,
	tipo INT,
    nome VARCHAR(40)
    PRIMARY KEY(codigo)
    FOREIGN KEY(tipo) REFERENCES tipos_mercadoria(codigo)
)
GO

CREATE TABLE mercadoria(
    codigo INT NOT NULL,
    nome VARCHAR(40) NOT NULL,
    corredor INT NOT NULL,
    tipo INT NOT NULL,
    valor DECIMAL(7,2) NOT NULL
    PRIMARY KEY(codigo)
    FOREIGN KEY(corredor) REFERENCES corredores(codigo),
    FOREIGN KEY(tipo) REFERENCES tipos_mercadoria(codigo)
)
GO

CREATE TABLE compra(
    nota_fiscal INT NOT NULL,
    cod_cliente INT NOT NULL,
    valor INT NOT NULL
    PRIMARY KEY(nota_fiscal)
    FOREIGN KEY(cod_cliente) REFERENCES cliente(codigo)
)
GO

-- Valor da Compra de Luis Paulo
SELECT com.valor
FROM compra com, cliente cli
WHERE com.cod_cliente = cli.codigo
	AND cli.nome LIKE 'Luis Paulo%'

-- Valor da Compra de Marcos Henrique
SELECT com.valor
FROM compra com, cliente cli
WHERE com.cod_cliente = cli.codigo
	AND cli.nome LIKE 'Marcos Henrique%'

-- Endereço e telefone do comprador de Nota Fiscal = 4567
SELECT cli.endereco, cli.telefone
FROM cliente cli, compra com
WHERE com.cod_cliente = cli.codigo
	AND com.nota_fiscal = 4567

-- Valor da mercadoria cadastrada do tipo " Pães"
SELECT me.valor
FROM mercadoria me, tipos_mercadoria tm
WHERE me.tipo = tm.codigo
AND tm.nome LIKE '%Pães%'

-- Nome do corredor onde está a Lasanha
SELECT cor.nome
FROM corredores cor, mercadoria me
WHERE me.corredor = cor.codigo
	AND me.nome LIKE '%Lasanha%'

-- Nome do corredor onde estão os clorados
SELECT cor.nome
FROM corredores cor, mercadoria me
WHERE me.corredor = cor.codigo
	AND me.nome LIKE '%Clorados%'