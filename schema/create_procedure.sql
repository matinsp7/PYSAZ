دUSE PYSAZ;


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

    -- Debugging: Print the initial price
    SELECT @price AS initial_price;

    -- Applying discounts iteratively
    SELECT
        @price := (
            CASE 
                WHEN DISCOUNT_CODE.Code_limit IS NULL THEN @price - DISCOUNT_CODE.Amount
                ELSE @price - (@price * DISCOUNT_CODE.Amount / 100)
            END
        ) AS intermediate_price
    FROM DISCOUNT_CODE
    NATURAL JOIN APPLIED_TO
    WHERE APPLIED_TO.ID = ID 
        AND APPLIED_TO.Cart_number = Cart_number
        AND APPLIED_TO.Locked_number = Locked_number
    ORDER BY APPLIED_TO.Timestamp;

    -- Debugging: Print the final discounted price
    SELECT @price AS final_price;

    -- Assign the final price to the output parameter
    SET Total_price = @price;
    
END //
DELIMITER ;
    


