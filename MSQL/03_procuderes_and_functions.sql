CREATE PROCEDURE sp_CreateUser
(
    @first_name NVARCHAR(125),
    @surname NVARCHAR(125),
    @father_name NVARCHAR(125),
    @email NVARCHAR(256),
    @passwordHASH VARBINARY(128),
    @birthDay DATE,
    @role INT
)
AS
BEGIN

INSERT INTO Users
(
first_name,
surname,
father_name,
email,
passwordHASH,
birthDay,
role,
isDeleted
)
VALUES
(
@first_name,
@surname,
@father_name,
@email,
@passwordHASH,
@birthDay,
@role,
0
)

END

go

CREATE PROCEDURE sp_Login
(
    @email NVARCHAR(256)
)
AS
BEGIN

SELECT
id,
passwordHASH,
role
FROM Users
WHERE email = @email
AND isDeleted = 0

END


go

CREATE PROCEDURE sp_CreateCourse
(
    @Status INT,
    @curseName NVARCHAR(256),
    @description NVARCHAR(2000),
    @DateOfBegin DATE,
    @HeaderURL NVARCHAR(1000),
    @price DECIMAL(10,2)
)
AS
BEGIN

INSERT INTO Courses
(
Status,
curseName,
description,
DateOfBegin,
HeaderURL,
price
)
VALUES
(
@Status,
@curseName,
@description,
@DateOfBegin,
@HeaderURL,
@price
)

END


go

CREATE PROCEDURE sp_GetCourses
AS
BEGIN

SELECT
id,
curseName,
description,
DateOfBegin,
price
FROM Courses
WHERE Status = 1

END

go

CREATE PROCEDURE sp_EnrollStudent
(
    @StudentId INT,
    @CourseId INT
)
AS
BEGIN

INSERT INTO StudentInCourse
(
StudId,
CourseId
)
VALUES
(
@StudentId,
@CourseId
)

END

go

CREATE PROCEDURE sp_CreateHomework
(
    @Tittle NVARCHAR(256),
    @description NVARCHAR(2000),
    @type INT,
    @assigmentLink NVARCHAR(1000),
    @curseId INT,
    @Status INT,
    @DateOfBegin DATE
)
AS
BEGIN

INSERT INTO Homework
(
Tittle,
description,
type,
assigmentLink,
curseId,
Status,
DateOfBegin
)
VALUES
(
@Tittle,
@description,
@type,
@assigmentLink,
@curseId,
@Status,
@DateOfBegin
)

END

go

CREATE PROCEDURE sp_GetCourseHomework
(
    @CourseId INT
)
AS
BEGIN

SELECT
id,
Tittle,
description,
DateOfBegin,
Status
FROM Homework
WHERE curseId = @CourseId

END

go

CREATE PROCEDURE sp_SubmitHomework
(
    @StudentId INT,
    @TaskId INT,
    @StudentWork NVARCHAR(2000),
    @Message NVARCHAR(2000)
)
AS
BEGIN

UPDATE StydentComplition
SET
StudentWork = @StudentWork,
Message = @Message
WHERE
StudId = @StudentId
AND TaskID = @TaskId

END


go

CREATE PROCEDURE sp_CheckHomework
(
    @StudentId INT,
    @TaskId INT,
    @Mark INT
)
AS
BEGIN

UPDATE StydentComplition
SET
Mark = @Mark
WHERE
StudId = @StudentId
AND TaskID = @TaskId

END



go


CREATE FUNCTION fn_GetStudentAverageMark
(
@StudentId INT
)
RETURNS FLOAT
AS
BEGIN

DECLARE @result FLOAT

SELECT @result = AVG(Mark)
FROM StydentComplition
WHERE StudId = @StudentId

RETURN @result

END

go


CREATE FUNCTION fn_GetCourseStudentsCount
(
@CourseId INT
)
RETURNS INT
AS
BEGIN

DECLARE @count INT

SELECT @count = COUNT(*)
FROM StudentInCourse
WHERE CourseId = @CourseId

RETURN @count

END