CREATE DATABASE exec09
GO

USE exec09
GO

CREATE TABLE editora(
    codigo INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    site VARCHAR(100),
    PRIMARY KEY(codigo)
)
GO

CREATE TABLE autor(
    codigo INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    breve_biografia VARCHAR(100) NOT NULL
    PRIMARY KEY(codigo)
)
GO

CREATE TABLE estoque(
    codigo INT NOT NULL,
    nome VARCHAR(100) UNIQUE NOT NULL,
    qtd INT NOT NULL,
    valor DECIMAL(7,2) CHECK(valor > 0),
    cod_editora INT NOT NULL,
    cod_autor INT NOT NULL,
    PRIMARY KEY(codigo),
    FOREIGN KEY(cod_editora) REFERENCES editora(codigo),
    FOREIGN KEY(cod_autor) REFERENCES autor(codigo)
)
GO

CREATE TABLE compras(
    codigo INT NOT NULL,
    cod_livro INT NOT NULL,
    qtd_comprada INT NOT NULL CHECK(qtd_comprada > 0),
    valor INT NOT NULL CHECK(valor > 0),
    data_compra DATE NOT NULL
    PRIMARY KEY(codigo, cod_livro)
    FOREIGN KEY(cod_livro) REFERENCES estoque(codigo),
)
GO

-- Consultar nome, valor unitário, nome da editora e nome do autor dos livros do estoque que foram vendidos. Não podem haver repetições.
SELECT DISTINCT liv.nome, liv.valor, edit.nome, aut.nome
FROM editora edit, autor aut, compras comp, estoque liv
WHERE comp.cod_livro = liv.codigo
	AND liv.cod_autor = aut.codigo
	AND liv.cod_editora = edit.codigo

-- Consultar nome do livro, quantidade comprada e valor de compra da compra 15051	
SELECT liv.nome, comp.qtd_comprada, comp.valor
FROM estoque liv, compras comp
WHERE comp.cod_livro = liv.codigo
	AND comp.codigo = 15051
-- Consultar Nome do livro e site da editora dos livros da Makron books (Caso o site tenha mais de 10 dígitos, remover o www.).	
SELECT liv.nome AS nome_livro,
	CASE
		WHEN LEN(edit.site) > 10 THEN
			SUBSTRING(edit.site, 5, 20)
		ELSE
			edit.site
		END AS site_editora
FROM estoque liv, editora edit
WHERE liv.cod_editora = edit.codigo
	AND edit.nome LIKE '%Makron books%'

-- Consultar nome do livro e Breve Biografia do David Halliday	
SELECT liv.nome, aut.breve_biografia AS biografia_autor
FROM estoque liv, autor aut
WHERE liv.cod_autor = aut.codigo
	AND aut.nome LIKE '%David Halliday%'

-- Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos	
SELECT comp.codigo, comp.qtd_comprada
FROM compras comp, estoque liv
WHERE comp.cod_livro = liv.codigo
	AND liv.nome LIKE '%Sistemas Operacionais Modernos%'

-- Consultar quais livros não foram vendidos	
SELECT liv.nome
FROM estoque liv
LEFT OUTER JOIN compras comp
ON liv.codigo = comp.cod_livro
WHERE comp.cod_livro IS NULL

-- Consultar quais livros foram vendidos e não estão cadastrados	
SELECT liv.nome
FROM estoque liv
LEFT OUTER JOIN compras comp
ON liv.codigo = comp.cod_livro
WHERE liv.codigo IS NULL

-- Consultar Nome e site da editora que não tem Livros no estoque (Caso o site tenha mais de 10 dígitos, remover o www.)	
SELECT edit.nome,
	CASE
		WHEN LEN(edit.site) > 10 THEN
			SUBSTRING(edit.site, 5, 20)
		ELSE
			edit.site
	END AS site_editora
FROM editora edit
LEFT OUTER JOIN estoque liv
ON edit.codigo = liv.cod_editora
WHERE liv.cod_editora IS NULL

-- Consultar Nome e biografia do autor que não tem Livros no estoque (Caso a biografia inicie com Doutorado, substituir por Ph.D.)	
SELECT aut.nome, REPLACE(aut.breve_biografia, 'Doutorado', 'Ph.D.') AS breve_biografia
FROM autor aut
LEFT OUTER JOIN estoque liv
ON aut.codigo = liv.cod_autor
WHERE liv.cod_autor IS NULL

-- Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor descendente	
SELECT TOP 1 aut.nome, liv.valor
FROM autor aut, estoque liv
WHERE aut.codigo = liv.cod_autor
ORDER BY liv.valor DESC

-- Consultar o código da compra, o total de livros comprados e a soma dos valores gastos. Ordenar por Código da Compra ascendente.	
SELECT comp.codigo,
	SUM(comp.qtd_comprada) AS total_livros_comprados,
	SUM(comp.valor) AS soma_valores_gastos
FROM compras comp
GROUP BY comp.codigo
ORDER BY comp.codigo

-- Consultar o nome da editora e a média de preços dos livros em estoque.Ordenar pela Média de Valores ascendente.	
SELECT edit.nome AS nome_editora, AVG(liv.valor) AS preco_medio_livros
FROM editora edit, estoque liv
WHERE edit.codigo = liv.cod_editora
GROUP BY edit.nome
ORDER BY AVG(liv.valor) ASC

-- Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da editora (Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna status onde:	
	-- Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
	-- Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
	-- Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
	-- A Ordenação deve ser por Quantidade ascendente
SELECT liv.nome,
	liv.qtd,
	edit.nome,
	CASE
		WHEN LEN(edit.site) > 10 THEN
			SUBSTRING(edit.site, 5, 20)
		ELSE
			edit.site
	END AS site_editora,
	CASE
		WHEN liv.qtd < 5 THEN
			'Produto em Ponto de Pedido'
		ELSE
			CASE WHEN liv.qtd >= 5 AND liv.qtd <= 10 THEN
				'Produto Acabando'
			ELSE
				'Estoque Suficiente'
			END
	END AS status
FROM estoque liv, editora edit
WHERE liv.cod_editora = edit.codigo
ORDER BY liv.qtd ASC

-- Para montar um relatório, é necessário montar uma consulta com a seguinte saída: Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site) de todos os livros	
	-- Só pode concatenar sites que não são nulos
SELECT liv.codigo, liv.nome,aut.nome,
	CASE
		WHEN edit.site IS NOT NULL THEN
			edit.nome + ' ' + edit.site
		ELSE
			edit.nome
	END AS info_editora
FROM estoque liv, autor aut, editora edit
WHERE liv.cod_autor = aut.codigo
	AND liv.cod_editora = edit.codigo

-- Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da compra até hoje	
SELECT comp.codigo,
	DATEDIFF(DAY, comp.data_compra, GETDATE()) AS dias_compra,
	DATEDIFF(MONTH, comp.data_compra, GETDATE()) AS meses_compra
FROM compras comp

-- Consultar o código da compra e a soma dos valores gastos das compras que somam mais de 200.00	
SELECT comp.codigo, SUM(comp.valor) AS soma_gastos
FROM compras comp
GROUP BY comp.codigo
HAVING SUM(comp.valor) > 200