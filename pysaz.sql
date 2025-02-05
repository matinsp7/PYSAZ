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
    Status boolean,

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






















































































































































































































CREATE TABLE IF NOT EXISTS HDD
(
    ID INT PRIMARY KEY,
    Rotational_speed INT,
    Wattage INT,
    Capacity INT,
    Depth INT,
    Height INT,
    Width INT
)


------------------------------------------------------------------------------------------------
--                                      EVENTS
------------------------------------------------------------------------------------------------

CREATE EVENT IF NOT EXISTS CheckExpirationVip
ON SCHEDULE EVERY 1 DAY
DO
DELETE FROM VIP_CLIENTS
WHERE Subcription_expiration_time < NOW() - INTRVAL 1 MONTH;