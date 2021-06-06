CREATE DATABASE exec12
GO

USE exec12
GO


CREATE TABLE planos(
    codPlano INT NOT NULL,
    nomePlano VARCHAR(40) NOT NULL,
    valorPlano INT NOT NULL
    PRIMARY KEY(codPlano)
)
GO

CREATE TABLE servicos(
    codServico INT NOT NULL,
    nomeServico VARCHAR(40) NOT NULL,
    valorServico INT NOT NULL
    PRIMARY KEY(codServico)
)
GO

CREATE TABLE cliente(
    codCliente INT NOT NULL,
    nomeCliente VARCHAR(40) NOT NULL,
    dataInicio DATE NOT NULL,
    PRIMARY KEY(codCliente)
)
GO

CREATE TABLE contratos(
    codCliente INT NOT NULL,
    codPlano INT NOT NULL,
    codServico INT NOT NULL,
    status CHAR(1) NOT NULL,
    data DATE NOT NULL
    PRIMARY KEY(codCliente, codPlano, codServico, data)
    FOREIGN KEY(codCliente) REFERENCES cliente(codCliente),
    FOREIGN KEY(codPlano) REFERENCES planos(codPlano),
    FOREIGN KEY(codServico) REFERENCES servicos(codServico)
)
GO

-- Obs.:
-- Status de contrato A(Ativo), D(Desativado), E(Espera)
-- Um plano só é válido se existe pelo menos um serviço associado a ele

-- Exercicios:
-- Consultar o nome do cliente, o nome do plano, a quantidade de estados
-- de contrato (sem repetições) por contrato, dos planos cancelados,
-- ordenados pelo nome do cliente
SELECT DISTINCT cli.nomeCliente, plano.nomePlano, COUNT(con.status) AS qtd_plano
FROM cliente cli, planos plano, contratos con, servicos serv
WHERE con.codCliente = cli.codCliente
	AND con.codPlano = plano.codPlano
	AND con.codServico = serv.codServico
	AND con.status = 'D'
GROUP BY con.status, cli.nomeCliente, plano.nomePlano
ORDER BY cli.nomeCliente

-- Consultar o nome do cliente, o nome do plano, a quantidade de estados
-- de contrato (sem repetições) por contrato, dos planos não cancelados,
-- ordenados pelo nome do cliente
SELECT DISTINCT cli.nomeCliente, plano.nomePlano, COUNT(con.status) AS qtd_plano
FROM cliente cli, planos plano, contratos con, servicos serv
WHERE con.codCliente = cli.codCliente
	AND con.codPlano = plano.codPlano
	AND con.codServico = serv.codServico
	AND con.status <> 'D'
GROUP BY con.status, cli.nomeCliente, plano.nomePlano
ORDER BY cli.nomeCliente

-- Consultar o nome do cliente, o nome do plano, e o valor da conta de cada
-- contrato que está ou esteve ativo, sob as seguintes condições:
	-- A conta é o valor do plano, somado à soma dos valores de todos os serviços
	-- Caso a conta tenha valor superior a R$400.00, deverá ser incluído um desconto de 8%
	-- Caso a conta tenha valor entre R$300,00 a R$400.00, deverá ser incluído um desconto de 5%
	-- Caso a conta tenha valor entre R$200,00 a R$300.00, deverá ser incluído um desconto de 3%
	-- Contas com valor inferiores a R$200,00 não tem desconto

-- SELECT correto abaixo, creio eu. Mas não tá funcionando.
-- SELECT serv.valorServico, serv.valorServico - (serv.valorServico * 0.08)
-- FROM servicos serv

SELECT cli.nomeCliente, plano.nomePlano, SUM(plano.valorPlano + serv.valorServico) AS valor_original,
	CASE
		WHEN 
			plano.valorPlano + SUM(serv.valorServico) > 400 THEN
			 SUM((plano.valorPlano + serv.valorServico * 0.92))
			ELSE
				CASE
					WHEN plano.valorPlano + SUM(serv.valorServico) > 300 AND plano.valorPlano + SUM(serv.valorServico) <= 400 THEN
						SUM((plano.valorPlano + serv.valorServico * 0.95))
					ELSE
						CASE
							WHEN plano.valorPlano + SUM(serv.valorServico) > 200 AND plano.valorPlano + SUM(serv.valorServico) <= 300 THEN
								SUM((plano.valorPlano + serv.valorServico * 0.97))
							ELSE
								SUM(plano.valorPlano + serv.valorServico)
							END
					END
			END AS desconto_aplicado
FROM cliente cli, planos plano, servicos serv, contratos cont
WHERE cli.codCliente = cont.codCliente
	AND serv.codServico = cont.codServico
	AND plano.codPlano = cont.codPlano
	AND (cont.status = 'A' OR cont.status = 'E')
GROUP BY cli.nomeCliente, plano.nomePlano, plano.valorPlano

-- Consultar o nome do cliente, o nome do serviço, e a duração, em meses
-- (até a data de hoje) do serviço, dos cliente que nunca cancelaram nenhum plano
SELECT cli.nomeCliente, serv.nomeServico, DATEDIFF(MONTH, con.data, GETDATE()) AS meses_duracao_servico, con.status
FROM cliente cli, contratos con, servicos serv
WHERE con.codCliente = cli.codCliente
	AND con.codServico = serv.codServico
	AND con.codCliente NOT IN (
		SELECT con.codCliente
		FROM servicos
		WHERE status = 'D'
	)