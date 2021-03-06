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

--==========================================================================================

--AULA 14:
--HAVING -> usado junto com GROUP BY pra filtrar resultados de um agrupamento.
--Funciona como um WHERE para dados agrupados.

--Sintaxe:
--SELECT coluna1, funcaoAgregacao(coluna2)
--FROM nomeTabela
--GROUP BY coluna1
--HAVING condicao

--Diferença entre HAVING e WHERE:
--HAVING -> aplicado depois dos dados serem agrupados
--WHERE -> aplicado antes dos dados serem agrupados


--Exemplo:
--Saber quais nomes no sistema tem uma ocorrência maior que 10.

SELECT firstName, COUNT(firstName) AS "Ocorrências"
FROM Person.Person
GROUP BY firstName
HAVING COUNT(firstName) > 10

--Outro exemplo:
--Saber quais produtos cujo os totais de vendas estão entre 162k a 500k

SELECT *
FROM Sales.SalesOrderDetail

SELECT ProductID, SUM(LineTotal) AS "Total de vendas"
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(LineTotal) BETWEEN 162000 AND 500000

--Outro exemplo:
--Saber quais nomes no sistema tem ocorrência maior que 10,
--somente onde o título é 'Mr.'

SELECT firstName, COUNT(firstName) AS "Ocorrências"
FROM Person.Person
WHERE Title = 'Mr.'
GROUP BY firstName
HAVING COUNT(firstName) > 10

--Desafio 1
--Queremos identificar as provincias(stateProvinceId) com o maior
--número de cadastros no sistema. Assim, precisamos encontrar
--quais provícias estão registradas no BD mais que 1000 vezes.

SELECT *
FROM Person.Address

SELECT StateProvinceID, COUNT(StateProvinceID) AS "Quantidade"
FROM Person.Address
GROUP BY StateProvinceID
HAVING COUNT(StateProvinceID) > 1000

--Desafio 2
--Numa multinacional os gerentes querem saber quais produtos
--não estão trazendo em média no mínimo 1 milhão em total de vendas (lineTotal)

SELECT ProductID, AVG(lineTotal) as "Total"
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING AVG(lineTotal) < 1000000

--==========================================================================================

--AULA 15:
-- AS -> serve p/ renomear colunas, selects, agregações...

SELECT TOP 10 listPrice AS Preço
FROM Production.Product

SELECT TOP 10 listPrice AS "Preço do produto" --obrigatório usar aspas se não for uma única palavra
FROM Production.Product

SELECT TOP 10 AVG(ListPrice) AS "Preço médio"
FROM Production.Product

--Desafio 1
--Encontrar o firstName e lastname Person.Person e trazê-las de forma traduzida.

SELECT TOP 10 firstName AS Nome, lastName AS Sobrenome
FROM Person.Person

--Desafio 2
--Traduzir ProductNumber da tabela Production.Product para "Número do produto".

SELECT TOP 10 ProductNumber AS "Número do produto"
FROM Production.Product

--Desafio 3
--Traduzir unitPrice de sales.SalesOrderDetail para "Preço unitário".

SELECT TOP 10 UnitPrice AS "Preço unitário"
FROM Sales.SalesOrderDetail

--==========================================================================================

--AULA 16:
--Tipos de JOIN:
--INNER JOIN, OUTER JOIN, SELF-JOIN
--INNER JOIN -> usado pra pegar informações contidas em outras tabelas

--Lida com conceito de PK e FK. Usado quando queremos ver o endereço de um cliente,
--onde CLIENTE é uma tabela e ENDEREÇO é outra, e CLIENTE tem como atributo a FK EnderecoID

--  ___________
-- |  Cliente |
-- |----------|
-- | ClienteID|
-- |   Nome   |
-- |EnderecoID|
-- ------------

--  ___________
-- | Endereco |
-- |----------|
-- |EnderecoID|
-- |    Rua   |
-- |  Cidade  |
-- ------------

--SELECT C.ClienteID, C.Nome, E.Rua, E.Cidade
--FROM Cliente C
--INNER JOIN Endereco E ON E.EnderecoID = C.EnderecoID

--Exemplo de saída:
-- 2 | Ricardo | Rua de Exemplo | São Paulo


--Outro exemplo:
--Necessário pegar as informaçõesBusinessEntityId, firstName, lastName e emailAddress

SELECT TOP 10 *
FROM Person.Person

SELECT TOP 10 *
FROM Person.EmailAddress

SELECT TOP 10 *
FROM Person.BusinessEntity

