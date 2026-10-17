-- #1 1.	Combine in a result set , the names and the score of all who took  ITIL ,or PMP certification, 
-- or both. If a person took  both exams, then her name should appear twice in the list, together with her scores in both exams.    
SELECT Sname, Score 
FROM itil I
UNION ALL
SELECT Sname, Score 
FROM pmp
ORDER BY Sname;

-- #2 List all who took both exams, name only.
SELECT Sname
FROM itil
INTERSECT
SELECT Sname
FROM pmp
ORDER BY Sname;

-- #3	List all passers of both exams (name only).  
-- The passing score is 60 for PMP and 50 for ITIL.  
SELECT Sname
FROM itil
WHERE Score >= 50
INTERSECT
SELECT Sname
FROM pmp
WHERE Score >= 60
ORDER BY Sname;

-- #4	List the names of all who took ITIL but 
-- who did not take PMP exam.
SELECT Sname
FROM itil
EXCEPT
SELECT Sname
FROM pmp;

-- #5 List the names of all who took PMP but 
-- who did not take ITIL exam.
SELECT Sname
FROM pmp
EXCEPT
SELECT Sname
FROM itil;

-- #6 List all who passed ITIL but who failed the PMP exam.
SELECT Sname
FROM itil
WHERE Score >= 50
INTERSECT
SELECT Sname
FROM pmp
WHERE Score < 60
ORDER BY Sname;

-- #7 List all who passed PMP but who failed the ITIL exam.  
SELECT Sname
FROM pmp
WHERE Score >= 60
INTERSECT
SELECT Sname
FROM itil 
WHERE Score < 50
ORDER BY Sname;

-- #8 List all who passed ITIL but who did not 
-- take the  PMP exam.
SELECT Sname 
FROM itil
WHERE score >= 50
EXCEPT
SELECT Sname FROM PMP
ORDER BY Sname;

-- #9.	List all names (with score) 
--  who got the same score in both exams. 
SELECT Sname, Score
FROM itil
INTERSECT
SELECT Sname, Score
FROM pmp;



