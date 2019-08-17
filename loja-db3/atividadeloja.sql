--atividade de relacionamentos entre tabelas
--no sql server para BD III (etec)

create database db_mercado
use db_mercado
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

create table tb_vendas(
id_venda int primary key IDENTITY(1,1),
id_cliente int not null,
data date not null,
desconto decimal(2,2),

constraint fk_clientes foreign key (id_cliente) references tb_clientes(id_ciente)
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


create table tb_vendas_canceladas(
id_vendas_canceladas int primary key IDENTITY(1,1),
id_itens_vendidos int not null,

constraint fk_itens_vendidos foreign key (id_item_vendido) references tb_itens_vendidos(id_item_vendido)

)
GO


create table tb_itens_vendidos(
id_item_vendido int primary key IDENTITY(1,1),
id_venda int not null,
id_produto int not null,

constraint fk_produtos foreign key (id_produto) references tb_produtos(id_produto),
constraint fk_vendas foreign key (id_venda) references tb_vendas(id_venda)

)
GO