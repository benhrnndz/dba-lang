SELECT *
FROM student1;

ALTER TABLE student1
ADD StudID_Mentor INT;

SELECT *
FROM program;

SELECT S1.StudID,
		S1.StudName,
		S1.StudID_Mentor AS 'Mentor ID',
        S2.StudName AS 'Mentor Name',
        P.Description,
        TIMESTAMPDIFF(YEAR, S1.DateAdmitted, CURDATE()) AS 'Years Stayed'
FROM hands_on.student1 AS S1
LEFT JOIN hands_on.student1 AS S2 ON S1.StudID_Mentor = S2.StudID
JOIN program P ON P.ProgramCode = S1.Program;