IF NOT EXISTS (
	SELECT NAME from sys.databases where name = 'ForeignWorld_DB'
) BEGIN
	CREATE DATABASE ForeignWorld_DB;
END;

go
use ForeignWorld_DB;

go


-- ENUMS
IF OBJECT_ID('EventTypes', 'U') IS NULL
CREATE TABLE EventTypes (
    id INT PRIMARY KEY,
    type NVARCHAR(125) NOT NULL
);

IF OBJECT_ID('HomeworkExecutionStatuses', 'U') IS NULL
CREATE TABLE HomeworkExecutionStatuses (
    id INT PRIMARY KEY,
    type NVARCHAR(125) NOT NULL
);

IF OBJECT_ID('HomeworkStatuses', 'U') IS NULL
CREATE TABLE HomeworkStatuses (
    id INT PRIMARY KEY,
    status NVARCHAR(125) NOT NULL
);

IF OBJECT_ID('HomeworkTypes', 'U') IS NULL
CREATE TABLE HomeworkTypes (
    id INT PRIMARY KEY,
    type NVARCHAR(125) NOT NULL
);

IF OBJECT_ID('CurseStatuses', 'U') IS NULL
CREATE TABLE CurseStatuses (
    id INT PRIMARY KEY,
    status NVARCHAR(125) NOT NULL
);


-- MAIN
IF OBJECT_ID('Users', 'U') IS NULL
CREATE TABLE Users(
    id INT PRIMARY KEY,
    first_name NVARCHAR(125) NOT NULL,
    surname NVARCHAR(125) NOT NULL,
    father_name NVARCHAR(125),
    email NVARCHAR(256) NOT NULL UNIQUE,
    passwordHASH VARBINARY(128) NOT NULL,
    birthDay DATE NOT NULL,
    avatarURI NVARCHAR(512),
    bio NVARCHAR(2000),
    role INT NOT NULL,
    isDeleted BIT
);

IF OBJECT_ID('Courses', 'U') IS NULL
CREATE TABLE Courses(
    id INT PRIMARY KEY,
    Status INT NOT NULL,
    curseName NVARCHAR(256) NOT NULL,
    description NVARCHAR(2000),
    DateOfBegin DATE NOT NULL,
    HeaderURL NVARCHAR(1000),
    price DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_Courses_Status
        FOREIGN KEY (Status)
        REFERENCES CurseStatuses(id)
);

IF OBJECT_ID('Schedule', 'U') IS NULL
CREATE TABLE Schedule(
    id INT PRIMARY KEY,
    eventType INT NOT NULL,
    curseID INT NOT NULL,
    date DATE NOT NULL,
    extraInfo NVARCHAR(2000),

    CONSTRAINT FK_Schedule_EventType
        FOREIGN KEY (eventType)
        REFERENCES EventTypes(id),

    CONSTRAINT FK_Schedule_Course
        FOREIGN KEY (curseID)
        REFERENCES Courses(id)
);

IF OBJECT_ID('Homework', 'U') IS NULL
CREATE TABLE Homework(
    id INT PRIMARY KEY,
    Tittle NVARCHAR(256) NOT NULL,
    description NVARCHAR(2000),
    type INT NOT NULL,
    assigmentLink NVARCHAR(1000) NOT NULL,
    curseId INT NOT NULL,
    Status INT NOT NULL,
    DateOfBegin DATE,

    CONSTRAINT FK_Homework_Type
        FOREIGN KEY (type)
        REFERENCES HomeworkTypes(id),

    CONSTRAINT FK_Homework_Course
        FOREIGN KEY (curseId)
        REFERENCES Courses(id),

    CONSTRAINT FK_Homework_Status
        FOREIGN KEY (Status)
        REFERENCES HomeworkStatuses(id)
);

IF OBJECT_ID('Languages', 'U') IS NULL
CREATE TABLE Languages(
    id INT PRIMARY KEY,
    Lang NVARCHAR(256) NOT NULL,
    LangCode NVARCHAR(5) NOT NULL
);


-- MANY TO MANY

if OBJECT_ID('LangInCureses', 'U') IS NULL
CREATE TABLE LangInCureses
(
    CourseID INT,
    LangID INT,

    CONSTRAINT PK_LangInCureses
        PRIMARY KEY (CourseID, LangID),

    CONSTRAINT FK_LangInCureses_Courses
        FOREIGN KEY (CourseID)
        REFERENCES Courses(id),

    CONSTRAINT FK_LangInCureses_LangID
        FOREIGN KEy (LangID)
        REFERENCES Languages(id)

)

IF OBJECT_ID('StydentComplition', 'U') IS NULL
CREATE TABLE StydentComplition(
    StudId INT NOT NULL,
    TaskID INT NOT NULL,
    Status INT NOT NULL,
    Mark INT,
    Message NVARCHAR(2000),

    CONSTRAINT PK_StydentComplition
        PRIMARY KEY (StudId, TaskID),

    CONSTRAINT FK_StudentComplition_Task
        FOREIGN KEY (TaskID)
        REFERENCES Homework(id),

    CONSTRAINT FK_StudentComplition_User
        FOREIGN KEY (StudId)
        REFERENCES Users(id),

    CONSTRAINT FK_StudentComplition_Status
        FOREIGN KEY (Status)
        REFERENCES HomeworkExecutionStatuses(id)
);

IF OBJECT_ID('MasteredLang', 'U') IS NULL
CREATE TABLE MasteredLang(
    UserId INT NOT NULL,
    LangId INT NOT NULL,
    level NVARCHAR(6) NOT NULL,

    CONSTRAINT PK_masteredLang
        PRIMARY KEY(UserId, LangId),

    CONSTRAINT FK_MasteredLang_User
        FOREIGN KEY (UserId)
        REFERENCES Users(id),

    CONSTRAINT FK_MasteredLang_Lang
        FOREIGN KEY (LangId)
        REFERENCES Languages(id)
);

IF OBJECT_ID('TeacherInCourse', 'U') IS NULL
CREATE TABLE TeacherInCourse (
    TeachId INT NOT NULL,
    CourseId INT NOT NULL,

    CONSTRAINT PK_TeacherInCourse 
        PRIMARY KEY (TeachId, CourseId),

    CONSTRAINT FK_TeacherInCourse_User
        FOREIGN KEY (TeachId)
        REFERENCES Users(id),

    CONSTRAINT FK_TeacherInCourse_Course
        FOREIGN KEY (CourseId)
        REFERENCES Courses(id)
);

IF OBJECT_ID('StudentInCourse', 'U') IS NULL
CREATE TABLE StudentInCourse (
    StudId INT NOT NULL,
    CourseId INT NOT NULL,

    CONSTRAINT PK_StudentInCourse
        PRIMARY KEY (StudId, CourseId),

    CONSTRAINT FK_StudentInCourse_User
        FOREIGN KEY (StudId)
        REFERENCES Users(id),

    CONSTRAINT FK_StudentInCourse_Course
        FOREIGN KEY (CourseId)
        REFERENCES Courses(id)
);