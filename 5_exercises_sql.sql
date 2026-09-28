-- #1
UPDATE pet
	SET Age = TIMESTAMPDIFF(YEAR, Birthdate, CURDATE());
    
-- #2
SELECT PetName, COUNT(DV.PetID) AS NumberofVisits
FROM pet P
JOIN doctorvisit DV ON P.PetID = DV.PetID
GROUP BY PetName
HAVING NumberofVisits > 1;

-- #3
SELECT OwnerName, COUNT(P.Owner) AS NumberofPetsOwned
FROM pet P
JOIN owner O ON P.Owner = O.Owner
GROUP BY OwnerName;

-- #4
SELECT PetID, PetName, PetType, Breed, Birthdate, Age, Sex, FurColor, Weight, OwnerName
FROM pet P
JOIN owner O ON P.Owner = O.Owner
WHERE Address LIKE '%Manila%'
ORDER BY Age DESC;

-- #5
SELECT PetName, DateofVisit, ProcedureName
FROM pet P
JOIN doctorvisit DV ON P.PetID = DV.PetID
JOIN proc PR ON DV.Procedure = PR.ProcCode
WHERE procedurename NOT LIKE '%Neutering%';

-- #6
SELECT PetName, SUM(Fee) AS TotalAmountPaid
FROM pet P
JOIN doctorvisit DV ON P.PetID = DV.PetID
JOIN proc PR ON DV.Procedure = PR.ProcCode
GROUP BY PetName
ORDER BY TotalAmountPaid DESC;

-- #7
SELECT PetName, Age
FROM pet P
JOIN doctorvisit DV ON P.PetID = DV.PetID
JOIN proc PR ON DV.Procedure = PR.ProcCode
WHERE ProcedureName LIKE '%Neutering%';

-- #8
SELECT PetName, DateofVisit AS DateVaccinated
FROM pet P
JOIN doctorvisit DV ON P.PetID = DV.PetID
JOIN proc PR ON DV.Procedure = PR.ProcCode
WHERE procedurename LIKE '%rabies%' AND YEAR(DateofVisit) < CURDATE();

-- #9
SELECT PetName, COUNT(DV.Procedure) AS VaccFreq
FROM pet P
JOIN doctorvisit DV ON P.PetID = DV.PetID
JOIN proc PR ON DV.Procedure = PR.ProcCode
WHERE DV.Procedure = 'RAV'
GROUP BY PetName
HAVING VaccFreq = 2;

-- #10
SELECT OwnerName, GROUP_CONCAT(CONCAT_WS(', ', PetName, Breed, Age) SEPARATOR ' | ') AS PetsOwned
FROM pet P
JOIN owner O ON P.Owner = O.Owner
GROUP BY OwnerName;
