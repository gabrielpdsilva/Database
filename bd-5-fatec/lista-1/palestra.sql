CREATE DATABASE db_palestra
GO
USE db_palestra
GO

CREATE TABLE curso(
    codigo_curso INT NOT NULL,
    nome VARCHAR(70) NOT NULL,
    sigla VARCHAR(10) NOT NULL
    PRIMARY KEY(codigo_curso)
)
GO

INSERT INTO curso(codigo_curso, nome, sigla) VALUES
(1, 'Análise de Sistemas', 'ADS'),
(2, 'Administração', 'ADM'),
(3, 'Polímeros', 'POM')
GO

CREATE TABLE palestrante(
    codigo_palestrante INT NOT NULL IDENTITY(1,1),
    nome VARCHAR(250) NOT NULL,
    empresa VARCHAR(100) NOT NULL
    PRIMARY KEY(codigo_palestrante)
)
GO

INSERT INTO palestrante(nome, empresa) VALUES
    ('Rafael Marques', 'Empresa A'),
    ('Daniela Costa', 'Empresa B'),
    ('Antônio Silva', 'Empresa C')
GO

CREATE TABLE aluno(
    ra CHAR(7) NOT NULL,
    nome VARCHAR(250) NOT NULL,
    codigo_curso INT NOT NULL
    PRIMARY KEY(ra)
    FOREIGN KEY(codigo_curso) REFERENCES curso(codigo_curso)
)
GO

INSERT INTO aluno(ra, nome, codigo_curso) VALUES
    ('1111111', 'Cláudio', 1),
    ('2222222', 'Mário', 2),
    ('3333333', 'Maria', 3)
GO

CREATE TABLE palestra(
    codigo_palestra INT NOT NULL IDENTITY(1,1),
    titulo VARCHAR(MAX) NOT NULL,
    carga_horaria INT NOT NULL,
    data DATETIME NOT NULL,
    codigo_palestrante INT NOT NULL
    PRIMARY KEY(codigo_palestra)
    FOREIGN KEY(codigo_palestrante) REFERENCES palestrante(codigo_palestrante)
)
GO

INSERT INTO palestra(titulo, carga_horaria, data, codigo_palestrante) VALUES
    ('Primeira palestra', 3, '2020-10-10 00:00:00.000', 1),
    ('Segunda palestra', 3, '2020-10-10 00:00:00.000', 2),
    ('Terceira palestra', 2, '2020-10-10 00:00:00.000', 2)
GO

CREATE TABLE alunos_inscritos(
    ra CHAR(7) NOT NULL,
    codigo_palestra INT NOT NULL
    PRIMARY KEY(ra, codigo_palestra)
    FOREIGN KEY(ra) REFERENCES aluno(ra),
    FOREIGN KEY(codigo_palestra) REFERENCES palestra(codigo_palestra)
)
GO

INSERT INTO alunos_inscritos(ra, codigo_palestra) VALUES
    ('1111111', 1),
    ('1111111', 2),
    ('2222222', 3)
GO

CREATE TABLE nao_alunos(
    rg VARCHAR(9) NOT NULL,
    orgao_exp CHAR(5) NOT NULL,
    nome VARCHAR(250) NOT NULL
    PRIMARY KEY(rg, orgao_exp)
)
GO

INSERT INTO nao_alunos(rg, orgao_exp, nome) VALUES
('123456789', 'SP', 'Ana'),
('123456999', 'RJ', 'César')
GO

CREATE TABLE nao_alunos_inscritos(
    codigo_palestra INT NOT NULL,
    rg VARCHAR(9) NOT NULL,
    orgao_exp CHAR(5) NOT NULL
    PRIMARY KEY(codigo_palestra, rg, orgao_exp)
    FOREIGN KEY(codigo_palestra) REFERENCES palestra(codigo_palestra),
    FOREIGN KEY(rg, orgao_exp) REFERENCES nao_alunos(rg, orgao_exp)
)
GO

INSERT INTO nao_alunos_inscritos(codigo_palestra, rg, orgao_exp) VALUES
(1, '123456789', 'SP')
GO

SELECT * FROM curso
SELECT * FROM palestrante
SELECT * FROM aluno
SELECT * FROM alunos_inscritos
SELECT * FROM palestra
SELECT * FROM nao_alunos
SELECT * FROM nao_alunos_inscritos

-- VIEW
CREATE VIEW v_lista_presenca
AS
	SELECT
		al.ra AS num_documento,
		al.nome AS nome_pessoa,
		pa.titulo AS titulo_palestra,
		pe.nome AS nome_palestrante,
		pa.carga_horaria AS carga_horaria,
		pa.data AS data
	FROM aluno al, palestra pa, palestrante pe, alunos_inscritos ai
	WHERE al.ra = ai.ra
		AND pa.codigo_palestra = ai.codigo_palestra
		AND pa.codigo_palestrante = pe.codigo_palestrante

	UNION
	SELECT
		na.rg + na.orgao_exp AS num_documento,
		na.nome AS nome_pessoa,
		pa.titulo AS titulo_palestra,
		pe.nome AS nome_palestrante,
		pa.carga_horaria AS carga_horaria,
		pa.data AS data
	FROM nao_alunos_inscritos nai, nao_alunos na, palestra pa, palestrante pe
	WHERE na.rg = nai.rg AND na.orgao_exp = nai.orgao_exp
		AND pa.codigo_palestra = nai.codigo_palestra
		AND pa.codigo_palestrante = pe.codigo_palestrante

GO

SELECT * FROM v_lista_presenca