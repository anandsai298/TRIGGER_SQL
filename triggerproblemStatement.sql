create database triggerproblem;
use triggerproblem;
--
create table Employees(
ID int primary key,
Name varchar(50),
Salary bigint,
Age int,
);
Alter table Employees Add Action Varchar(50);
--
create table Employee_Backup(
ID int,
Name varchar(50),
Salary bigint,
Age int,
);
drop table Employee_Backup;
--trigger insert
Alter trigger [dbo].[trgafterinserted] on [dbo].[Employees]
for insert
as
declare @ID int,@Name varchar(50),@Salary bigint,@Age int;

select @ID=Employees.ID ,@Name=Employees.Name ,@Salary=Employees.Salary, @Age=Employees.Age from inserted Employees;
if @Salary > 50000
begin
print 'Employee details not inserted becuase salary must lessthan 50000: '
rollback
end
else
begin
print 'employee details inserted successfully: '
end

--before/after insert
select * from Employees;
insert into Employees values(1,'ask',20000,25);
insert into Employees values(2,'sai',30000,22);
insert into Employees values(3,'jai',40000,23);
insert into Employees values(4,'yai',60000,26);


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

select @ID=Employees.ID ,@Name=Employees.Name ,@Salary=Employees.Salary, @Age=Employees.Age from deleted Employees;
insert into Employee_Backup values(@ID,@Name,@Salary,@Age)
print 'Employee details are backed up into Employee_Backup: '
--before/after delete
select * from Employees;
select * from Employee_Backup;
delete from Employees where ID=3;
----------
create table Employee_Audit(
ID int primary key,
Name varchar(50),
Salary bigint,
Age int,
Action varchar(50)
);
drop table Employee_Audit;
---After each product is deleted from the table, the trigger inserts a record into the ProductAudit table, capturing the ProductID, ProductName, and the action of "Deleted".
ALTER TRIGGER AfterDeleteTRG
ON Employees
AFTER DELETE
AS 
 declare @ID int,@Name varchar(50),@Salary bigint,@Age int,@Action varchar(50);
BEGIN
    INSERT INTO Employee_Audit (ID, Name, Salary, Age, Action)
    SELECT ID, Name, Salary, Age, Action
    FROM deleted Employees;
END;

-- Remaining code for testing
SELECT * FROM Employees;
SELECT * FROM Employee_Audit;
DELETE FROM Employees WHERE Name = 'jai';