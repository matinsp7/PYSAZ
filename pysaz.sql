CREATE DATABASE IF NOT EXISTS PYSAZ;

USE PYSAZ;


CREATE TABLE IF NOT EXISTS CLIENT
(
    ID INT PRIMARY KEY,
    Phone_number VARCHAR(12) UNIQUE,
    First_name VARCHAR(15),
    Last_name VARCHAR(15),
    Wallet_balance INT,
    Refferal_code VARCHAR(20) UNIQUE,

    CHECK( Wallet_balance >= 0)
)

