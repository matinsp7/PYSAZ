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
-- if aclient change its addres in ADDRES table automatic updated.
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

