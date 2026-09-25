SELECT *
FROM sporting_goods;

-- #1
SELECT Region,
       GROUP_CONCAT(LastName ORDER BY LastName SEPARATOR ', ') AS LastNames
FROM sporting_goods
GROUP BY Region
ORDER BY Region;

-- 2
SELECT Region, COUNT(EmpID) AS SalesmenCount
FROM sporting_goods
WHERE (Qtr1 + Qtr2 + Qtr3) / 3 BETWEEN 200000 AND 300000
GROUP BY Region;

SELECT EmpID, `LastName`, Region,
       (Qtr1 + Qtr2 + Qtr3) / 3 AS AvgSales
FROM sporting_goods
ORDER BY AvgSales DESC;

-- #3
SELECT CONCAT_WS(' ', FirstName, LastName) AS FullName, Region, (Qtr1+Qtr2+Qtr3) / 3 AS AvgSales
FROM sporting_goods
WHERE (Qtr1+Qtr2+Qtr3) / 3 BETWEEN 200000 AND 300000
ORDER BY FullName;

-- #4
SELECT CONCAT_WS(' ', FirstName, LastName, ' Nominee') AS Names, Qtr1, Qtr2
FROM sporting_goods
WHERE Qtr2 > Qtr1
ORDER BY Names;

-- #5
UPDATE sporting_goods
SET Yrs_Service = TIMESTAMPDIFF(YEAR, Date_hired, CURDATE());

SELECT CONCAT_WS(' ', FirstName, LastName) AS FullName, 
	FORMAT((Qtr1 + Qtr2 + Qtr3),2) AS Sum_Sales, 
    Yrs_Service
FROM sporting_goods
WHERE Yrs_Service >= 25;

-- #6
SELECT Region, COUNT(EmpID)
FROM sporting_goods
WHERE Qtr1 > Qtr2
	AND Qtr2 > Qtr3
GROUP BY Region;

-- #7
SELECT CONCAT_WS(' ', FirstName, LastName) AS FullName,
	CASE
		WHEN (Qtr1+Qtr2+Qtr3) / 3 >= 500000 THEN 'For Promotion as regional head'
        WHEN (Qtr1+Qtr2+Qtr3) / 3 BETWEEN 200000 AND 499999 THEN 'For Promotion as state head'
        WHEN Qtr1<Qtr2 AND Qtr2<Qtr3 THEN 'For 100% Bonus'
        WHEN Qtr2>Qtr1 AND (Qtr3<Qtr2 AND Qtr3>Qtr1) THEN 'For 50% Bonus'
        WHEN Qtr2>Qtr1 AND Qtr3<Qtr1 THEN 'For continued probation'
        WHEN Qtr1>Qtr2 AND Qtr2>Qtr3 THEN 'For contract termination'
        ELSE 'No Remark'
	END AS Remarks
FROM sporting_goods;

-- #8
SELECT CONCAT_WS(' ', FirstName, LastName) AS FullName, 
	Date_hired, 
	IF((MONTH(Date_hired) BETWEEN 10 AND 12) 
		AND (YEAR(Date_hired) >= 2005), Salary + (Salary*0.10), Salary) AS Updated_Salary
FROM sporting_goods;

-- #9
SELECT Region, YEAR(Date_hired), COUNT(EmpID)
FROM sporting_goods
GROUP BY Region, YEAR(Date_hired)
ORDER BY Region;


