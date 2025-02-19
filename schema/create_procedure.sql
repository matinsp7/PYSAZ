USE PYSAZ;


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


DELIMITER //

CREATE PROCEDURE IF NOT EXISTS calculateCartPrice(
    IN ID INT,
    IN Cart_number INT,
    IN Locked_number INT,
    OUT Total_price INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE discount_amount DECIMAL(10, 2);
    DECLARE code_limit DECIMAL(10, 2);
    DECLARE cur CURSOR FOR

        SELECT DISCOUNT_CODE.Amount, DISCOUNT_CODE.Code_limit
        FROM DISCOUNT_CODE
        NATURAL JOIN APPLIED_TO
        WHERE APPLIED_TO.ID = ID
            AND APPLIED_TO.Cart_number = Cart_number
            AND APPLIED_TO.Locked_number = Locked_number
        ORDER BY APPLIED_TO.Timestamp;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Initialize the total price
    SELECT SUM(Quantity * Cart_price) INTO @price
    FROM ADDED_TO
    WHERE ADDED_TO.ID = ID
        AND ADDED_TO.Cart_number = Cart_number
        AND ADDED_TO.Locked_number = Locked_number;

    -- Open the cursor to apply discounts
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO discount_amount, code_limit;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Apply the discount
        IF code_limit IS NULL THEN
            SET @price = @price - discount_amount;
        ELSE 
            IF (@price * discount_amount / 100) <= code_limit THEN
                SET @price = @price - (@price * discount_amount / 100);
            ELSE
                SET @price = @price - code_limit;
            END IF;
        END IF;
    END LOOP;

    CLOSE cur;

    -- Set the output variable
    SET Total_price = @price;
END //

DELIMITER ;

