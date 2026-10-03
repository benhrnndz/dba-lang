-- 4.1

ALTER TABLE `dba_exercise2`.`detail2` 
DROP FOREIGN KEY `proc_fk`;

ALTER TABLE `dba_exercise2`.`detail2` 
ADD CONSTRAINT `proc_fk`
  FOREIGN KEY (`ProdCode`)
  REFERENCES `dba_exercise2`.`product` (`ProductCode`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
  
-- 4.2
DELETE FROM product
WHERE ProductCode IN ('FT2', 'FS');

SELECT *
FROM product;

SELECT *
FROM detail2;

-- 4.3
ALTER TABLE `dba_exercise2`.`detail2` 
DROP FOREIGN KEY `invoice_fk`;

ALTER TABLE `dba_exercise2`.`detail2` 
ADD CONSTRAINT `invoice_fk`
  FOREIGN KEY (`InvoiceNo`)
  REFERENCES `dba_exercise2`.`order` (`InvoiceNo`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
  
-- 4.4
DELETE FROM dba_exercise2.order
WHERE InvoiceNo IN ('1', '4');

SELECT *
FROM dba_exercise2.order;

SELECT *
FROM detail2;

-- 4.5
ALTER TABLE dba_exercise2.order
DROP FOREIGN KEY client_fk;

ALTER TABLE dba_exercise2.order
ADD CONSTRAINT `client_fk`
	FOREIGN KEY (`ClientNo`)
    REFERENCES client2 (`ClientNo`)
    ON DELETE SET NULL
    ON UPDATE SET NULL;
    
-- 4.6
DELETE FROM client2
WHERE ClientNo IN ('C2', 'C1');

SELECT *
FROM client;

SELECT *
FROM dba_exercise2.order;

    





