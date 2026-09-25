SELECT *
FROM client;

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE client
	ADD mobileno VARCHAR(10),
    ADD landline VARCHAR(10),
    ADD email VARCHAR(30);
    
UPDATE client
SET email = CONCAT(LEFT(Surname, 4),
			LEFT(FirstName, 2),
            LEFT(MidName, 1),
            '@gmail.com');
            
SELECT CONCAT(TRIM(FirstName), ' ', LEFT(TRIM(MidName), 1), ' ', UPPER(TRIM(Surname))) AS FullName,
       IF(LEFT(City, 2) = 'Ma', SUBSTRING_INDEX(email, '@', 1), NULL) AS Username
FROM client;

INSERT INTO client (ClientNo, FirstName, MidName, Surname, Street, City, Zip, CreditLimit, mobileno, landline)
VALUES('C12', 'Harold','Odvina', 'Hernandez', 'Arnaiz', 'Makati', '1230', 15500, '9109386678', '2000225');

UPDATE client
SET mobileno = CASE ClientNo
					WHEN 'C1' THEN '9216156134'
					WHEN 'C5' THEN '9309332595'
					ELSE MobileNo
				END
WHERE ClientNo IN ('C1', 'C5');

UPDATE client
SET landline = CASE ClientNo
					WHEN 'C2' THEN '1000512'
                    WHEN 'C3' THEN '1000012'
                    WHEN 'C4' THEN '2000110'
                    WHEN 'C8' THEN '3000990'
                    WHEN 'C9' THEN '4001230'
                    ELSE Landline
				END
WHERE ClientNo IN ('C2','C3','C4','C8','C9');

SELECT CONCAT(TRIM(FirstName), ' ', LEFT(TRIM(MidName), 1), ' ', UPPER(TRIM(Surname))) AS FullName,
	   COALESCE(mobileno, landline, email) AS ContactInfo
FROM client
ORDER BY Surname DESC;

SELECT ClientNo,
	   CONCAT(Street, ',',' ', City,',', ' ', Zip) AS FullAddress,
	   FORMAT(CreditLimit, 2) AS CreditLimit
FROM client
WHERE RIGHT(Zip, 1) IN (1,4)
	AND CreditLimit BETWEEN 55000 AND 90000;