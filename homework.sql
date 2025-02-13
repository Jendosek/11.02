create database AcademyBD;
go
use AcademyBD;
go

create table Departments
(
    DepartmentID int primary key identity(1,1),
    DepartmentFinancing money not null check(DepartmentFinancing >= 0) default 0,
    DepartmentName nvarchar(100) not null check (DepartmentName <> '') unique,
    FacultyID int foreign key references Faculties(FacultyID)
);
go

create table Faculties
(
    FacultyID int primary key identity(1,1),
    FacultyName nvarchar(100) not null check (FacultyName <> '') unique,
);
go

create table Groups
(
    GroupID int primary key identity(1,1),
    GroupName nvarchar(100) not null check (GroupName <> '') unique,
    GroupYear int not null check (GroupYear between 1 and 5),
    DepartmentID int foreign key references Departments(DepartmentID)
);
go

create table GroupsLectures
(
    GroupsLecturesID int primary key identity(1,1),
    GroupID int foreign key references Groups(GroupID),
    LectureID int foreign key references Lectures(LectureID)
);
go

create table Lectures
(
    LectureID int primary key identity(1,1),
    LectureDayOfWeek int not null check (LectureDayOfWeek between 1 and 7),
    LectureRoom nvarchar(100) not null check (LectureRoom <> ''),
    SubjectId int foreign key references Subjects(SubjectId),
    TeacherId int foreign key references Teachers(TeacherId)
);
go

create table Subjects
(
    SubjectId int primary key identity(1,1),
    SubjectName nvarchar(100) not null check (SubjectName <> '') unique,
);
go

create table Teachers
(
    TeacherId int primary key identity(1,1),
    TeacherName nvarchar(100) not null check (TeacherName <> ''),
    TeacherSurname nvarchar(100) not null check (TeacherSurname <> ''),
    TeacherSalary money not null check (TeacherSalary >= 0) default 0
);
go

insert into Departments(DepartmentName, DepartmentFinancing, FacultyID) values
('Department1', 100000, 1),
('Department2', 200000, 2),
('Department3', 300000, 3),
('Department4', 400000, 4),
('Department5', 500000, 5);
go

insert into Faculties(FacultyName) values
('Faculty1'),
('Faculty2'),
('Faculty3'),
('Faculty4'),
('Faculty5');
go

insert into Groups(GroupName, GroupYear, DepartmentID) values
('Group6', 1, 1),
('Group7', 2, 2),
('Group8', 3, 3),
('Group9', 4, 4),
('Group10', 5, 5);
go

insert into Subjects(SubjectName) values
('Subject6'),
('Subject7'),
('Subject8'),
('Subject9'),
('Subject10');
go

insert into Teachers(TeacherName, TeacherSurname, TeacherSalary) values
('Teacher1', 'TeacherSurname1', 1000),
('Teacher2', 'TeacherSurname2', 2000),
('Teacher3', 'TeacherSurname3', 3000),
('Teacher4', 'TeacherSurname4', 4000),
('Teacher5', 'TeacherSurname5', 5000);
go

insert into Lectures(LectureDayOfWeek, LectureRoom, SubjectId, TeacherId) values
(1, 'Room1', 1, 1),
(2, 'Room2', 2, 2),
(3, 'Room3', 3, 3),
(4, 'Room4', 4, 4),
(5, 'Room5', 5, 5);
go

insert into GroupsLectures(GroupID, LectureID) values
(6, 1),
(7, 2),
(8, 3),
(9, 4),
(10, 5);
go

select * from Departments;
select * from Faculties;
select * from Groups;
select * from GroupsLectures;
select * from Lectures;
select * from Subjects;
select * from Teachers;

select count(TeacherId) as TeachersCount from Teachers
join Departments on TeacherId = DepartmentID
where DepartmentName = 'Department1';
go

select count (LectureID) as LecturesCount from Lectures
join Teachers on Lectures.TeacherId = Teachers.TeacherId
where TeacherName = 'Teacher1' and TeacherSurname = 'TeacherSurname1';
go

select count (LectureID) as LecturesCount from Lectures
where LectureRoom = 'Room1';
go

select LectureRoom, count(LectureID) as LecturesCount from Lectures
group by LectureRoom;
go

select count(distinct GroupsLectures.GroupID) as StudentsCount from Lectures
join Teachers on Lectures.TeacherId = Teachers.TeacherId
join GroupsLectures on Lectures.LectureID = GroupsLectures.LectureID
join Groups on GroupsLectures.GroupID = Groups.GroupID
where Teachers.TeacherName = 'Jack' and Teachers.TeacherSurname = 'Underhill';
go

select avg(TeacherSalary) as AverageSalary from Teachers
join Departments on Teachers.TeacherId = Departments.DepartmentID
join Faculties on Departments.FacultyID = Faculties.FacultyID
where Faculties.FacultyName = 'Computer Science';
go

select min(StudentCount) as MinStudents, max(StudentCount) as MaxStudents from (
    select count(GroupsLectures.GroupID) as StudentCount
    from GroupsLectures
    group by GroupsLectures.GroupID
) as GroupStudentCounts;
go

select avg(DepartmentFinancing) as AverageFinancing
from Departments;
go

select concat(TeacherName, ' ', TeacherSurname) as FullName, count(distinct SubjectId) as SubjectsCount from Teachers
join Lectures on Teachers.TeacherId = Lectures.TeacherId
group by concat(TeacherName, ' ', TeacherSurname);
go

select LectureDayOfWeek, count(LectureID) as LecturesCount from Lectures
group by LectureDayOfWeek;
go

select LectureRoom, count(distinct Departments.DepartmentID) as DepartmentsCount from Lectures
join Teachers on Lectures.TeacherId = Teachers.TeacherId
join Departments on Teachers.TeacherId = Departments.DepartmentID
group by LectureRoom;
go

select Faculties.FacultyName, count(distinct Lectures.SubjectId) as SubjectsCount from Faculties
join Departments on Faculties.FacultyID = Departments.FacultyID
join Teachers on Departments.DepartmentID = Teachers.TeacherId
join Lectures on Teachers.TeacherId = Lectures.TeacherId
group by Faculties.FacultyName;
go

select concat(Teachers.TeacherName, ' ', Teachers.TeacherSurname) as TeacherFullName, Lectures.LectureRoom, count(Lectures.LectureID) as LecturesCount from Lectures
join Teachers on Lectures.TeacherId = Teachers.TeacherId
group by concat(Teachers.TeacherName, ' ', Teachers.TeacherSurname), Lectures.LectureRoom;
go

drop table Departments;
drop table Faculties;
drop table Groups;
drop table GroupsLectures;
drop table Lectures;
drop table Subjects;
drop table Teachers;

use master;
drop database AcademyBD;