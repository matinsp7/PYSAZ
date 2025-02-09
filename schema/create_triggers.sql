USE PYSAZ;

-- check if cart is locked can't add to it product

-- DELIMITER $$

-- CREATE TRIGGER IF NOT EXISTS check_block_before_insert_ADDED_TO
-- BEFORE INSERT ON ADDED_TO
-- FOR EACH ROW
-- BEGIN
--     DECLARE cart_locked VARCHAR(10);

--     -- Check if the SHOPPING_CART is locked
--     SELECT 'locked' INTO cart_locked
--     FROM SHOPPING_CART
--     WHERE ID = NEW.ID AND Number = NEW.Cart_number;

--     -- If the cart is locked, prevent the insert
--     IF cart_locked = 'locked' THEN
--         SIGNAL SQLSTATE '45000'
--         SET MESSAGE_TEXT = 'Cannot add item: Cart is locked.';
--     END IF;
-- END$$

-- DELIMITER ;

DELIMITER //

CREATE TRIGGER prevent_insert_if_locked_or_blocked
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

END;
//

DELIMITER ;



DELIMITER //

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
END; //
DELIMITER ;


-- when a product added to ADDED_TO table stock_count of products change
DELIMITER //

CREATE TRIGGER IF NOT EXISTS controlStockCount
BEFORE INSERT
ON ADDED_TO
FOR EACH ROW
BEGIN

    DECLARE product_count INT;

    SELECT Stock_count INTO product_count
    FROM PRODUCT
    WHERE PRODUCT.ID = NEW.PRODUCT_ID; 

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


-- check maxmimum cart of users

DELIMITER //

CREATE TRIGGER IF NOT EXISTS checkNumberOFCartShop
BEFORE INSERT
ON SHOPPING_CART
FOR EACH ROW
BEGIN

    DECLARE activeCart INT;
    DECLARE isVip BOOLEAN;

    IF EXISTS (SELECT 1 FROM VIP_CLIENTS WHERE NEW.ID = ID) THEN
        SET isVip = TRUE;
    ELSE 
        SET isVip = FALSE;
    END IF;

    SELECT COUNT(*) INTO activeCart
    FROM SHOPPING_CART
    WHERE ID = NEW.ID and (Status = 'active' or Status = 'locked');

    IF (activeCart >= 1 and isVip = FALSE) or (activeCart >= 5 and isVip = TRUE) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'your limit of shopping cart exceeded!';
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
    
    SELECT TStatus INTO payStatus
    FROM TRANSACTION
    WHERE Tracking_code = NEW.Tracking_code;

    UPDATE SHOPPING_CART
    SET Status = 'active'
    WHERE NEW.ID = ID and NEW.Cart_number = Number and payStatus = TRUE;

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

    SELECT Tstatus INTO payStatus
    FROM TRANSACTION
    WHERE NEW.Tracking_code = Tracking_code

    UPDATE CLIENT
    SET Wallet_balance = Wallet_balance + NEW.Amount
    WHERE NEW.ID = ID and payStatus = TRUE;

END; //
DELIMITER ;
