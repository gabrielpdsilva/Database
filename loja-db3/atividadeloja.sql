--atividade de relacionamentos entre tabelas
--no sql server para BD III (etec)

use master 
go
drop database db_mercado
go
create database db_mercado
go
use db_mercado
go
--================================CREATE TABLES===================================================
create table tb_vendas(
id_venda int primary key IDENTITY(1,1),
id_cliente int not null,
id_item_vendido int not null,
data date,
desconto decimal(2,2)

--constraint fk_clientes foreign key (id_cliente) references tb_clientes(id_ciente)
)
GO

create table tb_clientes(
id_cliente int PRIMARY KEY IDENTITY(1,1),
nome nvarchar(50) not null,
endereco nvarchar(100),
idade int NOT NULL,
sexo char(1) NOT NULL,
fone nvarchar(15),
email nvarchar(70)

--Professor, não consegui entender se no relacionamento entre vendas e clientes
--precisa criar uma foreign key em ambas as tabelas ou se só uma fk já é o suficiente.
--Por isso deixei o código abaixo como comentário, porém adicionei uma fk na tb_vendas.
--add constraint fk_vendas foreign key (id_venda) references tb_vendas(id_venda)

)
GO

create table tb_itens_vendidos(
id_item_vendido int primary key IDENTITY(1,1),
--id_venda int not null,
id_produto int not null

--constraint fk_produtos foreign key (id_produto) references tb_produtos(id_produto),
--constraint fk_vendas foreign key (id_venda) references tb_vendas(id_venda)

)
GO





create table tb_vendas_canceladas(
id_vendas_canceladas int primary key IDENTITY(1,1),
id_item_vendido int UNIQUE not null

--UNIQUE faz com que não seja possível remover 2x o mesmo item da tabela.
--Se remover uma vez, não tem como 'remover' de novo.

--constraint fk_itens_vendidos foreign key (id_item_vendido) references tb_itens_vendidos(id_item_vendido)

)
GO

create table tb_produtos(
id_produto int primary key IDENTITY(1,1),
nome varchar(30) not null,
detalhes varchar(30),
data date not null,
desconto decimal(2,2)
)
GO

--================================ALTER TABLES===================================================
alter table tb_itens_vendidos
	add CONSTRAINT fk_id_produto
	FOREIGN KEY (id_produto)
	REFERENCES tb_produtos(id_produto)
	go
	
--alter table tb_itens_vendidos
--	add CONSTRAINT fk_vendas
--	FOREIGN KEY (id_venda)
--	REFERENCES tb_vendas(id_venda)
--	go
	
--alter table tb_vendas
--	add CONSTRAINT fk_clientes
--	FOREIGN KEY (id_cliente)
--	REFERENCES tb_clientes(id_cliente)
--	go
	
	alter table tb_vendas
	add CONSTRAINT fk_itens_vendidos
	FOREIGN KEY (id_item_vendido)
	REFERENCES tb_itens_vendidos(id_item_vendido)
	go
	
--alter table tb_clientes
	--add CONSTRAINT fk_vendas FOREIGN KEY (id_venda) REFERENCES tb_vendas(id_venda)
	--go
	
	
	--//////////////////necessario arrumar aqui
--alter table tb_vendas_canceladas
--	add CONSTRAINT fk_vendas foreign key (id_venda) references tb_vendas(id_venda)
--	go


	
alter table tb_vendas_canceladas
	add CONSTRAINT fk_id_item_vendido
	FOREIGN KEY (id_item_vendido)
	REFERENCES tb_itens_vendidos(id_item_vendido)
	go

--================================INSERT INTO===================================================
--Acrescentando código: 29/08/19
--insere os seguintes dados na tabela clientes
insert into tb_clientes(nome, endereco, idade, sexo)values(
'Rogerio','Rua 593','28','M'
)

insert into tb_clientes(nome, endereco, idade, sexo)values(
'Jailson','Rua 231','25','M'
)

insert into tb_clientes(nome, endereco, idade, sexo)values(
'Paulo Guina','Rua 312','28','M'
)




--inserindo dados na tabela produtos
insert into tb_produtos(nome, data, desconto)values(
'hardware','05/12/2009','0.1'
);

insert into tb_produtos(nome, data, desconto)values(
'teclado','12/11/2011','0.0'
);

insert into tb_itens_vendidos(id_produto)values(
2
)

--inserindo dados na tabela vendas
insert into tb_vendas(id_cliente, id_item_vendido)values(
2,2
);


select * from tb_clientes
select * from tb_vendas
select * from tb_produtos
select * from tb_itens_vendidos
--================================3 EXERCICIOS DE TLBD3===================================================

--Seleciona o ID da venda e o nome do cliente (que fez aquela venda) e mostra ambos
SELECT tbv.id_venda, tbc.nome 
FROM tb_vendas AS tbv 
JOIN tb_clientes AS tbc ON tbv.id_venda = tbc.id_cliente		--Nesse caso não coloca RIGHT JOIN porque o RIGHT vai puxar todas 
																--as informações restantes das tabelas, mas queremos apenas dados dos clientes que fizeram compras. (Inersecção)
																--Com o RIGHT, mostra os que não fizeram também.

--Seleciona os clientes que não fizeram compra nenhuma
SELECT tbc.nome
FROM tb_clientes as tbc --[esquerda]
LEFT JOIN tb_vendas AS tbv   --[direita]
ON tbc.id_cliente = tbv.id_cliente
WHERE tbv.id_cliente is NULL

SELECT tbp.id_produto
FROM tb_produtos as tbp
JOIN tb_itens_vendidos AS tbiv
ON tbp.id_produto = tbiv.id_produto
WHERE tbiv.id_item_vendido is NULL

--insert into tb_itens_vendidos(id_produto, id_venda)values(
--2,1
--)

select * from tb_clientes
select * from tb_vendas
select * from tb_produtos