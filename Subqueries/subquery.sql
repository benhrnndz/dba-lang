-- EXERCISE --

-- 1. List the name and school of the first 5 students 
-- who got who scored higher than the average score?
SELECT Name, School
FROM examinee
WHERE score > (
	SELECT AVG(score)
    FROM examinee)
ORDER BY score DESC
LIMIT 5;

-- Checking
SELECT AVG(score)
    FROM examinee;
    
-- 2. List the name and school of the examinees 
-- from Manila who got the 3 lowest scores.
SELECT Name, School
FROM examinee
WHERE Address LIKE '%Manila%'
	AND score IN (
		SELECT * FROM (
			SELECT DISTINCT score
			FROM examinee
			ORDER BY score
            LIMIT 3
		) AS LowScores
	);

-- Checking
SELECT DISTINCT score
FROM examinee
ORDER BY score
LIMIT 3;

-- 3. How many schools made it to the top 3 (distinct schools)
SELECT COUNT(DISTINCT School) AS 'Top Schools'
FROM examinee
WHERE score IN (SELECT * FROM (
    SELECT DISTINCT(score)
    FROM examinee
    ORDER BY score DESC
    LIMIT 3) AS Top3); 
    
-- Checking
SELECT DISTINCT(score)
FROM examinee
ORDER BY score DESC
LIMIT 3;

-- 4. Count the number of students per school who
-- made it to the top 3 eg. UP 3, ADMU 3, PUP 2, UST 2
SELECT School, COUNT(Name) AS 'Student Count'
FROM examinee
WHERE School IN (
	SELECT DISTINCT School
	FROM examinee
	WHERE score IN (
		SELECT * FROM (
			SELECT DISTINCT(score)
			FROM examinee
			ORDER BY score DESC
			LIMIT 3) AS Top3
		)
	)
GROUP BY School;

-- Another variation
SELECT e.School, COUNT(*) AS 'Student Count'
FROM examinee e
JOIN (
    SELECT DISTINCT School
    FROM examinee
    WHERE score IN (
        SELECT * FROM (
            SELECT DISTINCT score
            FROM examinee
            ORDER BY score DESC
            LIMIT 3
        ) AS Top3
    )
) AS ts ON e.School = ts.School
GROUP BY e.School;

-- 5. Name all examinees who got the 3rd highest score
-- Research on OFFSET to be used with LIMIT)
SELECT Name, Score
FROM examinee
WHERE Score = (
	SELECT DISTINCT Score
    FROM examinee
    ORDER BY Score DESC
    LIMIT 1 OFFSET 2);
    
-- Checking
SELECT DISTINCT Score
FROM examinee
ORDER BY Score DESC;