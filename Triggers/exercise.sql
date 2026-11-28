CREATE TABLE room (
	RoomID INT PRIMARY KEY,
    Category CHAR(10) NOT NULL CHECK (Category IN ('single', 'twin', 'studio')),
    RoomDesc VARCHAR(45),
    RoomPrice DECIMAL(10,2) NOT NULL CHECK (RoomPrice >= 0),
    RoomStatus CHAR(2) NOT NULL CHECK (RoomStatus IN ('AV', 'UA'))
);
    
CREATE TABLE trans_t (
	RoomID INT PRIMARY KEY,
    CheckInOut CHAR(3) NOT NULL CHECK (CheckInOut IN ('In', 'Out')),
    CheckInOutDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (RoomID) REFERENCEoom(RoomID)
); 

DELIMITER |

-- 2.1 If the transaction is a check-in  (checkinout = ‘In’) the room status must be automatically updated to UA (unavailable)

DROP TRIGGER IF EXISTS upd_rec_in; |
DROP TRIGGER IF EXISTS upd_rec_out; |

CREATE TRIGGER upd_rec_inout
	AFTER INSERT 
    ON trans_t FOR EACH ROW
BEGIN
	IF NEW.CheckInOut = 'In' THEN
		UPDATE room 
        SET RoomStatus = 'UA'
        WHERE RoomID = NEW.RoomID;
	ELSE 
		UPDATE room
        SET RoomStatus = 'AV'
        WHERE RoomID = NEW.RoomID;
	END IF;
END |

DROP PROCEDURE IF EXISTS SP_InTrans; |

CREATE PROCEDURE SP_InTrans (
	IN in_room INT,
    IN in_cio CHAR(3), 
    IN in_ciod DATE)
BEGIN
	DECLARE v_status CHAR(3);
		
	IF in_cio = 'In' THEN
		SELECT RoomStatus INTO v_status
        FROM room
        WHERE RoomID = in_room;
        
        IF v_status = 'AV' THEN
			INSERT INTO trans_t (RoomID, CheckInOut, CheckInOutDate)
            VALUES (in_room, in_cio, in_ciod);
            
            SELECT CONCAT('Room ID ', in_room, ' has been booked.') AS Message;
		ELSE
			SELECT CONCAT('Room ID ', in_room, ' is not available. Please book another room.') AS Message;
		END IF;
	ELSE
		SELECT RoomStatus INTO v_status
        FROM room
        WHERE RoomID = in_room;
        
        IF v_status = 'UA' THEN 
			INSERT INTO trans_t (RoomID, CheckInOut, CheckInOutDate)
			VALUES (in_room, in_cio, in_ciod);
        
			SELECT CONCAT('Check-out recorded for Room ID ', in_room, '.') AS Message;
		ELSE
			SELECT CONCAT('Room ID ', in_room, ' is already available. No need for a check-out') AS Message;
		END IF;
	END IF;
END |

CALL SP_InTrans(1, '', '2026-11-12'); |
CALL SP_InTrans(2, 'In', '2026-11-13'); |
CALL SP_InTrans(2, 'Out', '2026-11-14'); |
		
