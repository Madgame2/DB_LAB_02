use ForeignWorld_DB;

CREATE INDEX IDX_Users_Email
ON Users(email);

CREATE INDEX IDX_Homework_Course
ON Homework(curseId);

CREATE INDEX IDX_Schedule_Course
ON Schedule(curseID);

CREATE INDEX IDX_StudentComplition_Task
ON StydentComplition(TaskID);



--VIEWS
go

CREATE VIEW View_CoursesWithTeachers
AS
SELECT 
    c.id,
    c.curseName,
    u.first_name,
    u.surname
FROM Courses c
JOIN TeacherInCourse tc ON tc.CourseId = c.id
JOIN Users u ON u.id = tc.TeachId;

go

CREATE VIEW View_StudentHomework
AS
SELECT
    u.id as StudentID,
    u.first_name,
    h.Tittle,
    sc.Status,
    sc.Mark
FROM StydentComplition sc
JOIN Users u ON u.id = sc.StudId
JOIN Homework h ON h.id = sc.TaskID;

go

CREATE VIEW View_StudentCourses
AS
SELECT
    u.first_name,
    u.surname,
    c.curseName
FROM StudentInCourse sc
JOIN Users u ON u.id = sc.StudId
JOIN Courses c ON c.id = sc.CourseId;


--TRIGGERS
go


CREATE TRIGGER TR_AddHomeworkForStudents
ON Homework
AFTER INSERT
AS
BEGIN

INSERT INTO StydentComplition (StudId, TaskID, Status)
SELECT
    sc.StudId,
    i.id,
    1
FROM inserted i
JOIN StudentInCourse sc ON sc.CourseId = i.curseId;

END

go


CREATE TRIGGER TR_PreventDeleteUser
ON Users
INSTEAD OF DELETE
AS
BEGIN

UPDATE Users
SET isDeleted = 1
WHERE id IN (SELECT id FROM deleted)

END