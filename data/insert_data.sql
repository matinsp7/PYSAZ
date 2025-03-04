USE PYSAZ;

-- INSERT INTO CLIENT (First_name, Last_name, ID, Phone_number, Wallet_balance, Refferal_code, Timestamp) VALUES
-- ('John', 'Doe', 1, '1234567890', 2000, 'REF1', '2025-01-01'),
-- ('Jane', 'Smith', 2, '0987654321', 2000, 'REF2', '2025-01-02'),
-- ('Bob', 'Brown', 3, '1231231234', 1500, 'REF3', '2025-01-03'),
-- ('Alice', 'Green', 4, '3213214321', 3000, 'REF4', '2025-01-04'),
-- ('Tom', 'Hanks', 5, '4564564567', 500, 'REF5', '2025-01-05'),
-- ('Emma', 'Stone', 6, '7897897890', 2500, 'REF6', '2025-01-06'),
-- ('Chris', 'Evans', 7, '1472583690', 3500, 'REF7', '2025-01-07'),
-- ('Scarlett', 'Johansson', 8, '9638527410', 4000, 'REF8', '2025-01-08'),
-- ('Robert', 'Downey', 9, '2583691470', 4500, 'REF9', '2025-01-09'),
-- ('Jennifer', 'Lawrence', 10, '3692581470', 6000, 'REF10', '2025-01-10');

-- -- Insert ADDRESS data
-- INSERT INTO ADDRESS (ID, Province, Remainder) VALUES
-- (1, 'Province1', 'Address1'),
-- (2, 'Province2', 'Address2'),
-- (3, 'Province3', 'Address3'),
-- (4, 'Province4', 'Address4'),
-- (5, 'Province5', 'Address5'),
-- (6, 'Province6', 'Address6'),
-- (7, 'Province7', 'Address7'),
-- (8, 'Province8', 'Address8'),
-- (9, 'Province9', 'Address9'),
-- (10, 'Province10', 'Address10');

-- -- Insert TRANSACTION data
-- INSERT INTO TRANSACTION (Tracking_code, Status, Timestamp) VALUES
-- (1001, TRUE, '2025-01-10'),
-- (1002, FALSE, '2025-01-11'),
-- (1003, TRUE, '2025-01-12'),
-- (1004, FALSE, '2025-01-13'),
-- (1005, TRUE, '2025-01-14'),
-- (1006, FALSE, '2025-01-15'),
-- (1007, TRUE, '2025-01-16'),
-- (1008, FALSE, '2025-01-17'),
-- (1009, TRUE, '2025-01-18'),
-- (1010, FALSE, '2025-01-19');

-- -- Insert BANK_TRANSACTION data
-- INSERT INTO BANK_TRANSACTION (Tracking_code, Card_number) VALUES
-- (1001, '1111222233334444'),
-- (1002, '5555666677778888'),
-- (1003, '9999000011112222'),
-- (1004, '3333444455556666'),
-- (1005, '7777888899990000');

-- -- Insert WALLET_TRANSACTION data
-- INSERT INTO WALLET_TRANSACTION (Tracking_code) VALUES
-- (1006),
-- (1007),
-- (1008),
-- (1009),
-- (1010);

-- -- Insert SUBSCRIBES data
-- INSERT INTO SUBSCRIBES (Tracking_code, ID) VALUES
-- (1001, 1),
-- (1002, 2),
-- (1003, 3),
-- (1004, 4),
-- (1005, 5);

-- -- Insert DEPOSITS_INTO_WALLET data
-- INSERT INTO DEPOSITS_INTO_WALLET (Tracking_code, ID, Amount) VALUES
-- (1006, 6, 500),
-- (1007, 7, 700),
-- (1008, 8, 300),
-- (1009, 9, 1000),
-- (1010, 10, 1200);

-- -- Insert VIP_CLIENTS data
-- INSERT INTO VIP_CLIENTS (ID, Subcription_expiration_time) VALUES
-- (1, '2025-12-31'),
-- (2, '2025-11-30'),
-- (3, '2025-10-31');

-- -- Insert SHOPPING_CART data
-- INSERT INTO SHOPPING_CART (ID, Number, Status) VALUES
-- (1, 1, 'active'),
-- (2, 2, 'active'),
-- (3, 3, 'active'),
-- (4, 4, 'active'),
-- (5, 5, 'active');

