--Exercicio trigger
use master
create database exemplo_1
use exemplo_1
drop database exemplo_1

create table tb_pessoas(
	nome_pessoa varchar(30),
	id_pessoa int not null identity(1,1),
	primary key(id_pessoa),
	sexo_pessoa char(1)
)

create table tb_pessoas_com_data(
	nome_pessoa varchar(30),
	id_pessoa int not null,
	primary key(id_pessoa),
	sexo_pessoa char(1),
	data_registro date
)

insert into tb_pessoas(nome_pessoa, sexo_pessoa)values(
	'Rafael', 'M'
)

drop trigger tg_insert_pessoas_data

create trigger tg_insert_pessoas_data on tb_pessoas
for insert
as
declare @pessoaid int;
declare @pessoasexo char(1);
declare @pessoanome varchar(100);

select @pessoaid = i.id_pessoa from inserted i;
select @pessoasexo = i.nome_pessoa from inserted i;
select @pessoanome = i.sexo_pessoa from inserted i;

insert into tb_pessoas_com_data(id_pessoa, nome_pessoa, data_registro) values(@pessoaid, @pessoanome, GETDATE());


select * from tb_pessoas
select * from tb_pessoas_com_data
