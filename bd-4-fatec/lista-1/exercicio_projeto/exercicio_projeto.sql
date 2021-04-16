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

USE master
GO

DROP DATABASE projeto
GO