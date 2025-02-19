USE PYSAZ;

-- check if cart is locked can't add to it product

DELIMITER //
CREATE TRIGGER IF NOT EXISTS prevent_insert_if_locked_or_blocked
BEFORE INSERT ON ADDED_TO
FOR EACH ROW
BEGIN
    DECLARE cart_status VARCHAR(20);

    -- Get the status of the shopping cart
    SELECT Status INTO cart_status
    FROM SHOPPING_CART
    WHERE ID = NEW.ID AND Number = NEW.Cart_number;

    -- Check if the status is 'locked' or 'blocked'
    IF cart_status = 'locked' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insert not allowed: Shopping cart is locked';
    END IF;

    IF cart_status = 'blocked' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insert not allowed: Shopping cart is blocked';
    END IF;

END; //
DELIMITER ;


/*
Because the information added to is also used as history,
deleting and updating it is not allowed.
*/
DELIMITER //
CREATE TRIGGER IF NOT EXISTS prevent_ADDED_TO_deletion 
BEFORE DELETE ON ADDED_TO
FOR EACH ROW 
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Deletion not allowed in ADDED_TO';
END; //
DELIMITER ;


DELIMITER //

CREATE TRIGGER IF NOT EXISTS prevent_ADDED_TO_update
BEFORE UPDATE ON ADDED_TO
FOR EACH ROW
BEGIN 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Update not allowed in ADDED_TO';
END; //
DELIMITER ;

/*
The information inside LOCKED_SHOPPING_CART has three states:
either successful payment, blocked, or currently finalized.
In all three states, no data should be deleted from them
(because they are our history in a way).
*/
DELIMITER //

CREATE TRIGGER IF NOT EXISTS prevent_LOCKED_SHOPPING_CART_deletion
BEFORE DELETE ON LOCKED_SHOPPING_CART
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Deletion not allowed: Rows cannot be deleted from LOCKED_SHOPPING_CART';
END; //
DELIMITER ;


DELIMITER //

CREATE TRIGGER IF NOT EXISTS prevent_LOCKED_SHOPPING_CART_update
BEFORE UPDATE ON LOCKED_SHOPPING_CART
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Update not allowed: Rows cannot be updated in LOCKED_SHOPPING_CART';
END; //
DELIMITER ;


-- check maxmimum cart of users

DELIMITER //
CREATE TRIGGER IF NOT EXISTS checkNumberOFCartShop
BEFORE INSERT
ON SHOPPING_CART
FOR EACH ROW
BEGIN
    DECLARE cartNumbers INT;
    DECLARE isVip BOOLEAN;

    IF EXISTS (SELECT 1 FROM VIP_CLIENTS WHERE NEW.ID = ID) THEN
        SET isVip = TRUE;
    ELSE 
        SET isVip = FALSE;
    END IF;

    SELECT COUNT(*) INTO cartNumbers
    FROM SHOPPING_CART
    WHERE ID = NEW.ID and (Status = 'active' or Status = 'locked' or Status = 'blocked');

    IF (cartNumbers >= 1 and isVip = FALSE) or (cartNumbers >= 5) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'your limit of shopping cart exceeded!';
    END IF;
END; //
DELIMITER ;


DELIMITER //
CREATE TRIGGER IF NOT EXISTS prevent_shopping_cart_deletion
BEFORE DELETE ON SHOPPING_CART
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Deletion not allowed: Rows cannot be deleted from SHOPPING_CART';
END; //
DELIMITER ;


DELIMITER //
/*
The inventory should not be less than the requested amount.
when a product added to ADDED_TO table stock_count of products decreases.
*/
CREATE TRIGGER IF NOT EXISTS checkQuantity
BEFORE INSERT
ON ADDED_TO
FOR EACH ROW
BEGIN
    DECLARE product_count INT;

    SELECT Stock_count INTO product_count
    FROM PRODUCT
    WHERE PRODUCT.ID = NEW.PRODUCT_ID; 

    IF NEW.Quantity > product_count THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: you can not choose more than stock_count! ';
    END IF;

    UPDATE PRODUCT
    SET Stock_count = Stock_count - NEW.Quantity
    WHERE ID = NEW.PRODUCT_ID;
END; //
DELIMITER ;


-- check Expirationdata of discount codes
DELIMITER //
CREATE TRIGGER IF NOT EXISTS checkDiscountCodeExpiration
BEFORE INSERT 
ON APPLIED_TO
FOR EACH ROW
BEGIN
    DECLARE codeExpiration date;

    SELECT Expiration_date INTO codeExpiration
    FROM DISCOUNT_CODE
    WHERE Code = NEW.Code;

    IF NOW() > codeExpiration THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'you can not use from this code because this code has expired!';
    END IF;
END; //
DELIMITER ;

