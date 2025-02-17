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


DELIMITER //
CREATE PROCEDURE IF NOT EXISTS everyMonthBacking15PercentOfShoppingToVipClientsWallet ()
BEGIN 
    DECLARE done INT DEFAULT 0;
    DECLARE v_ID INT;
    DECLARE v_Cart_number INT; 
    DECLARE v_Locked_number INT;
    DECLARE result INT;

    DECLARE userCursor CURSOR FOR
        SELECT ID, Cart_number, Number
        FROM LOCKED_SHOPPING_CART 
        NATURAL JOIN VIP_CLIENTS;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN userCursor;

    userLoop: LOOP
        FETCH userCursor INTO v_ID, v_Cart_number, v_Locked_number;

        IF done = 1 THEN
            LEAVE userLoop;
        END IF;

        CALL calculateCartPrice(v_ID, v_Cart_number, v_Locked_number, result);
        SELECT result AS res;

        -- Debugging: Print the fetched values
        SELECT v_ID, v_Cart_number, v_Locked_number;

        UPDATE CLIENT 
        SET Wallet_balance = Wallet_balance + 0.15 * result
        WHERE CLIENT.ID = v_ID;
    END LOOP;

    CLOSE userCursor;
END //
DELIMITER ;