SELECT p.BusinessEntityID, p.FirstName, p.LastName, pe.EmailAddress
FROM Person.Person as p
INNER JOIN Person.EmailAddress pe ON p.BusinessEntityID = pe.BusinessEntityID

--Dica: é sempre bom usar apelidos, pois isso evita
--conflitos onde as colunas tem nomes iguais

--Outro exemplo:
--Buscar os nomes dos produtos, preços e as informações de suas subcategorias

SELECT *
FROM Production.Product

SELECT *
FROM Production.ProductSubcategory

SELECT TOP 10
	p.Name AS "Nome",
	ps.Name AS "Sub categoria",
	p.ListPrice AS "Preço"
FROM Production.Product as p
INNER JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID

--Juntando colunas de tabelas diferentes:
--Usado quando não especificamos as colunas, colocando-se assim um *
--Nesse caso, os dois comandos abaixo:

SELECT TOP 10 *
FROM Person.BusinessEntityAddress

SELECT TOP 10 *
FROM Person.Address

--Podem ser substituídos por:
SELECT TOP 10 *
FROM Person.BusinessEntityAddress pba
INNER JOIN Person.Address pa ON pa.AddressID = pba.AddressID

--Desafio 1
--Capturar o businessEntityID, Name, PhoneNumberTypeID, PhoneNumber dos comandos abaixo:
SELECT TOP 10 *
FROM Person.PhoneNumberType

SELECT TOP 10 *
FROM Person.PersonPhone

--Resposta:
SELECT TOP 10
pp.BusinessEntityID, pt.Name, pp.PhoneNumber, pp.PhoneNumberTypeID
FROM Person.PersonPhone pp
INNER JOIN Person.PhoneNumberType AS pt ON pt.PhoneNumberTypeID = pp.PhoneNumberTypeID

--Desafio 2
--Buscar as seguintes informações: AddressId, City, StateProvinceId, Nome do estado

SELECT *
FROM Person.Address

SELECT *
FROM Person.StateProvince

SELECT TOP 10
pad.AddressID AS "ID do endereço",
pad.City AS "Cidade",
pad.StateProvinceID AS "ID da província",
psp.Name AS "Nome do estado"
FROM Person.Address pad
INNER JOIN Person.StateProvince psp ON psp.StateProvinceID = pad.StateProvinceID

--==========================================================================================

--AULA 18 (a 17 foi explicando os tipos de JOINS):
--LEFT OUTER JOIN -> normalmente é abreviado como LEFT JOIN

--Descobrir quais pessoas tem um cartão de crédito registrado

SELECT *
FROM Person.Person pp
INNER JOIN Sales.PersonCreditCard pc
ON pc.BusinessEntityID = pp.BusinessEntityID

--Problema: com inner join temos 19118 resultados

SELECT *
FROM Person.Person pp
LEFT OUTER JOIN Sales.PersonCreditCard pc
ON pc.BusinessEntityID = pp.BusinessEntityID

--Com left join temos 19972 resultados (significa que algumas pessoas não estão com o cartão registrado)
--Left join incluirá até os resultados que não estão na tabela B (PersonCreditCard)

SELECT 19972 - 19118 --saída: 854 (total de pessoas sem cartão de crédito registrado)

--Exibindo os 854 resultados:
SELECT *
FROM Person.Person pp
LEFT OUTER JOIN Sales.PersonCreditCard pc
ON pc.BusinessEntityID = pp.BusinessEntityID
WHERE pc.BusinessEntityID IS NULL
--Isso mostra quais pessoas não tem cartão de crédito e, portanto, não podem fazer compras por exemplo.

--==========================================================================================

--AULA 19:
--UNION -> ajuda a combinar 2 ou mais resultados de um SELECT num único resultado.

--Estrutura:
--SELECT coluna1, coluna2
--FROM tabela1
--UNION
--SELECT coluna1, coluna2
--FROM tabela2

--Detalhe: UNION remove dados duplicados, a não ser que seja usado UNION ALL

--Comando abaixo retorna 5 resultados
SELECT [ProductID], [Name], [ProductNumber]
FROM Production.Product
WHERE Name LIKE '%chain%'

--Comando abaixo retorna 2 resultados
SELECT [ProductID], [Name], [ProductNumber]
FROM Production.Product
WHERE Name LIKE '%Decal%'

