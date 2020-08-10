--Lista de atividades do curso:
--https://www.youtube.com/watch?v=rX2I7OjLqWE

--==========================================================================================

--AULA 1:
--Desafio 1
--A equipe de marketing precisa fazer uma pesquisa sobre nomes mais comuns de seus clientes
--e precisa do nome e sobrenome de todos os clientes que estão cadastrados no sistema.

SELECT firstName, lastName
FROM Person.Person

--==========================================================================================
--AULA 2:
--DISTINCT -> usado pra não retornar valores repetidos.

--Desafio 2
--Quantos sobrenomes únicos nós temos em nossa tabela Person.Person?

SELECT DISTINCT lastName
FROM Person.Person

--==========================================================================================

--AULA 3:

--WHERE, modelo:
--SELECT coluna1, coluna2...
--FROM tabela
--WHERE condicao

--Condicoes:
--	= igual
--	> maior que
--	< menor que
--	>= maior ou igual
--	<= menor ou igual
--	<> diferente de
--	AND operador lógico E
--	OR operador lógico OU

--Desafio 1
--A equipe de produção de produtos precisa do nome de todas as peças que pesam
--mais que 500kg mas não mais que 700kg para inspeção

SELECT name
FROM Production.Product
WHERE weight > 500 AND weight <= 700

--Desafio 2
--Foi pedido pelo marketing uma relação de todos os empregados (employees) que são
-- casados (single = solteiro, married = casado) e são assalariados (salaried)

SELECT *
FROM HumanResources.Employee
WHERE SalariedFlag = 1 AND MaritalStatus = 'M'

--Desafio 3
--Um usuário chamado Peter Krebs está devendo um pagamento, consiga o e-mail dele
--para que possamos enviar uma cobrança!
--(Usar tabela Person.Person e depois tabela Person.EmailAddress)

SELECT *
FROM Person.Person
WHERE firstName = 'Peter' AND lastName = 'Krebs'

SELECT EmailAddress
FROM Person.EmailAddress
WHERE BusinessEntityID = 26

--==========================================================================================

--AULA 4:
--COUNT -> retorna o número de linhas que bate com determinada condição
--SELECT COUNT (*) FROM... -> contagem de todas as colunas da tabela
--SELECT COUNT (DISTINCT coluna) FROM... -> não irá incluir valores repetidos (acho que nulos também não)

SELECT COUNT (DISTINCT firstName)
FROM Person.Person

--Desafio 1
--Saber quantos produtos estão cadastrados na tabela de produtos

SELECT COUNT (*)
FROM Production.Product

--Desafio 2
--Saber quantos tamanhos de produtos estão cadastrados na tabela

SELECT COUNT (size)
FROM Production.Product

--Desafio 3
--Saber quantos tamanhos diferentes de produtos estão cadastrados na tabela

SELECT COUNT (DISTINCT size)
FROM Production.Product

--==========================================================================================

--AULA 5:
--TOP -> usado para limitar a quantidade de dados retornados do SELECT

--Pegando os 10 primeiros nomes de produtos:
SELECT TOP 10 name
FROM Production.Product

--==========================================================================================

--AULA 5:
--ORDER BY -> usado para indicar se queremos ver os dados de forma crescente ou decrescente

--SELECT coluna1, coluna2
--FROM tabela
--ORDER BY coluna1 asc/desc

SELECT TOP 20 LastName
FROM Person.Person
ORDER BY LastName asc

--Desafio 1
--Obter o ID de produto dos 10 produtos mais caros cadastrados no sistema,
--listando do mais caro para o mais barato.

SELECT TOP 10 productID, name, listPrice
FROM Production.Product
ORDER BY listPrice desc

--Desafio 2
--Obter o nome e o número do produto dos produtos que tem ProductID entre 1~4
SELECT TOP 4
Name, ProductNumber
FROM Production.Product
ORDER BY ProductID asc
--==========================================================================================

--AULA 8: (sim, pulou pra 8)
--BETWEEN -> usado pra encontrar um valor entre valor mínimo e valor máximo.
--valor BETWEEN minimo AND maximo
--Mesma coisa que (valor >= minimo AND valor <= maximo)

--Selecionando produtos onde o preço NÃO está entre 1000 e 1500:
SELECT *
FROM Production.Product
WHERE ListPrice NOT BETWEEN 1000 and 1500

--Selecionando empregados contratados entre 2009 e 2010, de forma ascendente:
SELECT *
FROM HumanResources.Employee
WHERE HireDate BETWEEN '2009/01/01' AND '2010/01/01'
ORDER BY HireDate asc

--==========================================================================================

--AULA 9:
--IN -> usado com WHERE pra ver se um dado corresponde com algum parâmetro passado
--na lista de valores.
--valor IN (valor1, valor2)
SELECT *
FROM Person.Person
WHERE BusinessEntityID IN (2, 7, 13)

--Seria o equivalente a:
SELECT *
FROM Person.Person
WHERE BusinessEntityID = 2
OR BusinessEntityID = 7
OR BusinessEntityID = 13

--==========================================================================================

--AULA 10:
--LIKE -> Vamos supor que queremos encontrar pessoas que começam com 'Dan...',
--podemos fazer:

SELECT *
FROM Person.Person
WHERE firstName LIKE 'dan%'

--Podemos usar também: '%nome%', ou '%nome'

