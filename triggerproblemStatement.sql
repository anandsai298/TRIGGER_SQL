create database triggerproblem;
use triggerproblem;
--
create table Employees(
ID int primary key,
Name varchar(50),
Salary bigint,
Age int,
);
drop table Customers;
--trigger insert
create trigger [dbo].[trgafterinserted] on [dbo].[Employees]
for insert
as
declare @ID int,@Name varchar(50),@Salary bigint,@Age int;

select @ID=Employees.ID from inserted Employees;
select @Name=Employees.Name from inserted Employees;
select @Salary=Employees.Salary from inserted Employees;
select @Age=Employees.Age from inserted Employees;
--before/after insert
select * from Employees;
insert into Employees values(1,'ask',20000,25);
insert into Employees values(2,'sai',30000,22);
--trigger update
create trigger [dbo].[trgafterupdate] on [dbo].[Employees]
after update
as
declare @ID int,@Name varchar(50),@Salary bigint,@Age int;

select @ID=Employees.ID from inserted Employees;
select @Name=Employees.Name from inserted Employees;
select @Salary=Employees.Salary from inserted Employees;
select @Age=Employees.Age from inserted Employees;
--before/after update
select * from Employees;
update Employees set Name='askar' where ID=1;
--trigger delete
create trigger [dbo].[trgafterdelete] on [dbo].[Employees]
after Delete
as
declare @ID int,@Name varchar(50),@Salary bigint,@Age int;

select @ID=Employees.ID from inserted Employees;
select @Name=Employees.Name from inserted Employees;
select @Salary=Employees.Salary from inserted Employees;
select @Age=Employees.Age from inserted Employees;
--before/after delete
select * from Employees;
delete from Employees where ID=2;

