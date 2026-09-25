SELECT *
FROM employee0;

SELECT EmpNo, EmpName, Salary
FROM employee0
WHERE JobLevel IN ('SE','SSclientclientclientE','TL')
	AND Salary > 50000;
    
SELECT *
FROM employee0
ORDER BY hiredate;

SELECT EmpNo, empname, salary, joblevel
FROM employee0
WHERE estatus = 'R'
ORDER BY salary DESC;

SELECT empno, empname, salary, joblevel
FROM employee0
ORDER BY joblevel ASC, salary DESC;

SELECT empname, hiredate, salary  
FROM employee0
WHERE estatus = 'R'
	AND YEAR(hiredate) BETWEEN 2015 AND 2018;
    
SELECT *
FROM employee0
WHERE deptcode = 'OPN'
	AND salary BETWEEN 40000 AND 60000;
    
SELECT empname
FROM employee0
WHERE empname LIKE 'A%N';

SELECT *
FROM employee0
WHERE DeptCode IN ('OPN','SAL','FIN')
ORDER BY DeptCode ASC, salary DESC;

    



