-- 4. Copy  Customer_t  to Custhist (history file) using the CREATE…SELECT clause

CREATE TABLE cust_hist
SELECT * FROM customer_t;

-- 5. Delete all data of cust_hist

TRUNCATE TABLE cust_hist;

-- 7. Create a trigger to add to Custhist deleted records from Customer_t.  Name it TR_DelCust

DELIMITER |
CREATE TRIGGER TR_DelCust
	AFTER DELETE
	ON customer_t FOR EACH ROW
BEGIN
	INSERT INTO cust_hist 
	VALUES (cust_id, old.cust_name, old.order_id, old.purchase_amt, old.sman_id, old.purch_date);
END |

-- 8. Create a stored proc (SP_DelCust) that will input the customer id of the record to be deleted from Customer_t
-- Execute the stored proc and and check customer_t and custhist tables

CREATE PROCEDURE SP_DelCust (IN in_cust INT)
	BEGIN
	DELETE FROM customer_t
	WHERE cust_id = in_cust;
	END |

CALL SP_DelCust (29);

-- 9. Revise the stored proc SP_DelCust and use explicit mode.  Commit only the deletion if the purchase was made before year 2020. Otherwise, rollback.
-- Execute the stored proc and and check customer_t and custhist tables

DROP PROCEDURE SP_DelCust;

CREATE PROCEDURE SP_DelCust (IN in_cust INT)
	BEGIN
    
    START TRANSACTION;
    
	DELETE FROM customer_t
	WHERE cust_id = in_cust;
    
	IF purch_date < '2020-01-01' THEN
			COMMIT;
		ELSE
			ROLLBACK;
		END IF;
	END |


