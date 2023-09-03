USE HW2_Q2;

--1)Part 1

GO;
CREATE PROCEDURE ClassesCount 
AS
SELECT COUNT(ClassId) AS ClassesCount FROM Classes

GO;
CREATE PROCEDURE GradesCountAndName
AS
SELECT COUNT(ClassId) AS ClassesCount, Grade FROM Classes GROUP BY Grade

GO;
CREATE PROCEDURE StudentsCount
AS
SELECT COUNT(StudentId) AS StudentsCount FROM Students

--2)Part 2

GO;
CREATE PROCEDURE ScoreOfSpecifyClass
	@InfoId int,
	@HWId int
AS 
SELECT MIN(S.Score) AS mini, MAX(S.Score) AS maxi, AVG(S.Score) AS average, VAR(S.Score) AS varians FROM Classes AS CInfo 
JOIN HomeWorks as HW ON CInfo.ClassId = HW.ClassId JOIN Score as S ON S.HomeWorkId = HW.HomeWorkId
WHERE CInfo.ClassId = @InfoId AND HW.HomeWorkId = @HWId

--3)Part 3
GO;
CREATE PROCEDURE ScoreOfSpecifyHomeWork
	@HWId int
AS
SELECT A.StudentId, S.Score FROM Answers as A JOIN Score AS S ON A.HomeWorkId = S.HomeWorkId
WHERE A.HomeWorkId = @HWId

--4)Part 4
GO;
CREATE PROCEDURE Schedule
	@CId int 
AS 
SELECT S.StudentId, Sc.CourseSubject, Sc.DayOfWeak1, Sc.DayOfWeak2, Sc.StartingTime, Sc.FinishingTime
FROM Scheduler AS Sc JOIN Classes AS C ON Sc.ClassId = C.ClassId JOIN Students AS S ON C.ClassId = S.ClassId
WHERE C.ClassId=@CId
ORDER BY Sc.DayOfWeak1, Sc.DayOfWeak2, Sc.StartingTime