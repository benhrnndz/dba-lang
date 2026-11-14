-- Stored Proc, Multi Tables, Subquery Exercises
-- Tables come from Stored_Proc-Multi_Tables-Subq_Data.xlsx (Student, Course, Program sheets)

-- ---------------------------------------------------------------
-- STORED PROCEDURES (one per exercise)
-- ---------------------------------------------------------------

USE storedproc;

DELIMITER //

-- 1. Enrollees per program for a given AY and sem.
--    One student = one count (COUNT DISTINCT), sorted by count descending.
--    Example: CALL sp_enrollees_per_program('2014-2015', 'S1');
CREATE PROCEDURE sp_enrollees_per_program(IN p_ay VARCHAR(9), IN p_sem VARCHAR(2))
BEGIN
  SELECT s.Program,
         COUNT(DISTINCT c.StudentID) AS EnrolleeCount
  FROM Course c
  JOIN Student s ON s.StudentID = c.StudentID
  WHERE c.AYSem = CONCAT(p_ay, p_sem)
  GROUP BY s.Program
  ORDER BY EnrolleeCount DESC;
END //

-- 2. Enrollees per course/subject for a whole AY (both semesters).
--    Example: CALL sp_enrollees_per_course('2015-2016');
CREATE PROCEDURE sp_enrollees_per_course(IN p_ay VARCHAR(9))
BEGIN
  SELECT c.CourseCode,
         p.Description,
         COUNT(DISTINCT c.StudentID) AS EnrolleeCount
  FROM Course c
  JOIN Student s ON s.StudentID = c.StudentID
  LEFT JOIN Program p ON p.Program = s.Program AND p.CourseCode = c.CourseCode
  WHERE c.AYSem LIKE CONCAT(p_ay, 'S%')
  GROUP BY c.CourseCode, p.Description
  ORDER BY EnrolleeCount DESC, c.CourseCode;
END //

-- 3. Students who exceeded the allowed tenure (years in school).
--    Not graduated; years in residence = current year - year admitted.
--    Example: CALL sp_exceeded_tenure(4);
CREATE PROCEDURE sp_exceeded_tenure(IN p_tenure INT)
BEGIN
  SELECT s.StudentID,
         s.StudentName,
         s.Program AS Course,
         s.ContactNo
  FROM Student s
  WHERE s.YearGraduated IS NULL
    AND (YEAR(CURDATE()) - CAST(LEFT(s.StudentID, 4) AS UNSIGNED)) > p_tenure
  ORDER BY s.StudentID;
END //

-- 4. Dean's listers for a school year-sem and program (average grade 1.5 or better).
--    Lower grade = better, so average must be <= 1.5.
--    Example: CALL sp_deans_list('2017-2018S1', 'BSCS');
CREATE PROCEDURE sp_deans_list(IN p_aysem VARCHAR(12), IN p_program VARCHAR(10))
BEGIN
  SELECT s.StudentID,
         s.StudentName
  FROM Student s
  WHERE s.Program = p_program
    AND s.StudentID IN (
          SELECT c.StudentID
          FROM Course c
          WHERE c.AYSem = p_aysem
          GROUP BY c.StudentID
          HAVING AVG(c.Grade) <= 1.5
        )
  ORDER BY s.StudentID;
END //

-- 5. Student id and all subjects taken with the grade.
--    Example: CALL sp_student_subjects_grades();]

CREATE PROCEDURE sp_student_subjects_grades()
BEGIN
  SELECT c.StudentID,
         c.CourseCode,
         p.Description,
         c.Grade,
         c.AYSem
  FROM Course c
  LEFT JOIN Student s ON s.StudentID = c.StudentID
  LEFT JOIN Program p ON p.Program = s.Program AND p.CourseCode = c.CourseCode
  ORDER BY c.StudentID, c.AYSem, c.CourseCode;
END //

CALL sp_student_subjects_grades();

USE storedproc;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_latin_honors_candidates //

-- 6. Latin honors candidates: top 3 average grades in a program,
--    excluding anyone with a grade of 5 or any grade worse than 1.75.
CREATE PROCEDURE sp_latin_honors_candidates(IN p_program VARCHAR(10))
BEGIN
  SELECT s.StudentID,
         s.StudentName,
		AVG(DISTINCT c.Grade)
  FROM Student s
  JOIN Course c ON c.StudentID = s.StudentID
  WHERE s.Program = p_program
    AND s.StudentID NOT IN (
          SELECT * FROM 
          (SELECT StudentID
          FROM Course
          WHERE Grade = 5 OR Grade > 1.75) AS inquery
        )
  GROUP BY s.StudentID, s.StudentName
  ORDER BY AVG(c.Grade) DESC
  LIMIT 3;
END //

DELIMITER ;

SELECT s.StudentID,
		s.StudentName,
        AVG(c.Grade)
FROM Student s
JOIN Course c ON c.StudentID = s.StudentID
WHERE s.Program = p_program
	AND (SELECT AVG(c.Grade)
  FROM Student s
  JOIN Course c ON c.StudentID = s.StudentID
  GROUP BY s.StudentID, s.StudentName
  ORDER BY AVG(c.Grade) ASC);