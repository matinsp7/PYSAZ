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
    Timestamp Timestamp,

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
    Status boolean NOT NULL, 
    Timestamp Timestamp
);

CREATE TABLE IF NOT EXISTS BANK_TRANSACTION
(
    Tracking_code INT,
    Card_number VARCHAR(16),

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
    Amount INT NOT NULL CHECK(Amount > 0),
    Code_limit INT,
    Usage_count INT,
    Expiration_date date
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
    Timestamp TIMESTAMP,

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

CREATE TABLE IF NOT EXISTS CC_SOCKET_COMPATIBLE_WITH
(
    Cooler_ID INT,
    CPU_ID INT,

    PRIMARY KEY (Cooler_ID, CPU_ID)

    FOREIGN KEY (Cooler_ID) REFERENCES COOLER(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    FOREIGN KEY (CPU_ID) REFERENCES CPU(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE

);

CREATE TABLE IF NOT EXISTS MC_SOCKET_COMPATIBLE_WITH
(
    Motherboard_ID INT,
    CPU_ID INT,

    PRIMARY KEY (Motherboard_ID, CPU_ID)

    FOREIGN KEY (Motherboard_ID) REFERENCES MOTHERBOARD(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    FOREIGN KEY (CPU_ID) REFERENCES CPU(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE

);

CREATE TABLE IF NOT EXISTS RM_SLOT_COMPATIBLE_WITH
(
    Motherboard_ID INT,
    Ram_ID INT,

    PRIMARY KEY (Motherboard_ID, Ram_ID)

    FOREIGN KEY (Motherboard_ID) REFERENCES MOTHERBOARD(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    FOREIGN KEY (Ram_ID) REFERENCES RAM_STICK(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS SM_SLOT_COMPATIBLE_WITH
(
    Motherboard_ID INT,
    SSD_ID INT,

    PRIMARY KEY (Motherboard_ID, SSD_ID)

    FOREIGN KEY (Motherboard_ID) REFERENCES MOTHERBOARD(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    FOREIGN KEY (SSD_ID) REFERENCES SSD_ID(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE

);

CREATE TABLE IF NOT EXISTS GM_SLOT_COMPATIBLE_WITH
(
    Motherboard_ID INT, 
    GPU_ID INT,
    
    PRIMARY KEY (Motherboard_ID, GPU_ID)

    FOREIGN KEY (Motherboard_ID) REFERENCES MOTHERBOARD(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    FOREIGN KEY (GPU_ID) REFERENCES GPU(ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE

);



