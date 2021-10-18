CREATE DATABASE cursores
GO

USE cursores 
GO

CREATE TABLE curso(
	codigo INT NOT NULL,
	nome VARCHAR(50) NOT NULL,
	duracao INT NOT NULL
	PRIMARY KEY(codigo)
)
GO

CREATE TABLE disciplina(
	codigo INT NOT NULL,
	nome VARCHAR(50) NOT NULL,
	carga_horaria INT NOT NULL
	PRIMARY KEY(codigo)
)
GO

CREATE TABLE disciplina_curso(
	codigo_disciplina INT NOT NULL,
	codigo_curso INT NOT NULL
	PRIMARY KEY(codigo_disciplina, codigo_curso)
	FOREIGN KEY(codigo_curso) REFERENCES curso(codigo),
	FOREIGN KEY(codigo_disciplina) REFERENCES disciplina(codigo)
)
GO

SELECT * FROM curso

INSERT INTO disciplina(codigo, nome, carga_horaria) VALUES
(1, 'Algoritmos', 80),
(2, 'Administração', 80),
(3, 'Laboratório de Hardware', 40),
(4, 'Pesquisa Operacional', 80),
(5, 'Física I', 80),
(6, 'Físico Química', 80),
(7, 'Comércio Exterior', 80),
(8, 'Fundamentos de Marketing', 80),
(9, 'Informática', 40),
(10, 'Sistemas de Informação', 80)

SELECT * FROM disciplina

INSERT INTO disciplina_curso(codigo_disciplina, codigo_curso) VALUES
(1, 0),
(2, 0),
(2, 1),
(2, 3),
(2, 4),
(3, 0),
(4, 1),
(5, 2),
(6, 2),
(7, 1),
(7, 3),
(8, 1),
(8, 4),
(9, 1),
(9, 3),
(10, 0),
(10, 4)

SELECT * FROM disciplina_curso

-- Criar uma UDF (Function) cuja entrada é o código do curso e, com um cursor,
-- monte uma tabela de saída com as informações do curso que é parâmetro de entrada.

-- (Código_Disciplina | Nome_Disciplina | Carga_Horaria_Disciplina | Nome_Curso)

CREATE FUNCTION fn_info_curso_cursores(@codigo_curso_parametro INT)
RETURNS @tabela TABLE(
	codigo_disciplina			INT,
	nome_disciplina				VARCHAR(50),
	carga_horaria_disciplina	INT,
	nome_curso					VARCHAR(50)
)
AS
BEGIN
	DECLARE @codigo_disciplina	INT,
			@codigo_curso		INT,
			@nome_disciplina VARCHAR(50),
			@carga_horaria_disciplina VARCHAR(50),
			@nome_curso VARCHAR(50)

	DECLARE cur CURSOR FOR
		SELECT codigo_disciplina, codigo_curso FROM disciplina_curso
 
	OPEN cur
	FETCH NEXT FROM cur INTO @codigo_disciplina, @codigo_curso
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@codigo_curso = @codigo_curso_parametro)
		BEGIN
			INSERT INTO @tabela(codigo_disciplina, nome_disciplina, carga_horaria_disciplina, nome_curso)
			SELECT
				d.codigo,
				d.nome,
				d.carga_horaria,
				c.nome
			FROM curso c, disciplina d
			WHERE d.codigo = @codigo_disciplina
				AND c.codigo = @codigo_curso_parametro
		END
 
		FETCH NEXT FROM cur INTO @codigo_disciplina, @codigo_curso
	END

	CLOSE cur
	DEALLOCATE cur
 
	RETURN
END
 
SELECT * FROM fn_info_curso_cursores(3)