--Comando abaixo retorna 7 resultados (tanto os resultados do comando 1 quanto comando 2.
SELECT [ProductID], [Name], [ProductNumber]
FROM Production.Product
WHERE Name LIKE '%chain%'
	UNION
SELECT [ProductID], [Name], [ProductNumber]
FROM Production.Product
WHERE Name LIKE '%Decal%'

--Podemos usar ORDER BY com o UNION, adicionando na última linha o comando a seguir por exemplo: ORDER BY Name ASC

--Desafio: aplicar o conceito do UNION em qualquer tabela do banco de dados.
SELECT FirstName, LastName, EmailPromotion
FROM Person.Person
WHERE EmailPromotion = 0
	UNION
SELECT FirstName, LastName, EmailPromotion
FROM Person.Person
WHERE MiddleName IS NULL

--==========================================================================================

--AULA 20:
--DATEPART -> usado para lidar com datas

--No caso do comando abaixo, além do ID estamos capturando o mês da coluna OrderDate
SELECT SalesOrderId, DATEPART(month, OrderDate) AS "Mes"
FROM Sales.SalesOrderHeader

--Além de month, podemos usar day, year...

--Capturando média de valor que está a dever por mês
SELECT AVG(TotalDue) As Media, DATEPART(month, OrderDate) AS Mes
FROM Sales.SalesOrderHeader
GROUP BY DATEPART(month, OrderDate)
ORDER BY Mes

--Capturando média de valor que está a dever por dia
SELECT AVG(TotalDue) As Media, DATEPART(day, OrderDate) AS Dia
FROM Sales.SalesOrderHeader
GROUP BY DATEPART(day, OrderDate)
ORDER BY Dia

--Desafio
--Selecionar o mês e o ano usando DATEPART de qualquer tabela que use datas.

--Pegando mês de nascimento apenas
SELECT BusinessEntityID, DATEPART(month, BirthDate) AS "Mês de nascimento"
FROM HumanResources.Employee

--Pegando BusinessEntityID, nome, sobrenome e dia de nascimento do funcionário.
SELECT
	hre.BusinessEntityID,
	pp.FirstName,
	pp.LastName,
	DATEPART(day, hre.BirthDate) AS "Dia de nascimento"
FROM HumanResources.Employee hre
INNER JOIN Person.Person pp ON pp.BusinessEntityID = hre.BusinessEntityID

--==========================================================================================

--AULA 21:
--Manipulação de String

--Concatenando valores
SELECT CONCAT(FirstName, ' ', LastName) AS "Nome Completo"
FROM Person.Person

--firstName com letras maiúsculas, lastName com letras minúsculas
SELECT UPPER(firstName), LOWER(lastName)
FROM Person.Person

SELECT CONCAT(UPPER(firstName), ' ', LOWER(lastName))
FROM Person.Person

--Descobrindo tamanho de uma String:
SELECT LEN(firstName), firstName
FROM Person.Person

--Substring: usado pra extrair um pedaço de uma String
--No exemplo abaixo, está começando do primeiro índice [1] e a partir dele
--exibirá 3 letras. No caso de 'Catherine', será apresentado 'Cat'
SELECT firstName, SUBSTRING(firstName, 1, 3)
FROM Person.Person

--Replace: substitui X por Y
--Sintaxe: REPLACE(Coluna, ValorOriginal, NovoValor)
SELECT ProductNumber, REPLACE(ProductNumber, '-', '+++')
FROM Production.Product

SELECT PhoneNumber, REPLACE(PhoneNumber, '-', ' ')
FROM Person.PersonPhone

--==========================================================================================

--AULA 22:
--Funções matemáticas
SELECT
	UnitPrice,
	LineTotal,
	UnitPrice + LineTotal AS "Soma"
FROM Sales.SalesOrderDetail

--Além do +, podemos usar -, * e /.

--Pegando a média
SELECT AVG(LineTotal)
FROM Sales.SalesOrderDetail

--Pegando soma
SELECT SUM(LineTotal)
FROM Sales.SalesOrderDetail

--Pegando maior valor
SELECT MAX(LineTotal)
FROM Sales.SalesOrderDetail

--Pegando menor valor
SELECT MIN(LineTotal)
FROM Sales.SalesOrderDetail

--Arredondando valores (com precisão decimal = 2)
SELECT LineTotal, ROUND(LineTotal, 2)
FROM Sales.SalesOrderDetail

--Pegando raíz quadrada
SELECT SQRT(LineTotal)
FROM Sales.SalesOrderDetail

--Caso precise saber de outras funções, basta pesquisar:
--Funções matemáticas SQL Server

--==========================================================================================

--AULA 23:
--SUBQUERY (SUBSELECT) -> SELECT dentro de outro SELECT.

--Montar um relatório de todos os produtos cadastrados que tem preço de venda acima da média.
--Uma forma seria:

--Pegando a média
SELECT AVG(ListPrice)
FROM Production.Product

--Exibindo os valores acima da média
SELECT *
FROM Production.Product
WHERE ListPrice > 438.66

--Utilizando subquerys:
SELECT *
FROM Production.Product
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product)

