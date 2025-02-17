USE PYSAZ;


DELIMITER //
CREATE PROCEDURE IF NOT EXISTS calculateCartPrice(
    IN ID INT,
    IN Cart_number INT,
    IN Locked_number INT,
    OUT Total_price INT
)
BEGIN 

    SELECT SUM(Quantity * Cart_price) INTO @price
    FROM ADDED_TO   
    WHERE ADDED_TO.ID = ID 
        AND ADDED_TO.Cart_number = Cart_number
        AND ADDED_TO.Locked_number = Locked_number;

    -- Applying discounts iteratively
    SELECT
        @price := (
            CASE 
                WHEN DISCOUNT_CODE.Code_limit IS NULL THEN @price - DISCOUNT_CODE.Amount
                ELSE
                    CASE
                        WHEN (@price * DISCOUNT_CODE.Amount / 100) <= DISCOUNT_CODE.Code_limit THEN
                            @price - (@price * DISCOUNT_CODE.Amount / 100)
                        ELSE @price - DISCOUNT_CODE.Code_limit
                    END
            END
        )
    FROM DISCOUNT_CODE
    NATURAL JOIN APPLIED_TO
    WHERE APPLIED_TO.ID = ID 
        AND APPLIED_TO.Cart_number = Cart_number
        AND APPLIED_TO.Locked_number = Locked_number
    ORDER BY APPLIED_TO.Timestamp;

    SET Total_price = @price;
    
END //
DELIMITER ;
    


