CREATE DATABASE projeto
GO
USE projeto
GO

CREATE TABLE users(
    id              INT NOT NULL IDENTITY(1,1),
    name            VARCHAR(10),
    username        VARCHAR(45) UNIQUE,
    email           VARCHAR(45),
    password        VARCHAR(45) DEFAULT('123mudar')
    PRIMARY KEY(id)
)
GO

CREATE TABLE projects(
    id              INT NOT NULL IDENTITY(10001,1),
    name            VARCHAR(45),
    description     VARCHAR(45),
    data            DATE CHECK(data > '2014-09-01')    
    PRIMARY KEY(id)
)
GO

CREATE TABLE users_has_projects(
    users_id      INT NOT NULL,
    projects_id   INT NOT NULL,
    PRIMARY KEY(users_id, projects_id),
    FOREIGN KEY(users_id) REFERENCES users(id),
    FOREIGN KEY(projects_id) REFERENCES projects(id)
)
GO

ALTER TABLE users
ALTER COLUMN password VARCHAR(8)
GO

INSERT INTO users(name, username, password, email) VALUES
('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),
('Clara', 'Ti_clara', '123mudar', 'clara@empresa.com'),
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')
GO

SELECT * FROM users

INSERT INTO projects(name, description, data) VALUES
('Re-folha', 'Refatoração das folhas', '05/09/2014'),
('Manutenção PCs', 'Manutenção PCs', '06/09/2014'),
('Auditoria', NULL, '07/09/2014')
GO

SELECT * FROM projects

INSERT INTO users_has_projects(users_id, projects_id) VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)
GO

SELECT * FROM users_has_projects
GO

-- 04/05/2021

-- 1) Fazer uma consulta que retorne id, nome, email, username e
-- caso a senha seja diferente de 123mudar, mostrar ********
-- (8 asteriscos), caso contrário, mostrar a própria senha
SELECT id, name, email, username,
	CASE
		WHEN password <> '123mudar' THEN
			'********'
		ELSE
			'123mudar'
		END AS formatted_password
FROM users
GO

-- 2) Considerando que o projeto 10001 durou 15 dias, fazer uma
-- consulta que mostre o nome do projeto, descrição, data, data_final
-- do projeto realizado por usuário de e-mail aparecido@empresa.com
SELECT name, description, data AS data_inicial,
	DATEADD(DAY, 15, data) AS data_final
FROM projects
WHERE id IN
(
	SELECT projects_id
	FROM users_has_projects
	WHERE users_id IN
	(
		SELECT id
		FROM users
		WHERE email = 'aparecido@empresa.com'
	)
)
GO

-- 3) Fazer uma consulta que retorne o nome e o email dos usuários que
-- estão envolvidos no projeto de nome Auditoria
SELECT name, email
FROM users
WHERE id IN
(
	SELECT users_id
	FROM users_has_projects
	WHERE projects_id IN
	(
		SELECT id
		FROM projects
		WHERE name = 'Auditoria'
	)
)
GO

-- 4) Considerando que o custo diário do projeto, cujo nome tem o termo
-- Manutenção, é de 79.85 e ele deve finalizar 16/09/2014, consultar, nome,
-- descrição, data, data_final e custo_total do projeto
SELECT name, description, CONVERT(CHAR(10), data, 103) AS data_inicial,
	'16/09/2014' AS data_final,
	79.85 * DATEDIFF(DAY, data, '2014-09-16') AS custo_total
FROM projects
WHERE name LIKE '%Manutenção%'
GO

-- 11/05/2021
INSERT INTO users(name, username, password, email) VALUES
('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')
GO

INSERT INTO projects(name, description, data) VALUES
('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PC''s', '12/09/2014')
GO

-- 1) Id, Name e Email de Users, Id, Name, Description e Data de
-- Projects, dos usuários que participaram do projeto Name Re-folha
SELECT u.id AS person_id, u.name, u.email, p.id AS project_id, p.name AS project_name, p.description, p.data AS date
FROM users u, projects p, users_has_projects up
WHERE u.id = up.users_id
	AND p.id = up.projects_id
	AND p.name LIKE 'Re-folha'
GO

-- 2) Name dos Projects que não tem Users
SELECT p.name
FROM projects p LEFT JOIN users_has_projects up
ON p.id = up.projects_id
WHERE up.users_id IS NULL
GO

-- 3) Name dos Users que não tem Projects
SELECT u.name
FROM users u LEFT JOIN users_has_projects up
ON u.id = up.users_id
WHERE up.users_id IS NULL
GO

--18/05/2021

-- 1) O projeto de Manutenção atrasou, mudar a data para 12/09/2014
UPDATE projects
SET projects.data = '2014-09-12'
WHERE projects.name LIKE 'Manutenção%'
GO

-- 2) O username de aparecido (usar o nome como condição de mudança)
-- está feio, mudar para Rh_cido
UPDATE users 
SET users.username = 'Rh_cido'
WHERE users.name LIKE 'Aparecido'
GO

-- 3) Mudar o password do username Rh_maria (usar o username como condição
-- de mudança) para 888@*, mas a condição deve verificar se o password dela ainda é 123mudar
UPDATE users
SET users.password =
	CASE
		WHEN password = '123mudar' THEN
			'888@*'
	END
WHERE users.username LIKE 'Rh_maria'
GO

-- 4) O user de id 2 não participa mais do projeto 10002, removê-lo da associativa
DELETE FROM users_has_projects
WHERE users_id = 2 AND projects_id = 10002
GO

-- Considerando já inseridas as linhas:
-- User (6; Joao; Ti_joao; 123mudar; joao@empresa.com)
-- Project (10004; Atualização de Sistemas; Modificação de Sistemas Operacionais nos PC's; 12/09/2014)

-- 5) Consultar: Quantos projetos não tem usuários associados a ele.
-- A coluna deve chamar qty_projects_no_users
SELECT COUNT(up.projects_id) AS qty_projects_no_users
FROM users_has_projects up
WHERE up.users_id = 6
GO

-- 6) Consultar: Id do projeto, nome do projeto, qty_users_project
-- (quantidade de usuários por projeto) em ordem alfabética crescente
-- pelo nome do projeto
SELECT p.id, p.name, COUNT(up.users_id) AS qty_users_project
FROM projects p, users_has_projects up
WHERE p.id = up.projects_id
GROUP BY p.id, p.name
ORDER BY p.name
GO

USE master
GO

DROP DATABASE projeto
GO