-- -- Insert DISCOUNT_CODE data
-- INSERT INTO DISCOUNT_CODE (Code, Amount, Code_limit, Usage_count, Expiration_date) VALUES
-- (101, 10, 100, 5, '2025-12-31'),
-- (102, 20, 50, 2, '2025-11-30'),
-- (103, 15, 80, 3, '2025-10-31'),
-- (104, 5, 30, 1, '2025-09-30'),
-- (105, 25, 60, 4, '2025-08-31'),
-- (106, 500, NULL, 5, '2026-08-31');

-- -- Insert PRIVATE_CODE data
-- INSERT INTO PRIVATE_CODE (Code, ID, Ttimestamp) VALUES
-- (101, 1, '2025-01-15 10:00:00'),
-- (102, 2, '2025-01-16 11:00:00'),
-- (103, 3, '2025-01-17 12:00:00'),
-- (104, 4, '2025-01-18 13:00:00'),
-- (105, 5, '2025-01-19 14:00:00');

-- -- Insert PUBLIC_CODE data
-- INSERT INTO PUBLIC_CODE (Code) VALUES
-- (101),
-- (102),
-- (103),
-- (104),
-- (105);

-- -- Insert LOCKED_SHOPPING_CART data
-- INSERT INTO LOCKED_SHOPPING_CART (ID, Cart_number, Number, Timestamp) VALUES
-- (1, 1, 1, '2025-01-20 12:00:00'),
-- (2, 2, 2, '2025-01-21 13:00:00'),
-- (3, 3, 3, '2025-01-22 14:00:00'),
-- (4, 4, 4, '2025-01-23 15:00:00'),
-- (5, 5, 5, '2025-01-24 16:00:00');

-- --Insert ISSUED_FOR data
-- INSERT INTO ISSUED_FOR (Tracking_code, ID, Cart_number, Locked_number) VALUES
-- (1001, 1, 1, 1),
-- (1006, 1, 1, 1),
-- (1008, 1, 1, 1),
-- (1002, 2, 2, 2),
-- (1003, 3, 3, 3),
-- (1004, 4, 4, 4),
-- (1005, 5, 5, 5);

-- -- Insert PRODUCT data
-- INSERT INTO PRODUCT (ID, Category, Image, Current_price, Stock_count, Brand, Model) VALUES
-- (1,  'Electronics', NULL, 500,  10, 'BrandA', 'ModelX'),
-- (2,  'Electronics', NULL, 300,  30, 'BrandB', 'ModelY'),
-- (3,  'Electronics', NULL, 700,  15, 'BrandC', 'ModelZ'),
-- (4,  'Electronics', NULL, 100,  10, 'BrandD', 'ModelW'),
-- (5,  'Electronics', NULL,  50, 100, 'BrandE', 'ModelV'),
-- (6,  'Electronics', NULL, 400, 100, 'BrandC', 'ModelA'),
-- (7,  'Electronics', NULL, 350, 200, 'BrandD', 'ModelA'),
-- (8,  'Electronics', NULL, 307, 224, 'BrandE', 'ModelY'),
-- (9,  'Electronics', NULL, 312, 221, 'BrandA', 'ModelY'),
-- (10, 'Electronics', NULL, 30 ,  20, 'BrandF', 'ModelZ'),
-- (11, 'Electronics', NULL, 100, 190, 'BrandV', 'ModelY'),
-- (12, 'Electronics', NULL, 300, 140, 'BrandV', 'ModelX'),
-- (13, 'Electronics', NULL, 400, 130, 'BrandH', 'ModelM'),
-- (14, 'Electronics', NULL, 600, 230, 'BrandN', 'ModelY'),
-- (15, 'Electronics', NULL, 400,  53, 'BrandA', 'ModelQ'),
-- (16, 'Electronics', NULL, 700, 219, 'BrandF', 'ModelG'),
-- (17, 'Electronics', NULL, 400, 324, 'BrandS', 'ModelX'),
-- (18, 'Electronics', NULL, 200, 223, 'BrandA', 'ModelW'),
-- (19, 'Electronics', NULL, 340, 212, 'BrandA', 'ModelA'),
-- (20, 'Electronics', NULL, 350, 212, 'BrandB', 'ModelY'),
-- (21, 'Electronics', NULL, 313,  23, 'BrandS', 'ModelM'),
-- (22, 'Electronics', NULL, 309, 243, 'BrandF', 'ModelA'),
-- (23, 'Electronics', NULL, 408, 235, 'BrandF', 'ModelB');

