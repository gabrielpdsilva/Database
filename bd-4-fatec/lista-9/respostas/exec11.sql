CREATE DATABASE exec11
GO

USE exec11
GO

CREATE TABLE planos_de_saude(
    codigo INT NOT NULL,
    nome VARCHAR(30) NOT NULL,
    telefone VARCHAR(10) NOT NULL
    PRIMARY KEY(codigo)
)
GO

CREATE TABLE paciente(
    cpf VARCHAR(15) NOT NULL,
    nome VARCHAR(30) NOT NULL,
    rua VARCHAR(30) NOT NULL,
    num INT NOT NULL,
    bairro VARCHAR(30) NOT NULL,
    telefone VARCHAR(10) NOT NULL,
    plano_de_saude INT NOT NULL
    PRIMARY KEY(cpf)
    FOREIGN KEY(plano_de_saude) REFERENCES planos_de_saude(codigo)
)
GO

CREATE TABLE medico(
    codigo INT NOT NULL,
    nome VARCHAR(30) NOT NULL,
    especialidade VARCHAR(30) NOT NULL,
    plano_de_saude INT NOT NULL
    PRIMARY KEY(codigo)
    FOREIGN KEY(plano_de_saude) REFERENCES planos_de_saude(codigo)
)
GO

CREATE TABLE consultas(
    medico INT NOT NULL,
    paciente VARCHAR(15) NOT NULL,
    dataHora DATETIME NOT NULL,
    diagnostico VARCHAR(30) NOT NULL
    PRIMARY KEY(medico, paciente, dataHora)
    FOREIGN KEY(medico) REFERENCES medico(codigo),
    FOREIGN KEY(paciente) REFERENCES paciente(cpf)
)
GO

-- Nome e especialidade dos médicos da Amil
SELECT med.nome, med.especialidade
FROM medico med, planos_de_saude plano
WHERE med.plano_de_saude = plano.codigo
	AND plano.nome LIKE '%Amil%'

-- Nome, Endereço concatenado, Telefone e Nome do Plano
-- de Saúde de todos os pacientes
SELECT pac.nome,
	pac.rua + ', ' + CONVERT(VARCHAR(4), pac.num) + ' - ' + pac.bairro AS endereco,
	pac.telefone, plano.nome AS plano
FROM paciente pac, planos_de_saude plano
WHERE pac.plano_de_saude = plano.codigo

-- Telefone do Plano de Saúde de Ana Júlia
SELECT plano.telefone
FROM paciente pac, planos_de_saude plano
WHERE pac.plano_de_saude = plano.codigo
	AND pac.nome LIKE '%Ana Julia%' -- se colocar "ú" o BD não vai encontrar.

-- Plano de Saúde que não tem pacientes cadastrados
SELECT plano.nome
FROM planos_de_saude plano
LEFT OUTER JOIN paciente pac
ON plano.codigo = pac.plano_de_saude
WHERE pac.plano_de_saude IS NULL

-- Planos de Saúde que não tem médicos cadastrados
SELECT plano.nome
FROM planos_de_saude plano
LEFT OUTER JOIN medico med
ON plano.codigo = med.plano_de_saude
WHERE med.plano_de_saude IS NULL

-- Data da consulta, Hora da consulta, nome do médico, nome
-- do paciente e diagnóstico de todas as consultas
SELECT con.dataHora, med.nome AS medico, pac.nome AS paciente, con.diagnostico
FROM consultas con, medico med, paciente pac
WHERE con.medico = med.codigo
	AND con.paciente = pac.cpf

-- Nome do médico, data e hora de consulta e diagnóstico
-- de José Lima
SELECT med.nome AS medico, con.dataHora, con.diagnostico
FROM consultas con, medico med, paciente pac
WHERE con.medico = med.codigo
	AND con.paciente = pac.cpf
	AND pac.nome LIKE '%José Lima%'

-- Alterar o nome de João Carlos para João Carlos da Silva
SELECT *
FROM paciente

UPDATE paciente
SET nome = 'João Carlos da Silva'
WHERE paciente.nome = 'João Carlos'

SELECT *
FROM paciente

-- Deletar o plano de Saúde Unimed
SELECT *
FROM planos_de_saude

DELETE planos_de_saude
WHERE planos_de_saude.nome = 'Unimed'

SELECT *
FROM planos_de_saude

-- Renomear a coluna Rua da tabela Paciente para Logradouro
SELECT *
FROM paciente

EXEC sp_rename 'paciente.rua','logradouro','column'

SELECT *
FROM paciente

-- Inserir uma coluna, na tabela Paciente, de nome data_nasc
-- e inserir os valores (1990-04-18,1981-03-25,2004-09-04 e 1986-06-18)
-- respectivamente
ALTER TABLE paciente
ADD data_nasc DATE NULL
GO

UPDATE paciente
SET data_nasc = '1990-04-18'
WHERE paciente.cpf = '23659874100'

UPDATE paciente
SET data_nasc = '1981-03-25'
WHERE paciente.cpf = '63259874100'

UPDATE paciente
SET data_nasc = '2004-09-04'
WHERE paciente.cpf = '85987458920'

UPDATE paciente
SET data_nasc = '1986-06-18'
WHERE paciente.cpf = '87452136900'