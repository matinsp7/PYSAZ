CREATE DATABASE IF NOT EXISTS PYSAZ;

USE PYSAZ;

-- time stamp not implemented yet
CREATE TABLE IF NOT EXISTS CLIENT
(
    First_name VARCHAR(15),
    Last_name VARCHAR(15),
    ID INT PRIMARY KEY,
    Phone_number VARCHAR(12) UNIQUE,
    Wallet_balance INT,
    Refferal_code VARCHAR(20) UNIQUE,
    Time_stamp date,

    CHECK( Wallet_balance >= 0 )
);

CREATE TABLE IF NOT EXISTS ADDRESS
(
    ID INT,
    Province VARCHAR(20),
    Remainder VARCHAR(40),

    PRIMARY KEY(ID, Province, Remainder),
    FOREIGN KEY (ID) REFERENCES CLIENT(ID)
-- if aclient change its addres in ADDRES table will update automaticly.
    ON UPDATE CASCADE
    ON DELETE CASCADE  
);

CREATE TABLE IF NOT EXISTS TRANSACTION
(
    Tracking_code INT PRIMARY KEY,
    Tstatus boolean, 
    Time_stamp date
);

CREATE TABLE IF NOT EXISTS BANK_TRANSACTION
(
    Tracking_code INT,
    Card_number VARCHAR(20),

    PRIMARY KEY(Tracking_code),
    FOREIGN KEY(Tracking_code) REFERENCES TRANSACTION(Tracking_code)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS WALLET_TRANSACTION
(
    Tracking_code INT,

    PRIMARY KEY(Tracking_code),
    FOREIGN KEY(Tracking_code) REFERENCES TRANSACTION(Tracking_code)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS SUBSCRIBES
(
    Tracking_code INT PRIMARY KEY,
    ID INT,

    FOREIGN KEY(Tracking_code) REFERENCES TRANSACTION(Tracking_code)
    ON UPDATE CASCADE  
    ON DELETE CASCADE,
    
    FOREIGN KEY(ID) REFERENCES CLIENT(ID)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS DEPOSITS_INTO_WALLET
(
    Tracking_code INT PRIMARY KEY,
    ID INT,
    Amount INT,

    CHECK(Amount > 0),

    FOREIGN KEY (ID) REFERENCES CLIENT(ID)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    FOREIGN KEY (Tracking_code) REFERENCES TRANSACTION(Tracking_code)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS VIP_CLIENTS
(
    ID INT PRIMARY KEY,
    Subcription_expiration_time date,

    FOREIGN KEY (ID) REFERENCES CLIENT(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- which table and column is this foreign key?
CREATE TABLE IF NOT EXISTS REFERS
(
    Referee VARCHAR(20) PRIMARY KEY,
    Referrer VARCHAR(20)

    -- FOREIGN KEY (Referee) 
);

CREATE TABLE IF NOT EXISTS SHOPPING_CART
(
    ID INT,
    Number INT,
    Status ENUM ('active', 'locked', 'blocked'),

    PRIMARY KEY(ID, Number),
    FOREIGN KEY (ID) REFERENCES CLIENT(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS DISCOUNT_CODE
(
    Code INT PRIMARY KEY,
    Amount INT,
    Limt INT,
    Usage_count INT,
    Expiration_date date,

    -- check it later
    CHECK(Amount > 0)
);

CREATE TABLE IF NOT EXISTS PRIVATE_CODE
(   
    Code INT PRIMARY KEY,
    ID INT,
    Ttimestamp TIMESTAMP,

    FOREIGN KEY (ID) REFERENCES CLIENT(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE, 

    FOREIGN KEY (Code) REFERENCES DISCOUNT_CODE(Code)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PUBLIC_CODE
(
    Code INT PRIMARY KEY,

    FOREIGN KEY (Code) REFERENCES DISCOUNT_CODE(Code)
    ON UPDATE CASCADE
    ON DELETE CASCADE 
);

CREATE TABLE IF NOT EXISTS LOCKED_SHOPPING_CART
(   
    ID INT,
    Cart_number INT,
-- might auto incremnt needed-----------------
    Number INT,          
    Ttimestamp TIMESTAMP,

    PRIMARY KEY(ID, Cart_number, Number),

    FOREIGN KEY (ID, Cart_number) REFERENCES SHOPPING_CART(ID, Number)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ISSUED_FOR
(
    Tracking_code INT PRIMARY KEY,
    ID INT, 
    Cart_number INT,
    Locked_number INT,

    FOREIGN KEY (Tracking_code) REFERENCES TRANSACTION(Tracking_code)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    FOREIGN KEY (ID, Cart_number, Locked_number) REFERENCES LOCKED_SHOPPING_CART(ID, Cart_number, Number)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS PRODUCT 
(
    ID INT PRIMARY KEY,
    Category VARCHAR(20),
    Image BLOB,
    Current_price INT,
    Stock_count INT, 
    Brand VARCHAR(20),
    Model VARCHAR(30)

    CHECK (Current_price > 0 and Stock_count > 0)
);

CREATE TABLE IF NOT EXISTS ADDED_TO
(
    ID INT,
    Cart_number INT,
    Locked_number INT,
    Product_ID INT,
    Quantity VARCHAR(20),
    Cart_price INT CHECK (Cart_price > 0),

    PRIMARY KEY (ID, Cart_number, Locked_number, Product_ID),

    FOREIGN KEY (ID, Cart_number, Locked_number) REFERENCES LOCKED_SHOPPING_CART (ID, Cart_number, Number)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    FOREIGN KEY (Product_ID) REFERENCES PRODUCT (ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS APPLIED_TO
(
    ID INT,
    Cart_number INT,
    Locked_number INT,
    Code INT,
    Timestamp date,

    PRIMARY KEY (ID, Cart_number, Locked_number, Code)

--  foreign key  

);

CREATE TABLE IF NOT EXISTS HDD
(
    ID INT PRIMARY KEY,
    Rotational_speed INT,
    Wattage INT,
    Capacity INT,
    Depth INT,
    Height INT,
    Width INT,

    FOREIGN KEY (ID) REFERENCES PRODUCT(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE

);

CREATE TABLE IF NOT EXISTS GPU
(
    ID INT PRIMARY KEY,
    Clock_speed INT,
    Ram_size INT,
    Number_of_fans INT,
    Wattage INT,
    Depth INT,
    Height INT,
    Width INT,

    FOREIGN KEY (ID) REFERENCES PRODUCT(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE


);


CREATE TABLE IF NOT EXISTS POWER_SUPPLY
(   
    ID INT PRIMARY KEY,
    Supported_Wattage INT,
    Depth INT,
    Height INT,
    Width INT,

    FOREIGN KEY (ID) REFERENCES PRODUCT(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE

);


CREATE TABLE IF NOT EXISTS COOLER
(   
    ID INT PRIMARY KEY,
    Maximum_rotational_speed INT,
    Wattage INT,
    Fan_size INT,
    Cooling_method INT,
    Depth INT,
    Height INT,
    Width INT,

    FOREIGN KEY (ID) REFERENCES PRODUCT(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS CPU
(   
    ID INT PRIMARY KEY,
    Maximum_addressable_memory_limit INT,
    Boost_frequency INT,
    Base_frequency INT,
    Number_of_cores INT,
    Number_of_Threads INT,
    Generation INT,
    Wattage INT,

    FOREIGN KEY (ID) REFERENCES PRODUCT(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS MOTHERBOARD
(   
    ID INT PRIMARY KEY,
    Chipset VARCHAR(30),
    Number_of_memory_slots INT,
    Memory_speed_range INT,
    Wattage INT,
    Depth INT,
    Height INT,
    Width INT,

    FOREIGN KEY (ID) REFERENCES PRODUCT(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE


);

CREATE TABLE IF NOT EXISTS RAM_STICK
(
    ID INT PRIMARY KEY,
    Frequency INT,  
    Wattage INT,
    Capacity INT,
    Generation VARCHAR(10),
    Depth INT,
    Height INT,
    Width INT,

    FOREIGN KEY (ID) REFERENCES PRODUCT(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS SSD
(
    ID INT PRIMARY KEY,
    Wattage INT,
    Capacity INT,

    FOREIGN KEY (ID) REFERENCES PRODUCT(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

------------------------------------------------------------------------------------------------
--                                      EVENTS AND TRIGGER
------------------------------------------------------------------------------------------------

CREATE EVENT IF NOT EXISTS CheckExpirationVip
ON SCHEDULE EVERY 1 DAY
DO
DELETE FROM VIP_CLIENTS
WHERE Subcription_expiration_time < NOW() - INTERVAL 1 MONTH;

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

    UPDATE CLIENT 
    SET Wallet_balance = Wallet_balance + NEW.Amount
    WHERE NEW.ID = ID;

END; //
DELIMITER ;



-----------------------------------------------------------------------------------------------------
--                                      INSERTING DATA
-----------------------------------------------------------------------------------------------------



INSERT INTO CLIENT (First_name, Last_name, ID, Phone_number, Wallet_balance, Refferal_code, Time_stamp) VALUES
('John', 'Doe', 1, '1234567890', 1000, 'REF1', '2025-01-01'),
('Jane', 'Smith', 2, '0987654321', 2000, 'REF2', '2025-01-02'),
('Bob', 'Brown', 3, '1231231234', 1500, 'REF3', '2025-01-03'),
('Alice', 'Green', 4, '3213214321', 3000, 'REF4', '2025-01-04'),
('Tom', 'Hanks', 5, '4564564567', 500, 'REF5', '2025-01-05'),
('Emma', 'Stone', 6, '7897897890', 2500, 'REF6', '2025-01-06'),
('Chris', 'Evans', 7, '1472583690', 3500, 'REF7', '2025-01-07'),
('Scarlett', 'Johansson', 8, '9638527410', 4000, 'REF8', '2025-01-08'),
('Robert', 'Downey', 9, '2583691470', 4500, 'REF9', '2025-01-09'),
('Jennifer', 'Lawrence', 10, '3692581470', 6000, 'REF10', '2025-01-10');

-- Insert ADDRESS data
INSERT INTO ADDRESS (ID, Province, Remainder) VALUES
(1, 'Province1', 'Address1'),
(2, 'Province2', 'Address2'),
(3, 'Province3', 'Address3'),
(4, 'Province4', 'Address4'),
(5, 'Province5', 'Address5'),
(6, 'Province6', 'Address6'),
(7, 'Province7', 'Address7'),
(8, 'Province8', 'Address8'),
(9, 'Province9', 'Address9'),
(10, 'Province10', 'Address10');

-- Insert TRANSACTION data
INSERT INTO TRANSACTION (Tracking_code, Tstatus, Time_stamp) VALUES
(1001, TRUE, '2025-01-10'),
(1002, FALSE, '2025-01-11'),
(1003, TRUE, '2025-01-12'),
(1004, FALSE, '2025-01-13'),
(1005, TRUE, '2025-01-14'),
(1006, FALSE, '2025-01-15'),
(1007, TRUE, '2025-01-16'),
(1008, FALSE, '2025-01-17'),
(1009, TRUE, '2025-01-18'),
(1010, FALSE, '2025-01-19');

-- Insert BANK_TRANSACTION data
INSERT INTO BANK_TRANSACTION (Tracking_code, Card_number) VALUES
(1001, '1111222233334444'),
(1002, '5555666677778888'),
(1003, '9999000011112222'),
(1004, '3333444455556666'),
(1005, '7777888899990000');

-- Insert WALLET_TRANSACTION data
INSERT INTO WALLET_TRANSACTION (Tracking_code) VALUES
(1006),
(1007),
(1008),
(1009),
(1010);

-- Insert SUBSCRIBES data
INSERT INTO SUBSCRIBES (Tracking_code, ID) VALUES
(1001, 1),
(1002, 2),
(1003, 3),
(1004, 4),
(1005, 5);

-- Insert DEPOSITS_INTO_WALLET data
INSERT INTO DEPOSITS_INTO_WALLET (Tracking_code, ID, Amount) VALUES
(1006, 6, 500),
(1007, 7, 700),
(1008, 8, 300),
(1009, 9, 1000),
(1010, 10, 1200);

-- Insert VIP_CLIENTS data
INSERT INTO VIP_CLIENTS (ID, Subcription_expiration_time) VALUES
(1, '2025-12-31'),
(2, '2025-11-30'),
(3, '2025-10-31'),
(4, '2025-09-30'),
(5, '2025-08-31');

-- Insert SHOPPING_CART data
INSERT INTO SHOPPING_CART (ID, Number, Status) VALUES
(1, 1, 'locked'),
(2, 2, 'locked'),
(3, 3, 'active'),
(4, 4, 'active'),
(5, 5, 'locked');

-- Insert DISCOUNT_CODE data
INSERT INTO DISCOUNT_CODE (Code, Amount, Limt, Usage_count, Expiration_date) VALUES
(101, 10, 100, 5, '2025-12-31'),
(102, 20, 50, 2, '2025-11-30'),
(103, 15, 80, 3, '2025-10-31'),
(104, 5, 30, 1, '2025-09-30'),
(105, 25, 60, 4, '2025-08-31');

-- Insert PRIVATE_CODE data
INSERT INTO PRIVATE_CODE (Code, ID, Ttimestamp) VALUES
(101, 1, '2025-01-15 10:00:00'),
(102, 2, '2025-01-16 11:00:00'),
(103, 3, '2025-01-17 12:00:00'),
(104, 4, '2025-01-18 13:00:00'),
(105, 5, '2025-01-19 14:00:00');

-- Insert PUBLIC_CODE data
INSERT INTO PUBLIC_CODE (Code) VALUES
(101),
(102),
(103),
(104),
(105);

-- Insert LOCKED_SHOPPING_CART data
INSERT INTO LOCKED_SHOPPING_CART (ID, Cart_number, Number, Ttimestamp) VALUES
(1, 1, 1, '2025-01-20 12:00:00'),
(2, 2, 2, '2025-01-21 13:00:00'),
(3, 3, 3, '2025-01-22 14:00:00'),
(4, 4, 4, '2025-01-23 15:00:00'),
(5, 5, 5, '2025-01-24 16:00:00');

-- Insert ISSUED_FOR data
-- INSERT INTO ISSUED_FOR (Tracking_code, ID, Cart_number, Locked_number) VALUES
-- (1001, 1, 1, 1),
-- (1002, 2, 2, 2),
-- (1003, 3, 3, 3),
-- (1004, 4, 4, 4),
-- (1005, 5, 5, 5);

-- Insert PRODUCT data
INSERT INTO PRODUCT (ID, Category, Image, Current_price, Stock_count, Brand, Model) VALUES
(1, 'Electronics', NULL, 500, 10, 'BrandA', 'ModelX'),
(2, 'Electronics', NULL, 300, 20, 'BrandB', 'ModelY'),
(3, 'Home Appliances', NULL, 700, 15, 'BrandC', 'ModelZ'),
(4, 'Furniture', NULL, 1000, 5, 'BrandD', 'ModelW'),
(5, 'Clothing', NULL, 50, 100, 'BrandE', 'ModelV');

-- Insert ADDED_TO data
INSERT INTO ADDED_TO (ID, Cart_number, Locked_number, Product_ID, Quantity, Cart_price) VALUES
(1, 1, 1, 1, 2, 1000),
(2, 2, 2, 2, 3, 900),
(3, 3, 3, 3, 1, 700),
(4, 4, 4, 4, 1, 1000),
(5, 5, 5, 5, 2, 100);

-- Insert HDD data
INSERT INTO HDD (ID, Rotational_speed, Wattage, Capacity, Depth, Height, Width) VALUES
(1, 7200, 10, 1000, 10, 10, 10),
(2, 5400, 15, 2000, 12, 12, 12);

-- Insert GPU data
INSERT INTO GPU (ID, Clock_speed, Ram_size, Number_of_fans, Wattage, Depth, Height, Width) VALUES
(1, 1500, 8, 2, 200, 20, 20, 20),
(2, 1400, 6, 1, 180, 18, 18, 18);

-- Insert POWER_SUPPLY data
INSERT INTO POWER_SUPPLY (ID, Supported_Wattage, Depth, Height, Width) VALUES
(1, 650, 15, 15, 15),
(2, 750, 17, 17, 17);

-- Insert COOLER data
INSERT INTO COOLER (ID, Maximum_rotational_speed, Wattage, Fan_size, Cooling_method, Depth, Height, Width) VALUES
(1, 2500, 50, 120, 1, 5, 5, 5),
(2, 2200, 45, 115, 1, 6, 6, 6);

-- Insert CPU data
INSERT INTO CPU (ID, Maximum_addressable_memory_limit, Boost_frequency, Base_frequency, Number_of_cores, Number_of_Threads, Generation, Wattage) VALUES
(1, 64, 4.5, 3.6, 8, 16, 10, 95),
(2, 128, 5.0, 4.0, 10, 20, 11, 105);

-- Insert MOTHERBOARD data
INSERT INTO MOTHERBOARD (ID, Chipset, Number_of_memory_slots, Memory_speed_range, Wattage, Depth, Height, Width) VALUES
(1, 'Z490', 4, 3200, 50, 30, 30, 30),
(2, 'X570', 4, 3600, 60, 32, 32, 32),
(3, 'B550', 2, 3200, 45, 28, 28, 28),
(4, 'Z390', 4, 3000, 55, 31, 31, 31),
(5, 'H370', 2, 2666, 40, 27, 27, 27);

-- Insert RAM_STICK data
INSERT INTO RAM_STICK (ID, Frequency, Wattage, Capacity, Generation, Depth, Height, Width) VALUES
(1, 3200, 15, 16, 'DDR4', 10, 10, 10),
(2, 3600, 18, 32, 'DDR4', 11, 11, 11),
(3, 3000, 12, 8, 'DDR3', 9, 9, 9),
(4, 2666, 10, 4, 'DDR3', 8, 8, 8),
(5, 2133, 8, 2, 'DDR2', 7, 7, 7);

-- Insert SSD data
INSERT INTO SSD (ID, Wattage, Capacity) VALUES
(1, 5, 500),
(2, 7, 1000),
(3, 6, 250),
(4, 4, 128),
(5, 8, 2000);