--Essa opção é melhor pois é dinâmica. No caso do primeiro exemplo, assim que
--adicionamos/removemos valores da tabela, precisariamos manualmente atualizar
--o valor da média.

--Outro exemplo:
--Saber o nome dos funcionários que tem cargo de 'Design Engineer'

SELECT *
FROM HumanResources.Employee
WHERE JobTitle = 'Design Engineer'

SELECT *
FROM Person.Person
WHERE BusinessEntityID IN (5, 6, 15)

--A solução acima é ruim pois não é dinâmica. Forma ideal:

SELECT FirstName
FROM Person.Person
WHERE BusinessEntityID IN (
	SELECT BusinessEntityID
	FROM HumanResources.Employee
	WHERE JobTitle = 'Design Engineer')

--Ou então usando conceito de JOINS:
SELECT pp.FirstName, hre.JobTitle
FROM Person.Person pp
INNER JOIN HumanResources.Employee hre ON hre.BusinessEntityID = pp.BusinessEntityID
AND hre.JobTitle = 'Design Engineer' --ou WHERE hre.JobTitle = 'Design Engineer'

--Desafio
--Encontrar todos os endereços que estão no estado de 'Alberta' (pode trazer todas as informações)
SELECT *
FROM Person.Address

SELECT *
FROM Person.StateProvince

SELECT *
FROM Person.Address
WHERE StateProvinceID = (
	SELECT StateProvinceID
	FROM Person.StateProvince
	WHERE Name = 'Alberta')

--==========================================================================================

--AULA 24:
--Obs.: será utilizado outro banco de dados, link:
--https://raw.githubusercontent.com/Microsoft/sql-server-samples/master/samples/databases/northwind-pubs/instnwnd.sql
--SELF-JOIN -> agrupar/ordenar dados dentro da mesma tabela
--Detalhe: só funciona usando um alias (apelido, "AS")

--Sintaxe:
--SELECT coluna 
--FROM tabela a, tabela b 
--WHERE condicao 

--Capturar todos os clientes que moram na mesma região
SELECT
	a.ContactName,
	a.Region,
	b.ContactName,
	b.Region
FROM Customers a, Customers b
WHERE a.Region = b.Region

--Capturar nome e data de contratação dos funcionários
--que foram contratados no mesmo ano

SELECT a.FirstName, b.FirstName, DATEPART(YEAR, a.HireDate) AS "Ano"
FROM Employees a, Employees b
WHERE DATEPART(YEAR, a.HireDate) = DATEPART(YEAR, b.HireDate)

--Desafio
--Saber na tabela detalhe do pedido quais produtos
--tem o mesmo percentual de desconto

SELECT a.ProductID, a.Discount, b.ProductID, b.Discount
FROM [Order Details] a, [Order Details] b
WHERE a.Discount = b.Discount

--==========================================================================================

--AULA 25:
--Tipos de dados principais
--1. booleanos:
-- => se inicia como nulo. Pode ser 1, 0 ou nulo. Usamos a palavra BIT para booleanos.

--2. caracteres:
-- => tamanho fixo CHAR - ocupa todo o espaço reservado, exemplo: char(50) ocupa 50, mesmo que só tenha sido preenchido 10
-- => tamanhos variáveis VARCHAR e NVARCHAR - só usa o espaço do que foi preenchido (se definiu 50 e usou 10, ocupará só 10)

--3. números:
-- => TINYINT - só permite inteiros
-- => SMALLINT - igual, mas com limite um pouco maior
-- => INT - igual, mas com limite um pouco maior
-- => BIGINT - igual, mas com limite um pouco maior
-- => NUMERIC ou DECIMAL - são inteiros mas permitem partes fracionadas, onde pode ser especificada a precisão e escala. Exemplo: NUMERIC (5,2) 113,44
-- => valores aproximados REAL - tem precisão aproximada de até 15 dígitos

