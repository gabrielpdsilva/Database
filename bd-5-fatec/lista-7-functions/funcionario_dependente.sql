CREATE DATABASE funcionario_dependente
GO

USE funcionario_dependente
GO

CREATE TABLE funcionario(
    codigo INT NOT NULL,
    nome VARCHAR(50),
    salario DECIMAL(7,2)
    PRIMARY KEY(codigo)
)
GO

CREATE TABLE dependente(
    codigo_funcionario INT NOT NULL,
    nome_dependente VARCHAR(50),
    salario_dependente DECIMAL(7,2)
    PRIMARY KEY(codigo_funcionario, nome_dependente)
    FOREIGN KEY(codigo_funcionario) REFERENCES funcionario(codigo)
)
GO

INSERT INTO funcionario(codigo, nome, salario) VALUES
(1, 'Renato', 1500.00),
(2, 'Alberto', 900.00),
(3, 'Ana', 900.00),
(4, 'Cesar', 1800.00),
(5, 'Maria', 1600.00)
GO

INSERT INTO dependente(codigo_funcionario, nome_dependente, salario_dependente) VALUES
(1, 'Bilbo', 100.00),
(2, 'Sam', 200.00),
(3, 'Galadriel', 600.00),
(1, 'Frodo', 350.00),
(5, 'Gandalf', 400.00),
(5, 'Saruman', 300.00)
GO
-- Criar:
-- a)Uma Multi Statement Table Function que Retorne uma tabela:
-- (Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)
CREATE FUNCTION fn_lista_funcionario_e_dependentes(@nome_funcionario VARCHAR(50))
RETURNS @table TABLE (
	codigo INT,
	nome_funcionario VARCHAR(50),
	nome_dependente VARCHAR(50),
    salario_funcionario DECIMAL(7,2),
    salario_dependente DECIMAL(7,2)
)
AS
BEGIN
    INSERT INTO @table (codigo, nome_funcionario, nome_dependente, salario_funcionario, salario_dependente)
		SELECT
            f.codigo AS codigo,
            f.nome AS nome_funcionario,
            d.nome_dependente AS nome_dependente,
            f.salario AS salario_funcionario,
            d.salario_dependente AS salario_dependente
        FROM funcionario f, dependente d
		WHERE f.codigo = d.codigo_funcionario
			AND f.nome LIKE '%' + @nome_funcionario + '%'
	RETURN
END
GO

SELECT * FROM fn_lista_funcionario_e_dependentes('renat')

-- b)Uma Scalar Function que Retorne a soma dos Salários dos dependentes, mais a do funcionário.

CREATE FUNCTION fn_somatoria_salario_depend_func(@nome_funcionario VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @somatoria DECIMAL(10,0)
	SET @somatoria = (
		SELECT
			f.salario + SUM(d.salario_dependente)
		FROM funcionario f, dependente d
		WHERE f.codigo = d.codigo_funcionario
			AND f.nome LIKE '%' + @nome_funcionario + '%'
		GROUP BY f.salario
	)
	RETURN @somatoria
END
GO

SELECT dbo.fn_somatoria_salario_depend_func('renat') AS somatoria_salario