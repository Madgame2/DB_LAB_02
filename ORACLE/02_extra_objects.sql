
CREATE INDEX IDX_USERS_EMAIL
ON Users(email);

CREATE INDEX IDX_HOMEWORK_COURSE
ON Homework(curseId);

CREATE INDEX IDX_SCHEDULE_COURSE
ON Schedule(curseID);

CREATE INDEX IDX_STUDENTCOMPLITION_TASK
ON StydentComplition(TaskID);

CREATE INDEX IDX_STUDENTINCOURSE_STUDENT
ON StudentInCourse(StudId);

CREATE INDEX IDX_TEACHERINCOURSE_TEACHER
ON TeacherInCourse(TeachId);








CREATE VIEW V_CourseStudents AS
SELECT 
    c.id AS course_id,
    c.curseName,
    u.id AS student_id,
    u.first_name,
    u.surname,
    u.email
FROM StudentInCourse sc
JOIN Users u ON sc.StudId = u.id
JOIN Courses c ON sc.CourseId = c.id;


CREATE VIEW V_CourseHomework AS
SELECT 
    c.curseName,
    h.id,
    h.Tittle,
    h.description,
    h.DateOfBegin
FROM Homework h
JOIN Courses c ON h.curseId = c.id;


CREATE VIEW V_StudentHomeworkStatus AS
SELECT
    u.first_name,
    u.surname,
    h.Tittle,
    sc.Status,
    sc.Mark,
    sc.StudentWork
FROM StydentComplition sc
JOIN Users u ON sc.StudId = u.id
JOIN Homework h ON sc.TaskID = h.id;






CREATE OR REPLACE TRIGGER TRG_PreventUserDelete
BEFORE DELETE ON Users
FOR EACH ROW
BEGIN
    UPDATE Users
    SET isDeleted = 1
    WHERE id = :OLD.id;

    RAISE_APPLICATION_ERROR(-20002, 'User cannot be deleted, only marked as deleted');
END;
/