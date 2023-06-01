create database TriggerSql;
use TriggerSql;
--
create table Employees(
EmployeeID int primary key,
EmployeeName varchar(50),
EmployeeSalary bigint,
DateOfBirth Date,
Experience bigint,
RecordTime DateTime
);
alter table Employees add Age int;
--
create table Employee_History(
FieldName varchar(50),
OldValue varchar(50),
NewValue varchar(50),
RecordDateTime DateTime,
);
alter table Employee_History Add  EmployeeID int;
drop table  Employee_History;
--
create table Employee_Backup(
EmployeeID int primary key,
EmployeeName varchar(50),
EmployeeSalary bigint,
DateOfBirth Date,
Experience bigint,
Age int
);
drop table Employee_Backup;


--trigger after/ for insert--
create trigger [dbo].[trgAfterInsert] on [dbo].[Employees]
for insert
As
declare @DateOfBirth date;
declare @Experience bigint;
declare @Age int;

select @DateOfBirth=Employees.DateOfBirth from inserted Employees;
select @Experience=Employees.Experience from inserted Employees;
--age below 25yrs--
set @Age=Year(GetDate())-Year(@DateOfBirth);
if @Age>25
begin
print 'not eligible :Age id greater than 25 yrs'
rollback
End
--experience should be greater than 5 yrs--
else if @Experience<5
begin
print 'not eligible : EXP is less than 5 yrs'
rollback
end
else
begin
print 'employee details inserted successfully'
end
--before insert
select * from Employees;

insert into Employees values(1,'ask',20000,'1999-09-29',6,GETDATE(),23)
insert into Employees values(5,'dada',20000,'1999-07-29',7,GETDATE(),23)
insert into Employees values(2,'sai',30000,'1995-09-29',6,GETDATE())
insert into Employees values(3,'anand',20000,'1999-09-29',4,GETDATE())
--create trigger after update--
create trigger [dbo].[trgafterupdate] on [dbo].[Employees]
After Update
as
declare @EmployeeID int;
declare @EmployeeName varchar(50);
declare @OldName varchar(50);
declare @EmployeeSalary bigint;
declare @OldSalary bigint;

select @EmployeeID=Employees.EmployeeID from inserted Employees;
select @EmployeeName=Employees.EmployeeName from inserted Employees;
select @OldName=Employees.EmployeeName from deleted Employees;
select @EmployeeSalary=Employees.EmployeeSalary from inserted Employees;
select @OldSalary=Employees.EmployeeSalary from deleted Employees;

if update(EmployeeName)
begin
insert into Employee_History(EmployeeID,FieldName,OldValue,NewValue,RecordDateTime) values(@EmployeeID,'EmployeeName',@OldName,@EmployeeName,GETDATE())
end
if update(EmployeeSalary)
begin
insert into Employee_History(EmployeeID,FieldName,OldValue,NewValue,RecordDateTime) values(@EmployeeID,'EmployeeSalary',@OldSalary,@EmployeeSalary,GETDATE())
end
--before update--
select * from Employees;
Select * from Employee_History;
--after update--
update Employees set EmployeeName='Ask' where EmployeeID=1
update Employees set EmployeeSalary='40000' where EmployeeID=1

--create trigger after/for delete--
create trigger [dbo].[trgafterdelete] on [dbo].[Employees]
after delete
as
declare @EmployeeID int;
declare @EmployeeName varchar(50);
declare @EmployeeSalary bigint;
declare @DateOfBirth date;
declare @Experience int;
declare @Age int;

select @EmployeeID=Employees.EmployeeID from deleted Employees;
select @EmployeeName=Employees.EmployeeName from deleted Employees;
select @EmployeeSalary=Employees.EmployeeSalary from deleted Employees;
select @DateOfBirth=Employees.DateOfBirth from deleted Employees;
select @Experience=Employees.Experience from deleted Employees;
select @Age=Employees.Age from deleted Employees;

insert into Employee_Backup values(@EmployeeID,@EmployeeName,@EmployeeSalary,@DateOfBirth,@Experience,@Age)
print 'Employee details are inserted successfully backedup'
--before delete--
select * from Employees;
select * from Employee_Backup;
--after delete--
Delete from Employees where EmployeeID=5;
--
select * from Employees;
select * from Employee_Backup;