-- -- Insert ADDED_TO data
-- INSERT INTO ADDED_TO (ID, Cart_number, Locked_number, Product_ID, Quantity, Cart_price) VALUES
-- (1, 1, 1, 1, 2, 1000),
-- (2, 2, 2, 2, 3, 900),
-- (3, 3, 3, 3, 1, 700),
-- (4, 4, 4, 4, 1, 1000),
-- (5, 5, 5, 5, 2, 100);

-- INSERT INTO APPLIED_TO (ID, Cart_number, Locked_number, Code, Timestamp) VALUES 
-- (1, 1, 1, 101, NOW()),
-- (1, 1, 1, 106, NOW()),
-- (1, 1, 1, 105, NOW());

-- -- Insert HDD data
-- INSERT INTO HDD (ID, Rotational_speed, Wattage, Capacity, Depth, Height, Width) VALUES
-- (1, 7200, 10, 1000, 10, 10, 10),
-- (2, 5400, 15, 2000, 12, 12, 12);

-- -- Insert GPU data
-- INSERT INTO GPU (ID, Clock_speed, Ram_size, Number_of_fans, Wattage, Depth, Height, Width) VALUES
-- (3, 1500, 8, 2, 200, 20, 20, 20),
-- (4, 1400, 6, 1, 180, 18, 18, 18);

-- -- Insert POWER_SUPPLY data
-- INSERT INTO POWER_SUPPLY (ID, Supported_Wattage, Depth, Height, Width) VALUES
-- (5, 650, 15, 15, 15),
-- (6, 750, 17, 17, 17);

-- -- Insert COOLER data
-- INSERT INTO COOLER (ID, Maximum_rotational_speed, Wattage, Fan_size, Cooling_method, Depth, Height, Width) VALUES
-- (7, 2500, 50, 120, 1, 5, 5, 5),
-- (8, 2200, 45, 115, 1, 6, 6, 6);

-- -- Insert CPU data
-- INSERT INTO CPU (ID, Maximum_addressable_memory_limit, Boost_frequency, Base_frequency, Number_of_cores, Number_of_Threads, Generation, Wattage) VALUES
-- (9, 64, 4.5, 3.6, 8, 16, 10, 95),
-- (10, 128, 5.0, 4.0, 10, 20, 11, 105);

-- -- Insert MOTHERBOARD data
-- INSERT INTO MOTHERBOARD (ID, Chipset, Number_of_memory_slots, Memory_speed_range, Wattage, Depth, Height, Width) VALUES
-- (11, 'Z490', 4, 3200, 50, 30, 30, 30),
-- (12, 'X570', 4, 3600, 60, 32, 32, 32),
-- (13, 'B550', 2, 3200, 45, 28, 28, 28),
-- (14, 'Z390', 4, 3000, 55, 31, 31, 31),
-- (15, 'H370', 2, 2666, 40, 27, 27, 27);

-- -- Insert RAM_STICK data
-- INSERT INTO RAM_STICK (ID, Frequency, Wattage, Capacity, Generation, Depth, Height, Width) VALUES
-- (16, 3200, 15, 16, 'DDR4', 10, 10, 10),
-- (17, 3600, 18, 32, 'DDR4', 11, 11, 11),
-- (18, 3000, 12, 8, 'DDR3', 9, 9, 9),
-- (19, 2666, 10, 4, 'DDR3', 8, 8, 8),
-- (20, 2133, 8, 2, 'DDR2', 7, 7, 7);

-- -- Insert SSD data
-- INSERT INTO SSD (ID, Wattage, Capacity) VALUES
-- (21, 5, 500),
-- (22, 7, 1000),
-- (23, 6, 250);









-- Insert CPU products
INSERT INTO PRODUCT (ID, Category, Image, Current_price, Stock_count, Brand, Model, Image_address)
VALUES 
(1, 'CPU', NULL, 350, 50, 'Intel', 'i7-12700K', 'exploreAsset/images/cpuIntelI7-12700K.jpg'),
(2, 'CPU', NULL, 450, 30, 'AMD', 'Ryzen 9 5900X', 'exploreAsset/images/cpuAmdRyzen-9-5900X.jpg');