SELECT *
FROM Person.Person
WHERE firstName like '%ro_'

--Underline é usado quando tem apenas um único caractere faltando, no caso
--acima poderia retornar Troy, Cameron, Aaron, Roy...

--==========================================================================================

--AULA 11:

--Desafio 1
--Quantos produtos temos cadastrados no sistema que custam mais que 1500 dólares?

SELECT COUNT (ListPrice)
FROM Production.Product
WHERE ListPrice > 1500

--Desafio 2
--Quantas pessoas temos cujo sobrenome se inicia com P?

SELECT COUNT (lastName)
FROM Person.Person
WHERE LastName LIKE 'p%'

--Desafio 3
--Em quantas cidades únicas estão cadastrados nossos clientes?

SELECT COUNT(DISTINCT (City))
FROM Person.Address

--Desafio 4
--Quais são as cidades únicas que temos cadastrados no sistema?

SELECT DISTINCT City
FROM Person.Address

--Desafio 5
--Quantos produtos vermelhos tem preço entre 500 a 1000 dólares?

SELECT COUNT(*)
FROM Production.Product
WHERE Color = 'Red'
AND
ListPrice BETWEEN 500 AND 1000

--Desafio 6
--Quantos produtos cadastrados tem a palavra 'road' no nome deles?

SELECT COUNT (*)
FROM Production.Product
WHERE Name LIKE '%road%'

--==========================================================================================

--AULA 12:

--MIN, MAX, SUM, AVG
--Funções de agregação; agregam ou combinam dados de uma tabela num
--só resultado.

--Exemplo: SUM vai somar todas as colunas e retornará um único resultado.

--No caso do código abaixo, irá somar todas os resultados da coluna LineTotal

SELECT TOP 10 SUM(LineTotal) AS "somatoria"
FROM Sales.SalesOrderDetail

--AS "somatoria" significa que está dando um apelido pra coluna que será apresentada.

SELECT *
FROM Sales.SalesOrderDetail

--retornando menor valor da coluna LineTotal
SELECT MIN(LineTotal)
FROM Sales.SalesOrderDetail

--retornando maior valor da coluna LineTotal
SELECT MAX(LineTotal)
FROM Sales.SalesOrderDetail

--AVG(average) = média
--retornando a média de valores da coluna LineTotal
SELECT AVG(LineTotal)
FROM Sales.SalesOrderDetail

--==========================================================================================

--AULA 13:
--GROUP BY -> divide o resultado da pesquisa em grupos.
--Pra cada grupo você pode aplicar uma função de agregação, exemplo:
-- 1. Calcular a soma de itens
-- 2. Contar o número de itens naquele grupo

--Sintaxe:
--SELECT coluna1, funcaoAgregacao(coluna2)
--FROM nomeTabela
--GROUP BY coluna1

--Exemplo:
SELECT SpecialOfferID, SUM(UnitPrice) AS "Soma"
FROM Sales.SalesOrderDetail
GROUP BY SpecialOfferID

--
--SpecialOfferID | Soma
--		9		 | 14328,717 <- somatória de tudo que contém SpecialOfferID = 9
--		..		 | ..

--Outro exemplo:
--Quero saber quantos de cada produto foram vendidos até hoje

SELECT ProductID, COUNT(ProductID) AS "Quantidade vendida"
FROM Sales.SalesOrderDetail
GROUP BY ProductID

--Basicamente o código acima está contando quantas vezes cada ProductID
--está aparecendo no banco de dados.

--ProductID | Quantidade vendida
--	707		| 3083 <- 3083 dos produtos com ID 707 foram vendidos
--	..		| ..

--Outro exemplo:
--Quero saber quantos nomes de cada nome estão cadastrados no banco de dados

SELECT firstName, COUNT(firstName) AS "Total de nomes"
FROM Person.Person
GROUP BY firstName

--Outro exemplo:
--Saber a média de preço pros produtos de prata(silver) da tabela Production.Product

SELECT *
FROM Production.Product

SELECT Color, AVG(ListPrice) AS "Média de preço"
FROM Production.Product
WHERE Color = 'Silver'
GROUP BY Color

--Desafio 1
--Saber quantas pessoas tem o mesmo MiddleName, agrupadas por MiddleName
SELECT middleName, COUNT(MiddleName) AS "Quantidade"
FROM Person.Person
GROUP BY middleName

--Desafio 2
--Saber em média a quantidade que cada produto é vendido na loja

SELECT *
FROM Sales.SalesOrderDetail

SELECT ProductID, AVG(OrderQty) AS "Quantidade média"
FROM Sales.SalesOrderDetail
GROUP BY ProductID

--Desafio 3
--Saber quais foram as 10 vendas que no total tiveram os maiores
--valores de venda (lineTotal) por produto do maior valor para o menor

SELECT TOP 10 ProductID, SUM(lineTotal) AS "Valor"
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY SUM(lineTotal) DESC

--Desafio 4
--Saber quantos produtos e qual quantidade média de produtos
--temos cadastrados na ordem de serviço (workOrder), agrupados
--por productID

SELECT *
FROM Production.WorkOrder

SELECT ProductID, COUNT(ProductID) AS "Contagem",
AVG(OrderQty) AS "Quantidade média"
FROM Production.WorkOrder
GROUP BY ProductID