-- check Usage_count of discount codes
DELIMITER //
CREATE TRIGGER IF NOT EXISTS checkDiscountCodeUsage_count
BEFORE INSERT 
ON APPLIED_TO
FOR EACH ROW
BEGIN
    DECLARE numberOfTimesAllowed int;
    DECLARE codeUsage_count int;

    SELECT Usage_count INTO numberOfTimesAllowed
    from DISCOUNT_CODE
    WHERE Code = NEW.Code;

    SELECT COUNT(*) INTO codeUsage_count
    FROM APPLIED_TO
    WHERE ID = NEW.ID AND Code = NEW.Code;

    IF codeUsage_count >= numberOfTimesAllowed THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The number of times you can use this discount code has expired.';
    END IF;
END; //
DELIMITER ;


-- after submmit a cart that cart will be active
DELIMITER //
CREATE TRIGGER IF NOT EXISTS controlSubmmitedCart
BEFORE INSERT
ON ISSUED_FOR
FOR EACH ROW
BEGIN
    DECLARE payStatus BOOLEAN;
    
    SELECT Status INTO payStatus
    FROM TRANSACTION
    WHERE Tracking_code = NEW.Tracking_code;

    IF payStatus = true THEN
        UPDATE SHOPPING_CART
        SET Status = 'active'
        WHERE NEW.ID = ID and NEW.Cart_number = Number;
    END IF;
END; //
DELIMITER ;


-- avoid to submmit a blocekd shopping cart
DELIMITER //
CREATE TRIGGER IF NOT EXISTS preventSubmmitBlockedCart
BEFORE INSERT ON ISSUED_FOR
FOR EACH ROW
BEGIN 

    DECLARE cartStatus VARCHAR(10);

    SELECT Status INTO cartStatus
    FROM SHOPPING_CART
    WHERE NEW.ID = ID and NEW.Cart_number = Number;

    IF cartStatus = 'blocked' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'submmit not allowed shopping cart is blocked';
    END IF;
END; //
DELIMITER ;
    

-- adding wallet_balance after deposists into wallet

DELIMITER //

CREATE TRIGGER IF NOT EXISTS depositWallet
AFTER INSERT
ON DEPOSITS_INTO_WALLET
FOR EACH ROW
BEGIN 
    DECLARE payStatus BOOLEAN;

    SELECT Status INTO payStatus
    FROM TRANSACTION
    WHERE NEW.Tracking_code = Tracking_code;

    UPDATE CLIENT
    SET Wallet_balance = Wallet_balance + NEW.Amount
    WHERE NEW.ID = ID and payStatus = TRUE;
END; //
DELIMITER ;


DELIMITER //

CREATE TRIGGER IF NOT EXISTS subtractCartPriceFromWallet
BEFORE INSERT
ON WALLET_TRANSACTION
FOR EACH ROW
BEGIN

    DECLARE payStatus BOOLEAN;
    DECLARE Total_price INT;
    DECLARE NID INT;
    DECLARE NCart_number INt;
    DECLARE NLocked_number INT;


    IF EXISTS (SELECT 1 FROM ISSUED_FOR WHERE NEW.Tracking_code = Tracking_code) THEN
        
        SELECT Status INTO payStatus
        FROM TRANSACTION
        WHERE NEW.Tracking_code = Tracking_code;

        IF payStatus = TRUE THEN
            SELECT ID, Cart_number, Locked_number INTO NID, NCart_number, NLocked_number
            FROM ISSUED_FOR 
            WHERE NEW.Tracking_code = Tracking_code;

            CALL calculateCartPrice2(NID, NCart_number, NLocked_number, Total_price);

            UPDATE CLIENT
            SET Wallet_balance = Wallet_balance - Total_price
            WHERE NID = ID;
        END IF;
    END IF;
END;//

DELIMITER ;

DELIMITER //

CREATE TRIGGER IF NOT EXISTS subtractsubscriptionFromWallet
BEFORE INSERT
ON SUBSCRIBES
FOR EACH ROW
BEGIN 

    DECLARE payStatus BOOLEAN;
    

    SELECT Status INTO payStatus
    FROM TRANSACTION
    WHERE NEW.Tracking_code = Tracking_code;

    IF EXISTS (SELECT 1 FROM WALLET_TRANSACTION WHERE NEW.Tracking_code = Tracking_code) THEN
        IF payStatus = TRUE THEN
            UPDATE CLIENT
            SET Wallet_balance = Wallet_balance - 10000
            WHERE NEW.ID = ID;

            INSERT INTO VIP_CLIENTS VALUES (NEW.ID, NOW() + INTERVAL 30 DAY);
            
        END IF;
    END IF;

END;//
DELIMITER ;

        




-- ترنز اکشن ها فقط مربوط به سبد خرید نیستند و چک شوند

        