--4. temporais:
-- => DATE - armazena data no formato aaaa/mm/dd
-- => DATETIME - armazena data e horas no formato aa/mm/dd:hh:mm:ss
-- => DATETIME2 - data e horas com adição de milissegundos, formato aa/mm/dd:hh:mm:sssssss
-- => SMALLDATETIME - data e hora respeitando limite de '1900-01-01:00:00:00' até '2079-06-06:23:59:59'
-- => TIME - horas, minutos, segundos e milissegundos respeitando limite de '00:00:00.0000000' até '23:59:59.9999999'
-- => DATETIMEOFFSET - permite armazenar informações de data e hora incluindo fuso-horário

--==========================================================================================

--AULA 26:
--Primary Keys e Foreign Keys (Chaves estrangeiras)
--São criadas utilizando CONSTRAINTS (restrições)

--Definindo PK:
--CREATE TABLE nomeTabela(
--	nomeColuna tipoDado PRIMARY KEY,
--	nomeColuna tipoDado
--)

--FK:
--São referências para linkar tabelas. Ou seja, ela conterá o ID para acessar o campo de outra tabela.
--Tabela que contém a FK: chamada de filha ou tabela referenciadora.
--Do mesmo modo, a tabela que é apontada é a tabela pai ou tabela referenciada.
--É definido com uma CONSTRAINT.
--Detalhe: uma tabela pode ter mais de uma FK.

--Para um exemplo mais prático, ver a AULA 16.

--==========================================================================================

--AULA 27:
--CREATE TABLE -> criar tabelas

--CREATE TABLE nomeTabela(
--	coluna, tipo, restricao, --restrição é opcional
--	...
--)

--Principais restrições:
--NOT NULL -> não permite nulos
--UNIQUE -> força que todos os valores da coluna sejam diferentes
--PRIMARY KEY -> junção do NOT NULL + UNIQUE
--FOREIGN KEY -> identifica unicamente uma linha em outra tabela
--CHECK -> força uma condição específica em uma coluna (exemplo: só valores maiores que 10 podem ser inseridos na coluna; mínimo de 5 caracteres, etc)
--DEFAULT -> força um valor padrão quando nenhum valor é passado (evita valores nulos)

CREATE TABLE Canal(
	CanalID int IDENTITY(1,1) PRIMARY KEY,
	Nome varchar(150) NOT NULL,
	ContagemInscritos INT DEFAULT 0,
	DataCriacao DATETIME NOT NULL
)

--Importante:
--IDENTITY(1,1) significa que o valor começa em 1 e incrementa de 1 em 1.
--Se colocasse IDENTITY(10,5) significaria que começa com 10 e acontece o incremento de 5 em 5.

CREATE TABLE Video(
	VideoID int IDENTITY(1,1) PRIMARY KEY,
	Nome varchar(150) NOT NULL,
	Visualizacoes INT DEFAULT 0,
	Likes INT DEFAULT 0,
	Deslikes INT DEFAULT 0,
	Duracao INT NOT NULL, --INT pois é contada em segundos
	CanalID INT FOREIGN KEY REFERENCES Canal(CanalID)
)

SELECT *
FROM Canal

SELECT *
FROM Video

--==========================================================================================

--AULA 28:
--INSERT INTO
--Inserindo valor na tabela:

--INSERT INTO nomeTabela(coluna1, coluna2,...)
--VALUES(valor1, valor2,...)

--Inserindo mais de um valor na tabela:
--INSERT INTO nomeTabela(coluna1, coluna2,...)
--VALUES
--(valor1, valor2,...),
--(valor1, valor2,...),
--(valor1, valor2,...)

--Inserindo valores de outra tabela dentro de uma tabela existente.
--INSERT INTO tabelaA(coluna1)
--SELECT coluna2
--FROM tabelaB 

CREATE TABLE Aula(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	Nome VARCHAR(50)
)

INSERT INTO Aula(Nome)
VALUES('Teste')

INSERT INTO Aula(Nome)
VALUES
('Teste1'),
('Teste2'),
('Teste3')

SELECT * FROM Aula

--Copiando dados de uma tabela e jogando para uma tabela já existente.
--Criando rapidamente uma tabela:
SELECT * INTO TabelaNova FROM Aula

--Os valores da tabela Aula agora estão na TabelaNova
SELECT * FROM TabelaNova

--==========================================================================================

--AULA 29:
--UPDATE -> serve pra atualizar linhas do banco de dados.

--UPDATE nomeTabela
--SET	coluna1 = valor1
--		coluna2 = valor2
--WHERE condicao

SELECT * FROM Aula

