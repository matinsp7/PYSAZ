USE PYSAZ;


DELIMITER //

CREATE PROCEDURE IF NOT EXISTS  calculateCartPrice(
    in ID INT,
    in Cart_number INT,
    in Locked_number INT,
    out Total_price INT
)
BEGIN 
    DECLARE tempPrice INT;

    SELECT SUM(Quantity * Cart_price) into tempPrice
    FROM ADDED_TO   
    where ADDED_TO.ID = ID 
        AND ADDED_TO.Cart_number = Cart_number
        AND ADDED_TO.Locked_number = Locked_number;


        SELECT 
        @fp := (
            CASE 
                WHEN DISCOUNT_CODE.Limt IS NULL THEN @fp - DISCOUNT_CODE.Amount
                ELSE @fp - (@fp * DISCOUNT_CODE.Amount)
            END
        ) AS intermediate_fp
    FROM DISCOUNT_CODE NATURAL JOIN APPLIED_TO, (SELECT @fp := fp) AS init
    ORDER BY APPLIED_TO.Timestamp;

    SET Total_price = @fp;

END //

DELIMITER ;
    


