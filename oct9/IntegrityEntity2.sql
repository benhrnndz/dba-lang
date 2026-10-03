-- 1. List client id, name (first name, mid intial with ‘.’, 
-- last name – concatenated) and his corresponding orders (invoice numbers) 
-- and order date from the order table if the order was made in 2020

SELECT C.ClientNo, 
	CONCAT(TRIM(FirstName), ' ', LEFT(MidName, 1), '.', ' ', Surname) AS FullName, 
	InvoiceNo, 
	OrderDate
FROM client2 C
JOIN dba_exercise2.order O ON C.ClientNo = O.ClientNo
WHERE YEAR(OrderDate) = 2020;

-- 2. List the client id and the products   (product code only)  
-- with order qty  ordered by each client

SELECT C.ClientNo, 
	GROUP_CONCAT(CONCAT_WS(' ', D.ProdCode, D.Quantity) SEPARATOR ' | ') AS ProductsBought
FROM client2 C
JOIN dba_exercise2.order O ON C.ClientNo = O.ClientNo
JOIN detail2 D ON O.InvoiceNo = D.InvoiceNo
GROUP BY C.ClientNo;

-- 3. Display the client id and name of client together with the 
-- invoice corresponding to the client. Display the client info even 
-- if he didn’t make any purchase

SELECT C.ClientNo, 
	CONCAT(TRIM(FirstName), ' ', LEFT(MidName, 1), '.', ' ', Surname) AS FullName, 
    GROUP_CONCAT(O.InvoiceNo SEPARATOR ' | ') AS InvoicesMade
FROM client2 C
LEFT JOIN dba_exercise2.order O ON C.clientno = O.clientno
GROUP BY C.ClientNo;

-- 4 Display client id and all products he purchased (product code only).  
-- Display all product codes even if not puchased by any client.
SELECT C.ClientNo,
	GROUP_CONCAT(D.ProdCode SEPARATOR ' | ') AS PurchasedProducts
FROM Client2 C
JOIN dba_exercise2.order O ON C.ClientNo = O.ClientNo
RIGHT JOIN detail2 D ON O.InvoiceNo = D.InvoiceNo
GROUP BY C.ClientNo;

-- 5. List the client id,  the description of the product ordered 
-- including the unit cost.  Display unique  records only.

SELECT C.ClientNo, P.ProductDescription, D.Quantity
FROM Client2 C
JOIN dba_exercise2.order O ON C.ClientNo = O.ClientNo
JOIN detail2 D ON O.InvoiceNo = D.InvoiceNo
JOIN product P ON D.ProdCode = P.ProductCode
ORDER BY C.ClientNo;

-- 6.
SELECT C.ClientNo, D.InvoiceNo, D.ProdCode, (D.quantity * P.unitcost) AS TotalAmount
FROM Client2 C
JOIN dba_exercise2.order O ON C.ClientNo = O.ClientNo
JOIN detail2 D ON O.InvoiceNo = D.InvoiceNo
JOIN product P ON D.ProdCode = P.ProductCode
GROUP BY D.InvoiceNo, D.ProdCode
ORDER BY ClientNo;

-- 6.1
SELECT C.ClientNo, D.InvoiceNo, SUM(D.quantity * P.unitcost) AS TotalAmountofInvoice
FROM Client2 C
JOIN dba_exercise2.order O ON C.ClientNo = O.ClientNo
JOIN detail2 D ON O.InvoiceNo = D.InvoiceNo
JOIN product P ON D.ProdCode = P.ProductCode
GROUP BY D.InvoiceNo
ORDER BY C.ClientNo;

-- 7. Display the total amount bought by each client  
SELECT C.ClientNo, SUM(D.quantity * P.unitcost) AS TotalAmountBought
FROM Client2 C
JOIN dba_exercise2.order O ON C.ClientNo = O.ClientNo
JOIN detail2 D ON O.InvoiceNo = D.InvoiceNo
JOIN product P ON D.ProdCode = P.ProductCode
GROUP BY C.ClientNo
ORDER BY C.ClientNo;

-- 8. Display client name, credit limit, product bought (description) and
-- the amount for product bought.
SELECT CONCAT(TRIM(FirstName), ' ', LEFT(MidName, 1), '.', ' ', Surname) AS FullName, 
	C.CreditLimit,
    P.ProductDescription,
    P.UnitCost
FROM Client2 C
JOIN dba_exercise2.order O ON C.ClientNo = O.ClientNo
JOIN detail2 D ON O.InvoiceNo = D.InvoiceNo
JOIN product P ON D.ProdCode = P.ProductCode;

-- 9. Display the invoice number and the product details corresponding 
-- to the products bought.  Product details will include all fields in the product table
SELECT D.InvoiceNo, P.ProductCode, P.ProductDescription, P.UnitCost, P.Category
FROM Client2 C
JOIN dba_exercise2.order O ON C.ClientNo = O.ClientNo
JOIN detail2 D ON O.InvoiceNo = D.InvoiceNo
JOIN product P ON D.ProdCode = P.ProductCode
ORDER BY D.InvoiceNo;

-- 10. Count how many invoices each client has and display only 
-- clients with more than 1 invoice.
SELECT C.ClientNo, COUNT(O.InvoiceNo) AS InvoiceCount
FROM Client2 C
JOIN dba_exercise2.order O ON C.ClientNo = O.ClientNo
GROUP BY C.ClientNo
HAVING InvoiceCount > 1;

-- Add ClientMentor column (stores ClientNo of the mentor)
ALTER TABLE Client2
	ADD ClientMentor VARCHAR(5);

-- Add a foreign key so ClientMentor must reference an existing ClientNo
ALTER TABLE Client2
	ADD CONSTRAINT mentor_fk
    FOREIGN KEY (ClientMentor)
    REFERENCES Client2 (ClientNo);

-- Populate ClientMentor for some clients (not all — it's optional)
UPDATE Client2 SET ClientMentor = 'C3' WHERE ClientNo = 'C1';
UPDATE Client2 SET ClientMentor = 'C6' WHERE ClientNo = 'C2';
UPDATE Client2 SET ClientMentor = 'C1' WHERE ClientNo = 'C5';
UPDATE Client2 SET ClientMentor = 'C8' WHERE ClientNo = 'C7';
UPDATE Client2 SET ClientMentor = 'C3' WHERE ClientNo = 'C9';
UPDATE Client2 SET ClientMentor = 'C10' WHERE ClientNo = 'C11';

-- Display client name, client id, mentor id, and mentor name
-- LEFT JOIN so clients without mentors still appear
SELECT 
	C.ClientNo,
    CONCAT(TRIM(C.FirstName), ' ', LEFT(C.MidName, 1), '. ', C.Surname) AS ClientName,
    C.ClientMentor AS MentorID,
    CONCAT(TRIM(M.FirstName), ' ', LEFT(M.MidName, 1), '. ', M.Surname) AS MentorName
FROM Client2 C
LEFT JOIN Client2 M ON C.ClientMentor = M.ClientNo;
