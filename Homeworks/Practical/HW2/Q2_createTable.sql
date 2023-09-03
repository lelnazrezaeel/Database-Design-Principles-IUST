USE HW2_Q2;

--1)CREATE CLASS TABLE

DROP TABLE IF EXISTS Answers;
DROP TABLE IF EXISTS Score;
DROP TABLE IF EXISTS Scheduler;
DROP TABLE IF EXISTS HomeWorks;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Classes;

CREATE TABLE Classes(
	ClassId INT PRIMARY KEY,
	ClassName NVARCHAR(20) NOT NULL,
	Descriptions TEXT,

	States NVARCHAR(20) NOT NULL,
	--"AC" for active, "NA" for not active, "AR" for archived 
	CONSTRAINT CheckState CHECK (States in ('AC' , 'NA' , 'AR')), 
	
	FirstSession DATE NOT NULL,
	LastSession DATE NOT NULL,
	CONSTRAINT CheckSession CHECK (LastSession > FirstSession),
		
	Grade INT NOT NULL,
	--"1" for first, "2" for second, ....
	CONSTRAINT CheckGrades CHECK (Grade in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)),
	
	TeacherName NVARCHAR(20) NOT NULL,
);

--2)CREATE STUDENT TABLE

CREATE TABLE Students(
	StudentId INT PRIMARY KEY,
	UserName NVARCHAR(20) NOT NULL,
	Passwords INT NOT NULL,
	FirstName NVARCHAR(20) NOT NULL,
	LastName NVARCHAR(20) NOT NULL,
	Email NVARCHAR(50),
	ClassId INT NOT NULL REFERENCES Classes(ClassId),
	BirthDate DATE NOT NULL,
	SSN INT NOT NULL,
	StudentAddress TEXT NOT NULL,
	
	PhoneNumber INT NOT NULL,
	CONSTRAINT CheckPhoneNumber CHECK (PhoneNumber >= 10000000 and PhoneNumber <= 99999999),
);

--3)CREATE TABLE SCHEDULE

CREATE TABLE Scheduler(
	SchedulerId INT  NOT NULL PRIMARY KEY,
	ClassId INT NOT NULL REFERENCES Classes(ClassId) ON DELETE CASCADE,
	Teacher NVARCHAR(20) NOT NULL,

	CourseSubject NVARCHAR(20) NOT NULL,
	--"M" for Math, "P" for Physics, ...
	CONSTRAINT CheckCourse CHECK (CourseSubject in ('M', 'P', 'C', 'B', 'F', 'E', 'A', 'R')),
	
	DayOfWeak1 INT NOT NULL,
	--"1" for saturday, "2" for sunday, ...
	CONSTRAINT CheckDayOfWeak1 CHECK (DayOfWeak1 in (1, 2, 3, 4, 5, 6, 7)),

	DayOfWeak2 INT NOT NULL,
	--"1" for saturday, "2" for sunday, ...
	CONSTRAINT CheckDayOfWeak2 CHECK (DayOfWeak2 in (1, 2, 3, 4, 5, 6, 7)),

	StartingTime TIME NOT NULL,
	FinishingTime TIME NOT NULL,
);

--4)CREATE TABLE HOMEWORKS

CREATE TABLE HomeWorks(
	HomeWorkId INT NOT NULL PRIMARY KEY,
	HomeWorkSubject NVARCHAR(20),
	HomeWorkDescription TEXT,
	FilePath NVARCHAR(500) NOT NULL,
	ClassId INT NOT NULL REFERENCES Classes(ClassId) ON DELETE CASCADE,
	
	CourseSubject NVARCHAR(20) NOT NULL,
	--"M" for Math, "P" for Physics, ...
	CONSTRAINT CheckCourseSubject CHECK (CourseSubject in ('M', 'P', 'C', 'B', 'F', 'E', 'A', 'R')),

	CreateDate DATE NOT NULL,
	DeadlineDate DATE NOT NULL,
	CONSTRAINT CheckDate CHECK (DeadlineDate >= CreateDate),
);

--5)CREATE TABLE ANSWERS

CREATE TABLE Answers(
	AnswersId INT NOT NULL PRIMARY KEY,
	AnswerDescription TEXT,
	FilePath NVARCHAR(500) NOT NULL,
	HomeWorkId INT NOT NULL REFERENCES HomeWorks(HomeWorkId) ON DELETE CASCADE,
	StudentId INT NOT NULL REFERENCES Students(StudentId) ON DELETE CASCADE,
	
	CourseSubject NVARCHAR(20) NOT NULL,
	--"M" for Math, "P" for Physics, ...
	CONSTRAINT CheckCourses CHECK (CourseSubject in ('M', 'P', 'C', 'B', 'F', 'E', 'A', 'R')),
	
	CreateDate DATE NOT NULL,
	
	CONSTRAINT CheckUnique UNIQUE (HomeWorkId, StudentId),
);

--6)CREATE TABLE SCORE

CREATE TABLE Score(
	ScoreId INT NOT NULL PRIMARY KEY,
	HomeWorkId INT NOT NULL REFERENCES HomeWorks(HomeWorkId),
	AnswersId INT NOT NULL REFERENCES Answers(AnswersId) ON DELETE CASCADE,

	CONSTRAINT CheckUniqueness UNIQUE (HomeWorkId, AnswersId),

	Score INT NOT NULL,

	CONSTRAINT CheckScore CHECK (Score>=0 AND Score<=20),
);
GO

--7)CREATE TRIGGER

CREATE TRIGGER AddScore 
ON Answers
AFTER INSERT 
AS
BEGIN
	SET NOCOUNT ON;
        DECLARE @HWId INT,
                @HWAId INT
        SELECT @HWId = inserted.HomeWorkId, @HWAId = INSERTED.AnswersId      
        FROM INSERTED
		INSERT into Score (HomeWorkId, AnswersId, Score) VALUES (@HWId, @HWAId, null)
END 
GO