UPDATE Aula
SET Nome = 'ABC'
--Agora todos os dados estão com Nome = ABC.

UPDATE Aula
SET Nome = 'Teste'
WHERE id = 4
--Agora só a linha com ID 4 foi alterada.

--==========================================================================================

--AULA 30:
--DELETE
--Funciona como o UPDATE. É necessária uma condição, ou apagará tudo.

--Deletando um dos registros
DELETE FROM Aula
WHERE Nome = 'Teste'

--Deletando todos os registros
DELETE FROM Aula

--==========================================================================================

--AULA 31:
--ALTER TABLE -> alterar estrutura de uma tabela.

--Sintaxe:
--ALTER TABLE nomeDaTabela
--ACAO

--Algumas ações:
--Adicionar, remover, alterar colunas
--Setar valores padrão para uma coluna
--Adicionar ou remover restrições de colunas
--Renomear uma tabela

--Adicionando coluna para IDADE
ALTER TABLE Aula
ADD Idade INT

--Alterando limite de caracteres e adicionando restrição NOT NULL
ALTER TABLE Aula
ALTER COLUMN Nome VARCHAR(30) NOT NULL

--Pra alterar nome de coluna, necessária a sintaxe:
--EXEC sp_RENAME 'NomeTabela.NomeColunaAtual', 'NomeColunaNova', 'COLUMN'

--Alterando nome de coluna
EXEC sp_RENAME 'Aula.Idade', 'NovaIdade', 'COLUMN'

--Pra alterar o nome da tabela, o processo é semelhante:
--EXEC sp_RENAME 'NomeTabela', 'NovoNome'
EXEC sp_RENAME 'Aula', 'AulaTeste'

--Não funciona
SELECT * FROM Aula

--Funciona
SELECT * FROM AulaTeste

INSERT INTO AulaTeste(Nome)
VALUES('Um'), ('Dois')

--==========================================================================================

--AULA 32:
--DROP TABLE -> excluir tabelas

--Sintaxe:
--DROP TABLE nomeTabela 

DROP TABLE AulaTeste

--Importante: só podemos dropar tabelas que não referenciam outras
--Erro:
DROP TABLE Customers

--Pra remover apenas os dados da tabela mas manter ela, é usado TRUNCATE

CREATE TABLE tabelaTeste(
	Id INT PRIMARY KEY,
	Nome VARCHAR(10)
)

INSERT INTO tabelaTeste(Id, Nome) VALUES(0, 'Teste')

TRUNCATE TABLE tabelaTeste

--As informações inseridas foram deletadas, mas tabelaTeste ainda existe.
SELECT *
FROM tabelaTeste

--==========================================================================================

--AULA 33:
--CHECK CONSTRAINT -> ajuda a aplicar restrições sobre valores, aplicado em inserção ou alteração de dado

--Exemplo:
CREATE TABLE CarteiraMotorista(
	Id INT PRIMARY KEY,
	Nome VARCHAR(100) NOT NULL,
	Idade INT CHECK (Idade >= 18)
)

SELECT * FROM CarteiraMotorista

--Válido:
INSERT INTO CarteiraMotorista(Id, Nome, Idade)
VALUES(0, 'Ana', 19)

--Erro:
INSERT INTO CarteiraMotorista(Id, Nome, Idade)
VALUES(1, 'Mario', 13)

--==========================================================================================

--AULA 35: (34 foi sobre NOT NULL)
--UNIQUE -> cada registro ali será único, semelhante à PRIMARY KEY.
--Podemos ter somente uma PK, mas várias colunas podem ser UNIQUE.

CREATE TABLE Usuario(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	Nome VARCHAR(30),
	Cpf INT UNIQUE
)

INSERT INTO Usuario(Nome, Cpf)
VALUES
('Roberto', 34345645)
--Agora não pode mais ser cadastrado um usuário com o valor especificado acima.

SELECT *
FROM Usuario

--==========================================================================================

--AULA 36: (última aula)
--VIEWS -> extrair informações de uma tabela existente, sem pegar todos os dados.
--Muito comum pra criar relatórios.

--Sintaxe:
--CREATE VIEW [nome da View] AS
--SELECT coluna1, coluna2
--FROM tabela
--WHERE condicao

CREATE VIEW [Pessoas] AS
SELECT FirstName, MiddleName, LastName
FROM Person.Person
WHERE Title = 'Ms.'

SELECT * From [Pessoas]

--Dropando a VIEW
DROP VIEW Pessoas