-- -- Insert GPU products
-- INSERT INTO PRODUCT (ID, Category, Image, Current_price, Stock_count, Brand, Model)
-- VALUES 
-- (3, 'GPU', LOAD_FILE('/images/gpu1.jpg'), 600, 40, 'NVIDIA', 'RTX 3080'),
-- (4, 'GPU', LOAD_FILE('/images/gpu2.jpg'), 800, 20, 'AMD', 'RX 6800 XT');

-- -- Insert RAM products
INSERT INTO PRODUCT (ID, Category, Image, Current_price, Stock_count, Brand, Model, Image_address)
VALUES 
(5, 'RAM', NULL, 120, 100, 'Corsair', 'Vengeance LPX 16GB', 'exploreAsset/images/115107119.jpg'),
(6, 'RAM', NULL, 150, 80, 'G.Skill', 'Trident Z RGB 32GB', 'exploreAsset/images/280x280.jpg');

-- Insert Storage products (HDD/SSD)
INSERT INTO PRODUCT (ID, Category, Image, Current_price, Stock_count, Brand, Model, Image_address)
VALUES 
(7, 'Storage', NULL, 100, 120, 'Samsung', '970 EVO Plus 1TB', 'exploreAsset/images/1c69dd1d.jpg'),
(8, 'Storage', NULL, 50, 150, 'Seagate', 'BarraCuda 2TB', 'exploreAsset/images/1375002.jpg');

-- -- Insert Motherboard products
-- INSERT INTO PRODUCT (ID, Category, Image, Current_price, Stock_count, Brand, Model)
-- VALUES 
-- (9, 'Motherboard', LOAD_FILE('images/mobo1.jpg'), 200, 60, 'ASUS', 'ROG Strix B550-E Gaming'),
-- (10, 'Motherboard', LOAD_FILE('images/mobo2.jpg'), 180, 70, 'MSI', 'MAG B550 TOMAHAWK WIFI');

-- -- Insert Power Supply products
-- INSERT INTO PRODUCT (ID, Category, Image, Current_price, Stock_count, Brand, Model)
-- VALUES 
-- (11, 'Power Supply', LOAD_FILE('images/psu1.jpg'), 130, 90, 'Corsair', 'RM750x'),
-- (12, 'Power Supply', LOAD_FILE('images/psu2.jpg'), 110, 100, 'EVGA', 'SuperNOVA 650 G5');

-- -- Insert Cooling products
-- INSERT INTO PRODUCT (ID, Category, Image, Current_price, Stock_count, Brand, Model)
-- VALUES 
-- (13, 'Cooling', LOAD_FILE('/images/cooler1.jpg'), 70, 80, 'Noctua', 'NH-U12S TR4-SP3'),
-- (14, 'Cooling', LOAD_FILE('/images/cooler2.jpg'), 90, 60, 'Cooler Master', 'Hyper 212 Black Edition');

-- -- Insert Case products
-- INSERT INTO PRODUCT (ID, Category, Image, Current_price, Stock_count, Brand, Model)
-- VALUES 
-- (15, 'Case', LOAD_FILE('/images/case1.jpg'), 100, 50, 'Lian Li', 'PC-O11 Dynamic XL'),
-- (16, 'Case', LOAD_FILE('/images/case2.jpg'), 80, 70, 'Fractal Design', 'Meshify C');

-- -- Insert Monitor products
-- INSERT INTO PRODUCT (ID, Category, Image, Current_price, Stock_count, Brand, Model)
-- VALUES 
-- (17, 'Monitor', LOAD_FILE('images/monitor1.jpg'), 250, 40, 'Dell', 'S2721DGF'),
-- (18, 'Monitor', LOAD_FILE('images/monitor2.jpg'), 300, 30, 'LG', 'UltraGear 27GL850');

-- -- Insert Keyboard products
-- INSERT INTO PRODUCT (ID, Category, Image, Current_price, Stock_count, Brand, Model)
-- VALUES 
-- (19, 'Keyboard', LOAD_FILE('images/keyboard1.jpg'), 150, 60, 'Logitech', 'G915 TKL'),
-- (20, 'Keyboard', LOAD_FILE('images/keyboard2.jpg'), 120, 80, 'Razer', 'BlackWidow V3');