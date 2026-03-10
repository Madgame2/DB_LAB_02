

CREATE OR REPLACE PROCEDURE CreateUser(
    p_first_name NVARCHAR2,
    p_surname NVARCHAR2,
    p_father_name NVARCHAR2,
    p_email NVARCHAR2,
    p_password RAW,
    p_birth DATE,
    p_role NUMBER,
    p_avatar NVARCHAR2 DEFAULT NULL,
    p_bio NVARCHAR2 DEFAULT NULL
)
AS
BEGIN
    INSERT INTO Users(
        first_name,
        surname,
        father_name,
        email,
        passwordHASH,
        birthDay,
        role,
        avatarURI,
        bio
    )
    VALUES(
        p_first_name,
        p_surname,
        p_father_name,
        p_email,
        p_password,
        p_birth,
        p_role,
        p_avatar,
        p_bio
    );
END;
/




CREATE OR REPLACE PROCEDURE CreateCourse(
    p_status NUMBER,
    p_curseName NVARCHAR2,
    p_description NVARCHAR2,
    p_dateOfBegin DATE,
    p_headerURL NVARCHAR2,
    p_price NUMBER
)
AS
BEGIN
    INSERT INTO Courses(
        Status, curseName, description, DateOfBegin, HeaderURL, price
    )
    VALUES(
        p_status, p_curseName, p_description, p_dateOfBegin, p_headerURL, p_price
    );
END;
/



CREATE OR REPLACE PROCEDURE AddStudentToCourse(
    p_student_id NUMBER,
    p_course_id NUMBER
)
AS
BEGIN
    INSERT INTO StudentInCourse(StudId, CourseId)
    VALUES(p_student_id, p_course_id);
END;
/



CREATE OR REPLACE PROCEDURE AddTeacherToCourse(
    p_teacher_id NUMBER,
    p_course_id NUMBER
)
AS
BEGIN
    INSERT INTO TeacherInCourse(TeachId, CourseId)
    VALUES(p_teacher_id, p_course_id);
END;
/


CREATE OR REPLACE PROCEDURE AddLangToCourse(
    p_course_id NUMBER,
    p_lang_id NUMBER
)
AS
BEGIN
    INSERT INTO LangInCureses(CourseID, LangID)
    VALUES(p_course_id, p_lang_id);
END;
/



CREATE OR REPLACE PROCEDURE CreateHomework(
    p_title NVARCHAR2,
    p_description NVARCHAR2,
    p_type NUMBER,
    p_assigmentLink NVARCHAR2,
    p_curseId NUMBER,
    p_status NUMBER,
    p_dateOfBegin DATE
)
AS
BEGIN
    INSERT INTO Homework(
        Tittle, description, type, assigmentLink, curseId, Status, DateOfBegin
    )
    VALUES(
        p_title, p_description, p_type, p_assigmentLink, p_curseId, p_status, p_dateOfBegin
    );
END;
/



CREATE OR REPLACE PROCEDURE SubmitHomework(
    p_student_id NUMBER,
    p_task_id NUMBER,
    p_status NUMBER,
    p_mark NUMBER DEFAULT NULL,
    p_studentWork NVARCHAR2 DEFAULT NULL,
    p_message NVARCHAR2 DEFAULT NULL
)
AS
BEGIN
    INSERT INTO StydentComplition(
        StudId, TaskID, Status, Mark, StudentWork, Message
    )
    VALUES(
        p_student_id, p_task_id, p_status, p_mark, p_studentWork, p_message
    );
END;
/



CREATE OR REPLACE PROCEDURE UpdateHomeworkMark(
    p_student_id NUMBER,
    p_task_id NUMBER,
    p_mark NUMBER
)
AS
BEGIN
    UPDATE StydentComplition
    SET Mark = p_mark
    WHERE StudId = p_student_id AND TaskID = p_task_id;
END;
/




CREATE OR REPLACE FUNCTION GetStudentCount(
    p_course_id NUMBER
) RETURN NUMBER
IS
    cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO cnt
    FROM StudentInCourse
    WHERE CourseId = p_course_id;
    
    RETURN cnt;
END;
/



CREATE OR REPLACE FUNCTION GetStudentAverageMark(
    p_student_id NUMBER,
    p_course_id NUMBER
) RETURN NUMBER
IS
    avgMark NUMBER;
BEGIN
    SELECT AVG(Mark) INTO avgMark
    FROM StydentComplition sc
    JOIN Homework h ON sc.TaskID = h.id
    WHERE sc.StudId = p_student_id AND h.curseId = p_course_id;
    
    RETURN avgMark;
END;
/



CREATE OR REPLACE FUNCTION GetCourseHomework(
    p_course_id NUMBER
) RETURN SYS_REFCURSOR
IS
    cur SYS_REFCURSOR;
BEGIN
    OPEN cur FOR
    SELECT id, Tittle, description, DateOfBegin
    FROM Homework
    WHERE curseId = p_course_id;
    
    RETURN cur;
END;
/