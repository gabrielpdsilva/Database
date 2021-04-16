CREATE DATABASE livraria
GO
USE livraria
GO

CREATE TABLE livro(
    codigo_livro INT NOT NULL,
    nome         VARCHAR(50),
    lingua       VARCHAR(10) DEFAULT('PT-BR'),
    ano          INT CHECK(ano >= 1990),
    PRIMARY KEY(codigo_livro)
)
GO

CREATE TABLE autor(
    codigo_autor INT NOT NULL,
    nome         VARCHAR(50) UNIQUE,
    nascimento   DATE,
    pais         VARCHAR(8), CHECK(pais = UPPER('Brasil') OR pais = UPPER('Alemanha')),
    biografia    VARCHAR(100),
    PRIMARY KEY(codigo_autor),
)
GO

CREATE TABLE livro_autor(
    livroCodigo_livro INT NOT NULL,
    autorCodigo_autor INT NOT NULL,
    PRIMARY KEY(livroCodigo_livro, autorCodigo_autor),
    FOREIGN KEY(livroCodigo_livro) REFERENCES livro(codigo_livro),
    FOREIGN KEY(autorCodigo_autor) REFERENCES autor(codigo_autor)
)
GO

CREATE TABLE edicoes(
    isbn INT NOT NULL,
    preco DECIMAL(7,2) CHECK(preco >= 0),
    ano INT CHECK(ano >= 1993),
    num_paginas INT CHECK(num_paginas > 0),
    qtd_estoque INT,
    livroCodigo_livro INT NOT NULL,
    PRIMARY KEY(isbn),
    FOREIGN KEY(livroCodigo_livro) REFERENCES livro(codigo_livro)
)
GO

CREATE TABLE editora(
    codigo_editora  INT NOT NULL,
    nome            VARCHAR(30) UNIQUE,
    logradouro      VARCHAR(50),
    numero          VARCHAR(4) CHECK(numero >= 0),
    cep             CHAR(7),
    telefone        CHAR(10),
    PRIMARY KEY(codigo_editora)
)
GO

CREATE TABLE edicoes_editora(
    edicoesISBN             INT NOT NULL,
    editoraCodigo_editora   INT NOT NULL,
    PRIMARY KEY(edicoesISBN, editoraCodigo_editora),
    FOREIGN KEY(edicoesISBN) REFERENCES edicoes(isbn),
    FOREIGN KEY(editoraCodigo_editora) REFERENCES editora(codigo_editora)
)

USE master
drop database livraria